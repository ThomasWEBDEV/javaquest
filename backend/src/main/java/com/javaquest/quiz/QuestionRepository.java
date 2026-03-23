package com.javaquest.quiz;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository pour acces aux donnees des questions.
 */
@Repository
public interface QuestionRepository extends JpaRepository<Question, Long> {

    /**
     * Recupere les questions d'un quiz, triees par ordre.
     */
    List<Question> findByQuizIdOrderByOrderIndexAsc(Long quizId);

    /**
     * Compte le nombre de questions dans un quiz.
     */
    long countByQuizId(Long quizId);
}
