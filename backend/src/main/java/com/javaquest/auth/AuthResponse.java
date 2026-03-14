package com.javaquest.auth;

/**
 * DTO pour la réponse d'authentification.
 * Retourne le token JWT et les informations utilisateur.
 */
public record AuthResponse(
    String token,
    String username,
    String email,
    String message
) {
    /**
     * Crée une réponse de succès.
     */
    public static AuthResponse success(String token, String username, String email) {
        return new AuthResponse(token, username, email, "Authentification réussie");
    }
}
