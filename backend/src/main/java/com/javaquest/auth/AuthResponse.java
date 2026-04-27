package com.javaquest.auth;

/**
 * DTO pour la réponse d'authentification.
 * Retourne le token JWT et les informations utilisateur.
 */
public record AuthResponse(
    Long userId,
    String token,
    String username,
    String email,
    String message
) {
    /**
     * Crée une réponse de succès.
     */
    public static AuthResponse success(Long userId, String token, String username, String email) {
        return new AuthResponse(userId, token, username, email, "Authentification réussie");
    }
}
