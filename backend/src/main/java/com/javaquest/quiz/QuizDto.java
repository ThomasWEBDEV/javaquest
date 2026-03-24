package com.javaquest.quiz;

import java.time.LocalDateTime;
import java.util.List;

/**
 * DTO pour la representation d'un quiz.
 */
public record QuizDto(
    Long id,
    Long lessonId,
    String title,
    String description,
    Integer timeLimitSeconds,
    Integer passingScore,
    Integer xpReward,
    Integer questionCount,
    LocalDateTime createdAt
) {
    public static QuizDto fromEntity(Quiz quiz) {
        return new QuizDto(
            quiz.getId(),
            quiz.getLesson() != null ? quiz.getLesson().getId() : null,
            quiz.getTitle(),
            quiz.getDescription(),
            quiz.getTimeLimitSeconds(),
            quiz.getPassingScore(),
            quiz.getXpReward(),
            quiz.getQuestions().size(),
            quiz.getCreatedAt()
        );
    }
}
