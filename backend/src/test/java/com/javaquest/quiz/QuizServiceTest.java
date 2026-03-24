package com.javaquest.quiz;

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
 * Tests unitaires pour QuizService.
 */
@ExtendWith(MockitoExtension.class)
class QuizServiceTest {

    @Mock
    private QuizRepository quizRepository;

    @Mock
    private QuestionRepository questionRepository;

    @Mock
    private AnswerRepository answerRepository;

    @Mock
    private LessonRepository lessonRepository;

    @InjectMocks
    private QuizService quizService;

    private Quiz quiz;
    private Question question;
    private Lesson lesson;

    @BeforeEach
    void setUp() {
        lesson = new Lesson("Variables", "variables", "Content", 1);
        lesson.setId(1L);

        quiz = new Quiz("Java Basics Quiz", "Test your knowledge");
        quiz.setId(1L);
        quiz.setPassingScore(70);
        quiz.setXpReward(100);

        question = new Question("What is Java?", QuestionType.SINGLE_CHOICE, 1);
        question.setId(1L);
        question.setQuiz(quiz);
    }

    @Test
    void getAllQuizzes_returnsList() {
        // Given
        when(quizRepository.findAll()).thenReturn(List.of(quiz));

        // When
        List<Quiz> result = quizService.getAllQuizzes();

        // Then
        assertEquals(1, result.size());
        assertEquals("Java Basics Quiz", result.get(0).getTitle());
    }

    @Test
    void getQuizById_found_returnsQuiz() {
        // Given
        when(quizRepository.findById(1L)).thenReturn(Optional.of(quiz));

        // When
        Quiz result = quizService.getQuizById(1L);

        // Then
        assertNotNull(result);
        assertEquals("Java Basics Quiz", result.getTitle());
    }

    @Test
    void getQuizById_notFound_throwsException() {
        // Given
        when(quizRepository.findById(anyLong())).thenReturn(Optional.empty());

        // When & Then
        assertThrows(QuizException.class, () -> {
            quizService.getQuizById(99L);
        });
    }

    @Test
    void createQuiz_withoutLesson_success() {
        // Given
        when(quizRepository.save(any(Quiz.class))).thenAnswer(i -> i.getArgument(0));

        // When
        Quiz result = quizService.createQuiz("New Quiz", "Description", null, 300, 80, 150);

        // Then
        assertNotNull(result);
        assertEquals("New Quiz", result.getTitle());
        assertEquals(80, result.getPassingScore());
        assertEquals(150, result.getXpReward());
        assertNull(result.getLesson());
    }

    @Test
    void createQuiz_withLesson_success() {
        // Given
        when(lessonRepository.findById(1L)).thenReturn(Optional.of(lesson));
        when(quizRepository.save(any(Quiz.class))).thenAnswer(i -> i.getArgument(0));

        // When
        Quiz result = quizService.createQuiz("New Quiz", "Description", 1L, null, null, null);

        // Then
        assertNotNull(result);
        assertEquals(lesson, result.getLesson());
    }

    @Test
    void createQuiz_lessonNotFound_throwsException() {
        // Given
        when(lessonRepository.findById(anyLong())).thenReturn(Optional.empty());

        // When & Then
        assertThrows(CourseException.class, () -> {
            quizService.createQuiz("Quiz", "Desc", 99L, null, null, null);
        });
    }

    @Test
    void updateQuiz_success() {
        // Given
        when(quizRepository.findById(1L)).thenReturn(Optional.of(quiz));
        when(quizRepository.save(any(Quiz.class))).thenAnswer(i -> i.getArgument(0));

        // When
        Quiz result = quizService.updateQuiz(1L, "Updated Title", null, 600, 90, null);

        // Then
        assertEquals("Updated Title", result.getTitle());
        assertEquals(600, result.getTimeLimitSeconds());
        assertEquals(90, result.getPassingScore());
    }

    @Test
    void deleteQuiz_success() {
        // Given
        when(quizRepository.findById(1L)).thenReturn(Optional.of(quiz));

        // When
        quizService.deleteQuiz(1L);

        // Then
        verify(quizRepository).delete(quiz);
    }

    @Test
    void addQuestion_success() {
        // Given
        when(quizRepository.findById(1L)).thenReturn(Optional.of(quiz));
        when(quizRepository.save(any(Quiz.class))).thenAnswer(i -> i.getArgument(0));

        // When
        Question result = quizService.addQuestion(1L, "New question?", QuestionType.TRUE_FALSE, null, "Explanation", 1);

        // Then
        assertNotNull(result);
        assertEquals("New question?", result.getText());
        assertEquals(QuestionType.TRUE_FALSE, result.getQuestionType());
    }

    @Test
    void addAnswer_success() {
        // Given
        when(questionRepository.findById(1L)).thenReturn(Optional.of(question));
        when(questionRepository.save(any(Question.class))).thenAnswer(i -> i.getArgument(0));

        // When
        Answer result = quizService.addAnswer(1L, "Java is a programming language", true, 1);

        // Then
        assertNotNull(result);
        assertEquals("Java is a programming language", result.getText());
        assertTrue(result.getIsCorrect());
    }

    @Test
    void addAnswer_questionNotFound_throwsException() {
        // Given
        when(questionRepository.findById(anyLong())).thenReturn(Optional.empty());

        // When & Then
        assertThrows(QuizException.class, () -> {
            quizService.addAnswer(99L, "Answer", true, 1);
        });
    }

    @Test
    void getQuestionsByQuiz_returnsList() {
        // Given
        when(questionRepository.findByQuizIdOrderByOrderIndexAsc(1L)).thenReturn(List.of(question));

        // When
        List<Question> result = quizService.getQuestionsByQuiz(1L);

        // Then
        assertEquals(1, result.size());
    }

    @Test
    void getCorrectAnswers_returnsList() {
        // Given
        Answer correctAnswer = new Answer("Correct", true, 1);
        when(answerRepository.findByQuestionIdAndIsCorrectTrue(1L)).thenReturn(List.of(correctAnswer));

        // When
        List<Answer> result = quizService.getCorrectAnswers(1L);

        // Then
        assertEquals(1, result.size());
        assertTrue(result.get(0).getIsCorrect());
    }
}
