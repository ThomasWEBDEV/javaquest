package com.javaquest.dashboard;

import java.time.LocalDateTime;

/**
 * DTO pour une tentative de quiz.
 */
public record QuizAttemptDto(
    Long quizId,
    String quizTitle,
    Integer score,
    Integer correctAnswers,
    Integer totalQuestions,
    Boolean passed,
    Integer xpEarned,
    LocalDateTime attemptedAt
) {
    public static QuizAttemptDto fromEntity(UserQuizAttempt attempt) {
        return new QuizAttemptDto(
            attempt.getQuiz().getId(),
            attempt.getQuiz().getTitle(),
            attempt.getScore(),
            attempt.getCorrectAnswers(),
            attempt.getTotalQuestions(),
            attempt.getPassed(),
            attempt.getXpEarned(),
            attempt.getAttemptedAt()
        );
    }
}
