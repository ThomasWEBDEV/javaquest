package com.javaquest.quiz;

import java.util.List;

/**
 * DTO pour le resultat d'un quiz.
 */
public record QuizResultDto(
    Long quizId,
    int totalQuestions,
    int correctAnswers,
    int score,
    boolean passed,
    int xpEarned,
    List<QuestionResultDto> questionResults
) {}
