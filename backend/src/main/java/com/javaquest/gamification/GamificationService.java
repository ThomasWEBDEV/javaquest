package com.javaquest.gamification;

import com.javaquest.dashboard.ProgressStatus;
import com.javaquest.dashboard.UserExerciseProgressRepository;
import com.javaquest.dashboard.UserQuizAttemptRepository;
import com.javaquest.user.User;
import com.javaquest.user.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

/**
 * Service gerant la gamification.
 * XP, niveaux, badges, streaks.
 */
@Service
public class GamificationService {

    private static final Logger log = LoggerFactory.getLogger(GamificationService.class);

    private final UserProgressRepository userProgressRepository;
    private final BadgeRepository badgeRepository;
    private final UserBadgeRepository userBadgeRepository;
    private final UserRepository userRepository;
    private final UserExerciseProgressRepository exerciseProgressRepository;
    private final UserQuizAttemptRepository quizAttemptRepository;

    public GamificationService(UserProgressRepository userProgressRepository,
                               BadgeRepository badgeRepository,
                               UserBadgeRepository userBadgeRepository,
                               UserRepository userRepository,
                               UserExerciseProgressRepository exerciseProgressRepository,
                               UserQuizAttemptRepository quizAttemptRepository) {
        this.userProgressRepository = userProgressRepository;
        this.badgeRepository = badgeRepository;
        this.userBadgeRepository = userBadgeRepository;
        this.userRepository = userRepository;
        this.exerciseProgressRepository = exerciseProgressRepository;
        this.quizAttemptRepository = quizAttemptRepository;
    }

    /**
     * Recupere ou cree la progression d'un utilisateur.
     */
    public UserProgress getOrCreateProgress(Long userId) {
        return userProgressRepository.findByUserId(userId)
            .orElseGet(() -> {
                User user = userRepository.findById(userId)
                    .orElseThrow(() -> new GamificationException("Utilisateur non trouve"));
                UserProgress progress = new UserProgress(user);
                return userProgressRepository.save(progress);
            });
    }

    /**
     * Recupere la progression d'un utilisateur.
     */
    public UserProgress getProgress(Long userId) {
        return userProgressRepository.findByUserId(userId)
            .orElseThrow(() -> new GamificationException("Progression non trouvee"));
    }

    /**
     * Ajoute de l'XP a un utilisateur et verifie les badges.
     */
    @Transactional
    public XpGainResult addXp(Long userId, int xp, String reason) {
        UserProgress progress = getOrCreateProgress(userId);
        int previousLevel = progress.getCurrentLevel();

        progress.addXp(xp);
        progress.updateStreak();
        userProgressRepository.save(progress);

        boolean leveledUp = progress.getCurrentLevel() > previousLevel;
        if (leveledUp) {
            log.info("Utilisateur {} passe au niveau {}", userId, progress.getCurrentLevel());
        }
        List<Badge> newBadges = checkAndAwardBadges(userId, progress);

        return new XpGainResult(
            xp,
            progress.getTotalXp(),
            progress.getCurrentLevel(),
            leveledUp,
            progress.getCurrentStreak(),
            newBadges
        );
    }

    /**
     * Verifie et attribue les badges.
     */
    @Transactional
    public List<Badge> checkAndAwardBadges(Long userId, UserProgress progress) {
        List<Badge> newBadges = new ArrayList<>();
        User user = progress.getUser();
        List<Badge> allBadges = badgeRepository.findAll();

        for (Badge badge : allBadges) {
            if (userBadgeRepository.existsByUserIdAndBadgeId(userId, badge.getId())) {
                continue;
            }

            boolean earned = switch (badge.getCriteriaType()) {
                case XP_TOTAL -> progress.getTotalXp() >= badge.getCriteriaValue();
                case LEVEL_REACHED -> progress.getCurrentLevel() >= badge.getCriteriaValue();
                case STREAK_DAYS -> progress.getCurrentStreak() >= badge.getCriteriaValue();
                case EXERCISES_COMPLETED -> exerciseProgressRepository
                    .countByUserIdAndStatus(userId, ProgressStatus.COMPLETED) >= badge.getCriteriaValue();
                case CHAPTERS_COMPLETED -> exerciseProgressRepository
                    .countDistinctCompletedChapters(userId, ProgressStatus.COMPLETED) >= badge.getCriteriaValue();
                case QUIZZES_PASSED -> quizAttemptRepository
                    .countByUserIdAndPassedTrue(userId) >= badge.getCriteriaValue();
            };

            if (earned) {
                UserBadge userBadge = new UserBadge(user, badge);
                userBadgeRepository.save(userBadge);
                newBadges.add(badge);
                log.info("Badge '{}' attribue a l'utilisateur {}", badge.getName(), userId);
            }
        }

        return newBadges;
    }

    /**
     * Recupere les badges d'un utilisateur.
     */
    public List<UserBadge> getUserBadges(Long userId) {
        return userBadgeRepository.findByUserId(userId);
    }

    /**
     * Recupere tous les badges disponibles.
     */
    public List<Badge> getAllBadges() {
        return badgeRepository.findAll();
    }

    /**
     * Cree un nouveau badge.
     */
    @Transactional
    public Badge createBadge(String name, String description, BadgeCriteria criteriaType, Integer criteriaValue) {
        Badge badge = new Badge(name, description, criteriaType, criteriaValue);
        return badgeRepository.save(badge);
    }
}
