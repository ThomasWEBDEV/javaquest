package com.javaquest.config;

import com.javaquest.challenge.ChallengeService;
import com.javaquest.challenge.DailyChallengeRepository;
import com.javaquest.quiz.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.annotation.Profile;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

/**
 * Initialise les donnees de demonstration au demarrage si necessaire.
 * S'execute apres Flyway et Hibernate pour avoir acces au schema complet.
 * Desactive en profil test pour ne pas interferences avec les tests d'integration.
 */
@Component
@Profile("!test")
public class DataInitializerService {

    private static final Logger log = LoggerFactory.getLogger(DataInitializerService.class);

    private final QuizRepository quizRepository;
    private final QuizService quizService;
    private final ChallengeService challengeService;
    private final DailyChallengeRepository dailyChallengeRepository;

    public DataInitializerService(QuizRepository quizRepository, QuizService quizService,
                                  ChallengeService challengeService,
                                  DailyChallengeRepository dailyChallengeRepository) {
        this.quizRepository = quizRepository;
        this.quizService = quizService;
        this.challengeService = challengeService;
        this.dailyChallengeRepository = dailyChallengeRepository;
    }

    @EventListener(ApplicationReadyEvent.class)
    @Transactional
    public void initializeData() {
        initializeQuiz();
        initializeDailyChallenge();
    }

    private void initializeQuiz() {
        if (quizRepository.count() > 0) {
            return;
        }

        log.info("Creation du quiz de demonstration...");

        Quiz quiz = quizService.createQuiz(
            "Variables et Types Java",
            "Testez vos connaissances sur les variables et types primitifs Java",
            null, null, 60, 100
        );

        Question q1 = quizService.addQuestion(quiz.getId(),
            "Quel mot-cle permet de declarer une variable entiere en Java?",
            QuestionType.SINGLE_CHOICE, null,
            "int est le type primitif entier le plus courant en Java.", 1);
        quizService.addAnswer(q1.getId(), "int", true, 1);
        quizService.addAnswer(q1.getId(), "Integer", false, 2);
        quizService.addAnswer(q1.getId(), "number", false, 3);
        quizService.addAnswer(q1.getId(), "var", false, 4);

        Question q2 = quizService.addQuestion(quiz.getId(),
            "Quelle est la valeur par defaut d'un boolean en Java?",
            QuestionType.SINGLE_CHOICE, null,
            "En Java, les variables boolean non initialisees valent false.", 2);
        quizService.addAnswer(q2.getId(), "false", true, 1);
        quizService.addAnswer(q2.getId(), "true", false, 2);
        quizService.addAnswer(q2.getId(), "null", false, 3);
        quizService.addAnswer(q2.getId(), "0", false, 4);

        String codeSnippet = "int x = 5;\nint y = 3;\nSystem.out.println(x + y);";
        Question q3 = quizService.addQuestion(quiz.getId(),
            "Que affiche ce code?",
            QuestionType.CODE_OUTPUT, codeSnippet,
            "x + y = 5 + 3 = 8", 3);
        quizService.addAnswer(q3.getId(), "8", true, 1);
        quizService.addAnswer(q3.getId(), "53", false, 2);
        quizService.addAnswer(q3.getId(), "5 + 3", false, 3);
        quizService.addAnswer(q3.getId(), "Erreur de compilation", false, 4);

        Question q4 = quizService.addQuestion(quiz.getId(),
            "Quels sont les types primitifs entiers en Java? (plusieurs reponses)",
            QuestionType.MULTIPLE_CHOICE, null,
            "Java a 4 types entiers: byte, short, int et long.", 4);
        quizService.addAnswer(q4.getId(), "int", true, 1);
        quizService.addAnswer(q4.getId(), "long", true, 2);
        quizService.addAnswer(q4.getId(), "byte", true, 3);
        quizService.addAnswer(q4.getId(), "float", false, 4);
        quizService.addAnswer(q4.getId(), "short", true, 5);

        Question q5 = quizService.addQuestion(quiz.getId(),
            "String est un type primitif en Java.",
            QuestionType.TRUE_FALSE, null,
            "String est une classe (type reference), pas un type primitif.", 5);
        quizService.addAnswer(q5.getId(), "Vrai", false, 1);
        quizService.addAnswer(q5.getId(), "Faux", true, 2);

        log.info("Quiz de demonstration cree avec {} questions", 5);
    }

    private void initializeDailyChallenge() {
        LocalDate today = LocalDate.now();
        if (dailyChallengeRepository.existsByDate(today)) {
            return;
        }

        log.info("Creation du defi quotidien pour aujourd'hui...");

        try {
            challengeService.createChallenge(
                today,
                "Calculer une factorielle",
                "Ecrivez un programme qui calcule et affiche la factorielle de 5 (5! = 120).",
                "public class Main {\n    public static void main(String[] args) {\n        int n = 5;\n        // Calculez la factorielle de n\n        \n    }\n}",
                "public class Main {\n    public static void main(String[] args) {\n        int n = 5;\n        int result = 1;\n        for (int i = 1; i <= n; i++) {\n            result *= i;\n        }\n        System.out.println(result);\n    }\n}",
                "output.contains(\"120\")",
                "Utilisez une boucle for et multipliez les nombres de 1 a n.",
                150, 75
            );
            log.info("Defi quotidien cree pour {}", today);
        } catch (Exception e) {
            log.warn("Impossible de creer le defi quotidien: {}", e.getMessage());
        }
    }
}
