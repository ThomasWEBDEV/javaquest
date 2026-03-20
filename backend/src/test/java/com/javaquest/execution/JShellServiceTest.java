package com.javaquest.execution;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests unitaires pour JShellService.
 */
class JShellServiceTest {

    private JShellService jshellService;

    @BeforeEach
    void setUp() {
        jshellService = new JShellService();
    }

    @Test
    void execute_simpleExpression_returnsResult() {
        // When
        ExecutionResult result = jshellService.execute("1 + 1");

        // Then
        assertTrue(result.success());
        assertEquals(ExecutionStatus.SUCCESS, result.status());
        assertTrue(result.output().contains("2"));
    }

    @Test
    void execute_printStatement_returnsOutput() {
        // When
        ExecutionResult result = jshellService.execute("System.out.println(\"Hello\");");

        // Then
        assertTrue(result.success());
        assertTrue(result.output().contains("Hello"));
    }

    @Test
    void execute_variableDeclaration_success() {
        // When
        ExecutionResult result = jshellService.execute("int x = 10;");

        // Then
        assertTrue(result.success());
        assertEquals(ExecutionStatus.SUCCESS, result.status());
    }

    @Test
    void execute_syntaxError_returnsError() {
        // When
        ExecutionResult result = jshellService.execute("int x = ");

        // Then
        assertFalse(result.success());
        assertEquals(ExecutionStatus.ERROR, result.status());
    }

    @Test
    void execute_runtimeException_returnsError() {
        // When
        ExecutionResult result = jshellService.execute("int[] arr = new int[1]; arr[5] = 1;");

        // Then
        assertFalse(result.success());
        assertEquals(ExecutionStatus.ERROR, result.status());
    }

    @Test
    void execute_multipleStatements_success() {
        // When
        String code = """
            int a = 5;
            int b = 3;
            System.out.println(a + b);
            """;
        ExecutionResult result = jshellService.execute(code);

        // Then
        assertTrue(result.success());
        assertTrue(result.output().contains("8"));
    }

    @Test
    void execute_methodDeclaration_success() {
        // When
        String code = """
            int add(int a, int b) { return a + b; }
            add(2, 3)
            """;
        ExecutionResult result = jshellService.execute(code);

        // Then
        assertTrue(result.success());
        assertTrue(result.output().contains("5"));
    }

    @Test
    void execute_returnsExecutionTime() {
        // When
        ExecutionResult result = jshellService.execute("1 + 1");

        // Then
        assertTrue(result.executionTimeMs() >= 0);
    }
}
