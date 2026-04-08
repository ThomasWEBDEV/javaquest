package com.javaquest.dashboard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository pour acces aux donnees de progression des exercices.
 */
@Repository
public interface UserExerciseProgressRepository extends JpaRepository<UserExerciseProgress, Long> {

    /**
     * Recherche la progression d'un utilisateur sur un exercice.
     */
    Optional<UserExerciseProgress> findByUserIdAndExerciseId(Long userId, Long exerciseId);

    /**
     * Recupere toutes les progressions d'un utilisateur.
     */
    List<UserExerciseProgress> findByUserId(Long userId);

    /**
     * Compte les exercices completes par un utilisateur.
     */
    long countByUserIdAndStatus(Long userId, ProgressStatus status);

    /**
     * Recupere les exercices en cours d'un utilisateur.
     */
    List<UserExerciseProgress> findByUserIdAndStatus(Long userId, ProgressStatus status);

    /**
     * Compte le total des tentatives d'un utilisateur.
     */
    @Query("SELECT COALESCE(SUM(p.attemptsCount), 0) FROM UserExerciseProgress p WHERE p.user.id = :userId")
    long sumAttemptsByUserId(Long userId);

    /**
     * Compte le nombre de chapitres distincts ou l'utilisateur a complete au moins un exercice.
     */
    @Query("SELECT COUNT(DISTINCT ep.exercise.lesson.chapter.id) FROM UserExerciseProgress ep WHERE ep.user.id = :userId AND ep.status = :status")
    long countDistinctCompletedChapters(Long userId, ProgressStatus status);
}
