package com.javaquest.dashboard;

import java.time.LocalDateTime;

/**
 * DTO pour la progression d'un exercice.
 */
public record ExerciseProgressDto(
    Long exerciseId,
    String exerciseTitle,
    ProgressStatus status,
    Integer attemptsCount,
    LocalDateTime completedAt
) {
    public static ExerciseProgressDto fromEntity(UserExerciseProgress progress) {
        return new ExerciseProgressDto(
            progress.getExercise().getId(),
            progress.getExercise().getTitle(),
            progress.getStatus(),
            progress.getAttemptsCount(),
            progress.getCompletedAt()
        );
    }
}
