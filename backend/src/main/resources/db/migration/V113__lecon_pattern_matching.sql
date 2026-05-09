-- V113: Lecon 2 Java Moderne - Pattern Matching + Quiz + Exercices

-- =============================================
-- LECON 2 : Pattern Matching
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Pattern Matching et Switch Expressions',
    'pattern-matching',
    E'PATTERN MATCHING ET SWITCH EXPRESSIONS\n\nJava 14-21 a introduit des syntaxes plus expressives pour les branchements conditionnels : switch expressions, pattern matching instanceof, et pattern matching dans les switch. Ces fonctionnalites remplacent du code verbeux par des expressions concises.\n\n---\n\nSWITCH EXPRESSION (Java 14+)\n\nAvant Java 14, switch etait une instruction avec des break fragiles :\n\n  // Ancien style (fragile, oubli de break = bug)\n  String libelle;\n  switch (jour) {\n      case MONDAY: libelle = "Lundi"; break;\n      case TUESDAY: libelle = "Mardi"; break;\n      default: libelle = "Autre"; break;\n  }\n\nDepuis Java 14, switch est une expression avec -> :\n\n  // Nouveau style : concis et surete (pas de fall-through)\n  String libelle = switch (jour) {\n      case MONDAY  -> "Lundi";\n      case TUESDAY -> "Mardi";\n      case WEDNESDAY -> "Mercredi";\n      default -> "Autre";\n  };\n\n  System.out.println(libelle); // Lundi, Mardi...\n\nAvantages : plus de break, pas de fall-through accidentel, c est une expression (assignable).\n\n---\n\nSWITCH AVEC PLUSIEURS CASES\n\nOn peut grouper plusieurs valeurs sur un meme case :\n\n  String typeJour = switch (jour) {\n      case MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY -> "Semaine";\n      case SATURDAY, SUNDAY -> "Weekend";\n  };\n\n---\n\nSWITCH AVEC YIELD\n\nSi on a besoin de plusieurs instructions avant de retourner une valeur, on utilise yield :\n\n  int bonus = switch (niveau) {\n      case "GOLD"   -> 100;\n      case "SILVER" -> 50;\n      case "BRONZE" -> {\n          System.out.println("Calcul bronze...");\n          yield 20; // yield retourne la valeur dans un bloc\n      }\n      default -> 0;\n  };\n\n---\n\nPATTERN MATCHING INSTANCEOF (Java 16+)\n\nAvant Java 16, verifier le type d un objet necessitait un cast explicite :\n\n  // Ancien style\n  if (obj instanceof String) {\n      String s = (String) obj; // cast redondant\n      System.out.println(s.length());\n  }\n\nAvec le pattern matching instanceof :\n\n  // Nouveau style : verification + cast en une seule operation\n  if (obj instanceof String s) {\n      System.out.println(s.length()); // s est directement utilisable\n  }\n\n  // Exemple complet\n  Object[] elements = {42, "Bonjour", 3.14, true};\n\n  for (Object el : elements) {\n      if (el instanceof Integer i) {\n          System.out.println("Entier : " + i * 2);\n      } else if (el instanceof String s) {\n          System.out.println("Chaine : " + s.toUpperCase());\n      } else if (el instanceof Double d) {\n          System.out.println("Decimal : " + d);\n      }\n  }\n  // Entier : 84\n  // Chaine : BONJOUR\n  // Decimal : 3.14\n\n---\n\nPATTERN MATCHING DANS SWITCH (Java 21)\n\nJava 21 combine switch et pattern matching pour une syntaxe encore plus puissante :\n\n  static String decrire(Object obj) {\n      return switch (obj) {\n          case Integer i -> "Entier : " + i;\n          case String s  -> "Chaine : " + s.toUpperCase();\n          case Double d  -> "Decimal : " + d;\n          case null      -> "Valeur nulle";\n          default        -> "Autre : " + obj.getClass().getSimpleName();\n      };\n  }\n\n  System.out.println(decrire(42));      // Entier : 42\n  System.out.println(decrire("Java"));  // Chaine : JAVA\n  System.out.println(decrire(null));    // Valeur nulle\n\n---\n\nGUARDED PATTERNS (Java 21)\n\nOn peut ajouter une condition supplementaire avec when :\n\n  static String categoriser(Object obj) {\n      return switch (obj) {\n          case Integer i when i < 0  -> "Negatif : " + i;\n          case Integer i when i == 0 -> "Zero";\n          case Integer i             -> "Positif : " + i;\n          case String s when s.isEmpty() -> "Chaine vide";\n          case String s              -> "Chaine : " + s;\n          default                    -> "Autre";\n      };\n  }\n\n  System.out.println(categoriser(-5));  // Negatif : -5\n  System.out.println(categoriser(0));   // Zero\n  System.out.println(categoriser(42));  // Positif : 42\n  System.out.println(categoriser(""));  // Chaine vide\n\n---\n\nBONNES PRATIQUES\n\n1. Preferez switch expressions (->) aux anciennes instructions switch avec break.\n2. Groupez les cases identiques : case A, B, C -> ...\n3. Utilisez instanceof avec pattern variable plutot que le double cast.\n4. Le switch sur Object en Java 21 remplace les longues chaines if-else instanceof.\n5. Avec des Records ou des Sealed Classes, le switch peut etre exhaustif sans default.',
    2,
    40
FROM chapters c WHERE c.slug = 'java-moderne';

-- =============================================
-- QUIZ : Pattern Matching
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Pattern Matching et Switch Expressions',
    'Testez vos connaissances sur les switch expressions, le pattern matching instanceof et les guarded patterns de Java moderne',
    300, 70, 100
FROM lessons l WHERE l.slug = 'pattern-matching';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la principale difference entre un switch expression (->) et l ancien switch ?',
        'SINGLE_CHOICE',
        'Le switch expression avec -> est sans fall-through : chaque case est independant, pas besoin de break. C est aussi une expression assignable a une variable. L ancien switch necessitait des break sous peine de bug subtil par fall-through accidentel.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'pattern-matching'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Le switch expression ne supporte que les types primitifs, pas les String', false, 1),
    ('Le switch expression est sans fall-through et peut etre assigne a une variable', true, 2),
    ('Le switch expression est plus lent car il cree un objet supplementaire', false, 3),
    ('Il n y a aucune difference, c est juste une syntaxe alternative', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que fait "if (obj instanceof String s)" en Java 16+ ?',
        'SINGLE_CHOICE',
        'Cette syntaxe combine la verification de type et le cast en une seule operation : elle verifie que obj est une String ET declare la variable s de type String directement utilisable dans le bloc if. Plus besoin du cast explicite (String) obj.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'pattern-matching'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Verifie uniquement si obj est une String, sans creer de variable', false, 1),
    ('Verifie si obj est une String et declare s directement utilisable dans le bloc', true, 2),
    ('Cree une copie de obj dans une nouvelle variable s de type Object', false, 3),
    ('Leve une exception si obj n est pas une String', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'A quoi sert le mot-cle "yield" dans un switch expression ?',
        'SINGLE_CHOICE',
        'yield est utilise dans les blocs {} d un switch expression pour retourner une valeur quand on a besoin de plusieurs instructions. C est l equivalent du return pour un switch expression avec un bloc de code.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'pattern-matching'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Sortir de la boucle switch sans valeur, comme un break', false, 1),
    ('Retourner une valeur depuis un bloc {} dans un switch expression', true, 2),
    ('Lancer une exception depuis un case du switch', false, 3),
    ('Passer au case suivant (fall-through explicite)', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment grouper plusieurs valeurs dans un meme case de switch expression ?',
        'SINGLE_CHOICE',
        'On separe les valeurs par des virgules dans le meme case : case MONDAY, TUESDAY, WEDNESDAY -> "Semaine". C est beaucoup plus lisible que de repeter le case pour chaque valeur ou d utiliser le fall-through de l ancien switch.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'pattern-matching'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('case MONDAY | TUESDAY | WEDNESDAY -> "Semaine"', false, 1),
    ('case MONDAY || TUESDAY || WEDNESDAY -> "Semaine"', false, 2),
    ('case MONDAY, TUESDAY, WEDNESDAY -> "Semaine"', true, 3),
    ('case (MONDAY, TUESDAY, WEDNESDAY) -> "Semaine"', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que permet le "guarded pattern" avec when dans un switch (Java 21) ?',
        'SINGLE_CHOICE',
        'Le guarded pattern permet d ajouter une condition supplementaire a un pattern : case Integer i when i > 0 -> ... ne correspond que si l objet est un Integer ET que i > 0. On peut ainsi avoir plusieurs cases du meme type avec des conditions differentes.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'pattern-matching'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Executer un case uniquement quand une exception est levee', false, 1),
    ('Ajouter une condition supplementaire a un pattern de type', true, 2),
    ('Remplacer le default dans un switch exhaustif', false, 3),
    ('Chainer plusieurs switch expressions en une seule expression', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel est l avantage du switch sur Object avec pattern matching (Java 21) ?',
        'SINGLE_CHOICE',
        'Le switch sur Object avec pattern matching remplace les longues chaines if-else instanceof. Le code est plus lisible, le compilateur peut verifier l exhaustivite des cas, et on evite les casts manuels repetes. C est particulierement utile avec des hierarchies de types.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'pattern-matching'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Il est plus rapide car il utilise une table de hachage en interne', false, 1),
    ('Il remplace les chaines if-else instanceof de facon lisible et verifiable', true, 2),
    ('Il permet d utiliser des types generiques comme case T -> dans le switch', false, 3),
    ('Il supprime le besoin du mot-cle default dans tous les cas', false, 4)
) AS opt(text, is_correct, order_index);

-- =============================================
-- EXERCICE 1 : Switch Expression jour de semaine (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Switch Expression - Jours de la semaine',
    'EASY',
    'Ecrivez une methode statique String typeJour(String jour) qui utilise un switch expression pour retourner "Semaine" si le jour est Lundi/Mardi/Mercredi/Jeudi/Vendredi, "Weekend" si Samedi/Dimanche, et "Inconnu" sinon. Dans le main, testez avec "Lundi", "Samedi" et "Fete". Affichez le resultat de chaque appel.',
    E'public class Main {\n    static String typeJour(String jour) {\n        // TODO: switch expression avec ->\n        // "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi" -> "Semaine"\n        // "Samedi", "Dimanche" -> "Weekend"\n        // default -> "Inconnu"\n        return "";\n    }\n\n    public static void main(String[] args) {\n        System.out.println(typeJour("Lundi"));\n        System.out.println(typeJour("Samedi"));\n        System.out.println(typeJour("Fete"));\n    }\n}',
    E'public class Main {\n    static String typeJour(String jour) {\n        return switch (jour) {\n            case "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi" -> "Semaine";\n            case "Samedi", "Dimanche" -> "Weekend";\n            default -> "Inconnu";\n        };\n    }\n\n    public static void main(String[] args) {\n        System.out.println(typeJour("Lundi"));\n        System.out.println(typeJour("Samedi"));\n        System.out.println(typeJour("Fete"));\n    }\n}',
    'output.contains("Semaine") && output.contains("Weekend") && output.contains("Inconnu")',
    '["La syntaxe du switch expression : return switch (variable) { case valeur -> resultat; default -> autre; };", "Pour grouper plusieurs valeurs : case \"Lundi\", \"Mardi\", \"Mercredi\" -> \"Semaine\"; - pas besoin de break", "Le switch expression retourne directement une valeur : on peut ecrire return switch(...) { ... }"]',
    30,
    1
FROM lessons l WHERE l.slug = 'pattern-matching';

-- =============================================
-- EXERCICE 2 : Pattern matching instanceof (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Pattern Matching instanceof - Formateur de valeurs',
    'MEDIUM',
    'Ecrivez une methode statique String formater(Object obj) qui utilise le pattern matching instanceof pour : si obj est un Integer i, retourner "Entier: " + i, si obj est un Double d, retourner "Decimal: " + String.format("%.2f", d), si obj est un String s, retourner "Texte: " + s.toUpperCase(), si obj est un Boolean b, retourner b ? "OUI" : "NON", sinon retourner "Inconnu". Dans le main, testez avec 42, 3.14159, "hello", true et une liste vide.',
    E'import java.util.List;\n\npublic class Main {\n    static String formater(Object obj) {\n        // TODO: utiliser le pattern matching instanceof\n        // if (obj instanceof Integer i) { ... }\n        // if (obj instanceof Double d) { ... }\n        // etc.\n        return "Inconnu";\n    }\n\n    public static void main(String[] args) {\n        System.out.println(formater(42));\n        System.out.println(formater(3.14159));\n        System.out.println(formater("hello"));\n        System.out.println(formater(true));\n        System.out.println(formater(List.of()));\n    }\n}',
    E'import java.util.List;\n\npublic class Main {\n    static String formater(Object obj) {\n        if (obj instanceof Integer i) {\n            return "Entier: " + i;\n        } else if (obj instanceof Double d) {\n            return "Decimal: " + String.format("%.2f", d);\n        } else if (obj instanceof String s) {\n            return "Texte: " + s.toUpperCase();\n        } else if (obj instanceof Boolean b) {\n            return b ? "OUI" : "NON";\n        } else {\n            return "Inconnu";\n        }\n    }\n\n    public static void main(String[] args) {\n        System.out.println(formater(42));\n        System.out.println(formater(3.14159));\n        System.out.println(formater("hello"));\n        System.out.println(formater(true));\n        System.out.println(formater(List.of()));\n    }\n}',
    'output.contains("Entier: 42") && output.contains("Decimal: 3.14") && output.contains("Texte: HELLO") && output.contains("OUI") && output.contains("Inconnu")',
    '["Syntaxe : if (obj instanceof Integer i) { return \"Entier: \" + i; } - i est directement de type Integer, pas besoin de cast", "Pour le Double avec 2 decimales : String.format(\"%.2f\", d)", "Les if-else instanceof sont dans l ordre : le premier match gagne. Comme Integer et Double sont differents, l ordre n a pas d importance ici"]',
    40,
    2
FROM lessons l WHERE l.slug = 'pattern-matching';

-- =============================================
-- EXERCICE 3 : Switch avec pattern matching et guarded patterns (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Switch Pattern Matching - Evaluateur de valeurs',
    'HARD',
    'Ecrivez une methode statique String evaluer(Object obj) qui utilise un switch avec pattern matching (Java 21) : case null -> "Nul", case Integer i when i < 0 -> "Entier negatif: " + i, case Integer i when i == 0 -> "Zero", case Integer i -> "Entier positif: " + i, case String s when s.isEmpty() -> "Chaine vide", case String s -> "Chaine (" + s.length() + " chars): " + s, case Double d -> "Decimal: " + d, default -> "Type inconnu: " + obj.getClass().getSimpleName(). Dans le main, testez avec null, -5, 0, 42, "", "Java", 3.14 et true.',
    E'public class Main {\n    static String evaluer(Object obj) {\n        // TODO: switch avec pattern matching et guarded patterns\n        return switch (obj) {\n            // case null -> ...\n            // case Integer i when i < 0 -> ...\n            // case Integer i when i == 0 -> ...\n            // case Integer i -> ...\n            // case String s when s.isEmpty() -> ...\n            // case String s -> ...\n            // case Double d -> ...\n            // default -> ...\n            default -> "TODO";\n        };\n    }\n\n    public static void main(String[] args) {\n        System.out.println(evaluer(null));\n        System.out.println(evaluer(-5));\n        System.out.println(evaluer(0));\n        System.out.println(evaluer(42));\n        System.out.println(evaluer(""));\n        System.out.println(evaluer("Java"));\n        System.out.println(evaluer(3.14));\n        System.out.println(evaluer(true));\n    }\n}',
    E'public class Main {\n    static String evaluer(Object obj) {\n        return switch (obj) {\n            case null                       -> "Nul";\n            case Integer i when i < 0      -> "Entier negatif: " + i;\n            case Integer i when i == 0     -> "Zero";\n            case Integer i                 -> "Entier positif: " + i;\n            case String s when s.isEmpty() -> "Chaine vide";\n            case String s                  -> "Chaine (" + s.length() + " chars): " + s;\n            case Double d                  -> "Decimal: " + d;\n            default -> "Type inconnu: " + obj.getClass().getSimpleName();\n        };\n    }\n\n    public static void main(String[] args) {\n        System.out.println(evaluer(null));\n        System.out.println(evaluer(-5));\n        System.out.println(evaluer(0));\n        System.out.println(evaluer(42));\n        System.out.println(evaluer(""));\n        System.out.println(evaluer("Java"));\n        System.out.println(evaluer(3.14));\n        System.out.println(evaluer(true));\n    }\n}',
    'output.contains("Nul") && output.contains("Entier negatif: -5") && output.contains("Zero") && output.contains("Entier positif: 42") && output.contains("Chaine vide") && output.contains("Chaine (4 chars): Java") && output.contains("Decimal: 3.14") && output.contains("Type inconnu: Boolean")',
    '["Le switch avec pattern matching s ecrit : return switch (obj) { case Integer i -> ...; case String s -> ...; default -> ...; };", "Les guarded patterns : case Integer i when i < 0 -> ... Le plus specifique (i < 0) doit venir avant le general (i). Java respecte l ordre des cases.", "Pour case null, ecrivez-le avant les patterns de type car null ne correspond a aucun type. default utilise obj.getClass().getSimpleName() pour nommer le type inconnu."]',
    50,
    3
FROM lessons l WHERE l.slug = 'pattern-matching';
