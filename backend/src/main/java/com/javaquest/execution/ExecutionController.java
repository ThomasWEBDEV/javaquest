package com.javaquest.execution;

import com.javaquest.dashboard.DashboardService;
import com.javaquest.dashboard.ExerciseAttemptResult;
import com.javaquest.user.User;
import com.javaquest.user.UserRepository;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * Controller REST pour l'execution de code.
 */
@RestController
@RequestMapping("/api/execute")
public class ExecutionController {

    private final JShellService jshellService;
    private final CodeValidator codeValidator;
    private final DashboardService dashboardService;
    private final UserRepository userRepository;

    public ExecutionController(JShellService jshellService, CodeValidator codeValidator,
                               DashboardService dashboardService, UserRepository userRepository) {
        this.jshellService = jshellService;
        this.codeValidator = codeValidator;
        this.dashboardService = dashboardService;
        this.userRepository = userRepository;
    }

    /**
     * Execute du code Java.
     * POST /api/execute
     */
    @PostMapping
    public ResponseEntity<?> executeCode(@Valid @RequestBody ExecuteRequest request,
                                         Authentication authentication) {
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

        // Si un exercice est associe et l'utilisateur est authentifie, enregistre la tentative
        if (request.exerciseId() != null && authentication != null) {
            String username = authentication.getName();
            User user = userRepository.findByUsername(username).orElse(null);

            if (user != null) {
                ExerciseAttemptResult attemptResult = dashboardService.recordExerciseAttempt(
                    user.getId(), request.exerciseId(), request.code(), result.success()
                );

                if (attemptResult.xpGain() != null) {
                    Map<String, Object> response = new HashMap<>();
                    response.put("success", result.success());
                    response.put("output", result.output());
                    response.put("executionTimeMs", result.executionTimeMs());
                    response.put("status", result.status());
                    response.put("xpGain", attemptResult.xpGain());
                    return ResponseEntity.ok(response);
                }
            }
        }

        return ResponseEntity.ok(result);
    }
}
