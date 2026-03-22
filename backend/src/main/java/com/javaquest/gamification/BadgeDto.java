package com.javaquest.gamification;

import java.time.LocalDateTime;

/**
 * DTO pour la representation d'un badge.
 */
public record BadgeDto(
    Long id,
    String name,
    String description,
    String iconUrl,
    BadgeCriteria criteriaType,
    Integer criteriaValue,
    LocalDateTime earnedAt
) {
    public static BadgeDto fromEntity(Badge badge) {
        return new BadgeDto(
            badge.getId(),
            badge.getName(),
            badge.getDescription(),
            badge.getIconUrl(),
            badge.getCriteriaType(),
            badge.getCriteriaValue(),
            null
        );
    }

    public static BadgeDto fromUserBadge(UserBadge userBadge) {
        Badge badge = userBadge.getBadge();
        return new BadgeDto(
            badge.getId(),
            badge.getName(),
            badge.getDescription(),
            badge.getIconUrl(),
            badge.getCriteriaType(),
            badge.getCriteriaValue(),
            userBadge.getEarnedAt()
        );
    }
}
