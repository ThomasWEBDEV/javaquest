package com.javaquest.challenge;

/**
 * Resultat d'une soumission de defi.
 */
public record ChallengeResult(
    boolean success,
    int xpEarned,
    boolean completed,
    String message
) {}
