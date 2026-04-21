-- V68: Lecon 3 Fichiers et IO - Gestion des repertoires (Files.list, Files.walk) + Quiz

-- =============================================
-- LECON 3 : Gestion des repertoires
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Gestion des repertoires : Files.list et Files.walk',
    'gestion-repertoires',
    E'GESTION DES REPERTOIRES : FILES.LIST ET FILES.WALK\n\nJava NIO.2 offre des outils puissants pour explorer et manipuler des repertoires. Apres avoir maitrise la lecture et l ecriture de fichiers, voyons comment naviguer dans les arborescences.\n\n---\n\nINFORMATIONS SUR UN CHEMIN\n\nAvant de parcourir des repertoires, il est utile de savoir interroger un chemin :\n\n  import java.nio.file.Files;\n  import java.nio.file.Path;\n  import java.nio.file.Paths;\n\n  Path chemin = Paths.get("documents/rapport.txt");\n\n  // Verifier le type\n  System.out.println(Files.isRegularFile(chemin));  // true si c est un fichier\n  System.out.println(Files.isDirectory(chemin));    // true si c est un repertoire\n  System.out.println(Files.exists(chemin));         // true si le chemin existe\n\n  // Obtenir la taille en octets\n  long taille = Files.size(chemin);\n  System.out.println("Taille : " + taille + " octets");\n\n  // Nom du fichier ou dossier\n  System.out.println(chemin.getFileName()); // rapport.txt\n\n---\n\nFILES.LIST : CONTENU DIRECT D UN REPERTOIRE\n\nFiles.list(Path) retourne un Stream<Path> contenant les entrees DIRECTES du repertoire (non recursif) :\n\n  import java.io.IOException;\n  import java.nio.file.Files;\n  import java.nio.file.Path;\n  import java.nio.file.Paths;\n\n  Path dossier = Paths.get("documents");\n\n  try (Stream<Path> entrees = Files.list(dossier)) {\n      entrees.forEach(p -> System.out.println(p.getFileName()));\n  } catch (IOException e) {\n      System.out.println("Erreur : " + e.getMessage());\n  }\n\nIMPORTANT : Files.list() retourne un Stream<Path> qui doit etre ferme avec try-with-resources.\nFiles.list() ne descend PAS dans les sous-repertoires.\n\n  // Compter les fichiers dans un repertoire\n  try (Stream<Path> entrees = Files.list(dossier)) {\n      long nombre = entrees\n          .filter(Files::isRegularFile)\n          .count();\n      System.out.println("Nombre de fichiers : " + nombre);\n  } catch (IOException e) {\n      System.out.println("Erreur : " + e.getMessage());\n  }\n\n---\n\nFILES.WALK : TRAVERSEE RECURSIVE\n\nFiles.walk(Path) parcourt recursivement toute l arborescence et retourne un Stream<Path> :\n\n  import java.io.IOException;\n  import java.nio.file.Files;\n  import java.nio.file.Path;\n  import java.nio.file.Paths;\n\n  Path racine = Paths.get("projet");\n\n  try (Stream<Path> tous = Files.walk(racine)) {\n      tous.forEach(p -> System.out.println(p));\n  } catch (IOException e) {\n      System.out.println("Erreur : " + e.getMessage());\n  }\n\nFiles.walk() inclut le repertoire racine lui-meme dans les resultats.\nVous pouvez limiter la profondeur : Files.walk(racine, 2) descend au maximum de 2 niveaux.\n\n  // Lister uniquement les fichiers .txt de maniere recursive\n  try (Stream<Path> tous = Files.walk(racine)) {\n      tous.filter(p -> p.toString().endsWith(".txt"))\n          .forEach(System.out::println);\n  } catch (IOException e) {\n      System.out.println("Erreur : " + e.getMessage());\n  }\n\n---\n\nCREER ET SUPPRIMER DES REPERTOIRES\n\n  import java.io.IOException;\n  import java.nio.file.Files;\n  import java.nio.file.Paths;\n\n  // Creer un seul repertoire (le parent doit exister)\n  Files.createDirectory(Paths.get("nouveauDossier"));\n\n  // Creer plusieurs niveaux en une seule operation\n  Files.createDirectories(Paths.get("a/b/c/d"));\n\n  // Supprimer un fichier ou un repertoire vide\n  Files.delete(Paths.get("fichier.txt"));\n\n  // Supprimer sans lever d exception si absent\n  boolean supprime = Files.deleteIfExists(Paths.get("fichier.txt"));\n  System.out.println("Supprime : " + supprime);\n\nATTENTION : Files.delete() leve une DirectoryNotEmptyException si le repertoire n est pas vide.\nPour supprimer un repertoire avec son contenu, il faut d abord supprimer tous les fichiers.\n\n---\n\nEXEMPLE COMPLET : SCANNER UN REPERTOIRE\n\n  import java.io.IOException;\n  import java.nio.file.Files;\n  import java.nio.file.Path;\n  import java.util.stream.Stream;\n\n  public class ScannerRepertoire {\n      public static void main(String[] args) throws IOException {\n          // Creer une arborescence temporaire\n          Path racine = Files.createTempDirectory("projet");\n          Path sousDossier = racine.resolve("sources");\n          Files.createDirectory(sousDossier);\n\n          Files.writeString(racine.resolve("README.txt"), "Documentation");\n          Files.writeString(sousDossier.resolve("Main.java"), "public class Main {}");\n          Files.writeString(sousDossier.resolve("Utils.java"), "public class Utils {}");\n\n          // Lister le contenu direct de la racine\n          System.out.println("Contenu direct :");\n          try (Stream<Path> entrees = Files.list(racine)) {\n              entrees.map(Path::getFileName).forEach(System.out::println);\n          }\n\n          // Lister tous les fichiers .java recursivement\n          System.out.println("Fichiers Java :");\n          try (Stream<Path> tous = Files.walk(racine)) {\n              tous.filter(p -> p.toString().endsWith(".java"))\n                  .map(Path::getFileName)\n                  .forEach(System.out::println);\n          }\n      }\n  }\n\n---\n\nBONNES PRATIQUES\n\n1. Utilisez toujours try-with-resources avec Files.list() et Files.walk() : ce sont des Streams qui encapsulent des ressources systeme.\n2. Preferez Files.list() quand vous n avez besoin que du contenu direct, c est plus efficace.\n3. Utilisez Files.walk() avec un filtre pour ne pas traiter des milliers de fichiers inutilement.\n4. Pour supprimer un repertoire complet, marchez dessus avec Files.walk() en ordre inverse (tri par profondeur decroissante).\n5. Verifiez toujours Files.isDirectory() avant d appeler Files.list() pour eviter les erreurs.',
    3,
    40
FROM chapters c WHERE c.slug = 'fichiers-io';

-- =============================================
-- QUIZ : Gestion des repertoires
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Gestion des repertoires',
    'Testez vos connaissances sur Files.list, Files.walk et la manipulation de repertoires',
    300, 70, 100
FROM lessons l WHERE l.slug = 'gestion-repertoires';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode de Files liste le contenu DIRECT (non recursif) d un repertoire ?',
        'SINGLE_CHOICE',
        'Files.list(path) retourne un Stream<Path> contenant uniquement les entrees directes du repertoire, sans descendre dans les sous-repertoires. Pour une traversee recursive, il faut utiliser Files.walk(path).',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'gestion-repertoires'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Files.walk(path)', false, 1),
    ('Files.list(path)', true, 2),
    ('Files.readDir(path)', false, 3),
    ('Files.entries(path)', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode traverse recursivement toute l arborescence d un repertoire ?',
        'SINGLE_CHOICE',
        'Files.walk(path) retourne un Stream<Path> qui inclut le repertoire racine, tous ses fichiers et tous ses sous-repertoires de maniere recursive. Files.list(path) ne fait que le niveau direct.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'gestion-repertoires'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Files.list(path)', false, 1),
    ('Files.scan(path)', false, 2),
    ('Files.walk(path)', true, 3),
    ('Files.traverse(path)', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment creer plusieurs repertoires imbriques en une seule operation ?',
        'SINGLE_CHOICE',
        'Files.createDirectories(path) cree tous les repertoires intermediaires manquants, comme mkdir -p. Files.createDirectory(path) echoue si le repertoire parent n existe pas.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'gestion-repertoires'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Files.createDirectory(path)', false, 1),
    ('Files.mkdirs(path)', false, 2),
    ('Files.createDirectories(path)', true, 3),
    ('Files.makeDir(path, true)', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment filtrer uniquement les fichiers .txt avec Files.walk() ?',
        'SINGLE_CHOICE',
        'On utilise .filter(p -> p.toString().endsWith(".txt")) sur le Stream<Path> retourne par Files.walk(). La methode toString() convertit le Path en String pour pouvoir tester l extension.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'gestion-repertoires'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('.filter(p -> p.getExtension().equals(".txt"))', false, 1),
    ('.filter(p -> p.toString().endsWith(".txt"))', true, 2),
    ('.filter(p -> p.getFileName() == ".txt")', false, 3),
    ('.where(p -> p.endsWith(".txt"))', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode supprime un fichier sans lever d exception s il n existe pas ?',
        'SINGLE_CHOICE',
        'Files.deleteIfExists(path) retourne true si le fichier a ete supprime, false s il n existait pas. Files.delete(path) leve une NoSuchFileException si le fichier est absent.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'gestion-repertoires'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Files.delete(path)', false, 1),
    ('Files.remove(path)', false, 2),
    ('Files.deleteIfExists(path)', true, 3),
    ('Files.safeDelete(path)', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que retourne Files.list(path) ?',
        'SINGLE_CHOICE',
        'Files.list(path) retourne un Stream<Path> representant les entrees directes du repertoire. Ce Stream doit etre ferme avec try-with-resources car il encapsule des ressources systeme (le descripteur de repertoire).',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'gestion-repertoires'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('List<Path>', false, 1),
    ('Path[]', false, 2),
    ('Iterator<Path>', false, 3),
    ('Stream<Path>', true, 4)
) AS opt(text, is_correct, order_index);
