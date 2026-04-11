-- V19: Lecon Heritage et Polymorphisme + Quiz

-- =============================================
-- LECON 2 : Heritage et Polymorphisme
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Heritage et Polymorphisme',
    'heritage-polymorphisme',
    E'HERITAGE ET POLYMORPHISME EN JAVA\n\nL heritage est un mecanisme fondamental de la POO qui permet a une classe de reutiliser les attributs et methodes d une autre classe. Il favorise la reutilisation du code et organise les classes en hierarchies logiques.\n\n---\n\nLE MOT-CLE EXTENDS\n\nPour creer une classe qui herite d une autre, on utilise extends :\n\n  // Classe parente (superclasse)\n  public class Animal {\n      String nom;\n      int age;\n\n      public Animal(String nom, int age) {\n          this.nom = nom;\n          this.age = age;\n      }\n\n      public void manger() {\n          System.out.println(nom + " mange.");\n      }\n\n      public String toString() {\n          return nom + " (age: " + age + ")";\n      }\n  }\n\n  // Classe enfant (sous-classe)\n  public class Chien extends Animal {\n      String race;\n\n      public Chien(String nom, int age, String race) {\n          super(nom, age); // Appelle le constructeur de Animal\n          this.race = race;\n      }\n\n      public void aboyer() {\n          System.out.println(nom + " dit : Ouaf !");\n      }\n  }\n\n  // Utilisation\n  Chien rex = new Chien("Rex", 3, "Labrador");\n  rex.manger();   // Heritage de Animal : "Rex mange."\n  rex.aboyer();   // Methode propre a Chien : "Rex dit : Ouaf !"\n\nLa sous-classe herite automatiquement de tous les attributs et methodes publics (et proteges) de la classe parente.\n\n---\n\nLE MOT-CLE SUPER\n\nsuper permet d acceder aux membres de la classe parente. Il a deux usages :\n\n  1. super() dans le constructeur : appelle le constructeur parent (doit etre la premiere instruction)\n\n  public class Chien extends Animal {\n      String race;\n\n      public Chien(String nom, int age, String race) {\n          super(nom, age); // OBLIGATOIRE en premier\n          this.race = race;\n      }\n  }\n\n  2. super.methode() : appelle une methode de la classe parente\n\n  public class Chien extends Animal {\n      @Override\n      public String toString() {\n          return super.toString() + " - Race: " + race;\n          // Reutilise toString() de Animal et ajoute la race\n      }\n  }\n\n  Chien rex = new Chien("Rex", 3, "Labrador");\n  System.out.println(rex); // "Rex (age: 3) - Race: Labrador"\n\nSi vous n appelez pas super() explicitement, Java appelle super() sans argument. Si la classe parente n a pas de constructeur sans argument, l appel a super() avec arguments est obligatoire.\n\n---\n\nREDEFINITION DE METHODES (@Override)\n\nUne sous-classe peut redefinir une methode heritee pour lui donner un comportement specifique :\n\n  public class Animal {\n      String nom;\n      public Animal(String nom) { this.nom = nom; }\n\n      public String parler() {\n          return nom + " fait un bruit.";\n      }\n  }\n\n  public class Chat extends Animal {\n      public Chat(String nom) { super(nom); }\n\n      @Override\n      public String parler() {\n          return nom + " dit : Miaou !";\n      }\n  }\n\n  public class Chien extends Animal {\n      public Chien(String nom) { super(nom); }\n\n      @Override\n      public String parler() {\n          return nom + " dit : Ouaf !";\n      }\n  }\n\n  System.out.println(new Animal("A").parler()); // A fait un bruit.\n  System.out.println(new Chat("Felix").parler()); // Felix dit : Miaou !\n  System.out.println(new Chien("Rex").parler());  // Rex dit : Ouaf !\n\nL annotation @Override est optionnelle mais fortement recommandee : elle permet au compilateur de detecter les fautes de frappe dans le nom de la methode.\n\n---\n\nLE POLYMORPHISME\n\nLe polymorphisme (plusieurs formes) permet de traiter des objets de types differents via leur type commun parent :\n\n  Animal monAnimal = new Chien("Rex"); // Variable de type Animal, objet de type Chien\n  System.out.println(monAnimal.parler()); // "Rex dit : Ouaf !" (methode de Chien executee)\n\nLe type de reference determine les methodes accessibles.\nLe type reel de l objet determine quelle version est executee.\n\nCela permet de traiter des collections heterogenes de maniere uniforme :\n\n  Animal[] animaux = {\n      new Chat("Felix"),\n      new Chien("Rex"),\n      new Chat("Whiskers"),\n      new Chien("Milou")\n  };\n\n  for (Animal a : animaux) {\n      System.out.println(a.parler()); // Appelle automatiquement la bonne methode\n  }\n  // Felix dit : Miaou !\n  // Rex dit : Ouaf !\n  // Whiskers dit : Miaou !\n  // Milou dit : Ouaf !\n\n---\n\nL OPERATEUR INSTANCEOF\n\ninstanceof verifie le type reel d un objet :\n\n  Animal a = new Chien("Rex");\n\n  System.out.println(a instanceof Animal); // true (Chien est un Animal)\n  System.out.println(a instanceof Chien);  // true\n  System.out.println(a instanceof Chat);   // false\n\n  // Cast explicite apres verification\n  if (a instanceof Chien) {\n      Chien chien = (Chien) a;\n      chien.aboyer(); // Methode specifique a Chien, non accessible via Animal\n  }\n\n---\n\nREGLES D HERITAGE EN JAVA\n\n  1. Heritage simple uniquement : une classe ne peut etendre qu une seule classe parente.\n  2. Toutes les classes heritent de Object : Object est la racine de la hierarchie Java.\n  3. Constructeurs non herites : il faut les redefinir dans chaque sous-classe.\n  4. Membres private inaccessibles : la sous-classe ne peut pas acceder directement aux membres private du parent (utiliser des getters).\n\nLa prochaine lecon explorera les classes abstraites et les interfaces, qui poussent encore plus loin le polymorphisme.',
    2,
    40
FROM chapters c WHERE c.slug = 'poo-bases';

-- =============================================
-- QUIZ : Heritage et Polymorphisme
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Heritage et Polymorphisme',
    'Testez vos connaissances sur l heritage, super, @Override et le polymorphisme',
    300, 70, 100
FROM lessons l WHERE l.slug = 'heritage-polymorphisme';

-- Question 1 : extends
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel mot-cle Java permet a une classe d heriter d une autre ?',
        'SINGLE_CHOICE',
        'Le mot-cle extends est utilise pour declarer l heritage : "class Chien extends Animal" signifie que Chien herite de tous les attributs et methodes publics (et proteges) de Animal. Java ne supporte pas l heritage multiple : une classe ne peut etendre qu une seule classe parente.',
        1
    FROM quizzes qz WHERE qz.title = 'Quiz - Heritage et Polymorphisme'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'inherits', false, 1 FROM q
UNION ALL SELECT q.id, 'extends', true, 2 FROM q
UNION ALL SELECT q.id, 'implements', false, 3 FROM q
UNION ALL SELECT q.id, 'super', false, 4 FROM q;

-- Question 2 : super()
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Dans un constructeur de sous-classe, que fait l appel super(arguments) ?',
        'SINGLE_CHOICE',
        'super(arguments) appelle le constructeur de la classe parente avec les arguments specifies. Cet appel doit obligatoirement etre la premiere instruction du constructeur. Il permet d initialiser la partie "parente" de l objet avant d initialiser les attributs specifiques a la sous-classe.',
        2
    FROM quizzes qz WHERE qz.title = 'Quiz - Heritage et Polymorphisme'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Il cree un nouvel objet de la classe parente', false, 1 FROM q
UNION ALL SELECT q.id, 'Il appelle le constructeur de la classe parente', true, 2 FROM q
UNION ALL SELECT q.id, 'Il remplace le constructeur de la sous-classe', false, 3 FROM q
UNION ALL SELECT q.id, 'Il est appele automatiquement, inutile de l ecrire', false, 4 FROM q;

-- Question 3 : @Override
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'A quoi sert l annotation @Override sur une methode ?',
        'SINGLE_CHOICE',
        '@Override indique au compilateur que la methode redefinie une methode de la classe parente. Si la methode n existe pas dans la classe parente (ex : faute de frappe), le compilateur genere une erreur. C est une bonne pratique qui rend le code plus clair et evite les bugs silencieux.',
        3
    FROM quizzes qz WHERE qz.title = 'Quiz - Heritage et Polymorphisme'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Elle est obligatoire pour redefinir une methode', false, 1 FROM q
UNION ALL SELECT q.id, 'Elle indique que la methode est finale et ne peut plus etre redefinie', false, 2 FROM q
UNION ALL SELECT q.id, 'Elle signale au compilateur qu on redefinie une methode parente et permet de detecter les erreurs', true, 3 FROM q
UNION ALL SELECT q.id, 'Elle rend la methode inaccessible depuis l exterieur', false, 4 FROM q;

-- Question 4 : polymorphisme
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Avec Animal a = new Chien("Rex"), que se passe-t-il quand on appelle a.parler() ?',
        'SINGLE_CHOICE',
        'C est le polymorphisme en action : meme si la variable a est de type Animal, l objet reel est un Chien. Java execute donc la version de parler() definie dans Chien, pas celle de Animal. Le type de reference (Animal) determine les methodes accessibles, mais le type reel (Chien) determine quelle version s execute.',
        4
    FROM quizzes qz WHERE qz.title = 'Quiz - Heritage et Polymorphisme'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'La version de parler() de Animal est executee', false, 1 FROM q
UNION ALL SELECT q.id, 'Une erreur est generee car le type ne correspond pas', false, 2 FROM q
UNION ALL SELECT q.id, 'La version de parler() de Chien est executee (polymorphisme)', true, 3 FROM q
UNION ALL SELECT q.id, 'Java choisit aleatoirement quelle version executer', false, 4 FROM q;

-- Question 5 : instanceof
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Si Chien extends Animal, que retourne "new Chien("Rex") instanceof Animal" ?',
        'SINGLE_CHOICE',
        'instanceof retourne true car un Chien EST un Animal (relation d heritage). La relation d heritage est une relation "est-un" : tout Chien est un Animal, donc instanceof Animal retourne true. En revanche, tout Animal n est pas forcement un Chien, donc "new Animal("X") instanceof Chien" retournerait false.',
        5
    FROM quizzes qz WHERE qz.title = 'Quiz - Heritage et Polymorphisme'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'false, car Chien et Animal sont des classes differentes', false, 1 FROM q
UNION ALL SELECT q.id, 'true, car un Chien est aussi un Animal', true, 2 FROM q
UNION ALL SELECT q.id, 'Une erreur de compilation', false, 3 FROM q
UNION ALL SELECT q.id, 'null', false, 4 FROM q;

-- Question 6 : heritage multiple
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Combien de classes parentes une classe Java peut-elle etendre avec extends ?',
        'SINGLE_CHOICE',
        'Java ne supporte pas l heritage multiple de classes : une classe ne peut etendre qu UNE SEULE classe parente avec extends. Cela evite le probleme du diamant (ambiguite quand deux classes parentes ont la meme methode). Java offre les interfaces pour simuler l heritage multiple de comportements.',
        6
    FROM quizzes qz WHERE qz.title = 'Quiz - Heritage et Polymorphisme'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Autant que souhaite', false, 1 FROM q
UNION ALL SELECT q.id, 'Deux au maximum', false, 2 FROM q
UNION ALL SELECT q.id, 'Une seule classe parente', true, 3 FROM q
UNION ALL SELECT q.id, 'Aucune, l heritage n existe pas en Java', false, 4 FROM q;
