-- V43: Lecon 2 Exceptions personnalisees + Quiz

-- =============================================
-- LECON 2 : Exceptions personnalisees
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Exceptions personnalisees',
    'exceptions-personnalisees',
    E'EXCEPTIONS PERSONNALISEES\n\nJava fournit de nombreuses exceptions standard (ArithmeticException, NumberFormatException...), mais parfois votre application a besoin d exceptions metier specifiques. Vous pouvez creer vos propres exceptions en etendant la classe Exception.\n\n---\n\nCREER UNE EXCEPTION PERSONNALISEE\n\nUne exception personnalisee est simplement une classe qui etend Exception :\n\n  public class AgeInvalideException extends Exception {\n      public AgeInvalideException(String message) {\n          super(message);\n      }\n  }\n\nC est tout ! Le constructeur appelle super(message) pour transmettre le message a la classe parente Exception. Vous pouvez maintenant utiliser cette exception comme n importe quelle autre.\n\n---\n\nUTILISER UNE EXCEPTION PERSONNALISEE\n\nLe mot-cle throws dans la signature indique que la methode peut propager cette exception :\n\n  public static void verifierAge(int age) throws AgeInvalideException {\n      if (age < 0 || age > 150) {\n          throw new AgeInvalideException("Age invalide : " + age + ". Doit etre entre 0 et 150.");\n      }\n      System.out.println("Age accepte : " + age);\n  }\n\n  // Dans main :\n  try {\n      verifierAge(25);\n      verifierAge(-5);\n  } catch (AgeInvalideException e) {\n      System.out.println("Erreur metier : " + e.getMessage());\n  }\n  // Age accepte : 25\n  // Erreur metier : Age invalide : -5. Doit etre entre 0 et 150.\n\n---\n\nEXCEPTION AVEC DES DONNEES SUPPLEMENTAIRES\n\nVotre exception peut stocker des informations additionnelles :\n\n  public class SoldeInsuffisantException extends Exception {\n      private double soldeActuel;\n      private double montantDemande;\n\n      public SoldeInsuffisantException(double soldeActuel, double montantDemande) {\n          super("Solde insuffisant : " + soldeActuel + " EUR disponibles, " + montantDemande + " EUR demandes");\n          this.soldeActuel = soldeActuel;\n          this.montantDemande = montantDemande;\n      }\n\n      public double getSoldeActuel() { return soldeActuel; }\n      public double getMontantDemande() { return montantDemande; }\n  }\n\n  // Utilisation :\n  public static void retirer(double solde, double montant) throws SoldeInsuffisantException {\n      if (montant > solde) {\n          throw new SoldeInsuffisantException(solde, montant);\n      }\n      System.out.println("Retrait de " + montant + " EUR effectue");\n  }\n\n  try {\n      retirer(100.0, 150.0);\n  } catch (SoldeInsuffisantException e) {\n      System.out.println(e.getMessage());\n      // Solde insuffisant : 100.0 EUR disponibles, 150.0 EUR demandes\n  }\n\n---\n\nPLUSIEURS CONSTRUCTEURS\n\nOn peut offrir plusieurs constructeurs pour plus de flexibilite :\n\n  public class ProduitIntrouvableException extends Exception {\n\n      public ProduitIntrouvableException(String message) {\n          super(message);\n      }\n\n      public ProduitIntrouvableException(String message, Throwable cause) {\n          super(message, cause);\n      }\n  }\n\nLe constructeur avec Throwable cause permet d encapsuler une exception originale dans la votre.\n\n---\n\nRUNTIMEEXCEPTION VS EXCEPTION\n\nIl existe deux grandes familles d exceptions :\n\nException (verifiee / checked) :\n  - Doit etre geree obligatoirement par try/catch ou throws\n  - Pour les erreurs que l appelant doit obligatoirement traiter\n  - Exemple : IOException, SQLException\n\nRuntimeException (non verifiee / unchecked) :\n  - Pas obligatoire de la gerer\n  - Pour les erreurs de programmation (bugs)\n  - Exemple : NullPointerException, ArrayIndexOutOfBoundsException\n\nVos exceptions metier etendent generalement Exception (verifiee) pour forcer leur gestion.\n\n---\n\nBONNES PRATIQUES\n\n1. Nommez vos exceptions avec le suffixe "Exception" (ex: AgeInvalideException).\n2. Fournissez toujours un message descriptif et comprehensible.\n3. Creez une exception par type de probleme metier distinct.\n4. Utilisez checked exceptions (extends Exception) pour les erreurs que l appelant doit obligatoirement traiter.\n5. Stockez les donnees pertinentes dans l exception pour faciliter le debogage.',
    2,
    40
FROM chapters c WHERE c.slug = 'gestion-exceptions';

-- =============================================
-- QUIZ : Exceptions personnalisees
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Exceptions personnalisees',
    'Testez vos connaissances sur la creation et l utilisation d exceptions personnalisees',
    300, 70, 100
FROM lessons l WHERE l.slug = 'exceptions-personnalisees';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle classe doit etendre une exception personnalisee en Java ?',
        'SINGLE_CHOICE',
        'Pour creer une exception personnalisee, la classe doit etendre Exception (pour une checked exception) ou RuntimeException (pour une unchecked exception).',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'exceptions-personnalisees'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Object', false, 1),
((SELECT id FROM q), 'Error', false, 2),
((SELECT id FROM q), 'Exception', true, 3),
((SELECT id FROM q), 'Throwable uniquement', false, 4);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que fait super(message) dans le constructeur d une exception personnalisee ?',
        'SINGLE_CHOICE',
        'super(message) appelle le constructeur de la classe parente (Exception) pour stocker le message d erreur, qui sera ensuite accessible via getMessage().',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'exceptions-personnalisees'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Il affiche le message dans la console', false, 1),
((SELECT id FROM q), 'Il appelle le constructeur de la classe parente avec le message', true, 2),
((SELECT id FROM q), 'Il initialise une variable locale message', false, 3),
((SELECT id FROM q), 'Il lance automatiquement l exception', false, 4);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel mot-cle utilise-t-on dans la signature d une methode pour signaler qu elle peut propager une exception ?',
        'SINGLE_CHOICE',
        'Le mot-cle throws (avec s) dans la signature de methode signale que celle-ci peut propager une exception verifiee. throw (sans s) est utilise pour lancer l exception.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'exceptions-personnalisees'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'throw', false, 1),
((SELECT id FROM q), 'throws', true, 2),
((SELECT id FROM q), 'catch', false, 3),
((SELECT id FROM q), 'propagate', false, 4);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la difference entre une checked et une unchecked exception ?',
        'SINGLE_CHOICE',
        'Une checked exception (extends Exception) doit obligatoirement etre geree par try/catch ou throws. Une unchecked exception (extends RuntimeException) n a pas cette obligation.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'exceptions-personnalisees'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'La checked exception est plus rapide a l execution', false, 1),
((SELECT id FROM q), 'La checked exception doit obligatoirement etre geree, pas la unchecked', true, 2),
((SELECT id FROM q), 'La unchecked exception ne peut pas etre attrapee avec catch', false, 3),
((SELECT id FROM q), 'Il n y a aucune difference pratique entre les deux', false, 4);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pourquoi stocker des donnees supplementaires dans une exception personnalisee ?',
        'SINGLE_CHOICE',
        'Stocker des donnees supplementaires (comme le solde actuel et le montant demande dans SoldeInsuffisantException) permet au code qui attrape l exception d avoir toutes les informations necessaires pour repondre au probleme de facon precise.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'exceptions-personnalisees'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Pour que l exception soit plus rapide', false, 1),
((SELECT id FROM q), 'C est une obligation imposee par Java', false, 2),
((SELECT id FROM q), 'Pour fournir au code appelant les informations necessaires pour traiter l erreur', true, 3),
((SELECT id FROM q), 'Pour eviter d avoir a utiliser getMessage()', false, 4);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle convention de nommage doit suivre une exception personnalisee ?',
        'SINGLE_CHOICE',
        'Par convention, les exceptions Java se terminent par le suffixe "Exception" (ex: AgeInvalideException, SoldeInsuffisantException). Cela les rend immediatement identifiables dans le code.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'exceptions-personnalisees'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Commencer par "Ex" (ex: ExAgeInvalide)', false, 1),
((SELECT id FROM q), 'Commencer par "Error" (ex: ErrorAgeInvalide)', false, 2),
((SELECT id FROM q), 'Se terminer par "Exception" (ex: AgeInvalideException)', true, 3),
((SELECT id FROM q), 'Aucune convention particuliere', false, 4);
