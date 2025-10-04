package com.mftplus.eesample.controller.exception;

public class NoRoleException extends Exception{
    public NoRoleException() {
        super("No role found");
    }
}
