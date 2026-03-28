package com.javaquest.challenge;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

/**
 * DTO pour la creation d'un defi.
 */
public record CreateChallengeRequest(
    @NotNull(message = "La date est requise")
    LocalDate date,

    @NotBlank(message = "Le titre est requis")
    String title,

    @NotBlank(message = "La description est requise")
    String description,

    String starterCode,

    @NotBlank(message = "Le code solution est requis")
    String solutionCode,

    @NotBlank(message = "Le code de test est requis")
    String testCode,

    String hints,

    Integer xpReward,

    Integer bonusXp
) {}
