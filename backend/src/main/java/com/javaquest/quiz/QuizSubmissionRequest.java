package com.javaquest.quiz;

import jakarta.validation.constraints.NotEmpty;
import java.util.List;
import java.util.Map;

/**
 * DTO pour la soumission d'un quiz.
 * Map: questionId -> liste des answerIds selectionnes
 */
public record QuizSubmissionRequest(
    @NotEmpty(message = "Les reponses sont requises")
    Map<Long, List<Long>> answers
) {}
