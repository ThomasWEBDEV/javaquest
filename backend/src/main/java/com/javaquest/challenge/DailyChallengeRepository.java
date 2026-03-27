package com.javaquest.challenge;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Repository pour acces aux donnees des defis quotidiens.
 */
@Repository
public interface DailyChallengeRepository extends JpaRepository<DailyChallenge, Long> {

    /**
     * Recherche le defi d'une date donnee.
     */
    Optional<DailyChallenge> findByDate(LocalDate date);

    /**
     * Recupere les defis entre deux dates.
     */
    List<DailyChallenge> findByDateBetweenOrderByDateDesc(LocalDate start, LocalDate end);

    /**
     * Verifie si un defi existe pour une date.
     */
    boolean existsByDate(LocalDate date);
}
