package com.javaquest.quiz;

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

import java.util.List;
import java.util.Map;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests d'integration pour QuizController.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class QuizControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private QuizRepository quizRepository;

    @Autowired
    private QuestionRepository questionRepository;

    @Autowired
    private AnswerRepository answerRepository;

    private Quiz testQuiz;
    private Question testQuestion;
    private Answer correctAnswer;
    private Answer wrongAnswer;

    @BeforeEach
    void setUp() {
        answerRepository.deleteAll();
        questionRepository.deleteAll();
        quizRepository.deleteAll();

        testQuiz = new Quiz("Java Basics", "Test your Java knowledge");
        testQuiz.setPassingScore(70);
        testQuiz.setXpReward(100);
        testQuiz = quizRepository.save(testQuiz);

        testQuestion = new Question("What is JVM?", QuestionType.SINGLE_CHOICE, 1);
        testQuestion.setExplanation("JVM stands for Java Virtual Machine");
        testQuestion.setQuiz(testQuiz);
        testQuestion = questionRepository.save(testQuestion);

        correctAnswer = new Answer("Java Virtual Machine", true, 1);
        correctAnswer.setQuestion(testQuestion);
        correctAnswer = answerRepository.save(correctAnswer);

        wrongAnswer = new Answer("Java Very Much", false, 2);
        wrongAnswer.setQuestion(testQuestion);
        wrongAnswer = answerRepository.save(wrongAnswer);
    }

    @Test
    void getAllQuizzes_returnsQuizzes() throws Exception {
        mockMvc.perform(get("/api/quizzes"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$[0].title").value("Java Basics"));
    }

    @Test
    void getQuizById_found_returnsQuiz() throws Exception {
        mockMvc.perform(get("/api/quizzes/" + testQuiz.getId()))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.title").value("Java Basics"))
            .andExpect(jsonPath("$.passingScore").value(70));
    }

    @Test
    void getQuizById_notFound_returns404() throws Exception {
        mockMvc.perform(get("/api/quizzes/999"))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.error").value("Quiz non trouve"));
    }

    @Test
    void createQuiz_success() throws Exception {
        CreateQuizRequest request = new CreateQuizRequest(
            "New Quiz", "Description", null, 300, 80, 150
        );

        mockMvc.perform(post("/api/quizzes")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.title").value("New Quiz"))
            .andExpect(jsonPath("$.passingScore").value(80));
    }

    @Test
    void createQuiz_missingTitle_returnsBadRequest() throws Exception {
        String invalidRequest = """
            {
                "description": "Desc"
            }
            """;

        mockMvc.perform(post("/api/quizzes")
                .contentType(MediaType.APPLICATION_JSON)
                .content(invalidRequest))
            .andExpect(status().isBadRequest());
    }

    @Test
    void updateQuiz_success() throws Exception {
        UpdateQuizRequest request = new UpdateQuizRequest(
            "Updated Quiz", null, 600, 90, null
        );

        mockMvc.perform(put("/api/quizzes/" + testQuiz.getId())
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.title").value("Updated Quiz"))
            .andExpect(jsonPath("$.passingScore").value(90));
    }

    @Test
    void deleteQuiz_success() throws Exception {
        mockMvc.perform(delete("/api/quizzes/" + testQuiz.getId()))
            .andExpect(status().isNoContent());

        mockMvc.perform(get("/api/quizzes/" + testQuiz.getId()))
            .andExpect(status().isNotFound());
    }

    @Test
    void getQuestions_returnsQuestionsWithoutCorrectAnswers() throws Exception {
        mockMvc.perform(get("/api/quizzes/" + testQuiz.getId() + "/questions"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$[0].text").value("What is JVM?"))
            .andExpect(jsonPath("$[0].answers[0].isCorrect").doesNotExist());
    }

    @Test
    void addQuestion_success() throws Exception {
        CreateQuestionRequest request = new CreateQuestionRequest(
            "What is JDK?", QuestionType.SINGLE_CHOICE, null, "JDK explanation", 2
        );

        mockMvc.perform(post("/api/quizzes/" + testQuiz.getId() + "/questions")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.text").value("What is JDK?"));
    }

    @Test
    void addAnswer_success() throws Exception {
        CreateAnswerRequest request = new CreateAnswerRequest(
            "Another answer", false, 3
        );

        mockMvc.perform(post("/api/quizzes/questions/" + testQuestion.getId() + "/answers")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.text").value("Another answer"));
    }

    @Test
    void submitQuiz_correctAnswer_passes() throws Exception {
        Map<Long, List<Long>> answers = Map.of(
            testQuestion.getId(), List.of(correctAnswer.getId())
        );
        QuizSubmissionRequest request = new QuizSubmissionRequest(answers);

        mockMvc.perform(post("/api/quizzes/" + testQuiz.getId() + "/submit")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.score").value(100))
            .andExpect(jsonPath("$.passed").value(true))
            .andExpect(jsonPath("$.xpEarned").value(100));
    }

    @Test
    void submitQuiz_wrongAnswer_fails() throws Exception {
        Map<Long, List<Long>> answers = Map.of(
            testQuestion.getId(), List.of(wrongAnswer.getId())
        );
        QuizSubmissionRequest request = new QuizSubmissionRequest(answers);

        mockMvc.perform(post("/api/quizzes/" + testQuiz.getId() + "/submit")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.score").value(0))
            .andExpect(jsonPath("$.passed").value(false))
            .andExpect(jsonPath("$.xpEarned").value(0));
    }

    @Test
    void submitQuiz_returnsExplanation() throws Exception {
        Map<Long, List<Long>> answers = Map.of(
            testQuestion.getId(), List.of(correctAnswer.getId())
        );
        QuizSubmissionRequest request = new QuizSubmissionRequest(answers);

        mockMvc.perform(post("/api/quizzes/" + testQuiz.getId() + "/submit")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.questionResults[0].explanation").value("JVM stands for Java Virtual Machine"));
    }
}
