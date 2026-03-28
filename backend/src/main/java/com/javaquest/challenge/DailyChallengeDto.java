package com.javaquest.challenge;

import com.javaquest.exercise.Difficulty;
import java.time.LocalDate;

/**
 * DTO pour la representation d'un defi quotidien.
 * Note: solutionCode et testCode ne sont pas exposes.
 */
public record DailyChallengeDto(
    Long id,
    LocalDate date,
    String title,
    String description,
    String starterCode,
    String hints,
    Difficulty difficulty,
    Integer xpReward,
    Integer bonusXp,
    Integer timeLimitMinutes,
    boolean isToday,
    boolean isExpired
) {
    public static DailyChallengeDto fromEntity(DailyChallenge challenge) {
        return new DailyChallengeDto(
            challenge.getId(),
            challenge.getDate(),
            challenge.getTitle(),
            challenge.getDescription(),
            challenge.getStarterCode(),
            challenge.getHints(),
            challenge.getDifficulty(),
            challenge.getXpReward(),
            challenge.getBonusXp(),
            challenge.getTimeLimitMinutes(),
            challenge.isToday(),
            challenge.isExpired()
        );
    }
}
