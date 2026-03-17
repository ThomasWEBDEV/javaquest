package com.javaquest.course;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository pour accès aux données des chapitres.
 */
@Repository
public interface ChapterRepository extends JpaRepository<Chapter, Long> {

    /**
     * Recherche un chapitre par son slug.
     */
    Optional<Chapter> findBySlug(String slug);

    /**
     * Vérifie si un slug existe déjà.
     */
    boolean existsBySlug(String slug);

    /**
     * Récupère tous les chapitres publiés, triés par ordre.
     */
    List<Chapter> findByIsPublishedTrueOrderByOrderIndexAsc();

    /**
     * Récupère tous les chapitres triés par ordre.
     */
    List<Chapter> findAllByOrderByOrderIndexAsc();
}
