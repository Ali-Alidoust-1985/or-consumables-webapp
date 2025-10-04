package com.mftplus.eesample.controller.exception;

import jakarta.ws.rs.core.Response.Status;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Map;

@NoArgsConstructor
@Getter
@Setter

public class ErrorResponse {
    private Status statusCode;
    private String message;
    private Map<String,String> errors;

    public ErrorResponse(Status statusCode, String message, Map<String,String> errors) {
        this.statusCode = statusCode;
        this.message = message;
        this.errors = errors;
    }
}
