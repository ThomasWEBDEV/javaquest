package com.javaquest.exercise;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.javaquest.course.Chapter;
import com.javaquest.course.ChapterRepository;
import com.javaquest.course.Lesson;
import com.javaquest.course.LessonRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests d'integration pour ExerciseController.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class ExerciseControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private ExerciseRepository exerciseRepository;

    @Autowired
    private LessonRepository lessonRepository;

    @Autowired
    private ChapterRepository chapterRepository;

    private Lesson testLesson;
    private Exercise testExercise;

    @BeforeEach
    void setUp() {
        exerciseRepository.deleteAll();
        lessonRepository.deleteAll();
        chapterRepository.deleteAll();

        Chapter chapter = new Chapter("Java Basics", "java-basics", "Description", 1);
        chapter = chapterRepository.save(chapter);

        testLesson = new Lesson("Variables", "variables", "Content", 1);
        testLesson.setChapter(chapter);
        testLesson = lessonRepository.save(testLesson);

        testExercise = new Exercise("Addition", "Add two numbers", "int a = 1;", 
            "int result = a + b;", "assert result == 3;", 1);
        testExercise.setLesson(testLesson);
        testExercise.setDifficulty(Difficulty.EASY);
        testExercise = exerciseRepository.save(testExercise);
    }

    @Test
    void getExercisesByLesson_returnsExercises() throws Exception {
        mockMvc.perform(get("/api/exercises/lesson/" + testLesson.getId()))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$[0].title").value("Addition"));
    }

    @Test
    void getExerciseById_found_returnsExercise() throws Exception {
        mockMvc.perform(get("/api/exercises/" + testExercise.getId()))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.title").value("Addition"))
            .andExpect(jsonPath("$.difficulty").value("EASY"));
    }

    @Test
    void getExerciseById_notFound_returns404() throws Exception {
        mockMvc.perform(get("/api/exercises/999"))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.error").value("Exercice non trouve"));
    }

    @Test
    void createExercise_success() throws Exception {
        CreateExerciseRequest request = new CreateExerciseRequest(
            "Soustraction", "Subtract two numbers", "int a = 5;",
            "int result = a - b;", "assert result == 2;", "Think about it",
            Difficulty.MEDIUM, 75, 2
        );

        mockMvc.perform(post("/api/exercises/lesson/" + testLesson.getId())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.title").value("Soustraction"))
            .andExpect(jsonPath("$.difficulty").value("MEDIUM"))
            .andExpect(jsonPath("$.xpReward").value(75));
    }

    @Test
    void createExercise_missingTitle_returnsBadRequest() throws Exception {
        String invalidRequest = """
            {
                "description": "Desc",
                "solutionCode": "solution",
                "testCode": "test",
                "orderIndex": 1
            }
            """;

        mockMvc.perform(post("/api/exercises/lesson/" + testLesson.getId())
                .contentType(MediaType.APPLICATION_JSON)
                .content(invalidRequest))
            .andExpect(status().isBadRequest());
    }

    @Test
    void updateExercise_success() throws Exception {
        UpdateExerciseRequest request = new UpdateExerciseRequest(
            "Updated Title", null, null, null, null, null, Difficulty.HARD, 100
        );

        mockMvc.perform(put("/api/exercises/" + testExercise.getId())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.title").value("Updated Title"))
            .andExpect(jsonPath("$.difficulty").value("HARD"))
            .andExpect(jsonPath("$.xpReward").value(100));
    }

    @Test
    void deleteExercise_success() throws Exception {
        mockMvc.perform(delete("/api/exercises/" + testExercise.getId()))
            .andExpect(status().isNoContent());

        mockMvc.perform(get("/api/exercises/" + testExercise.getId()))
            .andExpect(status().isNotFound());
    }

    @Test
    void getExercisesByDifficulty_returnsExercises() throws Exception {
        mockMvc.perform(get("/api/exercises/difficulty/EASY"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$[0].difficulty").value("EASY"));
    }
}
