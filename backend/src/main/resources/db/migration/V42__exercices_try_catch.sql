-- V42: Exercices try/catch/finally (EASY / MEDIUM / HARD)

-- =============================================
-- EXERCICE 1 : Division Securisee (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Division Securisee',
    'EASY',
    'Ecrivez une methode diviser() qui effectue une division entiere de maniere securisee. Si la division par zero est tentee, affichez un message d erreur au lieu de planter.',
    E'public class Main {\n    public static void diviser(int a, int b) {\n        // Entourez la division a / b avec un try/catch\n        // En cas d ArithmeticException, affichez :\n        // "Erreur : division par zero impossible"\n        // Sinon affichez : "Resultat : X" (X = resultat de a/b)\n    }\n\n    public static void main(String[] args) {\n        diviser(10, 2);\n        diviser(15, 3);\n        diviser(8, 0);\n        diviser(20, 4);\n    }\n}',
    E'public class Main {\n    public static void diviser(int a, int b) {\n        try {\n            int resultat = a / b;\n            System.out.println("Resultat : " + resultat);\n        } catch (ArithmeticException e) {\n            System.out.println("Erreur : division par zero impossible");\n        }\n    }\n\n    public static void main(String[] args) {\n        diviser(10, 2);\n        diviser(15, 3);\n        diviser(8, 0);\n        diviser(20, 4);\n    }\n}',
    'output.contains("Resultat : 5") && output.contains("Resultat : 5") && output.contains("Erreur : division par zero impossible") && output.contains("Resultat : 5")',
    '["Entourez uniquement int resultat = a / b dans le try", "Attrapez ArithmeticException dans le catch", "Affichez le message d erreur dans le catch et le resultat normal dans le try"]',
    30,
    1
FROM lessons l WHERE l.slug = 'try-catch-finally';

-- =============================================
-- EXERCICE 2 : Parseur Securise (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Parseur Securise',
    'MEDIUM',
    'Ecrivez une methode convertirEnNombre() qui tente de convertir une chaine en entier. Gerez les deux cas d erreur possibles : format invalide et valeur nulle. Utilisez un bloc finally pour toujours confirmer la tentative.',
    E'public class Main {\n    public static void convertirEnNombre(String texte) {\n        // Bloc try : convertissez texte avec Integer.parseInt(texte)\n        // et affichez "Nombre converti : X"\n        // Catch NumberFormatException : affichez "Format invalide : [texte]"\n        // Catch NullPointerException : affichez "Erreur : texte nul"\n        // Finally : affichez "Tentative terminee"\n    }\n\n    public static void main(String[] args) {\n        convertirEnNombre("42");\n        convertirEnNombre("bonjour");\n        convertirEnNombre(null);\n        convertirEnNombre("100");\n    }\n}',
    E'public class Main {\n    public static void convertirEnNombre(String texte) {\n        try {\n            int nombre = Integer.parseInt(texte);\n            System.out.println("Nombre converti : " + nombre);\n        } catch (NumberFormatException e) {\n            System.out.println("Format invalide : " + texte);\n        } catch (NullPointerException e) {\n            System.out.println("Erreur : texte nul");\n        } finally {\n            System.out.println("Tentative terminee");\n        }\n    }\n\n    public static void main(String[] args) {\n        convertirEnNombre("42");\n        convertirEnNombre("bonjour");\n        convertirEnNombre(null);\n        convertirEnNombre("100");\n    }\n}',
    'output.contains("Nombre converti : 42") && output.contains("Format invalide : bonjour") && output.contains("Erreur : texte nul") && output.contains("Nombre converti : 100") && output.split("Tentative terminee", -1).length - 1 == 4',
    '["Utilisez Integer.parseInt(texte) dans le try", "Ajoutez un catch pour NumberFormatException et un autre pour NullPointerException", "Le bloc finally s execute apres chaque appel, qu il y ait erreur ou non"]',
    50,
    2
FROM lessons l WHERE l.slug = 'try-catch-finally';

-- =============================================
-- EXERCICE 3 : Calculatrice Robuste (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Calculatrice Robuste',
    'HARD',
    'Implementez une calculatrice qui accepte deux chaines (potentiellement invalides) et un operateur. Gerez toutes les erreurs possibles : format invalide, division par zero, operateur inconnu.',
    E'public class Main {\n    public static void calculer(String aStr, String bStr, String operateur) {\n        // Etape 1 : convertissez aStr et bStr en int avec Integer.parseInt()\n        // Si NumberFormatException : affichez "Erreur : saisie non numerique" et retournez\n        // Etape 2 : selon l operateur (+, -, *, /), effectuez le calcul\n        // Si division par zero (ArithmeticException) : affichez "Erreur : division par zero"\n        // Si operateur inconnu : throw new IllegalArgumentException("Operateur inconnu : " + operateur)\n        // Affichez le resultat avec : "aStr operateur bStr = resultat"\n        // Catch IllegalArgumentException : affichez "Erreur : " + e.getMessage()\n    }\n\n    public static void main(String[] args) {\n        calculer("10", "3", "+");\n        calculer("10", "3", "-");\n        calculer("10", "3", "*");\n        calculer("10", "0", "/");\n        calculer("abc", "3", "+");\n        calculer("10", "3", "%");\n    }\n}',
    E'public class Main {\n    public static void calculer(String aStr, String bStr, String operateur) {\n        int a, b;\n        try {\n            a = Integer.parseInt(aStr);\n            b = Integer.parseInt(bStr);\n        } catch (NumberFormatException e) {\n            System.out.println("Erreur : saisie non numerique");\n            return;\n        }\n\n        try {\n            int resultat;\n            switch (operateur) {\n                case "+": resultat = a + b; break;\n                case "-": resultat = a - b; break;\n                case "*": resultat = a * b; break;\n                case "/": resultat = a / b; break;\n                default: throw new IllegalArgumentException("Operateur inconnu : " + operateur);\n            }\n            System.out.println(aStr + " " + operateur + " " + bStr + " = " + resultat);\n        } catch (ArithmeticException e) {\n            System.out.println("Erreur : division par zero");\n        } catch (IllegalArgumentException e) {\n            System.out.println("Erreur : " + e.getMessage());\n        }\n    }\n\n    public static void main(String[] args) {\n        calculer("10", "3", "+");\n        calculer("10", "3", "-");\n        calculer("10", "3", "*");\n        calculer("10", "0", "/");\n        calculer("abc", "3", "+");\n        calculer("10", "3", "%");\n    }\n}',
    'output.contains("10 + 3 = 13") && output.contains("10 - 3 = 7") && output.contains("10 * 3 = 30") && output.contains("Erreur : division par zero") && output.contains("Erreur : saisie non numerique") && output.contains("Erreur : Operateur inconnu : %")',
    '["Commencez par convertir les deux chaines en int dans un premier try/catch NumberFormatException", "Utilisez switch sur l operateur et throw new IllegalArgumentException pour le cas default", "Gerez ArithmeticException (division par zero) et IllegalArgumentException (operateur inconnu) dans deux catch distincts"]',
    80,
    3
FROM lessons l WHERE l.slug = 'try-catch-finally';
