package com.javaquest.execution;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests unitaires pour CodeValidator.
 */
class CodeValidatorTest {

    private CodeValidator codeValidator;
    private SandboxConfig sandboxConfig;

    @BeforeEach
    void setUp() {
        sandboxConfig = new SandboxConfig();
        codeValidator = new CodeValidator(sandboxConfig);
    }

    @Test
    void validate_validCode_returnsValid() {
        // When
        ValidationResult result = codeValidator.validate("int x = 10;");

        // Then
        assertTrue(result.valid());
        assertNull(result.message());
    }

    @Test
    void validate_nullCode_returnsInvalid() {
        // When
        ValidationResult result = codeValidator.validate(null);

        // Then
        assertFalse(result.valid());
        assertEquals("Le code ne peut pas etre vide", result.message());
    }

    @Test
    void validate_emptyCode_returnsInvalid() {
        // When
        ValidationResult result = codeValidator.validate("   ");

        // Then
        assertFalse(result.valid());
        assertEquals("Le code ne peut pas etre vide", result.message());
    }

    @Test
    void validate_fileAccess_returnsInvalid() {
        // When
        ValidationResult result = codeValidator.validate("new java.io.File(\"test.txt\");");

        // Then
        assertFalse(result.valid());
        assertTrue(result.message().contains("non autorisees"));
    }

    @Test
    void validate_networkAccess_returnsInvalid() {
        // When
        ValidationResult result = codeValidator.validate("new java.net.Socket(\"localhost\", 80);");

        // Then
        assertFalse(result.valid());
        assertTrue(result.message().contains("non autorisees"));
    }

    @Test
    void validate_runtimeExec_returnsInvalid() {
        // When
        ValidationResult result = codeValidator.validate("Runtime.getRuntime().exec(\"ls\");");

        // Then
        assertFalse(result.valid());
        assertTrue(result.message().contains("non autorisees"));
    }

    @Test
    void validate_systemExit_returnsInvalid() {
        // When
        ValidationResult result = codeValidator.validate("System.exit(0);");

        // Then
        assertFalse(result.valid());
        assertTrue(result.message().contains("non autorisees"));
    }

    @Test
    void validate_threadCreation_returnsInvalid() {
        // When
        ValidationResult result = codeValidator.validate("new Thread(() -> {}).start();");

        // Then
        assertFalse(result.valid());
        assertTrue(result.message().contains("non autorisees"));
    }

    @Test
    void validate_codeTooLong_returnsInvalid() {
        // Given
        sandboxConfig.setMaxCodeLength(10);
        String longCode = "int x = 12345678901234567890;";

        // When
        ValidationResult result = codeValidator.validate(longCode);

        // Then
        assertFalse(result.valid());
        assertTrue(result.message().contains("depasse la limite"));
    }

    @Test
    void validate_safeCode_returnsValid() {
        // When
        String safeCode = """
            int sum = 0;
            for (int i = 0; i < 10; i++) {
                sum += i;
            }
            System.out.println(sum);
            """;
        ValidationResult result = codeValidator.validate(safeCode);

        // Then
        assertTrue(result.valid());
    }
}
