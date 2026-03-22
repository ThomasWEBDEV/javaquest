package com.javaquest.gamification;

import java.time.LocalDate;

/**
 * DTO pour la representation de la progression utilisateur.
 */
public record UserProgressDto(
    Long userId,
    Integer totalXp,
    Integer currentLevel,
    Integer xpForNextLevel,
    Integer currentStreak,
    Integer longestStreak,
    LocalDate lastActivityDate
) {
    public static UserProgressDto fromEntity(UserProgress progress) {
        return new UserProgressDto(
            progress.getUser().getId(),
            progress.getTotalXp(),
            progress.getCurrentLevel(),
            progress.getXpForNextLevel(),
            progress.getCurrentStreak(),
            progress.getLongestStreak(),
            progress.getLastActivityDate()
        );
    }
}
