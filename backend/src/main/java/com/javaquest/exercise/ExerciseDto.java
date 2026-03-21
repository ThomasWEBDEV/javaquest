package com.javaquest.exercise;

import java.time.LocalDateTime;

/**
 * DTO pour la representation d'un exercice.
 */
public record ExerciseDto(
    Long id,
    Long lessonId,
    String title,
    String description,
    String starterCode,
    String hints,
    Difficulty difficulty,
    Integer xpReward,
    Integer orderIndex,
    LocalDateTime createdAt
) {
    /**
     * Convertit une entite Exercise en DTO.
     * Note: solutionCode et testCode ne sont pas exposes.
     */
    public static ExerciseDto fromEntity(Exercise exercise) {
        return new ExerciseDto(
            exercise.getId(),
            exercise.getLesson() != null ? exercise.getLesson().getId() : null,
            exercise.getTitle(),
            exercise.getDescription(),
            exercise.getStarterCode(),
            exercise.getHints(),
            exercise.getDifficulty(),
            exercise.getXpReward(),
            exercise.getOrderIndex(),
            exercise.getCreatedAt()
        );
    }
}
