package com.javaquest.exercise;

import com.javaquest.course.Lesson;
import com.javaquest.course.LessonRepository;
import com.javaquest.course.CourseException;
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
import static org.mockito.Mockito.*;

/**
 * Tests unitaires pour ExerciseService.
 */
@ExtendWith(MockitoExtension.class)
class ExerciseServiceTest {

    @Mock
    private ExerciseRepository exerciseRepository;

    @Mock
    private LessonRepository lessonRepository;

    @InjectMocks
    private ExerciseService exerciseService;

    private Exercise exercise;
    private Lesson lesson;

    @BeforeEach
    void setUp() {
        lesson = new Lesson("Variables", "variables", "Content", 1);
        lesson.setId(1L);

        exercise = new Exercise("Addition", "Additionner deux nombres", 
            "int a = 1;", "int result = a + b;", "assert result == 3;", 1);
        exercise.setId(1L);
        exercise.setLesson(lesson);
    }

    @Test
    void getExercisesByLesson_returnsList() {
        // Given
        when(exerciseRepository.findByLessonIdOrderByOrderIndexAsc(1L))
            .thenReturn(List.of(exercise));

        // When
        List<Exercise> result = exerciseService.getExercisesByLesson(1L);

        // Then
        assertEquals(1, result.size());
        assertEquals("Addition", result.get(0).getTitle());
    }

    @Test
    void getExerciseById_found_returnsExercise() {
        // Given
        when(exerciseRepository.findById(1L)).thenReturn(Optional.of(exercise));

        // When
        Exercise result = exerciseService.getExerciseById(1L);

        // Then
        assertNotNull(result);
        assertEquals("Addition", result.getTitle());
    }

    @Test
    void getExerciseById_notFound_throwsException() {
        // Given
        when(exerciseRepository.findById(anyLong())).thenReturn(Optional.empty());

        // When & Then
        assertThrows(ExerciseException.class, () -> {
            exerciseService.getExerciseById(99L);
        });
    }

    @Test
    void createExercise_success() {
        // Given
        when(lessonRepository.findById(1L)).thenReturn(Optional.of(lesson));
        when(exerciseRepository.save(any(Exercise.class))).thenAnswer(i -> i.getArgument(0));

        // When
        Exercise result = exerciseService.createExercise(
            1L, "New Exercise", "Description", "starter", "solution", "test",
            "hints", Difficulty.EASY, 50, 1
        );

        // Then
        assertNotNull(result);
        assertEquals("New Exercise", result.getTitle());
        assertEquals(Difficulty.EASY, result.getDifficulty());
        verify(exerciseRepository).save(any(Exercise.class));
    }

    @Test
    void createExercise_lessonNotFound_throwsException() {
        // Given
        when(lessonRepository.findById(anyLong())).thenReturn(Optional.empty());

        // When & Then
        assertThrows(CourseException.class, () -> {
            exerciseService.createExercise(99L, "Title", "Desc", null, "sol", "test", null, null, null, 1);
        });
    }

    @Test
    void createExercise_defaultValues() {
        // Given
        when(lessonRepository.findById(1L)).thenReturn(Optional.of(lesson));
        when(exerciseRepository.save(any(Exercise.class))).thenAnswer(i -> i.getArgument(0));

        // When
        Exercise result = exerciseService.createExercise(
            1L, "Exercise", "Desc", null, "solution", "test", null, null, null, 1
        );

        // Then
        assertEquals(Difficulty.EASY, result.getDifficulty());
        assertEquals(50, result.getXpReward());
    }

    @Test
    void updateExercise_success() {
        // Given
        when(exerciseRepository.findById(1L)).thenReturn(Optional.of(exercise));
        when(exerciseRepository.save(any(Exercise.class))).thenAnswer(i -> i.getArgument(0));

        // When
        Exercise result = exerciseService.updateExercise(
            1L, "Updated Title", null, null, null, null, null, Difficulty.HARD, 100
        );

        // Then
        assertEquals("Updated Title", result.getTitle());
        assertEquals(Difficulty.HARD, result.getDifficulty());
        assertEquals(100, result.getXpReward());
    }

    @Test
    void deleteExercise_success() {
        // Given
        when(exerciseRepository.findById(1L)).thenReturn(Optional.of(exercise));

        // When
        exerciseService.deleteExercise(1L);

        // Then
        verify(exerciseRepository).delete(exercise);
    }

    @Test
    void getExercisesByDifficulty_returnsList() {
        // Given
        when(exerciseRepository.findByDifficulty(Difficulty.EASY))
            .thenReturn(List.of(exercise));

        // When
        List<Exercise> result = exerciseService.getExercisesByDifficulty(Difficulty.EASY);

        // Then
        assertEquals(1, result.size());
    }
}
