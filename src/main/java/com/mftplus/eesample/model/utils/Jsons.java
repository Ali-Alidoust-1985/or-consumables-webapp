package com.mftplus.eesample.model.utils;

import jakarta.json.bind.Jsonb;
import jakarta.json.bind.JsonbBuilder;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;

public final class Jsons {
    private static final Jsonb JSONB = JsonbBuilder.create();
    private Jsons(){}

    public static <T> T readBody(HttpServletRequest req, Class<T> type) throws IOException {
        try (var r = new BufferedReader(new InputStreamReader(req.getInputStream(), req.getCharacterEncoding()==null?"UTF-8":req.getCharacterEncoding()))) {
            StringBuilder sb = new StringBuilder(); String line;
            while((line=r.readLine())!=null) sb.append(line);
            if (sb.length()==0) return null;
            return JSONB.fromJson(sb.toString(), type);
        }
    }
    public static void write(HttpServletResponse resp, Object obj) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");
        try (var w = new OutputStreamWriter(resp.getOutputStream(), "UTF-8")) {
            JSONB.toJson(obj, w);
        }
    }
}
