package com.javaquest.gamification;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository pour acces aux badges des utilisateurs.
 */
@Repository
public interface UserBadgeRepository extends JpaRepository<UserBadge, Long> {

    /**
     * Recupere tous les badges d'un utilisateur.
     */
    List<UserBadge> findByUserId(Long userId);

    /**
     * Verifie si un utilisateur possede un badge.
     */
    boolean existsByUserIdAndBadgeId(Long userId, Long badgeId);

    /**
     * Compte le nombre de badges d'un utilisateur.
     */
    long countByUserId(Long userId);
}
