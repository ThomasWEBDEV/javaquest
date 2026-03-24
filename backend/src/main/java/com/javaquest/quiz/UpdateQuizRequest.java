package com.javaquest.quiz;

/**
 * DTO pour la mise a jour d'un quiz.
 */
public record UpdateQuizRequest(
    String title,
    String description,
    Integer timeLimitSeconds,
    Integer passingScore,
    Integer xpReward
) {}
