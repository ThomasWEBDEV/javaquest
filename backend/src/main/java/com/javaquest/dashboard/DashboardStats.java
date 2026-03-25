package com.javaquest.dashboard;

/**
 * DTO pour les statistiques du dashboard.
 */
public record DashboardStats(
    int totalXp,
    int currentLevel,
    int xpForNextLevel,
    int currentStreak,
    int longestStreak,
    long exercisesCompleted,
    long exercisesInProgress,
    long totalExerciseAttempts,
    long quizzesPassed,
    long totalQuizAttempts,
    double averageQuizScore,
    long badgesCount
) {}
