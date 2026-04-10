-- V12: Exercices pratiques sur les boucles

-- =============================================
-- EXERCICE 1 : FizzBuzz (classique)
-- =============================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'FizzBuzz',
    'Le classique FizzBuzz ! Parcourez les nombres de 1 a 20 avec une boucle for. Pour chaque nombre : affichez "Fizz" s il est divisible par 3, "Buzz" s il est divisible par 5, "FizzBuzz" s il est divisible par 3 ET par 5, ou le nombre lui-meme sinon.',
    E'public class Main {\n    public static void main(String[] args) {\n        for (int i = 1; i <= 20; i++) {\n            // Testez les conditions dans le bon ordre :\n            // divisible par 3 ET 5, puis par 3, puis par 5, sinon le nombre\n        }\n    }\n}',
    E'public class Main {\n    public static void main(String[] args) {\n        for (int i = 1; i <= 20; i++) {\n            if (i % 15 == 0) {\n                System.out.println("FizzBuzz");\n            } else if (i % 3 == 0) {\n                System.out.println("Fizz");\n            } else if (i % 5 == 0) {\n                System.out.println("Buzz");\n            } else {\n                System.out.println(i);\n            }\n        }\n    }\n}',
    E'output.contains("Fizz") && output.contains("Buzz") && output.contains("FizzBuzz") && output.contains("1")',
    E'Testez d abord i % 15 == 0 (divisible par 3 ET 5), puis i % 3 == 0, puis i % 5 == 0. L ordre est crucial car si vous testez % 3 en premier, 15 sera affiche "Fizz" au lieu de "FizzBuzz".',
    'MEDIUM', 75, 2
FROM lessons l WHERE l.slug = 'boucles';

-- =============================================
-- EXERCICE 2 : Table de multiplication
-- =============================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Table de multiplication',
    'Affichez la table de multiplication du 7 de 7x1 jusqu a 7x10. Chaque ligne doit etre au format "7 x N = RESULTAT", par exemple "7 x 1 = 7".',
    E'public class Main {\n    public static void main(String[] args) {\n        // Utilisez une boucle for de 1 a 10\n        // Affichez : "7 x " + i + " = " + (7 * i)\n    }\n}',
    E'public class Main {\n    public static void main(String[] args) {\n        for (int i = 1; i <= 10; i++) {\n            System.out.println("7 x " + i + " = " + (7 * i));\n        }\n    }\n}',
    E'output.contains("7 x 1 = 7") && output.contains("7 x 5 = 35") && output.contains("7 x 10 = 70")',
    E'Utilisez une boucle for avec i de 1 a 10 inclus. Dans la boucle, affichez : "7 x " + i + " = " + (7 * i). Les parentheses autour de 7 * i evitent la concatenation de strings.',
    'EASY', 50, 3
FROM lessons l WHERE l.slug = 'boucles';

-- =============================================
-- EXERCICE 3 : Somme des N premiers entiers
-- =============================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Somme des entiers',
    'Calculez la somme de tous les entiers de 1 a 100 en utilisant une boucle while. Affichez uniquement le resultat final. (La somme attendue est 5050)',
    E'public class Main {\n    public static void main(String[] args) {\n        int somme = 0;\n        int i = 1;\n        // Completez la boucle while\n        // while (??) {\n        //     somme += i;\n        //     i++;\n        // }\n        System.out.println(somme);\n    }\n}',
    E'public class Main {\n    public static void main(String[] args) {\n        int somme = 0;\n        int i = 1;\n        while (i <= 100) {\n            somme += i;\n            i++;\n        }\n        System.out.println(somme);\n    }\n}',
    'output.contains("5050")',
    E'Initialisez somme = 0 et i = 1. La boucle while continue tant que i <= 100. A chaque iteration, ajoutez i a somme (somme += i) et incrementez i (i++). A la fin, affichez somme.',
    'EASY', 50, 4
FROM lessons l WHERE l.slug = 'boucles';
