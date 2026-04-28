-- V90: Lecon 3 - Architecture MVC : Controllers + Quiz

-- =============================================
-- LECON 3 : Architecture MVC - Controllers
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Architecture MVC : Controllers et BaseRepository generique',
    'mvc-controllers',
    E'ARCHITECTURE MVC : CONTROLLERS ET BASEREPOSITORY GENERIQUE\n\nNous avons nos modeles et nos repositories. Il manque le troisieme pilier du MVC : le Controller. C est lui qui fait le lien entre tous les composants.\n\n---\n\nLE ROLE DU CONTROLLER\n\nLe Controller coordonne les interactions :\n\n  UTILISATEUR -> Controller -> Repository -> Modele -> Controller -> Vue\n\nLe Controller :\n- Recoit une action ("afficher les repas", "ajouter un repas")\n- Delegue la recuperation des donnees au Repository\n- Passe les donnees a la Vue pour l affichage\n- Ne stocke pas de donnees : il orchestre\n\n---\n\nMEALCONTROLLER\n\n  class MealController {\n      private MealRepository repository;\n\n      public MealController(MealRepository repository) {\n          this.repository = repository;\n      }\n\n      // Action : lister tous les repas\n      public void list() {\n          List<Meal> meals = repository.all();\n          System.out.println("[Repas] " + meals.size() + " repas disponibles :");\n          for (Meal m : meals) {\n              System.out.println(m);\n          }\n      }\n\n      // Action : ajouter un repas\n      public void add(String name, double price) {\n          repository.add(name, price);\n          Meal added = repository.all().get(repository.all().size() - 1);\n          System.out.println("[Repas] Nouveau repas ajoute : " + added);\n      }\n  }\n\nLe Controller delaye au Repository : il ne manipule jamais la liste directement.\n\n---\n\nPRINCIPE DE RESPONSABILITE UNIQUE (SRP)\n\nChaque composant a une seule responsabilite :\n\n  Meal           : representer un repas (donnees)\n  MealRepository : stocker et retrouver les repas\n  MealController : coordonner les actions sur les repas\n\nSi demain on veut stocker les repas dans un fichier CSV plutot qu en memoire, on modifie seulement MealRepository. Le Controller et le Modele restent inchanges.\n\n---\n\nBASEREPOSITORY GENERIQUE : ELIMINER LA DUPLICATION\n\nMealRepository et CustomerRepository ont les memes methodes. Le principe DRY (Don t Repeat Yourself) suggere de factoriser :\n\n  abstract class BaseRepository<T> {\n      protected List<T> items = new ArrayList<>();\n      protected int nextId = 1;\n\n      public List<T> all() {\n          return new ArrayList<>(items);\n      }\n\n      public T findById(int id) {\n          // methode abstraite : chaque sous-classe sait comment comparer les IDs\n          return items.stream()\n              .filter(item -> getId(item) == id)\n              .findFirst()\n              .orElse(null);\n      }\n\n      public boolean delete(int id) {\n          return items.removeIf(item -> getId(item) == id);\n      }\n\n      // Chaque sous-classe definit comment obtenir l ID d un element\n      protected abstract int getId(T item);\n  }\n\n  class MealRepository extends BaseRepository<Meal> {\n      public void add(String name, double price) {\n          items.add(new Meal(nextId++, name, price));\n      }\n\n      @Override\n      protected int getId(Meal meal) {\n          return meal.getId();\n      }\n  }\n\n---\n\nALTERNATIVE SIMPLE AVEC METHODE PARTAGEE\n\nSi la syntaxe generique semble complexe, on peut aussi partager uniquement la logique commune sans generiques :\n\n  class MealRepository {\n      protected List<Meal> items = new ArrayList<>();\n      protected int nextId = 1;\n\n      public List<Meal> all() {\n          return new ArrayList<>(items);\n      }\n\n      // findById et delete implementes ici specifiquement\n  }\n\n---\n\nAPPLICATION COMPLETE : TOUT ASSEMBLER\n\n  public class Main {\n      public static void main(String[] args) {\n          MealRepository mealRepo = new MealRepository();\n          CustomerRepository customerRepo = new CustomerRepository();\n\n          MealController mealCtrl = new MealController(mealRepo);\n          CustomerController customerCtrl = new CustomerController(customerRepo);\n\n          // Ajouter des donnees\n          mealRepo.add("Pizza Margherita", 12.5);\n          mealRepo.add("Burger Classic", 9.9);\n          customerRepo.add("Jean Dupont", "12 rue de la Paix, Paris");\n\n          // Utiliser les controllers\n          System.out.println("=== Application Restaurant ===");\n          mealCtrl.list();\n          customerCtrl.list();\n      }\n  }\n\n---\n\nBONNES PRATIQUES\n\n1. Le Controller recoit son repository via le constructeur (injection de dependance).\n2. Le Controller ne stocke pas de donnees : il delaye au Repository.\n3. Chaque Controller gere un seul type d entite (SRP).\n4. Utilisez BaseRepository<T> pour eviter la duplication de code CRUD.\n5. Les methodes du Controller correspondent aux actions utilisateur : list(), add(), findById(), delete().',
    3,
    40
FROM chapters c WHERE c.slug = 'projet-livraison-mvc';

-- =============================================
-- QUIZ : Architecture MVC Controllers
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Architecture MVC et Controllers',
    'Testez vos connaissances sur les controllers MVC, le SRP et les generiques Java',
    300, 70, 100
FROM lessons l WHERE l.slug = 'mvc-controllers';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel est le role du Controller dans le patron MVC ?',
        'SINGLE_CHOICE',
        'Le Controller coordonne les interactions entre les composants. Il recoit une action, delegue la recuperation des donnees au Repository, et passe les donnees a la Vue pour l affichage. Il n affiche pas directement ni ne stocke de donnees.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'mvc-controllers'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Stocker les donnees dans une ArrayList', false, 1),
    ('Afficher les informations directement avec System.out', false, 2),
    ('Coordonner les interactions entre modeles, repositories et affichage', true, 3),
    ('Definir la structure des classes modeles', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Qu est-ce que le principe de responsabilite unique (SRP) ?',
        'SINGLE_CHOICE',
        'Le SRP (Single Responsibility Principle) indique que chaque classe doit avoir une seule raison de changer, une seule responsabilite. MealRepository gere le stockage, MealController coordonne les actions, Meal represente les donnees.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'mvc-controllers'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Une classe ne peut avoir qu une seule methode publique', false, 1),
    ('Chaque classe doit avoir une seule responsabilite, une seule raison de changer', true, 2),
    ('On ne peut creer qu un seul objet de chaque classe dans le programme', false, 3),
    ('Chaque methode doit tenir en une seule ligne de code', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment le Controller recoit-il son repository en bonne pratique ?',
        'SINGLE_CHOICE',
        'L injection de dependance via le constructeur est la meilleure pratique : le Controller recoit son Repository comme parametre du constructeur. Cela facilite les tests et rend les dependances explicites.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'mvc-controllers'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Le Controller cree lui-meme son Repository avec new MealRepository()', false, 1),
    ('Le Repository est un champ static accessible partout', false, 2),
    ('Le Controller recoit le Repository via son constructeur (injection de dependance)', true, 3),
    ('Le Controller n a pas besoin de Repository, il accede directement aux donnees', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment declarer une classe generique BaseRepository en Java ?',
        'SINGLE_CHOICE',
        'La syntaxe <T> apres le nom de la classe declare un parametre de type generique. abstract indique que la classe ne peut pas etre instanciee directement. T sera remplace par Meal, Customer, etc. selon la sous-classe.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'mvc-controllers'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('class BaseRepository { ... }', false, 1),
    ('abstract class BaseRepository<T> { ... }', true, 2),
    ('interface BaseRepository extends Generic { ... }', false, 3),
    ('class BaseRepository extends ArrayList { ... }', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment MealRepository herite-t-il de BaseRepository<Meal> ?',
        'SINGLE_CHOICE',
        'En Java, extends est utilise pour l heritage de classes (concretes ou abstraites). implements est reserve pour les interfaces. On ecrit : class MealRepository extends BaseRepository<Meal>.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'mvc-controllers'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('class MealRepository implements BaseRepository<Meal>', false, 1),
    ('class MealRepository extends BaseRepository<Meal>', true, 2),
    ('class MealRepository inherits BaseRepository<Meal>', false, 3),
    ('class MealRepository = BaseRepository<Meal>', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pourquoi utiliser un BaseRepository<T> generique ?',
        'SINGLE_CHOICE',
        'MealRepository et CustomerRepository ont les memes operations (all, findById, delete). En les factorisant dans BaseRepository<T>, on ecrit le code une seule fois et on respecte le principe DRY (Don t Repeat Yourself). Moins de code = moins de bugs.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'mvc-controllers'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Pour rendre le code plus lent et plus complexe', false, 1),
    ('Parce que Java l exige pour toutes les collections', false, 2),
    ('Pour eviter la duplication de code entre MealRepository et CustomerRepository', true, 3),
    ('Pour securiser les donnees avec un chiffrement automatique', false, 4)
) AS opt(text, is_correct, order_index);
