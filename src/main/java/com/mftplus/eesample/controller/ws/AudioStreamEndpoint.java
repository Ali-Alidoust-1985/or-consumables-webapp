package com.mftplus.eesample.controller.ws;

import com.mftplus.eesample.model.service.asr.AsrGateway;
import com.mftplus.eesample.model.service.asr.PythonAsrGateway;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import jakarta.json.*;
import java.io.StringReader;
import java.nio.ByteBuffer;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import com.mftplus.eesample.controller.ws.WsClients;

@ServerEndpoint(value = "/ws/dictation")
public class AudioStreamEndpoint {

    private static final AsrGateway ASR = new PythonAsrGateway();
    private static final Map<Session, Long> ACTIVE = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session s) {
        try {
            s.setMaxTextMessageBufferSize(64 * 1024);
            s.setMaxBinaryMessageBufferSize(512 * 1024);
            s.setMaxIdleTimeout(60_000);
        } catch (Throwable ignore) {}
        System.out.println("[WS] client connected (browser→Java)");
    }

    @OnMessage
    public void onText(Session s, String msg) {
        try {
            JsonObject n = Json.createReader(new StringReader(msg)).readObject();
            String type = n.getString("type", "");
            switch (type) {
                case "start": {
                    long id = n.getJsonNumber("dictationId").longValue();
                    String initialPrompt = (n.containsKey("initialPrompt") && !n.isNull("initialPrompt"))
                            ? n.getString("initialPrompt") : null;
                    ACTIVE.put(s, id);
                    WsClients.register(id, s);                 // ← ثبت سشن مرورگر برای فوروارد
                    System.out.println("[WS] start received for dictation " + id);
                    s.setMaxIdleTimeout(60_000);
                    ASR.startSession(id, initialPrompt);       // Java → Python
                    break;
                }
                case "stop": {
                    Long id = ACTIVE.remove(s);
                    if (id != null) ASR.stopSession(id);
                    try { s.close(); } catch (Exception ignore) {}
                    System.out.println("[WS] stop received (browser→Java)");
                    break;
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            try { s.close(new CloseReason(CloseReason.CloseCodes.UNEXPECTED_CONDITION, ex.getMessage())); } catch (Exception ignore) {}
        }
    }

    @OnMessage
    public void onBinary(Session s, ByteBuffer buf) {
        try {
            Long id = ACTIVE.get(s);
            if (id == null || buf == null) return;
            byte[] pcm = new byte[buf.remaining()];
            buf.get(pcm);
            if (Math.random() < 0.02) System.out.println("[WS] audio chunk bytes=" + pcm.length);
            ASR.sendPcmChunk(id, pcm);
        } catch (Exception ex) {
            ex.printStackTrace();
            try { s.close(new CloseReason(CloseReason.CloseCodes.UNEXPECTED_CONDITION, ex.getMessage())); } catch (Exception ignore) {}
        }
    }

    @OnClose
    public void onClose(Session s) {
        ACTIVE.remove(s);
        WsClients.unregister(s);            // ← حذف از رجیستری
        System.out.println("[WS] client closed (browser→Java)");
    }

    @OnError
    public void onError(Session s, Throwable t) {
        System.err.println("[WS] error: " + (t != null ? t.getMessage() : "(unknown)"));
        if (t != null) t.printStackTrace();
    }
}