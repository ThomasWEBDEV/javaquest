package com.javaquest.quiz;

import com.javaquest.course.Lesson;
import com.javaquest.course.LessonRepository;
import com.javaquest.course.CourseException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Service gerant les operations sur les quiz.
 */
@Service
public class QuizService {

    private final QuizRepository quizRepository;
    private final QuestionRepository questionRepository;
    private final AnswerRepository answerRepository;
    private final LessonRepository lessonRepository;

    public QuizService(QuizRepository quizRepository,
                       QuestionRepository questionRepository,
                       AnswerRepository answerRepository,
                       LessonRepository lessonRepository) {
        this.quizRepository = quizRepository;
        this.questionRepository = questionRepository;
        this.answerRepository = answerRepository;
        this.lessonRepository = lessonRepository;
    }

    /**
     * Recupere tous les quiz.
     */
    public List<Quiz> getAllQuizzes() {
        return quizRepository.findAll();
    }

    /**
     * Recupere un quiz par son ID.
     */
    public Quiz getQuizById(Long id) {
        return quizRepository.findById(id)
            .orElseThrow(() -> new QuizException("Quiz non trouve"));
    }

    /**
     * Recupere les quiz d'une lecon.
     */
    public List<Quiz> getQuizzesByLesson(Long lessonId) {
        return quizRepository.findByLessonId(lessonId);
    }

    /**
     * Cree un nouveau quiz.
     */
    @Transactional
    public Quiz createQuiz(String title, String description, Long lessonId,
                           Integer timeLimitSeconds, Integer passingScore, Integer xpReward) {
        Quiz quiz = new Quiz(title, description);
        quiz.setTimeLimitSeconds(timeLimitSeconds);
        quiz.setPassingScore(passingScore != null ? passingScore : 70);
        quiz.setXpReward(xpReward != null ? xpReward : 100);

        if (lessonId != null) {
            Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() -> new CourseException("Lecon non trouvee"));
            quiz.setLesson(lesson);
        }

        return quizRepository.save(quiz);
    }

    /**
     * Met a jour un quiz.
     */
    @Transactional
    public Quiz updateQuiz(Long id, String title, String description,
                           Integer timeLimitSeconds, Integer passingScore, Integer xpReward) {
        Quiz quiz = getQuizById(id);

        if (title != null) quiz.setTitle(title);
        if (description != null) quiz.setDescription(description);
        if (timeLimitSeconds != null) quiz.setTimeLimitSeconds(timeLimitSeconds);
        if (passingScore != null) quiz.setPassingScore(passingScore);
        if (xpReward != null) quiz.setXpReward(xpReward);

        return quizRepository.save(quiz);
    }

    /**
     * Supprime un quiz.
     */
    @Transactional
    public void deleteQuiz(Long id) {
        Quiz quiz = getQuizById(id);
        quizRepository.delete(quiz);
    }

    /**
     * Ajoute une question a un quiz.
     */
    @Transactional
    public Question addQuestion(Long quizId, String text, QuestionType questionType,
                                String codeSnippet, String explanation, Integer orderIndex) {
        Quiz quiz = getQuizById(quizId);

        Question question = new Question(text, questionType, orderIndex);
        question.setCodeSnippet(codeSnippet);
        question.setExplanation(explanation);
        quiz.addQuestion(question);

        quizRepository.save(quiz);
        return question;
    }

    /**
     * Ajoute une reponse a une question.
     */
    @Transactional
    public Answer addAnswer(Long questionId, String text, Boolean isCorrect, Integer orderIndex) {
        Question question = questionRepository.findById(questionId)
            .orElseThrow(() -> new QuizException("Question non trouvee"));

        Answer answer = new Answer(text, isCorrect, orderIndex);
        question.addAnswer(answer);

        questionRepository.save(question);
        return answer;
    }

    /**
     * Recupere les questions d'un quiz.
     */
    public List<Question> getQuestionsByQuiz(Long quizId) {
        return questionRepository.findByQuizIdOrderByOrderIndexAsc(quizId);
    }

    /**
     * Verifie si une reponse est correcte.
     */
    public boolean isAnswerCorrect(Long answerId) {
        return answerRepository.findById(answerId)
            .map(Answer::getIsCorrect)
            .orElse(false);
    }

    /**
     * Recupere les reponses correctes d'une question.
     */
    public List<Answer> getCorrectAnswers(Long questionId) {
        return answerRepository.findByQuestionIdAndIsCorrectTrue(questionId);
    }
}
