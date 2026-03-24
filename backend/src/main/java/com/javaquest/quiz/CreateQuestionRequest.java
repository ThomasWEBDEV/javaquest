package com.javaquest.quiz;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/**
 * DTO pour la creation d'une question.
 */
public record CreateQuestionRequest(
    @NotBlank(message = "Le texte est requis")
    String text,

    @NotNull(message = "Le type est requis")
    QuestionType questionType,

    String codeSnippet,

    String explanation,

    @NotNull(message = "L'ordre est requis")
    Integer orderIndex
) {}
