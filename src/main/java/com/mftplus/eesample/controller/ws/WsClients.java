package com.mftplus.eesample.controller.ws;

import jakarta.websocket.Session;
import java.io.IOException;
import java.util.Set;
import java.util.concurrent.*;

public final class WsClients {
    private WsClients() {}

    // dictationId -> set of browser sessions
    private static final ConcurrentMap<Long, CopyOnWriteArraySet<Session>> MAP = new ConcurrentHashMap<>();

    public static void register(Long dictationId, Session s) {
        if (dictationId == null || s == null) return;
        MAP.computeIfAbsent(dictationId, k -> new CopyOnWriteArraySet<>()).add(s);
    }

    public static void unregister(Session s) {
        if (s == null) return;
        for (Set<Session> set : MAP.values()) set.remove(s);
        // پاکسازی کلیدهای خالی
        MAP.entrySet().removeIf(e -> e.getValue().isEmpty());
    }

    /** ارسال پیام JSON به همه‌ی مرورگرهای عضو این dictationId */
    public static void notifyBrowsers(Long dictationId, String json) {
        if (dictationId == null || json == null) return;
        Set<Session> sessions = MAP.get(dictationId);
        if (sessions == null) return;
        for (Session s : sessions) {
            if (s.isOpen()) {
                try { s.getAsyncRemote().sendText(json); }
                catch (Exception ignore) {}
            }
        }
    }
}
