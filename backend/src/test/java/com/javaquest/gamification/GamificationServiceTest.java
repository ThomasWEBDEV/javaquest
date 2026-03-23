package com.javaquest.gamification;

import com.javaquest.user.User;
import com.javaquest.user.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.*;

/**
 * Tests unitaires pour GamificationService.
 */
@ExtendWith(MockitoExtension.class)
class GamificationServiceTest {

    @Mock
    private UserProgressRepository userProgressRepository;

    @Mock
    private BadgeRepository badgeRepository;

    @Mock
    private UserBadgeRepository userBadgeRepository;

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private GamificationService gamificationService;

    private User user;
    private UserProgress progress;
    private Badge badge;

    @BeforeEach
    void setUp() {
        user = new User();
        user.setId(1L);
        user.setUsername("testuser");
        user.setEmail("test@test.com");

        progress = new UserProgress(user);
        progress.setId(1L);
        progress.setTotalXp(500);
        progress.setCurrentLevel(1);
        progress.setCurrentStreak(3);
        progress.setLongestStreak(5);

        badge = new Badge("First Steps", "Complete first exercise", BadgeCriteria.XP_TOTAL, 100);
        badge.setId(1L);
    }

    @Test
    void getOrCreateProgress_exists_returnsProgress() {
        // Given
        when(userProgressRepository.findByUserId(1L)).thenReturn(Optional.of(progress));

        // When
        UserProgress result = gamificationService.getOrCreateProgress(1L);

        // Then
        assertNotNull(result);
        assertEquals(500, result.getTotalXp());
        verify(userRepository, never()).findById(anyLong());
    }

    @Test
    void getOrCreateProgress_notExists_createsNew() {
        // Given
        when(userProgressRepository.findByUserId(1L)).thenReturn(Optional.empty());
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(userProgressRepository.save(any(UserProgress.class))).thenAnswer(i -> i.getArgument(0));

        // When
        UserProgress result = gamificationService.getOrCreateProgress(1L);

        // Then
        assertNotNull(result);
        assertEquals(0, result.getTotalXp());
        verify(userProgressRepository).save(any(UserProgress.class));
    }

    @Test
    void getOrCreateProgress_userNotFound_throwsException() {
        // Given
        when(userProgressRepository.findByUserId(99L)).thenReturn(Optional.empty());
        when(userRepository.findById(99L)).thenReturn(Optional.empty());

        // When & Then
        assertThrows(GamificationException.class, () -> {
            gamificationService.getOrCreateProgress(99L);
        });
    }

    @Test
    void getProgress_found_returnsProgress() {
        // Given
        when(userProgressRepository.findByUserId(1L)).thenReturn(Optional.of(progress));

        // When
        UserProgress result = gamificationService.getProgress(1L);

        // Then
        assertNotNull(result);
        assertEquals(500, result.getTotalXp());
    }

    @Test
    void getProgress_notFound_throwsException() {
        // Given
        when(userProgressRepository.findByUserId(99L)).thenReturn(Optional.empty());

        // When & Then
        assertThrows(GamificationException.class, () -> {
            gamificationService.getProgress(99L);
        });
    }

    @Test
    void addXp_addsXpAndUpdatesStreak() {
        // Given
        when(userProgressRepository.findByUserId(1L)).thenReturn(Optional.of(progress));
        when(userProgressRepository.save(any(UserProgress.class))).thenAnswer(i -> i.getArgument(0));
        when(badgeRepository.findAll()).thenReturn(List.of());

        // When
        XpGainResult result = gamificationService.addXp(1L, 100, "Exercise completed");

        // Then
        assertEquals(100, result.xpGained());
        assertEquals(600, result.totalXp());
        verify(userProgressRepository).save(any(UserProgress.class));
    }

    @Test
    void addXp_levelUp_returnsLeveledUp() {
        // Given
        progress.setTotalXp(950);
        when(userProgressRepository.findByUserId(1L)).thenReturn(Optional.of(progress));
        when(userProgressRepository.save(any(UserProgress.class))).thenAnswer(i -> i.getArgument(0));
        when(badgeRepository.findAll()).thenReturn(List.of());

        // When
        XpGainResult result = gamificationService.addXp(1L, 100, "Exercise completed");

        // Then
        assertTrue(result.leveledUp());
        assertEquals(2, result.currentLevel());
    }

    @Test
    void checkAndAwardBadges_earnsBadge() {
        // Given
        progress.setTotalXp(150);
        when(badgeRepository.findAll()).thenReturn(List.of(badge));
        when(userBadgeRepository.existsByUserIdAndBadgeId(1L, 1L)).thenReturn(false);
        when(userBadgeRepository.save(any(UserBadge.class))).thenAnswer(i -> i.getArgument(0));

        // When
        List<Badge> newBadges = gamificationService.checkAndAwardBadges(1L, progress);

        // Then
        assertEquals(1, newBadges.size());
        assertEquals("First Steps", newBadges.get(0).getName());
        verify(userBadgeRepository).save(any(UserBadge.class));
    }

    @Test
    void checkAndAwardBadges_alreadyHasBadge_skips() {
        // Given
        when(badgeRepository.findAll()).thenReturn(List.of(badge));
        when(userBadgeRepository.existsByUserIdAndBadgeId(1L, 1L)).thenReturn(true);

        // When
        List<Badge> newBadges = gamificationService.checkAndAwardBadges(1L, progress);

        // Then
        assertTrue(newBadges.isEmpty());
        verify(userBadgeRepository, never()).save(any(UserBadge.class));
    }

    @Test
    void getUserBadges_returnsList() {
        // Given
        UserBadge userBadge = new UserBadge(user, badge);
        when(userBadgeRepository.findByUserId(1L)).thenReturn(List.of(userBadge));

        // When
        List<UserBadge> result = gamificationService.getUserBadges(1L);

        // Then
        assertEquals(1, result.size());
    }

    @Test
    void getAllBadges_returnsList() {
        // Given
        when(badgeRepository.findAll()).thenReturn(List.of(badge));

        // When
        List<Badge> result = gamificationService.getAllBadges();

        // Then
        assertEquals(1, result.size());
        assertEquals("First Steps", result.get(0).getName());
    }

    @Test
    void createBadge_success() {
        // Given
        when(badgeRepository.save(any(Badge.class))).thenAnswer(i -> i.getArgument(0));

        // When
        Badge result = gamificationService.createBadge("New Badge", "Description", BadgeCriteria.LEVEL_REACHED, 5);

        // Then
        assertNotNull(result);
        assertEquals("New Badge", result.getName());
        verify(badgeRepository).save(any(Badge.class));
    }
}
