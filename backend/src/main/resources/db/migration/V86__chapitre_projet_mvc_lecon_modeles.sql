-- V86: Chapitre 10 Projet Livraison MVC + Lecon 1 Modelisation + Quiz

-- =============================================
-- CHAPITRE 10 : Projet - Systeme de Livraison MVC
-- =============================================

INSERT INTO chapters (title, slug, description, order_index, xp_reward, is_published)
VALUES (
    'Projet - Systeme de Livraison MVC',
    'projet-livraison-mvc',
    'Construisez un systeme de livraison de repas complet en appliquant le patron MVC : modeles, repositories, controllers et heritage generique',
    10,
    600,
    true
);

-- =============================================
-- LECON 1 : Modelisation - Meal et Customer
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Modelisation : les classes Meal et Customer',
    'mvc-modeles',
    E'MODELISATION : LES CLASSES MEAL ET CUSTOMER\n\nDans ce chapitre, vous allez construire un systeme de livraison de repas complet. Vous appliquerez le patron MVC et les patterns de conception fondamentaux en Java.\n\n---\n\nLE PATRON MVC\n\nMVC (Modele-Vue-Controleur) divise le code en trois responsabilites :\n\n  MODELE     : represente les donnees (Meal, Customer, Order)\n  REPOSITORY : stocke et retrouve les donnees (MealRepository...)\n  CONTROLEUR : coordonne les actions utilisateur\n\nCe patron rend le code lisible, testable et facile a faire evoluer.\n\n---\n\nCREER UN MODELE JAVA : MEAL\n\nUn modele est une classe avec des champs prives, un constructeur et des getters :\n\n  class Meal {\n      private int id;\n      private String name;\n      private double price;\n\n      public Meal(int id, String name, double price) {\n          this.id = id;\n          this.name = name;\n          this.price = price;\n      }\n\n      public int getId() { return id; }\n      public String getName() { return name; }\n      public double getPrice() { return price; }\n\n      @Override\n      public String toString() {\n          return "#" + id + " - " + name + " : " + price + " EUR";\n      }\n  }\n\n  Meal pizza = new Meal(1, "Pizza Margherita", 12.5);\n  System.out.println(pizza); // #1 - Pizza Margherita : 12.5 EUR\n\n---\n\nENCAPSULATION\n\nLes champs sont toujours private : on ne peut y acceder qu a travers les getters.\n\n  // CORRECT : acces via getter\n  double prix = pizza.getPrice(); // 12.5\n\n  // INCORRECT : acces direct (ne compile pas si le champ est private)\n  // double prix = pizza.price; // erreur de compilation\n\nAvantages :\n- Protege l integrite des donnees\n- Permet de modifier l implementation sans casser le code appelant\n- Facilite l ajout de validation dans les setters\n\n---\n\nLA METHODE toString()\n\n@Override toString() remplace la representation par defaut de Java :\n\n  // Sans @Override toString() :\n  System.out.println(pizza); // Meal@3764951d (inutile)\n\n  // Avec @Override toString() :\n  System.out.println(pizza); // #1 - Pizza Margherita : 12.5 EUR\n\n  // toString() est aussi appele dans les concatenations :\n  String msg = "Repas : " + pizza;\n  // "Repas : #1 - Pizza Margherita : 12.5 EUR"\n\n---\n\nLE MODELE CUSTOMER\n\n  class Customer {\n      private int id;\n      private String name;\n      private String address;\n\n      public Customer(int id, String name, String address) {\n          this.id = id;\n          this.name = name;\n          this.address = address;\n      }\n\n      public int getId() { return id; }\n      public String getName() { return name; }\n      public String getAddress() { return address; }\n\n      @Override\n      public String toString() {\n          return "#" + id + " - " + name + " | " + address;\n      }\n  }\n\n---\n\nLIER DEUX MODELES : LA CLASSE ORDER\n\nUne commande relie un client a un repas :\n\n  class Order {\n      private int id;\n      private Customer customer;\n      private Meal meal;\n\n      public Order(int id, Customer customer, Meal meal) {\n          this.id = id;\n          this.customer = customer;\n          this.meal = meal;\n      }\n\n      @Override\n      public String toString() {\n          return "Commande #" + id + " : "\n              + customer.getName() + " -> "\n              + meal.getName()\n              + " (" + meal.getPrice() + " EUR)";\n      }\n  }\n\n  Order commande = new Order(1, jean, pizza);\n  System.out.println(commande);\n  // Commande #1 : Jean Dupont -> Pizza Margherita (12.5 EUR)\n\n---\n\nBONNES PRATIQUES\n\n1. Champs toujours private : acces uniquement via getters (et setters si necessaire).\n2. Constructeur avec tous les champs obligatoires : l objet est valide des sa creation.\n3. Redefinissez toString() pour chaque modele : facilite le debug et l affichage.\n4. Une classe = une responsabilite (Meal pour les repas, Customer pour les clients).\n5. Nommez les classes au singulier (Meal, Customer) car elles representent une entite.',
    1,
    40
FROM chapters c WHERE c.slug = 'projet-livraison-mvc';

-- =============================================
-- QUIZ : Modelisation MVC
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Modelisation MVC',
    'Testez vos connaissances sur le patron MVC, les modeles Java et l encapsulation',
    300, 70, 100
FROM lessons l WHERE l.slug = 'mvc-modeles';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que signifie le patron MVC ?',
        'SINGLE_CHOICE',
        'MVC signifie Modele-Vue-Controleur. Le Modele represente les donnees, la Vue affiche les informations, le Controleur coordonne les interactions entre les deux.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'mvc-modeles'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Methode-Variable-Classe', false, 1),
    ('Modele-Vue-Controleur', true, 2),
    ('Module-Verification-Creation', false, 3),
    ('Multi-Version-Code', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pourquoi les champs d un modele sont-ils declares private ?',
        'SINGLE_CHOICE',
        'Les champs private ne peuvent etre accedes qu a travers les getters et setters. Cela protege l integrite des donnees et permet de modifier l implementation sans impacter le code client.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'mvc-modeles'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Pour des raisons de performance', false, 1),
    ('Parce que Java l exige pour toutes les classes', false, 2),
    ('Pour proteger l integrite des donnees et controler l acces', true, 3),
    ('Pour eviter les conflits de noms entre classes', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode est automatiquement appelee par System.out.println(objet) ?',
        'SINGLE_CHOICE',
        'System.out.println(objet) appelle automatiquement la methode toString() de l objet. Si vous ne la redefinissez pas, Java affiche le nom de la classe suivi d un identifiant hexadecimal peu lisible.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'mvc-modeles'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('print()', false, 1),
    ('display()', false, 2),
    ('toString()', true, 3),
    ('show()', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'A quoi sert l annotation @Override ?',
        'SINGLE_CHOICE',
        '@Override indique au compilateur qu on redefinit une methode heritee. Si la methode n existe pas dans la classe parente, le compilateur signale une erreur. C est une protection contre les fautes de frappe.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'mvc-modeles'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Elle rend la methode plus rapide a l execution', false, 1),
    ('Elle est obligatoire pour tous les getters', false, 2),
    ('Elle cree une nouvelle methode Java unique', false, 3),
    ('Elle indique qu on redefinit une methode heritee et detecte les erreurs de frappe', true, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel est le role du Modele dans le patron MVC ?',
        'SINGLE_CHOICE',
        'Le Modele represente les donnees de l application et encapsule la logique metier. Il ne sait pas comment les donnees sont affichees ni comment l utilisateur interagit : c est la responsabilite de la Vue et du Controleur.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'mvc-modeles'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Afficher les donnees a l utilisateur via System.out', false, 1),
    ('Representer les donnees et encapsuler la logique metier', true, 2),
    ('Gerer les entrees clavier avec Scanner', false, 3),
    ('Faire le lien entre l affichage et la base de donnees', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la structure correcte d un modele Meal en Java ?',
        'SINGLE_CHOICE',
        'Un bon modele a des champs private, un constructeur avec tous les champs obligatoires et des getters publics pour acceder aux valeurs. L acces direct aux champs (public int id) viole l encapsulation.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'mvc-modeles'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('class Meal { public int id; public String name; public double price; }', false, 1),
    ('class Meal { private int id; Meal() {} }', false, 2),
    ('class Meal { private int id; private String name; private double price; public Meal(int id, String name, double price) { ... } public int getId() { return id; } ... }', true, 3),
    ('class Meal extends Model { @Column int id; @Column String name; }', false, 4)
) AS opt(text, is_correct, order_index);
