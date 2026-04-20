-- V65: Exercices lecture de fichiers (Files, Paths, BufferedReader)

-- =============================================
-- EXERCICE 1 : Mon Premier Fichier (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Mon Premier Fichier',
    'EASY',
    'Creez un fichier temporaire, ecrivez-y 3 lignes, lisez-le avec Files.readAllLines() et affichez chaque ligne. Affichez aussi le nombre total de lignes.',
    E'import java.io.IOException;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.util.Arrays;\nimport java.util.List;\n\npublic class Main {\n    public static void main(String[] args) throws IOException {\n        // Creez un fichier temporaire avec Files.createTempFile("cours", ".txt")\n        // Ecrivez ces lignes dedans avec Files.write(path, lignes)\n        List<String> lignesAEcrire = Arrays.asList("Java", "est", "puissant");\n        \n        // Lisez le fichier avec Files.readAllLines()\n        // Affichez le nombre de lignes\n        // Affichez chaque ligne\n    }\n}',
    E'import java.io.IOException;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.util.Arrays;\nimport java.util.List;\n\npublic class Main {\n    public static void main(String[] args) throws IOException {\n        Path fichier = Files.createTempFile("cours", ".txt");\n        List<String> lignesAEcrire = Arrays.asList("Java", "est", "puissant");\n        Files.write(fichier, lignesAEcrire);\n\n        List<String> lignes = Files.readAllLines(fichier);\n        System.out.println(lignes.size());\n        lignes.forEach(System.out::println);\n    }\n}',
    'output.contains("3") && output.contains("Java") && output.contains("est") && output.contains("puissant")',
    '["Utilisez Files.createTempFile(\"cours\", \".txt\") pour creer un fichier temporaire", "Files.write(path, listeDeLignes) ecrit les lignes dans le fichier", "Files.readAllLines(path) retourne une List<String>"]',
    30,
    1
FROM lessons l WHERE l.slug = 'lecture-fichiers';

-- =============================================
-- EXERCICE 2 : Filtrage de Lignes (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Filtrage de Lignes',
    'MEDIUM',
    'Creez un fichier avec plusieurs lignes de code Java. Lisez-le, filtrez les lignes qui contiennent le mot "import", comptez-les et affichez ce nombre ainsi que chaque ligne filtree.',
    E'import java.io.IOException;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.util.Arrays;\nimport java.util.List;\nimport java.util.stream.Collectors;\n\npublic class Main {\n    public static void main(String[] args) throws IOException {\n        Path fichier = Files.createTempFile("code", ".java");\n        Files.write(fichier, Arrays.asList(\n            "import java.util.List;",\n            "import java.util.Map;",\n            "public class Main {",\n            "    public static void main(String[] args) {",\n            "import java.util.stream.Collectors;",\n            "    }",\n            "}"\n        ));\n\n        // Lisez le fichier avec Files.readAllLines()\n        // Filtrez les lignes contenant "import" avec stream().filter()\n        // Affichez le nombre de lignes import\n        // Affichez chaque ligne import\n    }\n}',
    E'import java.io.IOException;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.util.Arrays;\nimport java.util.List;\nimport java.util.stream.Collectors;\n\npublic class Main {\n    public static void main(String[] args) throws IOException {\n        Path fichier = Files.createTempFile("code", ".java");\n        Files.write(fichier, Arrays.asList(\n            "import java.util.List;",\n            "import java.util.Map;",\n            "public class Main {",\n            "    public static void main(String[] args) {",\n            "import java.util.stream.Collectors;",\n            "    }",\n            "}"\n        ));\n\n        List<String> imports = Files.readAllLines(fichier).stream()\n            .filter(ligne -> ligne.contains("import"))\n            .collect(Collectors.toList());\n\n        System.out.println(imports.size());\n        imports.forEach(System.out::println);\n    }\n}',
    'output.contains("3") && output.contains("import java.util.List;") && output.contains("import java.util.Map;")',
    '["Utilisez Files.readAllLines(fichier) puis .stream() pour obtenir un Stream<String>", "Filtrez avec .filter(ligne -> ligne.contains(\"import\"))", "Collectez avec .collect(Collectors.toList()) et affichez la taille puis chaque element"]',
    40,
    2
FROM lessons l WHERE l.slug = 'lecture-fichiers';

-- =============================================
-- EXERCICE 3 : Statistiques de Fichier (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Statistiques de Fichier',
    'HARD',
    'Creez un fichier contenant des donnees de ventes (une vente par ligne au format "Produit:Prix"). Lisez-le, parsez les prix, et affichez : le nombre de ventes, le total des ventes (avec 2 decimales), et le nom du produit le plus cher.',
    E'import java.io.IOException;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.util.Arrays;\n\npublic class Main {\n    public static void main(String[] args) throws IOException {\n        Path fichier = Files.createTempFile("ventes", ".txt");\n        Files.write(fichier, Arrays.asList(\n            "Ordinateur:899.99",\n            "Souris:29.90",\n            "Clavier:79.50",\n            "Ecran:349.00",\n            "Casque:149.99"\n        ));\n\n        // Lisez le fichier\n        // Comptez le nombre de lignes (= nombre de ventes)\n        // Calculez le total : parsez le prix apres ":" avec Double.parseDouble()\n        // Trouvez le produit le plus cher : extrayez le nom avant ":"\n        // Affichez le nombre, le total (2 decimales), le produit le plus cher\n    }\n}',
    E'import java.io.IOException;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.util.Arrays;\nimport java.util.Comparator;\nimport java.util.List;\n\npublic class Main {\n    public static void main(String[] args) throws IOException {\n        Path fichier = Files.createTempFile("ventes", ".txt");\n        Files.write(fichier, Arrays.asList(\n            "Ordinateur:899.99",\n            "Souris:29.90",\n            "Clavier:79.50",\n            "Ecran:349.00",\n            "Casque:149.99"\n        ));\n\n        List<String> lignes = Files.readAllLines(fichier);\n\n        long nombre = lignes.size();\n        double total = lignes.stream()\n            .mapToDouble(l -> Double.parseDouble(l.split(":")[1]))\n            .sum();\n        String plusCher = lignes.stream()\n            .max(Comparator.comparingDouble(l -> Double.parseDouble(l.split(":")[1])))\n            .map(l -> l.split(":")[0])\n            .orElse("Inconnu");\n\n        System.out.println(nombre);\n        System.out.printf("%.2f%n", total);\n        System.out.println(plusCher);\n    }\n}',
    'output.contains("5") && output.contains("1508.38") && output.contains("Ordinateur")',
    '["Utilisez lignes.stream().mapToDouble(l -> Double.parseDouble(l.split(\":\")[1])).sum() pour le total", "Pour le produit le plus cher, utilisez .max(Comparator.comparingDouble(l -> Double.parseDouble(l.split(\":\")[1])))", "Extrayez le nom avec .map(l -> l.split(\":\")[0]).orElse(\"Inconnu\")"]',
    50,
    3
FROM lessons l WHERE l.slug = 'lecture-fichiers';
