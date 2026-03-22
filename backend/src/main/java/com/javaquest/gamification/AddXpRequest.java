package com.javaquest.gamification;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

/**
 * DTO pour ajouter de l'XP.
 */
public record AddXpRequest(
    @NotNull(message = "L'XP est requis")
    @Min(value = 1, message = "L'XP doit etre positif")
    Integer xp,

    String reason
) {}
