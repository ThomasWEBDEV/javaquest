package com.javaquest.auth;

/**
 * Exception levée lors d'erreurs d'authentification.
 */
public class AuthException extends RuntimeException {

    public AuthException(String message) {
        super(message);
    }
}
