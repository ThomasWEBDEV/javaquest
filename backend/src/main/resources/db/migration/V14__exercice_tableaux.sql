-- V14: Exercices pratiques sur les tableaux

-- =============================================
-- EXERCICE 1 : Calculateur de statistiques
-- =============================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Statistiques de notes',
    'Vous avez un tableau de notes : {12, 8, 15, 7, 18, 11, 14, 9}. Calculez et affichez dans cet ordre : la somme totale, la note minimale, la note maximale. Format attendu : une valeur par ligne (ex: "92", "7", "18").',
    E'public class Main {\n    public static void main(String[] args) {\n        int[] notes = {12, 8, 15, 7, 18, 11, 14, 9};\n\n        int somme = 0;\n        int min = notes[0];\n        int max = notes[0];\n\n        for (int note : notes) {\n            // Accumulez la somme\n            // Mettez a jour min et max\n        }\n\n        System.out.println(somme);\n        System.out.println(min);\n        System.out.println(max);\n    }\n}',
    E'public class Main {\n    public static void main(String[] args) {\n        int[] notes = {12, 8, 15, 7, 18, 11, 14, 9};\n\n        int somme = 0;\n        int min = notes[0];\n        int max = notes[0];\n\n        for (int note : notes) {\n            somme += note;\n            if (note < min) min = note;\n            if (note > max) max = note;\n        }\n\n        System.out.println(somme);\n        System.out.println(min);\n        System.out.println(max);\n    }\n}',
    'output.contains("94") && output.contains("7") && output.contains("18")',
    E'Initialisez min et max avec notes[0]. Dans le for-each, ajoutez chaque note a somme. Pour min : si note < min, then min = note. Pour max : si note > max, then max = note. La somme est 12+8+15+7+18+11+14+9 = 94.',
    'MEDIUM', 75, 1
FROM lessons l WHERE l.slug = 'tableaux';

-- =============================================
-- EXERCICE 2 : Inverser un tableau
-- =============================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Inverser un tableau',
    'Inversez le tableau {1, 2, 3, 4, 5} et affichez les elements du tableau inverse, un par ligne. Resultat attendu : 5, 4, 3, 2, 1 (chacun sur une ligne).',
    E'public class Main {\n    public static void main(String[] args) {\n        int[] original = {1, 2, 3, 4, 5};\n        int[] inverse = new int[original.length];\n\n        // Remplissez inverse en sens inverse\n        // Astuce : inverse[i] = original[original.length - 1 - i]\n\n        for (int val : inverse) {\n            System.out.println(val);\n        }\n    }\n}',
    E'public class Main {\n    public static void main(String[] args) {\n        int[] original = {1, 2, 3, 4, 5};\n        int[] inverse = new int[original.length];\n\n        for (int i = 0; i < original.length; i++) {\n            inverse[i] = original[original.length - 1 - i];\n        }\n\n        for (int val : inverse) {\n            System.out.println(val);\n        }\n    }\n}',
    E'output.contains("5") && output.contains("4") && output.contains("3") && output.contains("2") && output.contains("1")',
    E'Creez un tableau inverse de meme taille. Dans une boucle for avec i de 0 a length-1, affectez : inverse[i] = original[original.length - 1 - i]. Quand i=0, on prend le dernier element (index 4). Quand i=4, on prend le premier (index 0).',
    'MEDIUM', 75, 2
FROM lessons l WHERE l.slug = 'tableaux';

-- =============================================
-- EXERCICE 3 : Compter les occurrences
-- =============================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Compter les positifs',
    'Parcourez le tableau {-3, 5, -1, 8, 0, 12, -7, 4} et comptez combien de nombres sont strictement positifs (> 0). Affichez uniquement ce nombre.',
    E'public class Main {\n    public static void main(String[] args) {\n        int[] nombres = {-3, 5, -1, 8, 0, 12, -7, 4};\n        int compteur = 0;\n\n        // Parcourez le tableau et incrementez compteur\n        // quand un nombre est strictement positif\n\n        System.out.println(compteur);\n    }\n}',
    E'public class Main {\n    public static void main(String[] args) {\n        int[] nombres = {-3, 5, -1, 8, 0, 12, -7, 4};\n        int compteur = 0;\n\n        for (int n : nombres) {\n            if (n > 0) {\n                compteur++;\n            }\n        }\n\n        System.out.println(compteur);\n    }\n}',
    'output.contains("4")',
    E'Utilisez un for-each pour parcourir le tableau. Pour chaque element, verifiez si n > 0 (strictement positif, 0 ne compte pas). Si oui, incrementez compteur. Les positifs sont : 5, 8, 12, 4 soit 4 elements.',
    'EASY', 50, 3
FROM lessons l WHERE l.slug = 'tableaux';
