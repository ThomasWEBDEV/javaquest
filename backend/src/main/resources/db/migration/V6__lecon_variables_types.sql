-- V6: Contenu detaille du chapitre Variables et Types + QCMs

-- =============================================
-- CONTENU RICHE : Types primitifs
-- =============================================

UPDATE lessons SET content = E'LES TYPES PRIMITIFS EN JAVA\n\nJava est un langage a typage statique fort : chaque variable a un type defini a la compilation et ce type ne peut pas changer. Java propose 8 types primitifs, qui stockent directement une valeur en memoire (contrairement aux objets).\n\n---\n\nLES 4 TYPES ENTIERS\n\nJava distingue plusieurs types pour les entiers selon la plage de valeurs necessaire :\n\n  byte  : 8 bits,  de -128 a 127\n  short : 16 bits, de -32 768 a 32 767\n  int   : 32 bits, de -2 147 483 648 a 2 147 483 647\n  long  : 64 bits, de -9 223 372 036 854 775 808 a 9 223 372 036 854 775 807\n\nExemples :\n\n  byte temperature = 37;\n  short annee = 2024;\n  int population = 68_000_000;   // les underscores ameliorent la lisibilite\n  long distanceEtoile = 9_460_730_472_580_800L;  // le L indique un long\n\nConseils pratiques :\n- Utilisez int par defaut pour les entiers. C est le type le plus efficace sur la plupart des machines.\n- Utilisez long uniquement si la valeur depasse la plage de int.\n- byte et short sont surtout utiles pour economiser la memoire dans de grands tableaux.\n\n---\n\nLES TYPES DECIMAUX\n\n  float  : 32 bits, precision d environ 7 chiffres significatifs\n  double : 64 bits, precision d environ 15 chiffres significatifs\n\nExemples :\n\n  float tauxTVA = 0.20f;      // le f indique un float\n  double pi = 3.141592653589793;\n  double prixProduit = 49.99;\n\nConseils pratiques :\n- Utilisez double par defaut pour les decimaux. Il est plus precis et c est le type par defaut de Java pour les litteraux decimaux.\n- Evitez float sauf contrainte memoire forte.\n- ATTENTION : les types flottants ne sont pas exacts ! 0.1 + 0.2 ne vaut pas exactement 0.3 en Java (ni dans aucun autre langage utilisant l IEEE 754). Pour les calculs financiers, utilisez java.math.BigDecimal.\n\n---\n\nLE TYPE BOOLEAN\n\n  boolean : stocke uniquement true ou false\n\nExemples :\n\n  boolean estActif = true;\n  boolean aDepasse18Ans = age >= 18;\n  boolean estVide = liste.isEmpty();\n\nLe type boolean est fondamental pour les conditions (if, while). Il ne peut prendre que deux valeurs, jamais un entier comme en C.\n\n---\n\nLE TYPE CHAR\n\n  char : 16 bits, stocke un unique caractere Unicode (de \\u0000 a \\uFFFF)\n\nExemples :\n\n  char initiale = \'J\';\n  char symboleEuro = \'\\u20AC\';   // le symbole euro en Unicode\n  char sautLigne = \'\\n\';        // caracteres echappes\n\nNote : char utilise des guillemets simples, String utilise des guillemets doubles.\n\n---\n\nCONVERSION ENTRE TYPES\n\nJava permet de convertir entre types numeriques de deux facons :\n\n  Conversion implicite (widening) : du plus petit vers le plus grand, sans perte\n    int entier = 42;\n    double decimal = entier;   // OK, automatique\n\n  Conversion explicite (cast) : du plus grand vers le plus petit, avec perte possible\n    double prix = 9.99;\n    int prixEntier = (int) prix;   // prixEntier vaut 9, la partie decimale est perdue\n\nL ordre des conversions implicites : byte -> short -> int -> long -> float -> double\n\n---\n\nPIEGES COURANTS\n\n  Division entiere\n    int a = 7;\n    int b = 2;\n    double resultat = a / b;   // resultat vaut 3.0, pas 3.5 !\n    // La division est calculee en entier avant la conversion\n    double correct = (double) a / b;   // resultat vaut 3.5\n\n  Debordement (overflow)\n    int max = Integer.MAX_VALUE;   // 2 147 483 647\n    int suivant = max + 1;         // suivant vaut -2 147 483 648 !\n    // Java ne genere pas d erreur, il repart a la valeur minimale\n\n  Comparaison de flottants\n    double x = 0.1 + 0.2;\n    System.out.println(x == 0.3);   // affiche false !\n    // Comparaison correcte :\n    System.out.println(Math.abs(x - 0.3) < 0.0001);   // affiche true'
WHERE slug = 'types-primitifs';

-- =============================================
-- CONTENU RICHE : Variables
-- =============================================

UPDATE lessons SET content = E'VARIABLES ET CONSTANTES EN JAVA\n\nUne variable est un espace memoire nomme qui contient une valeur. En Java, toute variable doit etre declaree avec un type avant d etre utilisee.\n\n---\n\nDECLARATION ET INITIALISATION\n\nOn peut declarer et initialiser une variable en une seule ligne ou en deux etapes :\n\n  // Declaration + initialisation en une ligne (recommande)\n  int score = 0;\n  String nom = "Alice";\n  boolean estConnecte = false;\n\n  // Declaration puis initialisation separees\n  int compteur;\n  compteur = 10;\n\nUne variable non initialisee ne peut pas etre utilisee : Java refuse de compiler et signale l erreur "variable might not have been initialized".\n\n---\n\nPORTEE DES VARIABLES (SCOPE)\n\nLa portee d une variable definit la zone du code ou elle est accessible. En Java, la portee est delimitee par les accolades { }.\n\n  public class Exemple {\n\n      static int variableDeClasse = 100;   // accessible dans toute la classe\n\n      public static void main(String[] args) {\n\n          int variableLocale = 42;   // accessible dans toute la methode main\n\n          if (variableLocale > 0) {\n              int dansLeBloc = 5;    // accessible uniquement dans ce bloc if\n              System.out.println(dansLeBloc);   // OK\n          }\n\n          // System.out.println(dansLeBloc);   // ERREUR : hors de portee\n      }\n  }\n\n---\n\nCONSTANTES AVEC FINAL\n\nLe mot-cle final empeche la reassignation d une variable. C est l equivalent des constantes dans d autres langages.\n\n  final int JOURS_PAR_SEMAINE = 7;\n  final double TVA = 0.20;\n  final String NOM_APP = "JavaQuest";\n\n  JOURS_PAR_SEMAINE = 8;   // ERREUR de compilation !\n\nConventions de nommage pour les constantes : UPPER_SNAKE_CASE (tout en majuscules avec des underscores).\n\n---\n\nINFERENCE DE TYPE AVEC VAR (Java 10+)\n\nDepuis Java 10, le mot-cle var permet au compilateur de deduire automatiquement le type d une variable locale :\n\n  var age = 25;            // le compilateur deduit int\n  var prix = 9.99;         // le compilateur deduit double\n  var message = "Salut";   // le compilateur deduit String\n\nvar ne signifie pas "sans type" : le type est toujours fixe a la compilation, il est simplement deduit automatiquement. On ne peut pas ecrire var x; sans valeur initiale.\n\n---\n\nCONVENTIONS DE NOMMAGE\n\nJava a des conventions strictes, respectees par tous les developpeurs :\n\n  Variables et methodes : camelCase\n    int nombreEtudiants = 30;\n    double calculerMoyenne() { ... }\n\n  Classes : PascalCase (ou UpperCamelCase)\n    class EtudiantInscrit { ... }\n\n  Constantes : UPPER_SNAKE_CASE\n    final int MAX_TENTATIVES = 3;\n\n  Packages : tout en minuscules\n    package com.javaquest.modele;\n\nCes conventions ne sont pas imposees par le compilateur, mais les ignorer est considere comme une tres mauvaise pratique en Java professionnel.\n\n---\n\nOPERATEURS D ASSIGNATION\n\nJava propose des operateurs raccourcis pour modifier une variable :\n\n  int x = 10;\n  x += 5;    // equivalent a x = x + 5  => x vaut 15\n  x -= 3;    // equivalent a x = x - 3  => x vaut 12\n  x *= 2;    // equivalent a x = x * 2  => x vaut 24\n  x /= 4;    // equivalent a x = x / 4  => x vaut 6\n  x %= 4;    // equivalent a x = x % 4  => x vaut 2\n\n  x++;       // incremente x de 1 (post-increment)\n  ++x;       // incremente x de 1 (pre-increment)\n  x--;       // decremente x de 1\n\nDifference entre x++ et ++x :\n  int a = 5;\n  int b = a++;   // b vaut 5, a vaut 6 (increment apres assignation)\n  int c = ++a;   // c vaut 7, a vaut 7 (increment avant assignation)\n\n---\n\nBONNES PRATIQUES\n\n- Declarez les variables le plus pres possible de leur premiere utilisation\n- Donnez des noms explicites : nombreJoursRestants est meilleur que n\n- Preferez des variables a usage unique plutot que de reutiliser une meme variable pour differents roles\n- Utilisez final des que la valeur ne doit pas changer : cela documente votre intention et previent les bugs'
WHERE slug = 'variables';

-- =============================================
-- QUIZ : Types primitifs
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Types primitifs',
    'Testez vos connaissances sur les 8 types primitifs de Java',
    300, 70, 100
FROM lessons l WHERE l.slug = 'types-primitifs';

-- Question 1 : type par defaut pour les entiers
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel type Java est recommande par defaut pour stocker un nombre entier ?',
        'SINGLE_CHOICE',
        'int est le type entier recommande par defaut en Java. Il est sur 32 bits et couvre la plupart des besoins. On n utilise long que si la valeur depasse 2 147 483 647.',
        1
    FROM quizzes qz WHERE qz.title = 'Quiz - Types primitifs'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'byte', false, 1 FROM q
UNION ALL SELECT q.id, 'short', false, 2 FROM q
UNION ALL SELECT q.id, 'int', true, 3 FROM q
UNION ALL SELECT q.id, 'long', false, 4 FROM q;

-- Question 2 : type pour les decimaux
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel est le type recommande par defaut pour les nombres decimaux en Java ?',
        'SINGLE_CHOICE',
        'double est recommande par defaut pour les decimaux. Il offre une precision d environ 15 chiffres significatifs. float n a que 7 chiffres de precision et est moins pratique car il necessite le suffixe f.',
        2
    FROM quizzes qz WHERE qz.title = 'Quiz - Types primitifs'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'float', false, 1 FROM q
UNION ALL SELECT q.id, 'double', true, 2 FROM q
UNION ALL SELECT q.id, 'decimal', false, 3 FROM q
UNION ALL SELECT q.id, 'number', false, 4 FROM q;

-- Question 3 : valeurs possibles de boolean
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelles sont les deux seules valeurs possibles pour un boolean en Java ?',
        'SINGLE_CHOICE',
        'Un boolean Java ne peut valoir que true ou false. Contrairement au C ou C++, Java n accepte pas 0 ou 1 comme valeur booleenne.',
        3
    FROM quizzes qz WHERE qz.title = 'Quiz - Types primitifs'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, '0 et 1', false, 1 FROM q
UNION ALL SELECT q.id, 'true et false', true, 2 FROM q
UNION ALL SELECT q.id, 'yes et no', false, 3 FROM q
UNION ALL SELECT q.id, 'on et off', false, 4 FROM q;

-- Question 4 : division entiere
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la valeur de : double resultat = 7 / 2; en Java ?',
        'SINGLE_CHOICE',
        'La division 7 / 2 est calculee comme une division entiere (les deux operandes sont des int), ce qui donne 3. Ce 3 est ensuite converti en double, donc resultat vaut 3.0. Pour obtenir 3.5, il faut ecrire (double) 7 / 2 ou 7.0 / 2.',
        4
    FROM quizzes qz WHERE qz.title = 'Quiz - Types primitifs'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, '3.5', false, 1 FROM q
UNION ALL SELECT q.id, '3.0', true, 2 FROM q
UNION ALL SELECT q.id, '3', false, 3 FROM q
UNION ALL SELECT q.id, 'Erreur de compilation', false, 4 FROM q;

-- Question 5 : nombre de types primitifs
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Combien de types primitifs Java possede-t-il ?',
        'SINGLE_CHOICE',
        'Java possede exactement 8 types primitifs : byte, short, int, long, float, double, boolean et char. Tous les autres types (String, tableaux, objets) sont des types references.',
        5
    FROM quizzes qz WHERE qz.title = 'Quiz - Types primitifs'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, '4', false, 1 FROM q
UNION ALL SELECT q.id, '6', false, 2 FROM q
UNION ALL SELECT q.id, '8', true, 3 FROM q
UNION ALL SELECT q.id, '10', false, 4 FROM q;

-- Question 6 : guillemets pour char
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment declarer correctement un char contenant la lettre A en Java ?',
        'SINGLE_CHOICE',
        'Un char utilise des guillemets simples : char c = ''A''. Les guillemets doubles sont reserves aux String. Ecrire "A" entre guillemets doubles cree un String, pas un char.',
        6
    FROM quizzes qz WHERE qz.title = 'Quiz - Types primitifs'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'char c = "A";', false, 1 FROM q
UNION ALL SELECT q.id, 'char c = ''A'';', true, 2 FROM q
UNION ALL SELECT q.id, 'char c = A;', false, 3 FROM q
UNION ALL SELECT q.id, 'char c = (char) "A";', false, 4 FROM q;

-- =============================================
-- QUIZ : Variables
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Variables et constantes',
    'Verifiez votre maitrise des variables, de la portee et du mot-cle final',
    240, 70, 75
FROM lessons l WHERE l.slug = 'variables';

-- Question 1 : mot-cle final
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel mot-cle Java permet de declarer une constante (valeur non modifiable) ?',
        'SINGLE_CHOICE',
        'Le mot-cle final empeche la reassignation d une variable. Une fois initialisee, sa valeur ne peut plus changer. Les constantes sont par convention nommees en UPPER_SNAKE_CASE.',
        1
    FROM quizzes qz WHERE qz.title = 'Quiz - Variables et constantes'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'const', false, 1 FROM q
UNION ALL SELECT q.id, 'static', false, 2 FROM q
UNION ALL SELECT q.id, 'final', true, 3 FROM q
UNION ALL SELECT q.id, 'immutable', false, 4 FROM q;

-- Question 2 : convention camelCase
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Selon les conventions Java, quel est le bon nom pour une variable comptant le nombre d etudiants ?',
        'SINGLE_CHOICE',
        'Les variables et methodes Java utilisent le camelCase : la premiere lettre est minuscule, chaque nouveau mot commence par une majuscule. NombreEtudiants serait du PascalCase (pour les classes). NOMBRE_ETUDIANTS est pour les constantes.',
        2
    FROM quizzes qz WHERE qz.title = 'Quiz - Variables et constantes'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'NombreEtudiants', false, 1 FROM q
UNION ALL SELECT q.id, 'nombre_etudiants', false, 2 FROM q
UNION ALL SELECT q.id, 'nombreEtudiants', true, 3 FROM q
UNION ALL SELECT q.id, 'NOMBRE_ETUDIANTS', false, 4 FROM q;

-- Question 3 : inference de type var
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Depuis quelle version de Java le mot-cle var permet-il l inference de type local ?',
        'SINGLE_CHOICE',
        'var a ete introduit en Java 10. Il permet au compilateur de deduire automatiquement le type d une variable locale a partir de la valeur initiale. Le type reste fixe a la compilation.',
        3
    FROM quizzes qz WHERE qz.title = 'Quiz - Variables et constantes'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Java 8', false, 1 FROM q
UNION ALL SELECT q.id, 'Java 9', false, 2 FROM q
UNION ALL SELECT q.id, 'Java 10', true, 3 FROM q
UNION ALL SELECT q.id, 'Java 11', false, 4 FROM q;

-- Question 4 : portee de variable
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Qu est-ce que la portee (scope) d une variable en Java ?',
        'SINGLE_CHOICE',
        'La portee definit la zone du code ou une variable est accessible. En Java, elle est delimitee par les accolades. Une variable declaree dans un bloc if n est pas accessible en dehors de ce bloc.',
        4
    FROM quizzes qz WHERE qz.title = 'Quiz - Variables et constantes'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'La taille en memoire de la variable', false, 1 FROM q
UNION ALL SELECT q.id, 'La zone du code ou la variable est accessible', true, 2 FROM q
UNION ALL SELECT q.id, 'Le type de donnees stocke', false, 3 FROM q
UNION ALL SELECT q.id, 'La valeur maximale de la variable', false, 4 FROM q;

-- Question 5 : operateur +=
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la valeur de x apres : int x = 10; x += 5; x *= 2; ?',
        'SINGLE_CHOICE',
        'x += 5 est equivalent a x = x + 5, donc x vaut 15. Puis x *= 2 est equivalent a x = x * 2, donc x vaut 30.',
        5
    FROM quizzes qz WHERE qz.title = 'Quiz - Variables et constantes'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, '15', false, 1 FROM q
UNION ALL SELECT q.id, '20', false, 2 FROM q
UNION ALL SELECT q.id, '25', false, 3 FROM q
UNION ALL SELECT q.id, '30', true, 4 FROM q;
