package com.javaquest.gamification;

/**
 * Types de criteres pour obtenir un badge.
 */
public enum BadgeCriteria {
    XP_TOTAL,           // Total d'XP atteint
    LEVEL_REACHED,      // Niveau atteint
    EXERCISES_COMPLETED,// Nombre d'exercices termines
    CHAPTERS_COMPLETED, // Nombre de chapitres termines
    STREAK_DAYS,        // Jours de streak consecutifs
    QUIZZES_PASSED      // Nombre de quiz reussis
}
