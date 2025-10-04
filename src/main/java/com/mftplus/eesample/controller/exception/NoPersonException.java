package com.mftplus.eesample.controller.exception;

public class NoPersonException extends Exception{
    public NoPersonException() {
        super("No person found");
    }
}
