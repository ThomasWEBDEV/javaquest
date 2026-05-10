-- V114: Lecon 3 Java Moderne - Sealed Classes + Quiz + Exercices

-- =============================================
-- LECON 3 : Sealed Classes
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Sealed Classes et Interfaces',
    'sealed-classes',
    E'SEALED CLASSES ET INTERFACES\n\nIntroduites en Java 17 (stable) et Java 21, les sealed classes et interfaces permettent de controler precisement quelles classes peuvent etendre ou implementer un type. Elles forment la base des hierarchies fermees et s associent parfaitement au pattern matching.\n\n---\n\nPROBLEME SANS SEALED\n\nSans sealed, n importe quelle classe peut etendre une autre :\n\n  interface Forme {} // Ouvert a tout\n\n  class Cercle    implements Forme {}\n  class Rectangle implements Forme {}\n  // n importe qui peut ajouter Hexagone, Etoile, etc.\n\nCela pose probleme pour l exhaustivite : un switch ne peut pas savoir que toutes les formes sont couvertes, donc un default est toujours obligatoire.\n\n---\n\nSYNTAXE : SEALED INTERFACE\n\n  sealed interface Forme permits Cercle, Rectangle, Triangle {}\n\n  // Chaque classe permise DOIT etre final, sealed ou non-sealed\n  record Cercle(double rayon)           implements Forme {} // record => implicitement final\n  record Rectangle(double l, double h)  implements Forme {}\n  record Triangle(double b, double h)   implements Forme {}\n\n  // Switch EXHAUSTIF sans default\n  static double aire(Forme f) {\n      return switch (f) {\n          case Cercle c    -> Math.PI * c.rayon() * c.rayon();\n          case Rectangle r -> r.l() * r.h();\n          case Triangle t  -> (t.b() * t.h()) / 2;\n      }; // pas de default : Java sait que les 3 cas couvrent tout\n  }\n\n---\n\nSYNTAXE : SEALED CLASS\n\n  sealed class Vehicule permits Voiture, Camion, Moto {}\n\n  final class Voiture extends Vehicule {   // final : aucune sous-classe\n      int portes;\n      Voiture(int portes) { this.portes = portes; }\n  }\n\n  final class Camion extends Vehicule {\n      double tonnage;\n      Camion(double tonnage) { this.tonnage = tonnage; }\n  }\n\n  non-sealed class Moto extends Vehicule {} // non-sealed : reautorise l extension\n\n---\n\nTROIS MODIFICATEURS POSSIBLES\n\nChaque sous-classe permise DOIT choisir l un de ces trois modificateurs :\n\n  sealed class A permits B, C, D {}\n\n  final class B extends A {}             // Termine la hierarchie\n  sealed class C extends A permits E {}  // Continue la hierarchie fermee\n  non-sealed class D extends A {}        // Reautorise l extension libre\n\n---\n\nSEALED + RECORDS : COMBINAISON IDEALE\n\nLes Records sont implicitement final, parfaits comme sous-classes sealed :\n\n  sealed interface Resultat permits Succes, Echec {}\n  record Succes(int valeur)   implements Resultat {}\n  record Echec(String erreur) implements Resultat {}\n\n  // Switch exhaustif : Java connait toutes les implementations\n  static String afficher(Resultat r) {\n      return switch (r) {\n          case Succes s -> "OK : " + s.valeur();\n          case Echec e  -> "Erreur : " + e.erreur();\n      };\n  }\n\n---\n\nREGLES IMPORTANTES\n\n1. Toutes les classes dans permits doivent etre dans le meme package (ou meme fichier).\n2. Chaque classe permise doit explicitement extends/implements la classe sealed.\n3. Les sous-classes DOIVENT choisir : final, sealed ou non-sealed.\n4. Un switch sur un type sealed est exhaustif si tous les permits sont couverts.\n\n---\n\nBONNES PRATIQUES\n\n- Utilisez sealed pour modeliser des hierarchies fermees (AST, resultats, formes, etats).\n- Combinez sealed + record pour des structures de donnees immutables et exhaustives.\n- Evitez non-sealed sauf si vous avez reellement besoin d extensibilite partielle.\n- Si vous ajoutez un type dans permits, le compilateur force la mise a jour de tous les switchs.',
    3,
    40
FROM chapters c WHERE c.slug = 'java-moderne';

-- =============================================
-- QUIZ : Sealed Classes
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Sealed Classes et Interfaces',
    'Testez vos connaissances sur les sealed classes, le mot-cle permits, les modificateurs de sous-classes et l exhaustivite des switch',
    300, 70, 100
FROM lessons l WHERE l.slug = 'sealed-classes';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel est le but principal des sealed classes en Java ?',
        'SINGLE_CHOICE',
        'Les sealed classes permettent de controler precisement quelles classes peuvent etendre ou implementer un type. Cela permet de creer des hierarchies fermees, ce qui rend les switch exhaustifs possibles sans default. Ce n est pas une question de performance ou de securite memoire.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'sealed-classes'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Ameliorer les performances en evitant les appels virtuels', false, 1),
    ('Controler quelles classes peuvent etendre un type pour former une hierarchie fermee', true, 2),
    ('Empecher la serialisation des objets en memoire', false, 3),
    ('Remplacer les interfaces fonctionnelles pour les lambdas', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel mot-cle liste les sous-classes autorisees dans une sealed class ?',
        'SINGLE_CHOICE',
        'Le mot-cle permits liste explicitement toutes les sous-classes ou sous-interfaces autorisees. Par exemple : sealed interface Forme permits Cercle, Rectangle {}. Toute classe ne figurant pas dans permits ne peut pas implementer ou etendre ce type.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'sealed-classes'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('extends', false, 1),
    ('allows', false, 2),
    ('permits', true, 3),
    ('restricts', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quels sont les trois modificateurs valides pour une sous-classe d une sealed class ?',
        'SINGLE_CHOICE',
        'Une sous-classe permise DOIT etre l un de ces trois : final (aucune sous-classe possible), sealed (continue la hierarchie fermee avec ses propres permits), ou non-sealed (reautorise l extension libre). Ces modificateurs sont obligatoires - une sous-classe sans l un d eux est une erreur de compilation.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'sealed-classes'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('abstract, concrete, interface', false, 1),
    ('final, sealed, non-sealed', true, 2),
    ('public, protected, private', false, 3),
    ('static, instance, nested', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pourquoi un switch sur un type sealed peut-il etre exhaustif sans default ?',
        'SINGLE_CHOICE',
        'Parce que le compilateur connait statiquement toutes les implementations possibles via la clause permits. Si un case couvre chaque type liste dans permits, le switch est exhaustif et le default est inutile. Si on ajoute un nouveau type dans permits, le compilateur signale les switch qui ne le couvrent pas encore.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'sealed-classes'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Parce que Java ajoute automatiquement un default null a la compilation', false, 1),
    ('Parce que le compilateur connait toutes les implementations via permits', true, 2),
    ('Parce que les sealed classes ne peuvent avoir qu un seul niveau de sous-classes', false, 3),
    ('Parce que le JVM verifie l exhaustivite au moment de l execution', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Un Record peut-il implementer une sealed interface ?',
        'SINGLE_CHOICE',
        'Oui, et c est meme une combinaison tres recommandee. Les Records sont implicitement final, ce qui satisfait l une des trois exigences pour les sous-classes sealed. On ecrit simplement : record Cercle(double rayon) implements Forme {}. Cette combinaison sealed interface + records est tres courante pour les hierarchies de donnees immutables.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'sealed-classes'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Non, les Records ne peuvent implementer que des interfaces normales', false, 1),
    ('Non, car un Record ne peut pas avoir de modificateur final explicite', false, 2),
    ('Oui, car un Record est implicitement final ce qui satisfait l exigence sealed', true, 3),
    ('Oui, mais uniquement si le Record n a pas de champs', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle contrainte s applique a l emplacement des classes permises ?',
        'SINGLE_CHOICE',
        'Toutes les classes listees dans permits doivent etre dans le meme package que la classe sealed (ou dans le meme fichier source pour les nested classes). Elles ne peuvent pas etre dans un package different. Cela garantit que le module/package maintient le controle total sur la hierarchie.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'sealed-classes'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Les classes permises doivent etre dans le meme module mais pas forcement le meme package', false, 1),
    ('Les classes permises peuvent etre dans n importe quel package accessible', false, 2),
    ('Les classes permises doivent etre dans le meme package que la classe sealed', true, 3),
    ('Les classes permises doivent etre des classes internes (nested classes)', false, 4)
) AS opt(text, is_correct, order_index);

-- =============================================
-- EXERCICE 1 : Formes Geometriques Sealed (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Formes Geometriques Sealed',
    'EASY',
    'Creez une sealed interface Forme avec la clause permits pour trois Records : Cercle(double rayon), Rectangle(double largeur, double hauteur) et Triangle(double base, double hauteur). Ajoutez une methode statique double aire(Forme f) qui utilise un switch exhaustif (sans default) pour calculer : Cercle = PI * rayon * rayon, Rectangle = largeur * hauteur, Triangle = base * hauteur / 2. Dans le main, creez une instance de chaque forme et affichez leur aire avec printf("%.2f").',
    E'// TODO: sealed interface Forme permits Cercle, Rectangle, Triangle\n// TODO: record Cercle(double rayon) implements Forme {}\n// TODO: record Rectangle(double largeur, double hauteur) implements Forme {}\n// TODO: record Triangle(double base, double hauteur) implements Forme {}\n\npublic class Main {\n    static double aire(Forme f) {\n        // TODO: switch exhaustif (sans default)\n        return 0;\n    }\n\n    public static void main(String[] args) {\n        Forme cercle = new Cercle(5);\n        Forme rect   = new Rectangle(4, 6);\n        Forme tri    = new Triangle(3, 8);\n\n        System.out.printf("Cercle : %.2f%n", aire(cercle));\n        System.out.printf("Rectangle : %.2f%n", aire(rect));\n        System.out.printf("Triangle : %.2f%n", aire(tri));\n    }\n}',
    E'sealed interface Forme permits Cercle, Rectangle, Triangle {}\nrecord Cercle(double rayon)           implements Forme {}\nrecord Rectangle(double largeur, double hauteur) implements Forme {}\nrecord Triangle(double base, double hauteur)     implements Forme {}\n\npublic class Main {\n    static double aire(Forme f) {\n        return switch (f) {\n            case Cercle c    -> Math.PI * c.rayon() * c.rayon();\n            case Rectangle r -> r.largeur() * r.hauteur();\n            case Triangle t  -> (t.base() * t.hauteur()) / 2;\n        };\n    }\n\n    public static void main(String[] args) {\n        Forme cercle = new Cercle(5);\n        Forme rect   = new Rectangle(4, 6);\n        Forme tri    = new Triangle(3, 8);\n\n        System.out.printf("Cercle : %.2f%n", aire(cercle));\n        System.out.printf("Rectangle : %.2f%n", aire(rect));\n        System.out.printf("Triangle : %.2f%n", aire(tri));\n    }\n}',
    'output.contains("Cercle") && output.contains("78.") && output.contains("Rectangle") && output.contains("24.00") && output.contains("Triangle") && output.contains("12.00")',
    '["La syntaxe est : sealed interface Forme permits Cercle, Rectangle, Triangle {}. Chaque record implementant Forme doit ecrire : implements Forme a la fin.", "Le switch exhaustif : return switch (f) { case Cercle c -> ...; case Rectangle r -> ...; case Triangle t -> ...; }. Pas de default car Java sait que ces 3 types couvrent tout.", "Pour le Cercle : Math.PI * c.rayon() * c.rayon(). Les accesseurs d un Record portent le meme nom que les champs : rayon(), largeur(), hauteur(), base()."]',
    30,
    1
FROM lessons l WHERE l.slug = 'sealed-classes';

-- =============================================
-- EXERCICE 2 : Resultat Sealed - Parsing Securise (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Resultat Sealed - Parsing Securise',
    'MEDIUM',
    'Creez une sealed interface Resultat avec deux Records : Succes(int valeur) et Echec(String erreur). Implementez une methode statique Resultat parseEntier(String s) qui retourne new Succes(Integer.parseInt(s)) si la chaine est un entier valide, ou new Echec("Valeur invalide : " + s) en cas de NumberFormatException. Dans le main, testez avec le tableau {"42", "abc", "100", "xyz"} et affichez chaque resultat avec un switch exhaustif : "Succes : " + valeur pour Succes, "Echec : " + erreur pour Echec.',
    E'// TODO: sealed interface Resultat permits Succes, Echec\n// TODO: record Succes(int valeur) implements Resultat {}\n// TODO: record Echec(String erreur) implements Resultat {}\n\npublic class Main {\n    static Resultat parseEntier(String s) {\n        // TODO: try Integer.parseInt(s) -> Succes, catch -> Echec\n        return null;\n    }\n\n    public static void main(String[] args) {\n        String[] tests = {"42", "abc", "100", "xyz"};\n\n        for (String test : tests) {\n            Resultat r = parseEntier(test);\n            // TODO: switch exhaustif pour afficher\n            String message = "";\n            System.out.println(message);\n        }\n    }\n}',
    E'sealed interface Resultat permits Succes, Echec {}\nrecord Succes(int valeur)   implements Resultat {}\nrecord Echec(String erreur) implements Resultat {}\n\npublic class Main {\n    static Resultat parseEntier(String s) {\n        try {\n            return new Succes(Integer.parseInt(s));\n        } catch (NumberFormatException e) {\n            return new Echec("Valeur invalide : " + s);\n        }\n    }\n\n    public static void main(String[] args) {\n        String[] tests = {"42", "abc", "100", "xyz"};\n\n        for (String test : tests) {\n            Resultat r = parseEntier(test);\n            String message = switch (r) {\n                case Succes s -> "Succes : " + s.valeur();\n                case Echec e  -> "Echec : " + e.erreur();\n            };\n            System.out.println(message);\n        }\n    }\n}',
    'output.contains("Succes : 42") && output.contains("Echec : Valeur invalide : abc") && output.contains("Succes : 100") && output.contains("Echec : Valeur invalide : xyz")',
    '["Declarez la sealed interface et les records avant la classe Main dans le meme fichier. Le switch exhaustif n a pas besoin de default car Succes et Echec couvrent tous les cas.", "La methode parseEntier : try { return new Succes(Integer.parseInt(s)); } catch (NumberFormatException e) { return new Echec(\"Valeur invalide : \" + s); }", "Dans le switch : case Succes s -> \"Succes : \" + s.valeur(); - l accesseur du record Succes est valeur() et celui de Echec est erreur()."]',
    40,
    2
FROM lessons l WHERE l.slug = 'sealed-classes';

-- =============================================
-- EXERCICE 3 : Mini Evaluateur d Expressions Sealed (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Mini Evaluateur d Expressions Sealed',
    'HARD',
    'Creez une sealed interface Expression permits Nombre, Addition, Multiplication, Negation. Chaque type est un Record : Nombre(int valeur), Addition(Expression gauche, Expression droite), Multiplication(Expression gauche, Expression droite), Negation(Expression expr). Implementez deux methodes statiques recursives : int evaluer(Expression e) qui calcule la valeur et String afficher(Expression e) qui retourne la representation textuelle (ex: "(2 + 3)"). Dans le main, evaluez et affichez : (2 + 3) * 4, -(5 + 3), et 10 * 2 + 5.',
    E'// TODO: sealed interface Expression permits Nombre, Addition, Multiplication, Negation\n// TODO: record Nombre(int valeur) implements Expression {}\n// TODO: record Addition(Expression gauche, Expression droite) implements Expression {}\n// TODO: record Multiplication(Expression gauche, Expression droite) implements Expression {}\n// TODO: record Negation(Expression expr) implements Expression {}\n\npublic class Main {\n    static int evaluer(Expression e) {\n        // TODO: switch exhaustif recursif\n        return 0;\n    }\n\n    static String afficher(Expression e) {\n        // TODO: switch exhaustif recursif\n        return "";\n    }\n\n    public static void main(String[] args) {\n        // (2 + 3) * 4 = 20\n        Expression e1 = new Multiplication(\n            new Addition(new Nombre(2), new Nombre(3)),\n            new Nombre(4)\n        );\n        System.out.println(afficher(e1) + " = " + evaluer(e1));\n\n        // -(5 + 3) = -8\n        Expression e2 = new Negation(new Addition(new Nombre(5), new Nombre(3)));\n        System.out.println(afficher(e2) + " = " + evaluer(e2));\n\n        // 10 * 2 + 5 = 25\n        Expression e3 = new Addition(\n            new Multiplication(new Nombre(10), new Nombre(2)),\n            new Nombre(5)\n        );\n        System.out.println(afficher(e3) + " = " + evaluer(e3));\n    }\n}',
    E'sealed interface Expression permits Nombre, Addition, Multiplication, Negation {}\nrecord Nombre(int valeur)                                    implements Expression {}\nrecord Addition(Expression gauche, Expression droite)        implements Expression {}\nrecord Multiplication(Expression gauche, Expression droite)  implements Expression {}\nrecord Negation(Expression expr)                             implements Expression {}\n\npublic class Main {\n    static int evaluer(Expression e) {\n        return switch (e) {\n            case Nombre n       -> n.valeur();\n            case Addition a     -> evaluer(a.gauche()) + evaluer(a.droite());\n            case Multiplication m -> evaluer(m.gauche()) * evaluer(m.droite());\n            case Negation ng    -> -evaluer(ng.expr());\n        };\n    }\n\n    static String afficher(Expression e) {\n        return switch (e) {\n            case Nombre n       -> String.valueOf(n.valeur());\n            case Addition a     -> "(" + afficher(a.gauche()) + " + " + afficher(a.droite()) + ")";\n            case Multiplication m -> "(" + afficher(m.gauche()) + " * " + afficher(m.droite()) + ")";\n            case Negation ng    -> "-" + afficher(ng.expr());\n        };\n    }\n\n    public static void main(String[] args) {\n        Expression e1 = new Multiplication(\n            new Addition(new Nombre(2), new Nombre(3)),\n            new Nombre(4)\n        );\n        System.out.println(afficher(e1) + " = " + evaluer(e1));\n\n        Expression e2 = new Negation(new Addition(new Nombre(5), new Nombre(3)));\n        System.out.println(afficher(e2) + " = " + evaluer(e2));\n\n        Expression e3 = new Addition(\n            new Multiplication(new Nombre(10), new Nombre(2)),\n            new Nombre(5)\n        );\n        System.out.println(afficher(e3) + " = " + evaluer(e3));\n    }\n}',
    'output.contains("= 20") && output.contains("= -8") && output.contains("= 25")',
    '["Declarez tous les records avant la classe Main. Le switch exhaustif dans evaluer : case Nombre n -> n.valeur(); case Addition a -> evaluer(a.gauche()) + evaluer(a.droite()); etc. La recursivite s obtient en rappelant evaluer() dans le switch.", "Pour afficher : case Addition a -> \"(\" + afficher(a.gauche()) + \" + \" + afficher(a.droite()) + \")\". La Negation : case Negation ng -> \"-\" + afficher(ng.expr())", "Java garantit que le switch est exhaustif : si vous ajoutez un nouveau type dans permits, le compilateur signale les switch incomplets. C est tout l interet des sealed classes : la completude verifiee a la compilation."]',
    50,
    3
FROM lessons l WHERE l.slug = 'sealed-classes';
