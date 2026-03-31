package com.javaquest.execution;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * Controller REST pour l'execution de code.
 */
@RestController
@RequestMapping("/api/execute")
public class ExecutionController {

    private final JShellService jshellService;
    private final CodeValidator codeValidator;

    public ExecutionController(JShellService jshellService, CodeValidator codeValidator) {
        this.jshellService = jshellService;
        this.codeValidator = codeValidator;
    }

    /**
     * Execute du code Java.
     * POST /api/execute
     */
    @PostMapping
    public ResponseEntity<?> executeCode(@Valid @RequestBody ExecuteRequest request) {
        // Valide le code avant execution
        ValidationResult validation = codeValidator.validate(request.code());

        if (!validation.isValid()) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "error", validation.message()
            ));
        }

        // Execute le code
        ExecutionResult result = jshellService.execute(request.code());

        return ResponseEntity.ok(result);
    }
}
