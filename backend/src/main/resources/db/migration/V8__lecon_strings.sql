-- V8: Nouvelle lecon Strings dans le chapitre Variables et Types + QCMs

-- =============================================
-- INSERTION DE LA LECON STRINGS
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Les Strings',
    'strings',
    E'LES STRINGS EN JAVA\n\nEn Java, String n est pas un type primitif : c est un objet de la classe java.lang.String. Cette distinction a des consequences importantes sur la facon de l utiliser.\n\n---\n\nCREATION D UNE STRING\n\nDeux facons de creer une String :\n\n  // Litterale (recommande) - utilise le pool de constantes\n  String prenom = "Alice";\n  String vide = "";\n\n  // Via le constructeur (rarement necessaire)\n  String s = new String("Alice");\n\nPour les chaines sur plusieurs lignes, Java 15+ propose les text blocks :\n\n  String json = """\n      {\n          "nom": "Alice",\n          "age": 30\n      }\n      """;\n\n---\n\nIMMUTABILITE : LE CONCEPT CLE\n\nUne String en Java est IMMUTABLE : une fois creee, sa valeur ne peut jamais changer.\nToutes les methodes de String retournent une NOUVELLE String sans modifier l originale.\n\n  String s = "bonjour";\n  s.toUpperCase();              // ne modifie PAS s !\n  System.out.println(s);       // affiche toujours "bonjour"\n\n  String majuscule = s.toUpperCase();  // correct : on recupere la nouvelle String\n  System.out.println(majuscule);       // affiche "BONJOUR"\n\nPourquoi cette conception ? L immutabilite rend les Strings thread-safe et permet\na la JVM d optimiser la memoire via le String Pool.\n\n---\n\nMETHODES ESSENTIELLES\n\n  length() : nombre de caracteres\n    String mot = "Java";\n    int taille = mot.length();   // 4\n\n  charAt(index) : caractere a la position donnee (commence a 0)\n    char premier = mot.charAt(0);       // ''J''\n    char dernier = mot.charAt(mot.length() - 1);   // ''a''\n\n  substring(debut) / substring(debut, fin) : extraire une sous-chaine\n    String texte = "Bonjour monde";\n    String partie = texte.substring(8);      // "monde"\n    String bout   = texte.substring(0, 7);   // "Bonjour"\n\n  indexOf(str) : position de la premiere occurrence (-1 si absent)\n    int pos = texte.indexOf("monde");   // 8\n\n  contains(str) : verifie si la sous-chaine est presente\n    boolean present = texte.contains("jour");   // true\n\n  toUpperCase() / toLowerCase() : changer la casse\n    "hello".toUpperCase()   // "HELLO"\n    "WORLD".toLowerCase()   // "world"\n\n  trim() : supprimer les espaces en debut et fin\n    "  Alice  ".trim()   // "Alice"\n\n  replace(ancien, nouveau) : remplacer des occurrences\n    "aaabbb".replace("a", "x")   // "xxxbbb"\n\n  split(separateur) : decouper en tableau\n    String[] mots = "un,deux,trois".split(",");   // ["un", "deux", "trois"]\n\n  startsWith(prefix) / endsWith(suffix)\n    "JavaQuest".startsWith("Java")   // true\n    "JavaQuest".endsWith("est")      // true\n\n---\n\nEGALS VS == : LE PIEGE CLASSIQUE\n\nC est l erreur la plus frequente avec les Strings en Java !\n\n  String a = "bonjour";\n  String b = "bonjour";\n  String c = new String("bonjour");\n\n  System.out.println(a == b);         // true  (meme reference dans le pool)\n  System.out.println(a == c);         // false (objets differents en memoire)\n  System.out.println(a.equals(c));    // true  (meme contenu)\n\nRegle absolue : toujours utiliser .equals() pour comparer le contenu de deux Strings.\nL operateur == compare les references memoire, pas les valeurs.\n\n  // Comparaison insensible a la casse\n  "Java".equalsIgnoreCase("java")   // true\n\n---\n\nCONCATENATION ET FORMATAGE\n\n  Avec l operateur + (simple mais inefficace en boucle)\n    String message = "Bonjour " + prenom + ", vous avez " + age + " ans.";\n\n  Avec String.format() (style printf)\n    String msg = String.format("Bonjour %s, vous avez %d ans.", prenom, age);\n    // %s pour String, %d pour entier, %f pour decimal, %.2f pour 2 decimales\n\n  Avec formatted() depuis Java 15\n    String msg = "Bonjour %s, vous avez %d ans.".formatted(prenom, age);\n\n---\n\nSTRINGBUILDER : CONCATENATION PERFORMANTE\n\nQuand on concatene beaucoup de Strings en boucle, chaque + cree un nouvel objet\nen memoire. StringBuilder est bien plus efficace car il modifie un seul buffer interne.\n\n  StringBuilder sb = new StringBuilder();\n  for (int i = 1; i <= 5; i++) {\n      sb.append("element ").append(i).append("\\n");\n  }\n  String resultat = sb.toString();\n\nMethodes utiles de StringBuilder :\n  append(valeur)        : ajoute a la fin\n  insert(index, valeur) : insere a une position\n  delete(debut, fin)    : supprime une portion\n  reverse()             : inverse la chaine\n  toString()            : convertit en String\n\n---\n\nCONVERSION STRING <-> TYPES PRIMITIFS\n\n  int vers String\n    String s = String.valueOf(42);     // "42"\n    String s = Integer.toString(42);   // "42"\n\n  String vers int\n    int n = Integer.parseInt("42");    // 42\n    // Attention : Integer.parseInt("abc") lance une NumberFormatException !\n\n  Autres conversions\n    double d = Double.parseDouble("3.14");\n    boolean b = Boolean.parseBoolean("true");\n    String s = String.valueOf(true);   // "true"',
    3,
    25
FROM chapters c WHERE c.slug = 'variables-types';

-- =============================================
-- QUIZ : Les Strings
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Les Strings',
    'Testez vos connaissances sur les Strings, l immutabilite et les methodes essentielles',
    300, 70, 100
FROM lessons l WHERE l.slug = 'strings';

-- Question 1 : immutabilite
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que se passe-t-il apres ce code : String s = "bonjour"; s.toUpperCase(); System.out.println(s);',
        'SINGLE_CHOICE',
        'Les Strings sont immutables en Java. toUpperCase() retourne une NOUVELLE String sans modifier s. Pour utiliser le resultat, il faut ecrire : String majuscule = s.toUpperCase();',
        1
    FROM quizzes qz WHERE qz.title = 'Quiz - Les Strings'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Affiche "BONJOUR"', false, 1 FROM q
UNION ALL SELECT q.id, 'Affiche "bonjour"', true, 2 FROM q
UNION ALL SELECT q.id, 'Erreur de compilation', false, 3 FROM q
UNION ALL SELECT q.id, 'Affiche null', false, 4 FROM q;

-- Question 2 : equals vs ==
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment comparer correctement le contenu de deux Strings en Java ?',
        'SINGLE_CHOICE',
        'L operateur == compare les references memoire, pas le contenu. Pour comparer le contenu, il faut utiliser la methode .equals(). C est une des erreurs les plus classiques en Java.',
        2
    FROM quizzes qz WHERE qz.title = 'Quiz - Les Strings'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Avec l operateur ==', false, 1 FROM q
UNION ALL SELECT q.id, 'Avec la methode .equals()', true, 2 FROM q
UNION ALL SELECT q.id, 'Avec l operateur !=', false, 3 FROM q
UNION ALL SELECT q.id, 'Avec .compare()', false, 4 FROM q;

-- Question 3 : length
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la valeur de "JavaQuest".length() ?',
        'SINGLE_CHOICE',
        'La methode length() retourne le nombre de caracteres de la String. "JavaQuest" contient 9 caracteres : J-a-v-a-Q-u-e-s-t.',
        3
    FROM quizzes qz WHERE qz.title = 'Quiz - Les Strings'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, '8', false, 1 FROM q
UNION ALL SELECT q.id, '9', true, 2 FROM q
UNION ALL SELECT q.id, '10', false, 3 FROM q
UNION ALL SELECT q.id, 'Erreur', false, 4 FROM q;

-- Question 4 : substring
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que retourne "Bonjour".substring(3) ?',
        'SINGLE_CHOICE',
        'substring(debut) extrait la chaine a partir de l index indique (inclus) jusqu a la fin. L index commence a 0. "Bonjour" : B=0, o=1, n=2, j=3. Donc substring(3) retourne "jour".',
        4
    FROM quizzes qz WHERE qz.title = 'Quiz - Les Strings'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Bon', false, 1 FROM q
UNION ALL SELECT q.id, 'jour', true, 2 FROM q
UNION ALL SELECT q.id, 'njour', false, 3 FROM q
UNION ALL SELECT q.id, 'Bonjour', false, 4 FROM q;

-- Question 5 : StringBuilder
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pourquoi utiliser StringBuilder plutot que + pour concatener des Strings dans une boucle ?',
        'SINGLE_CHOICE',
        'Chaque utilisation de + avec des Strings cree un nouvel objet String en memoire. Dans une boucle avec beaucoup d iterations, cela peut creer des milliers d objets temporaires. StringBuilder utilise un buffer interne modifiable, ce qui est beaucoup plus efficace.',
        5
    FROM quizzes qz WHERE qz.title = 'Quiz - Les Strings'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'StringBuilder produit des Strings mutables', false, 1 FROM q
UNION ALL SELECT q.id, 'Chaque + cree un nouvel objet, StringBuilder modifie un seul buffer', true, 2 FROM q
UNION ALL SELECT q.id, 'StringBuilder est obligatoire depuis Java 11', false, 3 FROM q
UNION ALL SELECT q.id, 'Le + ne fonctionne pas avec les boucles', false, 4 FROM q;

-- Question 6 : Integer.parseInt
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode convertit la String "42" en int en Java ?',
        'SINGLE_CHOICE',
        'Integer.parseInt(String) convertit une String representant un entier en int. Si la String ne contient pas un entier valide (ex: "abc"), une NumberFormatException est lancee.',
        6
    FROM quizzes qz WHERE qz.title = 'Quiz - Les Strings'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'String.toInt("42")', false, 1 FROM q
UNION ALL SELECT q.id, 'Integer.parseInt("42")', true, 2 FROM q
UNION ALL SELECT q.id, '(int) "42"', false, 3 FROM q
UNION ALL SELECT q.id, 'Int.valueOf("42")', false, 4 FROM q;
