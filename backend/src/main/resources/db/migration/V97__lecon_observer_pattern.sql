-- V97: Lecon 2 Design Patterns - Observer Pattern + Quiz

-- =============================================
-- LECON 2 : Observer Pattern
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Observer Pattern',
    'observer-pattern',
    E'OBSERVER PATTERN\n\nLe patron Observer (Observateur) definit une relation un-a-plusieurs entre objets : quand un objet change d etat, tous ses observateurs sont notifies automatiquement. C est la base des systemes evenementiels et des interfaces reactives.\n\n---\n\nLE PROBLEME SANS OBSERVER\n\nSans ce patron, les composants doivent se demander mutuellement s il y a du nouveau. C est le "polling" : inefficace et tres couple.\n\n  // Mauvaise approche : couplage fort, le sujet connait tout le monde\n  class TemperatureSensor {\n      private NewsApp news;\n      private WeatherDisplay display;\n\n      public void updateTemp(double temp) {\n          news.onTempChange(temp);      // couplage direct\n          display.onTempChange(temp);   // couplage direct\n      }\n  }\n\nProblematiuqe : si on ajoute un 3eme abonne, il faut modifier TemperatureSensor.\n\n---\n\nLES INTERFACES DE BASE\n\n  // L observateur : sait reagir a une notification\n  interface Observer {\n      void update(String event, Object data);\n  }\n\n  // Le sujet : gere sa liste d observateurs\n  interface Subject {\n      void addObserver(Observer o);\n      void removeObserver(Observer o);\n      void notifyObservers(String event, Object data);\n  }\n\n---\n\nIMPLEMENTATION COMPLETE\n\n  import java.util.ArrayList;\n  import java.util.List;\n\n  // Le sujet concret : une station meteo\n  class WeatherStation implements Subject {\n      private List<Observer> observers = new ArrayList<>();\n      private double temperature;\n\n      public void addObserver(Observer o) {\n          observers.add(o);\n      }\n\n      public void removeObserver(Observer o) {\n          observers.remove(o);\n      }\n\n      public void notifyObservers(String event, Object data) {\n          for (Observer o : observers) {\n              o.update(event, data);\n          }\n      }\n\n      public void setTemperature(double temp) {\n          this.temperature = temp;\n          notifyObservers("temperature", temp);  // notification automatique\n      }\n  }\n\n  // Observateur 1 : affiche la temperature\n  class DisplayPanel implements Observer {\n      private String name;\n      public DisplayPanel(String name) { this.name = name; }\n\n      public void update(String event, Object data) {\n          System.out.println("[" + name + "] " + event + " : " + data + " C");\n      }\n  }\n\n  // Observateur 2 : envoie une alerte si temp elevee\n  class AlertSystem implements Observer {\n      public void update(String event, Object data) {\n          double temp = (Double) data;\n          if (temp > 35.0) {\n              System.out.println("[ALERTE] Temperature critique : " + temp + " C !");\n          }\n      }\n  }\n\n  // Utilisation\n  WeatherStation station = new WeatherStation();\n  station.addObserver(new DisplayPanel("Ecran principal"));\n  station.addObserver(new DisplayPanel("Ecran secondaire"));\n  station.addObserver(new AlertSystem());\n\n  station.setTemperature(22.5);\n  // [Ecran principal] temperature : 22.5 C\n  // [Ecran secondaire] temperature : 22.5 C\n\n  station.setTemperature(38.0);\n  // [Ecran principal] temperature : 38.0 C\n  // [Ecran secondaire] temperature : 38.0 C\n  // [ALERTE] Temperature critique : 38.0 C !\n\n---\n\nAJOUT ET SUPPRESSION D OBSERVATEURS\n\nL un des grands avantages de l Observer est qu on peut brancher ou debrancher des observateurs sans toucher au sujet.\n\n  DisplayPanel ecran = new DisplayPanel("Ecran mobile");\n  station.addObserver(ecran);\n  station.setTemperature(25.0);    // ecran recoit la notif\n\n  station.removeObserver(ecran);\n  station.setTemperature(30.0);    // ecran ne recoit plus rien\n\n---\n\nOBSERVER SIMPLIFIE AVEC LAMBDAS\n\nEn Java moderne, si Observer est une interface fonctionnelle, on peut utiliser des lambdas :\n\n  @FunctionalInterface\n  interface SimpleObserver {\n      void onEvent(String message);\n  }\n\n  class EventBus {\n      private List<SimpleObserver> listeners = new ArrayList<>();\n\n      public void subscribe(SimpleObserver listener) { listeners.add(listener); }\n\n      public void publish(String message) {\n          for (SimpleObserver l : listeners) l.onEvent(message);\n      }\n  }\n\n  EventBus bus = new EventBus();\n  bus.subscribe(msg -> System.out.println("Logger: " + msg));\n  bus.subscribe(msg -> System.out.println("Analytics: " + msg));\n  bus.publish("UserConnecte");  // les deux lambdas sont notifiees\n\n---\n\nPOURQUOI UTILISER OBSERVER ?\n\n- Decouplage total : le sujet ne connait pas les classes concretes des observateurs\n- Ouvert a l extension : ajouter un nouvel observateur sans modifier le sujet\n- Notification automatique : les observateurs sont informes des que l etat change\n- Base de nombreux frameworks : Swing listeners, Spring events, RxJava\n\n---\n\nBONNES PRATIQUES\n\n1. Observer : interface avec une seule methode update() claire.\n2. Subject : toujours passer par addObserver/removeObserver, jamais manipuler la liste directement.\n3. notifyObservers() : parcourez une copie de la liste pour eviter les ConcurrentModificationException.\n4. Ne pas abuser : si un seul objet observe, un appel direct suffit.\n5. Lambdas : utilisez @FunctionalInterface pour des observateurs simples et lisibles.',
    2,
    40
FROM chapters c WHERE c.slug = 'design-patterns';

-- =============================================
-- QUIZ : Observer Pattern
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Observer Pattern',
    'Testez vos connaissances sur le patron Observer, les interfaces Subject et Observer, et la notification automatique',
    300, 70, 100
FROM lessons l WHERE l.slug = 'observer-pattern';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle relation le patron Observer definit-il ?',
        'SINGLE_CHOICE',
        'Le patron Observer definit une relation un-a-plusieurs : un sujet unique peut avoir plusieurs observateurs. Quand le sujet change d etat, tous ses observateurs sont notifies automatiquement via leur methode update().',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'observer-pattern'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Une relation un-a-un entre deux objets', false, 1),
    ('Une relation un-a-plusieurs entre un sujet et ses observateurs', true, 2),
    ('Une relation plusieurs-a-plusieurs entre classes egales', false, 3),
    ('Une relation d heritage entre une classe parent et ses sous-classes', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que fait la methode notifyObservers() dans le sujet ?',
        'SINGLE_CHOICE',
        'notifyObservers() parcourt la liste des observateurs enregistres et appelle update() sur chacun d eux. C est le mecanisme central qui permet la notification automatique de tous les abonnes quand le sujet change.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'observer-pattern'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Elle supprime tous les observateurs de la liste', false, 1),
    ('Elle demande a chaque observateur s il veut etre notifie', false, 2),
    ('Elle appelle update() sur chaque observateur enregistre', true, 3),
    ('Elle cree de nouveaux observateurs automatiquement', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel est le principal avantage de l Observer par rapport au couplage direct ?',
        'SINGLE_CHOICE',
        'Avec l Observer, le sujet ne connait pas les classes concretes des observateurs, seulement l interface Observer. Cela permet d ajouter, supprimer ou modifier des observateurs sans jamais toucher au code du sujet (principe ouvert/ferme).',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'observer-pattern'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Il est plus rapide car il utilise des threads', false, 1),
    ('Le sujet est decouple des classes concretes des observateurs', true, 2),
    ('Il empeche les observateurs de modifier le sujet', false, 3),
    ('Il garantit que les observateurs sont thread-safe', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment ajouter un nouvel observateur a un WeatherStation existant ?',
        'SINGLE_CHOICE',
        'On appelle addObserver(o) sur l instance du sujet. La liste interne est mise a jour, et le nouvel observateur recevra toutes les prochaines notifications. C est dynamique : pas besoin de modifier le code de WeatherStation.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'observer-pattern'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('En modifiant le code source de WeatherStation pour ajouter un champ', false, 1),
    ('En appelant station.addObserver(monObservateur)', true, 2),
    ('En heritant de WeatherStation et en surchargeant notifyObservers()', false, 3),
    ('En remplacant l interface Observer par une classe abstraite', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Qu est-ce qu une interface fonctionnelle @FunctionalInterface apporte a Observer ?',
        'SINGLE_CHOICE',
        'Une interface fonctionnelle avec une seule methode abstraite peut etre implementee par une lambda en Java. Cela evite de creer une classe anonyme ou une classe entiere : on passe directement msg -> System.out.println(msg) comme observateur.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'observer-pattern'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Elle rend l interface thread-safe automatiquement', false, 1),
    ('Elle permet d implementer l observateur avec une lambda', true, 2),
    ('Elle impose que l interface ait exactement deux methodes', false, 3),
    ('Elle optimise automatiquement les performances de notification', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel probleme peut survenir si notifyObservers() parcourt directement la liste pendant qu un observateur se desabonne ?',
        'SINGLE_CHOICE',
        'Si un observateur appelle removeObserver() dans son update(), il modifie la liste pendant qu on l itere : c est une ConcurrentModificationException. La solution est de parcourir une copie de la liste : new ArrayList<>(observers).',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'observer-pattern'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Un StackOverflowError car update() rappelle notifyObservers()', false, 1),
    ('Un NullPointerException car l observateur est null apres remove()', false, 2),
    ('Une ConcurrentModificationException si la liste est modifiee pendant l iteration', true, 3),
    ('Un OutOfMemoryError car trop d observateurs sont crees en memoire', false, 4)
) AS opt(text, is_correct, order_index);
