package com.javaquest.dashboard;

import jakarta.validation.constraints.NotNull;

/**
 * DTO pour enregistrer une tentative d'exercice.
 */
public record ExerciseAttemptRequest(
    String code,

    @NotNull(message = "Le resultat est requis")
    Boolean success
) {}
