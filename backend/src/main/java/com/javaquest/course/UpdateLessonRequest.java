package com.javaquest.course;

import jakarta.validation.constraints.Size;

/**
 * DTO pour la mise a jour d'une lecon.
 */
public record UpdateLessonRequest(
    @Size(max = 100, message = "Le titre ne doit pas depasser 100 caracteres")
    String title,

    String content,

    Integer xpReward
) {}
