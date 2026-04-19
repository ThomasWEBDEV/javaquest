-- V56: Exercices Lecon 2 Streams - Reduction et agregation (EASY / MEDIUM / HARD)

-- =============================================
-- EXERCICE 1 : Statistiques de Notes (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Statistiques de Notes',
    'EASY',
    'Vous avez une liste de notes d etudiants. Calculez et affichez le nombre de notes, la somme totale et la note maximale. Affichez chaque valeur sur une ligne separee.',
    E'import java.util.List;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<Integer> notes = List.of(14, 8, 17, 12, 9, 15, 11, 6, 13);\n\n        // Calculez le nombre de notes avec count()\n        // Calculez la somme avec mapToInt().sum()\n        // Calculez le max avec mapToInt().max().getAsInt()\n        // Affichez chaque valeur sur une ligne\n    }\n}',
    E'import java.util.List;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<Integer> notes = List.of(14, 8, 17, 12, 9, 15, 11, 6, 13);\n\n        long nombre = notes.stream().count();\n        int somme = notes.stream().mapToInt(Integer::intValue).sum();\n        int max = notes.stream().mapToInt(Integer::intValue).max().getAsInt();\n\n        System.out.println(nombre);\n        System.out.println(somme);\n        System.out.println(max);\n    }\n}',
    'output.contains("9") && output.contains("105") && output.contains("17")',
    '["Utilisez notes.stream().count() pour compter (retourne un long)", "Utilisez mapToInt(Integer::intValue).sum() pour la somme", "Utilisez mapToInt(Integer::intValue).max().getAsInt() pour le maximum"]',
    30,
    1
FROM lessons l WHERE l.slug = 'streams-reduction-agregation';

-- =============================================
-- EXERCICE 2 : Analyse de Prix (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Analyse de Prix',
    'MEDIUM',
    'Vous avez une liste de prix de produits. Determinez : y a-t-il un produit a moins de 10 euros (anyMatch) ? Tous les produits coutent-ils moins de 100 euros (allMatch) ? Trouvez le prix moyen des produits de plus de 20 euros. Affichez chaque resultat sur une ligne.',
    E'import java.util.List;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<Double> prix = List.of(25.99, 8.50, 45.00, 12.75, 89.90, 5.99, 34.50);\n\n        // Verifiez si au moins un prix est < 10 avec anyMatch()\n        // Verifiez si tous les prix sont < 100 avec allMatch()\n        // Calculez la moyenne des prix > 20 avec filter() + mapToDouble() + average()\n        // Affichez chaque resultat sur une ligne\n    }\n}',
    E'import java.util.List;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<Double> prix = List.of(25.99, 8.50, 45.00, 12.75, 89.90, 5.99, 34.50);\n\n        boolean unPasCher = prix.stream().anyMatch(p -> p < 10);\n        boolean tousMoinsCent = prix.stream().allMatch(p -> p < 100);\n        double moyenneCher = prix.stream()\n            .filter(p -> p > 20)\n            .mapToDouble(Double::doubleValue)\n            .average()\n            .getAsDouble();\n\n        System.out.println(unPasCher);\n        System.out.println(tousMoinsCent);\n        System.out.printf("%.2f%n", moyenneCher);\n    }\n}',
    'output.contains("true") && output.contains("48.85")',
    '["Utilisez anyMatch(p -> p < 10) pour la premiere question", "Utilisez allMatch(p -> p < 100) pour la deuxieme", "Combinez filter(p -> p > 20) puis mapToDouble(...).average().getAsDouble() pour la moyenne"]',
    40,
    2
FROM lessons l WHERE l.slug = 'streams-reduction-agregation';

-- =============================================
-- EXERCICE 3 : Calcul de Panier (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Calcul de Panier',
    'HARD',
    'Vous avez une liste de quantites et une liste de prix unitaires correspondants. Calculez le total du panier en utilisant reduce() : multipliez chaque quantite par son prix et additionnez tout. Affichez le total avec 2 decimales. Indice : utilisez un IntStream.range() pour iterer sur les indices.',
    E'import java.util.List;\nimport java.util.stream.IntStream;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<Integer> quantites = List.of(3, 1, 5, 2, 4);\n        List<Double> prixUnitaires = List.of(12.50, 45.00, 3.99, 28.75, 7.20);\n\n        // Utilisez IntStream.range(0, quantites.size())\n        // Pour chaque indice i, calculez quantites.get(i) * prixUnitaires.get(i)\n        // Additionnez tout avec reduce() ou sum()\n        // Affichez le total avec System.out.printf("%.2f%n", total)\n    }\n}',
    E'import java.util.List;\nimport java.util.stream.IntStream;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<Integer> quantites = List.of(3, 1, 5, 2, 4);\n        List<Double> prixUnitaires = List.of(12.50, 45.00, 3.99, 28.75, 7.20);\n\n        double total = IntStream.range(0, quantites.size())\n            .mapToDouble(i -> quantites.get(i) * prixUnitaires.get(i))\n            .reduce(0, (a, b) -> a + b);\n\n        System.out.printf("%.2f%n", total);\n    }\n}',
    'output.contains("151.20")',
    '["Utilisez IntStream.range(0, quantites.size()) pour parcourir les indices", "Dans mapToDouble, calculez quantites.get(i) * prixUnitaires.get(i)", "Utilisez reduce(0, (a, b) -> a + b) ou directement sum() pour additionner", "Le total attendu est 3*12.50 + 1*45 + 5*3.99 + 2*28.75 + 4*7.20 = 151.20"]',
    50,
    3
FROM lessons l WHERE l.slug = 'streams-reduction-agregation';
