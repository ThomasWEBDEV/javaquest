-- V35: Lecon 3 HashSet + Quiz

-- =============================================
-- LECON 3 : HashSet
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'HashSet : ensembles sans doublons',
    'hashset',
    E'HASHSET EN JAVA : ENSEMBLES SANS DOUBLONS\n\nArrayList conserve l ordre et accepte les doublons. HashMap stocke des paires cle-valeur. HashSet stocke des elements UNIQUES sans ordre garanti. Il est ideal quand vous voulez savoir si un element est present, sans vous soucier de l ordre.\n\n---\n\nCREER UN HASHSET\n\nLa declaration utilise un seul type generique : le type des elements :\n\n  import java.util.HashSet;\n\n  HashSet<String> prenoms = new HashSet<>();\n  HashSet<Integer> nombres = new HashSet<>();\n  HashSet<Double> prix = new HashSet<>();\n\n---\n\nAJOUTER DES ELEMENTS\n\n  HashSet<String> couleurs = new HashSet<>();\n\n  couleurs.add("Rouge");\n  couleurs.add("Vert");\n  couleurs.add("Bleu");\n  couleurs.add("Rouge"); // Doublon ignore !\n  couleurs.add("Vert");  // Doublon ignore !\n\n  System.out.println(couleurs.size()); // 3 (pas 5)\n\nadd() retourne true si l element a ete ajoute, false si c etait un doublon :\n\n  boolean ajoute = couleurs.add("Jaune"); // true\n  boolean doublon = couleurs.add("Rouge"); // false (deja present)\n\n---\n\nVERIFIER ET SUPPRIMER\n\n  HashSet<String> langages = new HashSet<>();\n  langages.add("Java");\n  langages.add("Python");\n  langages.add("JavaScript");\n\n  // Verifier la presence\n  System.out.println(langages.contains("Java"));   // true\n  System.out.println(langages.contains("C++"));    // false\n\n  // Supprimer un element\n  langages.remove("Python");\n  System.out.println(langages.size()); // 2\n\n  // Vider le set\n  langages.clear();\n  System.out.println(langages.size()); // 0\n\n---\n\nPARCOURIR UN HASHSET\n\nLa boucle for-each fonctionne comme avec ArrayList :\n\n  HashSet<String> pays = new HashSet<>();\n  pays.add("France");\n  pays.add("Espagne");\n  pays.add("Italie");\n\n  for (String p : pays) {\n      System.out.println(p);\n  }\n\nATTENTION : HashSet ne garantit pas l ordre d affichage. L ordre peut changer a chaque execution. Si l ordre est important, utilisez ArrayList a la place.\n\n---\n\nCAS D USAGE : ELIMINER LES DOUBLONS\n\nHashSet est la solution parfaite pour eliminer les doublons d une liste :\n\n  ArrayList<String> villes = new ArrayList<>();\n  villes.add("Paris");\n  villes.add("Lyon");\n  villes.add("Paris");    // doublon\n  villes.add("Marseille");\n  villes.add("Lyon");     // doublon\n\n  HashSet<String> villesUniques = new HashSet<>(villes);\n  System.out.println("Total : " + villes.size());          // 5\n  System.out.println("Uniques : " + villesUniques.size()); // 3\n\n---\n\nCAS D USAGE : TESTER L APPARTENANCE\n\ncontains() dans un HashSet est O(1) : quasi instantane, meme avec des millions d elements.\ncontains() dans une ArrayList est O(n) : parcourt tous les elements un par un.\n\n  HashSet<String> bannis = new HashSet<>();\n  bannis.add("spammer42");\n  bannis.add("hacker99");\n  bannis.add("troll007");\n\n  String utilisateur = "alice";\n  if (bannis.contains(utilisateur)) {\n      System.out.println("Acces refuse");\n  } else {\n      System.out.println("Bienvenue " + utilisateur);\n  }\n  // Bienvenue alice\n\n---\n\nARRAYLIST vs HASHMAP vs HASHSET\n\nArrayList :\n  - Liste ordonnee avec doublons autorises\n  - Acces par index : liste.get(0)\n  - Usage : sequence d elements, ordre important\n\nHashMap :\n  - Paires cle-valeur uniques\n  - Acces par cle : map.get("nom")\n  - Usage : associations, comptages, recherche rapide par identifiant\n\nHashSet :\n  - Ensemble d elements uniques\n  - Test d appartenance : set.contains("x")\n  - Usage : eliminer les doublons, verifier la presence d un element\n\nBravo ! Vous maitrisez maintenant les trois collections fondamentales de Java !',
    3,
    40
FROM chapters c WHERE c.slug = 'collections-java';

-- =============================================
-- QUIZ : HashSet
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - HashSet',
    'Testez vos connaissances sur les ensembles sans doublons avec HashSet',
    300, 70, 100
FROM lessons l WHERE l.slug = 'hashset';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle affirmation decrit correctement un HashSet ?',
        'SINGLE_CHOICE',
        'Un HashSet est une collection qui n autorise pas les doublons et ne garantit pas l ordre des elements.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'hashset'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Il permet les doublons et garantit l ordre d insertion', false, 1),
((SELECT id FROM q), 'Il stocke des paires cle-valeur comme une HashMap', false, 2),
((SELECT id FROM q), 'Il refuse les doublons et ne garantit pas l ordre', true, 3),
((SELECT id FROM q), 'Il est identique a ArrayList mais plus rapide', false, 4);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode ajoute un element dans un HashSet ?',
        'SINGLE_CHOICE',
        'La methode add() est utilisee pour ajouter un element dans un HashSet. put() est reservee a HashMap.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'hashset'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'put("element")', false, 1),
((SELECT id FROM q), 'add("element")', true, 2),
((SELECT id FROM q), 'insert("element")', false, 3),
((SELECT id FROM q), 'append("element")', false, 4);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que retourne add() si l element existe deja dans le HashSet ?',
        'SINGLE_CHOICE',
        'add() retourne false si l element etait deja present (doublon ignore), et true si l element a bien ete ajoute.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'hashset'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Une exception est levee', false, 1),
((SELECT id FROM q), 'true', false, 2),
((SELECT id FROM q), 'null', false, 3),
((SELECT id FROM q), 'false', true, 4);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment verifier si un HashSet contient un element specifique ?',
        'SINGLE_CHOICE',
        'La methode contains() permet de verifier la presence d un element dans un HashSet. Elle retourne true ou false.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'hashset'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'monSet.has("element")', false, 1),
((SELECT id FROM q), 'monSet.exists("element")', false, 2),
((SELECT id FROM q), 'monSet.contains("element")', true, 3),
((SELECT id FROM q), 'monSet.get("element")', false, 4);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la principale difference entre ArrayList et HashSet ?',
        'SINGLE_CHOICE',
        'ArrayList autorise les doublons et conserve l ordre d insertion. HashSet interdit les doublons et ne garantit pas l ordre.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'hashset'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'ArrayList est toujours plus rapide que HashSet', false, 1),
((SELECT id FROM q), 'HashSet interdit les doublons, ArrayList les autorise', true, 2),
((SELECT id FROM q), 'HashSet peut contenir des types primitifs comme int', false, 3),
((SELECT id FROM q), 'ArrayList ne peut pas etre parcouru avec for-each', false, 4);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la complexite de contains() dans un HashSet ?',
        'SINGLE_CHOICE',
        'contains() dans un HashSet est O(1) : le temps de recherche est quasi constant quelle que soit la taille du set, grace au hachage.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'hashset'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'O(n) - parcours de tous les elements', false, 1),
((SELECT id FROM q), 'O(log n) - recherche dichotomique', false, 2),
((SELECT id FROM q), 'O(n2) - comparaison de tous les couples', false, 3),
((SELECT id FROM q), 'O(1) - acces quasi instantane grace au hachage', true, 4);
