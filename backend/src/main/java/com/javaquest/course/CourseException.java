package com.javaquest.course;

/**
 * Exception levée lors d'erreurs liées aux cours.
 */
public class CourseException extends RuntimeException {

    public CourseException(String message) {
        super(message);
    }
}
