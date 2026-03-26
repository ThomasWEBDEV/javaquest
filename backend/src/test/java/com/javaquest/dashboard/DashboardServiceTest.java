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
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

/**
 * Tests unitaires pour DashboardService.
 */
@ExtendWith(MockitoExtension.class)
class DashboardServiceTest {

    @Mock
    private UserExerciseProgressRepository exerciseProgressRepository;

    @Mock
    private UserQuizAttemptRepository quizAttemptRepository;

    @Mock
    private GamificationService gamificationService;

    @Mock
    private UserRepository userRepository;

    @Mock
    private ExerciseRepository exerciseRepository;

    @Mock
    private QuizRepository quizRepository;

    @InjectMocks
    private DashboardService dashboardService;

    private User user;
    private Exercise exercise;
    private Quiz quiz;
    private UserProgress userProgress;

    @BeforeEach
    void setUp() {
        user = new User();
        user.setId(1L);
        user.setUsername("testuser");

        exercise = new Exercise("Test Exercise", "Description", "starter", "solution", "test", 1);
        exercise.setId(1L);
        exercise.setXpReward(50);

        quiz = new Quiz("Test Quiz", "Description");
        quiz.setId(1L);
        quiz.setXpReward(100);

        userProgress = new UserProgress(user);
        userProgress.setTotalXp(500);
        userProgress.setCurrentLevel(1);
        userProgress.setCurrentStreak(5);
        userProgress.setLongestStreak(10);
    }

    @Test
    void getDashboardStats_returnsCompleteStats() {
        // Given
        when(gamificationService.getOrCreateProgress(1L)).thenReturn(userProgress);
        when(exerciseProgressRepository.countByUserIdAndStatus(1L, ProgressStatus.COMPLETED)).thenReturn(10L);
        when(exerciseProgressRepository.countByUserIdAndStatus(1L, ProgressStatus.IN_PROGRESS)).thenReturn(3L);
        when(exerciseProgressRepository.sumAttemptsByUserId(1L)).thenReturn(25L);
        when(quizAttemptRepository.countByUserIdAndPassedTrue(1L)).thenReturn(5L);
        when(quizAttemptRepository.countByUserId(1L)).thenReturn(8L);
        when(quizAttemptRepository.averageScoreByUserId(1L)).thenReturn(75.5);
        when(gamificationService.getUserBadges(1L)).thenReturn(List.of());

        // When
        DashboardStats stats = dashboardService.getDashboardStats(1L);

        // Then
        assertEquals(500, stats.totalXp());
        assertEquals(1, stats.currentLevel());
        assertEquals(5, stats.currentStreak());
        assertEquals(10, stats.longestStreak());
        assertEquals(10, stats.exercisesCompleted());
        assertEquals(3, stats.exercisesInProgress());
        assertEquals(25, stats.totalExerciseAttempts());
        assertEquals(5, stats.quizzesPassed());
        assertEquals(8, stats.totalQuizAttempts());
        assertEquals(75.5, stats.averageQuizScore());
    }

    @Test
    void recordExerciseAttempt_newProgress_createsProgress() {
        // Given
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(exerciseRepository.findById(1L)).thenReturn(Optional.of(exercise));
        when(exerciseProgressRepository.findByUserIdAndExerciseId(1L, 1L)).thenReturn(Optional.empty());
        when(exerciseProgressRepository.save(any(UserExerciseProgress.class))).thenAnswer(i -> i.getArgument(0));

        // When
        UserExerciseProgress progress = dashboardService.recordExerciseAttempt(1L, 1L, "code", false);

        // Then
        assertNotNull(progress);
        assertEquals(1, progress.getAttemptsCount());
        assertEquals(ProgressStatus.IN_PROGRESS, progress.getStatus());
        assertEquals("code", progress.getLastCode());
    }

    @Test
    void recordExerciseAttempt_success_marksCompleted() {
        // Given
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(exerciseRepository.findById(1L)).thenReturn(Optional.of(exercise));
        when(exerciseProgressRepository.findByUserIdAndExerciseId(1L, 1L)).thenReturn(Optional.empty());
        when(exerciseProgressRepository.save(any(UserExerciseProgress.class))).thenAnswer(i -> i.getArgument(0));
        when(gamificationService.addXp(anyLong(), anyInt(), anyString()))
            .thenReturn(new XpGainResult(50, 550, 1, false, 5, List.of()));

        // When
        UserExerciseProgress progress = dashboardService.recordExerciseAttempt(1L, 1L, "code", true);

        // Then
        assertEquals(ProgressStatus.COMPLETED, progress.getStatus());
        assertNotNull(progress.getCompletedAt());
        verify(gamificationService).addXp(eq(1L), eq(50), anyString());
    }

    @Test
    void recordExerciseAttempt_alreadyCompleted_noExtraXp() {
        // Given
        UserExerciseProgress existingProgress = new UserExerciseProgress(user, exercise);
        existingProgress.setStatus(ProgressStatus.COMPLETED);

        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(exerciseRepository.findById(1L)).thenReturn(Optional.of(exercise));
        when(exerciseProgressRepository.findByUserIdAndExerciseId(1L, 1L)).thenReturn(Optional.of(existingProgress));
        when(exerciseProgressRepository.save(any(UserExerciseProgress.class))).thenAnswer(i -> i.getArgument(0));

        // When
        dashboardService.recordExerciseAttempt(1L, 1L, "code", true);

        // Then
        verify(gamificationService, never()).addXp(anyLong(), anyInt(), anyString());
    }

    @Test
    void recordExerciseAttempt_userNotFound_throwsException() {
        // Given
        when(userRepository.findById(99L)).thenReturn(Optional.empty());

        // When & Then
        assertThrows(DashboardException.class, () -> {
            dashboardService.recordExerciseAttempt(99L, 1L, "code", false);
        });
    }

    @Test
    void recordQuizAttempt_passed_addsXp() {
        // Given
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(quizRepository.findById(1L)).thenReturn(Optional.of(quiz));
        when(quizAttemptRepository.save(any(UserQuizAttempt.class))).thenAnswer(i -> i.getArgument(0));
        when(gamificationService.addXp(anyLong(), anyInt(), anyString()))
            .thenReturn(new XpGainResult(100, 600, 1, false, 5, List.of()));

        // When
        UserQuizAttempt attempt = dashboardService.recordQuizAttempt(1L, 1L, 80, 8, 10, true, 100);

        // Then
        assertNotNull(attempt);
        assertEquals(80, attempt.getScore());
        assertTrue(attempt.getPassed());
        verify(gamificationService).addXp(eq(1L), eq(100), anyString());
    }

    @Test
    void recordQuizAttempt_failed_noXp() {
        // Given
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(quizRepository.findById(1L)).thenReturn(Optional.of(quiz));
        when(quizAttemptRepository.save(any(UserQuizAttempt.class))).thenAnswer(i -> i.getArgument(0));

        // When
        UserQuizAttempt attempt = dashboardService.recordQuizAttempt(1L, 1L, 50, 5, 10, false, 0);

        // Then
        assertFalse(attempt.getPassed());
        verify(gamificationService, never()).addXp(anyLong(), anyInt(), anyString());
    }

    @Test
    void getExerciseProgress_found_returnsProgress() {
        // Given
        UserExerciseProgress progress = new UserExerciseProgress(user, exercise);
        when(exerciseProgressRepository.findByUserIdAndExerciseId(1L, 1L)).thenReturn(Optional.of(progress));

        // When
        UserExerciseProgress result = dashboardService.getExerciseProgress(1L, 1L);

        // Then
        assertNotNull(result);
    }

    @Test
    void getExerciseProgress_notFound_returnsNull() {
        // Given
        when(exerciseProgressRepository.findByUserIdAndExerciseId(1L, 99L)).thenReturn(Optional.empty());

        // When
        UserExerciseProgress result = dashboardService.getExerciseProgress(1L, 99L);

        // Then
        assertNull(result);
    }

    @Test
    void getQuizHistory_returnsList() {
        // Given
        UserQuizAttempt attempt = new UserQuizAttempt(user, quiz, 80, 8, 10, true, 100);
        when(quizAttemptRepository.findByUserIdOrderByAttemptedAtDesc(1L)).thenReturn(List.of(attempt));

        // When
        List<UserQuizAttempt> result = dashboardService.getQuizHistory(1L);

        // Then
        assertEquals(1, result.size());
    }

    @Test
    void getBestQuizAttempt_found_returnsAttempt() {
        // Given
        UserQuizAttempt attempt = new UserQuizAttempt(user, quiz, 90, 9, 10, true, 100);
        when(quizAttemptRepository.findFirstByUserIdAndQuizIdOrderByScoreDesc(1L, 1L))
            .thenReturn(Optional.of(attempt));

        // When
        UserQuizAttempt result = dashboardService.getBestQuizAttempt(1L, 1L);

        // Then
        assertNotNull(result);
        assertEquals(90, result.getScore());
    }

    @Test
    void getExercisesInProgress_returnsList() {
        // Given
        UserExerciseProgress progress = new UserExerciseProgress(user, exercise);
        progress.setStatus(ProgressStatus.IN_PROGRESS);
        when(exerciseProgressRepository.findByUserIdAndStatus(1L, ProgressStatus.IN_PROGRESS))
            .thenReturn(List.of(progress));

        // When
        List<UserExerciseProgress> result = dashboardService.getExercisesInProgress(1L);

        // Then
        assertEquals(1, result.size());
        assertEquals(ProgressStatus.IN_PROGRESS, result.get(0).getStatus());
    }
}
