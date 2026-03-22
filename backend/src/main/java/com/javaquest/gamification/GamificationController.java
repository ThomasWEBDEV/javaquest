package com.javaquest.gamification;

import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * Controller REST pour la gamification.
 */
@RestController
@RequestMapping("/api/gamification")
public class GamificationController {

    private final GamificationService gamificationService;

    public GamificationController(GamificationService gamificationService) {
        this.gamificationService = gamificationService;
    }

    /**
     * Recupere la progression d'un utilisateur.
     * GET /api/gamification/progress/{userId}
     */
    @GetMapping("/progress/{userId}")
    public ResponseEntity<UserProgressDto> getProgress(@PathVariable Long userId) {
        UserProgress progress = gamificationService.getOrCreateProgress(userId);
        return ResponseEntity.ok(UserProgressDto.fromEntity(progress));
    }

    /**
     * Ajoute de l'XP a un utilisateur.
     * POST /api/gamification/xp/{userId}
     */
    @PostMapping("/xp/{userId}")
    public ResponseEntity<XpGainResult> addXp(
            @PathVariable Long userId,
            @Valid @RequestBody AddXpRequest request) {
        XpGainResult result = gamificationService.addXp(userId, request.xp(), request.reason());
        return ResponseEntity.ok(result);
    }

    /**
     * Recupere les badges d'un utilisateur.
     * GET /api/gamification/badges/{userId}
     */
    @GetMapping("/badges/{userId}")
    public ResponseEntity<List<BadgeDto>> getUserBadges(@PathVariable Long userId) {
        List<BadgeDto> badges = gamificationService.getUserBadges(userId)
            .stream()
            .map(BadgeDto::fromUserBadge)
            .toList();
        return ResponseEntity.ok(badges);
    }

    /**
     * Recupere tous les badges disponibles.
     * GET /api/gamification/badges
     */
    @GetMapping("/badges")
    public ResponseEntity<List<BadgeDto>> getAllBadges() {
        List<BadgeDto> badges = gamificationService.getAllBadges()
            .stream()
            .map(BadgeDto::fromEntity)
            .toList();
        return ResponseEntity.ok(badges);
    }

    /**
     * Gestion des erreurs liees a la gamification.
     */
    @ExceptionHandler(GamificationException.class)
    public ResponseEntity<Map<String, String>> handleGamificationException(GamificationException ex) {
        return ResponseEntity
            .status(HttpStatus.NOT_FOUND)
            .body(Map.of("error", ex.getMessage()));
    }
}
