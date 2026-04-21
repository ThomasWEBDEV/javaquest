-- V69: Exercices gestion des repertoires (Files.list, Files.walk, createDirectories)

-- =============================================
-- EXERCICE 1 : Lister un Repertoire (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Lister un Repertoire',
    'EASY',
    'Creez un repertoire temporaire, ajoutez-y 3 fichiers .txt avec Files.write(), listez son contenu avec Files.list() et affichez le nombre de fichiers puis le nom de chaque fichier.',
    E'import java.io.IOException;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.util.Arrays;\nimport java.util.List;\nimport java.util.stream.Stream;\n\npublic class Main {\n    public static void main(String[] args) throws IOException {\n        // Creez un repertoire temporaire avec Files.createTempDirectory("test")\n        // Creez 3 fichiers .txt dedans : fichier1.txt, fichier2.txt, fichier3.txt\n        // Ecrivez du contenu dans chaque fichier avec Files.write()\n        // Listez le repertoire avec Files.list()\n        // Affichez le nombre de fichiers puis le nom (getFileName()) de chacun\n    }\n}',
    E'import java.io.IOException;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.util.Arrays;\nimport java.util.List;\nimport java.util.stream.Collectors;\nimport java.util.stream.Stream;\n\npublic class Main {\n    public static void main(String[] args) throws IOException {\n        Path repertoire = Files.createTempDirectory("test");\n\n        Files.write(repertoire.resolve("fichier1.txt"), Arrays.asList("Contenu 1"));\n        Files.write(repertoire.resolve("fichier2.txt"), Arrays.asList("Contenu 2"));\n        Files.write(repertoire.resolve("fichier3.txt"), Arrays.asList("Contenu 3"));\n\n        try (Stream<Path> entrees = Files.list(repertoire)) {\n            List<Path> fichiers = entrees.collect(Collectors.toList());\n            System.out.println(fichiers.size());\n            fichiers.stream().map(Path::getFileName).forEach(System.out::println);\n        }\n    }\n}',
    'output.contains("3") && output.contains(".txt")',
    '["Utilisez Files.createTempDirectory(\"test\") pour creer un repertoire temporaire", "Ajoutez des fichiers avec repertoire.resolve(\"fichier1.txt\") pour construire le chemin", "Files.list() retourne un Stream<Path> a fermer avec try-with-resources"]',
    30,
    1
FROM lessons l WHERE l.slug = 'gestion-repertoires';

-- =============================================
-- EXERCICE 2 : Compter par Type (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Compter par Type',
    'MEDIUM',
    'Creez une arborescence avec un repertoire contenant 2 fichiers .txt et 1 fichier .log. Utilisez Files.walk() pour compter separement les fichiers .txt et les fichiers .log. Affichez "Fichiers .txt: X" et "Fichiers .log: Y".',
    E'import java.io.IOException;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.util.Arrays;\nimport java.util.stream.Stream;\n\npublic class Main {\n    public static void main(String[] args) throws IOException {\n        // Creez un repertoire temporaire\n        // Creez 2 fichiers .txt et 1 fichier .log\n        // Utilisez Files.walk() pour compter les .txt\n        // Utilisez Files.walk() pour compter les .log\n        // Affichez "Fichiers .txt: X" et "Fichiers .log: Y"\n    }\n}',
    E'import java.io.IOException;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.util.Arrays;\nimport java.util.stream.Stream;\n\npublic class Main {\n    public static void main(String[] args) throws IOException {\n        Path repertoire = Files.createTempDirectory("logs");\n\n        Files.write(repertoire.resolve("rapport.txt"), Arrays.asList("Rapport principal"));\n        Files.write(repertoire.resolve("notes.txt"), Arrays.asList("Notes diverses"));\n        Files.write(repertoire.resolve("app.log"), Arrays.asList("INFO: demarrage"));\n\n        long nbTxt;\n        try (Stream<Path> tous = Files.walk(repertoire)) {\n            nbTxt = tous.filter(p -> p.toString().endsWith(".txt")).count();\n        }\n\n        long nbLog;\n        try (Stream<Path> tous = Files.walk(repertoire)) {\n            nbLog = tous.filter(p -> p.toString().endsWith(".log")).count();\n        }\n\n        System.out.println("Fichiers .txt: " + nbTxt);\n        System.out.println("Fichiers .log: " + nbLog);\n    }\n}',
    'output.contains("Fichiers .txt: 2") && output.contains("Fichiers .log: 1")',
    '["Utilisez Files.walk(repertoire) pour parcourir recursivement", "Filtrez avec .filter(p -> p.toString().endsWith(\".txt\")) pour les .txt", "Appelez .count() pour obtenir le nombre de fichiers filtres"]',
    40,
    2
FROM lessons l WHERE l.slug = 'gestion-repertoires';

-- =============================================
-- EXERCICE 3 : Taille Totale (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Taille Totale',
    'HARD',
    'Creez un repertoire temporaire avec 3 fichiers ayant du contenu. Utilisez Files.walk() combine avec mapToLong(Files::size) pour calculer la taille totale en octets. Affichez "Taille totale: X octets" et "Nombre de fichiers: 3".',
    E'import java.io.IOException;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.util.Arrays;\nimport java.util.stream.Stream;\n\npublic class Main {\n    public static void main(String[] args) throws IOException {\n        // Creez un repertoire temporaire\n        // Creez 3 fichiers avec du contenu (au moins quelques caracteres)\n        // Utilisez Files.walk() + filter(Files::isRegularFile) + mapToLong(Files::size) + sum()\n        // Comptez les fichiers reguliers\n        // Affichez "Taille totale: X octets" et "Nombre de fichiers: 3"\n    }\n}',
    E'import java.io.IOException;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.util.Arrays;\nimport java.util.stream.Stream;\n\npublic class Main {\n    public static void main(String[] args) throws IOException {\n        Path repertoire = Files.createTempDirectory("mesures");\n\n        Files.write(repertoire.resolve("alpha.txt"), Arrays.asList("Premier fichier avec du contenu"));\n        Files.write(repertoire.resolve("beta.txt"), Arrays.asList("Deuxieme fichier avec encore plus de contenu"));\n        Files.write(repertoire.resolve("gamma.txt"), Arrays.asList("Troisieme fichier"));\n\n        long tailleTotale;\n        try (Stream<Path> tous = Files.walk(repertoire)) {\n            tailleTotale = tous\n                .filter(Files::isRegularFile)\n                .mapToLong(p -> {\n                    try { return Files.size(p); } catch (IOException e) { return 0L; }\n                })\n                .sum();\n        }\n\n        long nombreFichiers;\n        try (Stream<Path> tous = Files.walk(repertoire)) {\n            nombreFichiers = tous.filter(Files::isRegularFile).count();\n        }\n\n        System.out.println("Taille totale: " + tailleTotale + " octets");\n        System.out.println("Nombre de fichiers: " + nombreFichiers);\n    }\n}',
    'output.contains("Taille totale:") && output.contains("Nombre de fichiers: 3")',
    '["Utilisez .filter(Files::isRegularFile) pour exclure les repertoires du calcul", "mapToLong(Files::size) convertit chaque Path en sa taille en octets", "Gerez IOException dans le lambda avec un try-catch interne retournant 0L"]',
    50,
    3
FROM lessons l WHERE l.slug = 'gestion-repertoires';
