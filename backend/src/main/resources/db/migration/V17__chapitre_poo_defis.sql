-- V17: Nouveau chapitre POO + premiere lecon + defis quotidiens

-- =============================================
-- CHAPITRE 4 : Programmation Orientee Objet
-- =============================================

INSERT INTO chapters (title, slug, description, order_index, xp_reward, is_published)
VALUES (
    'Programmation Orientee Objet',
    'poo-bases',
    'Decouvrez les fondements de la POO : classes, objets, encapsulation et constructeurs',
    4,
    300,
    true
);

-- =============================================
-- LECON 1 : Classes et Objets
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Classes et Objets',
    'classes-et-objets',
    E'CLASSES ET OBJETS EN JAVA\n\nLa Programmation Orientee Objet (POO) organise le code autour d objets qui combinent donnees (attributs) et comportements (methodes). Java est un langage oriente objet pur : tout (sauf les types primitifs) est un objet.\n\n---\n\nQU EST-CE QU UNE CLASSE ?\n\nUne classe est un modele (blueprint) qui definit la structure et le comportement d un type d objet. Pensez-y comme un plan architectural : le plan definit la maison, mais il peut y avoir plusieurs maisons construites a partir du meme plan.\n\n  // Definition de la classe\n  public class Voiture {\n      // Attributs (champs / fields)\n      String marque;\n      String modele;\n      int annee;\n      double vitesseActuelle;\n\n      // Methode\n      public void accelerer(double increment) {\n          vitesseActuelle += increment;\n          System.out.println("Vitesse : " + vitesseActuelle + " km/h");\n      }\n\n      public void freiner() {\n          vitesseActuelle = 0;\n          System.out.println("Arret complet");\n      }\n\n      public String getDescription() {\n          return annee + " " + marque + " " + modele;\n      }\n  }\n\n---\n\nCREER DES OBJETS AVEC NEW\n\nUn objet est une instance d une classe. On le cree avec le mot-cle new :\n\n  public class Main {\n      public static void main(String[] args) {\n          // Creer deux objets Voiture differents\n          Voiture maVoiture = new Voiture();\n          maVoiture.marque = "Renault";\n          maVoiture.modele = "Clio";\n          maVoiture.annee = 2022;\n\n          Voiture autreVoiture = new Voiture();\n          autreVoiture.marque = "Peugeot";\n          autreVoiture.modele = "308";\n          autreVoiture.annee = 2023;\n\n          // Chaque objet a ses propres donnees\n          maVoiture.accelerer(50);     // Vitesse : 50.0 km/h\n          autreVoiture.accelerer(80);  // Vitesse : 80.0 km/h\n\n          System.out.println(maVoiture.getDescription());    // 2022 Renault Clio\n          System.out.println(autreVoiture.getDescription()); // 2023 Peugeot 308\n      }\n  }\n\nChaque objet cree avec new est independant : modifier maVoiture n affecte pas autreVoiture.\n\n---\n\nLES CONSTRUCTEURS\n\nUn constructeur est une methode speciale appelee lors de la creation d un objet avec new. Il porte le meme nom que la classe et n a pas de type de retour.\n\n  public class Voiture {\n      String marque;\n      String modele;\n      int annee;\n\n      // Constructeur\n      public Voiture(String marque, String modele, int annee) {\n          this.marque = marque;\n          this.modele = modele;\n          this.annee = annee;\n      }\n  }\n\n  // Utilisation\n  Voiture v = new Voiture("Toyota", "Corolla", 2021);\n  System.out.println(v.marque);   // "Toyota"\n\nLE MOT-CLE this\n\nthis fait reference a l objet courant. Dans le constructeur ci-dessus, this.marque designe l attribut de l objet, tandis que marque (sans this) designe le parametre du constructeur.\n\n  public Voiture(String marque, String modele, int annee) {\n      this.marque = marque;   // this.marque = attribut, marque = parametre\n      this.modele = modele;\n      this.annee = annee;\n  }\n\n---\n\nENCAPSULATION : PRIVE ET PUBLIC\n\nL encapsulation consiste a controler l acces aux donnees d un objet. On declare les attributs private et on les expose via des methodes publiques getters/setters :\n\n  public class CompteBancaire {\n      private double solde;   // Prive : inaccessible directement depuis l exterieur\n      private String titulaire;\n\n      public CompteBancaire(String titulaire, double soldeInitial) {\n          this.titulaire = titulaire;\n          this.solde = soldeInitial;\n      }\n\n      // Getter : lire la valeur\n      public double getSolde() {\n          return solde;\n      }\n\n      // Setter avec validation\n      public void deposer(double montant) {\n          if (montant > 0) {\n              solde += montant;\n          }\n      }\n\n      public boolean retirer(double montant) {\n          if (montant > 0 && montant <= solde) {\n              solde -= montant;\n              return true;\n          }\n          return false;\n      }\n  }\n\n  // Utilisation\n  CompteBancaire compte = new CompteBancaire("Alice", 500.0);\n  compte.deposer(200.0);\n  System.out.println(compte.getSolde());   // 700.0\n  // compte.solde = -1000;  // ERREUR : solde est private !\n\n---\n\nLES QUATRE PILIERS DE LA POO\n\nJava applique les quatre principes fondamentaux de la POO :\n\n  1. Encapsulation\n  Regrouper les donnees et methodes dans une classe, cacher les details d implementation.\n\n  2. Heritage\n  Une classe peut heriter des attributs et methodes d une autre classe (extends).\n  Exemple : class Camion extends Voiture\n\n  3. Polymorphisme\n  Un objet peut prendre plusieurs formes. Une methode peut avoir des comportements differents selon l objet sur lequel elle est appelee.\n\n  4. Abstraction\n  Masquer la complexite interne et n exposer que l interface necessaire.\n\nCes concepts seront explores en detail dans les prochaines lecons.',
    1,
    35
FROM chapters c WHERE c.slug = 'poo-bases';

-- =============================================
-- QUIZ : Classes et Objets
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Classes et Objets',
    'Testez vos connaissances sur les classes, objets, constructeurs et encapsulation',
    300, 70, 100
FROM lessons l WHERE l.slug = 'classes-et-objets';

-- Question 1 : classe vs objet
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la relation entre une classe et un objet en Java ?',
        'SINGLE_CHOICE',
        'Une classe est un modele (blueprint) qui definit la structure. Un objet est une instance de cette classe, cree avec new. On peut creer autant d objets que necessaire a partir d une seule classe. Chaque objet a ses propres valeurs d attributs.',
        1
    FROM quizzes qz WHERE qz.title = 'Quiz - Classes et Objets'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Un objet et une classe sont la meme chose', false, 1 FROM q
UNION ALL SELECT q.id, 'Une classe est un modele dont on cree des instances (objets)', true, 2 FROM q
UNION ALL SELECT q.id, 'Un objet contient plusieurs classes', false, 3 FROM q
UNION ALL SELECT q.id, 'Une classe ne peut creer qu un seul objet', false, 4 FROM q;

-- Question 2 : mot-cle new
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel mot-cle Java permet de creer un nouvel objet ?',
        'SINGLE_CHOICE',
        'Le mot-cle new alloue de la memoire pour un nouvel objet et appelle le constructeur de la classe pour l initialiser. La syntaxe est : NomClasse variable = new NomClasse(arguments);',
        2
    FROM quizzes qz WHERE qz.title = 'Quiz - Classes et Objets'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'create', false, 1 FROM q
UNION ALL SELECT q.id, 'new', true, 2 FROM q
UNION ALL SELECT q.id, 'make', false, 3 FROM q
UNION ALL SELECT q.id, 'instance', false, 4 FROM q;

-- Question 3 : constructeur
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle caracteristique distingue un constructeur d une methode normale ?',
        'SINGLE_CHOICE',
        'Un constructeur porte exactement le meme nom que la classe et n a pas de type de retour (meme pas void). Il est automatiquement appele lors de la creation d un objet avec new. Il sert a initialiser les attributs de l objet.',
        3
    FROM quizzes qz WHERE qz.title = 'Quiz - Classes et Objets'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Il est toujours statique', false, 1 FROM q
UNION ALL SELECT q.id, 'Il retourne toujours void', false, 2 FROM q
UNION ALL SELECT q.id, 'Il porte le meme nom que la classe et n a pas de type de retour', true, 3 FROM q
UNION ALL SELECT q.id, 'Il ne peut pas avoir de parametres', false, 4 FROM q;

-- Question 4 : this
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Dans un constructeur, a quoi sert le mot-cle this ?',
        'SINGLE_CHOICE',
        'this designe l objet courant (celui qui est en train d etre construit ou sur lequel la methode est appelee). Dans un constructeur, this.attribut permet de distinguer l attribut de l objet du parametre du constructeur qui porte le meme nom.',
        4
    FROM quizzes qz WHERE qz.title = 'Quiz - Classes et Objets'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Il appelle la classe parente', false, 1 FROM q
UNION ALL SELECT q.id, 'Il reference l objet courant', true, 2 FROM q
UNION ALL SELECT q.id, 'Il cree un nouvel objet', false, 3 FROM q
UNION ALL SELECT q.id, 'Il designe la classe statique', false, 4 FROM q;

-- Question 5 : encapsulation private
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pourquoi declare-t-on les attributs d une classe private ?',
        'SINGLE_CHOICE',
        'Declarer les attributs private est le principe d encapsulation. Cela empeche l acces direct et non controle depuis l exterieur de la classe. L acces se fait via des methodes publiques (getters/setters) qui peuvent valider les valeurs et maintenir la coherence des donnees.',
        5
    FROM quizzes qz WHERE qz.title = 'Quiz - Classes et Objets'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Pour que la classe s execute plus vite', false, 1 FROM q
UNION ALL SELECT q.id, 'Pour controler l acces et proteger l integrite des donnees', true, 2 FROM q
UNION ALL SELECT q.id, 'C est obligatoire en Java', false, 3 FROM q
UNION ALL SELECT q.id, 'Pour economiser de la memoire', false, 4 FROM q;

-- Question 6 : piliers POO
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quels sont les quatre piliers de la Programmation Orientee Objet ?',
        'SINGLE_CHOICE',
        'Les quatre piliers de la POO sont : Encapsulation (cacher les details internes), Heritage (reutiliser le code d une classe parente), Polymorphisme (meme interface, comportements differents), Abstraction (masquer la complexite). Ces principes rendent le code modulaire, reutilisable et maintenable.',
        6
    FROM quizzes qz WHERE qz.title = 'Quiz - Classes et Objets'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Variables, Methodes, Classes, Interfaces', false, 1 FROM q
UNION ALL SELECT q.id, 'Compilation, Execution, Debug, Test', false, 2 FROM q
UNION ALL SELECT q.id, 'Encapsulation, Heritage, Polymorphisme, Abstraction', true, 3 FROM q
UNION ALL SELECT q.id, 'Public, Private, Protected, Default', false, 4 FROM q;

-- =============================================
-- DEFIS QUOTIDIENS (semaine du 10 avril 2026)
-- =============================================

-- Defi du 10 avril : FizzBuzz (V12 exercice 1 de boucles)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-10', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'boucles' AND e.title = 'FizzBuzz';

-- Defi du 11 avril : Statistiques de notes (V14 exercice 1 de tableaux)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-11', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'tableaux' AND e.title = 'Statistiques de notes';

-- Defi du 12 avril : Calculateur geometrique (V16 exercice 1 de methodes)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-12', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'methodes' AND e.title = 'Calculateur geometrique';

-- Defi du 13 avril : Somme des entiers (V12 exercice 3 de boucles)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-13', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'boucles' AND e.title = 'Somme des entiers';

-- Defi du 14 avril : Inverser un tableau (V14 exercice 2 de tableaux)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-14', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'tableaux' AND e.title = 'Inverser un tableau';

-- Defi du 15 avril : Maximum surchargé (V16 exercice 3 de methodes)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-15', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'methodes' AND e.title = E'Maximum surcharg\u00e9';

-- Defi du 16 avril : Table de multiplication (V12 exercice 2 de boucles)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-16', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'boucles' AND e.title = 'Table de multiplication';
