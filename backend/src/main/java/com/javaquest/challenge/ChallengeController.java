package com.javaquest.challenge;

import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * Controller REST pour les defis quotidiens.
 */
@RestController
@RequestMapping("/api/challenges")
public class ChallengeController {

    private final ChallengeService challengeService;

    public ChallengeController(ChallengeService challengeService) {
        this.challengeService = challengeService;
    }

    /**
     * Recupere le defi du jour.
     * GET /api/challenges/today
     */
    @GetMapping("/today")
    public ResponseEntity<DailyChallengeDto> getTodayChallenge() {
        DailyChallenge challenge = challengeService.getTodayChallenge();
        return ResponseEntity.ok(DailyChallengeDto.fromEntity(challenge));
    }

    /**
     * Recupere un defi par son ID.
     * GET /api/challenges/{id}
     */
    @GetMapping("/{id}")
    public ResponseEntity<DailyChallengeDto> getChallengeById(@PathVariable Long id) {
        DailyChallenge challenge = challengeService.getChallengeById(id);
        return ResponseEntity.ok(DailyChallengeDto.fromEntity(challenge));
    }

    /**
     * Recupere les defis recents.
     * GET /api/challenges/recent?days=7
     */
    @GetMapping("/recent")
    public ResponseEntity<List<DailyChallengeDto>> getRecentChallenges(
            @RequestParam(defaultValue = "7") int days) {
        List<DailyChallengeDto> challenges = challengeService.getRecentChallenges(days).stream()
            .map(DailyChallengeDto::fromEntity)
            .toList();
        return ResponseEntity.ok(challenges);
    }

    /**
     * Cree un nouveau defi.
     * POST /api/challenges
     */
    @PostMapping
    public ResponseEntity<DailyChallengeDto> createChallenge(
            @Valid @RequestBody CreateChallengeRequest request) {
        DailyChallenge challenge = challengeService.createChallenge(
            request.date(),
            request.title(),
            request.description(),
            request.starterCode(),
            request.solutionCode(),
            request.testCode(),
            request.hints(),
            request.xpReward(),
            request.bonusXp()
        );
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(DailyChallengeDto.fromEntity(challenge));
    }

    /**
     * Demarre un defi pour un utilisateur.
     * POST /api/challenges/{id}/start/{userId}
     */
    @PostMapping("/{id}/start/{userId}")
    public ResponseEntity<UserChallengeDto> startChallenge(
            @PathVariable Long id,
            @PathVariable Long userId) {
        UserDailyChallenge userChallenge = challengeService.startChallenge(userId, id);
        return ResponseEntity.ok(UserChallengeDto.fromEntity(userChallenge));
    }

    /**
     * Soumet une tentative de defi.
     * POST /api/challenges/{id}/submit/{userId}
     */
    @PostMapping("/{id}/submit/{userId}")
    public ResponseEntity<ChallengeResult> submitChallenge(
            @PathVariable Long id,
            @PathVariable Long userId,
            @Valid @RequestBody SubmitChallengeRequest request) {
        ChallengeResult result = challengeService.submitChallenge(
            userId, id, request.code(), request.success()
        );
        return ResponseEntity.ok(result);
    }

    /**
     * Recupere la participation d'un utilisateur a un defi.
     * GET /api/challenges/{id}/user/{userId}
     */
    @GetMapping("/{id}/user/{userId}")
    public ResponseEntity<UserChallengeDto> getUserChallenge(
            @PathVariable Long id,
            @PathVariable Long userId) {
        UserDailyChallenge userChallenge = challengeService.getUserChallenge(userId, id);
        if (userChallenge == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(UserChallengeDto.fromEntity(userChallenge));
    }

    /**
     * Recupere l'historique des defis d'un utilisateur.
     * GET /api/challenges/user/{userId}/history
     */
    @GetMapping("/user/{userId}/history")
    public ResponseEntity<List<UserChallengeDto>> getUserHistory(@PathVariable Long userId) {
        List<UserChallengeDto> history = challengeService.getUserChallengeHistory(userId).stream()
            .map(UserChallengeDto::fromEntity)
            .toList();
        return ResponseEntity.ok(history);
    }

    /**
     * Gestion des erreurs liees aux defis.
     */
    @ExceptionHandler(ChallengeException.class)
    public ResponseEntity<Map<String, String>> handleChallengeException(ChallengeException ex) {
        return ResponseEntity
            .status(HttpStatus.NOT_FOUND)
            .body(Map.of("error", ex.getMessage()));
    }
}
