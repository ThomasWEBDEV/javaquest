package com.javaquest.dashboard;

import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * Controller REST pour le dashboard.
 */
@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    private final DashboardService dashboardService;

    public DashboardController(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    /**
     * Recupere les statistiques du dashboard.
     * GET /api/dashboard/{userId}/stats
     */
    @GetMapping("/{userId}/stats")
    public ResponseEntity<DashboardStats> getStats(@PathVariable Long userId) {
        DashboardStats stats = dashboardService.getDashboardStats(userId);
        return ResponseEntity.ok(stats);
    }

    /**
     * Enregistre une tentative d'exercice.
     * POST /api/dashboard/{userId}/exercises/{exerciseId}/attempt
     */
    @PostMapping("/{userId}/exercises/{exerciseId}/attempt")
    public ResponseEntity<ExerciseProgressDto> recordExerciseAttempt(
            @PathVariable Long userId,
            @PathVariable Long exerciseId,
            @Valid @RequestBody ExerciseAttemptRequest request) {
        UserExerciseProgress progress = dashboardService.recordExerciseAttempt(
            userId, exerciseId, request.code(), request.success()
        );
        return ResponseEntity.ok(ExerciseProgressDto.fromEntity(progress));
    }

    /**
     * Recupere la progression sur un exercice.
     * GET /api/dashboard/{userId}/exercises/{exerciseId}/progress
     */
    @GetMapping("/{userId}/exercises/{exerciseId}/progress")
    public ResponseEntity<ExerciseProgressDto> getExerciseProgress(
            @PathVariable Long userId,
            @PathVariable Long exerciseId) {
        UserExerciseProgress progress = dashboardService.getExerciseProgress(userId, exerciseId);
        if (progress == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(ExerciseProgressDto.fromEntity(progress));
    }

    /**
     * Recupere les exercices en cours.
     * GET /api/dashboard/{userId}/exercises/in-progress
     */
    @GetMapping("/{userId}/exercises/in-progress")
    public ResponseEntity<List<ExerciseProgressDto>> getExercisesInProgress(@PathVariable Long userId) {
        List<ExerciseProgressDto> exercises = dashboardService.getExercisesInProgress(userId).stream()
            .map(ExerciseProgressDto::fromEntity)
            .toList();
        return ResponseEntity.ok(exercises);
    }

    /**
     * Recupere l'historique des quiz.
     * GET /api/dashboard/{userId}/quizzes/history
     */
    @GetMapping("/{userId}/quizzes/history")
    public ResponseEntity<List<QuizAttemptDto>> getQuizHistory(@PathVariable Long userId) {
        List<QuizAttemptDto> attempts = dashboardService.getQuizHistory(userId).stream()
            .map(QuizAttemptDto::fromEntity)
            .toList();
        return ResponseEntity.ok(attempts);
    }

    /**
     * Recupere la meilleure tentative sur un quiz.
     * GET /api/dashboard/{userId}/quizzes/{quizId}/best
     */
    @GetMapping("/{userId}/quizzes/{quizId}/best")
    public ResponseEntity<QuizAttemptDto> getBestQuizAttempt(
            @PathVariable Long userId,
            @PathVariable Long quizId) {
        UserQuizAttempt attempt = dashboardService.getBestQuizAttempt(userId, quizId);
        if (attempt == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(QuizAttemptDto.fromEntity(attempt));
    }

    /**
     * Gestion des erreurs liees au dashboard.
     */
    @ExceptionHandler(DashboardException.class)
    public ResponseEntity<Map<String, String>> handleDashboardException(DashboardException ex) {
        return ResponseEntity
            .status(HttpStatus.NOT_FOUND)
            .body(Map.of("error", ex.getMessage()));
    }
}
