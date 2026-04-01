package com.javaquest.dashboard;

import com.javaquest.exercise.Exercise;
import com.javaquest.exercise.ExerciseRepository;
import com.javaquest.gamification.GamificationService;
import com.javaquest.gamification.UserProgress;
import com.javaquest.gamification.XpGainResult;
import com.javaquest.quiz.Quiz;
import com.javaquest.quiz.QuizRepository;
import com.javaquest.user.User;
import com.javaquest.user.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Service gerant le dashboard et les statistiques utilisateur.
 */
@Service
public class DashboardService {

    private final UserExerciseProgressRepository exerciseProgressRepository;
    private final UserQuizAttemptRepository quizAttemptRepository;
    private final GamificationService gamificationService;
    private final UserRepository userRepository;
    private final ExerciseRepository exerciseRepository;
    private final QuizRepository quizRepository;

    public DashboardService(UserExerciseProgressRepository exerciseProgressRepository,
                            UserQuizAttemptRepository quizAttemptRepository,
                            GamificationService gamificationService,
                            UserRepository userRepository,
                            ExerciseRepository exerciseRepository,
                            QuizRepository quizRepository) {
        this.exerciseProgressRepository = exerciseProgressRepository;
        this.quizAttemptRepository = quizAttemptRepository;
        this.gamificationService = gamificationService;
        this.userRepository = userRepository;
        this.exerciseRepository = exerciseRepository;
        this.quizRepository = quizRepository;
    }

    /**
     * Recupere les statistiques completes d'un utilisateur.
     */
    public DashboardStats getDashboardStats(Long userId) {
        UserProgress progress = gamificationService.getOrCreateProgress(userId);

        long exercisesCompleted = exerciseProgressRepository.countByUserIdAndStatus(userId, ProgressStatus.COMPLETED);
        long exercisesInProgress = exerciseProgressRepository.countByUserIdAndStatus(userId, ProgressStatus.IN_PROGRESS);
        long totalExerciseAttempts = exerciseProgressRepository.sumAttemptsByUserId(userId);

        long quizzesPassed = quizAttemptRepository.countByUserIdAndPassedTrue(userId);
        long totalQuizAttempts = quizAttemptRepository.countByUserId(userId);
        double averageQuizScore = quizAttemptRepository.averageScoreByUserId(userId);

        long badgesCount = gamificationService.getUserBadges(userId).size();

        return new DashboardStats(
            progress.getTotalXp(),
            progress.getCurrentLevel(),
            progress.getXpForNextLevel(),
            progress.getCurrentStreak(),
            progress.getLongestStreak(),
            exercisesCompleted,
            exercisesInProgress,
            totalExerciseAttempts,
            quizzesPassed,
            totalQuizAttempts,
            averageQuizScore,
            badgesCount
        );
    }

    /**
     * Enregistre une tentative d'exercice.
     */
    @Transactional
    public ExerciseAttemptResult recordExerciseAttempt(Long userId, Long exerciseId, String code, boolean success) {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new DashboardException("Utilisateur non trouve"));

        Exercise exercise = exerciseRepository.findById(exerciseId)
            .orElseThrow(() -> new DashboardException("Exercice non trouve"));

        UserExerciseProgress progress = exerciseProgressRepository
            .findByUserIdAndExerciseId(userId, exerciseId)
            .orElseGet(() -> new UserExerciseProgress(user, exercise));

        progress.incrementAttempts();
        progress.setLastCode(code);

        XpGainResult xpGain = null;
        if (success && progress.getStatus() != ProgressStatus.COMPLETED) {
            progress.markCompleted();
            xpGain = gamificationService.addXp(userId, exercise.getXpReward(), "Exercice complete: " + exercise.getTitle());
        }

        return new ExerciseAttemptResult(exerciseProgressRepository.save(progress), xpGain);
    }

    /**
     * Enregistre une tentative de quiz.
     */
    @Transactional
    public UserQuizAttempt recordQuizAttempt(Long userId, Long quizId, int score, int correctAnswers,
                                              int totalQuestions, boolean passed, int xpEarned) {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new DashboardException("Utilisateur non trouve"));

        Quiz quiz = quizRepository.findById(quizId)
            .orElseThrow(() -> new DashboardException("Quiz non trouve"));

        UserQuizAttempt attempt = new UserQuizAttempt(user, quiz, score, correctAnswers, totalQuestions, passed, xpEarned);

        if (passed && xpEarned > 0) {
            gamificationService.addXp(userId, xpEarned, "Quiz reussi: " + quiz.getTitle());
        }

        return quizAttemptRepository.save(attempt);
    }

    /**
     * Recupere la progression d'un utilisateur sur un exercice.
     */
    public UserExerciseProgress getExerciseProgress(Long userId, Long exerciseId) {
        return exerciseProgressRepository.findByUserIdAndExerciseId(userId, exerciseId)
            .orElse(null);
    }

    /**
     * Recupere l'historique des tentatives de quiz d'un utilisateur.
     */
    public List<UserQuizAttempt> getQuizHistory(Long userId) {
        return quizAttemptRepository.findByUserIdOrderByAttemptedAtDesc(userId);
    }

    /**
     * Recupere la meilleure tentative sur un quiz.
     */
    public UserQuizAttempt getBestQuizAttempt(Long userId, Long quizId) {
        return quizAttemptRepository.findFirstByUserIdAndQuizIdOrderByScoreDesc(userId, quizId)
            .orElse(null);
    }

    /**
     * Recupere les exercices en cours d'un utilisateur.
     */
    public List<UserExerciseProgress> getExercisesInProgress(Long userId) {
        return exerciseProgressRepository.findByUserIdAndStatus(userId, ProgressStatus.IN_PROGRESS);
    }
}
