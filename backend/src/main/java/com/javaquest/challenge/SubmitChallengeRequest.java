package com.javaquest.challenge;

import jakarta.validation.constraints.NotNull;

/**
 * DTO pour soumettre une tentative de defi.
 */
public record SubmitChallengeRequest(
    String code,

    @NotNull(message = "Le resultat est requis")
    Boolean success
) {}
