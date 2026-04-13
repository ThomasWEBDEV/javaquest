-- V27: Lecon Concepts Avances (static, final, toString, equals) + Quiz

-- =============================================
-- LECON 5 : Concepts Avances
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Concepts Avances : static, final et equals',
    'concepts-avances',
    E'CONCEPTS AVANCES EN JAVA : STATIC, FINAL ET EQUALS\n\nCette lecon couvre des outils essentiels : les membres statiques partages entre toutes les instances, les constantes inmodifiables, et les methodes toString() et equals() pour mieux exploiter vos objets.\n\n---\n\nLE MOT-CLE STATIC\n\nUn champ ou une methode static appartient a la CLASSE, pas a une instance particuliere. Toutes les instances partagent la meme valeur du champ static :\n\n  class CompteurObjets {\n      private String nom;\n      private static int count = 0;  // Partage entre toutes les instances\n\n      CompteurObjets(String nom) {\n          this.nom = nom;\n          count++;  // Incremente a chaque creation\n      }\n\n      public String getNom() { return nom; }\n\n      public static int getCount() {  // Methode de classe\n          return count;\n      }\n  }\n\n  System.out.println(CompteurObjets.getCount()); // 0\n\n  CompteurObjets o1 = new CompteurObjets("Bureau");\n  CompteurObjets o2 = new CompteurObjets("Chaise");\n\n  System.out.println(CompteurObjets.getCount()); // 2\n\nLes methodes static s appellent sur la classe directement : Math.abs(-5), Integer.parseInt("42").\n\nCas d utilisation courants :\n  - Compteurs et identifiants uniques\n  - Methodes utilitaires independantes d une instance\n  - Constantes partagees\n\n---\n\nLE MOT-CLE FINAL\n\nfinal empeche la modification d une variable apres son initialisation. Avec static, il cree une constante de classe :\n\n  class Mathematiques {\n      static final double PI = 3.14159;\n      static final int JOURS_SEMAINE = 7;\n  }\n\n  System.out.println(Mathematiques.PI);            // 3.14159\n  System.out.println(Mathematiques.JOURS_SEMAINE); // 7\n  // Mathematiques.PI = 3.0; // ERREUR de compilation !\n\nConvention : les constantes static final s ecrivent en MAJUSCULES avec des underscores.\n\nfinal s applique aussi aux variables locales et parametres :\n\n  void calculer(final int valeur) {\n      final int resultat = valeur * 2;\n      // valeur = 10;    // ERREUR : parametre final\n      // resultat = 20;  // ERREUR : variable locale finale\n      System.out.println(resultat);\n  }\n\n---\n\nLA METHODE TOSTRING()\n\nQuand vous affichez un objet avec System.out.println(), Java appelle automatiquement sa methode toString(). Par defaut, le resultat est peu lisible : "Main$Point@6d06d69c". En redefinissant toString(), vous controllez l affichage :\n\n  class Point {\n      private int x;\n      private int y;\n\n      Point(int x, int y) {\n          this.x = x;\n          this.y = y;\n      }\n\n      @Override\n      public String toString() {\n          return "(" + x + ", " + y + ")";\n      }\n  }\n\n  Point p = new Point(3, 5);\n  System.out.println(p);              // (3, 5) grace a toString()\n  System.out.println("Position : " + p); // Position : (3, 5) via concatenation\n\nL annotation @Override confirme au compilateur que vous redefinissez bien une methode existante.\n\n---\n\nLA METHODE EQUALS()\n\nL operateur == compare les REFERENCES (si c est le meme objet en memoire), pas le contenu. Pour comparer le contenu de deux objets, redefinissez equals() :\n\n  class Point {\n      private int x;\n      private int y;\n\n      Point(int x, int y) {\n          this.x = x;\n          this.y = y;\n      }\n\n      @Override\n      public boolean equals(Object obj) {\n          if (obj instanceof Point) {\n              Point autre = (Point) obj;\n              return this.x == autre.x && this.y == autre.y;\n          }\n          return false;\n      }\n  }\n\n  Point p1 = new Point(3, 5);\n  Point p2 = new Point(3, 5);\n  Point p3 = new Point(1, 2);\n\n  System.out.println(p1 == p2);       // false : references differentes\n  System.out.println(p1.equals(p2)); // true  : meme contenu\n  System.out.println(p1.equals(p3)); // false : contenu different\n\nEtapes d implementation d equals() :\n  1. Verifiez avec instanceof que l objet est du bon type\n  2. Castez en votre type : Point autre = (Point) obj;\n  3. Comparez chaque champ pertinent avec ==\n\n---\n\nCOMBINER STATIC, FINAL, TOSTRING ET EQUALS\n\n  class Temperature {\n      static final double ZERO_ABSOLU = -273.15;\n\n      private double valeur;\n\n      Temperature(double valeur) {\n          this.valeur = valeur;\n      }\n\n      @Override\n      public String toString() {\n          return valeur + " degres";\n      }\n\n      @Override\n      public boolean equals(Object obj) {\n          if (obj instanceof Temperature) {\n              Temperature autre = (Temperature) obj;\n              return this.valeur == autre.valeur;\n          }\n          return false;\n      }\n  }\n\n  Temperature t1 = new Temperature(20);\n  Temperature t2 = new Temperature(20);\n  System.out.println(t1);              // 20.0 degres\n  System.out.println(t1.equals(t2));  // true\n  System.out.println(Temperature.ZERO_ABSOLU); // -273.15\n\nFelicitations ! Vous avez maintenant tous les outils fondamentaux de la POO Java. La prochaine etape : les Collections pour gerer des groupes d objets dynamiquement.',
    5,
    45
FROM chapters c WHERE c.slug = 'poo-bases';

-- =============================================
-- QUIZ : Concepts Avances
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Concepts Avances Java',
    'Testez vos connaissances sur static, final, toString et equals',
    300, 70, 100
FROM lessons l WHERE l.slug = 'concepts-avances';

-- Question 1 : static
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que signifie qu un champ est static dans une classe Java ?',
        'SINGLE_CHOICE',
        'Un champ static appartient a la classe et non a une instance particuliere. Toutes les instances partagent la meme valeur. Si une instance modifie un champ static, la valeur change pour toutes les autres. C est utile pour les compteurs, identifiants uniques ou constantes partagees. Les methodes static s appellent via NomClasse.methode() et n ont pas acces a this.',
        1
    FROM quizzes qz WHERE qz.title = 'Quiz - Concepts Avances Java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Il est prive et inaccessible depuis l exterieur', false, 1 FROM q
UNION ALL SELECT q.id, 'Il est partage entre toutes les instances de la classe', true, 2 FROM q
UNION ALL SELECT q.id, 'Il ne peut pas etre modifie apres initialisation', false, 3 FROM q
UNION ALL SELECT q.id, 'Il ne peut pas etre utilise dans un constructeur', false, 4 FROM q;

-- Question 2 : convention constantes
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la convention de nommage pour les constantes static final en Java ?',
        'SINGLE_CHOICE',
        'Par convention, les constantes static final s ecrivent en MAJUSCULES avec des underscores pour separer les mots : PI, MAX_VITESSE, JOURS_SEMAINE. Cette convention distingue visuellement les constantes des variables ordinaires et des methodes. Java ne l impose pas techniquement mais elle est universellement adoptee par la communaute Java.',
        2
    FROM quizzes qz WHERE qz.title = 'Quiz - Concepts Avances Java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'camelCase comme getNom()', false, 1 FROM q
UNION ALL SELECT q.id, 'PascalCase comme MaConstante', false, 2 FROM q
UNION ALL SELECT q.id, 'MAJUSCULES_AVEC_UNDERSCORES', true, 3 FROM q
UNION ALL SELECT q.id, 'lowercase_avec_underscores', false, 4 FROM q;

-- Question 3 : toString
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode Java est appelee automatiquement quand on affiche un objet avec System.out.println() ?',
        'SINGLE_CHOICE',
        'System.out.println(monObjet) appelle automatiquement monObjet.toString(). Par defaut, cette methode retourne un resultat peu lisible du type "Main$Point@6d06d69c". En redefinissant toString() avec @Override dans votre classe, vous controlez la representation textuelle. La concatenation "Position : " + monObjet appelle aussi toString() implicitement.',
        3
    FROM quizzes qz WHERE qz.title = 'Quiz - Concepts Avances Java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'afficher()', false, 1 FROM q
UNION ALL SELECT q.id, 'print()', false, 2 FROM q
UNION ALL SELECT q.id, 'toString()', true, 3 FROM q
UNION ALL SELECT q.id, 'describe()', false, 4 FROM q;

-- Question 4 : equals vs ==
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pourquoi utilise-t-on equals() plutot que == pour comparer deux objets ?',
        'SINGLE_CHOICE',
        'L operateur == compare les ADRESSES memoire : deux variables pointant vers des objets differents mais de meme contenu retournent false avec ==. La methode equals() redefinissable compare le CONTENU selon nos criteres. new Point(3,5) == new Point(3,5) est false car ce sont deux objets distincts en memoire, mais equals() peut retourner true si x et y sont identiques.',
        4
    FROM quizzes qz WHERE qz.title = 'Quiz - Concepts Avances Java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'equals() est plus rapide que ==', false, 1 FROM q
UNION ALL SELECT q.id, '== compare les references memoire, equals() compare le contenu', true, 2 FROM q
UNION ALL SELECT q.id, '== ne fonctionne pas avec les objets', false, 3 FROM q
UNION ALL SELECT q.id, 'equals() est obligatoire pour tous les objets', false, 4 FROM q;

-- Question 5 : final variable
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Qu est-ce que final signifie applique a une variable locale ?',
        'SINGLE_CHOICE',
        'final empeche toute reassignation apres la premiere initialisation. "final int x = 5; x = 10;" genere une erreur de compilation. Avec static, final cree une constante de classe immuable. Utilise comme parametre de methode (final int val), il garantit que val ne sera pas modifie dans la methode. C est une bonne pratique pour eviter les modifications accidentelles.',
        5
    FROM quizzes qz WHERE qz.title = 'Quiz - Concepts Avances Java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'La variable est accessible depuis partout', false, 1 FROM q
UNION ALL SELECT q.id, 'La variable ne peut pas etre modifiee apres son initialisation', true, 2 FROM q
UNION ALL SELECT q.id, 'La variable est automatiquement static', false, 3 FROM q
UNION ALL SELECT q.id, 'La variable doit obligatoirement etre un entier', false, 4 FROM q;

-- Question 6 : appel methode static
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment appelle-t-on correctement une methode static depuis l exterieur de la classe ?',
        'SINGLE_CHOICE',
        'Les methodes static s appellent sur la CLASSE, pas sur une instance : Math.abs(-5), Integer.parseInt("42"), CompteurObjets.getCount(). C est la convention recommandee et elle indique clairement que c est une methode de classe independante d une instance. Bien qu on puisse techniquement l appeler via une instance, les outils d analyse de code le deconseillent.',
        6
    FROM quizzes qz WHERE qz.title = 'Quiz - Concepts Avances Java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Il faut creer une instance pour appeler une methode static', false, 1 FROM q
UNION ALL SELECT q.id, 'Via NomDeLaClasse.methode()', true, 2 FROM q
UNION ALL SELECT q.id, 'Les methodes static ne peuvent pas etre appelees depuis l exterieur', false, 3 FROM q
UNION ALL SELECT q.id, 'Via super.methode()', false, 4 FROM q;
