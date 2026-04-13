-- V24: Lecon Encapsulation Avancee + Quiz

-- =============================================
-- LECON 4 : Encapsulation Avancee
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Encapsulation Avancee',
    'encapsulation-avancee',
    E'ENCAPSULATION AVANCEE EN JAVA\n\nL encapsulation consiste a cacher les donnees internes d un objet et a controler leur acces via des methodes publiques. C est l un des quatre piliers de la programmation orientee objet.\n\n---\n\nLE PROBLEME SANS ENCAPSULATION\n\nSans protection, n importe quel code peut modifier les champs directement, sans aucun controle :\n\n  class CompteBancaire {\n      double solde;  // accessible directement\n  }\n\n  CompteBancaire c = new CompteBancaire();\n  c.solde = -1000;   // solde negatif autorise !\n  c.solde = 9999999; // aucune validation possible\n\nL encapsulation resout ce probleme en rendant les champs prives et en controlant les acces via des methodes.\n\n---\n\nLES MODIFICATEURS D ACCES\n\nJava propose 4 niveaux d acces pour les champs et les methodes :\n\n  private   : accessible uniquement dans la classe elle-meme\n  (defaut)  : accessible dans le meme package\n  protected : accessible dans le package et les sous-classes\n  public    : accessible depuis n importe ou\n\nRegle fondamentale : declarez vos champs private et exposez-les via des methodes publiques.\n\n---\n\nGETTERS ET SETTERS\n\nUn getter retourne la valeur d un champ prive. Un setter la modifie avec une validation eventuelle :\n\n  class CompteBancaire {\n      private String titulaire;\n      private double solde;\n\n      CompteBancaire(String titulaire, double soldeInitial) {\n          this.titulaire = titulaire;\n          this.solde = soldeInitial;\n      }\n\n      // Getter : lecture seule du champ\n      public String getTitulaire() {\n          return titulaire;\n      }\n\n      // Getter\n      public double getSolde() {\n          return solde;\n      }\n\n      // Methode avec validation\n      public void deposer(double montant) {\n          if (montant > 0) {\n              solde = solde + montant;\n              System.out.println("Depot de " + montant + " euros.");\n          } else {\n              System.out.println("Montant invalide.");\n          }\n      }\n\n      public void retirer(double montant) {\n          if (montant > 0 && montant <= solde) {\n              solde = solde - montant;\n              System.out.println("Retrait de " + montant + " euros.");\n          } else {\n              System.out.println("Retrait impossible.");\n          }\n      }\n  }\n\n  CompteBancaire c = new CompteBancaire("Alice", 500);\n  c.deposer(200);   // Depot de 200.0 euros.\n  c.retirer(100);   // Retrait de 100.0 euros.\n  c.retirer(1000);  // Retrait impossible.\n  System.out.println(c.getSolde()); // 600.0\n  // c.solde = -999; // ERREUR : solde est private !\n\n---\n\nLE MOT-CLE THIS\n\nthis designe l objet courant. Il distingue un champ d instance d un parametre portant le meme nom :\n\n  class Personne {\n      private String nom;\n      private int age;\n\n      Personne(String nom, int age) {\n          this.nom = nom;  // this.nom = champ, nom = parametre\n          this.age = age;\n      }\n\n      public String getNom() { return nom; }\n      public int getAge() { return age; }\n\n      public void setAge(int age) {\n          if (age >= 0 && age <= 150) {\n              this.age = age;  // Validation avant affectation\n          }\n      }\n  }\n\n  Personne p = new Personne("Bob", 30);\n  p.setAge(35);   // OK\n  p.setAge(-5);   // Ignore : age invalide\n  System.out.println(p.getAge()); // 35\n\n---\n\nVALIDATION DANS LES SETTERS\n\nLes setters permettent de valider les donnees avant de les stocker. Le constructeur peut reutiliser le setter pour eviter la duplication de logique :\n\n  class Produit {\n      private String nom;\n      private double prix;\n\n      Produit(String nom, double prixInitial) {\n          this.nom = nom;\n          setPrix(prixInitial);  // Reutilise la validation du setter\n      }\n\n      public String getNom() { return nom; }\n      public double getPrix() { return prix; }\n\n      public void setPrix(double prix) {\n          if (prix > 0) {\n              this.prix = prix;\n          } else {\n              System.out.println("Prix invalide.");\n          }\n      }\n  }\n\n  Produit p = new Produit("Stylo", 1.5);\n  p.setPrix(2.0);   // OK\n  p.setPrix(-3.0);  // Prix invalide.\n  System.out.println(p.getPrix()); // 2.0\n\nLa prochaine lecon couvrira les concepts avances : static, final et la methode equals().',
    4,
    40
FROM chapters c WHERE c.slug = 'poo-bases';

-- =============================================
-- QUIZ : Encapsulation Avancee
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Encapsulation Avancee',
    'Testez vos connaissances sur private, getters, setters et this',
    300, 70, 100
FROM lessons l WHERE l.slug = 'encapsulation-avancee';

-- Question 1 : modificateur private
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel modificateur d acces rend un champ accessible uniquement dans sa propre classe ?',
        'SINGLE_CHOICE',
        'Le modificateur private limite l acces au champ a la seule classe qui le declare. Aucun autre code, meme dans le meme package, ne peut y acceder directement. C est le niveau d acces le plus restrictif de Java. Regle de base de l encapsulation : declarez vos champs private et exposez-les via des methodes publiques.',
        1
    FROM quizzes qz WHERE qz.title = 'Quiz - Encapsulation Avancee'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'public', false, 1 FROM q
UNION ALL SELECT q.id, 'protected', false, 2 FROM q
UNION ALL SELECT q.id, 'private', true, 3 FROM q
UNION ALL SELECT q.id, 'static', false, 4 FROM q;

-- Question 2 : getter
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment s appelle une methode qui retourne la valeur d un champ prive ?',
        'SINGLE_CHOICE',
        'Un getter (ou accesseur) est une methode publique qui retourne la valeur d un champ prive. Par convention, son nom commence par "get" suivi du nom du champ avec une majuscule : getSolde(), getNom(), getAge(). Un setter (mutateur) fait l inverse : il permet de modifier la valeur en appliquant une validation eventuelle.',
        2
    FROM quizzes qz WHERE qz.title = 'Quiz - Encapsulation Avancee'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Un setter', false, 1 FROM q
UNION ALL SELECT q.id, 'Un getter', true, 2 FROM q
UNION ALL SELECT q.id, 'Un constructeur', false, 3 FROM q
UNION ALL SELECT q.id, 'Une methode abstraite', false, 4 FROM q;

-- Question 3 : this
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel est le role du mot-cle this dans une classe Java ?',
        'SINGLE_CHOICE',
        'this fait reference a l instance courante de la classe. Il est indispensable quand un parametre porte le meme nom qu un champ : this.nom = nom signifie "affecte le parametre nom au champ nom de cet objet". Sans this, Java utiliserait le parametre pour les deux membres et le champ ne serait pas mis a jour.',
        3
    FROM quizzes qz WHERE qz.title = 'Quiz - Encapsulation Avancee'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Il cree une nouvelle instance de la classe', false, 1 FROM q
UNION ALL SELECT q.id, 'Il designe l objet courant et distingue champ et parametre de meme nom', true, 2 FROM q
UNION ALL SELECT q.id, 'Il appelle la methode parente', false, 3 FROM q
UNION ALL SELECT q.id, 'Il rend une methode statique', false, 4 FROM q;

-- Question 4 : setter avec validation
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pourquoi utilise-t-on des setters plutot que de modifier directement un champ prive ?',
        'SINGLE_CHOICE',
        'Le principal avantage des setters est la validation : on peut verifier que la valeur est acceptable avant de l affecter. Par exemple, un setter setPrix() peut refuser un prix negatif. Sans setter, n importe quelle valeur incorrecte pourrait etre stockee directement dans le champ sans aucun controle.',
        4
    FROM quizzes qz WHERE qz.title = 'Quiz - Encapsulation Avancee'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Pour rendre le code plus long et complexe', false, 1 FROM q
UNION ALL SELECT q.id, 'Pour valider les donnees avant de les stocker', true, 2 FROM q
UNION ALL SELECT q.id, 'Pour convertir les types automatiquement', false, 3 FROM q
UNION ALL SELECT q.id, 'Car Java l impose obligatoirement', false, 4 FROM q;

-- Question 5 : convention nommage getter
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la convention de nommage pour un getter du champ "prix" ?',
        'SINGLE_CHOICE',
        'La convention Java pour les getters est get + nom du champ avec la premiere lettre en majuscule. Pour le champ prix on ecrira getPrix(). De meme : getNom(), getAge(). Pour les setters : setPrix(double prix). Cette convention est utilisee par de nombreux frameworks Java comme Spring et Hibernate pour detecter automatiquement les proprietes d un objet.',
        5
    FROM quizzes qz WHERE qz.title = 'Quiz - Encapsulation Avancee'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'readPrix()', false, 1 FROM q
UNION ALL SELECT q.id, 'getPrix()', true, 2 FROM q
UNION ALL SELECT q.id, 'fetchPrix()', false, 3 FROM q
UNION ALL SELECT q.id, 'prix()', false, 4 FROM q;

-- Question 6 : acces champ private depuis l exterieur
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que se passe-t-il si on tente d acceder a un champ private depuis une classe externe ?',
        'SINGLE_CHOICE',
        'L acces a un champ private depuis une classe externe est une erreur de COMPILATION, pas d execution. Java refuse de compiler le code si vous tentez d acceder a c.solde alors que solde est declare private. C est un avantage majeur de l encapsulation : les violations de visibilite sont detectees tot, avant meme d executer le programme.',
        6
    FROM quizzes qz WHERE qz.title = 'Quiz - Encapsulation Avancee'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'La valeur retournee est null', false, 1 FROM q
UNION ALL SELECT q.id, 'Le compilateur genere une erreur', true, 2 FROM q
UNION ALL SELECT q.id, 'Le programme plante a l execution', false, 3 FROM q
UNION ALL SELECT q.id, 'Le champ retourne sa valeur quand meme', false, 4 FROM q;
