package com.javaquest.exercise;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository pour acces aux donnees des exercices.
 */
@Repository
public interface ExerciseRepository extends JpaRepository<Exercise, Long> {

    /**
     * Recupere tous les exercices d'une lecon, tries par ordre.
     */
    List<Exercise> findByLessonIdOrderByOrderIndexAsc(Long lessonId);

    /**
     * Recupere les exercices par difficulte.
     */
    List<Exercise> findByDifficulty(Difficulty difficulty);

    /**
     * Compte le nombre d'exercices dans une lecon.
     */
    long countByLessonId(Long lessonId);
}
