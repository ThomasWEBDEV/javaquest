-- V67: Exercices ecriture de fichiers (Files.write, BufferedWriter, StandardOpenOption)

-- =============================================
-- EXERCICE 1 : Journal de Bord (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Journal de Bord',
    'EASY',
    'Creez un fichier temporaire et ecrivez-y 4 lignes representant un journal de bord. Lisez ensuite le fichier et affichez son contenu ligne par ligne, ainsi que le nombre total de lignes.',
    E'import java.io.IOException;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.util.Arrays;\nimport java.util.List;\n\npublic class Main {\n    public static void main(String[] args) throws IOException {\n        Path journal = Files.createTempFile("journal", ".txt");\n\n        // Ecrivez ces 4 lignes avec Files.write()\n        List<String> entrees = Arrays.asList(\n            "Lundi : debut du projet",\n            "Mardi : implementation",\n            "Mercredi : tests",\n            "Jeudi : livraison"\n        );\n\n        // Lisez le fichier et affichez le nombre de lignes puis chaque ligne\n    }\n}',
    E'import java.io.IOException;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.util.Arrays;\nimport java.util.List;\n\npublic class Main {\n    public static void main(String[] args) throws IOException {\n        Path journal = Files.createTempFile("journal", ".txt");\n\n        List<String> entrees = Arrays.asList(\n            "Lundi : debut du projet",\n            "Mardi : implementation",\n            "Mercredi : tests",\n            "Jeudi : livraison"\n        );\n\n        Files.write(journal, entrees);\n\n        List<String> lignes = Files.readAllLines(journal);\n        System.out.println(lignes.size());\n        lignes.forEach(System.out::println);\n    }\n}',
    'output.contains("4") && output.contains("Lundi : debut du projet") && output.contains("Jeudi : livraison")',
    '["Utilisez Files.write(journal, entrees) pour ecrire la liste", "Puis Files.readAllLines(journal) pour relire", "Affichez lignes.size() puis lignes.forEach(System.out::println)"]',
    30,
    1
FROM lessons l WHERE l.slug = 'ecriture-fichiers';

-- =============================================
-- EXERCICE 2 : Rapport de Ventes (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Rapport de Ventes',
    'MEDIUM',
    'Generez un rapport de ventes dans un fichier. Utilisez BufferedWriter pour ecrire un en-tete, les ventes une par une, puis le total calcule. Relisez le fichier et affichez son contenu.',
    E'import java.io.BufferedWriter;\nimport java.io.IOException;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.util.Arrays;\nimport java.util.List;\n\npublic class Main {\n    public static void main(String[] args) throws IOException {\n        Path rapport = Files.createTempFile("rapport", ".txt");\n        List<String> ventes = Arrays.asList("Stylo:2.50", "Cahier:4.99", "Sac:19.90", "Regle:1.20");\n\n        // Calculez le total des ventes (parsez le prix apres ":")\n        // Utilisez try (BufferedWriter writer = Files.newBufferedWriter(rapport))\n        // Ecrivez "RAPPORT DE VENTES" puis chaque vente puis "TOTAL: X.XX"\n        // Relisez avec Files.readAllLines() et affichez chaque ligne\n    }\n}',
    E'import java.io.BufferedWriter;\nimport java.io.IOException;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.util.Arrays;\nimport java.util.List;\n\npublic class Main {\n    public static void main(String[] args) throws IOException {\n        Path rapport = Files.createTempFile("rapport", ".txt");\n        List<String> ventes = Arrays.asList("Stylo:2.50", "Cahier:4.99", "Sac:19.90", "Regle:1.20");\n\n        double total = ventes.stream()\n            .mapToDouble(v -> Double.parseDouble(v.split(":")[1]))\n            .sum();\n\n        try (BufferedWriter writer = Files.newBufferedWriter(rapport)) {\n            writer.write("RAPPORT DE VENTES");\n            writer.newLine();\n            for (String vente : ventes) {\n                writer.write(vente);\n                writer.newLine();\n            }\n            writer.write(String.format("TOTAL: %.2f", total));\n        }\n\n        Files.readAllLines(rapport).forEach(System.out::println);\n    }\n}',
    'output.contains("RAPPORT DE VENTES") && output.contains("Sac:19.90") && output.contains("TOTAL: 28.59")',
    '["Calculez le total avec .mapToDouble(v -> Double.parseDouble(v.split(\":\")[1])).sum()", "Dans le try-with-resources, ecrivez l en-tete, puis bouclez sur les ventes avec writer.write() et writer.newLine()", "Terminez avec String.format(\"TOTAL: %.2f\", total)"]',
    40,
    2
FROM lessons l WHERE l.slug = 'ecriture-fichiers';

-- =============================================
-- EXERCICE 3 : Systeme de Log (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Systeme de Log',
    'HARD',
    'Implementez un systeme de log simple. Creez un fichier de log, ajoutez 3 entrees en mode APPEND (une a la fois), puis lisez le fichier et affichez le nombre d entrees et la derniere entree uniquement.',
    E'import java.io.IOException;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.nio.file.StandardOpenOption;\nimport java.util.Arrays;\nimport java.util.List;\n\npublic class Main {\n    public static void main(String[] args) throws IOException {\n        Path logFile = Files.createTempFile("app", ".log");\n\n        String[] messages = {\n            "INFO: Application demarree",\n            "INFO: Connexion etablie",\n            "INFO: Traitement termine"\n        };\n\n        // Ajoutez chaque message avec Files.write() en mode APPEND\n        // Hint: Files.write(logFile, Arrays.asList(message), StandardOpenOption.APPEND)\n\n        // Lisez le fichier, affichez le nombre de lignes\n        // Affichez uniquement la derniere ligne\n    }\n}',
    E'import java.io.IOException;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.nio.file.StandardOpenOption;\nimport java.util.Arrays;\nimport java.util.List;\n\npublic class Main {\n    public static void main(String[] args) throws IOException {\n        Path logFile = Files.createTempFile("app", ".log");\n\n        String[] messages = {\n            "INFO: Application demarree",\n            "INFO: Connexion etablie",\n            "INFO: Traitement termine"\n        };\n\n        for (String message : messages) {\n            Files.write(logFile, Arrays.asList(message), StandardOpenOption.APPEND);\n        }\n\n        List<String> lignes = Files.readAllLines(logFile);\n        System.out.println(lignes.size());\n        System.out.println(lignes.get(lignes.size() - 1));\n    }\n}',
    'output.contains("3") && output.contains("INFO: Traitement termine")',
    '["Utilisez une boucle for et Files.write(logFile, Arrays.asList(message), StandardOpenOption.APPEND) pour ajouter chaque message", "Files.readAllLines() retourne une List<String>", "La derniere ligne est lignes.get(lignes.size() - 1)"]',
    50,
    3
FROM lessons l WHERE l.slug = 'ecriture-fichiers';
