package com.javaquest.challenge;

import com.javaquest.gamification.GamificationService;
import com.javaquest.gamification.XpGainResult;
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
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ChallengeServiceTest {

    @Mock
    private DailyChallengeRepository challengeRepository;

    @Mock
    private UserDailyChallengeRepository userChallengeRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private GamificationService gamificationService;

    @InjectMocks
    private ChallengeService challengeService;

    private User user;
    private DailyChallenge challenge;
    private UserDailyChallenge userChallenge;

    @BeforeEach
    void setUp() {
        user = new User();
        user.setId(1L);
        user.setUsername("testuser");

        challenge = new DailyChallenge(LocalDate.now(), "Test Challenge", "Description", "solution", "test");
        challenge.setId(1L);
        challenge.setXpReward(100);
        challenge.setBonusXp(50);

        userChallenge = new UserDailyChallenge(user, challenge);
        userChallenge.setId(1L);
    }

    @Test
    void getTodayChallenge_exists_returnsChallenge() {
        when(challengeRepository.findByDate(LocalDate.now())).thenReturn(Optional.of(challenge));

        DailyChallenge result = challengeService.getTodayChallenge();

        assertNotNull(result);
        assertEquals("Test Challenge", result.getTitle());
    }

    @Test
    void getTodayChallenge_notExists_throwsException() {
        when(challengeRepository.findByDate(LocalDate.now())).thenReturn(Optional.empty());

        assertThrows(ChallengeException.class, () -> {
            challengeService.getTodayChallenge();
        });
    }

    @Test
    void getChallengeById_found_returnsChallenge() {
        when(challengeRepository.findById(1L)).thenReturn(Optional.of(challenge));

        DailyChallenge result = challengeService.getChallengeById(1L);

        assertNotNull(result);
        assertEquals(1L, result.getId());
    }

    @Test
    void getChallengeById_notFound_throwsException() {
        when(challengeRepository.findById(99L)).thenReturn(Optional.empty());

        assertThrows(ChallengeException.class, () -> {
            challengeService.getChallengeById(99L);
        });
    }

    @Test
    void createChallenge_success() {
        when(challengeRepository.existsByDate(any())).thenReturn(false);
        when(challengeRepository.save(any(DailyChallenge.class))).thenAnswer(i -> i.getArgument(0));

        DailyChallenge result = challengeService.createChallenge(
            LocalDate.now().plusDays(1), "New Challenge", "Desc",
            "starter", "solution", "test", "hints", 100, 50
        );

        assertNotNull(result);
        assertEquals("New Challenge", result.getTitle());
        verify(challengeRepository).save(any(DailyChallenge.class));
    }

    @Test
    void createChallenge_dateExists_throwsException() {
        when(challengeRepository.existsByDate(any())).thenReturn(true);

        assertThrows(ChallengeException.class, () -> {
            challengeService.createChallenge(
                LocalDate.now(), "Challenge", "Desc",
                null, "solution", "test", null, null, null
            );
        });
    }

    @Test
    void startChallenge_newParticipation_createsUserChallenge() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(challengeRepository.findById(1L)).thenReturn(Optional.of(challenge));
        when(userChallengeRepository.findByUserIdAndChallengeId(1L, 1L)).thenReturn(Optional.empty());
        when(userChallengeRepository.save(any(UserDailyChallenge.class))).thenAnswer(i -> i.getArgument(0));

        UserDailyChallenge result = challengeService.startChallenge(1L, 1L);

        assertNotNull(result);
        assertEquals(ChallengeStatus.STARTED, result.getStatus());
        verify(userChallengeRepository).save(any(UserDailyChallenge.class));
    }

    @Test
    void startChallenge_alreadyStarted_returnsExisting() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(challengeRepository.findById(1L)).thenReturn(Optional.of(challenge));
        when(userChallengeRepository.findByUserIdAndChallengeId(1L, 1L)).thenReturn(Optional.of(userChallenge));

        UserDailyChallenge result = challengeService.startChallenge(1L, 1L);

        assertNotNull(result);
        verify(userChallengeRepository, never()).save(any(UserDailyChallenge.class));
    }

    @Test
    void submitChallenge_success_firstAttempt_fullBonus() {
        when(userChallengeRepository.findByUserIdAndChallengeId(1L, 1L)).thenReturn(Optional.of(userChallenge));
        when(userChallengeRepository.save(any(UserDailyChallenge.class))).thenAnswer(i -> i.getArgument(0));
        when(gamificationService.addXp(anyLong(), anyInt(), anyString()))
            .thenReturn(new XpGainResult(150, 150, 1, false, 1, List.of()));

        ChallengeResult result = challengeService.submitChallenge(1L, 1L, "code", true);

        assertTrue(result.success());
        assertTrue(result.completed());
        assertEquals(150, result.xpEarned());
        verify(gamificationService).addXp(eq(1L), eq(150), anyString());
    }

    @Test
    void submitChallenge_success_threeAttempts_partialBonus() {
        userChallenge.setAttemptsCount(2);
        when(userChallengeRepository.findByUserIdAndChallengeId(1L, 1L)).thenReturn(Optional.of(userChallenge));
        when(userChallengeRepository.save(any(UserDailyChallenge.class))).thenAnswer(i -> i.getArgument(0));
        when(gamificationService.addXp(anyLong(), anyInt(), anyString()))
            .thenReturn(new XpGainResult(125, 125, 1, false, 1, List.of()));

        ChallengeResult result = challengeService.submitChallenge(1L, 1L, "code", true);

        assertTrue(result.success());
        assertEquals(125, result.xpEarned());
    }

    @Test
    void submitChallenge_success_manyAttempts_noBonus() {
        userChallenge.setAttemptsCount(5);
        when(userChallengeRepository.findByUserIdAndChallengeId(1L, 1L)).thenReturn(Optional.of(userChallenge));
        when(userChallengeRepository.save(any(UserDailyChallenge.class))).thenAnswer(i -> i.getArgument(0));
        when(gamificationService.addXp(anyLong(), anyInt(), anyString()))
            .thenReturn(new XpGainResult(100, 100, 1, false, 1, List.of()));

        ChallengeResult result = challengeService.submitChallenge(1L, 1L, "code", true);

        assertTrue(result.success());
        assertEquals(100, result.xpEarned());
    }

    @Test
    void submitChallenge_failure_noXp() {
        when(userChallengeRepository.findByUserIdAndChallengeId(1L, 1L)).thenReturn(Optional.of(userChallenge));
        when(userChallengeRepository.save(any(UserDailyChallenge.class))).thenAnswer(i -> i.getArgument(0));

        ChallengeResult result = challengeService.submitChallenge(1L, 1L, "code", false);

        assertFalse(result.success());
        assertEquals(0, result.xpEarned());
        verify(gamificationService, never()).addXp(anyLong(), anyInt(), anyString());
    }

    @Test
    void submitChallenge_alreadyCompleted_returnsZeroXp() {
        userChallenge.setStatus(ChallengeStatus.COMPLETED);
        when(userChallengeRepository.findByUserIdAndChallengeId(1L, 1L)).thenReturn(Optional.of(userChallenge));

        ChallengeResult result = challengeService.submitChallenge(1L, 1L, "code", true);

        assertTrue(result.success());
        assertEquals(0, result.xpEarned());
        assertFalse(result.completed());
    }

    @Test
    void getUserChallengeHistory_returnsList() {
        when(userChallengeRepository.findByUserIdOrderByStartedAtDesc(1L)).thenReturn(List.of(userChallenge));

        List<UserDailyChallenge> result = challengeService.getUserChallengeHistory(1L);

        assertEquals(1, result.size());
    }

    @Test
    void countCompletedChallenges_returnsCount() {
        when(userChallengeRepository.countByUserIdAndStatus(1L, ChallengeStatus.COMPLETED)).thenReturn(5L);

        long result = challengeService.countCompletedChallenges(1L);

        assertEquals(5, result);
    }
}
