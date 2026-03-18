package com.javaquest.execution;

/**
 * Resultat de la validation du code.
 */
public record ValidationResult(
    boolean valid,
    String message
) {
    /**
     * Cree un resultat valide.
     */
    public static ValidationResult valid() {
        return new ValidationResult(true, null);
    }

    /**
     * Cree un resultat invalide avec message d'erreur.
     */
    public static ValidationResult invalid(String message) {
        return new ValidationResult(false, message);
    }
}
