package com.javaquest.gamification;

import java.util.List;

/**
 * Resultat d'un gain d'XP.
 */
public record XpGainResult(
    int xpGained,
    int totalXp,
    int currentLevel,
    boolean leveledUp,
    int currentStreak,
    List<Badge> newBadges
) {}
