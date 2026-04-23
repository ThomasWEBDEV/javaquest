-- V64: Chapitre 8 Fichiers et IO + Lecon 1 lecture de fichiers + Quiz

-- =============================================
-- CHAPITRE 8 : Fichiers et IO
-- =============================================

INSERT INTO chapters (title, slug, description, order_index, xp_reward, is_published)
VALUES (
    'Fichiers et IO',
    'fichiers-io',
    'Apprenez a lire et ecrire des fichiers en Java avec l API NIO.2, Files, Paths et les flux de donnees',
    8,
    400,
    true
);

-- =============================================
-- LECON 1 : Lecture de fichiers
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Lecture de fichiers : Files, Paths et BufferedReader',
    'lecture-fichiers',
    E'LECTURE DE FICHIERS : FILES, PATHS ET BUFFEREDREADER\n\nLa gestion des fichiers est une competence fondamentale en Java. Depuis Java 7, l API NIO.2 avec java.nio.file rend cette tache beaucoup plus simple et intuitive.\n\n---\n\nPATHS : CREER UN CHEMIN\n\nPath est l abstraction qui represente un chemin vers un fichier ou repertoire :\n\n  import java.nio.file.Path;\n  import java.nio.file.Paths;\n\n  // Chemin absolu\n  Path absolu = Paths.get("/home/user/documents/fichier.txt");\n\n  // Chemin relatif\n  Path relatif = Paths.get("documents/fichier.txt");\n\n  // Combiner des parties de chemin\n  Path combine = Paths.get("documents", "java", "fichier.txt");\n  System.out.println(combine); // documents/java/fichier.txt\n\n  // Infos sur le chemin\n  System.out.println(combine.getFileName()); // fichier.txt\n  System.out.println(combine.getParent());   // documents/java\n\n---\n\nFILES : LIRE UN FICHIER EN ENTIER\n\nLa classe Files propose plusieurs methodes statiques pour lire des fichiers :\n\n  import java.nio.file.Files;\n  import java.nio.file.Path;\n  import java.nio.file.Paths;\n  import java.util.List;\n\n  Path chemin = Paths.get("notes.txt");\n\n  // Lire toutes les lignes dans une List<String>\n  List<String> lignes = Files.readAllLines(chemin);\n  System.out.println("Nombre de lignes : " + lignes.size());\n\n  for (String ligne : lignes) {\n      System.out.println(ligne);\n  }\n\n  // Lire le contenu entier en une chaine\n  String contenu = Files.readString(chemin);\n  System.out.println(contenu);\n\nIMPORTANT : Ces methodes levent une IOException. Il faut les entourer d un try-catch :\n\n  try {\n      List<String> lignes = Files.readAllLines(Paths.get("notes.txt"));\n      lignes.forEach(System.out::println);\n  } catch (IOException e) {\n      System.out.println("Erreur : " + e.getMessage());\n  }\n\n---\n\nBUFFEREDREADER : LIRE LIGNE PAR LIGNE\n\nPour les grands fichiers, BufferedReader est plus efficace :\n\n  import java.io.BufferedReader;\n  import java.io.IOException;\n  import java.nio.file.Files;\n  import java.nio.file.Paths;\n\n  try (BufferedReader reader = Files.newBufferedReader(Paths.get("fichier.txt"))) {\n      String ligne;\n      while ((ligne = reader.readLine()) != null) {\n          System.out.println(ligne);\n      }\n  } catch (IOException e) {\n      System.out.println("Erreur de lecture : " + e.getMessage());\n  }\n\nLe bloc try-with-resources garantit que le fichier est ferme automatiquement.\n\n---\n\nSTREAMS DE LIGNES\n\nFiles.lines() retourne un Stream<String> pour traiter les lignes avec l API Streams :\n\n  import java.io.IOException;\n  import java.nio.file.Files;\n  import java.nio.file.Paths;\n\n  try (Stream<String> lignes = Files.lines(Paths.get("notes.txt"))) {\n      // Compter les lignes non vides\n      long count = lignes\n          .filter(l -> !l.isBlank())\n          .count();\n      System.out.println("Lignes non vides : " + count);\n  } catch (IOException e) {\n      System.out.println("Erreur : " + e.getMessage());\n  }\n\nIMPORTANT : Le Stream retourne par Files.lines() doit etre ferme (try-with-resources).\n\n---\n\nVERIFIER L EXISTENCE D UN FICHIER\n\n  Path chemin = Paths.get("fichier.txt");\n\n  if (Files.exists(chemin)) {\n      System.out.println("Le fichier existe");\n      System.out.println("Taille : " + Files.size(chemin) + " octets");\n  } else {\n      System.out.println("Fichier introuvable");\n  }\n\n  // Verifier si c est un fichier ou un repertoire\n  System.out.println(Files.isRegularFile(chemin));  // true si c est un fichier\n  System.out.println(Files.isDirectory(chemin));     // true si c est un dossier\n\n---\n\nBONNES PRATIQUES\n\n1. Utilisez toujours try-with-resources pour fermer les ressources automatiquement.\n2. Files.readAllLines() est pratique pour les petits fichiers.\n3. BufferedReader ou Files.lines() sont preferes pour les grands fichiers.\n4. Gerez toujours IOException, n ignorez jamais les erreurs de lecture.\n5. Utilisez Paths.get() avec plusieurs arguments plutot que la concatenation de strings.',
    1,
    40
FROM chapters c WHERE c.slug = 'fichiers-io';

-- =============================================
-- QUIZ : Lecture de fichiers
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Lecture de fichiers',
    'Testez vos connaissances sur Files, Paths et BufferedReader',
    300, 70, 100
FROM lessons l WHERE l.slug = 'lecture-fichiers';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode Files permet de lire tout un fichier en une List<String> ?',
        'SINGLE_CHOICE',
        'Files.readAllLines(Path) lit toutes les lignes d un fichier et les retourne dans une List<String>. Elle leve une IOException si le fichier n existe pas ou ne peut pas etre lu.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'lecture-fichiers'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Files.readAll()', false, 1),
    ('Files.readAllLines(path)', true, 2),
    ('Files.getLines(path)', false, 3),
    ('Files.loadFile(path)', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pourquoi faut-il utiliser try-with-resources avec BufferedReader ?',
        'SINGLE_CHOICE',
        'try-with-resources (try (Resource r = ...)) garantit que close() est appele automatiquement a la fin du bloc, meme si une exception survient. Sans cela, le fichier pourrait rester ouvert.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'lecture-fichiers'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Pour accelerer la lecture', false, 1),
    ('Pour garantir la fermeture automatique du fichier meme en cas d exception', true, 2),
    ('Pour eviter les IOException', false, 3),
    ('C est facultatif, juste une convention', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que retourne Files.lines(path) ?',
        'SINGLE_CHOICE',
        'Files.lines() retourne un Stream<String> permettant de traiter les lignes avec l API Streams (filter, map, etc.). Ce Stream doit etre ferme avec try-with-resources.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'lecture-fichiers'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('List<String>', false, 1),
    ('String[]', false, 2),
    ('Stream<String>', true, 3),
    ('BufferedReader', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment creer un Path vers le fichier "documents/java/cours.txt" ?',
        'SINGLE_CHOICE',
        'Paths.get() accepte plusieurs arguments qui sont assembles en chemin de facon portable (independamment du systeme d exploitation). Path.of() existe aussi depuis Java 11 mais Paths.get() reste la methode la plus courante.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'lecture-fichiers'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('new Path("documents/java/cours.txt")', false, 1),
    ('Paths.get("documents", "java", "cours.txt")', true, 2),
    ('Path.of("documents\\java\\cours.txt")', false, 3),
    ('Files.getPath("documents/java/cours.txt")', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment verifier qu un fichier existe avant de le lire ?',
        'SINGLE_CHOICE',
        'Files.exists(Path) retourne true si le fichier ou repertoire existe. C est la methode recommandee avec l API NIO.2.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'lecture-fichiers'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('file.exists()', false, 1),
    ('Files.exists(path)', true, 2),
    ('Path.fileExists()', false, 3),
    ('new File(path).isPresent()', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la difference entre Files.readString() et Files.readAllLines() ?',
        'SINGLE_CHOICE',
        'Files.readString() (Java 11+) lit tout le contenu du fichier en une seule chaine de caracteres. Files.readAllLines() lit chaque ligne et les stocke dans une List<String>, ce qui est plus pratique pour traiter les lignes individuellement.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'lecture-fichiers'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Il n y a pas de difference', false, 1),
    ('readString() retourne tout le contenu en une seule String, readAllLines() retourne une List<String> avec une entree par ligne', true, 2),
    ('readAllLines() est plus rapide', false, 3),
    ('readString() ne fonctionne qu avec les fichiers texte', false, 4)
) AS opt(text, is_correct, order_index);
