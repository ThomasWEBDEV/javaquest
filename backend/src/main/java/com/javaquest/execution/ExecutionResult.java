package com.javaquest.execution;

/**
 * Resultat de l'execution de code.
 */
public record ExecutionResult(
    boolean success,
    String output,
    long executionTimeMs,
    ExecutionStatus status
) {
    /**
     * Cree un resultat de succes.
     */
    public static ExecutionResult success(String output, long executionTimeMs) {
        return new ExecutionResult(true, output, executionTimeMs, ExecutionStatus.SUCCESS);
    }

    /**
     * Cree un resultat d'erreur.
     */
    public static ExecutionResult error(String output, long executionTimeMs) {
        return new ExecutionResult(false, output, executionTimeMs, ExecutionStatus.ERROR);
    }

    /**
     * Cree un resultat d'erreur sans temps d'execution.
     */
    public static ExecutionResult error(String output) {
        return new ExecutionResult(false, output, 0, ExecutionStatus.ERROR);
    }

    /**
     * Cree un resultat de timeout.
     */
    public static ExecutionResult timeout(String output) {
        return new ExecutionResult(false, output, 0, ExecutionStatus.TIMEOUT);
    }
}
