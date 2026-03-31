package com.javaquest.quiz;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository pour acces aux donnees des quiz.
 */
@Repository
public interface QuizRepository extends JpaRepository<Quiz, Long> {

    /**
     * Recupere les quiz d'une lecon.
     */
    List<Quiz> findByLessonId(Long lessonId);

    /**
     * Recupere un quiz avec ses questions.
     */
    @Query("SELECT q FROM Quiz q LEFT JOIN FETCH q.questions WHERE q.id = :id")
    Optional<Quiz> findByIdWithQuestions(@Param("id") Long id);
}
