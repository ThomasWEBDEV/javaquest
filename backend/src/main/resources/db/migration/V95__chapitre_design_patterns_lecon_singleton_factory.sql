-- V95: Chapitre 11 Design Patterns + Lecon 1 Singleton et Factory Method + Quiz

-- =============================================
-- CHAPITRE 11 : Design Patterns en Java
-- =============================================

INSERT INTO chapters (title, slug, description, order_index, xp_reward, is_published)
VALUES (
    'Design Patterns en Java',
    'design-patterns',
    'Maitrisez les patrons de conception les plus utilises en Java : Singleton, Factory, Observer, Strategy et Builder. Des solutions eprouvees aux problemes recurrents de conception orientee objet.',
    11,
    500,
    true
);

-- =============================================
-- LECON 1 : Singleton et Factory Method
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Singleton et Factory Method',
    'singleton-factory',
    E'SINGLETON ET FACTORY METHOD\n\nLes patrons de conception (Design Patterns) sont des solutions eprouvees a des problemes recurrents de conception orientee objet. Ils ont ete formalises par le Gang of Four en 1994 et sont utilises dans tous les projets Java professionnels.\n\n---\n\nLE PATRON SINGLETON\n\nLe Singleton garantit qu une classe n a qu une seule instance dans tout le programme, et fournit un point d acces global a cette instance.\n\nCas d usage : configuration de l application, logger global, connexion a une base de donnees.\n\n  class AppConfig {\n      private static AppConfig instance = null;\n      private String env;\n      private int maxConnections;\n\n      // Constructeur private : empeche new AppConfig() depuis l exterieur\n      private AppConfig() {\n          this.env = "production";\n          this.maxConnections = 10;\n      }\n\n      public static AppConfig getInstance() {\n          if (instance == null) {\n              instance = new AppConfig();\n          }\n          return instance;\n      }\n\n      public String getEnv() { return env; }\n      public int getMaxConnections() { return maxConnections; }\n  }\n\n  // Toujours la meme instance\n  AppConfig config1 = AppConfig.getInstance();\n  AppConfig config2 = AppConfig.getInstance();\n  System.out.println(config1 == config2); // true : meme objet en memoire\n\nPoints cles :\n- Constructeur private : impossible de faire new AppConfig() depuis l exterieur\n- Champ static instance : reference unique, partagee par toute l application\n- getInstance() : cree l instance au premier appel, la retourne directement ensuite\n\n---\n\nLE PATRON FACTORY METHOD\n\nLa Factory Method encapsule la logique de creation d objets derriere une methode statique. Le code client demande un objet par type sans connaitre la classe concrete.\n\n  interface Animal {\n      String speak();\n      String name();\n  }\n\n  class Dog implements Animal {\n      public String speak() { return "Wouf !"; }\n      public String name() { return "Chien"; }\n  }\n\n  class Cat implements Animal {\n      public String speak() { return "Miaou !"; }\n      public String name() { return "Chat"; }\n  }\n\n  // La Factory centralise la creation\n  class AnimalFactory {\n      public static Animal create(String type) {\n          switch (type) {\n              case "dog": return new Dog();\n              case "cat": return new Cat();\n              default: throw new IllegalArgumentException("Type inconnu : " + type);\n          }\n      }\n  }\n\n  Animal a = AnimalFactory.create("dog");\n  Animal b = AnimalFactory.create("cat");\n  System.out.println(a.name() + " : " + a.speak()); // Chien : Wouf !\n  System.out.println(b.name() + " : " + b.speak()); // Chat : Miaou !\n\n---\n\nCOMBINER SINGLETON ET FACTORY\n\nCes deux patrons se combinent naturellement : une Factory Singleton garantit une creation centralisee et unique.\n\n  class VehicleFactory {\n      private static VehicleFactory instance = null;\n      private int creationCount = 0;\n\n      private VehicleFactory() {}\n\n      public static VehicleFactory getInstance() {\n          if (instance == null) instance = new VehicleFactory();\n          return instance;\n      }\n\n      public String create(String type) {\n          creationCount++;\n          return "[" + type.toUpperCase() + " #" + creationCount + "] cree";\n      }\n\n      public int getCreationCount() { return creationCount; }\n  }\n\n  VehicleFactory factory = VehicleFactory.getInstance();\n  System.out.println(factory.create("car"));   // [CAR #1] cree\n  System.out.println(factory.create("truck")); // [TRUCK #2] cree\n  System.out.println("Total crees : " + factory.getCreationCount()); // 2\n\n---\n\nPOURQUOI CES PATRONS ?\n\nSINGLETON :\n- Une seule source de verite pour la configuration ou le logging\n- Economie de ressources (une seule connexion BD, un seul cache)\n- Acces global structure sans variables globales\n\nFACTORY :\n- Decouple le code client de la classe concrete a instancier\n- Facilite l ajout de nouveaux types sans modifier le code existant\n- Centralise la logique de construction complexe\n\n---\n\nBONNES PRATIQUES\n\n1. Singleton : constructeur toujours private pour bloquer new.\n2. Singleton : getInstance() avec if (instance == null) avant de creer.\n3. Factory : les classes creees implementent une interface commune.\n4. Factory : utilisez switch ou Map pour dispatcher selon le type.\n5. N utilisez le Singleton que pour des ressources vraiment uniques.',
    1,
    40
FROM chapters c WHERE c.slug = 'design-patterns';

-- =============================================
-- QUIZ : Singleton et Factory Method
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Singleton et Factory Method',
    'Testez vos connaissances sur le patron Singleton, la Factory Method et leurs combinaisons',
    300, 70, 100
FROM lessons l WHERE l.slug = 'singleton-factory';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que garantit le patron Singleton ?',
        'SINGLE_CHOICE',
        'Le Singleton garantit qu une classe n a qu une seule instance dans tout le programme et fournit un point d acces global a cette instance. C est utile pour les ressources partagees comme la configuration ou le logger.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'singleton-factory'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Qu une classe peut creer autant d instances que necessaire', false, 1),
    ('Qu une classe n a qu une seule instance dans tout le programme', true, 2),
    ('Que toutes les instances d une classe sont identiques', false, 3),
    ('Que la classe est automatiquement thread-safe', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pourquoi le constructeur d un Singleton est-il declare private ?',
        'SINGLE_CHOICE',
        'Le constructeur private empeche toute instanciation directe avec new depuis l exterieur de la classe. Seule la methode getInstance() peut creer l instance, ce qui garantit l unicite.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'singleton-factory'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Pour rendre la classe plus rapide a l execution', false, 1),
    ('Pour empecher l instanciation directe avec new depuis l exterieur', true, 2),
    ('Parce que Java l exige pour les classes avec champs static', false, 3),
    ('Pour eviter la duplication des constructeurs', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que fait getInstance() lors du PREMIER appel si instance == null ?',
        'SINGLE_CHOICE',
        'Au premier appel, instance est null. La condition if (instance == null) est vraie, donc getInstance() cree une nouvelle instance via le constructeur prive et l assigne au champ static. Les appels suivants retournent directement cette instance.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'singleton-factory'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Elle retourne null car aucune instance n existe encore', false, 1),
    ('Elle lance une exception NullPointerException', false, 2),
    ('Elle cree une nouvelle instance via le constructeur prive', true, 3),
    ('Elle attend qu une autre methode cree l instance', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'A quoi sert la Factory Method ?',
        'SINGLE_CHOICE',
        'La Factory Method encapsule la logique de creation d objets derriere une methode statique. Le code client demande un objet par type (ex: "dog") sans connaitre la classe concrete (Dog). Cela decouple la creation de l utilisation.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'singleton-factory'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('A creer des copies identiques d objets existants', false, 1),
    ('A detruire des objets en memoire apres utilisation', false, 2),
    ('A encapsuler la logique de creation derriere une methode statique', true, 3),
    ('A convertir des types primitifs en objets wrapper', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que retourne AnimalFactory.create("dog") si Dog implements Animal ?',
        'SINGLE_CHOICE',
        'La Factory retourne une instance de Dog, mais le type declare est Animal (l interface). C est le polymorphisme : on travaille avec l interface sans connaitre la classe concrete. new Dog() est appele a l interieur de la Factory.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'singleton-factory'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Le String "dog"', false, 1),
    ('null car "dog" n est pas une classe Java', false, 2),
    ('Une instance de Animal creee directement', false, 3),
    ('Une instance de Dog referencee par le type Animal', true, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel est l avantage principal de la Factory Method par rapport a new ?',
        'SINGLE_CHOICE',
        'La Factory Method decouple le code client de la classe concrete. Si on veut ajouter un nouveau type, on modifie uniquement la Factory (ouvert a l extension). Le code client n a pas a changer. Avec new, le code client depend directement de la classe concrete.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'singleton-factory'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Elle est plus rapide que new en termes de performance', false, 1),
    ('Elle decouple le code client de la classe concrete a instancier', true, 2),
    ('Elle empeche la creation de trop nombreux objets en memoire', false, 3),
    ('Elle remplace automatiquement le constructeur prive du Singleton', false, 4)
) AS opt(text, is_correct, order_index);
