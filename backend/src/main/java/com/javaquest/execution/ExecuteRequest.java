package com.javaquest.execution;

import jakarta.validation.constraints.NotBlank;

/**
 * DTO pour la requete d'execution de code.
 */
public record ExecuteRequest(
    @NotBlank(message = "Le code est requis")
    String code,
    Long exerciseId
) {}
