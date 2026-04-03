package com.javaquest.quiz;

import com.javaquest.dashboard.DashboardService;
import com.javaquest.user.User;
import com.javaquest.user.UserRepository;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * Controller REST pour la gestion des quiz.
 */
@RestController
@RequestMapping("/api/quizzes")
public class QuizController {

    private final QuizService quizService;
    private final QuizSubmissionService submissionService;
    private final DashboardService dashboardService;
    private final UserRepository userRepository;

    public QuizController(QuizService quizService, QuizSubmissionService submissionService,
                          DashboardService dashboardService, UserRepository userRepository) {
        this.quizService = quizService;
        this.submissionService = submissionService;
        this.dashboardService = dashboardService;
        this.userRepository = userRepository;
    }

    /**
     * Liste tous les quiz.
     * GET /api/quizzes
     */
    @GetMapping
    public ResponseEntity<List<QuizDto>> getAllQuizzes() {
        List<QuizDto> quizzes = quizService.getAllQuizzes().stream()
            .map(QuizDto::fromEntity)
            .toList();
        return ResponseEntity.ok(quizzes);
    }

    /**
     * Recupere un quiz par son ID.
     * GET /api/quizzes/{id}
     */
    @GetMapping("/{id}")
    public ResponseEntity<QuizDto> getQuizById(@PathVariable Long id) {
        Quiz quiz = quizService.getQuizById(id);
        return ResponseEntity.ok(QuizDto.fromEntity(quiz));
    }

    /**
     * Recupere les quiz d'une lecon.
     * GET /api/quizzes/lesson/{lessonId}
     */
    @GetMapping("/lesson/{lessonId}")
    public ResponseEntity<List<QuizDto>> getQuizzesByLesson(@PathVariable Long lessonId) {
        List<QuizDto> quizzes = quizService.getQuizzesByLesson(lessonId).stream()
            .map(QuizDto::fromEntity)
            .toList();
        return ResponseEntity.ok(quizzes);
    }

    /**
     * Cree un nouveau quiz.
     * POST /api/quizzes
     */
    @PostMapping
    public ResponseEntity<QuizDto> createQuiz(@Valid @RequestBody CreateQuizRequest request) {
        Quiz quiz = quizService.createQuiz(
            request.title(),
            request.description(),
            request.lessonId(),
            request.timeLimitSeconds(),
            request.passingScore(),
            request.xpReward()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(QuizDto.fromEntity(quiz));
    }

    /**
     * Met a jour un quiz.
     * PUT /api/quizzes/{id}
     */
    @PutMapping("/{id}")
    public ResponseEntity<QuizDto> updateQuiz(
            @PathVariable Long id,
            @Valid @RequestBody UpdateQuizRequest request) {
        Quiz quiz = quizService.updateQuiz(
            id,
            request.title(),
            request.description(),
            request.timeLimitSeconds(),
            request.passingScore(),
            request.xpReward()
        );
        return ResponseEntity.ok(QuizDto.fromEntity(quiz));
    }

    /**
     * Supprime un quiz.
     * DELETE /api/quizzes/{id}
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteQuiz(@PathVariable Long id) {
        quizService.deleteQuiz(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * Recupere les questions d'un quiz (sans les reponses correctes).
     * GET /api/quizzes/{id}/questions
     */
    @GetMapping("/{id}/questions")
    public ResponseEntity<List<QuestionDto>> getQuestions(@PathVariable Long id) {
        List<QuestionDto> questions = quizService.getQuestionsByQuiz(id).stream()
            .map(q -> QuestionDto.fromEntity(q, false))
            .toList();
        return ResponseEntity.ok(questions);
    }

    /**
     * Ajoute une question a un quiz.
     * POST /api/quizzes/{id}/questions
     */
    @PostMapping("/{id}/questions")
    public ResponseEntity<QuestionDto> addQuestion(
            @PathVariable Long id,
            @Valid @RequestBody CreateQuestionRequest request) {
        Question question = quizService.addQuestion(
            id,
            request.text(),
            request.questionType(),
            request.codeSnippet(),
            request.explanation(),
            request.orderIndex()
        );
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(QuestionDto.fromEntity(question, true));
    }

    /**
     * Ajoute une reponse a une question.
     * POST /api/quizzes/questions/{questionId}/answers
     */
    @PostMapping("/questions/{questionId}/answers")
    public ResponseEntity<AnswerDto> addAnswer(
            @PathVariable Long questionId,
            @Valid @RequestBody CreateAnswerRequest request) {
        Answer answer = quizService.addAnswer(
            questionId,
            request.text(),
            request.isCorrect(),
            request.orderIndex()
        );
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(AnswerDto.fromEntity(answer, true));
    }

    /**
     * Soumet un quiz pour correction et enregistre la tentative.
     * POST /api/quizzes/{id}/submit
     */
    @PostMapping("/{id}/submit")
    public ResponseEntity<QuizResultDto> submitQuiz(
            @PathVariable Long id,
            @Valid @RequestBody QuizSubmissionRequest request,
            Authentication authentication) {
        QuizResultDto result = submissionService.submitQuiz(id, request);

        if (authentication != null) {
            userRepository.findByUsername(authentication.getName()).ifPresent(user ->
                dashboardService.recordQuizAttempt(
                    user.getId(), id, result.score(), result.correctAnswers(),
                    result.totalQuestions(), result.passed(), result.xpEarned()
                )
            );
        }

        return ResponseEntity.ok(result);
    }

    /**
     * Gestion des erreurs liees aux quiz.
     */
    @ExceptionHandler(QuizException.class)
    public ResponseEntity<Map<String, String>> handleQuizException(QuizException ex) {
        return ResponseEntity
            .status(HttpStatus.NOT_FOUND)
            .body(Map.of("error", ex.getMessage()));
    }
}
