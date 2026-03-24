package com.javaquest.quiz;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/**
 * DTO pour la creation d'une reponse.
 */
public record CreateAnswerRequest(
    @NotBlank(message = "Le texte est requis")
    String text,

    @NotNull(message = "isCorrect est requis")
    Boolean isCorrect,

    @NotNull(message = "L'ordre est requis")
    Integer orderIndex
) {}
