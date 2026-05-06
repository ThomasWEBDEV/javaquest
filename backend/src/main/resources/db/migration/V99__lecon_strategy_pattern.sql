-- V99: Lecon 3 Design Patterns - Strategy Pattern + Quiz

-- =============================================
-- LECON 3 : Strategy Pattern
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Strategy Pattern',
    'strategy-pattern',
    E'STRATEGY PATTERN\n\nLe patron Strategy definit une famille d algorithmes, encapsule chacun d eux et les rend interchangeables. L algorithme peut ainsi varier independamment des clients qui l utilisent. C est l un des patrons les plus utilisés pour remplacer les cascades de if/else.\n\n---\n\nLE PROBLEME SANS STRATEGY\n\nSans ce patron, changer d algorithme oblige a modifier le code existant avec des conditions en cascade :\n\n  class Sorter {\n      public void sort(int[] data, String type) {\n          if (type.equals("bubble")) {\n              // algorithme bubble sort...\n          } else if (type.equals("quick")) {\n              // algorithme quick sort...\n          } else if (type.equals("merge")) {\n              // algorithme merge sort...\n          }\n          // ajouter un tri = modifier cette classe\n      }\n  }\n\nProbleme : viole le principe ouvert/ferme. Chaque nouvel algorithme gonfle la methode sort().\n\n---\n\nL INTERFACE STRATEGY\n\nOn extrait chaque algorithme derriere une interface commune :\n\n  // L interface commune a toutes les strategies\n  interface SortStrategy {\n      void sort(int[] data);\n  }\n\n  // Strategie 1 : tri a bulles\n  class BubbleSort implements SortStrategy {\n      public void sort(int[] data) {\n          // implementation bubble sort\n          System.out.println("Tri a bulles applique");\n      }\n  }\n\n  // Strategie 2 : tri rapide\n  class QuickSort implements SortStrategy {\n      public void sort(int[] data) {\n          // implementation quick sort\n          System.out.println("Tri rapide applique");\n      }\n  }\n\n---\n\nLE CONTEXT\n\nLe Context est la classe qui utilise la strategie. Il ne connait que l interface, pas les implementations concretes :\n\n  class Sorter {\n      private SortStrategy strategy;\n\n      // Injection par constructeur\n      public Sorter(SortStrategy strategy) {\n          this.strategy = strategy;\n      }\n\n      // Changement dynamique de strategie\n      public void setStrategy(SortStrategy strategy) {\n          this.strategy = strategy;\n      }\n\n      public void sort(int[] data) {\n          strategy.sort(data);   // delegation a la strategie\n      }\n  }\n\n  // Utilisation\n  int[] data = {5, 2, 8, 1, 9};\n\n  Sorter sorter = new Sorter(new BubbleSort());\n  sorter.sort(data);   // Tri a bulles applique\n\n  sorter.setStrategy(new QuickSort());\n  sorter.sort(data);   // Tri rapide applique\n\n---\n\nEXEMPLE COMPLET : SYSTEME DE PAIEMENT\n\n  // Interface Strategy\n  interface PaymentStrategy {\n      void pay(double amount);\n  }\n\n  // Strategies concretes\n  class CreditCardPayment implements PaymentStrategy {\n      private String cardNumber;\n      public CreditCardPayment(String cardNumber) {\n          this.cardNumber = cardNumber;\n      }\n      public void pay(double amount) {\n          System.out.println("Paiement de " + amount + " EUR par carte " + cardNumber);\n      }\n  }\n\n  class PaypalPayment implements PaymentStrategy {\n      private String email;\n      public PaypalPayment(String email) {\n          this.email = email;\n      }\n      public void pay(double amount) {\n          System.out.println("Paiement de " + amount + " EUR via PayPal " + email);\n      }\n  }\n\n  class CryptoPayment implements PaymentStrategy {\n      public void pay(double amount) {\n          System.out.println("Paiement de " + amount + " EUR en cryptomonnaie");\n      }\n  }\n\n  // Context : le panier d achat\n  class ShoppingCart {\n      private PaymentStrategy paymentStrategy;\n\n      public void setPaymentStrategy(PaymentStrategy strategy) {\n          this.paymentStrategy = strategy;\n      }\n\n      public void checkout(double total) {\n          paymentStrategy.pay(total);\n      }\n  }\n\n  // Utilisation : le client choisit son mode de paiement\n  ShoppingCart cart = new ShoppingCart();\n\n  cart.setPaymentStrategy(new CreditCardPayment("1234-5678"));\n  cart.checkout(59.99);\n  // Paiement de 59.99 EUR par carte 1234-5678\n\n  cart.setPaymentStrategy(new PaypalPayment("alice@mail.com"));\n  cart.checkout(25.00);\n  // Paiement de 25.0 EUR via PayPal alice@mail.com\n\n---\n\nSTRATEGY AVEC LAMBDAS\n\nSi l interface Strategy est fonctionnelle (une seule methode abstraite), on peut passer des lambdas directement :\n\n  @FunctionalInterface\n  interface DiscountStrategy {\n      double apply(double price);\n  }\n\n  class PriceCalculator {\n      private DiscountStrategy discount;\n\n      public PriceCalculator(DiscountStrategy discount) {\n          this.discount = discount;\n      }\n\n      public double calculate(double price) {\n          return discount.apply(price);\n      }\n  }\n\n  // Pas besoin de classes concretes : les lambdas font office de strategies\n  PriceCalculator noDiscount   = new PriceCalculator(price -> price);\n  PriceCalculator tenPercent   = new PriceCalculator(price -> price * 0.90);\n  PriceCalculator flatDiscount = new PriceCalculator(price -> price - 5.0);\n\n  System.out.println(noDiscount.calculate(100.0));   // 100.0\n  System.out.println(tenPercent.calculate(100.0));   // 90.0\n  System.out.println(flatDiscount.calculate(100.0)); // 95.0\n\n---\n\nPOURQUOI UTILISER STRATEGY ?\n\n- Elimine les if/else et switch en cascade lies a un algorithme\n- Ouvert a l extension : nouvelle strategie = nouvelle classe, aucun code existant modifie\n- Changement a l execution : le Context peut changer de strategie dynamiquement\n- Testabilite : chaque strategie est une classe isolee, facile a tester unitairement\n\n---\n\nBONNES PRATIQUES\n\n1. Interface : une seule methode, nommee avec un verbe d action (sort, pay, apply, format).\n2. Context : ne jamais caster la strategie vers une implementation concrete.\n3. Lambdas : privilegiez @FunctionalInterface si la strategie n a qu une seule methode.\n4. Injection : preferez l injection par constructeur a un setter si la strategie ne change pas.\n5. Ne pas abuser : si un seul algorithme existe, inutile de creer une interface Strategy.',
    3,
    40
FROM chapters c WHERE c.slug = 'design-patterns';

-- =============================================
-- QUIZ : Strategy Pattern
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Strategy Pattern',
    'Testez vos connaissances sur le patron Strategy, le Context, l interface fonctionnelle et l interchangeabilite des algorithmes',
    300, 70, 100
FROM lessons l WHERE l.slug = 'strategy-pattern';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel est le but principal du patron Strategy ?',
        'SINGLE_CHOICE',
        'Le Strategy Pattern definit une famille d algorithmes, encapsule chacun derriere une interface commune et les rend interchangeables. Le client (Context) peut ainsi changer d algorithme a l execution sans modifier son propre code.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'strategy-pattern'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Garantir qu une classe n a qu une seule instance', false, 1),
    ('Definir une famille d algorithmes interchangeables derriere une interface commune', true, 2),
    ('Notifier automatiquement des objets quand un etat change', false, 3),
    ('Construire des objets complexes etape par etape', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel role joue le "Context" dans le patron Strategy ?',
        'SINGLE_CHOICE',
        'Le Context est la classe qui possede une reference vers une Strategy et lui delegue le travail. Il connait seulement l interface Strategy, jamais les implementations concretes. Cela permet de changer l algorithme sans modifier le Context.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'strategy-pattern'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Il implemente tous les algorithmes en interne via des if/else', false, 1),
    ('Il herite de toutes les strategies pour en combiner les comportements', false, 2),
    ('Il possede une reference vers l interface Strategy et lui delegue l algorithme', true, 3),
    ('Il cree et detruit les strategies selon les besoins', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment changer d algorithme a l execution avec Strategy ?',
        'SINGLE_CHOICE',
        'Il suffit d appeler setStrategy(nouvelleStrategie) sur le Context. Puisque le Context travaille avec l interface, il suffit de lui passer une nouvelle implementation concrete sans modifier son code ni celui des autres strategies.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'strategy-pattern'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('En creant un nouveau Context avec l algorithme souhaite', false, 1),
    ('En modifiant l implementation concrete de la strategie actuelle', false, 2),
    ('En appelant setStrategy() avec une nouvelle implementation concrete', true, 3),
    ('En faisant heriter le Context d une nouvelle classe Strategy', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel probleme Strategy resout-il principalement ?',
        'SINGLE_CHOICE',
        'Strategy elimine les cascades de if/else ou switch qui grandissent a chaque nouvel algorithme. Chaque variante devient une classe independante, et le Context choisit laquelle utiliser sans connaitre les details d implementation.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'strategy-pattern'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Les fuites memoire causees par trop d objets crees', false, 1),
    ('Les cascades de if/else qui grandissent a chaque nouvel algorithme', true, 2),
    ('Les problemes de synchronisation dans les applications multi-threads', false, 3),
    ('La duplication de code entre classes qui partagent un heritage', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quand peut-on utiliser une lambda comme Strategy ?',
        'SINGLE_CHOICE',
        'Une lambda peut remplacer une classe concrete uniquement si l interface Strategy est fonctionnelle (@FunctionalInterface), c est-a-dire qu elle n a qu une seule methode abstraite. Cela evite de creer une classe entiere pour une logique simple.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'strategy-pattern'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Toujours, quelle que soit l interface Strategy', false, 1),
    ('Uniquement si l interface Strategy est annotee @FunctionalInterface et n a qu une methode abstraite', true, 2),
    ('Uniquement si la methode retourne void', false, 3),
    ('Jamais, les lambdas ne sont pas compatibles avec Strategy', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle bonne pratique s applique au Context avec Strategy ?',
        'SINGLE_CHOICE',
        'Le Context ne doit jamais caster la strategie vers une implementation concrete (instanceof, cast). Il doit toujours travailler via l interface. Caster briserait le decouplage et rendrait le Context dependant d une implementation specifique.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'strategy-pattern'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Le Context doit creer lui-meme toutes les strategies dont il a besoin', false, 1),
    ('Le Context doit toujours utiliser un switch pour choisir la bonne strategie', false, 2),
    ('Le Context ne doit jamais caster la strategie vers une implementation concrete', true, 3),
    ('Le Context doit avoir autant de methodes que de strategies possibles', false, 4)
) AS opt(text, is_correct, order_index);
