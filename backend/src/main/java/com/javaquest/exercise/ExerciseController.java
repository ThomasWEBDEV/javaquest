package com.javaquest.exercise;

import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * Controller REST pour la gestion des exercices.
 */
@RestController
@RequestMapping("/api/exercises")
public class ExerciseController {

    private final ExerciseService exerciseService;

    public ExerciseController(ExerciseService exerciseService) {
        this.exerciseService = exerciseService;
    }

    /**
     * Liste tous les exercices d'une lecon.
     * GET /api/exercises/lesson/{lessonId}
     */
    @GetMapping("/lesson/{lessonId}")
    public ResponseEntity<List<ExerciseDto>> getExercisesByLesson(@PathVariable Long lessonId) {
        List<ExerciseDto> exercises = exerciseService.getExercisesByLesson(lessonId)
            .stream()
            .map(ExerciseDto::fromEntity)
            .toList();
        return ResponseEntity.ok(exercises);
    }

    /**
     * Recupere un exercice par son ID.
     * GET /api/exercises/{id}
     */
    @GetMapping("/{id}")
    public ResponseEntity<ExerciseDto> getExerciseById(@PathVariable Long id) {
        Exercise exercise = exerciseService.getExerciseById(id);
        return ResponseEntity.ok(ExerciseDto.fromEntity(exercise));
    }

    /**
     * Cree un nouvel exercice dans une lecon.
     * POST /api/exercises/lesson/{lessonId}
     */
    @PostMapping("/lesson/{lessonId}")
    public ResponseEntity<ExerciseDto> createExercise(
            @PathVariable Long lessonId,
            @Valid @RequestBody CreateExerciseRequest request) {
        Exercise exercise = exerciseService.createExercise(
            lessonId,
            request.title(),
            request.description(),
            request.starterCode(),
            request.solutionCode(),
            request.testCode(),
            request.hints(),
            request.difficulty(),
            request.xpReward(),
            request.orderIndex()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(ExerciseDto.fromEntity(exercise));
    }

    /**
     * Met a jour un exercice.
     * PUT /api/exercises/{id}
     */
    @PutMapping("/{id}")
    public ResponseEntity<ExerciseDto> updateExercise(
            @PathVariable Long id,
            @Valid @RequestBody UpdateExerciseRequest request) {
        Exercise exercise = exerciseService.updateExercise(
            id,
            request.title(),
            request.description(),
            request.starterCode(),
            request.solutionCode(),
            request.testCode(),
            request.hints(),
            request.difficulty(),
            request.xpReward()
        );
        return ResponseEntity.ok(ExerciseDto.fromEntity(exercise));
    }

    /**
     * Supprime un exercice.
     * DELETE /api/exercises/{id}
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteExercise(@PathVariable Long id) {
        exerciseService.deleteExercise(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * Liste les exercices par difficulte.
     * GET /api/exercises/difficulty/{difficulty}
     */
    @GetMapping("/difficulty/{difficulty}")
    public ResponseEntity<List<ExerciseDto>> getExercisesByDifficulty(@PathVariable Difficulty difficulty) {
        List<ExerciseDto> exercises = exerciseService.getExercisesByDifficulty(difficulty)
            .stream()
            .map(ExerciseDto::fromEntity)
            .toList();
        return ResponseEntity.ok(exercises);
    }

    /**
     * Gestion des erreurs liees aux exercices.
     */
    @ExceptionHandler(ExerciseException.class)
    public ResponseEntity<Map<String, String>> handleExerciseException(ExerciseException ex) {
        return ResponseEntity
            .status(HttpStatus.NOT_FOUND)
            .body(Map.of("error", ex.getMessage()));
    }
}
