package com.javaquest.exercise;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/**
 * DTO pour la creation d'un exercice.
 */
public record CreateExerciseRequest(
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

    Difficulty difficulty,

    Integer xpReward,

    @NotNull(message = "L'ordre est requis")
    Integer orderIndex
) {}
