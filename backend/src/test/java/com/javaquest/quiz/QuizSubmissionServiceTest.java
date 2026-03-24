package com.javaquest.quiz;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * Tests unitaires pour QuizSubmissionService.
 */
@ExtendWith(MockitoExtension.class)
class QuizSubmissionServiceTest {

    @Mock
    private QuizService quizService;

    @Mock
    private QuestionRepository questionRepository;

    @Mock
    private AnswerRepository answerRepository;

    @InjectMocks
    private QuizSubmissionService submissionService;

    private Quiz quiz;
    private Question question1;
    private Question question2;
    private Answer correctAnswer1;
    private Answer wrongAnswer1;
    private Answer correctAnswer2;

    @BeforeEach
    void setUp() {
        quiz = new Quiz("Test Quiz", "Description");
        quiz.setId(1L);
        quiz.setPassingScore(50);
        quiz.setXpReward(100);

        question1 = new Question("Question 1?", QuestionType.SINGLE_CHOICE, 1);
        question1.setId(1L);
        question1.setExplanation("Explanation 1");

        question2 = new Question("Question 2?", QuestionType.SINGLE_CHOICE, 2);
        question2.setId(2L);
        question2.setExplanation("Explanation 2");

        correctAnswer1 = new Answer("Correct 1", true, 1);
        correctAnswer1.setId(1L);

        wrongAnswer1 = new Answer("Wrong 1", false, 2);
        wrongAnswer1.setId(2L);

        correctAnswer2 = new Answer("Correct 2", true, 1);
        correctAnswer2.setId(3L);
    }

    @Test
    void submitQuiz_allCorrect_passes() {
        // Given
        when(quizService.getQuizById(1L)).thenReturn(quiz);
        when(quizService.getQuestionsByQuiz(1L)).thenReturn(List.of(question1, question2));
        when(answerRepository.findByQuestionIdAndIsCorrectTrue(1L)).thenReturn(List.of(correctAnswer1));
        when(answerRepository.findByQuestionIdAndIsCorrectTrue(2L)).thenReturn(List.of(correctAnswer2));

        Map<Long, List<Long>> answers = Map.of(
            1L, List.of(1L),
            2L, List.of(3L)
        );
        QuizSubmissionRequest submission = new QuizSubmissionRequest(answers);

        // When
        QuizResultDto result = submissionService.submitQuiz(1L, submission);

        // Then
        assertEquals(2, result.totalQuestions());
        assertEquals(2, result.correctAnswers());
        assertEquals(100, result.score());
        assertTrue(result.passed());
        assertEquals(100, result.xpEarned());
    }

    @Test
    void submitQuiz_allWrong_fails() {
        // Given
        when(quizService.getQuizById(1L)).thenReturn(quiz);
        when(quizService.getQuestionsByQuiz(1L)).thenReturn(List.of(question1, question2));
        when(answerRepository.findByQuestionIdAndIsCorrectTrue(1L)).thenReturn(List.of(correctAnswer1));
        when(answerRepository.findByQuestionIdAndIsCorrectTrue(2L)).thenReturn(List.of(correctAnswer2));

        Map<Long, List<Long>> answers = Map.of(
            1L, List.of(2L),
            2L, List.of(2L)
        );
        QuizSubmissionRequest submission = new QuizSubmissionRequest(answers);

        // When
        QuizResultDto result = submissionService.submitQuiz(1L, submission);

        // Then
        assertEquals(0, result.correctAnswers());
        assertEquals(0, result.score());
        assertFalse(result.passed());
        assertEquals(0, result.xpEarned());
    }

    @Test
    void submitQuiz_partialCorrect_calculatesScore() {
        // Given
        when(quizService.getQuizById(1L)).thenReturn(quiz);
        when(quizService.getQuestionsByQuiz(1L)).thenReturn(List.of(question1, question2));
        when(answerRepository.findByQuestionIdAndIsCorrectTrue(1L)).thenReturn(List.of(correctAnswer1));
        when(answerRepository.findByQuestionIdAndIsCorrectTrue(2L)).thenReturn(List.of(correctAnswer2));

        Map<Long, List<Long>> answers = Map.of(
            1L, List.of(1L),
            2L, List.of(2L)
        );
        QuizSubmissionRequest submission = new QuizSubmissionRequest(answers);

        // When
        QuizResultDto result = submissionService.submitQuiz(1L, submission);

        // Then
        assertEquals(1, result.correctAnswers());
        assertEquals(50, result.score());
        assertTrue(result.passed());
    }

    @Test
    void submitQuiz_multipleChoice_allMustMatch() {
        // Given
        Question mcQuestion = new Question("Multiple choice?", QuestionType.MULTIPLE_CHOICE, 1);
        mcQuestion.setId(3L);

        Answer mc1 = new Answer("A", true, 1);
        mc1.setId(10L);
        Answer mc2 = new Answer("B", true, 2);
        mc2.setId(11L);

        when(quizService.getQuizById(1L)).thenReturn(quiz);
        when(quizService.getQuestionsByQuiz(1L)).thenReturn(List.of(mcQuestion));
        when(answerRepository.findByQuestionIdAndIsCorrectTrue(3L)).thenReturn(List.of(mc1, mc2));

        // Only one correct answer selected - should fail
        Map<Long, List<Long>> answers = Map.of(3L, List.of(10L));
        QuizSubmissionRequest submission = new QuizSubmissionRequest(answers);

        // When
        QuizResultDto result = submissionService.submitQuiz(1L, submission);

        // Then
        assertEquals(0, result.correctAnswers());
    }

    @Test
    void submitQuiz_multipleChoice_allSelected_passes() {
        // Given
        Question mcQuestion = new Question("Multiple choice?", QuestionType.MULTIPLE_CHOICE, 1);
        mcQuestion.setId(3L);

        Answer mc1 = new Answer("A", true, 1);
        mc1.setId(10L);
        Answer mc2 = new Answer("B", true, 2);
        mc2.setId(11L);

        when(quizService.getQuizById(1L)).thenReturn(quiz);
        when(quizService.getQuestionsByQuiz(1L)).thenReturn(List.of(mcQuestion));
        when(answerRepository.findByQuestionIdAndIsCorrectTrue(3L)).thenReturn(List.of(mc1, mc2));

        Map<Long, List<Long>> answers = Map.of(3L, List.of(10L, 11L));
        QuizSubmissionRequest submission = new QuizSubmissionRequest(answers);

        // When
        QuizResultDto result = submissionService.submitQuiz(1L, submission);

        // Then
        assertEquals(1, result.correctAnswers());
        assertEquals(100, result.score());
    }

    @Test
    void submitQuiz_returnsExplanations() {
        // Given
        when(quizService.getQuizById(1L)).thenReturn(quiz);
        when(quizService.getQuestionsByQuiz(1L)).thenReturn(List.of(question1));
        when(answerRepository.findByQuestionIdAndIsCorrectTrue(1L)).thenReturn(List.of(correctAnswer1));

        Map<Long, List<Long>> answers = Map.of(1L, List.of(1L));
        QuizSubmissionRequest submission = new QuizSubmissionRequest(answers);

        // When
        QuizResultDto result = submissionService.submitQuiz(1L, submission);

        // Then
        assertEquals("Explanation 1", result.questionResults().get(0).explanation());
    }

    @Test
    void calculateScore_returnsScoreOnly() {
        // Given
        when(quizService.getQuizById(1L)).thenReturn(quiz);
        when(quizService.getQuestionsByQuiz(1L)).thenReturn(List.of(question1));
        when(answerRepository.findByQuestionIdAndIsCorrectTrue(1L)).thenReturn(List.of(correctAnswer1));

        Map<Long, List<Long>> answers = Map.of(1L, List.of(1L));
        QuizSubmissionRequest submission = new QuizSubmissionRequest(answers);

        // When
        int score = submissionService.calculateScore(1L, submission);

        // Then
        assertEquals(100, score);
    }
}
