package com.mftplus.eesample.controller.exception;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;

import java.util.Map;
import java.util.stream.Collectors;

@Provider
public class ValidationExceptionMapper implements ExceptionMapper<ConstraintViolationException> {
    @Override
    public Response toResponse(ConstraintViolationException exception) {

        Map<String, String> errors = exception.getConstraintViolations().stream()
                .collect(Collectors.toMap(
                        violation -> {
                            String propertyPath = violation.getPropertyPath().toString();
                            return propertyPath.substring(propertyPath.lastIndexOf('.') + 1); // Get only field name
                        },
                        ConstraintViolation::getMessage,
                        (existing, replacement) -> existing // Handle duplicate keys by keeping the first occurrence
                ));


        ErrorResponse errorResponse = new ErrorResponse(
                Response.Status.BAD_REQUEST,
                "Validation Errors Occurred !",
                errors
        );

        return Response
                .status(Response.Status.BAD_REQUEST)
                .entity(errorResponse)
                .type(MediaType.APPLICATION_JSON)
                .build();
    }
}
