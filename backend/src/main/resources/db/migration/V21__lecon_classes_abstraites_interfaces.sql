-- V21: Lecon Classes Abstraites et Interfaces + Quiz

-- =============================================
-- LECON 3 : Classes Abstraites et Interfaces
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Classes Abstraites et Interfaces',
    'classes-abstraites-interfaces',
    E'CLASSES ABSTRAITES ET INTERFACES EN JAVA\n\nLes classes abstraites et les interfaces permettent de definir des contrats : des methodes que les sous-classes DOIVENT obligatoirement implementer. Ce sont des outils puissants pour organiser et securiser vos hierarchies de classes.\n\n---\n\nLE PROBLEME SANS CLASSES ABSTRAITES\n\nSans contrainte, rien n oblige une sous-classe a redefinir une methode :\n\n  class Forme {\n      double aire() {\n          return 0; // Valeur sans sens par defaut\n      }\n  }\n\n  class Carre extends Forme {\n      double cote;\n      Carre(double cote) { this.cote = cote; }\n      // On peut oublier de redefinir aire() !\n  }\n\n  Carre c = new Carre(5);\n  System.out.println(c.aire()); // 0 au lieu de 25 !\n\nLes classes abstraites resolvent ce probleme.\n\n---\n\nLA CLASSE ABSTRAITE\n\nUne classe abstraite (mot-cle abstract) ne peut pas etre instanciee directement. Elle peut contenir des methodes abstraites (sans corps) que chaque sous-classe concrete doit implementer :\n\n  abstract class Forme {\n      String couleur;\n\n      Forme(String couleur) {\n          this.couleur = couleur;\n      }\n\n      // Methode abstraite : pas de corps, implementation obligatoire\n      abstract double aire();\n\n      // Methode concrete : comportement commun partage\n      void afficher() {\n          System.out.println(couleur + " - aire : " + aire());\n      }\n  }\n\n  class Carre extends Forme {\n      double cote;\n\n      Carre(double cote, String couleur) {\n          super(couleur);\n          this.cote = cote;\n      }\n\n      @Override\n      double aire() {\n          return cote * cote; // OBLIGATOIRE sous peine d erreur de compilation\n      }\n  }\n\n  class Cercle extends Forme {\n      double rayon;\n\n      Cercle(double rayon, String couleur) {\n          super(couleur);\n          this.rayon = rayon;\n      }\n\n      @Override\n      double aire() {\n          return 3.14 * rayon * rayon;\n      }\n  }\n\n  // Utilisation\n  Forme f1 = new Carre(4, "rouge");\n  Forme f2 = new Cercle(3, "bleu");\n  // new Forme("vert"); // ERREUR : classe abstraite non instanciable !\n\n  f1.afficher(); // rouge - aire : 16.0\n  f2.afficher(); // bleu - aire : 28.26\n\nSi une sous-classe concrete n implemente pas toutes les methodes abstraites, le compilateur genere une erreur immediate.\n\n---\n\nL INTERFACE\n\nUne interface est un contrat pur : elle ne contient que des signatures de methodes (pas de corps, pas de champs d instance). Toute classe qui l implements doit fournir une implementation pour chaque methode :\n\n  interface Salutable {\n      String saluer(); // public abstract par defaut\n  }\n\n  class Francais implements Salutable {\n      String nom;\n      Francais(String nom) { this.nom = nom; }\n\n      @Override\n      public String saluer() {\n          return "Bonjour, je suis " + nom + " !";\n      }\n  }\n\n  class Anglais implements Salutable {\n      String nom;\n      Anglais(String nom) { this.nom = nom; }\n\n      @Override\n      public String saluer() {\n          return "Hello, I am " + nom + " !";\n      }\n  }\n\n  // Polymorphisme via interface\n  Salutable[] personnes = { new Francais("Alice"), new Anglais("Bob") };\n  for (Salutable p : personnes) {\n      System.out.println(p.saluer());\n  }\n  // Bonjour, je suis Alice !\n  // Hello, I am Bob !\n\nToute classe qui n implemente pas toutes les methodes d une interface doit etre declaree abstract.\n\n---\n\nHERITAGE MULTIPLE AVEC LES INTERFACES\n\nUne classe ne peut etendre qu une seule classe, mais peut implementer PLUSIEURS interfaces separees par des virgules :\n\n  interface Nageable {\n      void nager();\n  }\n\n  interface Volable {\n      void voler();\n  }\n\n  class Canard extends Animal implements Nageable, Volable {\n      Canard(String nom) { super(nom); }\n\n      @Override\n      public void nager() { System.out.println(nom + " nage."); }\n\n      @Override\n      public void voler() { System.out.println(nom + " vole."); }\n  }\n\n  Canard donald = new Canard("Donald");\n  donald.nager(); // Donald nage.\n  donald.voler(); // Donald vole.\n\n  System.out.println(donald instanceof Nageable); // true\n  System.out.println(donald instanceof Volable);  // true\n\nSyntaxe : class MaClasse extends Parent implements Interface1, Interface2, Interface3\n\n---\n\nCLASSE ABSTRAITE vs INTERFACE\n\nClasse abstraite :\n  - Peut avoir des champs d instance (String nom, int age...)\n  - Peut avoir des constructeurs\n  - Peut avoir des methodes concretes (avec corps)\n  - Une classe ne peut etendre qu UNE SEULE classe abstraite\n  - A utiliser quand les sous-classes partagent un etat commun\n\nInterface :\n  - Pas de champs d instance (seulement des constantes static final)\n  - Pas de constructeurs\n  - Seulement des methodes abstraites (avant Java 8)\n  - Une classe peut implementer PLUSIEURS interfaces\n  - A utiliser pour definir un comportement pur sans etat partage\n\nLa prochaine lecon explorera l encapsulation avancee : private, getters et setters.',
    3,
    40
FROM chapters c WHERE c.slug = 'poo-bases';

-- =============================================
-- QUIZ : Classes Abstraites et Interfaces
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Classes Abstraites et Interfaces',
    'Testez vos connaissances sur abstract, interface et implements',
    300, 70, 100
FROM lessons l WHERE l.slug = 'classes-abstraites-interfaces';

-- Question 1 : mot-cle abstract
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel mot-cle Java permet de declarer une classe comme abstraite ?',
        'SINGLE_CHOICE',
        'Le mot-cle abstract place avant class declare une classe abstraite : "abstract class Forme". Une classe abstraite ne peut pas etre instanciee directement avec new. Elle peut contenir des methodes abstraites sans corps (juste la signature) que les sous-classes concretes doivent implementer obligatoirement.',
        1
    FROM quizzes qz WHERE qz.title = 'Quiz - Classes Abstraites et Interfaces'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'final', false, 1 FROM q
UNION ALL SELECT q.id, 'abstract', true, 2 FROM q
UNION ALL SELECT q.id, 'interface', false, 3 FROM q
UNION ALL SELECT q.id, 'static', false, 4 FROM q;

-- Question 2 : instanciation classe abstraite
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Peut-on creer une instance directe d une classe abstraite avec new ?',
        'SINGLE_CHOICE',
        'Non, une classe abstraite ne peut jamais etre instanciee directement. Ecrire "new Forme()" genere une erreur de compilation si Forme est abstraite. On peut uniquement instancier ses sous-classes concretes qui implementent toutes les methodes abstraites. En revanche, la variable peut etre de type abstrait : "Forme f = new Carre(4)" est tout a fait valide.',
        2
    FROM quizzes qz WHERE qz.title = 'Quiz - Classes Abstraites et Interfaces'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Oui, comme n importe quelle classe', false, 1 FROM q
UNION ALL SELECT q.id, 'Oui, si elle possede un constructeur public', false, 2 FROM q
UNION ALL SELECT q.id, 'Non, une classe abstraite ne peut pas etre instanciee', true, 3 FROM q
UNION ALL SELECT q.id, 'Cela depend du compilateur utilise', false, 4 FROM q;

-- Question 3 : implements
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel mot-cle une classe utilise-t-elle pour implementer une interface ?',
        'SINGLE_CHOICE',
        'Le mot-cle implements est utilise pour implementer une interface : "class Francais implements Salutable". Le mot-cle extends est reserve pour l heritage de classe. Une classe peut utiliser les deux : "class Canard extends Animal implements Nageable, Volable" est valide.',
        3
    FROM quizzes qz WHERE qz.title = 'Quiz - Classes Abstraites et Interfaces'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'extends', false, 1 FROM q
UNION ALL SELECT q.id, 'abstract', false, 2 FROM q
UNION ALL SELECT q.id, 'implements', true, 3 FROM q
UNION ALL SELECT q.id, 'inherits', false, 4 FROM q;

-- Question 4 : nombre d interfaces
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Combien d interfaces une classe Java peut-elle implementer simultanement ?',
        'SINGLE_CHOICE',
        'Une classe peut implementer autant d interfaces que necessaire, separees par des virgules : "class Canard extends Animal implements Nageable, Volable, Bruyant". C est la facon dont Java permet l heritage multiple de comportements. Java interdit en revanche l heritage multiple de classes : une seule classe parente est autorisee avec extends.',
        4
    FROM quizzes qz WHERE qz.title = 'Quiz - Classes Abstraites et Interfaces'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Une seule interface', false, 1 FROM q
UNION ALL SELECT q.id, 'Deux au maximum', false, 2 FROM q
UNION ALL SELECT q.id, 'Autant que necessaire, separees par des virgules', true, 3 FROM q
UNION ALL SELECT q.id, 'Aucune si elle etend deja une classe', false, 4 FROM q;

-- Question 5 : difference abstraite vs interface
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la principale difference entre une classe abstraite et une interface ?',
        'SINGLE_CHOICE',
        'La principale difference : une classe abstraite peut avoir des champs d instance (String nom, int age...) et des constructeurs, ce qui lui permet de partager un etat entre ses sous-classes. Une interface ne peut avoir que des constantes (static final) et pas de constructeurs. Regle pratique : classe abstraite pour partager un etat commun, interface pour definir un comportement pur.',
        5
    FROM quizzes qz WHERE qz.title = 'Quiz - Classes Abstraites et Interfaces'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Une interface peut etre instanciee, pas la classe abstraite', false, 1 FROM q
UNION ALL SELECT q.id, 'Une classe abstraite peut avoir des champs d instance, une interface non', true, 2 FROM q
UNION ALL SELECT q.id, 'Une interface utilise extends, une classe abstraite utilise implements', false, 3 FROM q
UNION ALL SELECT q.id, 'Il n y a aucune difference fonctionnelle', false, 4 FROM q;

-- Question 6 : obligation d implementation
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Qu arrive-t-il si une classe concrete n implemente pas toutes les methodes abstraites de sa classe parente ?',
        'SINGLE_CHOICE',
        'Le compilateur Java refuse de compiler le code et genere une erreur. C est precisement l avantage des methodes abstraites : le compilateur garantit que toutes les sous-classes concretes implementent les methodes requises. Si une sous-classe ne peut pas implementer toutes les methodes abstraites, elle doit elle-meme etre declaree abstract.',
        6
    FROM quizzes qz WHERE qz.title = 'Quiz - Classes Abstraites et Interfaces'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'La methode retourne null automatiquement', false, 1 FROM q
UNION ALL SELECT q.id, 'Une exception NullPointerException est lancee a l execution', false, 2 FROM q
UNION ALL SELECT q.id, 'Le compilateur refuse de compiler le code', true, 3 FROM q
UNION ALL SELECT q.id, 'La sous-classe devient automatiquement abstraite', false, 4 FROM q;
