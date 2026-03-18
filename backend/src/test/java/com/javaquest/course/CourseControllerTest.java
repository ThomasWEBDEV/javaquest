package com.javaquest.course;

import com.fasterxml.jackson.databind.ObjectMapper;
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
 * Tests d'integration pour CourseController.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class CourseControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private ChapterRepository chapterRepository;

    @Autowired
    private LessonRepository lessonRepository;

    private Chapter testChapter;

    @BeforeEach
    void setUp() {
        lessonRepository.deleteAll();
        chapterRepository.deleteAll();

        testChapter = new Chapter("Java Basics", "java-basics", "Introduction to Java", 1);
        testChapter.setIsPublished(true);
        testChapter = chapterRepository.save(testChapter);
    }

    // ==================== Tests Chapitres ====================

    @Test
    void getPublishedChapters_returnsChapters() throws Exception {
        mockMvc.perform(get("/api/courses/chapters"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$[0].title").value("Java Basics"))
            .andExpect(jsonPath("$[0].slug").value("java-basics"));
    }

    @Test
    void getPublishedChapters_excludesUnpublished() throws Exception {
        // Given - chapitre non publie
        Chapter unpublished = new Chapter("Draft", "draft", "Draft chapter", 2);
        unpublished.setIsPublished(false);
        chapterRepository.save(unpublished);

        // When & Then
        mockMvc.perform(get("/api/courses/chapters"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.length()").value(1));
    }

    @Test
    void getAllChapters_returnsAllChapters() throws Exception {
        // Given - chapitre non publie
        Chapter unpublished = new Chapter("Draft", "draft", "Draft chapter", 2);
        unpublished.setIsPublished(false);
        chapterRepository.save(unpublished);

        // When & Then
        mockMvc.perform(get("/api/courses/chapters/all"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.length()").value(2));
    }

    @Test
    void getChapterBySlug_found_returnsChapter() throws Exception {
        mockMvc.perform(get("/api/courses/chapters/java-basics"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.title").value("Java Basics"))
            .andExpect(jsonPath("$.description").value("Introduction to Java"));
    }

    @Test
    void getChapterBySlug_notFound_returns404() throws Exception {
        mockMvc.perform(get("/api/courses/chapters/unknown"))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.error").value("Chapitre non trouvé"));
    }

    @Test
    void createChapter_success() throws Exception {
        CreateChapterRequest request = new CreateChapterRequest(
            "Advanced Java", "advanced-java", "Advanced topics", 2
        );

        mockMvc.perform(post("/api/courses/chapters")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.title").value("Advanced Java"))
            .andExpect(jsonPath("$.slug").value("advanced-java"));
    }

    @Test
    void createChapter_duplicateSlug_returnsError() throws Exception {
        CreateChapterRequest request = new CreateChapterRequest(
            "Another", "java-basics", "Description", 2
        );

        mockMvc.perform(post("/api/courses/chapters")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.error").value("Ce slug existe déjà"));
    }

    @Test
    void createChapter_missingTitle_returnsBadRequest() throws Exception {
        String invalidRequest = "{\"slug\": \"test\", \"orderIndex\": 1}";

        mockMvc.perform(post("/api/courses/chapters")
                .contentType(MediaType.APPLICATION_JSON)
                .content(invalidRequest))
            .andExpect(status().isBadRequest());
    }

    @Test
    void updateChapter_success() throws Exception {
        UpdateChapterRequest request = new UpdateChapterRequest(
            "Updated Title", "Updated description", 150, true
        );

        mockMvc.perform(put("/api/courses/chapters/" + testChapter.getId())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.title").value("Updated Title"))
            .andExpect(jsonPath("$.xpReward").value(150));
    }

    @Test
    void deleteChapter_success() throws Exception {
        mockMvc.perform(delete("/api/courses/chapters/" + testChapter.getId()))
            .andExpect(status().isNoContent());

        mockMvc.perform(get("/api/courses/chapters/java-basics"))
            .andExpect(status().isNotFound());
    }

    // ==================== Tests Lecons ====================

    @Test
    void getLessonsByChapter_returnsLessons() throws Exception {
        // Given
        Lesson lesson = new Lesson("Variables", "variables", "Content", 1);
        lesson.setChapter(testChapter);
        lessonRepository.save(lesson);

        // When & Then
        mockMvc.perform(get("/api/courses/chapters/" + testChapter.getId() + "/lessons"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$[0].title").value("Variables"));
    }

    @Test
    void getLessonById_found_returnsLesson() throws Exception {
        // Given
        Lesson lesson = new Lesson("Variables", "variables", "Content", 1);
        lesson.setChapter(testChapter);
        lesson = lessonRepository.save(lesson);

        // When & Then
        mockMvc.perform(get("/api/courses/lessons/" + lesson.getId()))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.title").value("Variables"));
    }

    @Test
    void getLessonById_notFound_returns404() throws Exception {
        mockMvc.perform(get("/api/courses/lessons/999"))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.error").value("Leçon non trouvée"));
    }

    @Test
    void createLesson_success() throws Exception {
        CreateLessonRequest request = new CreateLessonRequest(
            "Variables", "variables", "Content about variables", 1
        );

        mockMvc.perform(post("/api/courses/chapters/" + testChapter.getId() + "/lessons")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.title").value("Variables"))
            .andExpect(jsonPath("$.slug").value("variables"));
    }

    @Test
    void createLesson_duplicateSlug_returnsError() throws Exception {
        // Given - lecon existante
        Lesson existing = new Lesson("Variables", "variables", "Content", 1);
        existing.setChapter(testChapter);
        lessonRepository.save(existing);

        CreateLessonRequest request = new CreateLessonRequest(
            "Another", "variables", "Content", 2
        );

        // When & Then
        mockMvc.perform(post("/api/courses/chapters/" + testChapter.getId() + "/lessons")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.error").value("Ce slug existe déjà dans ce chapitre"));
    }

    @Test
    void updateLesson_success() throws Exception {
        // Given
        Lesson lesson = new Lesson("Variables", "variables", "Content", 1);
        lesson.setChapter(testChapter);
        lesson = lessonRepository.save(lesson);

        UpdateLessonRequest request = new UpdateLessonRequest(
            "Updated Variables", "New content", 50
        );

        // When & Then
        mockMvc.perform(put("/api/courses/lessons/" + lesson.getId())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.title").value("Updated Variables"))
            .andExpect(jsonPath("$.xpReward").value(50));
    }

    @Test
    void deleteLesson_success() throws Exception {
        // Given
        Lesson lesson = new Lesson("Variables", "variables", "Content", 1);
        lesson.setChapter(testChapter);
        lesson = lessonRepository.save(lesson);

        // When & Then
        mockMvc.perform(delete("/api/courses/lessons/" + lesson.getId()))
            .andExpect(status().isNoContent());
    }
}
