package com.javaquest.quiz;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository pour acces aux donnees des reponses.
 */
@Repository
public interface AnswerRepository extends JpaRepository<Answer, Long> {

    /**
     * Recupere les reponses d'une question, triees par ordre.
     */
    List<Answer> findByQuestionIdOrderByOrderIndexAsc(Long questionId);

    /**
     * Recupere les reponses correctes d'une question.
     */
    List<Answer> findByQuestionIdAndIsCorrectTrue(Long questionId);
}
