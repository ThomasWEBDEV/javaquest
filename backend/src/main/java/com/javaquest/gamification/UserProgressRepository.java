package com.javaquest.gamification;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Repository pour acces aux donnees de progression utilisateur.
 */
@Repository
public interface UserProgressRepository extends JpaRepository<UserProgress, Long> {

    /**
     * Recherche la progression par utilisateur.
     */
    Optional<UserProgress> findByUserId(Long userId);

    /**
     * Verifie si une progression existe pour un utilisateur.
     */
    boolean existsByUserId(Long userId);
}
