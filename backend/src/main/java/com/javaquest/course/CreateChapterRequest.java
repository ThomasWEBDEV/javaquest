package com.javaquest.course;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * DTO pour la creation d'un chapitre.
 */
public record CreateChapterRequest(
    @NotBlank(message = "Le titre est requis")
    @Size(max = 100, message = "Le titre ne doit pas depasser 100 caracteres")
    String title,

    @NotBlank(message = "Le slug est requis")
    @Size(max = 100, message = "Le slug ne doit pas depasser 100 caracteres")
    String slug,

    String description,

    @NotNull(message = "L'ordre est requis")
    Integer orderIndex
) {}
