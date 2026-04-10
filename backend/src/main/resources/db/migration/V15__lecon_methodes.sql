-- V15: Nouvelle lecon Methodes + quiz

-- =============================================
-- CREATION DE LA LECON METHODES
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Methodes',
    'methodes',
    E'METHODES EN JAVA\n\nUne methode est un bloc de code nomme qui accomplit une tache specifique. Les methodes permettent de structurer le code, d eviter la repetition (DRY : Don t Repeat Yourself) et de le rendre plus lisible et testable.\n\n---\n\nDECLARATION D UNE METHODE\n\nSyntaxe complete :\n\n  modificateurs typeRetour nomMethode(type param1, type param2) {\n      // corps de la methode\n      return valeur;   // si le type de retour n est pas void\n  }\n\nExemples :\n\n  // Methode qui retourne un int\n  public static int addition(int a, int b) {\n      return a + b;\n  }\n\n  // Methode sans retour (void)\n  public static void afficherBonjour(String prenom) {\n      System.out.println("Bonjour " + prenom + " !");\n  }\n\n  // Methode sans parametres\n  public static void afficherSeparateur() {\n      System.out.println("---");\n  }\n\n---\n\nAPPELER UNE METHODE\n\n  public class Main {\n      public static void main(String[] args) {\n          // Appel avec recuperation du resultat\n          int resultat = addition(3, 5);\n          System.out.println(resultat);   // 8\n\n          // Appel direct (retour ignore ou methode void)\n          afficherBonjour("Alice");\n          afficherSeparateur();\n\n          // Appel imbriqué\n          System.out.println(addition(10, addition(3, 4)));   // 17\n      }\n\n      public static int addition(int a, int b) {\n          return a + b;\n      }\n\n      public static void afficherBonjour(String prenom) {\n          System.out.println("Bonjour " + prenom + " !");\n      }\n\n      public static void afficherSeparateur() {\n          System.out.println("---");\n      }\n  }\n\n---\n\nPARAMETRES ET ARGUMENTS\n\nParametres : variables declarees dans la signature de la methode\nArguments : valeurs passees lors de l appel\n\n  // a et b sont les PARAMETRES\n  public static int multiplier(int a, int b) {\n      return a * b;\n  }\n\n  // 4 et 7 sont les ARGUMENTS\n  int resultat = multiplier(4, 7);   // resultat = 28\n\nJava passe les types primitifs PAR VALEUR : la methode recoit une copie, pas la variable originale.\n\n  public static void incrementer(int x) {\n      x++;   // Modifie la copie locale, pas la variable originale !\n  }\n\n  int nombre = 5;\n  incrementer(nombre);\n  System.out.println(nombre);   // 5, pas 6 !\n\n---\n\nVALEUR DE RETOUR\n\nreturn termine immediatement la methode et renvoie la valeur specifiee :\n\n  public static String classer(int note) {\n      if (note >= 90) return "Excellent";\n      if (note >= 70) return "Bien";\n      if (note >= 50) return "Passable";\n      return "Insuffisant";   // return obligatoire pour tous les chemins d execution\n  }\n\n  System.out.println(classer(85));   // "Bien"\n  System.out.println(classer(45));   // "Insuffisant"\n\nPour une methode void, return sans valeur est optionnel mais peut servir a sortir de la methode :\n\n  public static void afficherPositif(int n) {\n      if (n <= 0) return;   // Sortie anticipee\n      System.out.println(n);\n  }\n\n---\n\nSURCHARGE DE METHODE (OVERLOADING)\n\nJava permet d avoir plusieurs methodes avec le MEME nom mais des parametres differents :\n\n  public static int additionner(int a, int b) {\n      return a + b;\n  }\n\n  public static double additionner(double a, double b) {\n      return a + b;\n  }\n\n  public static int additionner(int a, int b, int c) {\n      return a + b + c;\n  }\n\n  // Java choisit automatiquement la bonne version\n  additionner(3, 5);       // appelle la version int\n  additionner(3.0, 5.0);   // appelle la version double\n  additionner(1, 2, 3);    // appelle la version a 3 parametres\n\n---\n\nSTATIC VS INSTANCE\n\n  static : methode appartenant a la classe elle-meme\n  sans static : methode appartenant aux objets (instances) de la classe\n\n  public class Calculatrice {\n      // Methode statique : appelee sur la classe\n      public static int additionner(int a, int b) {\n          return a + b;\n      }\n\n      // Methode d instance : appelee sur un objet\n      public int multiplier(int a, int b) {\n          return a * b;\n      }\n  }\n\n  // Appel statique\n  int somme = Calculatrice.additionner(3, 5);   // Pas besoin de new\n\n  // Appel sur instance\n  Calculatrice calc = new Calculatrice();\n  int produit = calc.multiplier(3, 5);\n\nDans la methode main (static), vous ne pouvez appeler que des methodes static directement. Pour appeler une methode d instance, vous devez creer un objet avec new.\n\n---\n\nBONNES PRATIQUES\n\n  - Une methode = une responsabilite (principe de responsabilite unique)\n  - Noms de methodes : verbes en camelCase (calculerTotal, afficherMenu)\n  - Gardez vos methodes courtes : si une methode depasse 20 lignes, envisagez de la decouper\n  - Commentez le POURQUOI, pas le QUOI\n  - Evitez plus de 3-4 parametres : si besoin, regroupez dans un objet',
    4,
    30
FROM chapters c WHERE c.slug = 'structures-controle';

-- =============================================
-- QUIZ : Methodes
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Methodes en Java',
    'Testez votre maitrise de la declaration, des parametres, du retour et de la surcharge de methodes',
    300, 70, 100
FROM lessons l WHERE l.slug = 'methodes';

-- Question 1 : mot-cle void
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que signifie void dans la declaration d une methode Java ?',
        'SINGLE_CHOICE',
        'void indique que la methode ne retourne aucune valeur. Une methode void peut contenir des return vides (return;) pour sortir anticipement, mais ne peut pas retourner de valeur avec return valeur;.',
        1
    FROM quizzes qz WHERE qz.title = 'Quiz - Methodes en Java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'La methode est vide (sans code)', false, 1 FROM q
UNION ALL SELECT q.id, 'La methode ne retourne aucune valeur', true, 2 FROM q
UNION ALL SELECT q.id, 'La methode retourne null', false, 3 FROM q
UNION ALL SELECT q.id, 'La methode est privee', false, 4 FROM q;

-- Question 2 : passage par valeur
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que se passe-t-il si on modifie un parametre de type int dans une methode ?',
        'SINGLE_CHOICE',
        'Java passe les types primitifs par valeur. La methode recoit une COPIE de la valeur originale. Modifier le parametre n affecte pas la variable originale de l appelant. Ce comportement est different pour les objets qui sont passes par reference de valeur.',
        2
    FROM quizzes qz WHERE qz.title = 'Quiz - Methodes en Java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'La variable originale est modifiee', false, 1 FROM q
UNION ALL SELECT q.id, 'Une exception est levee', false, 2 FROM q
UNION ALL SELECT q.id, 'La variable originale n est pas affectee', true, 3 FROM q
UNION ALL SELECT q.id, 'Le compilateur refuse la modification', false, 4 FROM q;

-- Question 3 : surcharge
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Qu est-ce que la surcharge de methode (method overloading) en Java ?',
        'SINGLE_CHOICE',
        'La surcharge permet de definir plusieurs methodes avec le meme nom mais des signatures differentes (nombre ou types de parametres differents). Java determine a la compilation quelle version appeler selon les arguments fournis. Le type de retour seul ne suffit pas a differentier deux methodes surchargees.',
        3
    FROM quizzes qz WHERE qz.title = 'Quiz - Methodes en Java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Modifier une methode heritee', false, 1 FROM q
UNION ALL SELECT q.id, 'Plusieurs methodes de meme nom avec des parametres differents', true, 2 FROM q
UNION ALL SELECT q.id, 'Appeler une methode plusieurs fois', false, 3 FROM q
UNION ALL SELECT q.id, 'Cacher une methode de la classe parente', false, 4 FROM q;

-- Question 4 : static
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Depuis la methode main (static), comment peut-on appeler une methode NON statique de la meme classe ?',
        'SINGLE_CHOICE',
        'La methode main est statique et ne peut acceder directement qu aux autres membres statiques. Pour appeler une methode d instance (non statique), il faut d abord creer un objet de la classe avec new, puis appeler la methode sur cet objet.',
        4
    FROM quizzes qz WHERE qz.title = 'Quiz - Methodes en Java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Directement, comme une methode statique', false, 1 FROM q
UNION ALL SELECT q.id, 'En la rendant d abord statique avec le mot-cle static', false, 2 FROM q
UNION ALL SELECT q.id, 'En creant une instance de la classe avec new', true, 3 FROM q
UNION ALL SELECT q.id, 'Ce n est pas possible', false, 4 FROM q;

-- Question 5 : return
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle affirmation sur return est correcte ?',
        'SINGLE_CHOICE',
        'return termine immediatement l execution de la methode. Pour une methode avec un type de retour non void, Java oblige a ce que tous les chemins d execution possibles se terminent par un return avec une valeur compatible. Pour void, return est optionnel.',
        5
    FROM quizzes qz WHERE qz.title = 'Quiz - Methodes en Java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'return ne peut apparaitre qu a la fin de la methode', false, 1 FROM q
UNION ALL SELECT q.id, 'return termine immediatement l execution de la methode', true, 2 FROM q
UNION ALL SELECT q.id, 'Une methode void ne peut pas avoir de return', false, 3 FROM q
UNION ALL SELECT q.id, 'return peut retourner plusieurs valeurs', false, 4 FROM q;

-- Question 6 : bonne pratique
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Selon les bonnes pratiques, quelle convention de nommage Java s applique aux methodes ?',
        'SINGLE_CHOICE',
        'Les methodes Java utilisent le camelCase et commencent par un verbe decrivant l action effectuee : calculerTotal(), afficherMenu(), getAge(), setNom(). Le PascalCase est reserve aux noms de classes. Le snake_case est utilise dans d autres langages comme Python mais pas Java.',
        6
    FROM quizzes qz WHERE qz.title = 'Quiz - Methodes en Java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'PascalCase : CalculerTotal()', false, 1 FROM q
UNION ALL SELECT q.id, 'snake_case : calculer_total()', false, 2 FROM q
UNION ALL SELECT q.id, 'SCREAMING_SNAKE : CALCULER_TOTAL()', false, 3 FROM q
UNION ALL SELECT q.id, 'camelCase : calculerTotal()', true, 4 FROM q;
