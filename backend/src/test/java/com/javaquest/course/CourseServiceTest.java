package com.javaquest.course;

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
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

/**
 * Tests unitaires pour CourseService.
 */
@ExtendWith(MockitoExtension.class)
class CourseServiceTest {

    @Mock
    private ChapterRepository chapterRepository;

    @Mock
    private LessonRepository lessonRepository;

    @InjectMocks
    private CourseService courseService;

    private Chapter chapter;
    private Lesson lesson;

    @BeforeEach
    void setUp() {
        chapter = new Chapter("Java Basics", "java-basics", "Introduction to Java", 1);
        chapter.setId(1L);

        lesson = new Lesson("Variables", "variables", "Content about variables", 1);
        lesson.setId(1L);
        lesson.setChapter(chapter);
    }

    // ==================== Tests Chapitres ====================

    @Test
    void getPublishedChapters_returnsList() {
        // Given
        when(chapterRepository.findByIsPublishedTrueOrderByOrderIndexAsc())
            .thenReturn(List.of(chapter));

        // When
        List<Chapter> result = courseService.getPublishedChapters();

        // Then
        assertEquals(1, result.size());
        assertEquals("Java Basics", result.get(0).getTitle());
    }

    @Test
    void getAllChapters_returnsList() {
        // Given
        when(chapterRepository.findAllByOrderByOrderIndexAsc())
            .thenReturn(List.of(chapter));

        // When
        List<Chapter> result = courseService.getAllChapters();

        // Then
        assertEquals(1, result.size());
    }

    @Test
    void getChapterById_found_returnsChapter() {
        // Given
        when(chapterRepository.findById(1L)).thenReturn(Optional.of(chapter));

        // When
        Chapter result = courseService.getChapterById(1L);

        // Then
        assertNotNull(result);
        assertEquals("Java Basics", result.getTitle());
    }

    @Test
    void getChapterById_notFound_throwsException() {
        // Given
        when(chapterRepository.findById(anyLong())).thenReturn(Optional.empty());

        // When & Then
        CourseException exception = assertThrows(CourseException.class, () -> {
            courseService.getChapterById(99L);
        });
        assertEquals("Chapitre non trouvé", exception.getMessage());
    }

    @Test
    void getChapterBySlug_found_returnsChapter() {
        // Given
        when(chapterRepository.findBySlug("java-basics")).thenReturn(Optional.of(chapter));

        // When
        Chapter result = courseService.getChapterBySlug("java-basics");

        // Then
        assertNotNull(result);
        assertEquals("java-basics", result.getSlug());
    }

    @Test
    void getChapterBySlug_notFound_throwsException() {
        // Given
        when(chapterRepository.findBySlug(anyString())).thenReturn(Optional.empty());

        // When & Then
        assertThrows(CourseException.class, () -> {
            courseService.getChapterBySlug("unknown");
        });
    }

    @Test
    void createChapter_success() {
        // Given
        when(chapterRepository.existsBySlug("new-chapter")).thenReturn(false);
        when(chapterRepository.save(any(Chapter.class))).thenAnswer(i -> i.getArgument(0));

        // When
        Chapter result = courseService.createChapter("New Chapter", "new-chapter", "Description", 2);

        // Then
        assertNotNull(result);
        assertEquals("New Chapter", result.getTitle());
        verify(chapterRepository).save(any(Chapter.class));
    }

    @Test
    void createChapter_slugExists_throwsException() {
        // Given
        when(chapterRepository.existsBySlug("java-basics")).thenReturn(true);

        // When & Then
        CourseException exception = assertThrows(CourseException.class, () -> {
            courseService.createChapter("Title", "java-basics", "Desc", 1);
        });
        assertEquals("Ce slug existe déjà", exception.getMessage());
        verify(chapterRepository, never()).save(any());
    }

    @Test
    void updateChapter_success() {
        // Given
        when(chapterRepository.findById(1L)).thenReturn(Optional.of(chapter));
        when(chapterRepository.save(any(Chapter.class))).thenAnswer(i -> i.getArgument(0));

        // When
        Chapter result = courseService.updateChapter(1L, "Updated Title", null, 150, true);

        // Then
        assertEquals("Updated Title", result.getTitle());
        assertEquals(150, result.getXpReward());
        assertTrue(result.getIsPublished());
    }

    @Test
    void deleteChapter_success() {
        // Given
        when(chapterRepository.findById(1L)).thenReturn(Optional.of(chapter));

        // When
        courseService.deleteChapter(1L);

        // Then
        verify(chapterRepository).delete(chapter);
    }

    // ==================== Tests Lecons ====================

    @Test
    void getLessonsByChapter_returnsList() {
        // Given
        when(chapterRepository.findById(1L)).thenReturn(Optional.of(chapter));
        when(lessonRepository.findByChapterIdOrderByOrderIndexAsc(1L))
            .thenReturn(List.of(lesson));

        // When
        List<Lesson> result = courseService.getLessonsByChapter(1L);

        // Then
        assertEquals(1, result.size());
        assertEquals("Variables", result.get(0).getTitle());
    }

    @Test
    void getLessonById_found_returnsLesson() {
        // Given
        when(lessonRepository.findById(1L)).thenReturn(Optional.of(lesson));

        // When
        Lesson result = courseService.getLessonById(1L);

        // Then
        assertNotNull(result);
        assertEquals("Variables", result.getTitle());
    }

    @Test
    void getLessonById_notFound_throwsException() {
        // Given
        when(lessonRepository.findById(anyLong())).thenReturn(Optional.empty());

        // When & Then
        assertThrows(CourseException.class, () -> {
            courseService.getLessonById(99L);
        });
    }

    @Test
    void createLesson_success() {
        // Given
        when(chapterRepository.findById(1L)).thenReturn(Optional.of(chapter));
        when(lessonRepository.existsByChapterIdAndSlug(1L, "new-lesson")).thenReturn(false);
        when(lessonRepository.save(any(Lesson.class))).thenAnswer(i -> i.getArgument(0));

        // When
        Lesson result = courseService.createLesson(1L, "New Lesson", "new-lesson", "Content", 2);

        // Then
        assertNotNull(result);
        assertEquals("New Lesson", result.getTitle());
        verify(lessonRepository).save(any(Lesson.class));
    }

    @Test
    void createLesson_slugExists_throwsException() {
        // Given
        when(chapterRepository.findById(1L)).thenReturn(Optional.of(chapter));
        when(lessonRepository.existsByChapterIdAndSlug(1L, "variables")).thenReturn(true);

        // When & Then
        CourseException exception = assertThrows(CourseException.class, () -> {
            courseService.createLesson(1L, "Title", "variables", "Content", 1);
        });
        assertEquals("Ce slug existe déjà dans ce chapitre", exception.getMessage());
    }

    @Test
    void updateLesson_success() {
        // Given
        when(lessonRepository.findById(1L)).thenReturn(Optional.of(lesson));
        when(lessonRepository.save(any(Lesson.class))).thenAnswer(i -> i.getArgument(0));

        // When
        Lesson result = courseService.updateLesson(1L, "Updated Title", "New content", 50);

        // Then
        assertEquals("Updated Title", result.getTitle());
        assertEquals("New content", result.getContent());
        assertEquals(50, result.getXpReward());
    }

    @Test
    void deleteLesson_success() {
        // Given
        when(lessonRepository.findById(1L)).thenReturn(Optional.of(lesson));

        // When
        courseService.deleteLesson(1L);

        // Then
        verify(lessonRepository).delete(lesson);
    }
}
