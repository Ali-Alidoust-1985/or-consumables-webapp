package com.mftplus.eesample.controller.rest;


import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;


@ApplicationPath("/api")
public class RestApp extends Application {
// TomEE (Apache CXF) منابع @Path را به‌صورت خودکار پیدا می‌کند
}
