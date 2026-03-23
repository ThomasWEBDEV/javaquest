package com.javaquest.quiz;

/**
 * Exception levee lors d'erreurs liees aux quiz.
 */
public class QuizException extends RuntimeException {

    public QuizException(String message) {
        super(message);
    }
}
