-- V101: Lecon 4 Design Patterns - Builder Pattern + Quiz

-- =============================================
-- LECON 4 : Builder Pattern
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Builder Pattern',
    'builder-pattern',
    E'BUILDER PATTERN\n\nLe patron Builder separe la construction d un objet complexe de sa representation. Il permet de creer des objets avec de nombreux parametres optionnels de facon lisible et sans multiplier les constructeurs. C est l un des patrons les plus utilisés dans les APIs Java modernes.\n\n---\n\nLE PROBLEME SANS BUILDER\n\nQuand un objet a de nombreux champs, les constructeurs deviennent vite illisibles :\n\n  // Constructeur telescopique : illisible et fragile\n  class Pizza {\n      Pizza(String taille, String pate, String sauce, String fromage,\n            boolean olives, boolean champignons, boolean jambon) { ... }\n  }\n\n  // A l usage, on ne sait plus quel parametre est quoi\n  Pizza p = new Pizza("grande", "fine", "tomate", "mozzarella", true, false, true);\n  //                                                              ^- olives? fromage? champignons?\n\nProbleme : ordre des parametres ambigu, impossible d avoir des parametres optionnels proprement.\n\n---\n\nLA STRUCTURE DU BUILDER\n\nLe Builder est une classe interne statique qui accumule les parametres et construit l objet final via build() :\n\n  class Pizza {\n      // Les champs de Pizza (private final)\n      private final String taille;\n      private final String sauce;\n      private final boolean olives;\n      private final boolean jambon;\n\n      // Constructeur prive : seul le Builder peut creer une Pizza\n      private Pizza(Builder builder) {\n          this.taille = builder.taille;\n          this.sauce  = builder.sauce;\n          this.olives = builder.olives;\n          this.jambon = builder.jambon;\n      }\n\n      // Classe Builder interne statique\n      public static class Builder {\n          private String taille;     // obligatoire\n          private String sauce = "tomate";  // valeur par defaut\n          private boolean olives = false;\n          private boolean jambon = false;\n\n          public Builder(String taille) {  // parametres obligatoires dans le constructeur\n              this.taille = taille;\n          }\n\n          public Builder sauce(String sauce) {\n              this.sauce = sauce;\n              return this;   // retourne this pour le chaining\n          }\n\n          public Builder olives(boolean olives) {\n              this.olives = olives;\n              return this;\n          }\n\n          public Builder jambon(boolean jambon) {\n              this.jambon = jambon;\n              return this;\n          }\n\n          public Pizza build() {\n              return new Pizza(this);\n          }\n      }\n\n      public String toString() {\n          return "Pizza " + taille + " | sauce: " + sauce +\n              " | olives: " + olives + " | jambon: " + jambon;\n      }\n  }\n\n  // Utilisation : lisible, fluent, ordre libre\n  Pizza p1 = new Pizza.Builder("grande")\n      .sauce("pesto")\n      .olives(true)\n      .build();\n\n  Pizza p2 = new Pizza.Builder("petite")\n      .jambon(true)\n      .build();  // sauce par defaut "tomate", pas d olives\n\n  System.out.println(p1); // Pizza grande | sauce: pesto | olives: true | jambon: false\n  System.out.println(p2); // Pizza petite | sauce: tomate | olives: false | jambon: true\n\n---\n\nEXEMPLE COMPLET : CONFIGURATION HTTP\n\n  class HttpRequest {\n      private final String url;\n      private final String method;\n      private final int timeout;\n      private final boolean followRedirects;\n      private final String authToken;\n\n      private HttpRequest(Builder b) {\n          this.url             = b.url;\n          this.method          = b.method;\n          this.timeout         = b.timeout;\n          this.followRedirects = b.followRedirects;\n          this.authToken       = b.authToken;\n      }\n\n      public String toString() {\n          return method + " " + url + " [timeout=" + timeout +\n              "s, redirects=" + followRedirects + ", auth=" + (authToken != null) + "]";\n      }\n\n      public static class Builder {\n          private final String url;           // obligatoire\n          private String method = "GET";      // defaut\n          private int timeout = 30;           // defaut\n          private boolean followRedirects = true;\n          private String authToken = null;\n\n          public Builder(String url) {\n              this.url = url;\n          }\n\n          public Builder method(String method)          { this.method = method; return this; }\n          public Builder timeout(int seconds)           { this.timeout = seconds; return this; }\n          public Builder followRedirects(boolean follow){ this.followRedirects = follow; return this; }\n          public Builder authToken(String token)        { this.authToken = token; return this; }\n\n          public HttpRequest build() { return new HttpRequest(this); }\n      }\n  }\n\n  // Utilisation\n  HttpRequest req1 = new HttpRequest.Builder("https://api.example.com/users")\n      .method("POST")\n      .timeout(10)\n      .authToken("Bearer abc123")\n      .build();\n\n  HttpRequest req2 = new HttpRequest.Builder("https://api.example.com/data")\n      .followRedirects(false)\n      .build();\n\n  System.out.println(req1); // POST https://api.example.com/users [timeout=10s, redirects=true, auth=true]\n  System.out.println(req2); // GET https://api.example.com/data [timeout=30s, redirects=false, auth=false]\n\n---\n\nBUILDER AVEC VALIDATION\n\nLe Builder est l endroit ideal pour valider les contraintes avant de construire l objet :\n\n  public HttpRequest build() {\n      if (url == null || url.isEmpty()) {\n          throw new IllegalStateException("URL obligatoire");\n      }\n      if (timeout <= 0) {\n          throw new IllegalStateException("Le timeout doit etre positif");\n      }\n      return new HttpRequest(this);\n  }\n\n---\n\nMETHODE FLUENTE (CHAINING)\n\nLa cle du Builder est que chaque methode de configuration retourne this (le Builder lui-meme). Cela permet d enchainer les appels sur une seule expression :\n\n  // Chaque setter retourne this -> on peut enchainer\n  public Builder sauce(String sauce) {\n      this.sauce = sauce;\n      return this;   // <- retourne le Builder, pas void\n  }\n\n  // Sans chaining : verbeux\n  Builder b = new Pizza.Builder("grande");\n  b.sauce("pesto");\n  b.olives(true);\n  Pizza p = b.build();\n\n  // Avec chaining : concis et lisible\n  Pizza p = new Pizza.Builder("grande").sauce("pesto").olives(true).build();\n\n---\n\nPOURQUOI UTILISER BUILDER ?\n\n- Lisibilite : on voit clairement quel parametre correspond a quoi\n- Valeurs par defaut : les champs optionnels ont des defauts dans le Builder\n- Immutabilite : l objet cible peut avoir tous ses champs final\n- Validation : build() peut valider les contraintes avant creation\n- Pas de surcharge : plus besoin de 5 constructeurs pour 5 combinaisons\n\n---\n\nBONNES PRATIQUES\n\n1. Parametres obligatoires dans le constructeur du Builder, optionnels en methodes.\n2. Chaque methode du Builder retourne this pour permettre le chaining fluent.\n3. build() est le seul endroit ou l objet cible est instancie.\n4. Le constructeur de l objet cible est prive si possible : seul le Builder le cree.\n5. Nommez les methodes du Builder comme des champs, pas comme des setters (sauce() et non setSauce()).',
    4,
    40
FROM chapters c WHERE c.slug = 'design-patterns';

-- =============================================
-- QUIZ : Builder Pattern
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Builder Pattern',
    'Testez vos connaissances sur le patron Builder, la methode fluente, les valeurs par defaut et la construction d objets complexes',
    300, 70, 100
FROM lessons l WHERE l.slug = 'builder-pattern';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel probleme le patron Builder resout-il principalement ?',
        'SINGLE_CHOICE',
        'Le Builder resout le probleme du "constructeur telescopique" : quand un objet a de nombreux parametres (surtout optionnels), les constructeurs deviennent illisibles et difficiles a utiliser. Le Builder accumule les parametres un par un de facon lisible avant de construire l objet.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'builder-pattern'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Les problemes de synchronisation dans les applications multi-threads', false, 1),
    ('La construction d objets complexes avec de nombreux parametres optionnels', true, 2),
    ('La notification automatique d objets quand un etat change', false, 3),
    ('Le choix dynamique d un algorithme parmi plusieurs', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pourquoi les methodes du Builder retournent-elles "this" ?',
        'SINGLE_CHOICE',
        'Retourner this (le Builder lui-meme) permet le chaining fluent : on peut enchainer les appels en une seule expression new Pizza.Builder("grande").sauce("pesto").olives(true).build(). Sans this, chaque appel devrait etre sur une ligne separee avec une variable intermediaire.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'builder-pattern'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Pour eviter que le Builder soit garbage collecte pendant la construction', false, 1),
    ('Pour permettre l enchainement fluent des appels de configuration', true, 2),
    ('Pour que build() sache quel Builder a ete utilise', false, 3),
    ('Pour que l objet cible puisse modifier le Builder apres creation', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Ou place-t-on les parametres obligatoires dans le patron Builder ?',
        'SINGLE_CHOICE',
        'Les parametres obligatoires sont places dans le constructeur du Builder lui-meme, pas dans des methodes de configuration. Cela garantit qu ils sont toujours fournis : on ne peut pas creer un Builder sans eux. Les parametres optionnels ont des valeurs par defaut et sont configures via des methodes.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'builder-pattern'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Dans la methode build() qui verifie leur presence', false, 1),
    ('Dans le constructeur de l objet cible final', false, 2),
    ('Dans le constructeur du Builder pour les rendre obligatoires', true, 3),
    ('Dans des methodes required() separees des methodes optionnelles', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel est le role de la methode build() dans le Builder ?',
        'SINGLE_CHOICE',
        'build() est l unique endroit ou l objet cible est instancie. Elle appelle le constructeur prive de l objet en lui passant le Builder (this). C est aussi le bon endroit pour valider les contraintes : si les donnees accumulees sont invalides, build() lance une exception avant de creer l objet.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'builder-pattern'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Elle reinitialise le Builder pour permettre de construire un second objet', false, 1),
    ('Elle cree l objet cible a partir des donnees accumulees dans le Builder', true, 2),
    ('Elle valide les types des parametres passes aux methodes de configuration', false, 3),
    ('Elle retourne le Builder pour une derniere phase de configuration', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pourquoi le constructeur de l objet cible est-il souvent "private" ?',
        'SINGLE_CHOICE',
        'En rendant le constructeur de l objet cible private, on force les clients a passer par le Builder. Cela garantit que l objet est toujours construit correctement avec toutes les validations du Builder, et empeche la creation directe avec des parametres dans le mauvais ordre.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'builder-pattern'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Pour que la JVM puisse optimiser la creation de l objet', false, 1),
    ('Pour empecher la creation directe et forcer l usage du Builder', true, 2),
    ('Pour que le Builder puisse acceder aux champs prives de l objet', false, 3),
    ('Pour rendre l objet immutable apres creation', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la bonne convention de nommage pour les methodes du Builder ?',
        'SINGLE_CHOICE',
        'Les methodes du Builder suivent la convention fluente : on les nomme comme le champ qu elles configurent (sauce(), timeout(), olives()) et non comme des setters Java (setSauce(), setTimeout()). Cela rend le code de construction plus lisible, proche d un DSL (Domain Specific Language).',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'builder-pattern'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('setNomDuChamp() pour suivre les conventions JavaBeans standards', false, 1),
    ('withNomDuChamp() obligatoirement pour distinguer les Builders des objets normaux', false, 2),
    ('nomDuChamp() sans prefixe pour un style fluent lisible comme un DSL', true, 3),
    ('addNomDuChamp() pour indiquer que l on ajoute une valeur au Builder', false, 4)
) AS opt(text, is_correct, order_index);
