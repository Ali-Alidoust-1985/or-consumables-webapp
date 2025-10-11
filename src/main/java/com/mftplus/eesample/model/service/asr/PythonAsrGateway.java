package com.mftplus.eesample.model.service.asr;

import com.mftplus.eesample.controller.ws.WsClients;
import com.mftplus.eesample.model.service.DictationService;
import jakarta.websocket.*;
import java.net.URI;
import java.util.Base64;
import java.util.concurrent.atomic.AtomicBoolean;

/** Gateway: Java → Python (server.py) via WebSocket */
@ClientEndpoint
public class PythonAsrGateway implements AsrGateway {

    private Session session;
    private Long currentId;
    private final DictationService dictService = DictationService.get();
    // قابل تغییر با: -Dasr.ws=ws://HOST:8000/ws/asr
    private static final String ASR_URL = "ws://127.0.0.1:8000/ws/asr"; // مسیر جدید
//    c.setDefaultMaxTextMessageBufferSize(512 * 1024); // بافر بزرگ‌تر

    private final AtomicBoolean doneReceived = new AtomicBoolean(false);

    @OnOpen
    public void onOpen(Session s) {
        System.out.println("ASR Gateway: WS opened");
        try {
            s.setMaxTextMessageBufferSize(256 * 1024);
            s.setMaxBinaryMessageBufferSize(256 * 1024);
            s.setMaxIdleTimeout(60_000);
        } catch (Throwable ignore) {}
    }

    @OnMessage
    public void onMessage(String msg) {
        System.out.println("ASR Gateway <== " + msg);
        try {
            if (msg.contains("\"type\":\"done\"")) {
                doneReceived.set(true);
                // اطلاع به مرورگر که کار تمام است (اختیاری)
                if (currentId != null) {
                    WsClients.notifyBrowsers(currentId, "{\"type\":\"done\"}");
                }
                try { if (session != null && session.isOpen()) session.close(); } catch (Exception ignore) {}
                session = null; currentId = null;
                return;
            }

            // فوراً به مرورگر بازپخش کن
            if (currentId != null) {
                WsClients.notifyBrowsers(currentId, msg);
            }

            // و همچنان ذخیره کن (برای پایایی)
            String text = extractText(msg);
            if (text != null && currentId != null) {
                dictService.addSegment(currentId, text, true, null, null);
                System.out.println("ASR Gateway: segment added for dictation " + currentId + " -> " + text);
            }
        } catch (Exception e) {
            System.err.println("ASR Gateway onMessage parse error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session s, CloseReason r) {
        System.out.println("ASR Gateway: WS closed: " + (r != null ? r.toString() : "(no reason)"));
        session = null;
        currentId = null;
    }

    @OnError
    public void onError(Session s, Throwable t) {
        System.err.println("ASR Gateway error: " + (t != null ? t.getMessage() : "(unknown)"));
        if (t != null) t.printStackTrace();
    }

    @Override
    public void startSession(Long dictationId, String initialPrompt) {
        try {
            // افزایش تایم‌اوت هندشیک (میلی‌ثانیه)
            System.setProperty("org.apache.tomcat.websocket.IO_TIMEOUT_MS", "30000");
            // از پراکسی‌های سیستم استفاده نکن
            System.setProperty("java.net.useSystemProxies", "false");

            WebSocketContainer c = ContainerProvider.getWebSocketContainer();
            c.setDefaultMaxTextMessageBufferSize(256 * 1024);
            c.setDefaultMaxSessionIdleTimeout(10 * 60_000); // 10 دقیقه
            System.out.println("ASR Gateway: connecting to " + ASR_URL + " (dictationId=" + dictationId + ")");

            // --- retry با وقفه کوتاه:
            final int MAX_TRIES = 3;
            int attempt = 0;
            while (true) {
                attempt++;
                try {
                    this.session = c.connectToServer(this, URI.create(ASR_URL));
                    break; // OK
                } catch (jakarta.websocket.DeploymentException de) {
                    if (attempt >= MAX_TRIES) throw de;
                    System.err.println("ASR connect attempt " + attempt + " failed: " + de.getMessage() + " -> retrying…");
                    try { Thread.sleep(400L * attempt); } catch (InterruptedException ignored) {}
                }
            }

            this.currentId = dictationId;
            String startJson = "{\"type\":\"start\",\"dictationId\":"+dictationId+
                    ",\"sampleRate\":16000,\"language\":\"fa\",\"initial_prompt\":"+
                    (initialPrompt==null? "null" : ("\""+ initialPrompt.replace("\"","'") +"\"")) +"}";
            session.getAsyncRemote().sendText(startJson);
            System.out.println("ASR Gateway: start sent.");
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("ASR connect failed: " + e.getMessage(), e);
        }
    }


    @Override
    public void sendPcmChunk(Long dictationId, byte[] pcm16le) {
        // به Python باید JSON+Base64 بفرستیم
        if (session == null || !session.isOpen()) return;
        String b64 = Base64.getEncoder().encodeToString(pcm16le);
        session.getAsyncRemote().sendText("{\"type\":\"audio\",\"base64\":\"" + b64 + "\"}");
    }

    @Override
    public void stopSession(Long dictationId) {
        try {
            if (session != null && session.isOpen()) {
                // فقط stop بفرست—نبند! منتظر "done" بمان تا onMessage ببندد.
                session.getAsyncRemote().sendText("{\"type\":\"stop\"}");
            }
        } catch (Exception ignore) {}
        // connection را اینجا نبند—بگذار "done" برسد
    }

    // پارس خیلی ساده؛ در نسخهٔ نهایی JSON-P/Jackson بهتر است
    private static String extractText(String json) {
        int i = json.indexOf("\"text\"");
        if (i < 0) return null;
        i = json.indexOf(':', i) + 1;
        while (i < json.length() && json.charAt(i) == ' ') i++;
        if (i < json.length() && json.charAt(i) == '\"') {
            int j = json.indexOf('\"', i + 1);
            if (j > i) return json.substring(i + 1, j);
        }
        return null;
    }
}
