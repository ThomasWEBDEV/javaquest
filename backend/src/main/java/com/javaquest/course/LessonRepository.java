package com.javaquest.course;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository pour accès aux données des leçons.
 */
@Repository
public interface LessonRepository extends JpaRepository<Lesson, Long> {

    /**
     * Récupère toutes les leçons d'un chapitre, triées par ordre.
     */
    List<Lesson> findByChapterIdOrderByOrderIndexAsc(Long chapterId);

    /**
     * Recherche une leçon par chapitre et slug.
     */
    Optional<Lesson> findByChapterIdAndSlug(Long chapterId, String slug);

    /**
     * Vérifie si un slug existe déjà dans un chapitre.
     */
    boolean existsByChapterIdAndSlug(Long chapterId, String slug);
}
