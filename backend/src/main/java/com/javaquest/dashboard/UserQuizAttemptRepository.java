package com.javaquest.dashboard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository pour acces aux donnees des tentatives de quiz.
 */
@Repository
public interface UserQuizAttemptRepository extends JpaRepository<UserQuizAttempt, Long> {

    /**
     * Recupere toutes les tentatives d'un utilisateur.
     */
    List<UserQuizAttempt> findByUserIdOrderByAttemptedAtDesc(Long userId);

    /**
     * Recupere les tentatives d'un utilisateur sur un quiz.
     */
    List<UserQuizAttempt> findByUserIdAndQuizIdOrderByAttemptedAtDesc(Long userId, Long quizId);

    /**
     * Recupere la meilleure tentative d'un utilisateur sur un quiz.
     */
    Optional<UserQuizAttempt> findFirstByUserIdAndQuizIdOrderByScoreDesc(Long userId, Long quizId);

    /**
     * Compte les quiz reussis par un utilisateur.
     */
    long countByUserIdAndPassedTrue(Long userId);

    /**
     * Compte le total des tentatives d'un utilisateur.
     */
    long countByUserId(Long userId);

    /**
     * Calcule le score moyen d'un utilisateur.
     */
    @Query("SELECT COALESCE(AVG(a.score), 0) FROM UserQuizAttempt a WHERE a.user.id = :userId")
    double averageScoreByUserId(Long userId);

    /**
     * Somme des XP gagnes par quiz pour un utilisateur.
     */
    @Query("SELECT COALESCE(SUM(a.xpEarned), 0) FROM UserQuizAttempt a WHERE a.user.id = :userId")
    long sumXpEarnedByUserId(Long userId);

    /**
     * Verifie si un utilisateur a deja reussi un quiz specifique.
     */
    boolean existsByUserIdAndQuizIdAndPassedTrue(Long userId, Long quizId);
}
