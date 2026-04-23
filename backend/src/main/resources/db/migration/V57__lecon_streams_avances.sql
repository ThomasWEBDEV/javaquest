-- V57: Lecon 3 Streams Java - Streams avances (flatMap, distinct, limit, skip) + Quiz

-- =============================================
-- LECON 3 : Streams avances
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Streams avances : flatMap, distinct, limit, skip',
    'streams-avances',
    E'STREAMS AVANCES : FLATMAP, DISTINCT, LIMIT, SKIP\n\nApres les bases (filter, map, collect) et la reduction (count, sum, reduce), decouvrons les operations avancees qui rendent les Streams encore plus puissants.\n\n---\n\nDISTINCT : SUPPRIMER LES DOUBLONS\n\ndistinct() elimine les elements dupliques (utilise equals() en interne) :\n\n  List<Integer> nombres = List.of(1, 2, 2, 3, 3, 3, 4, 5, 5);\n\n  List<Integer> uniques = nombres.stream()\n      .distinct()\n      .collect(Collectors.toList());\n  System.out.println(uniques); // [1, 2, 3, 4, 5]\n\n  // Compter les valeurs distinctes\n  long nbDistincts = nombres.stream().distinct().count();\n  System.out.println(nbDistincts); // 5\n\n---\n\nSORTED : TRIER LES ELEMENTS\n\nsorted() trie dans l ordre naturel, sorted(Comparator) trie selon un critere :\n\n  List<String> prenoms = List.of("Charlie", "Alice", "Bob", "Diana");\n\n  // Tri alphabetique\n  List<String> triAlpha = prenoms.stream()\n      .sorted()\n      .collect(Collectors.toList());\n  System.out.println(triAlpha); // [Alice, Bob, Charlie, Diana]\n\n  // Tri par longueur de nom\n  List<String> triLongueur = prenoms.stream()\n      .sorted(Comparator.comparingInt(String::length))\n      .collect(Collectors.toList());\n  System.out.println(triLongueur); // [Bob, Alice, Diana, Charlie]\n\n  // Tri inverse\n  List<String> triInverse = prenoms.stream()\n      .sorted(Comparator.reverseOrder())\n      .collect(Collectors.toList());\n  System.out.println(triInverse); // [Diana, Charlie, Bob, Alice]\n\n---\n\nLIMIT : PRENDRE LES N PREMIERS\n\nlimit(n) garde au maximum n elements (operation court-circuitante) :\n\n  List<Integer> nombres = List.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);\n\n  // Les 3 premiers\n  List<Integer> trois = nombres.stream()\n      .limit(3)\n      .collect(Collectors.toList());\n  System.out.println(trois); // [1, 2, 3]\n\n  // Les 3 plus grandes notes\n  List<Integer> notes = List.of(12, 8, 17, 15, 9, 14);\n  List<Integer> top3 = notes.stream()\n      .sorted(Comparator.reverseOrder())\n      .limit(3)\n      .collect(Collectors.toList());\n  System.out.println(top3); // [17, 15, 14]\n\n---\n\nSKIP : IGNORER LES N PREMIERS\n\nskip(n) ignore les n premiers elements :\n\n  List<Integer> nombres = List.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);\n\n  // Ignorer les 3 premiers\n  List<Integer> sansDebut = nombres.stream()\n      .skip(3)\n      .collect(Collectors.toList());\n  System.out.println(sansDebut); // [4, 5, 6, 7, 8, 9, 10]\n\n  // Pagination : page 2, 3 elements par page\n  int page = 2;\n  int taille = 3;\n  List<Integer> page2 = nombres.stream()\n      .skip((long)(page - 1) * taille)\n      .limit(taille)\n      .collect(Collectors.toList());\n  System.out.println(page2); // [4, 5, 6]\n\n---\n\nFLATMAP : APLATIR DES STREAMS IMBRIQUES\n\nflatMap() est l operation la plus puissante : elle transforme chaque element en un Stream, puis aplati tous ces Streams en un seul.\n\nUtilisee quand chaque element est lui-meme une collection :\n\n  List<List<Integer>> groupes = List.of(\n      List.of(1, 2, 3),\n      List.of(4, 5),\n      List.of(6, 7, 8, 9)\n  );\n\n  // map() donnerait Stream<List<Integer>>\n  // flatMap() donne Stream<Integer>\n  List<Integer> tous = groupes.stream()\n      .flatMap(List::stream)\n      .collect(Collectors.toList());\n  System.out.println(tous); // [1, 2, 3, 4, 5, 6, 7, 8, 9]\n\nAutre exemple : extraire tous les mots de plusieurs phrases :\n\n  List<String> phrases = List.of(\n      "Java est puissant",\n      "les Streams sont pratiques",\n      "flatMap est utile"\n  );\n\n  List<String> mots = phrases.stream()\n      .flatMap(phrase -> Arrays.stream(phrase.split(" ")))\n      .collect(Collectors.toList());\n  System.out.println(mots.size()); // 9\n  System.out.println(mots.get(0)); // Java\n\n---\n\nCOMBINER LES OPERATIONS\n\nLa vraie puissance vient de la combinaison de toutes ces operations :\n\n  List<String> phrases = List.of(\n      "Java est super",\n      "Java est puissant",\n      "Python est simple"\n  );\n\n  // Tous les mots distincts de plus de 4 lettres, tries\n  List<String> motsCles = phrases.stream()\n      .flatMap(p -> Arrays.stream(p.split(" ")))\n      .filter(m -> m.length() > 4)\n      .distinct()\n      .sorted()\n      .collect(Collectors.toList());\n  System.out.println(motsCles); // [Python, puissant, simple, super]\n\n---\n\nPEEK : INSPECTER SANS MODIFIER\n\npeek() permet d observer les elements sans les modifier, utile pour le debogage :\n\n  List<Integer> notes = List.of(8, 15, 6, 12, 18);\n\n  List<Integer> resultat = notes.stream()\n      .peek(n -> System.out.println("Avant filter: " + n))\n      .filter(n -> n >= 10)\n      .peek(n -> System.out.println("Apres filter: " + n))\n      .collect(Collectors.toList());\n\npeek() ne doit pas etre utilise en production pour des effets de bord, uniquement pour le debogage.\n\n---\n\nBONNES PRATIQUES\n\n1. distinct() avant sorted() pour eviter de trier des doublons inutilement.\n2. limit() avant les operations couteuses quand on n a besoin que des premiers resultats.\n3. flatMap() est ideal pour "aplatir" des structures imbriquees comme List<List<T>>.\n4. L ordre des operations compte : filter() tot dans le pipeline reduit le nombre d elements traites par les operations suivantes.',
    3,
    40
FROM chapters c WHERE c.slug = 'streams-java';

-- =============================================
-- QUIZ : Streams avances
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Streams avances',
    'Testez vos connaissances sur flatMap, distinct, limit, skip et sorted',
    300, 70, 100
FROM lessons l WHERE l.slug = 'streams-avances';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle operation supprime les elements dupliques dans un Stream ?',
        'SINGLE_CHOICE',
        'distinct() utilise la methode equals() pour identifier et supprimer les doublons. Elle retourne un Stream ne contenant que des elements uniques.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'streams-avances'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('unique()', false, 1),
    ('distinct()', true, 2),
    ('deduplicate()', false, 3),
    ('noDuplicates()', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que fait flatMap() par rapport a map() ?',
        'SINGLE_CHOICE',
        'flatMap() transforme chaque element en un Stream, puis aplati tous ces Streams en un seul Stream. map() produirait un Stream<Stream<T>>, alors que flatMap() produit directement un Stream<T>.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'streams-avances'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('flatMap() est identique a map() mais plus rapide', false, 1),
    ('flatMap() transforme et aplati les Streams imbriques en un seul Stream', true, 2),
    ('flatMap() filtre les elements nuls', false, 3),
    ('flatMap() cree un Stream bidimensionnel', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment implementer la pagination (page 3, 4 elements par page) avec les Streams ?',
        'SINGLE_CHOICE',
        'Pour la page 3 avec 4 elements par page, on saute (3-1)*4 = 8 elements avec skip(8), puis on prend 4 elements avec limit(4).',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'streams-avances'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('.limit(4).skip(8)', false, 1),
    ('.skip(8).limit(4)', true, 2),
    ('.page(3).size(4)', false, 3),
    ('.skip(12).limit(4)', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel est le resultat de List.of(1,2,2,3,3,3).stream().distinct().count() ?',
        'SINGLE_CHOICE',
        'distinct() supprime les doublons : on obtient [1, 2, 3]. count() retourne alors 3.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'streams-avances'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('6', false, 1),
    ('3', true, 2),
    ('1', false, 3),
    ('2', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'A quoi sert peek() dans un pipeline de Stream ?',
        'SINGLE_CHOICE',
        'peek() est une operation intermediaire qui permet d observer les elements (par exemple pour les logger) sans les modifier. Elle est principalement utilisee pour le debogage.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'streams-avances'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Trier les elements', false, 1),
    ('Observer les elements sans les modifier, utile pour deboguer', true, 2),
    ('Filtrer les elements nuls', false, 3),
    ('Terminer le Stream et retourner une valeur', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Dans quel ordre faut-il appeler sorted() et distinct() pour optimiser les performances ?',
        'SINGLE_CHOICE',
        'Il est preferable d appeler distinct() avant sorted(). Ainsi on reduit le nombre d elements avant de faire le tri, qui est une operation couteuse O(n log n).',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'streams-avances'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('sorted() puis distinct()', false, 1),
    ('distinct() puis sorted()', true, 2),
    ('L ordre n a aucune importance', false, 3),
    ('Il faut toujours utiliser sorted() en dernier', false, 4)
) AS opt(text, is_correct, order_index);
