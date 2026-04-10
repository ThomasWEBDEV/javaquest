-- V16: Exercices pratiques sur les methodes

-- =============================================
-- EXERCICE 1 : Calculateur geometrique
-- =============================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Calculateur geometrique',
    'Completez les deux methodes : aireCercle(double rayon) qui retourne l aire d un cercle (PI * rayon * rayon), et perimetre Rectangle(double largeur, double hauteur) qui retourne le perimetre d un rectangle (2 * (largeur + hauteur)). La methode main appelle ces deux methodes et affiche les resultats. Utilisez Math.PI pour la constante pi.',
    E'public class Main {\n    public static void main(String[] args) {\n        double aire = aireCercle(5.0);\n        System.out.println(aire);\n\n        double perim = perimetreRectangle(4.0, 6.0);\n        System.out.println(perim);\n    }\n\n    public static double aireCercle(double rayon) {\n        // Retournez Math.PI * rayon * rayon\n        return 0;\n    }\n\n    public static double perimetreRectangle(double largeur, double hauteur) {\n        // Retournez 2 * (largeur + hauteur)\n        return 0;\n    }\n}',
    E'public class Main {\n    public static void main(String[] args) {\n        double aire = aireCercle(5.0);\n        System.out.println(aire);\n\n        double perim = perimetreRectangle(4.0, 6.0);\n        System.out.println(perim);\n    }\n\n    public static double aireCercle(double rayon) {\n        return Math.PI * rayon * rayon;\n    }\n\n    public static double perimetreRectangle(double largeur, double hauteur) {\n        return 2 * (largeur + hauteur);\n    }\n}',
    E'output.contains("78.5") && output.contains("20.0")',
    E'Pour aireCercle : utilisez Math.PI (la constante pi en Java) et multipliez par rayon*rayon. L aire d un cercle de rayon 5 est environ 78.53. Pour perimetreRectangle : le perimetre est 2*(largeur+hauteur) = 2*(4+6) = 20.',
    'MEDIUM', 75, 1
FROM lessons l WHERE l.slug = 'methodes';

-- =============================================
-- EXERCICE 2 : Methode de validation
-- =============================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Validateur de mot de passe',
    'Ecrivez la methode estMotDePasseValide(String mdp) qui retourne true si le mot de passe a au moins 8 caracteres, false sinon. Dans main, testez avec "abc" (doit afficher false) puis avec "monMotDePasse" (doit afficher true). Utilisez mdp.length() pour obtenir la longueur.',
    E'public class Main {\n    public static void main(String[] args) {\n        System.out.println(estMotDePasseValide("abc"));\n        System.out.println(estMotDePasseValide("monMotDePasse"));\n    }\n\n    public static boolean estMotDePasseValide(String mdp) {\n        // Retournez true si mdp.length() >= 8, false sinon\n        return false;\n    }\n}',
    E'public class Main {\n    public static void main(String[] args) {\n        System.out.println(estMotDePasseValide("abc"));\n        System.out.println(estMotDePasseValide("monMotDePasse"));\n    }\n\n    public static boolean estMotDePasseValide(String mdp) {\n        return mdp.length() >= 8;\n    }\n}',
    'output.contains("false") && output.contains("true")',
    E'La methode doit retourner un boolean. Utilisez mdp.length() pour obtenir le nombre de caracteres du String. Comparez avec >= 8. "abc" a 3 caracteres (false), "monMotDePasse" a 13 caracteres (true). Le return peut etre direct : return mdp.length() >= 8;',
    'EASY', 50, 2
FROM lessons l WHERE l.slug = 'methodes';

-- =============================================
-- EXERCICE 3 : Surcharge de methode
-- =============================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Maximum surchargé',
    'Implementez deux versions surchargees de la methode max : une qui prend deux int et retourne le plus grand, une autre qui prend trois int et retourne le plus grand des trois. La methode main affiche max(3, 7) puis max(4, 2, 9).',
    E'public class Main {\n    public static void main(String[] args) {\n        System.out.println(max(3, 7));\n        System.out.println(max(4, 2, 9));\n    }\n\n    public static int max(int a, int b) {\n        // Retournez le plus grand entre a et b\n        return 0;\n    }\n\n    public static int max(int a, int b, int c) {\n        // Reutilisez la methode max(int, int) !\n        return 0;\n    }\n}',
    E'public class Main {\n    public static void main(String[] args) {\n        System.out.println(max(3, 7));\n        System.out.println(max(4, 2, 9));\n    }\n\n    public static int max(int a, int b) {\n        return a > b ? a : b;\n    }\n\n    public static int max(int a, int b, int c) {\n        return max(max(a, b), c);\n    }\n}',
    'output.contains("7") && output.contains("9")',
    E'Pour max(int a, int b) : utilisez l operateur ternaire a > b ? a : b. Pour max(int a, int b, int c) : reutilisez la premiere version en appelant max(max(a, b), c) - trouvez d abord le max de a et b, puis comparez ce resultat avec c.',
    'MEDIUM', 75, 3
FROM lessons l WHERE l.slug = 'methodes';
