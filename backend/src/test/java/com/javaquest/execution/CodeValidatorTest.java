package com.javaquest.execution;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class CodeValidatorTest {

    private CodeValidator codeValidator;
    private SandboxConfig sandboxConfig;

    @BeforeEach
    void setUp() {
        sandboxConfig = new SandboxConfig();
        sandboxConfig.setMaxCodeLength(10000);
        sandboxConfig.setTimeoutSeconds(5);
        sandboxConfig.setMaxOutputLength(5000);
        codeValidator = new CodeValidator(sandboxConfig);
    }

    @Test
    void validate_validCode_returnsValid() {
        String code = "System.out.println(\"Hello World\");";

        ValidationResult result = codeValidator.validate(code);

        assertTrue(result.isValid());
    }

    @Test
    void validate_emptyCode_returnsInvalid() {
        String code = "";

        ValidationResult result = codeValidator.validate(code);

        assertFalse(result.isValid());
        assertNotNull(result.message());
    }

    @Test
    void validate_nullCode_returnsInvalid() {
        ValidationResult result = codeValidator.validate(null);

        assertFalse(result.isValid());
    }

    @Test
    void validate_fileAccess_returnsInvalid() {
        String code = "java.io.File file = new java.io.File(\"test.txt\");";

        ValidationResult result = codeValidator.validate(code);

        assertFalse(result.isValid());
    }

    @Test
    void validate_networkAccess_returnsInvalid() {
        String code = "java.net.Socket socket = new java.net.Socket();";

        ValidationResult result = codeValidator.validate(code);

        assertFalse(result.isValid());
    }

    @Test
    void validate_runtimeExec_returnsInvalid() {
        String code = "Runtime.getRuntime().exec(\"ls\");";

        ValidationResult result = codeValidator.validate(code);

        assertFalse(result.isValid());
    }

    @Test
    void validate_systemExit_returnsInvalid() {
        String code = "System.exit(0);";

        ValidationResult result = codeValidator.validate(code);

        assertFalse(result.isValid());
    }

    @Test
    void validate_reflection_returnsInvalid() {
        String code = "field.setAccessible(true);";

        ValidationResult result = codeValidator.validate(code);

        assertFalse(result.isValid());
    }

    @Test
    void validate_codeTooLong_returnsInvalid() {
        sandboxConfig.setMaxCodeLength(10);
        String code = "System.out.println(\"This code is too long\");";

        ValidationResult result = codeValidator.validate(code);

        assertFalse(result.isValid());
    }

    @Test
    void validate_safeOperations_returnsValid() {
        String code = """
            int x = 10;
            int y = 20;
            System.out.println(x + y);
            """;

        ValidationResult result = codeValidator.validate(code);

        assertTrue(result.isValid());
    }
}
