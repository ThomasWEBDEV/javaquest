package com.javaquest.dashboard;

import com.javaquest.gamification.XpGainResult;

/**
 * Resultat d'une tentative d'exercice, incluant la progression et l'XP gagne.
 */
public record ExerciseAttemptResult(
    UserExerciseProgress progress,
    XpGainResult xpGain
) {}
