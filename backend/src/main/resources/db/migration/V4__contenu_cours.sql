-- V4: Contenu pedagogique des lecons et exercices
-- Contenu court (50-100 mots max par lecon), pas de caracteres speciaux

-- =============================================
-- MISE A JOUR DU CONTENU DES LECONS
-- =============================================

-- Chapitre 1 : Introduction a Java
UPDATE lessons SET content = E'Java est un langage de programmation oriente objet cree en 1995.\nIl fonctionne grace a la JVM (Java Virtual Machine) qui permet d\'executer le meme code sur tout systeme d\'exploitation.\nJava est utilise pour les applications web, Android et les systemes d\'entreprise.\nSa portabilite est son principal avantage : un code compile peut tourner partout sans modification.'
WHERE slug = 'quest-ce-que-java';

UPDATE lessons SET content = E'Pour programmer en Java, installez le JDK (Java Development Kit) depuis adoptium.net.\nUtilisez un IDE comme IntelliJ IDEA ou VS Code pour ecrire du code confortablement.\nVerifiez l\'installation en tapant java -version dans un terminal.\nTout programme Java contient une classe avec une methode main, point d\'entree de l\'execution.'
WHERE slug = 'installation';

-- Chapitre 2 : Variables et Types
UPDATE lessons SET content = E'Java possede 8 types primitifs. Les plus utilises sont :\nint pour les entiers : int age = 25;\ndouble pour les decimaux : double prix = 9.99;\nboolean pour vrai/faux : boolean actif = true;\nCes types primitifs stockent directement une valeur en memoire, contrairement aux objets Java.'
WHERE slug = 'types-primitifs';

UPDATE lessons SET content = E'Une variable est un espace memoire nomme qui stocke une valeur pouvant changer.\nSyntaxe de declaration : type nom = valeur; Exemple : int score = 0;\nPour une constante immuable, utilisez final : final int MAX = 100;\nLa convention Java est le camelCase pour les noms : monScore, nombreEtudiants.'
WHERE slug = 'variables';

-- Chapitre 3 : Structures de Controle
UPDATE lessons SET content = E'L\'instruction if execute du code selon une condition booleenne.\nSi la condition est vraie, le bloc if s\'execute. Sinon, le bloc else s\'execute.\nOn enchaine plusieurs cas avec else if.\nLes operateurs de comparaison sont : == (egal), != (different), <, >, <=, >=.'
WHERE slug = 'conditions';

UPDATE lessons SET content = E'Les boucles repetent un bloc d\'instructions plusieurs fois.\nLa boucle for est utilisee quand le nombre d\'iterations est connu : for (int i = 0; i < 5; i++).\nLa boucle while continue tant qu\'une condition est vraie : while (vies > 0).\nbreak sort immediatement d\'une boucle, continue saute a l\'iteration suivante.'
WHERE slug = 'boucles';

-- =============================================
-- EXERCICES SUPPLEMENTAIRES
-- =============================================

-- Lecon "installation" : afficher un message
INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Premier message',
    'Affichez le message "Bonjour Java !" dans la console.',
    E'public class Main {\n    public static void main(String[] args) {\n        // Affichez Bonjour Java !\n    }\n}',
    E'public class Main {\n    public static void main(String[] args) {\n        System.out.println("Bonjour Java !");\n    }\n}',
    'output.contains("Bonjour Java")',
    'Utilisez System.out.println() avec le texte entre guillemets doubles.',
    'EASY', 50, 1
FROM lessons l WHERE l.slug = 'installation';

-- Lecon "types-primitifs" : declarer et afficher une variable
INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Declarer et afficher',
    'Declarez une variable entiere age avec la valeur 20 et affichez-la.',
    E'public class Main {\n    public static void main(String[] args) {\n        // Declarez int age = 20 et affichez-la\n    }\n}',
    E'public class Main {\n    public static void main(String[] args) {\n        int age = 20;\n        System.out.println(age);\n    }\n}',
    'output.contains("20")',
    'Declarez : int age = 20; puis utilisez System.out.println(age);',
    'EASY', 50, 2
FROM lessons l WHERE l.slug = 'types-primitifs';

-- Lecon "variables" : calcul prix TTC
INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Calculer prix TTC',
    'Calculez le prix TTC avec 20 pourcent de TVA sur un prix HT de 50 euros. Affichez le resultat.',
    E'public class Main {\n    public static void main(String[] args) {\n        double prixHT = 50.0;\n        // Calculez prixTTC et affichez-le\n    }\n}',
    E'public class Main {\n    public static void main(String[] args) {\n        double prixHT = 50.0;\n        double prixTTC = prixHT * 1.20;\n        System.out.println(prixTTC);\n    }\n}',
    'output.contains("60")',
    'Multipliez prixHT par 1.20 pour obtenir le prix avec 20 pourcent de TVA.',
    'EASY', 50, 1
FROM lessons l WHERE l.slug = 'variables';

-- Lecon "conditions" : pair ou impair
INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Pair ou Impair',
    'Determinez si le nombre 7 est pair ou impair. Affichez "Pair" ou "Impair".',
    E'public class Main {\n    public static void main(String[] args) {\n        int nombre = 7;\n        // Testez si nombre est pair ou impair\n    }\n}',
    E'public class Main {\n    public static void main(String[] args) {\n        int nombre = 7;\n        if (nombre % 2 == 0) {\n            System.out.println("Pair");\n        } else {\n            System.out.println("Impair");\n        }\n    }\n}',
    'output.contains("Impair")',
    E'Utilisez l\'operateur modulo % : si nombre % 2 == 0 c\'est pair, sinon impair.',
    'EASY', 50, 2
FROM lessons l WHERE l.slug = 'conditions';

-- Lecon "boucles" : compter de 1 a 5
INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Compter de 1 a 5',
    'Utilisez une boucle for pour afficher les nombres de 1 a 5.',
    E'public class Main {\n    public static void main(String[] args) {\n        // Utilisez une boucle for\n    }\n}',
    E'public class Main {\n    public static void main(String[] args) {\n        for (int i = 1; i <= 5; i++) {\n            System.out.println(i);\n        }\n    }\n}',
    E'output.contains("1") && output.contains("5")',
    E'Commencez i a 1, continuez tant que i <= 5, incrementez avec i++.',
    'EASY', 50, 1
FROM lessons l WHERE l.slug = 'boucles';
