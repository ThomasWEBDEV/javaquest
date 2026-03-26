package com.javaquest.dashboard;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.javaquest.course.Chapter;
import com.javaquest.course.ChapterRepository;
import com.javaquest.course.Lesson;
import com.javaquest.course.LessonRepository;
import com.javaquest.exercise.Difficulty;
import com.javaquest.exercise.Exercise;
import com.javaquest.exercise.ExerciseRepository;
import com.javaquest.quiz.Quiz;
import com.javaquest.quiz.QuizRepository;
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
 * Tests d'integration pour DashboardController.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class DashboardControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ExerciseRepository exerciseRepository;

    @Autowired
    private QuizRepository quizRepository;

    @Autowired
    private ChapterRepository chapterRepository;

    @Autowired
    private LessonRepository lessonRepository;

    @Autowired
    private UserExerciseProgressRepository exerciseProgressRepository;

    @Autowired
    private UserQuizAttemptRepository quizAttemptRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private User testUser;
    private Exercise testExercise;
    private Quiz testQuiz;

    @BeforeEach
    void setUp() {
        quizAttemptRepository.deleteAll();
        exerciseProgressRepository.deleteAll();
        exerciseRepository.deleteAll();
        quizRepository.deleteAll();
        lessonRepository.deleteAll();
        chapterRepository.deleteAll();
        userRepository.deleteAll();

        testUser = new User();
        testUser.setUsername("testuser");
        testUser.setEmail("test@test.com");
        testUser.setPasswordHash(passwordEncoder.encode("password"));
        testUser = userRepository.save(testUser);

        Chapter chapter = new Chapter("Java Basics", "java-basics", "Description", 1);
        chapter = chapterRepository.save(chapter);

        Lesson lesson = new Lesson("Variables", "variables", "Content", 1);
        lesson.setChapter(chapter);
        lesson = lessonRepository.save(lesson);

        testExercise = new Exercise("Test Exercise", "Description", "starter", "solution", "test", 1);
        testExercise.setLesson(lesson);
        testExercise.setDifficulty(Difficulty.EASY);
        testExercise.setXpReward(50);
        testExercise = exerciseRepository.save(testExercise);

        testQuiz = new Quiz("Test Quiz", "Description");
        testQuiz.setPassingScore(70);
        testQuiz.setXpReward(100);
        testQuiz = quizRepository.save(testQuiz);
    }

    @Test
    void getStats_returnsStats() throws Exception {
        mockMvc.perform(get("/api/dashboard/" + testUser.getId() + "/stats"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.totalXp").exists())
            .andExpect(jsonPath("$.currentLevel").exists())
            .andExpect(jsonPath("$.exercisesCompleted").value(0));
    }

    @Test
    void recordExerciseAttempt_success() throws Exception {
        ExerciseAttemptRequest request = new ExerciseAttemptRequest("int x = 5;", false);

        mockMvc.perform(post("/api/dashboard/" + testUser.getId() + "/exercises/" + testExercise.getId() + "/attempt")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.status").value("IN_PROGRESS"))
            .andExpect(jsonPath("$.attemptsCount").value(1));
    }

    @Test
    void recordExerciseAttempt_completed() throws Exception {
        ExerciseAttemptRequest request = new ExerciseAttemptRequest("int x = 5;", true);

        mockMvc.perform(post("/api/dashboard/" + testUser.getId() + "/exercises/" + testExercise.getId() + "/attempt")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.status").value("COMPLETED"));
    }

    @Test
    void recordExerciseAttempt_multipleAttempts_incrementsCount() throws Exception {
        ExerciseAttemptRequest request = new ExerciseAttemptRequest("code", false);

        // First attempt
        mockMvc.perform(post("/api/dashboard/" + testUser.getId() + "/exercises/" + testExercise.getId() + "/attempt")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.attemptsCount").value(1));

        // Second attempt
        mockMvc.perform(post("/api/dashboard/" + testUser.getId() + "/exercises/" + testExercise.getId() + "/attempt")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.attemptsCount").value(2));
    }

    @Test
    void getExerciseProgress_notFound_returns404() throws Exception {
        mockMvc.perform(get("/api/dashboard/" + testUser.getId() + "/exercises/999/progress"))
            .andExpect(status().isNotFound());
    }

    @Test
    void getExerciseProgress_found_returnsProgress() throws Exception {
        // Create progress first
        ExerciseAttemptRequest request = new ExerciseAttemptRequest("code", false);
        mockMvc.perform(post("/api/dashboard/" + testUser.getId() + "/exercises/" + testExercise.getId() + "/attempt")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)));

        // Get progress
        mockMvc.perform(get("/api/dashboard/" + testUser.getId() + "/exercises/" + testExercise.getId() + "/progress"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.exerciseId").value(testExercise.getId()));
    }

    @Test
    void getExercisesInProgress_returnsEmptyList() throws Exception {
        mockMvc.perform(get("/api/dashboard/" + testUser.getId() + "/exercises/in-progress"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$").isArray())
            .andExpect(jsonPath("$").isEmpty());
    }

    @Test
    void getExercisesInProgress_returnsInProgressExercises() throws Exception {
        // Create in-progress exercise
        ExerciseAttemptRequest request = new ExerciseAttemptRequest("code", false);
        mockMvc.perform(post("/api/dashboard/" + testUser.getId() + "/exercises/" + testExercise.getId() + "/attempt")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)));

        mockMvc.perform(get("/api/dashboard/" + testUser.getId() + "/exercises/in-progress"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$[0].status").value("IN_PROGRESS"));
    }

    @Test
    void getQuizHistory_returnsEmptyList() throws Exception {
        mockMvc.perform(get("/api/dashboard/" + testUser.getId() + "/quizzes/history"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$").isArray())
            .andExpect(jsonPath("$").isEmpty());
    }

    @Test
    void getBestQuizAttempt_notFound_returns404() throws Exception {
        mockMvc.perform(get("/api/dashboard/" + testUser.getId() + "/quizzes/" + testQuiz.getId() + "/best"))
            .andExpect(status().isNotFound());
    }
}
