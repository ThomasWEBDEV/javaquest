-- V58: Exercices Streams avances (distinct, flatMap, skip/limit)

-- =============================================
-- EXERCICE 1 : Villes Uniques (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Villes Uniques',
    'EASY',
    'Vous avez une liste de villes avec des doublons. Utilisez distinct() pour obtenir les villes uniques, sorted() pour les trier alphabetiquement, et affichez-les une par une.',
    E'import java.util.List;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<String> villes = List.of("Paris", "Lyon", "Paris", "Marseille", "Lyon", "Nice", "Paris");\n\n        // Utilisez distinct() pour supprimer les doublons\n        // Utilisez sorted() pour trier alphabetiquement\n        // Utilisez forEach(System.out::println) pour afficher\n    }\n}',
    E'import java.util.List;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<String> villes = List.of("Paris", "Lyon", "Paris", "Marseille", "Lyon", "Nice", "Paris");\n\n        villes.stream()\n            .distinct()\n            .sorted()\n            .forEach(System.out::println);\n    }\n}',
    'output.contains("Lyon") && output.contains("Marseille") && output.contains("Nice") && output.contains("Paris") && !output.contains("Paris\nParis")',
    '["Utilisez .distinct() pour supprimer les doublons", "Ajoutez .sorted() pour trier alphabetiquement", "Terminez avec .forEach(System.out::println) pour afficher chaque ville"]',
    30,
    1
FROM lessons l WHERE l.slug = 'streams-avances';

-- =============================================
-- EXERCICE 2 : Mots Cles Extraits (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Mots Cles Extraits',
    'MEDIUM',
    'Vous avez une liste de phrases. Extrayez tous les mots distincts de plus de 4 lettres, triez-les alphabetiquement et affichez le nombre total puis chaque mot. Utilisez flatMap pour aplatir les phrases en mots.',
    E'import java.util.Arrays;\nimport java.util.List;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<String> phrases = List.of(\n            "Java est un langage puissant",\n            "les Streams Java sont pratiques",\n            "la programmation fonctionnelle est utile"\n        );\n\n        // Utilisez flatMap(p -> Arrays.stream(p.split(" "))) pour extraire les mots\n        // Filtrez les mots de plus de 4 lettres avec filter()\n        // Supprimez les doublons avec distinct()\n        // Triez avec sorted()\n        // Affichez le nombre puis chaque mot\n    }\n}',
    E'import java.util.Arrays;\nimport java.util.List;\nimport java.util.stream.Collectors;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<String> phrases = List.of(\n            "Java est un langage puissant",\n            "les Streams Java sont pratiques",\n            "la programmation fonctionnelle est utile"\n        );\n\n        List<String> motsCles = phrases.stream()\n            .flatMap(p -> Arrays.stream(p.split(" ")))\n            .filter(m -> m.length() > 4)\n            .distinct()\n            .sorted()\n            .collect(Collectors.toList());\n\n        System.out.println(motsCles.size());\n        motsCles.forEach(System.out::println);\n    }\n}',
    'output.contains("Java") && output.contains("Streams") && output.contains("langage") && output.contains("pratiques") && output.contains("puissant")',
    '["Utilisez flatMap(p -> Arrays.stream(p.split(\" \"))) pour decouper chaque phrase en mots", "Filtrez avec filter(m -> m.length() > 4)", "Chainez distinct().sorted() pour obtenir des mots uniques tries"]',
    40,
    2
FROM lessons l WHERE l.slug = 'streams-avances';

-- =============================================
-- EXERCICE 3 : Pagination de Resultats (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Pagination de Resultats',
    'HARD',
    'Vous avez une liste de 20 produits numerotes. Implementez la pagination : affichez les produits de la page 2 avec 5 produits par page. Utilisez skip() et limit(). Affichez ensuite combien de produits il reste apres la page 2.',
    E'import java.util.stream.Collectors;\nimport java.util.stream.IntStream;\nimport java.util.List;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<String> produits = IntStream.rangeClosed(1, 20)\n            .mapToObj(i -> "Produit " + i)\n            .collect(Collectors.toList());\n\n        int page = 2;\n        int taille = 5;\n\n        // Calculez le nombre a sauter : (page - 1) * taille\n        // Utilisez skip() puis limit() pour la page 2\n        // Affichez chaque produit de la page\n        // Calculez et affichez combien de produits restent apres la page 2\n    }\n}',
    E'import java.util.stream.Collectors;\nimport java.util.stream.IntStream;\nimport java.util.List;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<String> produits = IntStream.rangeClosed(1, 20)\n            .mapToObj(i -> "Produit " + i)\n            .collect(Collectors.toList());\n\n        int page = 2;\n        int taille = 5;\n\n        List<String> pageDeux = produits.stream()\n            .skip((long)(page - 1) * taille)\n            .limit(taille)\n            .collect(Collectors.toList());\n\n        pageDeux.forEach(System.out::println);\n\n        long restants = produits.stream()\n            .skip((long) page * taille)\n            .count();\n        System.out.println(restants);\n    }\n}',
    'output.contains("Produit 6") && output.contains("Produit 10") && output.contains("10")',
    '["Pour la page 2 avec 5 elements par page, sautez (2-1)*5 = 5 elements avec skip(5)", "Utilisez limit(5) pour prendre exactement 5 elements", "Pour les restants, sautez page*taille = 10 elements et utilisez count()"]',
    50,
    3
FROM lessons l WHERE l.slug = 'streams-avances';
