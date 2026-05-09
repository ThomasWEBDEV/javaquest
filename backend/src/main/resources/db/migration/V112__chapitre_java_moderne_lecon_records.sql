-- V112: Chapitre Java Moderne + Lecon 1 Records + Quiz + Exercices

-- =============================================
-- CHAPITRE 12 : Java Moderne
-- =============================================

INSERT INTO chapters (title, slug, description, order_index, xp_reward, is_published)
VALUES (
    'Java Moderne',
    'java-moderne',
    'Decouvrez les fonctionnalites modernes de Java 16-21 : Records, Pattern Matching, Sealed Classes et Text Blocks pour un code plus expressif et concis',
    12,
    350,
    true
);

-- =============================================
-- LECON 1 : Records Java
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Records Java : classes de donnees immutables',
    'records-java',
    E'RECORDS JAVA : CLASSES DE DONNEES IMMUTABLES\n\nIntroduits en Java 16, les Records eliminent le code boilerplate des classes de donnees. En une seule ligne, Java genere automatiquement le constructeur, les accesseurs, equals(), hashCode() et toString().\n\n---\n\nLE PROBLEME AVANT LES RECORDS\n\nPour representer un simple point 2D, on ecrivait :\n\n  class Point {\n      private final int x;\n      private final int y;\n\n      public Point(int x, int y) {\n          this.x = x;\n          this.y = y;\n      }\n\n      public int x() { return x; }\n      public int y() { return y; }\n\n      public boolean equals(Object o) {\n          if (this == o) return true;\n          if (!(o instanceof Point)) return false;\n          Point p = (Point) o;\n          return x == p.x && y == p.y;\n      }\n\n      public int hashCode() { return Objects.hash(x, y); }\n      public String toString() { return "Point[x=" + x + ", y=" + y + "]"; }\n  }\n\n30 lignes pour un simple conteneur de 2 champs.\n\n---\n\nAVEC LES RECORDS : 1 LIGNE\n\n  record Point(int x, int y) {}\n\nJava genere automatiquement :\n- Un constructeur canonique Point(int x, int y)\n- Des accesseurs x() et y() (pas getX() : convention Record)\n- equals() qui compare les champs\n- hashCode() base sur les champs\n- toString() qui retourne "Point[x=3, y=4]"\n\n  Point p = new Point(3, 4);\n  System.out.println(p);            // Point[x=3, y=4]\n  System.out.println(p.x());        // 3\n  System.out.println(p.y());        // 4\n\n  Point p2 = new Point(3, 4);\n  System.out.println(p.equals(p2)); // true (meme contenu)\n\n---\n\nRECORDS ET IMMUTABILITE\n\nLes champs d un Record sont toujours final. On ne peut pas les modifier apres creation :\n\n  Point p = new Point(3, 4);\n  // p.x = 5; // Erreur de compilation\n\n  // Pour "modifier", on cree un nouveau Record\n  Point deplace = new Point(p.x() + 1, p.y() + 1);\n  System.out.println(deplace); // Point[x=4, y=5]\n\n---\n\nMETHODES PERSONNALISEES\n\nOn peut ajouter des methodes dans un Record :\n\n  record Point(int x, int y) {\n\n      public double distance() {\n          return Math.sqrt(x * x + y * y);\n      }\n\n      public static Point origine() {\n          return new Point(0, 0);\n      }\n  }\n\n  Point p = new Point(3, 4);\n  System.out.println(p.distance());    // 5.0\n  System.out.println(Point.origine()); // Point[x=0, y=0]\n\n---\n\nCONSTRUCTEUR COMPACT : VALIDATION\n\nLe constructeur compact valide les champs sans redeclarer les parametres :\n\n  record Personne(String nom, int age) {\n      Personne {\n          if (age < 0) throw new IllegalArgumentException("Age invalide : " + age);\n          if (nom == null || nom.isBlank()) throw new IllegalArgumentException("Nom invalide");\n          nom = nom.trim(); // normalisation avant affectation automatique\n      }\n  }\n\n  Personne p = new Personne("  Alice  ", 30);\n  System.out.println(p); // Personne[nom=Alice, age=30]\n\n  try {\n      new Personne("Bob", -5);\n  } catch (IllegalArgumentException e) {\n      System.out.println(e.getMessage()); // Age invalide : -5\n  }\n\n---\n\nRECORDS ET COLLECTIONS\n\nLes Records fonctionnent parfaitement avec les Streams car equals() et hashCode() sont corrects :\n\n  record Produit(String nom, double prix) {}\n\n  List<Produit> catalogue = List.of(\n      new Produit("Java Book", 29.99),\n      new Produit("Mouse", 49.99),\n      new Produit("Keyboard", 79.99)\n  );\n\n  catalogue.stream()\n      .filter(p -> p.prix() < 60)\n      .forEach(System.out::println);\n  // Produit[nom=Java Book, prix=29.99]\n  // Produit[nom=Mouse, prix=49.99]\n\n---\n\nBONNES PRATIQUES\n\n1. Utilisez les Records pour les DTOs, coordonnees, resultats de calcul.\n2. Les accesseurs portent le nom du champ : x(), pas getX().\n3. Un Record est final : il ne peut pas etre etendu par une sous-classe.\n4. Ajoutez un constructeur compact pour valider les contraintes metier.\n5. Les Records peuvent implementer des interfaces.',
    1,
    40
FROM chapters c WHERE c.slug = 'java-moderne';

-- =============================================
-- QUIZ : Records Java
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Records Java',
    'Testez vos connaissances sur les Records Java, leurs methodes generees automatiquement, l immutabilite et le constructeur compact',
    300, 70, 100
FROM lessons l WHERE l.slug = 'records-java';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que genere automatiquement un Record Java ?',
        'SINGLE_CHOICE',
        'Un Record genere automatiquement : le constructeur canonique, les accesseurs (x(), y()...), equals(), hashCode() et toString(). Cela elimine tout le code boilerplate habituel des classes de donnees.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'records-java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Uniquement le constructeur et toString()', false, 1),
    ('Constructeur, accesseurs, equals(), hashCode() et toString()', true, 2),
    ('Constructeur, getters au format getX(), setters et toString()', false, 3),
    ('Rien : il faut tout definir manuellement comme une classe normale', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pour un Record "record Point(int x, int y) {}", comment accede-t-on au champ x ?',
        'SINGLE_CHOICE',
        'Les accesseurs d un Record portent exactement le nom du champ : p.x() et non p.getX(). C est une difference importante avec les JavaBeans classiques. Cette convention rend le code plus concis.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'records-java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('p.getX()', false, 1),
    ('p.x', false, 2),
    ('p.x()', true, 3),
    ('p.field("x")', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Les champs d un Record sont-ils modifiables apres creation ?',
        'SINGLE_CHOICE',
        'Non, les champs d un Record sont implicitement final. Un Record est immutable par nature : on ne peut pas modifier ses champs apres creation. Pour obtenir un Record modifie, on cree un nouvel objet avec les nouvelles valeurs.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'records-java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Oui, via les setters generes automatiquement', false, 1),
    ('Oui, car les champs sont public par defaut', false, 2),
    ('Non, les champs sont implicitement final', true, 3),
    ('Cela depend si on utilise le mot-cle mutable', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'A quoi sert le constructeur compact dans un Record ?',
        'SINGLE_CHOICE',
        'Le constructeur compact permet de valider ou normaliser les champs sans redeclarer les parametres. Il s ecrit sans parentheses avec les parametres. Les affectations this.x = x sont faites automatiquement apres le corps du constructeur compact.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'records-java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Creer le Record sans aucun parametre (constructeur vide)', false, 1),
    ('Valider ou normaliser les champs avant affectation automatique', true, 2),
    ('Remplacer le constructeur canonique pour modifier les noms de champs', false, 3),
    ('Permettre la serialisation JSON automatique du Record', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Un Record peut-il etendre (extends) une autre classe ?',
        'SINGLE_CHOICE',
        'Non. Un Record est implicitement final et etend toujours java.lang.Record. Il ne peut pas etendre d autre classe. En revanche, un Record peut implémenter des interfaces.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'records-java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Oui, avec le mot-cle extends comme une classe normale', false, 1),
    ('Oui, mais uniquement des classes abstraites', false, 2),
    ('Non, un Record est final et etend toujours java.lang.Record', true, 3),
    ('Non, et un Record ne peut pas non plus implementer d interfaces', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Dans quel cas les Records sont-ils particulierement adaptes ?',
        'SINGLE_CHOICE',
        'Les Records sont ideaux pour les DTOs (Data Transfer Objects), value objects, coordonnees ou resultats de calcul : des structures qui transportent des donnees sans logique complexe. Ils ne conviennent pas pour des classes avec beaucoup de comportement ou de logique metier.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'records-java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Les classes avec beaucoup de logique metier et d etats mutables', false, 1),
    ('Les services Spring qui gerent des transactions en base de donnees', false, 2),
    ('Les DTOs, value objects et structures de donnees immutables', true, 3),
    ('Les classes abstraites servant de base a une hierarchie complexe', false, 4)
) AS opt(text, is_correct, order_index);

-- =============================================
-- EXERCICE 1 : Record Couleur (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Record Couleur RGB',
    'EASY',
    'Creez un Record Couleur avec trois champs int : rouge, vert, bleu. Ajoutez une methode estClaire() qui retourne true si la moyenne des trois composantes est superieure a 127. Dans le main, creez deux couleurs : blanc (255, 255, 255) et noir (0, 0, 0), affichez-les avec println, puis affichez le resultat de estClaire() pour chacune.',
    E'// TODO: definir le Record Couleur\n// - champs : int rouge, int vert, int bleu\n// - methode : boolean estClaire() -> moyenne > 127\n\npublic class Main {\n    public static void main(String[] args) {\n        Couleur blanc = new Couleur(255, 255, 255);\n        Couleur noir  = new Couleur(0, 0, 0);\n\n        System.out.println(blanc);\n        System.out.println(noir);\n        System.out.println(blanc.estClaire());\n        System.out.println(noir.estClaire());\n    }\n}',
    E'record Couleur(int rouge, int vert, int bleu) {\n    public boolean estClaire() {\n        return (rouge + vert + bleu) / 3 > 127;\n    }\n}\n\npublic class Main {\n    public static void main(String[] args) {\n        Couleur blanc = new Couleur(255, 255, 255);\n        Couleur noir  = new Couleur(0, 0, 0);\n\n        System.out.println(blanc);\n        System.out.println(noir);\n        System.out.println(blanc.estClaire());\n        System.out.println(noir.estClaire());\n    }\n}',
    'output.contains("Couleur[rouge=255, vert=255, bleu=255]") && output.contains("Couleur[rouge=0, vert=0, bleu=0]") && output.contains("true") && output.contains("false")',
    '["La syntaxe est : record Couleur(int rouge, int vert, int bleu) {} - Java genere toString() automatiquement sous la forme Couleur[rouge=255, vert=255, bleu=255]", "Pour ajouter une methode, ecrivez-la dans le corps du Record entre les accolades. Les champs sont accessibles directement par leur nom : rouge, vert, bleu", "estClaire() : return (rouge + vert + bleu) / 3 > 127"]',
    30,
    1
FROM lessons l WHERE l.slug = 'records-java';

-- =============================================
-- EXERCICE 2 : Record Produit avec validation (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Record Produit avec validation',
    'MEDIUM',
    'Creez un Record Produit avec les champs String nom, double prix, int stock. Ajoutez un constructeur compact qui valide : prix > 0 (sinon IllegalArgumentException "Prix invalide"), stock >= 0 (sinon IllegalArgumentException "Stock invalide"), et normalise nom avec trim(). Ajoutez une methode boolean estDisponible() qui retourne true si stock > 0, et une methode double prixTTC() qui retourne prix * 1.20. Dans le main, creez un produit valide, affichez-le, ses methodes, puis testez la validation avec un prix negatif.',
    E'// TODO: Record Produit(String nom, double prix, int stock)\n// Constructeur compact : valider prix > 0 et stock >= 0, trim() sur nom\n// Methodes : boolean estDisponible(), double prixTTC()\n\npublic class Main {\n    public static void main(String[] args) {\n        Produit p = new Produit("  Clavier  ", 79.99, 5);\n        System.out.println(p);\n        System.out.println(p.estDisponible());\n        System.out.println(p.prixTTC());\n\n        try {\n            new Produit("Souris", -10.0, 3);\n        } catch (IllegalArgumentException e) {\n            System.out.println(e.getMessage());\n        }\n    }\n}',
    E'record Produit(String nom, double prix, int stock) {\n    Produit {\n        if (prix <= 0) throw new IllegalArgumentException("Prix invalide");\n        if (stock < 0) throw new IllegalArgumentException("Stock invalide");\n        nom = nom.trim();\n    }\n\n    public boolean estDisponible() {\n        return stock > 0;\n    }\n\n    public double prixTTC() {\n        return prix * 1.20;\n    }\n}\n\npublic class Main {\n    public static void main(String[] args) {\n        Produit p = new Produit("  Clavier  ", 79.99, 5);\n        System.out.println(p);\n        System.out.println(p.estDisponible());\n        System.out.println(p.prixTTC());\n\n        try {\n            new Produit("Souris", -10.0, 3);\n        } catch (IllegalArgumentException e) {\n            System.out.println(e.getMessage());\n        }\n    }\n}',
    'output.contains("Produit[nom=Clavier") && output.contains("true") && output.contains("95.988") && output.contains("Prix invalide")',
    '["Le constructeur compact s ecrit sans parentheses avec les parametres : record Produit(...) { Produit { /* validation */ } }. Les affectations this.x = x sont faites automatiquement apres.", "Pour normaliser nom, ecrivez nom = nom.trim(); dans le constructeur compact. On peut modifier la valeur du parametre avant qu elle soit affectee au champ.", "prixTTC() retourne prix * 1.20. Comme prix est un champ final du Record, on y accede directement par son nom dans les methodes."]',
    40,
    2
FROM lessons l WHERE l.slug = 'records-java';

-- =============================================
-- EXERCICE 3 : Record et collections (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Records et Stream - Catalogue de livres',
    'HARD',
    'Creez un Record Livre avec les champs String titre, String auteur, int annee, double note (de 1.0 a 5.0). Ajoutez un constructeur compact qui valide note entre 1.0 et 5.0 (sinon IllegalArgumentException "Note invalide"). Ajoutez une methode String mention() qui retourne "Excellent" si note >= 4.5, "Bien" si >= 3.5, "Moyen" sinon. Dans le main : creez une List de 4 livres, puis utilisez des Streams pour : 1) afficher les livres notes >= 4.0 tries par note decroissante, 2) calculer et afficher la note moyenne arrondie a 2 decimales.',
    E'import java.util.List;\nimport java.util.Comparator;\n\n// TODO: Record Livre(String titre, String auteur, int annee, double note)\n// Constructeur compact : note entre 1.0 et 5.0\n// Methode : String mention()\n\npublic class Main {\n    public static void main(String[] args) {\n        List<Livre> bibliotheque = List.of(\n            new Livre("Clean Code", "Robert Martin", 2008, 4.8),\n            new Livre("Effective Java", "Joshua Bloch", 2018, 4.9),\n            new Livre("Java Basics", "Auteur Inconnu", 2020, 3.2),\n            new Livre("Design Patterns", "Gang of Four", 1994, 4.3)\n        );\n\n        System.out.println("=== Livres bien notes ===");\n        // TODO: afficher les livres notes >= 4.0, tries par note decroissante\n        // Format : titre + " (" + note + ") - " + mention()\n\n        System.out.println("=== Note moyenne ===");\n        // TODO: calculer et afficher la moyenne des notes (2 decimales)\n    }\n}',
    E'import java.util.List;\nimport java.util.Comparator;\n\nrecord Livre(String titre, String auteur, int annee, double note) {\n    Livre {\n        if (note < 1.0 || note > 5.0) throw new IllegalArgumentException("Note invalide");\n    }\n\n    public String mention() {\n        if (note >= 4.5) return "Excellent";\n        if (note >= 3.5) return "Bien";\n        return "Moyen";\n    }\n}\n\npublic class Main {\n    public static void main(String[] args) {\n        List<Livre> bibliotheque = List.of(\n            new Livre("Clean Code", "Robert Martin", 2008, 4.8),\n            new Livre("Effective Java", "Joshua Bloch", 2018, 4.9),\n            new Livre("Java Basics", "Auteur Inconnu", 2020, 3.2),\n            new Livre("Design Patterns", "Gang of Four", 1994, 4.3)\n        );\n\n        System.out.println("=== Livres bien notes ===");\n        bibliotheque.stream()\n            .filter(l -> l.note() >= 4.0)\n            .sorted(Comparator.comparingDouble(Livre::note).reversed())\n            .forEach(l -> System.out.println(l.titre() + " (" + l.note() + ") - " + l.mention()));\n\n        System.out.println("=== Note moyenne ===");\n        double moyenne = bibliotheque.stream()\n            .mapToDouble(Livre::note)\n            .average()\n            .orElse(0.0);\n        System.out.printf("%.2f%n", moyenne);\n    }\n}',
    'output.contains("Livres bien notes") && output.contains("Effective Java") && output.contains("Clean Code") && output.contains("Design Patterns") && output.contains("Note moyenne") && output.contains("4.30")',
    '["Pour trier par note decroissante : .sorted(Comparator.comparingDouble(Livre::note).reversed())", "Pour la moyenne : .mapToDouble(Livre::note).average().orElse(0.0) retourne un OptionalDouble. Utilisez orElse(0.0) pour obtenir un double.", "Pour afficher 2 decimales : System.out.printf(\"%.2f%n\", moyenne)"]',
    50,
    3
FROM lessons l WHERE l.slug = 'records-java';
