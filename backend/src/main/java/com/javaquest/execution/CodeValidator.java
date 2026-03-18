package com.javaquest.execution;

import org.springframework.stereotype.Component;

import java.util.List;
import java.util.regex.Pattern;

/**
 * Validateur de code pour le sandbox.
 * Bloque les operations dangereuses avant execution.
 */
@Component
public class CodeValidator {

    private final SandboxConfig sandboxConfig;

    // Patterns pour detecter le code dangereux
    private static final List<Pattern> FORBIDDEN_PATTERNS = List.of(
        // Acces fichiers
        Pattern.compile("java\\.io\\.File"),
        Pattern.compile("java\\.nio\\.file"),
        Pattern.compile("FileInputStream"),
        Pattern.compile("FileOutputStream"),
        Pattern.compile("FileReader"),
        Pattern.compile("FileWriter"),
        Pattern.compile("RandomAccessFile"),

        // Acces reseau
        Pattern.compile("java\\.net\\."),
        Pattern.compile("Socket"),
        Pattern.compile("ServerSocket"),
        Pattern.compile("URL"),
        Pattern.compile("HttpClient"),

        // Execution systeme
        Pattern.compile("Runtime\\.getRuntime"),
        Pattern.compile("ProcessBuilder"),
        Pattern.compile("System\\.exit"),

        // Reflexion dangereuse
        Pattern.compile("setAccessible"),
        Pattern.compile("getDeclaredField"),
        Pattern.compile("getDeclaredMethod"),

        // Chargement de classes
        Pattern.compile("ClassLoader"),
        Pattern.compile("Class\\.forName"),

        // Threads (peut causer des problemes)
        Pattern.compile("new\\s+Thread"),
        Pattern.compile("ExecutorService"),
        Pattern.compile("ThreadPoolExecutor"),

        // Securite
        Pattern.compile("SecurityManager"),
        Pattern.compile("System\\.setProperty"),
        Pattern.compile("System\\.getenv")
    );

    public CodeValidator(SandboxConfig sandboxConfig) {
        this.sandboxConfig = sandboxConfig;
    }

    /**
     * Valide le code avant execution.
     *
     * @param code Le code a valider
     * @return Le resultat de validation
     */
    public ValidationResult validate(String code) {
        if (code == null || code.isBlank()) {
            return ValidationResult.invalid("Le code ne peut pas etre vide");
        }

        if (code.length() > sandboxConfig.getMaxCodeLength()) {
            return ValidationResult.invalid(
                "Le code depasse la limite de " + sandboxConfig.getMaxCodeLength() + " caracteres"
            );
        }

        // Verifie les patterns interdits
        for (Pattern pattern : FORBIDDEN_PATTERNS) {
            if (pattern.matcher(code).find()) {
                return ValidationResult.invalid(
                    "Code interdit detecte : utilisation de fonctionnalites non autorisees"
                );
            }
        }

        return ValidationResult.valid();
    }
}
