package com.javaquest.course;

import java.time.LocalDateTime;
import java.util.List;

/**
 * DTO pour la representation d'un chapitre.
 */
public record ChapterDto(
    Long id,
    String title,
    String slug,
    String description,
    Integer orderIndex,
    Integer xpReward,
    Boolean isPublished,
    Integer lessonCount,
    LocalDateTime createdAt
) {
    /**
     * Convertit une entite Chapter en DTO.
     */
    public static ChapterDto fromEntity(Chapter chapter) {
        return new ChapterDto(
            chapter.getId(),
            chapter.getTitle(),
            chapter.getSlug(),
            chapter.getDescription(),
            chapter.getOrderIndex(),
            chapter.getXpReward(),
            chapter.getIsPublished(),
            chapter.getLessons() != null ? chapter.getLessons().size() : 0,
            chapter.getCreatedAt()
        );
    }
}
