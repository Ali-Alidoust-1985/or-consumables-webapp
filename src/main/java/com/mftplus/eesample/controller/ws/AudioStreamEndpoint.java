package com.mftplus.eesample.controller.ws;



import com.mftplus.eesample.model.service.asr.AsrGateway;
import com.mftplus.eesample.model.service.asr.MockAsrGateway;


import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import jakarta.json.*;
import java.io.StringReader;
import java.util.Base64;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;


@ServerEndpoint(value = "/ws/dictation")
public class AudioStreamEndpoint {
    private static final AsrGateway ASR = new MockAsrGateway();
    private static final Map<Session, Long> ACTIVE = new ConcurrentHashMap<>();


    @OnOpen public void onOpen(Session s) { }


    @OnMessage public void onMessage(Session s, String msg) {
        try {
            JsonObject n = Json.createReader(new StringReader(msg)).readObject();
            String type = n.getString("type", "");
            switch (type) {
                case "start": {
                    long id = n.getJsonNumber("dictationId").longValue();
                    ACTIVE.put(s, id);
                    break;
                }
                case "audio": {
                    Long id = ACTIVE.get(s);
                    if (id != null) {
                        String b64 = n.getString("base64", null);
                        if (b64 != null) {
                            byte[] pcm = Base64.getDecoder().decode(b64);
                            ASR.sendPcmChunk(id, pcm);
                        }
                    }
                    break;
                }
                case "stop": {
                    Long id = ACTIVE.remove(s);
                    if (id != null) ASR.stopSession(id);
                    s.close();
                    break;
                }
                default: break;
            }
        } catch (Exception ex) {
            try { s.close(new CloseReason(CloseReason.CloseCodes.UNEXPECTED_CONDITION, ex.getMessage())); } catch (Exception ignore) {}
        }
    }


    @OnClose public void onClose(Session s) { ACTIVE.remove(s); }
}