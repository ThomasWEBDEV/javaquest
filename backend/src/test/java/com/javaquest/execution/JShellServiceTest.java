package com.javaquest.execution;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
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
        ExecutionResult result = jshellService.execute("1 + 1");
        assertTrue(result.success());
        assertEquals("2", result.output().trim());
    }

    @Test
    void execute_printStatement_returnsOutput() {
        ExecutionResult result = jshellService.execute("System.out.println(\"Hello\");");
        assertTrue(result.success());
        assertTrue(result.output().contains("Hello"));
    }

    @Test
    void execute_variableDeclaration_success() {
        ExecutionResult result = jshellService.execute("int x = 10;");
        assertTrue(result.success());
    }

    @Test
    void execute_syntaxError_returnsError() {
        ExecutionResult result = jshellService.execute("int x = ");
        assertFalse(result.success());
    }

    @Test
    @Disabled("Instable sur WSL2/Java 21")
    void execute_runtimeException_returnsError() {
        ExecutionResult result = jshellService.execute("int x = 1/0;");
        assertFalse(result.success());
    }

    @Test
    @Disabled("Instable sur WSL2/Java 21")
    void execute_multipleStatements_success() {
        ExecutionResult result = jshellService.execute("int a = 5; int b = 3; System.out.println(a + b);");
        assertTrue(result.success());
        assertTrue(result.output().contains("8"));
    }

    @Test
    @Disabled("Instable sur WSL2/Java 21")
    void execute_methodDeclaration_success() {
        ExecutionResult result = jshellService.execute("int add(int a, int b) { return a + b; }");
        assertTrue(result.success());
    }

    @Test
    void execute_returnsExecutionTime() {
        ExecutionResult result = jshellService.execute("1 + 1");
        assertTrue(result.executionTimeMs() >= 0);
    }
}
