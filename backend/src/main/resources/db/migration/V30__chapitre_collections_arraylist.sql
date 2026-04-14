-- V30: Nouveau chapitre Collections Java + Lecon 1 ArrayList + Quiz

-- =============================================
-- CHAPITRE 5 : Collections Java
-- =============================================

INSERT INTO chapters (title, slug, description, order_index, xp_reward, is_published)
VALUES (
    'Collections Java',
    'collections-java',
    'Maitrisez ArrayList et HashMap pour gerer des groupes de donnees de maniere dynamique',
    5,
    300,
    true
);

-- =============================================
-- LECON 1 : ArrayList
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'ArrayList : listes dynamiques',
    'arraylist',
    E'ARRAYLIST EN JAVA : LISTES DYNAMIQUES\n\nLes tableaux Java ont une taille fixe definie a la creation. ArrayList offre une liste dynamique qui peut grandir ou se reduire selon les besoins, sans limite predefinie.\n\n---\n\nLE PROBLEME AVEC LES TABLEAUX\n\nUn tableau a une taille fixe :\n\n  String[] noms = new String[3];\n  noms[0] = "Alice";\n  noms[1] = "Bob";\n  noms[2] = "Charlie";\n  // Impossible d ajouter un 4eme element !\n\nAvec ArrayList, plus de contrainte de taille :\n\n  ArrayList<String> noms = new ArrayList<>();\n  noms.add("Alice");\n  noms.add("Bob");\n  noms.add("Charlie");\n  noms.add("David"); // Aucun probleme !\n\n---\n\nCREER UNE ARRAYLIST\n\nLa syntaxe utilise des generiques (<Type>) pour preciser le type des elements :\n\n  import java.util.ArrayList;\n\n  ArrayList<String> prenoms  = new ArrayList<>();\n  ArrayList<Integer> notes   = new ArrayList<>();\n  ArrayList<Double> prix     = new ArrayList<>();\n\nLe type entre < > est le type des elements stockes. On utilise les types enveloppes (Integer, Double) et non les types primitifs (int, double).\n\n---\n\nAJOUTER ET ACCEDER AUX ELEMENTS\n\n  ArrayList<String> fruits = new ArrayList<>();\n\n  // Ajouter a la fin\n  fruits.add("Pomme");\n  fruits.add("Banane");\n  fruits.add("Cerise");\n\n  // Ajouter a un index precis (decale les suivants)\n  fruits.add(1, "Abricot"); // ["Pomme", "Abricot", "Banane", "Cerise"]\n\n  // Acceder par index (commence a 0)\n  System.out.println(fruits.get(0)); // Pomme\n  System.out.println(fruits.get(2)); // Banane\n\n  // Taille de la liste\n  System.out.println(fruits.size()); // 4\n\n---\n\nMODIFIER ET SUPPRIMER\n\n  ArrayList<String> couleurs = new ArrayList<>();\n  couleurs.add("Rouge");\n  couleurs.add("Vert");\n  couleurs.add("Bleu");\n\n  // Modifier un element\n  couleurs.set(1, "Jaune"); // ["Rouge", "Jaune", "Bleu"]\n\n  // Supprimer par index\n  couleurs.remove(0); // ["Jaune", "Bleu"]\n\n  // Supprimer par valeur\n  couleurs.remove("Bleu"); // ["Jaune"]\n\n  // Verifier si un element existe\n  System.out.println(couleurs.contains("Jaune")); // true\n  System.out.println(couleurs.contains("Bleu"));  // false\n\n---\n\nPARCOURIR UNE ARRAYLIST\n\nLa boucle for-each est la plus lisible :\n\n  ArrayList<String> villes = new ArrayList<>();\n  villes.add("Paris");\n  villes.add("Lyon");\n  villes.add("Marseille");\n\n  for (String ville : villes) {\n      System.out.println("Ville : " + ville);\n  }\n  // Ville : Paris\n  // Ville : Lyon\n  // Ville : Marseille\n\nAvec un index si necessaire :\n\n  for (int i = 0; i < villes.size(); i++) {\n      System.out.println(i + " : " + villes.get(i));\n  }\n  // 0 : Paris\n  // 1 : Lyon\n  // 2 : Marseille\n\n---\n\nEXEMPLE COMPLET\n\n  ArrayList<Integer> temperatures = new ArrayList<>();\n  temperatures.add(18);\n  temperatures.add(22);\n  temperatures.add(15);\n  temperatures.add(27);\n  temperatures.add(20);\n\n  // Calculer la moyenne\n  int somme = 0;\n  for (int t : temperatures) {\n      somme += t;\n  }\n  double moyenne = (double) somme / temperatures.size();\n  System.out.println("Moyenne : " + moyenne); // Moyenne : 20.4\n\n  // Trouver le maximum\n  int max = temperatures.get(0);\n  for (int t : temperatures) {\n      if (t > max) max = t;\n  }\n  System.out.println("Maximum : " + max); // Maximum : 27\n\nLa prochaine lecon explore HashMap, qui stocke des paires cle-valeur pour un acces ultra-rapide par cle.',
    1,
    40
FROM chapters c WHERE c.slug = 'collections-java';

-- =============================================
-- QUIZ : ArrayList
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - ArrayList',
    'Testez vos connaissances sur les listes dynamiques ArrayList',
    300, 70, 100
FROM lessons l WHERE l.slug = 'arraylist';

-- Question 1 : tableau vs ArrayList
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la principale difference entre un tableau (array) et une ArrayList en Java ?',
        'SINGLE_CHOICE',
        'Un tableau a une taille fixe definie a la creation : new int[5] ne pourra jamais stocker plus de 5 elements. Une ArrayList est une liste dynamique dont la taille varie automatiquement : on peut ajouter ou supprimer des elements sans limite. C est la difference fondamentale qui justifie l utilisation de ArrayList quand on ne connait pas a l avance le nombre d elements.',
        1
    FROM quizzes qz WHERE qz.title = 'Quiz - ArrayList'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Un tableau peut stocker plusieurs types, ArrayList un seul', false, 1 FROM q
UNION ALL SELECT q.id, 'Un tableau a une taille fixe, ArrayList est dynamique', true, 2 FROM q
UNION ALL SELECT q.id, 'ArrayList ne peut pas stocker des String', false, 3 FROM q
UNION ALL SELECT q.id, 'Un tableau est plus puissant qu une ArrayList', false, 4 FROM q;

-- Question 2 : ajouter un element
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode utilise-t-on pour ajouter un element a la fin d une ArrayList ?',
        'SINGLE_CHOICE',
        'La methode add(element) ajoute un element a la fin de la liste. On peut aussi utiliser add(index, element) pour inserer a une position precise, ce qui decale tous les elements suivants vers la droite. Par exemple : fruits.add("Pomme") ajoute "Pomme" en derniere position. La taille de la liste augmente automatiquement de 1.',
        2
    FROM quizzes qz WHERE qz.title = 'Quiz - ArrayList'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'insert(element)', false, 1 FROM q
UNION ALL SELECT q.id, 'push(element)', false, 2 FROM q
UNION ALL SELECT q.id, 'add(element)', true, 3 FROM q
UNION ALL SELECT q.id, 'append(element)', false, 4 FROM q;

-- Question 3 : obtenir la taille
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode retourne le nombre d elements dans une ArrayList ?',
        'SINGLE_CHOICE',
        'La methode size() retourne le nombre d elements actuellement dans la liste. Attention : avec les tableaux on utilise .length (propriete), mais avec ArrayList on utilise .size() (methode avec parentheses). Exemple : if (liste.size() == 0) { ... } pour tester si la liste est vide, ou la methode pratique isEmpty() qui fait la meme chose.',
        3
    FROM quizzes qz WHERE qz.title = 'Quiz - ArrayList'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'length()', false, 1 FROM q
UNION ALL SELECT q.id, 'count()', false, 2 FROM q
UNION ALL SELECT q.id, 'size()', true, 3 FROM q
UNION ALL SELECT q.id, 'length', false, 4 FROM q;

-- Question 4 : acceder par index
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment accede-t-on a l element d index 2 dans une ArrayList nommee "liste" ?',
        'SINGLE_CHOICE',
        'La methode get(index) retourne l element a la position donnee. Les index commencent a 0 : liste.get(0) retourne le premier element, liste.get(1) le deuxieme, liste.get(2) le troisieme. Contrairement aux tableaux ou on utilise liste[2], avec ArrayList on doit utiliser liste.get(2). Un index hors bornes (negatif ou >= size()) lance une IndexOutOfBoundsException.',
        4
    FROM quizzes qz WHERE qz.title = 'Quiz - ArrayList'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'liste[2]', false, 1 FROM q
UNION ALL SELECT q.id, 'liste.element(2)', false, 2 FROM q
UNION ALL SELECT q.id, 'liste.get(2)', true, 3 FROM q
UNION ALL SELECT q.id, 'liste.index(2)', false, 4 FROM q;

-- Question 5 : contains
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode permet de verifier si une ArrayList contient un element donne ?',
        'SINGLE_CHOICE',
        'La methode contains(element) retourne true si l element est present dans la liste, false sinon. Elle utilise equals() pour la comparaison, donc elle compare le contenu et non les references. Exemple : fruits.contains("Pomme") retourne true si "Pomme" est dans la liste. Tres utile avant de tenter de supprimer un element avec remove() pour eviter les erreurs.',
        5
    FROM quizzes qz WHERE qz.title = 'Quiz - ArrayList'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'has(element)', false, 1 FROM q
UNION ALL SELECT q.id, 'includes(element)', false, 2 FROM q
UNION ALL SELECT q.id, 'contains(element)', true, 3 FROM q
UNION ALL SELECT q.id, 'exists(element)', false, 4 FROM q;

-- Question 6 : declaration correcte
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la syntaxe correcte pour declarer une ArrayList de String en Java ?',
        'SINGLE_CHOICE',
        'La declaration correcte est ArrayList<String> liste = new ArrayList<>();. Le type entre < > (generique) precise le type des elements stockes. On utilise String (type objet), pas string. Le <> vide a droite est le diamant (diamond operator), introduit en Java 7 : Java infere le type automatiquement depuis la declaration. Il faut importer java.util.ArrayList pour utiliser cette classe.',
        6
    FROM quizzes qz WHERE qz.title = 'Quiz - ArrayList'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'ArrayList liste = new ArrayList(String);', false, 1 FROM q
UNION ALL SELECT q.id, 'String[] liste = new ArrayList<>();', false, 2 FROM q
UNION ALL SELECT q.id, 'ArrayList<String> liste = new ArrayList<>();', true, 3 FROM q
UNION ALL SELECT q.id, 'List<string> liste = new ArrayList<>();', false, 4 FROM q;
