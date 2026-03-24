package com.javaquest.quiz;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Service gerant la soumission et correction des quiz.
 */
@Service
public class QuizSubmissionService {

    private final QuizService quizService;
    private final QuestionRepository questionRepository;
    private final AnswerRepository answerRepository;

    public QuizSubmissionService(QuizService quizService,
                                  QuestionRepository questionRepository,
                                  AnswerRepository answerRepository) {
        this.quizService = quizService;
        this.questionRepository = questionRepository;
        this.answerRepository = answerRepository;
    }

    /**
     * Soumet un quiz et retourne le resultat.
     */
    @Transactional(readOnly = true)
    public QuizResultDto submitQuiz(Long quizId, QuizSubmissionRequest submission) {
        Quiz quiz = quizService.getQuizById(quizId);
        List<Question> questions = quizService.getQuestionsByQuiz(quizId);

        List<QuestionResultDto> questionResults = new ArrayList<>();
        int correctCount = 0;

        for (Question question : questions) {
            QuestionResultDto result = evaluateQuestion(question, submission.answers());
            questionResults.add(result);

            if (result.correct()) {
                correctCount++;
            }
        }

        int totalQuestions = questions.size();
        int score = totalQuestions > 0 ? (correctCount * 100) / totalQuestions : 0;
        boolean passed = score >= quiz.getPassingScore();
        int xpEarned = passed ? quiz.getXpReward() : 0;

        return new QuizResultDto(
            quizId,
            totalQuestions,
            correctCount,
            score,
            passed,
            xpEarned,
            questionResults
        );
    }

    /**
     * Evalue une question.
     */
    private QuestionResultDto evaluateQuestion(Question question, Map<Long, List<Long>> answers) {
        List<Long> selectedAnswerIds = answers.getOrDefault(question.getId(), List.of());
        List<Answer> correctAnswers = answerRepository.findByQuestionIdAndIsCorrectTrue(question.getId());
        List<Long> correctAnswerIds = correctAnswers.stream()
            .map(Answer::getId)
            .toList();

        boolean isCorrect = isQuestionCorrect(question.getQuestionType(), selectedAnswerIds, correctAnswerIds);

        return new QuestionResultDto(
            question.getId(),
            isCorrect,
            correctAnswerIds,
            selectedAnswerIds,
            question.getExplanation()
        );
    }

    /**
     * Verifie si la reponse a une question est correcte.
     */
    private boolean isQuestionCorrect(QuestionType type, List<Long> selected, List<Long> correct) {
        if (selected.isEmpty() && correct.isEmpty()) {
            return true;
        }

        Set<Long> selectedSet = Set.copyOf(selected);
        Set<Long> correctSet = Set.copyOf(correct);

        return switch (type) {
            case SINGLE_CHOICE, TRUE_FALSE, CODE_OUTPUT -> 
                selected.size() == 1 && correct.contains(selected.get(0));
            case MULTIPLE_CHOICE -> 
                selectedSet.equals(correctSet);
        };
    }

    /**
     * Calcule le score d'un quiz sans sauvegarder.
     */
    public int calculateScore(Long quizId, QuizSubmissionRequest submission) {
        QuizResultDto result = submitQuiz(quizId, submission);
        return result.score();
    }
}
