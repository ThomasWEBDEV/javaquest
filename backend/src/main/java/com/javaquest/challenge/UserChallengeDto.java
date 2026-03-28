package com.javaquest.challenge;

import java.time.LocalDateTime;

/**
 * DTO pour la participation a un defi.
 */
public record UserChallengeDto(
    Long challengeId,
    String challengeTitle,
    ChallengeStatus status,
    Integer attemptsCount,
    Integer xpEarned,
    LocalDateTime startedAt,
    LocalDateTime completedAt
) {
    public static UserChallengeDto fromEntity(UserDailyChallenge userChallenge) {
        return new UserChallengeDto(
            userChallenge.getChallenge().getId(),
            userChallenge.getChallenge().getTitle(),
            userChallenge.getStatus(),
            userChallenge.getAttemptsCount(),
            userChallenge.getXpEarned(),
            userChallenge.getStartedAt(),
            userChallenge.getCompletedAt()
        );
    }
}
