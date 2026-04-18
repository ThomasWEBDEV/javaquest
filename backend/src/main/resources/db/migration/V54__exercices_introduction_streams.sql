-- V54: Exercices introduction aux Streams (EASY / MEDIUM / HARD)

-- =============================================
-- EXERCICE 1 : Filtrage de Notes (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Filtrage de Notes',
    'EASY',
    'Utilisez un Stream pour filtrer une liste de notes et n afficher que celles qui sont superieures ou egales a 10. Affichez chaque note sur une ligne.',
    E'import java.util.List;\nimport java.util.stream.Collectors;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<Integer> notes = List.of(8, 15, 6, 12, 18, 9, 14, 3, 11);\n\n        // Creez un Stream a partir de notes\n        // Filtrez les notes >= 10\n        // Affichez chaque note avec forEach\n    }\n}',
    E'import java.util.List;\nimport java.util.stream.Collectors;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<Integer> notes = List.of(8, 15, 6, 12, 18, 9, 14, 3, 11);\n\n        notes.stream()\n            .filter(n -> n >= 10)\n            .forEach(n -> System.out.println(n));\n    }\n}',
    'output.contains("15") && output.contains("12") && output.contains("18") && output.contains("14") && output.contains("11") && !output.contains("8") && !output.contains("6") && !output.contains("9") && !output.contains("3")',
    '["Utilisez notes.stream() pour obtenir un Stream", "Passez la condition n >= 10 dans filter()", "Utilisez forEach(n -> System.out.println(n)) pour afficher chaque element"]',
    30,
    1
FROM lessons l WHERE l.slug = 'introduction-streams';

-- =============================================
-- EXERCICE 2 : Transformation de Prenoms (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Transformation de Prenoms',
    'MEDIUM',
    'A partir d une liste de prenoms, creez une nouvelle liste contenant uniquement les prenoms de plus de 4 lettres, convertis en majuscules et tries alphabetiquement. Affichez la liste resultante.',
    E'import java.util.List;\nimport java.util.stream.Collectors;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<String> prenoms = List.of("Alice", "Bob", "Charlie", "Eva", "Diana", "Luc", "Beatrice");\n\n        // Enchainez les operations sur le Stream :\n        // 1. filter : longueur > 4\n        // 2. sorted : tri alphabetique\n        // 3. map : mettre en majuscules\n        // 4. collect : Collectors.toList()\n        // Puis affichez la liste avec System.out.println()\n    }\n}',
    E'import java.util.List;\nimport java.util.stream.Collectors;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<String> prenoms = List.of("Alice", "Bob", "Charlie", "Eva", "Diana", "Luc", "Beatrice");\n\n        List<String> resultat = prenoms.stream()\n            .filter(p -> p.length() > 4)\n            .sorted()\n            .map(String::toUpperCase)\n            .collect(Collectors.toList());\n\n        System.out.println(resultat);\n    }\n}',
    'output.contains("ALICE") && output.contains("BEATRICE") && output.contains("CHARLIE") && output.contains("DIANA") && !output.contains("BOB") && !output.contains("EVA") && !output.contains("LUC")',
    '["Utilisez .length() > 4 dans filter() pour ne garder que les prenoms longs", "Ajoutez .sorted() sans argument pour le tri alphabetique naturel", "Utilisez String::toUpperCase comme reference de methode dans map()"]',
    50,
    2
FROM lessons l WHERE l.slug = 'introduction-streams';

-- =============================================
-- EXERCICE 3 : Analyse de Produits (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Analyse de Produits',
    'HARD',
    'Vous avez une liste de produits avec nom et prix. Utilisez des Streams pour : (1) afficher les noms des produits de moins de 50 euros tries par prix croissant, (2) afficher la liste des noms en majuscules separes par " | ".',
    E'import java.util.List;\nimport java.util.stream.Collectors;\n\npublic class Main {\n\n    static class Produit {\n        String nom;\n        double prix;\n        Produit(String nom, double prix) {\n            this.nom = nom;\n            this.prix = prix;\n        }\n    }\n\n    public static void main(String[] args) {\n        List<Produit> produits = List.of(\n            new Produit("Stylo", 1.5),\n            new Produit("Cahier", 3.2),\n            new Produit("Ordinateur", 899.0),\n            new Produit("Souris", 25.0),\n            new Produit("Clavier", 45.0),\n            new Produit("Ecran", 350.0),\n            new Produit("Cable", 8.0)\n        );\n\n        // Partie 1 : produits < 50 euros, tries par prix croissant\n        // Affichez chaque nom sur une ligne avec System.out.println()\n        System.out.println("--- Produits abordables ---");\n        // Votre code ici\n\n        // Partie 2 : tous les noms en majuscules rejoins par " | "\n        // Stockez dans une variable String et affichez avec System.out.println()\n        System.out.println("--- Catalogue ---");\n        // Votre code ici\n    }\n}',
    E'import java.util.List;\nimport java.util.stream.Collectors;\n\npublic class Main {\n\n    static class Produit {\n        String nom;\n        double prix;\n        Produit(String nom, double prix) {\n            this.nom = nom;\n            this.prix = prix;\n        }\n    }\n\n    public static void main(String[] args) {\n        List<Produit> produits = List.of(\n            new Produit("Stylo", 1.5),\n            new Produit("Cahier", 3.2),\n            new Produit("Ordinateur", 899.0),\n            new Produit("Souris", 25.0),\n            new Produit("Clavier", 45.0),\n            new Produit("Ecran", 350.0),\n            new Produit("Cable", 8.0)\n        );\n\n        System.out.println("--- Produits abordables ---");\n        produits.stream()\n            .filter(p -> p.prix < 50)\n            .sorted((a, b) -> Double.compare(a.prix, b.prix))\n            .map(p -> p.nom)\n            .forEach(System.out::println);\n\n        System.out.println("--- Catalogue ---");\n        String catalogue = produits.stream()\n            .map(p -> p.nom.toUpperCase())\n            .collect(Collectors.joining(" | "));\n        System.out.println(catalogue);\n    }\n}',
    'output.contains("Stylo") && output.contains("Cahier") && output.contains("Cable") && output.contains("Souris") && output.contains("Clavier") && !output.contains("Ordinateur\n") && output.contains("ORDINATEUR") && output.contains(" | ")',
    '["Pour trier par prix, utilisez .sorted((a, b) -> Double.compare(a.prix, b.prix))", "Apres le tri, utilisez .map(p -> p.nom) pour extraire uniquement le nom", "Pour Collectors.joining(), passez le separateur en argument : Collectors.joining(\" | \")"]',
    80,
    3
FROM lessons l WHERE l.slug = 'introduction-streams';
