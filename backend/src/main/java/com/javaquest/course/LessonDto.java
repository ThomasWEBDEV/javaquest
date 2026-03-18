package com.javaquest.course;

import java.time.LocalDateTime;

/**
 * DTO pour la representation d'une lecon.
 */
public record LessonDto(
    Long id,
    Long chapterId,
    String title,
    String slug,
    String content,
    Integer orderIndex,
    Integer xpReward,
    LocalDateTime createdAt
) {
    /**
     * Convertit une entite Lesson en DTO.
     */
    public static LessonDto fromEntity(Lesson lesson) {
        return new LessonDto(
            lesson.getId(),
            lesson.getChapter() != null ? lesson.getChapter().getId() : null,
            lesson.getTitle(),
            lesson.getSlug(),
            lesson.getContent(),
            lesson.getOrderIndex(),
            lesson.getXpReward(),
            lesson.getCreatedAt()
        );
    }
}
