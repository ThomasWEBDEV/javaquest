-- V48: Lecon 4 Multi-catch et propagation + Quiz

-- =============================================
-- LECON 4 : Multi-catch et propagation
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Multi-catch et propagation',
    'multi-catch-propagation',
    E'MULTI-CATCH ET PROPAGATION DES EXCEPTIONS\n\nQuand votre code peut lever plusieurs types d exceptions differentes, Java offre des mecanismes avances pour les gerer proprement : le multi-catch, le re-throw et l encapsulation (chaining), ainsi que le try-with-resources pour les ressources.\n\n---\n\nMULTI-CATCH : CAPTURER PLUSIEURS TYPES\n\nAvant Java 7, il fallait un bloc catch par type d exception. Le multi-catch (Java 7+) permet de les regrouper :\n\n  // Sans multi-catch (repetitif)\n  try {\n      traiter(donnee);\n  } catch (NumberFormatException e) {\n      System.out.println("Erreur format : " + e.getMessage());\n  } catch (ArithmeticException e) {\n      System.out.println("Erreur format : " + e.getMessage());\n  }\n\n  // Avec multi-catch (concis)\n  try {\n      traiter(donnee);\n  } catch (NumberFormatException | ArithmeticException e) {\n      System.out.println("Erreur : " + e.getMessage());\n  }\n\nATTENTION : dans un multi-catch, la variable e est implicitement final. Vous ne pouvez pas la reassigner.\n\n---\n\nRE-THROW : RELANCER UNE EXCEPTION\n\nOn peut capturer une exception, effectuer un traitement partiel (log, nettoyage), puis la relancer :\n\n  public static void charger(String fichier) throws RuntimeException {\n      try {\n          // simulation d acces fichier\n          if (fichier.isEmpty()) throw new RuntimeException("Fichier vide");\n          System.out.println("Fichier charge : " + fichier);\n      } catch (RuntimeException e) {\n          System.out.println("Erreur journalisee : " + e.getMessage());\n          throw e; // on relance l exception originale\n      }\n  }\n\n  // Ou on relance sous un autre type\n  catch (RuntimeException e) {\n      throw new IllegalStateException("Echec chargement : " + fichier, e);\n  }\n\n---\n\nENCAPSULATION D EXCEPTIONS (CHAINING)\n\nL encapsulation consiste a capturer une exception technique et la convertir en exception metier, tout en conservant la cause originale :\n\n  static class ServiceException extends RuntimeException {\n      public ServiceException(String message, Throwable cause) {\n          super(message, cause);\n      }\n  }\n\n  public static void sauvegarder(String data) {\n      try {\n          if (data == null) throw new NullPointerException("data est null");\n          System.out.println("Sauvegarde : " + data);\n      } catch (Exception e) {\n          // On encapsule : l appelant voit une exception metier claire\n          throw new ServiceException("Echec de la sauvegarde", e);\n      }\n  }\n\n  // Utilisation\n  try {\n      sauvegarder(null);\n  } catch (ServiceException e) {\n      System.out.println(e.getMessage());           // Echec de la sauvegarde\n      System.out.println(e.getCause().getMessage()); // data est null\n  }\n\ngetCause() permet de remonter a l exception originale pour le debogage.\n\n---\n\nTRY-WITH-RESOURCES\n\nLes ressources (connexions, streams, fichiers) doivent toujours etre fermees. try-with-resources garantit la fermeture automatique, meme si une exception survient :\n\n  // Sans try-with-resources (risque d oubli)\n  Scanner sc = new Scanner(System.in);\n  try {\n      String ligne = sc.nextLine();\n  } finally {\n      sc.close(); // peut etre oublie !\n  }\n\n  // Avec try-with-resources (automatique et sur)\n  try (Scanner sc = new Scanner(System.in)) {\n      String ligne = sc.nextLine();\n  } // sc.close() appele automatiquement\n\nPlusieurs ressources sont fermees dans l ordre inverse de leur declaration :\n\n  try (ConnexionBD con = new ConnexionBD();\n       PreparedStatement ps = con.preparer("SELECT...")) {\n      ps.executer();\n  } // ps.close() puis con.close() automatiquement\n\nCREER SA PROPRE RESSOURCE\n\nToute classe implementant AutoCloseable peut etre utilisee dans try-with-resources :\n\n  class Ressource implements AutoCloseable {\n      public Ressource() {\n          System.out.println("Ressource ouverte");\n      }\n      public void utiliser() {\n          System.out.println("Ressource utilisee");\n      }\n      @Override\n      public void close() {\n          System.out.println("Ressource fermee");\n      }\n  }\n\n  try (Ressource r = new Ressource()) {\n      r.utiliser();\n  }\n  // Ressource ouverte\n  // Ressource utilisee\n  // Ressource fermee  <-- garanti meme si utiliser() levait une exception\n\n---\n\nBONNES PRATIQUES\n\n1. Utilisez le multi-catch pour eviter la duplication quand le traitement est identique.\n2. Ne capturez que les exceptions que vous pouvez vraiment traiter.\n3. Encapsulez les exceptions techniques en exceptions metier pour les couches superieures.\n4. Conservez toujours la cause originale (throw new MonException(msg, e)) pour le debogage.\n5. Utilisez systematiquement try-with-resources pour toute classe implementant AutoCloseable.',
    4,
    40
FROM chapters c WHERE c.slug = 'gestion-exceptions';

-- =============================================
-- QUIZ : Multi-catch et propagation
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Multi-catch et propagation',
    'Testez vos connaissances sur le multi-catch, le re-throw, le chaining et try-with-resources',
    300, 70, 100
FROM lessons l WHERE l.slug = 'multi-catch-propagation';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la syntaxe correcte pour capturer deux types d exceptions dans un seul catch ?',
        'SINGLE_CHOICE',
        'Le multi-catch utilise le separateur | entre les types d exceptions. La syntaxe est catch (TypeA | TypeB e). Cette fonctionnalite est disponible depuis Java 7.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'multi-catch-propagation'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'catch (IOException && SQLException e)', false, 1),
((SELECT id FROM q), 'catch (IOException | SQLException e)', true, 2),
((SELECT id FROM q), 'catch (IOException, SQLException e)', false, 3),
((SELECT id FROM q), 'catch (IOException or SQLException e)', false, 4);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Dans un multi-catch, quel est le statut de la variable d exception ?',
        'SINGLE_CHOICE',
        'Dans un multi-catch (catch A | B e), la variable e est implicitement final. Cela empeche de la reassigner, ce qui serait ambigu puisqu elle peut representer plusieurs types differents.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'multi-catch-propagation'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Elle est modifiable comme dans un catch normal', false, 1),
((SELECT id FROM q), 'Elle est implicitement final et ne peut pas etre reassignee', true, 2),
((SELECT id FROM q), 'Elle contient toujours la derniere exception levee', false, 3),
((SELECT id FROM q), 'Elle est de type Object pour accepter tous les types', false, 4);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pour quelle raison utilise-t-on le re-throw ?',
        'SINGLE_CHOICE',
        'Le re-throw permet d effectuer un traitement partiel (journalisation, nettoyage) dans le catch, puis de propager l exception pour que les couches superieures puissent aussi la gerer. On ne capture une exception que si on peut la traiter utilement.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'multi-catch-propagation'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Pour ignorer definitivement une exception', false, 1),
((SELECT id FROM q), 'Pour traiter partiellement puis propager l exception a la couche superieure', true, 2),
((SELECT id FROM q), 'Pour convertir une exception en valeur de retour', false, 3),
((SELECT id FROM q), 'Pour fusionner plusieurs exceptions en une seule', false, 4);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment encapsuler une exception originale dans une nouvelle exception ?',
        'SINGLE_CHOICE',
        'Pour conserver la cause originale, on passe l exception attrapee comme second argument au constructeur de la nouvelle exception : new RuntimeException("message", e). On peut ensuite retrouver la cause avec getCause().',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'multi-catch-propagation'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'new RuntimeException(e.getMessage())', false, 1),
((SELECT id FROM q), 'new RuntimeException("message", e)', true, 2),
((SELECT id FROM q), 'RuntimeException.wrap(e)', false, 3),
((SELECT id FROM q), 'e.chain(new RuntimeException())', false, 4);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle interface une classe doit-elle implementer pour etre utilisee dans try-with-resources ?',
        'SINGLE_CHOICE',
        'Une classe doit implementer AutoCloseable (ou son sous-type Closeable) pour etre utilisee dans try-with-resources. La methode close() est automatiquement appelee a la fin du bloc try, qu une exception survienne ou non.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'multi-catch-propagation'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Disposable', false, 1),
((SELECT id FROM q), 'Releasable', false, 2),
((SELECT id FROM q), 'AutoCloseable', true, 3),
((SELECT id FROM q), 'Manageable', false, 4);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que garantit try-with-resources par rapport a un try/finally classique ?',
        'SINGLE_CHOICE',
        'try-with-resources garantit que close() est appele automatiquement a la fin du bloc, qu une exception survienne ou non. Cela evite les fuites de ressources dues a un oubli de fermeture ou a une exception dans le bloc finally.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'multi-catch-propagation'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Le code s execute plus rapidement qu avec finally', false, 1),
((SELECT id FROM q), 'La ressource est fermee automatiquement meme si une exception survient', true, 2),
((SELECT id FROM q), 'Les exceptions dans close() sont automatiquement loggees', false, 3),
((SELECT id FROM q), 'La ressource peut etre reutilisee apres le bloc try', false, 4);
