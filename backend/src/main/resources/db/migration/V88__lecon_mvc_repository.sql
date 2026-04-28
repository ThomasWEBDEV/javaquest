-- V88: Lecon 2 - Le Pattern Repository + Quiz

-- =============================================
-- LECON 2 : Le Pattern Repository
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Le Pattern Repository : stocker et retrouver les donnees',
    'mvc-repository',
    E'LE PATTERN REPOSITORY : STOCKER ET RETROUVER LES DONNEES\n\nLes modeles representent les donnees, mais ou les stocker ? Le patron Repository est une couche d abstraction qui gere le stockage et la recuperation des objets.\n\n---\n\nQU EST-CE QU UN REPOSITORY ?\n\nUn repository expose des operations simples sur une collection d objets :\n\n  - add    : ajouter un nouvel objet\n  - all    : recuperer tous les objets\n  - findById : retrouver un objet par son ID\n  - delete : supprimer un objet\n\nLe code appelant ne sait pas si les donnees sont en memoire, dans un fichier CSV ou dans une base de donnees. C est le principe d abstraction.\n\n---\n\nMEALREPOSITORY : STOCKAGE EN MEMOIRE\n\n  import java.util.ArrayList;\n  import java.util.List;\n\n  class MealRepository {\n      private List<Meal> meals = new ArrayList<>();\n      private int nextId = 1;\n\n      // Ajouter un repas (id auto-incremente)\n      public void add(String name, double price) {\n          meals.add(new Meal(nextId++, name, price));\n      }\n\n      // Recuperer tous les repas (copie defensive)\n      public List<Meal> all() {\n          return new ArrayList<>(meals);\n      }\n  }\n\n  MealRepository repo = new MealRepository();\n  repo.add("Pizza Margherita", 12.5);\n  repo.add("Burger Classic", 9.9);\n  repo.all().forEach(System.out::println);\n  // #1 - Pizza Margherita : 12.5 EUR\n  // #2 - Burger Classic : 9.9 EUR\n\n---\n\nL ID AUTO-INCREMENTANT\n\nLe repository gere les IDs pour garantir leur unicite :\n\n  private int nextId = 1;\n\n  public void add(String name, double price) {\n      // nextId++ : utilise la valeur actuelle PUIS incremente\n      meals.add(new Meal(nextId++, name, price));\n  }\n\nPremier appel a add() -> ID 1, nextId devient 2\nDeuxieme appel -> ID 2, nextId devient 3, etc.\n\n---\n\nLa COPIE DEFENSIVE dans all()\n\n  // CORRECT : retourne une copie\n  public List<Meal> all() {\n      return new ArrayList<>(meals); // nouvelle liste avec les memes elements\n  }\n\n  // RISQUE : retourne la liste interne directement\n  // public List<Meal> all() { return meals; } // le code appelant peut modifier meals !\n\nRetourner une copie empeche le code appelant de modifier la liste interne du repository. C est une bonne pratique d encapsulation.\n\n---\n\nFINDBYID : RECHERCHER PAR ID\n\n  public Meal findById(int id) {\n      for (Meal meal : meals) {\n          if (meal.getId() == id) {\n              return meal;\n          }\n      }\n      return null; // convention : retourner null si non trouve\n  }\n\n  Meal found = repo.findById(2);\n  if (found != null) {\n      System.out.println("Trouve : " + found);\n  } else {\n      System.out.println("Repas introuvable");\n  }\n\nIMPORTANT : Verifiez toujours si le resultat est null avant de l utiliser.\n\n---\n\nDELETE : SUPPRIMER UN ELEMENT\n\n  public boolean delete(int id) {\n      // removeIf supprime tous les elements qui satisfont la condition\n      return meals.removeIf(meal -> meal.getId() == id);\n  }\n\n  repo.delete(2);\n  System.out.println(repo.all().size()); // 1 (si on avait 2 repas)\n\nremoveIf() parcourt la liste et supprime les elements qui satisfont le predicat. Tres efficace avec les lambdas.\n\n---\n\nCUSTOMERREPOSITORY : MISE A JOUR (UPDATE)\n\nPour modifier un element existant, on utilise les setters du modele :\n\n  public void update(int id, String newName, String newAddress) {\n      Customer customer = findById(id);\n      if (customer != null) {\n          customer.setName(newName);\n          customer.setAddress(newAddress);\n      }\n  }\n\nCela requiert d ajouter des setters dans la classe Customer :\n\n  public void setName(String name) { this.name = name; }\n  public void setAddress(String address) { this.address = address; }\n\n---\n\nBONNES PRATIQUES\n\n1. Le repository encapsule tout acces aux donnees : ni les controleurs ni les vues ne manipulent la liste directement.\n2. L ID est gere par le repository, pas par le code appelant.\n3. findById() retourne null si non trouve : verifiez toujours avant d utiliser le resultat.\n4. all() retourne une copie defensive : new ArrayList<>(laListeInterne).\n5. Les methodes du repository correspondent aux operations CRUD : Create, Read, Update, Delete.',
    2,
    40
FROM chapters c WHERE c.slug = 'projet-livraison-mvc';

-- =============================================
-- QUIZ : Le Pattern Repository
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Le Pattern Repository',
    'Testez vos connaissances sur le patron Repository, ArrayList et les operations CRUD',
    300, 70, 100
FROM lessons l WHERE l.slug = 'mvc-repository';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Qu est-ce que le patron Repository ?',
        'SINGLE_CHOICE',
        'Le Repository est une couche d abstraction qui gere le stockage et la recuperation des donnees. Il expose des operations CRUD simples et masque les details de persistence (memoire, fichier, BDD). Le code appelant ne sait pas comment les donnees sont stockees.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'mvc-repository'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Une base de donnees Java integree', false, 1),
    ('Une couche d abstraction qui gere le stockage et la recuperation des objets', true, 2),
    ('Une classe qui affiche les donnees a l ecran', false, 3),
    ('Un type special de tableau Java', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle collection Java utilise-t-on pour stocker les objets dans un repository en memoire ?',
        'SINGLE_CHOICE',
        'ArrayList<T> est la collection la plus adaptee pour un repository en memoire. Elle permet d ajouter, supprimer et parcourir des elements facilement avec une taille dynamique. T est le type d objet stocke (Meal, Customer...).',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'mvc-repository'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('int[]', false, 1),
    ('String[]', false, 2),
    ('ArrayList<T>', true, 3),
    ('Stack<T>', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment implementer un ID auto-incrementant dans un repository ?',
        'SINGLE_CHOICE',
        'Un champ int nextId = 1 initialise dans le repository permet de generer des IDs uniques. On passe nextId++ au constructeur : l operateur ++ postfixe utilise la valeur actuelle PUIS incremente. Ainsi chaque objet recoit un ID unique.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'mvc-repository'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Utiliser Math.random() pour generer un ID aleatoire', false, 1),
    ('Demander l ID a l utilisateur a chaque ajout', false, 2),
    ('Utiliser le hashCode() de l objet comme ID', false, 3),
    ('Declarer private int nextId = 1 et passer nextId++ au constructeur', true, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que doit retourner findById(int id) si l element n est pas trouve ?',
        'SINGLE_CHOICE',
        'La convention Java est de retourner null quand un element n est pas trouve. Le code appelant doit toujours verifier si le resultat est null avant de l utiliser pour eviter une NullPointerException.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'mvc-repository'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Une exception RuntimeException', false, 1),
    ('Un objet vide avec new Meal()', false, 2),
    ('null', true, 3),
    ('L entier -1', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pourquoi retourner new ArrayList<>(meals) dans all() plutot que meals directement ?',
        'SINGLE_CHOICE',
        'Retourner une copie defensive empeche le code appelant de modifier la liste interne du repository directement (par exemple avec list.add() ou list.remove()). C est une bonne pratique d encapsulation.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'mvc-repository'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Pour des raisons de performance memoire', false, 1),
    ('Pour retourner une copie defensive qui empeche la modification de la liste interne', true, 2),
    ('Parce que ArrayList n est pas serialisable directement', false, 3),
    ('Pour trier automatiquement les resultats par ID', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode Java permet de supprimer facilement des elements d une ArrayList avec une condition ?',
        'SINGLE_CHOICE',
        'removeIf(predicat) parcourt la liste et supprime tous les elements pour lesquels le predicat retourne true. C est tres efficace avec une lambda : meals.removeIf(m -> m.getId() == id).',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'mvc-repository'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('delete(index)', false, 1),
    ('suppress(predicat)', false, 2),
    ('removeIf(predicat)', true, 3),
    ('filter(predicat)', false, 4)
) AS opt(text, is_correct, order_index);
