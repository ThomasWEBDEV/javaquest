package com.javaquest.quiz;

import java.util.List;

/**
 * DTO pour le resultat d'une question.
 */
public record QuestionResultDto(
    Long questionId,
    boolean correct,
    List<Long> correctAnswerIds,
    List<Long> selectedAnswerIds,
    String explanation
) {}
