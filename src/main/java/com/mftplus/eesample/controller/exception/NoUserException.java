package com.mftplus.eesample.controller.exception;

public class NoUserException extends Exception{
    public NoUserException() {
        super("No user found");
    }
}
