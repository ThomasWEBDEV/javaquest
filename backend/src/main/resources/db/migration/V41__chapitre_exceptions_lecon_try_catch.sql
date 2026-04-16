-- V41: Chapitre 6 Gestion des Exceptions + Lecon 1 try/catch/finally + Quiz

-- =============================================
-- CHAPITRE 6 : Gestion des Exceptions
-- =============================================

INSERT INTO chapters (title, slug, description, order_index, xp_reward, is_published)
VALUES (
    'Gestion des Exceptions',
    'gestion-exceptions',
    'Apprenez a gerer les erreurs et les situations imprevues pour ecrire des programmes robustes et fiables',
    6,
    300,
    true
);

-- =============================================
-- LECON 1 : try/catch/finally
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'try/catch/finally : gerer les erreurs',
    'try-catch-finally',
    E'TRY/CATCH/FINALLY : GERER LES ERREURS\n\nUne exception est une erreur qui survient pendant l execution d un programme. Sans gestion, elle provoque l arret brutal du programme. Java offre un mecanisme structure pour capturer et traiter ces erreurs : le bloc try/catch.\n\n---\n\nLE PROBLEME SANS GESTION DES ERREURS\n\n  int[] nombres = {10, 20, 30};\n  System.out.println(nombres[5]); // ERREUR : ArrayIndexOutOfBoundsException\n  System.out.println("Cette ligne ne s affiche jamais");\n\nLe programme plante et tout le code apres l erreur est ignore.\n\n---\n\nSTRUCTURE TRY/CATCH\n\n  try {\n      // Code qui pourrait provoquer une exception\n      int[] nombres = {10, 20, 30};\n      System.out.println(nombres[5]);\n  } catch (ArrayIndexOutOfBoundsException e) {\n      // Code execute si l exception survient\n      System.out.println("Erreur : index hors limites !");\n  }\n  System.out.println("Le programme continue normalement");\n  // Erreur : index hors limites !\n  // Le programme continue normalement\n\nAvec try/catch, le programme ne plante plus : l exception est "attrapee" et le flux d execution continue.\n\n---\n\nEXCEPTIONS COURANTES\n\nJava definit de nombreux types d exceptions :\n\n  // Division par zero\n  try {\n      int resultat = 10 / 0;\n  } catch (ArithmeticException e) {\n      System.out.println("Division par zero impossible !");\n  }\n\n  // Conversion de type invalide\n  try {\n      int nombre = Integer.parseInt("abc");\n  } catch (NumberFormatException e) {\n      System.out.println("Format numerique invalide !");\n  }\n\n  // Acces a un objet null\n  try {\n      String texte = null;\n      System.out.println(texte.length());\n  } catch (NullPointerException e) {\n      System.out.println("Reference nulle !");\n  }\n\n---\n\nLE MESSAGE D EXCEPTION\n\nChaque exception contient un message descriptif accessible via getMessage() :\n\n  try {\n      int valeur = Integer.parseInt("bonjour");\n  } catch (NumberFormatException e) {\n      System.out.println("Erreur : " + e.getMessage());\n      // Erreur : For input string: "bonjour"\n  }\n\n---\n\nPLUSIEURS BLOCS CATCH\n\nOn peut attraper plusieurs types d exceptions differents :\n\n  public static void diviser(int a, int b) {\n      try {\n          int resultat = a / b;\n          System.out.println("Resultat : " + resultat);\n      } catch (ArithmeticException e) {\n          System.out.println("Erreur : division par zero");\n      } catch (Exception e) {\n          System.out.println("Erreur inattendue : " + e.getMessage());\n      }\n  }\n\nLes catch sont evalues dans l ordre. Exception est la classe parente de toutes les exceptions : c est le "filet de securite" a placer en dernier.\n\n---\n\nLE BLOC FINALLY\n\nLe bloc finally s execute TOUJOURS, qu une exception soit levee ou non. Utile pour liberer des ressources (fermer un fichier, une connexion) :\n\n  try {\n      System.out.println("Tentative de connexion...");\n      int resultat = 10 / 2;\n      System.out.println("Resultat : " + resultat);\n  } catch (ArithmeticException e) {\n      System.out.println("Erreur : " + e.getMessage());\n  } finally {\n      System.out.println("Nettoyage effectue (toujours execute)");\n  }\n  // Tentative de connexion...\n  // Resultat : 5\n  // Nettoyage effectue (toujours execute)\n\n---\n\nLEVER UNE EXCEPTION AVEC THROW\n\nOn peut aussi creer et lancer une exception manuellement avec throw :\n\n  public static void verifierAge(int age) {\n      if (age < 0) {\n          throw new IllegalArgumentException("L age ne peut pas etre negatif : " + age);\n      }\n      System.out.println("Age valide : " + age);\n  }\n\n  // Dans main :\n  verifierAge(25);  // Age valide : 25\n  verifierAge(-5);  // IllegalArgumentException levee\n\nIllegalArgumentException est l exception standard pour signaler un argument invalide.\n\n---\n\nBONNES PRATIQUES\n\n1. Attrapez des exceptions specifiques (ArithmeticException, NumberFormatException) plutot que Exception pour avoir des messages d erreur precis.\n2. N utilisez pas try/catch pour controler le flux normal de votre programme. Les exceptions sont pour les cas anormaux.\n3. Utilisez finally pour liberer des ressources (connexions, fichiers).\n4. Affichez toujours un message d erreur utile pour aider au debogage.',
    1,
    35
FROM chapters c WHERE c.slug = 'gestion-exceptions';

-- =============================================
-- QUIZ : try/catch/finally
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - try/catch/finally',
    'Testez vos connaissances sur la gestion des exceptions en Java',
    300, 70, 100
FROM lessons l WHERE l.slug = 'try-catch-finally';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que se passe-t-il si une exception n est pas attrapee par un bloc catch ?',
        'SINGLE_CHOICE',
        'Si une exception n est pas attrapee, elle remonte la pile d appels et provoque l arret brutal du programme avec un message d erreur (stack trace).',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Le programme continue normalement en ignorant l erreur', false, 1),
((SELECT id FROM q), 'L exception est automatiquement corrigee par Java', false, 2),
((SELECT id FROM q), 'Le programme s arrete brutalement avec un message d erreur', true, 3),
((SELECT id FROM q), 'Le programme recommence depuis le debut', false, 4);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel type d exception est levee lors d une division par zero en Java ?',
        'SINGLE_CHOICE',
        'En Java, diviser un entier par zero leve une ArithmeticException avec le message "/ by zero".',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index) VALUES
((SELECT id FROM q), 'DivisionException', false, 1),
((SELECT id FROM q), 'MathException', false, 2),
((SELECT id FROM q), 'IllegalArgumentException', false, 3),
((SELECT id FROM q), 'ArithmeticException', true, 4);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Dans quel cas le bloc finally est-il execute ?',
        'SINGLE_CHOICE',
        'Le bloc finally est execute dans TOUS les cas : que le code du try se termine normalement, qu une exception soit levee et attrapee, ou meme qu une exception ne soit pas attrapee.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Uniquement si une exception est levee', false, 1),
((SELECT id FROM q), 'Uniquement si aucune exception n est levee', false, 2),
((SELECT id FROM q), 'Toujours, qu une exception soit levee ou non', true, 3),
((SELECT id FROM q), 'Uniquement si l exception est de type RuntimeException', false, 4);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que retourne la methode getMessage() sur une exception ?',
        'SINGLE_CHOICE',
        'getMessage() retourne le message d erreur textuel associe a l exception, qui decrit la cause de l erreur.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Le type de l exception sous forme de String', false, 1),
((SELECT id FROM q), 'Le message d erreur descriptif de l exception', true, 2),
((SELECT id FROM q), 'Le numero de ligne ou l exception a ete levee', false, 3),
((SELECT id FROM q), 'La valeur null si aucun message n est defini', false, 4);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est l exception levee par Integer.parseInt("abc") ?',
        'SINGLE_CHOICE',
        'Integer.parseInt() leve une NumberFormatException quand la chaine ne peut pas etre convertie en entier.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index) VALUES
((SELECT id FROM q), 'ClassCastException', false, 1),
((SELECT id FROM q), 'IllegalArgumentException', false, 2),
((SELECT id FROM q), 'NumberFormatException', true, 3),
((SELECT id FROM q), 'ParseException', false, 4);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel mot-cle permet de lancer manuellement une exception ?',
        'SINGLE_CHOICE',
        'Le mot-cle throw permet de lever manuellement une exception. throws (avec s) est utilise dans la signature d une methode pour declarer qu elle peut propager une exception.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'try-catch-finally'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index) VALUES
((SELECT id FROM q), 'raise', false, 1),
((SELECT id FROM q), 'throws', false, 2),
((SELECT id FROM q), 'throw', true, 3),
((SELECT id FROM q), 'exception', false, 4);
