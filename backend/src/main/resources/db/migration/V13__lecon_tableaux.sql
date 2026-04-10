-- V13: Nouvelle lecon Tableaux + quiz

-- =============================================
-- CREATION DE LA LECON TABLEAUX
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Tableaux',
    'tableaux',
    E'TABLEAUX EN JAVA\n\nUn tableau (array) est une structure de donnees qui stocke plusieurs valeurs du meme type sous un seul nom. Les elements sont accessibles par leur indice (index), qui commence toujours a 0.\n\n---\n\nDECLARATION ET INITIALISATION\n\nIl existe deux syntaxes pour creer un tableau :\n\n  // Syntaxe 1 : taille definie, valeurs par defaut\n  int[] scores = new int[5];       // [0, 0, 0, 0, 0]\n  String[] noms = new String[3];   // [null, null, null]\n  boolean[] flags = new boolean[4]; // [false, false, false, false]\n\n  // Syntaxe 2 : initialisation directe\n  int[] notes = {85, 92, 78, 95, 88};\n  String[] jours = {"Lundi", "Mardi", "Mercredi"};\n\nValeurs par defaut :\n- int, long, short, byte : 0\n- double, float : 0.0\n- boolean : false\n- String, objets : null\n\n---\n\nACCES AUX ELEMENTS\n\nL index commence a 0. Le dernier element a l index longueur-1.\n\n  int[] notes = {85, 92, 78, 95, 88};\n\n  System.out.println(notes[0]);   // 85 (premier element)\n  System.out.println(notes[4]);   // 88 (dernier element)\n\n  notes[2] = 100;   // Modifier un element\n  System.out.println(notes[2]);   // 100\n\nERREUR FREQUENTE : ArrayIndexOutOfBoundsException\n  System.out.println(notes[5]);   // ERREUR : index 5, tableau de taille 5 (0 a 4)\n\n---\n\nLA PROPRIETE LENGTH\n\nChaque tableau possede la propriete .length qui retourne son nombre d elements.\n\n  int[] tableau = {10, 20, 30, 40, 50};\n  System.out.println(tableau.length);   // 5\n\n  // Le dernier element est toujours a l index length - 1\n  System.out.println(tableau[tableau.length - 1]);   // 50\n\nIMPORTANT : .length est une propriete (pas une methode), donc pas de parentheses !\n\n---\n\nPARCOURIR UN TABLEAU\n\nTrois methodes pour parcourir un tableau :\n\n  int[] scores = {85, 92, 78, 95, 88};\n\n  // 1. For classique (acces a l index)\n  for (int i = 0; i < scores.length; i++) {\n      System.out.println("scores[" + i + "] = " + scores[i]);\n  }\n\n  // 2. For-each (plus lisible, mais sans acces a l index)\n  for (int score : scores) {\n      System.out.println(score);\n  }\n\n  // 3. Calcul avec for : somme des elements\n  int somme = 0;\n  for (int score : scores) {\n      somme += score;\n  }\n  double moyenne = (double) somme / scores.length;\n  System.out.println("Moyenne : " + moyenne);   // 87.6\n\n---\n\nTABLEAUX MULTIDIMENSIONNELS\n\nJava supporte les tableaux de tableaux (matrices) :\n\n  // Tableau 2D : 3 lignes, 3 colonnes\n  int[][] matrice = {\n      {1, 2, 3},\n      {4, 5, 6},\n      {7, 8, 9}\n  };\n\n  System.out.println(matrice[0][0]);   // 1 (ligne 0, colonne 0)\n  System.out.println(matrice[1][2]);   // 6 (ligne 1, colonne 2)\n  System.out.println(matrice[2][1]);   // 8 (ligne 2, colonne 1)\n\n  // Parcourir avec des boucles imbriquees\n  for (int i = 0; i < matrice.length; i++) {\n      for (int j = 0; j < matrice[i].length; j++) {\n          System.out.print(matrice[i][j] + " ");\n      }\n      System.out.println();\n  }\n\n---\n\nMETHODES UTILES : Arrays\n\nLa classe java.util.Arrays offre des methodes pratiques :\n\n  import java.util.Arrays;\n\n  int[] nombres = {5, 2, 8, 1, 9};\n\n  // Trier un tableau\n  Arrays.sort(nombres);\n  System.out.println(Arrays.toString(nombres));   // [1, 2, 5, 8, 9]\n\n  // Copier un tableau\n  int[] copie = Arrays.copyOf(nombres, nombres.length);\n\n  // Remplir un tableau\n  int[] zeros = new int[5];\n  Arrays.fill(zeros, 0);   // [0, 0, 0, 0, 0]\n\n  // Afficher un tableau\n  System.out.println(Arrays.toString(nombres));   // [1, 2, 5, 8, 9]\n\nATTENTION : System.out.println(nombres) affiche une reference memoire, pas les valeurs !\nUtilisez toujours Arrays.toString() pour afficher un tableau.',
    3,
    30
FROM chapters c WHERE c.slug = 'structures-controle';

-- =============================================
-- QUIZ : Tableaux
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Tableaux en Java',
    'Testez vos connaissances sur la declaration, l acces et le parcours des tableaux',
    300, 70, 100
FROM lessons l WHERE l.slug = 'tableaux';

-- Question 1 : index de debut
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel est l index du premier element d un tableau en Java ?',
        'SINGLE_CHOICE',
        'En Java (comme dans la plupart des langages), les tableaux sont indexes a partir de 0. Un tableau de 5 elements a des indices de 0 a 4. Tenter d acceder a l index 5 provoque une ArrayIndexOutOfBoundsException.',
        1
    FROM quizzes qz WHERE qz.title = 'Quiz - Tableaux en Java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, '1', false, 1 FROM q
UNION ALL SELECT q.id, '0', true, 2 FROM q
UNION ALL SELECT q.id, '-1', false, 3 FROM q
UNION ALL SELECT q.id, 'Depend du type', false, 4 FROM q;

-- Question 2 : taille d un tableau
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment obtenir le nombre d elements d un tableau int[] scores ?',
        'SINGLE_CHOICE',
        'La propriete .length (sans parentheses) retourne la taille du tableau. C est une propriete, pas une methode comme pour les String ou les listes. scores.length() avec parentheses provoquerait une erreur de compilation.',
        2
    FROM quizzes qz WHERE qz.title = 'Quiz - Tableaux en Java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'scores.size()', false, 1 FROM q
UNION ALL SELECT q.id, 'scores.length()', false, 2 FROM q
UNION ALL SELECT q.id, 'scores.length', true, 3 FROM q
UNION ALL SELECT q.id, 'length(scores)', false, 4 FROM q;

-- Question 3 : valeur par defaut
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la valeur initiale des elements d un tableau int[] cree avec new int[5] ?',
        'SINGLE_CHOICE',
        'En Java, les tableaux de types primitifs sont automatiquement initialises a leur valeur par defaut : 0 pour int/long, 0.0 pour double, false pour boolean, null pour les objets (String, etc.).',
        3
    FROM quizzes qz WHERE qz.title = 'Quiz - Tableaux en Java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'null', false, 1 FROM q
UNION ALL SELECT q.id, 'Non initialise (aleatoire)', false, 2 FROM q
UNION ALL SELECT q.id, '0', true, 3 FROM q
UNION ALL SELECT q.id, '-1', false, 4 FROM q;

-- Question 4 : acces dernier element
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pour un tableau int[] tab de taille 5, comment acceder au dernier element ?',
        'SINGLE_CHOICE',
        'Le dernier element est a l index length-1. Pour un tableau de 5 elements, les indices vont de 0 a 4. tab[tab.length-1] est la facon generique d acceder au dernier element, quelle que soit la taille du tableau.',
        4
    FROM quizzes qz WHERE qz.title = 'Quiz - Tableaux en Java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'tab[5]', false, 1 FROM q
UNION ALL SELECT q.id, 'tab[tab.length]', false, 2 FROM q
UNION ALL SELECT q.id, 'tab[tab.length - 1]', true, 3 FROM q
UNION ALL SELECT q.id, 'tab.last()', false, 4 FROM q;

-- Question 5 : ArrayIndexOutOfBoundsException
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle exception est levee quand on accede a un index invalide d un tableau ?',
        'SINGLE_CHOICE',
        'ArrayIndexOutOfBoundsException est levee a l execution quand on tente d acceder a un index negatif ou superieur ou egal a la taille du tableau. C est une RuntimeException, donc non verifiee a la compilation.',
        5
    FROM quizzes qz WHERE qz.title = 'Quiz - Tableaux en Java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'IndexException', false, 1 FROM q
UNION ALL SELECT q.id, 'ArrayIndexOutOfBoundsException', true, 2 FROM q
UNION ALL SELECT q.id, 'NullPointerException', false, 3 FROM q
UNION ALL SELECT q.id, 'IllegalArgumentException', false, 4 FROM q;

-- Question 6 : afficher un tableau
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment afficher correctement les valeurs d un tableau int[] avec System.out.println ?',
        'SINGLE_CHOICE',
        'System.out.println(tableau) n affiche pas les valeurs mais une reference memoire du type [I@1a2b3c. Pour afficher les valeurs, il faut utiliser Arrays.toString(tableau) qui retourne une representation lisible comme [1, 2, 3, 4, 5].',
        6
    FROM quizzes qz WHERE qz.title = 'Quiz - Tableaux en Java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'System.out.println(tableau)', false, 1 FROM q
UNION ALL SELECT q.id, 'System.out.println(Arrays.toString(tableau))', true, 2 FROM q
UNION ALL SELECT q.id, 'System.out.println(tableau.values())', false, 3 FROM q
UNION ALL SELECT q.id, 'tableau.print()', false, 4 FROM q;
