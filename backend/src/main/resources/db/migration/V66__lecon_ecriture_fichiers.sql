-- V66: Lecon 2 Fichiers et IO - Ecriture de fichiers (Files.write, BufferedWriter) + Quiz

-- =============================================
-- LECON 2 : Ecriture de fichiers
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Ecriture de fichiers : Files.write et BufferedWriter',
    'ecriture-fichiers',
    E'ECRITURE DE FICHIERS : FILES.WRITE ET BUFFEREDWRITER\n\nApres avoir appris a lire des fichiers, voyons comment en ecrire. Java propose plusieurs approches selon vos besoins.\n\n---\n\nFILES.WRITE : ECRITURE SIMPLE\n\nFiles.write() est la methode la plus simple pour ecrire dans un fichier :\n\n  import java.nio.file.Files;\n  import java.nio.file.Paths;\n  import java.util.Arrays;\n  import java.util.List;\n\n  // Ecrire une liste de lignes\n  List<String> lignes = Arrays.asList("Ligne 1", "Ligne 2", "Ligne 3");\n  Files.write(Paths.get("sortie.txt"), lignes);\n\n  // Ecrire une chaine directement (Java 11+)\n  Files.writeString(Paths.get("message.txt"), "Bonjour le monde !");\n\nATTENTION : Files.write() ecrase le fichier existant par defaut.\n\n---\n\nOPTIONS D ECRITURE : APPEND ET CREATE\n\nAvec StandardOpenOption, vous controlez le comportement :\n\n  import java.nio.file.StandardOpenOption;\n\n  // Ajouter a la fin du fichier (APPEND)\n  Files.write(\n      Paths.get("log.txt"),\n      Arrays.asList("Nouvelle ligne"),\n      StandardOpenOption.APPEND\n  );\n\n  // Creer si inexistant, ecraser si existant (comportement par defaut)\n  Files.write(\n      Paths.get("rapport.txt"),\n      Arrays.asList("Contenu"),\n      StandardOpenOption.CREATE,\n      StandardOpenOption.WRITE\n  );\n\n---\n\nBUFFEREDWRITER : ECRITURE EFFICACE\n\nBufferedWriter est ideal pour ecrire de nombreuses lignes efficacement :\n\n  import java.io.BufferedWriter;\n  import java.io.IOException;\n  import java.nio.file.Files;\n  import java.nio.file.Paths;\n\n  try (BufferedWriter writer = Files.newBufferedWriter(Paths.get("rapport.txt"))) {\n      writer.write("Rapport du jour");\n      writer.newLine(); // saut de ligne\n      writer.write("Nombre de ventes : 42");\n      writer.newLine();\n      writer.write("Chiffre d affaires : 1500.00 euros");\n  } catch (IOException e) {\n      System.out.println("Erreur ecriture : " + e.getMessage());\n  }\n\nLe try-with-resources assure la fermeture automatique du writer.\n\n---\n\nCREER DES REPERTOIRES\n\n  import java.nio.file.Files;\n  import java.nio.file.Paths;\n\n  // Creer un repertoire\n  Files.createDirectory(Paths.get("nouveauDossier"));\n\n  // Creer des repertoires en cascade (parents inclus)\n  Files.createDirectories(Paths.get("a/b/c"));\n\n---\n\nCOPIER ET DEPLACER DES FICHIERS\n\n  import java.nio.file.Files;\n  import java.nio.file.Path;\n  import java.nio.file.Paths;\n  import java.nio.file.StandardCopyOption;\n\n  Path source = Paths.get("fichier.txt");\n  Path destination = Paths.get("copie.txt");\n\n  // Copier (ecrase si existant)\n  Files.copy(source, destination, StandardCopyOption.REPLACE_EXISTING);\n\n  // Deplacer / renommer\n  Files.move(source, Paths.get("renomme.txt"), StandardCopyOption.REPLACE_EXISTING);\n\n  // Supprimer un fichier\n  Files.deleteIfExists(source);\n\n---\n\nEXEMPLE COMPLET : GENERATEUR DE RAPPORT\n\n  import java.io.IOException;\n  import java.nio.file.Files;\n  import java.nio.file.Path;\n  import java.nio.file.Paths;\n  import java.util.List;\n\n  public class GenerateurRapport {\n      public static void main(String[] args) throws IOException {\n          List<String> ventes = List.of("Produit A: 150.00", "Produit B: 89.99", "Produit C: 220.50");\n\n          double total = ventes.stream()\n              .mapToDouble(v -> Double.parseDouble(v.split(": ")[1]))\n              .sum();\n\n          Path rapport = Paths.get("rapport.txt");\n\n          try (var writer = Files.newBufferedWriter(rapport)) {\n              writer.write("=== RAPPORT DE VENTES ===");\n              writer.newLine();\n              for (String vente : ventes) {\n                  writer.write("- " + vente);\n                  writer.newLine();\n              }\n              writer.write(String.format("TOTAL: %.2f euros", total));\n          }\n\n          System.out.println("Rapport genere : " + rapport.toAbsolutePath());\n          System.out.println(Files.readString(rapport));\n      }\n  }\n\n---\n\nBONNES PRATIQUES\n\n1. Utilisez toujours try-with-resources avec BufferedWriter pour eviter les fuites de ressources.\n2. Files.write() est pratique pour les petits fichiers, BufferedWriter pour les grands.\n3. Verifiez que le repertoire parent existe avant d ecrire (Files.createDirectories(path.getParent())).\n4. Gerez toujours IOException, n ignorez jamais les erreurs d ecriture.\n5. Utilisez StandardOpenOption.APPEND pour ajouter a un fichier existant sans l ecraser.',
    2,
    40
FROM chapters c WHERE c.slug = 'fichiers-io';

-- =============================================
-- QUIZ : Ecriture de fichiers
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Ecriture de fichiers',
    'Testez vos connaissances sur Files.write, BufferedWriter et les options d ecriture',
    300, 70, 100
FROM lessons l WHERE l.slug = 'ecriture-fichiers';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment ajouter du contenu a la fin d un fichier existant sans l ecraser ?',
        'SINGLE_CHOICE',
        'StandardOpenOption.APPEND indique a Files.write() d ajouter le contenu a la fin du fichier plutot que de l ecraser. Sans cette option, le fichier est ecrase par defaut.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'ecriture-fichiers'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Files.write(path, lignes)', false, 1),
    ('Files.write(path, lignes, StandardOpenOption.APPEND)', true, 2),
    ('Files.append(path, lignes)', false, 3),
    ('Files.writeString(path, contenu, "APPEND")', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle classe est recommandee pour ecrire efficacement de nombreuses lignes ?',
        'SINGLE_CHOICE',
        'BufferedWriter bufferise les ecritures en memoire et les envoie par blocs, ce qui est beaucoup plus efficace que d ecrire caractere par caractere. Files.newBufferedWriter(path) est la facon recommandee de l obtenir.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'ecriture-fichiers'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('FileWriter', false, 1),
    ('PrintWriter', false, 2),
    ('BufferedWriter', true, 3),
    ('OutputStreamWriter', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode Files cree des repertoires intermediaires si necessaire ?',
        'SINGLE_CHOICE',
        'Files.createDirectory() echoue si le repertoire parent n existe pas. Files.createDirectories() cree tous les repertoires intermediaires manquants, comme la commande mkdir -p.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'ecriture-fichiers'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Files.createDirectory(path)', false, 1),
    ('Files.makeDirectories(path)', false, 2),
    ('Files.createDirectories(path)', true, 3),
    ('Files.mkdir(path)', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment copier un fichier en ecrasant la destination si elle existe ?',
        'SINGLE_CHOICE',
        'Par defaut, Files.copy() leve une exception si le fichier destination existe deja. StandardCopyOption.REPLACE_EXISTING autorise l ecrasement.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'ecriture-fichiers'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Files.copy(source, dest)', false, 1),
    ('Files.copy(source, dest, StandardCopyOption.REPLACE_EXISTING)', true, 2),
    ('Files.overwrite(source, dest)', false, 3),
    ('Files.copy(source, dest, true)', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que fait writer.newLine() dans BufferedWriter ?',
        'SINGLE_CHOICE',
        'newLine() insere le separateur de ligne du systeme d exploitation (\n sur Linux/Mac, \r\n sur Windows), ce qui est plus portable que d ecrire "\n" directement.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'ecriture-fichiers'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Ferme le writer', false, 1),
    ('Insere un retour a la ligne adapte au systeme d exploitation', true, 2),
    ('Vide le buffer', false, 3),
    ('Insere un espace', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la facon recommandee d utiliser BufferedWriter ?',
        'SINGLE_CHOICE',
        'try-with-resources garantit que le writer est ferme automatiquement, meme en cas d exception. Oublier de fermer un writer peut entrainer des fuites de ressources et des donnees non ecrites (non flushees).',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'ecriture-fichiers'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('BufferedWriter writer = new BufferedWriter(); writer.close();', false, 1),
    ('try (BufferedWriter writer = Files.newBufferedWriter(path)) { ... }', true, 2),
    ('Files.getWriter(path).write(content);', false, 3),
    ('new FileOutputStream(path).write(content.getBytes());', false, 4)
) AS opt(text, is_correct, order_index);
