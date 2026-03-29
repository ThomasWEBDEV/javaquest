package com.javaquest.challenge;

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

import java.time.LocalDate;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class ChallengeControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private DailyChallengeRepository challengeRepository;

    @Autowired
    private UserDailyChallengeRepository userChallengeRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private User testUser;
    private DailyChallenge todayChallenge;

    @BeforeEach
    void setUp() {
        userChallengeRepository.deleteAll();
        challengeRepository.deleteAll();
        userRepository.deleteAll();

        testUser = new User();
        testUser.setUsername("testuser");
        testUser.setEmail("test@test.com");
        testUser.setPasswordHash(passwordEncoder.encode("password"));
        testUser = userRepository.save(testUser);

        todayChallenge = new DailyChallenge(
            LocalDate.now(), "Today Challenge", "Description", "solution", "test"
        );
        todayChallenge.setXpReward(100);
        todayChallenge.setBonusXp(50);
        todayChallenge = challengeRepository.save(todayChallenge);
    }

    @Test
    void getTodayChallenge_exists_returnsChallenge() throws Exception {
        mockMvc.perform(get("/api/challenges/today"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.title").value("Today Challenge"))
            .andExpect(jsonPath("$.isToday").value(true));
    }

    @Test
    void getChallengeById_found_returnsChallenge() throws Exception {
        mockMvc.perform(get("/api/challenges/" + todayChallenge.getId()))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.title").value("Today Challenge"));
    }

    @Test
    void getChallengeById_notFound_returns404() throws Exception {
        mockMvc.perform(get("/api/challenges/999"))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.error").value("Defi non trouve"));
    }

    @Test
    void getRecentChallenges_returnsList() throws Exception {
        mockMvc.perform(get("/api/challenges/recent?days=7"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$[0].title").value("Today Challenge"));
    }

    @Test
    void createChallenge_success() throws Exception {
        CreateChallengeRequest request = new CreateChallengeRequest(
            LocalDate.now().plusDays(1), "Tomorrow Challenge", "Desc",
            "starter", "solution", "test", "hints", 100, 50
        );

        mockMvc.perform(post("/api/challenges")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.title").value("Tomorrow Challenge"));
    }

    @Test
    void createChallenge_duplicateDate_returns404() throws Exception {
        CreateChallengeRequest request = new CreateChallengeRequest(
            LocalDate.now(), "Duplicate", "Desc",
            null, "solution", "test", null, null, null
        );

        mockMvc.perform(post("/api/challenges")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.error").value("Un defi existe deja pour cette date"));
    }

    @Test
    void startChallenge_success() throws Exception {
        mockMvc.perform(post("/api/challenges/" + todayChallenge.getId() + "/start/" + testUser.getId()))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.status").value("STARTED"))
            .andExpect(jsonPath("$.attemptsCount").value(0));
    }

    @Test
    void startChallenge_alreadyStarted_returnsExisting() throws Exception {
        // Start once
        mockMvc.perform(post("/api/challenges/" + todayChallenge.getId() + "/start/" + testUser.getId()));

        // Start again
        mockMvc.perform(post("/api/challenges/" + todayChallenge.getId() + "/start/" + testUser.getId()))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.status").value("STARTED"));
    }

    @Test
    void submitChallenge_success() throws Exception {
        // Start first
        mockMvc.perform(post("/api/challenges/" + todayChallenge.getId() + "/start/" + testUser.getId()));

        SubmitChallengeRequest request = new SubmitChallengeRequest("code", true);

        mockMvc.perform(post("/api/challenges/" + todayChallenge.getId() + "/submit/" + testUser.getId())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.completed").value(true))
            .andExpect(jsonPath("$.xpEarned").value(150));
    }

    @Test
    void submitChallenge_failure() throws Exception {
        mockMvc.perform(post("/api/challenges/" + todayChallenge.getId() + "/start/" + testUser.getId()));

        SubmitChallengeRequest request = new SubmitChallengeRequest("wrong code", false);

        mockMvc.perform(post("/api/challenges/" + todayChallenge.getId() + "/submit/" + testUser.getId())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(false))
            .andExpect(jsonPath("$.xpEarned").value(0));
    }

    @Test
    void getUserChallenge_notFound_returns404() throws Exception {
        mockMvc.perform(get("/api/challenges/" + todayChallenge.getId() + "/user/" + testUser.getId()))
            .andExpect(status().isNotFound());
    }

    @Test
    void getUserChallenge_found_returnsParticipation() throws Exception {
        mockMvc.perform(post("/api/challenges/" + todayChallenge.getId() + "/start/" + testUser.getId()));

        mockMvc.perform(get("/api/challenges/" + todayChallenge.getId() + "/user/" + testUser.getId()))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.challengeTitle").value("Today Challenge"));
    }

    @Test
    void getUserHistory_returnsEmptyList() throws Exception {
        mockMvc.perform(get("/api/challenges/user/" + testUser.getId() + "/history"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$").isArray())
            .andExpect(jsonPath("$").isEmpty());
    }

    @Test
    void getUserHistory_returnsHistory() throws Exception {
        mockMvc.perform(post("/api/challenges/" + todayChallenge.getId() + "/start/" + testUser.getId()));

        mockMvc.perform(get("/api/challenges/user/" + testUser.getId() + "/history"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$[0].challengeTitle").value("Today Challenge"));
    }
}
