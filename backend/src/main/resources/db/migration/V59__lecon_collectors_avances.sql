-- V59: Lecon 4 Streams Java - Collectors avances (groupingBy, partitioningBy, joining) + Quiz

-- =============================================
-- LECON 4 : Collectors avances
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Collectors avances : groupingBy, partitioningBy, joining',
    'collectors-avances',
    E'COLLECTORS AVANCES : GROUPINGBY, PARTITIONINGBY, JOINING\n\nJusqu ici nous avons utilise Collectors.toList() et les reductions simples. Decouvrons les Collectors les plus puissants pour organiser et transformer vos donnees.\n\n---\n\nGROUPINGBY : REGROUPER PAR CRITERE\n\ngroupingBy() regroupe les elements dans une Map selon un critere :\n\n  List<String> prenoms = List.of("Alice", "Bob", "Anna", "Charlie", "Bernard", "Camille");\n\n  // Grouper par premiere lettre\n  Map<Character, List<String>> parLettre = prenoms.stream()\n      .collect(Collectors.groupingBy(p -> p.charAt(0)));\n  System.out.println(parLettre.get(\'A\')); // [Alice, Anna]\n  System.out.println(parLettre.get(\'B\')); // [Bob, Bernard]\n\n  // Grouper et compter\n  Map<Character, Long> comptesParLettre = prenoms.stream()\n      .collect(Collectors.groupingBy(p -> p.charAt(0), Collectors.counting()));\n  System.out.println(comptesParLettre.get(\'A\')); // 2\n\n  // Grouper par longueur\n  Map<Integer, List<String>> parLongueur = prenoms.stream()\n      .collect(Collectors.groupingBy(String::length));\n\n---\n\nPARTITIONINGBY : DIVISER EN DEUX GROUPES\n\npartitioningBy() divise en deux groupes (true/false) selon un predicat :\n\n  List<Integer> notes = List.of(12, 8, 15, 6, 17, 9, 14, 11, 5, 13);\n\n  // Partitionner en reussi (>=10) et echoue (<10)\n  Map<Boolean, List<Integer>> resultats = notes.stream()\n      .collect(Collectors.partitioningBy(n -> n >= 10));\n\n  List<Integer> recus = resultats.get(true);\n  List<Integer> recales = resultats.get(false);\n  System.out.println("Recus : " + recus);   // [12, 15, 17, 14, 11, 13]\n  System.out.println("Recales : " + recales); // [8, 6, 9, 5]\n\n  // Avec comptage\n  Map<Boolean, Long> comptage = notes.stream()\n      .collect(Collectors.partitioningBy(n -> n >= 10, Collectors.counting()));\n  System.out.println("Nombre de recus : " + comptage.get(true)); // 6\n\n---\n\nJOINING : ASSEMBLER DES CHAINES\n\njoining() concatene des elements en une seule chaine :\n\n  List<String> langages = List.of("Java", "Python", "Go", "Rust");\n\n  // Concatenation simple\n  String simple = langages.stream().collect(Collectors.joining());\n  System.out.println(simple); // JavaPythonGoRust\n\n  // Avec separateur\n  String avecVirgule = langages.stream().collect(Collectors.joining(", "));\n  System.out.println(avecVirgule); // Java, Python, Go, Rust\n\n  // Avec separateur, prefixe et suffixe\n  String formate = langages.stream().collect(Collectors.joining(", ", "[", "]"));\n  System.out.println(formate); // [Java, Python, Go, Rust]\n\n---\n\nTOMAP : CREER UNE MAP DIRECTEMENT\n\ntoMap() transforme un Stream en Map avec une cle et une valeur :\n\n  List<String> mots = List.of("Java", "Python", "Go");\n\n  // Creer une map mot -> longueur\n  Map<String, Integer> longueurs = mots.stream()\n      .collect(Collectors.toMap(m -> m, String::length));\n  System.out.println(longueurs.get("Java")); // 4\n  System.out.println(longueurs.get("Python")); // 6\n\n---\n\nCOMBINER LES COLLECTORS\n\nLes Collectors se combinent pour des analyses puissantes :\n\n  List<String> prenoms = List.of("Alice", "Bob", "Anna", "Charlie", "Bernard", "Camille");\n\n  // Grouper par premiere lettre ET trier chaque groupe\n  Map<Character, List<String>> groupesTries = prenoms.stream()\n      .collect(Collectors.groupingBy(\n          p -> p.charAt(0),\n          Collectors.collectingAndThen(\n              Collectors.toList(),\n              list -> list.stream().sorted().collect(Collectors.toList())\n          )\n      ));\n\n  // Grouper par longueur et joindre les noms\n  Map<Integer, String> nomsParlongueur = prenoms.stream()\n      .collect(Collectors.groupingBy(String::length, Collectors.joining(", ")));\n  System.out.println(nomsParlongueur.get(3)); // Bob\n\n---\n\nBONNES PRATIQUES\n\n1. Utilisez groupingBy() quand vous voulez organiser par categories multiples.\n2. Preferez partitioningBy() a groupingBy() quand il n y a que deux groupes (true/false).\n3. joining() est ideal pour formater des listes en chaines lisibles.\n4. toMap() necessite des cles uniques, sinon il leve une IllegalStateException.',
    4,
    45
FROM chapters c WHERE c.slug = 'streams-java';

-- =============================================
-- QUIZ : Collectors avances
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Collectors avances',
    'Testez vos connaissances sur groupingBy, partitioningBy, joining et toMap',
    300, 70, 100
FROM lessons l WHERE l.slug = 'collectors-avances';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que retourne Collectors.groupingBy(p -> p.charAt(0)) applique a une List<String> ?',
        'SINGLE_CHOICE',
        'groupingBy() retourne une Map dont les cles sont le critere de groupement et les valeurs sont des listes des elements correspondants.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'collectors-avances'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Map<Character, List<String>>', true, 1),
    ('List<Map<String, Object>>', false, 2),
    ('Map<String, String>', false, 3),
    ('Set<Character>', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la difference entre groupingBy() et partitioningBy() ?',
        'SINGLE_CHOICE',
        'partitioningBy() utilise un predicat et retourne toujours une Map<Boolean, List<T>> avec deux entrees. groupingBy() retourne une Map<K, List<T>> avec autant de cles que de valeurs distinctes du critere.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'collectors-avances'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Il n y a aucune difference', false, 1),
    ('partitioningBy() cree toujours exactement deux groupes (true/false), groupingBy() peut creer autant de groupes que necessaire', true, 2),
    ('groupingBy() est plus rapide que partitioningBy()', false, 3),
    ('partitioningBy() retourne une List, groupingBy() une Map', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que produit List.of("Java", "Go", "Rust").stream().collect(Collectors.joining(", ", "[", "]")) ?',
        'SINGLE_CHOICE',
        'joining(separateur, prefixe, suffixe) concatene les elements avec le separateur, entoure du prefixe et du suffixe.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'collectors-avances'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Java, Go, Rust', false, 1),
    ('[Java, Go, Rust]', true, 2),
    ('[Java], [Go], [Rust]', false, 3),
    ('Java Go Rust', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment compter le nombre d elements dans chaque groupe avec groupingBy() ?',
        'SINGLE_CHOICE',
        'Le deuxieme argument de groupingBy() est un downstream Collector. Collectors.counting() est un Collector qui compte les elements de chaque groupe.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'collectors-avances'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Collectors.groupingBy(critere, Collectors.counting())', true, 1),
    ('Collectors.groupingBy(critere).count()', false, 2),
    ('Collectors.groupingBy(critere, Collectors.size())', false, 3),
    ('Collectors.countingBy(critere)', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Vous avez List<Integer> notes = List.of(12, 8, 15, 6). Quel code separe correctement les notes >= 10 des notes < 10 ?',
        'SINGLE_CHOICE',
        'partitioningBy() est ideal pour diviser en deux groupes selon un predicat. Il retourne Map<Boolean, List<Integer>> avec true pour les notes >= 10 et false pour les autres.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'collectors-avances'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('notes.stream().collect(Collectors.groupingBy(n -> n >= 10))', false, 1),
    ('notes.stream().collect(Collectors.partitioningBy(n -> n >= 10))', true, 2),
    ('notes.stream().filter(n -> n >= 10).collect(Collectors.toList())', false, 3),
    ('notes.stream().collect(Collectors.toMap(n -> n >= 10, n -> n))', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que se passe-t-il si toMap() rencontre deux elements avec la meme cle ?',
        'SINGLE_CHOICE',
        'Par defaut, toMap() leve une IllegalStateException en cas de cles dupliquees. Pour gerer ce cas, il faut fournir un troisieme argument mergeFunction : Collectors.toMap(cle, valeur, (v1, v2) -> v1).',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'collectors-avances'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Il garde le premier element', false, 1),
    ('Il garde le dernier element', false, 2),
    ('Il leve une IllegalStateException', true, 3),
    ('Il cree une liste pour les doublons', false, 4)
) AS opt(text, is_correct, order_index);
