package com.javaquest.gamification;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.javaquest.user.User;
import com.javaquest.user.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests d'integration pour GamificationController.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class GamificationControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserProgressRepository userProgressRepository;

    @Autowired
    private BadgeRepository badgeRepository;

    @Autowired
    private UserBadgeRepository userBadgeRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private User testUser;

    @BeforeEach
    void setUp() {
        userBadgeRepository.deleteAll();
        userProgressRepository.deleteAll();
        badgeRepository.deleteAll();
        userRepository.deleteAll();

        testUser = new User();
        testUser.setUsername("testuser");
        testUser.setEmail("test@test.com");
        testUser.setPasswordHash(passwordEncoder.encode("password"));
        testUser = userRepository.save(testUser);
    }

    @Test
    void getProgress_createsNewProgress() throws Exception {
        mockMvc.perform(get("/api/gamification/progress/" + testUser.getId()))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.userId").value(testUser.getId()))
            .andExpect(jsonPath("$.totalXp").value(0))
            .andExpect(jsonPath("$.currentLevel").value(1));
    }

    @Test
    void getProgress_existingProgress_returnsProgress() throws Exception {
        UserProgress progress = new UserProgress(testUser);
        progress.setTotalXp(500);
        progress.setCurrentLevel(1);
        userProgressRepository.save(progress);

        mockMvc.perform(get("/api/gamification/progress/" + testUser.getId()))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.totalXp").value(500));
    }

    @Test
    void addXp_success() throws Exception {
        AddXpRequest request = new AddXpRequest(100, "Exercise completed");

        mockMvc.perform(post("/api/gamification/xp/" + testUser.getId())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.xpGained").value(100))
            .andExpect(jsonPath("$.totalXp").value(100));
    }

    @Test
    void addXp_levelUp() throws Exception {
        UserProgress progress = new UserProgress(testUser);
        progress.setTotalXp(950);
        progress.setCurrentLevel(1);
        userProgressRepository.save(progress);

        AddXpRequest request = new AddXpRequest(100, "Level up test");

        mockMvc.perform(post("/api/gamification/xp/" + testUser.getId())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.leveledUp").value(true))
            .andExpect(jsonPath("$.currentLevel").value(2));
    }

    @Test
    void addXp_invalidXp_returnsBadRequest() throws Exception {
        AddXpRequest request = new AddXpRequest(0, "Invalid");

        mockMvc.perform(post("/api/gamification/xp/" + testUser.getId())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isBadRequest());
    }

    @Test
    void getUserBadges_empty_returnsEmptyList() throws Exception {
        mockMvc.perform(get("/api/gamification/badges/" + testUser.getId()))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$").isArray())
            .andExpect(jsonPath("$").isEmpty());
    }

    @Test
    void getUserBadges_withBadges_returnsBadges() throws Exception {
        Badge badge = new Badge("First Steps", "Complete first exercise", BadgeCriteria.XP_TOTAL, 100);
        badge = badgeRepository.save(badge);

        UserBadge userBadge = new UserBadge(testUser, badge);
        userBadgeRepository.save(userBadge);

        mockMvc.perform(get("/api/gamification/badges/" + testUser.getId()))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$[0].name").value("First Steps"));
    }

    @Test
    void getAllBadges_returnsAllBadges() throws Exception {
        Badge badge1 = new Badge("First Steps", "Complete first exercise", BadgeCriteria.XP_TOTAL, 100);
        Badge badge2 = new Badge("Level 5", "Reach level 5", BadgeCriteria.LEVEL_REACHED, 5);
        badgeRepository.save(badge1);
        badgeRepository.save(badge2);

        mockMvc.perform(get("/api/gamification/badges"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.length()").value(2));
    }

    @Test
    void addXp_awardsBadge() throws Exception {
        Badge badge = new Badge("Starter", "Earn 50 XP", BadgeCriteria.XP_TOTAL, 50);
        badgeRepository.save(badge);

        AddXpRequest request = new AddXpRequest(100, "Should earn badge");

        mockMvc.perform(post("/api/gamification/xp/" + testUser.getId())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.newBadges[0].name").value("Starter"));
    }
}
