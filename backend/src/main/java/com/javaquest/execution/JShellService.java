package com.javaquest.execution;

import jdk.jshell.JShell;
import jdk.jshell.SnippetEvent;
import jdk.jshell.Diag;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.util.List;
import java.util.concurrent.*;

/**
 * Service d'execution de code Java via JShell.
 * Execute le code utilisateur de maniere securisee avec timeout.
 */
@Service
public class JShellService {

    private static final int TIMEOUT_SECONDS = 5;
    private static final int MAX_OUTPUT_LENGTH = 10000;

    /**
     * Execute du code Java et retourne le resultat.
     *
     * @param code Le code Java a executer
     * @return Le resultat de l'execution
     */
    public ExecutionResult execute(String code) {
        ExecutorService executor = Executors.newSingleThreadExecutor();

        try {
            Future<ExecutionResult> future = executor.submit(() -> executeCode(code));
            return future.get(TIMEOUT_SECONDS, TimeUnit.SECONDS);

        } catch (TimeoutException e) {
            return ExecutionResult.timeout("Execution interrompue : depassement du delai de " + TIMEOUT_SECONDS + " secondes");

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return ExecutionResult.error("Execution interrompue");

        } catch (ExecutionException e) {
            return ExecutionResult.error("Erreur d'execution : " + e.getCause().getMessage());

        } finally {
            executor.shutdownNow();
        }
    }

    /**
     * Execute le code dans JShell.
     */
    private ExecutionResult executeCode(String code) {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        PrintStream printStream = new PrintStream(outputStream);

        long startTime = System.currentTimeMillis();

        try (JShell jshell = JShell.builder()
                .out(printStream)
                .err(printStream)
                .build()) {

            StringBuilder resultBuilder = new StringBuilder();
            boolean hasErrors = false;

            // Execute le code
            List<SnippetEvent> events = jshell.eval(code);

            for (SnippetEvent event : events) {
                // Verifie les erreurs de compilation
                List<Diag> diagnostics = jshell.diagnostics(event.snippet()).toList();
                for (Diag diag : diagnostics) {
                    if (diag.isError()) {
                        hasErrors = true;
                        resultBuilder.append("Erreur ligne ")
                                .append(diag.getStartPosition())
                                .append(": ")
                                .append(diag.getMessage(null))
                                .append("\n");
                    }
                }

                // Recupere la valeur de retour si presente
                if (event.value() != null && !event.value().isEmpty()) {
                    resultBuilder.append(event.value()).append("\n");
                }

                // Verifie les exceptions
                if (event.exception() != null) {
                    hasErrors = true;
                    resultBuilder.append("Exception: ")
                            .append(event.exception().getMessage())
                            .append("\n");
                }
            }

            // Ajoute la sortie standard
            String consoleOutput = outputStream.toString();
            if (!consoleOutput.isEmpty()) {
                resultBuilder.append(consoleOutput);
            }

            long executionTime = System.currentTimeMillis() - startTime;
            String output = truncateOutput(resultBuilder.toString());

            if (hasErrors) {
                return ExecutionResult.error(output, executionTime);
            }

            return ExecutionResult.success(output, executionTime);

        } catch (Exception e) {
            long executionTime = System.currentTimeMillis() - startTime;
            return ExecutionResult.error("Erreur : " + e.getMessage(), executionTime);
        }
    }

    /**
     * Tronque la sortie si elle depasse la limite.
     */
    private String truncateOutput(String output) {
        if (output.length() > MAX_OUTPUT_LENGTH) {
            return output.substring(0, MAX_OUTPUT_LENGTH) + "\n... (sortie tronquee)";
        }
        return output;
    }
}
