-- V53: Chapitre 7 Streams Java + Lecon 1 introduction aux streams + Quiz

-- =============================================
-- CHAPITRE 7 : Streams Java
-- =============================================

INSERT INTO chapters (title, slug, description, order_index, xp_reward, is_published)
VALUES (
    'Streams Java',
    'streams-java',
    'Maitrisez les Streams Java pour traiter des collections de donnees de facon declarative, concise et puissante',
    7,
    350,
    true
);

-- =============================================
-- LECON 1 : Introduction aux Streams
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Introduction aux Streams : filter, map, collect',
    'introduction-streams',
    E'INTRODUCTION AUX STREAMS : FILTER, MAP, COLLECT\n\nUn Stream est un pipeline de traitement de donnees qui permet de manipuler des collections de facon declarative (on dit QUOI faire, pas COMMENT). Introduits en Java 8, les Streams sont devenus indispensables pour ecrire du code concis et lisible.\n\n---\n\nLE PROBLEME AVEC LES BOUCLES CLASSIQUES\n\nAvec une boucle for classique :\n\n  List<String> prenoms = List.of("Alice", "Bob", "Charlie", "Anna", "Bruno");\n\n  // Filtrer les prenoms qui commencent par A, en majuscules\n  List<String> resultat = new ArrayList<>();\n  for (String prenom : prenoms) {\n      if (prenom.startsWith("A")) {\n          resultat.add(prenom.toUpperCase());\n      }\n  }\n  // [ALICE, ANNA]\n\nC est verbeux et melange la logique de filtrage avec la gestion de la liste resultat.\n\n---\n\nLA SOLUTION AVEC LES STREAMS\n\nLe meme code avec les Streams :\n\n  List<String> prenoms = List.of("Alice", "Bob", "Charlie", "Anna", "Bruno");\n\n  List<String> resultat = prenoms.stream()\n      .filter(p -> p.startsWith("A"))\n      .map(String::toUpperCase)\n      .collect(Collectors.toList());\n  // [ALICE, ANNA]\n\nBeaucoup plus lisible ! On lit clairement : "filtrer ceux qui commencent par A, les mettre en majuscules, collecter en liste".\n\n---\n\nCREER UN STREAM\n\nOn cree un Stream a partir de n importe quelle collection avec .stream() :\n\n  List<Integer> nombres = List.of(1, 2, 3, 4, 5);\n  Stream<Integer> stream = nombres.stream();\n\n  // Ou directement en chaine\n  nombres.stream()\n      .forEach(n -> System.out.println(n));\n  // 1  2  3  4  5\n\nOn peut aussi creer un Stream directement avec Stream.of() :\n\n  Stream<String> stream = Stream.of("Java", "Python", "C++");\n\n---\n\nFILTER : FILTRER DES ELEMENTS\n\nfilter() garde uniquement les elements qui satisfont un predicat (condition) :\n\n  List<Integer> nombres = List.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);\n\n  List<Integer> pairs = nombres.stream()\n      .filter(n -> n % 2 == 0)\n      .collect(Collectors.toList());\n  System.out.println(pairs); // [2, 4, 6, 8, 10]\n\n  // Filtrer les chaines non vides\n  List<String> mots = List.of("Java", "", "Stream", "", "API");\n  List<String> nonVides = mots.stream()\n      .filter(s -> !s.isEmpty())\n      .collect(Collectors.toList());\n  System.out.println(nonVides); // [Java, Stream, API]\n\n---\n\nMAP : TRANSFORMER DES ELEMENTS\n\nmap() transforme chaque element en appliquant une fonction :\n\n  List<String> fruits = List.of("pomme", "banane", "cerise");\n\n  // Mettre en majuscules\n  List<String> majuscules = fruits.stream()\n      .map(String::toUpperCase)\n      .collect(Collectors.toList());\n  System.out.println(majuscules); // [POMME, BANANE, CERISE]\n\n  // Obtenir la longueur de chaque mot\n  List<Integer> longueurs = fruits.stream()\n      .map(String::length)\n      .collect(Collectors.toList());\n  System.out.println(longueurs); // [5, 6, 6]\n\nmap() peut changer le type : ici on passe de Stream<String> a Stream<Integer>.\n\n---\n\nCOLLECT : TERMINER LE STREAM\n\ncollect() est une operation terminale qui materialise le Stream en une collection concrete :\n\n  // Vers une List\n  .collect(Collectors.toList())\n\n  // Vers un Set (supprime les doublons)\n  .collect(Collectors.toSet())\n\n  // Vers une chaine de caracteres\n  List<String> mots = List.of("Hello", "World", "Java");\n  String phrase = mots.stream()\n      .collect(Collectors.joining(", "));\n  System.out.println(phrase); // Hello, World, Java\n\n---\n\nCHAINER LES OPERATIONS\n\nLa vraie puissance des Streams vient du chaining : enchainder plusieurs operations :\n\n  List<String> etudiants = List.of("Alice", "Bob", "Charlie", "Anna", "Benjamin", "Carla");\n\n  // Prenoms qui commencent par A ou B, tries, en majuscules\n  List<String> resultat = etudiants.stream()\n      .filter(s -> s.startsWith("A") || s.startsWith("B"))\n      .sorted()\n      .map(String::toUpperCase)\n      .collect(Collectors.toList());\n  System.out.println(resultat); // [ALICE, ANNA, BENJAMIN, BOB]\n\n---\n\nFOREACH : PARCOURIR SANS COLLECTER\n\nSi on veut juste afficher ou traiter sans creer de nouvelle collection, forEach() suffit :\n\n  List<Integer> nombres = List.of(3, 1, 4, 1, 5, 9);\n\n  nombres.stream()\n      .filter(n -> n > 3)\n      .forEach(n -> System.out.print(n + " "));\n  // 4 5 9\n\n---\n\nBONNES PRATIQUES\n\n1. Les Streams ne modifient pas la collection source - ils creeent un nouveau flux.\n2. Un Stream ne peut etre consomme qu une seule fois : apres collect() ou forEach(), il est epuise.\n3. Preferez les references de methodes (String::toUpperCase) aux lambdas quand c est possible.\n4. Les Streams sont paresseux (lazy) : filter et map ne s executent que quand une operation terminale est appelee.',
    1,
    40
FROM chapters c WHERE c.slug = 'streams-java';

-- =============================================
-- QUIZ : Introduction aux Streams
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Introduction aux Streams',
    'Testez vos connaissances sur les Streams Java et les operations filter, map, collect',
    300, 70, 100
FROM lessons l WHERE l.slug = 'introduction-streams';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode permet de creer un Stream a partir d une List en Java ?',
        'SINGLE_CHOICE',
        'La methode .stream() est disponible sur toutes les collections Java (List, Set, etc.) et retourne un Stream pour traiter les elements de facon declarative.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'introduction-streams'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'maListe.toStream()', false, 1),
((SELECT id FROM q), 'Stream.from(maListe)', false, 2),
((SELECT id FROM q), 'maListe.stream()', true, 3),
((SELECT id FROM q), 'maListe.asStream()', false, 4);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que fait l operation filter() dans un Stream ?',
        'SINGLE_CHOICE',
        'filter() est une operation intermediaire qui conserve uniquement les elements qui satisfont le predicat (la condition booleenne) passe en argument.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'introduction-streams'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Elle transforme chaque element en appliquant une fonction', false, 1),
((SELECT id FROM q), 'Elle garde uniquement les elements qui respectent une condition', true, 2),
((SELECT id FROM q), 'Elle trie les elements dans l ordre naturel', false, 3),
((SELECT id FROM q), 'Elle supprime les doublons du Stream', false, 4);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que retourne .map(String::toUpperCase) applique sur un Stream<String> ?',
        'SINGLE_CHOICE',
        'map() transforme chaque element : ici chaque String est convertie en majuscules. Le Stream produit est toujours un Stream<String> mais avec tous les elements en majuscules.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'introduction-streams'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Un Stream<String> avec chaque element converti en majuscules', true, 1),
((SELECT id FROM q), 'Une List<String> avec chaque element converti en majuscules', false, 2),
((SELECT id FROM q), 'Un Stream<Character> avec les premiers caracteres', false, 3),
((SELECT id FROM q), 'La premiere String du Stream en majuscules', false, 4);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Parmi ces propositions, laquelle decrit correctement collect(Collectors.toList()) ?',
        'SINGLE_CHOICE',
        'collect() est une operation terminale qui materialise le Stream en une collection concrete. Collectors.toList() specifie qu on veut recuperer les elements dans une nouvelle List.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'introduction-streams'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'C est une operation intermediaire qui continue le Stream', false, 1),
((SELECT id FROM q), 'Elle filtre la liste pour ne garder que certains elements', false, 2),
((SELECT id FROM q), 'C est une operation terminale qui convertit le Stream en List', true, 3),
((SELECT id FROM q), 'Elle cree un nouveau Stream a partir d une List', false, 4);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel est le resultat de ce code ?\nList.of(1,2,3,4,5).stream().filter(n -> n > 3).collect(Collectors.toList())',
        'SINGLE_CHOICE',
        'filter(n -> n > 3) garde uniquement les elements strictement superieurs a 3. Dans la liste [1,2,3,4,5], seuls 4 et 5 satisfont cette condition.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'introduction-streams'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), '[1, 2, 3]', false, 1),
((SELECT id FROM q), '[4, 5]', true, 2),
((SELECT id FROM q), '[3, 4, 5]', false, 3),
((SELECT id FROM q), '[1, 2]', false, 4);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que se passe-t-il si on essaie d utiliser un Stream une deuxieme fois apres collect() ?',
        'SINGLE_CHOICE',
        'Un Stream Java ne peut etre consomme qu une seule fois. Une fois qu une operation terminale (collect, forEach, count, etc.) a ete appelee, le Stream est epuise et toute reutilisation lance une IllegalStateException.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'introduction-streams'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Le Stream repart depuis le debut automatiquement', false, 1),
((SELECT id FROM q), 'Le Stream retourne un resultat vide', false, 2),
((SELECT id FROM q), 'Java leve une IllegalStateException : stream already been operated upon', true, 3),
((SELECT id FROM q), 'Le Stream ignore la deuxieme operation silencieusement', false, 4);
