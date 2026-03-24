package com.javaquest.quiz;

import jakarta.validation.constraints.NotBlank;

/**
 * DTO pour la creation d'un quiz.
 */
public record CreateQuizRequest(
    @NotBlank(message = "Le titre est requis")
    String title,

    String description,

    Long lessonId,

    Integer timeLimitSeconds,

    Integer passingScore,

    Integer xpReward
) {}
