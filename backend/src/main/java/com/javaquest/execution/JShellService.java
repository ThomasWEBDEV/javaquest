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

    private static final int TIMEOUT_SECONDS = 10;
    private static final int MAX_OUTPUT_LENGTH = 10000;
    // System.out est global : on synchronise pour eviter les interferences entre requetes concurrentes
    private static final Object SYSTEM_OUT_LOCK = new Object();

    public ExecutionResult execute(String code, String testCode) {
        ExecutorService executor = Executors.newSingleThreadExecutor();

        try {
            Future<ExecutionResult> future = executor.submit(() -> executeCode(code, testCode));
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

    private ExecutionResult executeCode(String code, String testCode) {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        PrintStream printStream = new PrintStream(outputStream);
        long startTime = System.currentTimeMillis();

        synchronized (SYSTEM_OUT_LOCK) {
            PrintStream originalOut = System.out;
            PrintStream originalErr = System.err;
            System.setOut(printStream);
            System.setErr(printStream);

            try (JShell jshell = JShell.builder()
                    .out(printStream)
                    .err(printStream)
                    .build()) {

                StringBuilder errorBuilder = new StringBuilder();
                boolean hasErrors = false;

                // Evalue le code utilisateur (definition de classe)
                List<SnippetEvent> events = jshell.eval(code);
                for (SnippetEvent event : events) {
                    List<Diag> diagnostics = jshell.diagnostics(event.snippet()).toList();
                    for (Diag diag : diagnostics) {
                        if (diag.isError()) {
                            hasErrors = true;
                            errorBuilder.append("Erreur ligne ")
                                    .append(diag.getStartPosition())
                                    .append(": ")
                                    .append(diag.getMessage(null))
                                    .append("\n");
                        }
                    }
                    if (event.exception() != null) {
                        hasErrors = true;
                        errorBuilder.append("Exception: ")
                                .append(event.exception().getMessage())
                                .append("\n");
                    }
                }

                if (!hasErrors) {
                    // JShell ne execute pas main() automatiquement — on l'appelle explicitement.
                    // Les erreurs de compilation ici (ex: classe Main absente) sont ignorees silencieusement.
                    List<SnippetEvent> mainEvents = jshell.eval("Main.main(new String[]{});");
                    for (SnippetEvent event : mainEvents) {
                        if (event.exception() != null) {
                            hasErrors = true;
                            errorBuilder.append("Exception: ")
                                    .append(event.exception().getMessage())
                                    .append("\n");
                        }
                    }
                }

                printStream.flush();
                String consoleOutput = outputStream.toString().trim();
                long executionTime = System.currentTimeMillis() - startTime;

                if (hasErrors) {
                    String errorMsg = errorBuilder.toString().trim();
                    return ExecutionResult.error(truncateOutput(errorMsg.isEmpty() ? consoleOutput : errorMsg), executionTime);
                }

                String output = truncateOutput(consoleOutput);

                // Verifie le testCode si fourni (ex: output.contains("Hello"))
                if (testCode != null && !testCode.isBlank()) {
                    boolean testPassed = evaluateTestCode(jshell, output, testCode);
                    if (!testPassed) {
                        return ExecutionResult.error(output, executionTime);
                    }
                }

                return ExecutionResult.success(output, executionTime);

            } catch (Exception e) {
                long executionTime = System.currentTimeMillis() - startTime;
                return ExecutionResult.error("Erreur : " + e.getMessage(), executionTime);
            } finally {
                System.setOut(originalOut);
                System.setErr(originalErr);
            }
        }
    }

    /**
     * Evalue le testCode (ex: output.contains("X") && output.contains("Y"))
     * en injectant la variable output dans JShell.
     */
    private boolean evaluateTestCode(JShell jshell, String actualOutput, String testCode) {
        try {
            String escaped = actualOutput
                    .replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");

            jshell.eval("String output = \"" + escaped + "\";");
            List<SnippetEvent> testEvents = jshell.eval(testCode + ";");

            for (SnippetEvent event : testEvents) {
                if (event.exception() != null) return false;
                if ("true".equals(event.value())) return true;
                if ("false".equals(event.value())) return false;
            }
            return false;
        } catch (Exception e) {
            return false;
        }
    }

    private String truncateOutput(String output) {
        if (output.length() > MAX_OUTPUT_LENGTH) {
            return output.substring(0, MAX_OUTPUT_LENGTH) + "\n... (sortie tronquee)";
        }
        return output;
    }
}
