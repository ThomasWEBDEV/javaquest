-- V55: Lecon 2 Streams Java - Reduction et agregation + Quiz

-- =============================================
-- LECON 2 : Reduction et agregation
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Reduction et agregation : count, sum, min, max, reduce',
    'streams-reduction-agregation',
    E'REDUCTION ET AGREGATION AVEC LES STREAMS\n\nApres avoir filtre et transforme des donnees avec filter() et map(), il faut souvent les reduire a une seule valeur : compter, additionner, trouver le min ou le max. C est le role des operations terminales de reduction.\n\n---\n\nCOUNT : COMPTER LES ELEMENTS\n\ncount() retourne le nombre d elements dans le Stream :\n\n  List<String> prenoms = List.of("Alice", "Bob", "Charlie", "Anna", "Bruno");\n\n  // Compter tous les elements\n  long total = prenoms.stream().count();\n  System.out.println(total); // 5\n\n  // Compter ceux qui commencent par A\n  long nbA = prenoms.stream()\n      .filter(p -> p.startsWith("A"))\n      .count();\n  System.out.println(nbA); // 2\n\nAttention : count() retourne un long, pas un int.\n\n---\n\nSUM, MIN, MAX SUR DES NOMBRES\n\nPour les Stream<Integer>, on utilise mapToInt() pour obtenir un IntStream qui offre sum(), min(), max(), average() :\n\n  List<Integer> notes = List.of(12, 8, 15, 6, 18, 11);\n\n  int somme = notes.stream()\n      .mapToInt(Integer::intValue)\n      .sum();\n  System.out.println(somme); // 70\n\n  int max = notes.stream()\n      .mapToInt(Integer::intValue)\n      .max()\n      .getAsInt();\n  System.out.println(max); // 18\n\n  int min = notes.stream()\n      .mapToInt(Integer::intValue)\n      .min()\n      .getAsInt();\n  System.out.println(min); // 6\n\n  double moyenne = notes.stream()\n      .mapToInt(Integer::intValue)\n      .average()\n      .getAsDouble();\n  System.out.printf("%.2f%n", moyenne); // 11.67\n\nmax() et min() retournent un OptionalInt car le Stream pourrait etre vide.\n\n---\n\nFINDFIRST ET FINDANY\n\nfindFirst() retourne le premier element du Stream (si present) :\n\n  List<String> prenoms = List.of("Alice", "Bob", "Charlie", "Anna");\n\n  Optional<String> premier = prenoms.stream()\n      .filter(p -> p.startsWith("A"))\n      .findFirst();\n\n  if (premier.isPresent()) {\n      System.out.println(premier.get()); // Alice\n  }\n\n  // Avec orElse pour une valeur par defaut\n  String nom = prenoms.stream()\n      .filter(p -> p.startsWith("Z"))\n      .findFirst()\n      .orElse("Inconnu");\n  System.out.println(nom); // Inconnu\n\n---\n\nANYMATCH, ALLmatch, NONEMATCH\n\nCes methodes testent si des elements satisfont une condition :\n\n  List<Integer> notes = List.of(12, 8, 15, 6, 18, 11);\n\n  // Au moins une note >= 15 ?\n  boolean excellent = notes.stream().anyMatch(n -> n >= 15);\n  System.out.println(excellent); // true\n\n  // Toutes les notes >= 5 ?\n  boolean toutesValides = notes.stream().allMatch(n -> n >= 5);\n  System.out.println(toutesValides); // true\n\n  // Aucune note negative ?\n  boolean sansNegatif = notes.stream().noneMatch(n -> n < 0);\n  System.out.println(sansNegatif); // true\n\nCes methodes court-circuitent : elles s arretent des qu elles ont la reponse.\n\n---\n\nREDUCE : REDUCTION PERSONNALISEE\n\nreduce() permet de combiner tous les elements avec une operation binaire :\n\n  List<Integer> nombres = List.of(1, 2, 3, 4, 5);\n\n  // Additionner tous les elements\n  int somme = nombres.stream()\n      .reduce(0, (a, b) -> a + b);\n  System.out.println(somme); // 15\n\n  // Multiplier tous les elements\n  int produit = nombres.stream()\n      .reduce(1, (a, b) -> a * b);\n  System.out.println(produit); // 120\n\n  // Avec reference de methode\n  int somme2 = nombres.stream()\n      .reduce(0, Integer::sum);\n  System.out.println(somme2); // 15\n\nLe premier argument est la valeur initiale (identite de l operation).\n\n---\n\nMIN ET MAX AVEC COMPARATOR\n\nPour des objets complexes, on utilise min() et max() avec un Comparator :\n\n  List<String> prenoms = List.of("Alice", "Bob", "Charlie", "Eva");\n\n  // Le prenom le plus long\n  String plusLong = prenoms.stream()\n      .max(Comparator.comparingInt(String::length))\n      .orElse("");\n  System.out.println(plusLong); // Charlie\n\n  // Le prenom alphabetiquement le plus petit\n  String premier = prenoms.stream()\n      .min(Comparator.naturalOrder())\n      .orElse("");\n  System.out.println(premier); // Alice\n\n---\n\nSTATISTIQUES AVEC SUMMARIZINGINT\n\nPour obtenir toutes les statistiques en une seule passe :\n\n  List<Integer> notes = List.of(12, 8, 15, 6, 18, 11);\n\n  IntSummaryStatistics stats = notes.stream()\n      .collect(Collectors.summarizingInt(Integer::intValue));\n\n  System.out.println("Nombre : " + stats.getCount());   // 6\n  System.out.println("Somme : " + stats.getSum());       // 70\n  System.out.println("Min : " + stats.getMin());         // 6\n  System.out.println("Max : " + stats.getMax());         // 18\n  System.out.printf("Moyenne : %.2f%n", stats.getAverage()); // 11.67\n\n---\n\nBONNES PRATIQUES\n\n1. Preferez mapToInt/mapToLong/mapToDouble a map() quand vous faites des calculs numeriques : plus efficace.\n2. anyMatch/allMatch/noneMatch sont plus lisibles que count() > 0 ou count() == size.\n3. reduce() est tres flexible mais sum()/count() sont plus expressifs pour les cas courants.\n4. Pensez toujours a gerer le cas vide avec Optional.orElse() ou Optional.orElseThrow().',
    2,
    40
FROM chapters c WHERE c.slug = 'streams-java';

-- =============================================
-- QUIZ : Reduction et agregation
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Reduction et agregation',
    'Testez vos connaissances sur les operations de reduction des Streams Java',
    300, 70, 100
FROM lessons l WHERE l.slug = 'streams-reduction-agregation';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel type retourne la methode count() d un Stream ?',
        'SINGLE_CHOICE',
        'count() retourne un long (et non un int) pour pouvoir compter de tres grandes collections sans debordement.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'streams-reduction-agregation'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('int', false, 1),
    ('long', true, 2),
    ('Integer', false, 3),
    ('double', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode doit-on appeler avant sum() pour additionner une List<Integer> ?',
        'SINGLE_CHOICE',
        'mapToInt() convertit un Stream<Integer> en IntStream primitif, qui propose directement sum(), min(), max(), average(). Sans cela, ces methodes ne sont pas disponibles.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'streams-reduction-agregation'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('toInt()', false, 1),
    ('mapToInt()', true, 2),
    ('asInt()', false, 3),
    ('intStream()', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode verifie qu au moins un element satisfait une condition ?',
        'SINGLE_CHOICE',
        'anyMatch() retourne true si au moins un element du Stream satisfait le predicat. Elle court-circuite : elle s arrete des qu elle trouve un element valide.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'streams-reduction-agregation'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('allMatch()', false, 1),
    ('anyMatch()', true, 2),
    ('noneMatch()', false, 3),
    ('findFirst()', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel est le resultat de : List.of(1,2,3,4,5).stream().reduce(0, (a,b) -> a+b) ?',
        'SINGLE_CHOICE',
        'reduce(0, (a,b) -> a+b) additionne tous les elements en partant de 0 : 0+1=1, 1+2=3, 3+3=6, 6+4=10, 10+5=15.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'streams-reduction-agregation'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('0', false, 1),
    ('15', true, 2),
    ('120', false, 3),
    ('5', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que retourne findFirst() sur un Stream vide ?',
        'SINGLE_CHOICE',
        'findFirst() retourne un Optional<T>. Sur un Stream vide, il retourne Optional.empty(). C est pourquoi on utilise .orElse() ou .isPresent() avant d appeler .get().',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'streams-reduction-agregation'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('null', false, 1),
    ('Optional.empty()', true, 2),
    ('Une exception NullPointerException', false, 3),
    ('0', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle classe fournit des statistiques completes (count, sum, min, max, average) en une seule passe ?',
        'SINGLE_CHOICE',
        'IntSummaryStatistics est retourne par Collectors.summarizingInt(). Il calcule count, sum, min, max et average en une seule traversee du Stream, ce qui est tres efficace.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'streams-reduction-agregation'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('StreamStatistics', false, 1),
    ('IntSummaryStatistics', true, 2),
    ('NumberCollector', false, 3),
    ('StreamMetrics', false, 4)
) AS opt(text, is_correct, order_index);
