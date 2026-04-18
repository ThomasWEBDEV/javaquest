-- V46: Lecon 3 Optional et valeurs absentes + Quiz

-- =============================================
-- LECON 3 : Optional et valeurs absentes
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Optional et valeurs absentes',
    'optional-streams-securises',
    E'OPTIONAL ET VALEURS ABSENTES\n\nEn Java, le NullPointerException est l une des erreurs les plus frequentes. Java 8 a introduit Optional<T>, un conteneur explicite pour une valeur qui peut etre absente. Plutot que de retourner null et risquer un NPE, vous retournez un Optional qui oblige l appelant a gerer l absence de valeur.\n\n---\n\nCREER UN OPTIONAL\n\nIl existe trois facons de creer un Optional :\n\n  // Contient une valeur non-nulle (leve NullPointerException si null)\n  Optional<String> a = Optional.of("Java");\n\n  // Accepte null : retourne Optional.empty() si null\n  Optional<String> b = Optional.ofNullable(null);    // vide\n  Optional<String> c = Optional.ofNullable("Java"); // contient "Java"\n\n  // Vide explicitement\n  Optional<String> d = Optional.empty();\n\nPreferez Optional.ofNullable() quand vous n etes pas certain que la valeur est non-nulle.\n\n---\n\nVERIFIER ET ACCEDER\n\n  Optional<String> opt = Optional.of("Java");\n\n  // Verifier la presence\n  if (opt.isPresent()) {\n      System.out.println(opt.get()); // Java\n  }\n  if (opt.isEmpty()) { // Java 11+\n      System.out.println("Vide");\n  }\n\n  // Acces securise\n  String r1 = opt.orElse("Defaut");                         // valeur si vide\n  String r2 = opt.orElseGet(() -> calculer());              // calcul si vide\n  String r3 = opt.orElseThrow(() -> new RuntimeException()); // exception si vide\n\nATTENTION : opt.get() sans verification lance NoSuchElementException si l Optional est vide. Preferez toujours orElse, orElseGet ou orElseThrow.\n\n---\n\nTRANSFORMER AVEC MAP ET FILTER\n\nOptional propose des methodes fonctionnelles qui ne font rien si l Optional est vide :\n\n  Optional<String> nom = Optional.of("alice");\n\n  // map() transforme la valeur et retourne un nouveau Optional\n  Optional<String> maj = nom.map(n -> n.toUpperCase());\n  System.out.println(maj.orElse("?")); // ALICE\n\n  // filter() conserve la valeur si elle repond au critere\n  Optional<String> long_ = nom.filter(n -> n.length() > 3);\n  System.out.println(long_.orElse("trop court")); // alice\n\n  // ifPresent() execute une action seulement si presente\n  nom.ifPresent(n -> System.out.println("Nom : " + n)); // Nom : alice\n\nCes methodes retournent toutes un Optional, ce qui permet le chainage.\n\n---\n\nOPTIONAL COMME VALEUR DE RETOUR\n\nLa convention est de retourner Optional quand une methode peut ne pas trouver de resultat :\n\n  // Mauvais : null est invisible pour l appelant\n  public static String trouver(int id) {\n      if (id == 1) return "Alice";\n      return null; // risque NPE !\n  }\n\n  // Bon : Optional signale explicitement l absence possible\n  public static Optional<String> trouver(int id) {\n      if (id == 1) return Optional.of("Alice");\n      return Optional.empty();\n  }\n\n  // Utilisation\n  String nom = trouver(42).orElse("Inconnu");\n  System.out.println(nom); // Inconnu\n\n  trouver(1)\n      .map(String::toUpperCase)\n      .ifPresent(n -> System.out.println("Trouve : " + n)); // Trouve : ALICE\n\n---\n\nOPTIONAL ET STREAMS\n\nfindFirst() et findAny() sur un stream retournent un Optional, car le stream peut etre vide :\n\n  import java.util.Arrays;\n  import java.util.List;\n  import java.util.Optional;\n\n  List<String> noms = Arrays.asList("Alice", "Bob", "Charlie");\n\n  Optional<String> premierB = noms.stream()\n      .filter(n -> n.startsWith("B"))\n      .findFirst();\n\n  System.out.println(premierB.orElse("Personne")); // Bob\n\n  Optional<String> premierZ = noms.stream()\n      .filter(n -> n.startsWith("Z"))\n      .findFirst();\n\n  System.out.println(premierZ.orElse("Personne")); // Personne\n\n---\n\nBONNES PRATIQUES\n\n1. Ne retournez jamais null depuis une methode publique : utilisez Optional.empty().\n2. Evitez Optional.get() sans verification : preferez orElse ou orElseThrow.\n3. Preferez orElseGet() si le calcul de la valeur par defaut est couteux.\n4. N utilisez pas Optional comme champ de classe ou parametre de methode.\n5. Utilisez Optional pour signifier explicitement qu une methode peut ne pas avoir de resultat.',
    3,
    40
FROM chapters c WHERE c.slug = 'gestion-exceptions';

-- =============================================
-- QUIZ : Optional et valeurs absentes
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Optional et valeurs absentes',
    'Testez vos connaissances sur Optional et la gestion des valeurs absentes en Java',
    300, 70, 100
FROM lessons l WHERE l.slug = 'optional-streams-securises';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode creer un Optional qui accepte une valeur null sans lever d exception ?',
        'SINGLE_CHOICE',
        'Optional.ofNullable() accepte null et retourne Optional.empty() dans ce cas. Optional.of() leve une NullPointerException si la valeur passee est null.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'optional-streams-securises'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Optional.of()', false, 1),
((SELECT id FROM q), 'Optional.ofNullable()', true, 2),
((SELECT id FROM q), 'Optional.nullable()', false, 3),
((SELECT id FROM q), 'Optional.safe()', false, 4);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que se passe-t-il si on appelle get() sur un Optional vide ?',
        'SINGLE_CHOICE',
        'Appeler get() sur un Optional vide lance une NoSuchElementException. C est pourquoi il faut toujours preferer orElse(), orElseGet() ou orElseThrow() plutot que get() direct.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'optional-streams-securises'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Retourne null', false, 1),
((SELECT id FROM q), 'Lance une NoSuchElementException', true, 2),
((SELECT id FROM q), 'Lance une NullPointerException', false, 3),
((SELECT id FROM q), 'Retourne Optional.empty()', false, 4);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode permet de fournir une valeur de remplacement si Optional est vide ?',
        'SINGLE_CHOICE',
        'orElse(T valeur) retourne la valeur contenue si presente, ou la valeur de remplacement si l Optional est vide. C est la methode la plus simple pour eviter de gerer isPresent() manuellement.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'optional-streams-securises'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'get()', false, 1),
((SELECT id FROM q), 'ifPresent()', false, 2),
((SELECT id FROM q), 'orElse()', true, 3),
((SELECT id FROM q), 'map()', false, 4);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la principale difference entre orElse() et orElseGet() ?',
        'SINGLE_CHOICE',
        'orElse(valeur) evalue toujours son argument, meme si l Optional est present. orElseGet(fournisseur) evalue le fournisseur seulement si l Optional est vide. Preferez orElseGet() si le calcul de la valeur par defaut est couteux.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'optional-streams-securises'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Il n y a aucune difference entre les deux', false, 1),
((SELECT id FROM q), 'orElse() evalue toujours son argument, orElseGet() seulement si vide', true, 2),
((SELECT id FROM q), 'orElseGet() evalue toujours son argument, orElse() seulement si vide', false, 3),
((SELECT id FROM q), 'orElse() ne fonctionne qu avec des String', false, 4);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que fait la methode map() sur un Optional ?',
        'SINGLE_CHOICE',
        'map() applique une fonction de transformation a la valeur si elle est presente et retourne un nouveau Optional contenant le resultat. Si l Optional est vide, map() retourne Optional.empty() sans appliquer la fonction.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'optional-streams-securises'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Elle verifie si l Optional est present', false, 1),
((SELECT id FROM q), 'Elle transforme la valeur si presente et retourne un nouveau Optional', true, 2),
((SELECT id FROM q), 'Elle filtre les valeurs selon un critere booleen', false, 3),
((SELECT id FROM q), 'Elle combine deux Optional en un seul', false, 4);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel type retourne Stream.findFirst() ?',
        'SINGLE_CHOICE',
        'Stream.findFirst() retourne un Optional<T> car le stream peut etre vide. Cela force l appelant a gerer explicitement le cas ou aucun element n est trouve, evitant ainsi un NullPointerException.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'optional-streams-securises'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'T (le type direct, null si vide)', false, 1),
((SELECT id FROM q), 'List<T> avec 0 ou 1 element', false, 2),
((SELECT id FROM q), 'Optional<T>', true, 3),
((SELECT id FROM q), 'Stream<T> reduit', false, 4);
