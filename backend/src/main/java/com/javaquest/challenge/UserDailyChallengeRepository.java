package com.javaquest.challenge;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository pour acces aux participations aux defis quotidiens.
 */
@Repository
public interface UserDailyChallengeRepository extends JpaRepository<UserDailyChallenge, Long> {

    /**
     * Recherche la participation d'un utilisateur a un defi.
     */
    Optional<UserDailyChallenge> findByUserIdAndChallengeId(Long userId, Long challengeId);

    /**
     * Recupere toutes les participations d'un utilisateur.
     */
    List<UserDailyChallenge> findByUserIdOrderByStartedAtDesc(Long userId);

    /**
     * Compte les defis completes par un utilisateur.
     */
    long countByUserIdAndStatus(Long userId, ChallengeStatus status);

    /**
     * Recupere les defis completes consecutifs (pour calcul streak).
     */
    @Query("SELECT u FROM UserDailyChallenge u WHERE u.user.id = :userId AND u.status = 'COMPLETED' ORDER BY u.challenge.date DESC")
    List<UserDailyChallenge> findCompletedByUserIdOrderByDateDesc(Long userId);

    /**
     * Somme des XP gagnes sur les defis.
     */
    @Query("SELECT COALESCE(SUM(u.xpEarned), 0) FROM UserDailyChallenge u WHERE u.user.id = :userId")
    long sumXpEarnedByUserId(Long userId);
}
