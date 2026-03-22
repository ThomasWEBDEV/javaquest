package com.javaquest.gamification;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository pour acces aux donnees des badges.
 */
@Repository
public interface BadgeRepository extends JpaRepository<Badge, Long> {

    /**
     * Recherche un badge par son nom.
     */
    Optional<Badge> findByName(String name);

    /**
     * Recherche les badges par type de critere.
     */
    List<Badge> findByCriteriaType(BadgeCriteria criteriaType);
}
