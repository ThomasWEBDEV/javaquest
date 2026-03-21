package com.javaquest.exercise;

/**
 * DTO pour la mise a jour d'un exercice.
 */
public record UpdateExerciseRequest(
    String title,
    String description,
    String starterCode,
    String solutionCode,
    String testCode,
    String hints,
    Difficulty difficulty,
    Integer xpReward
) {}
