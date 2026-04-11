-- V20: Exercices Heritage + Defis quotidiens POO (semaine du 17 avril 2026)

-- =============================================
-- EXERCICE 1 : Heritage Animal (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Heritage Animal',
    'Completez les methodes parler() de Chien et Chat en les redefinissant (@Override). Chien.parler() doit retourner nom + " dit : Ouaf !", Chat.parler() doit retourner nom + " dit : Miaou !". La classe Animal de base retourne nom + " fait un bruit.".',
    E'public class Main {\n\n    static class Animal {\n        String nom;\n\n        Animal(String nom) {\n            this.nom = nom;\n        }\n\n        String parler() {\n            return nom + " fait un bruit.";\n        }\n    }\n\n    static class Chien extends Animal {\n        Chien(String nom) {\n            super(nom);\n        }\n\n        @Override\n        String parler() {\n            // TODO: retournez nom + " dit : Ouaf !"\n            return "";\n        }\n    }\n\n    static class Chat extends Animal {\n        Chat(String nom) {\n            super(nom);\n        }\n\n        @Override\n        String parler() {\n            // TODO: retournez nom + " dit : Miaou !"\n            return "";\n        }\n    }\n\n    public static void main(String[] args) {\n        Animal generique = new Animal("Bete");\n        Chien rex = new Chien("Rex");\n        Chat felix = new Chat("Felix");\n\n        System.out.println(generique.parler());\n        System.out.println(rex.parler());\n        System.out.println(felix.parler());\n    }\n}',
    E'public class Main {\n\n    static class Animal {\n        String nom;\n\n        Animal(String nom) {\n            this.nom = nom;\n        }\n\n        String parler() {\n            return nom + " fait un bruit.";\n        }\n    }\n\n    static class Chien extends Animal {\n        Chien(String nom) {\n            super(nom);\n        }\n\n        @Override\n        String parler() {\n            return nom + " dit : Ouaf !";\n        }\n    }\n\n    static class Chat extends Animal {\n        Chat(String nom) {\n            super(nom);\n        }\n\n        @Override\n        String parler() {\n            return nom + " dit : Miaou !";\n        }\n    }\n\n    public static void main(String[] args) {\n        Animal generique = new Animal("Bete");\n        Chien rex = new Chien("Rex");\n        Chat felix = new Chat("Felix");\n\n        System.out.println(generique.parler());\n        System.out.println(rex.parler());\n        System.out.println(felix.parler());\n    }\n}',
    'output.contains("Ouaf") && output.contains("Miaou") && output.contains("bruit")',
    E'Chien.parler() herite du champ nom de Animal via super(nom). Retournez simplement nom + " dit : Ouaf !". Meme chose pour Chat.parler() avec " dit : Miaou !". Le constructeur de Chien appelle super(nom) pour initialiser le champ nom defini dans Animal : vous pouvez donc utiliser nom directement.',
    'EASY', 50, 1
FROM lessons l WHERE l.slug = 'heritage-polymorphisme';

-- =============================================
-- EXERCICE 2 : Salaires Employes (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Salaires Employes',
    'Completez la classe Employe : getSalaire() retourne le salaire. Completez Manager qui extends Employe : le constructeur appelle super(), calculerSalaire() retourne salaire + bonus. La methode afficher() de Employe appelle calculerSalaire() et l affiche.',
    E'public class Main {\n\n    static class Employe {\n        String nom;\n        double salaire;\n\n        Employe(String nom, double salaire) {\n            this.nom = nom;\n            this.salaire = salaire;\n        }\n\n        double calculerSalaire() {\n            // TODO: retournez le salaire de base\n            return 0;\n        }\n\n        void afficher() {\n            System.out.println(nom + " : " + calculerSalaire() + " euros");\n        }\n    }\n\n    static class Manager extends Employe {\n        double bonus;\n\n        Manager(String nom, double salaire, double bonus) {\n            // TODO: appelez super() et initialisez this.bonus\n            this.bonus = bonus;\n        }\n\n        @Override\n        double calculerSalaire() {\n            // TODO: retournez salaire + bonus\n            return 0;\n        }\n    }\n\n    public static void main(String[] args) {\n        Employe emp = new Employe("Alice", 2500.0);\n        Manager mgr = new Manager("Bob", 3000.0, 800.0);\n\n        emp.afficher(); // Alice : 2500.0 euros\n        mgr.afficher(); // Bob : 3800.0 euros\n    }\n}',
    E'public class Main {\n\n    static class Employe {\n        String nom;\n        double salaire;\n\n        Employe(String nom, double salaire) {\n            this.nom = nom;\n            this.salaire = salaire;\n        }\n\n        double calculerSalaire() {\n            return salaire;\n        }\n\n        void afficher() {\n            System.out.println(nom + " : " + calculerSalaire() + " euros");\n        }\n    }\n\n    static class Manager extends Employe {\n        double bonus;\n\n        Manager(String nom, double salaire, double bonus) {\n            super(nom, salaire);\n            this.bonus = bonus;\n        }\n\n        @Override\n        double calculerSalaire() {\n            return salaire + bonus;\n        }\n    }\n\n    public static void main(String[] args) {\n        Employe emp = new Employe("Alice", 2500.0);\n        Manager mgr = new Manager("Bob", 3000.0, 800.0);\n\n        emp.afficher(); // Alice : 2500.0 euros\n        mgr.afficher(); // Bob : 3800.0 euros\n    }\n}',
    'output.contains("2500.0") && output.contains("3800.0")',
    E'Employe.calculerSalaire() : retournez simplement salaire. Manager constructeur : appelez super(nom, salaire) en premiere instruction avant this.bonus = bonus. Manager.calculerSalaire() : retournez salaire + bonus. salaire est accessible depuis Manager car il n est pas private dans Employe. Bob : 3000 + 800 = 3800.0.',
    'MEDIUM', 75, 2
FROM lessons l WHERE l.slug = 'heritage-polymorphisme';

-- =============================================
-- EXERCICE 3 : Zoo Polymorphe (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Zoo Polymorphe',
    'Completez crier() dans Lion (retourne nom + " rugit !") et dans Perroquet (retourne nom + " dit : " + phrase). Le main cree un tableau de type Animal[] contenant differents animaux et parcourt le tableau en appelant crier() sur chacun. C est le polymorphisme en action.',
    E'public class Main {\n\n    static class Animal {\n        String nom;\n\n        Animal(String nom) {\n            this.nom = nom;\n        }\n\n        String crier() {\n            return nom + " !";\n        }\n\n        String getType() { return "Animal"; }\n    }\n\n    static class Lion extends Animal {\n        Lion(String nom) {\n            super(nom);\n        }\n\n        @Override\n        String crier() {\n            // TODO: retournez nom + " rugit !"\n            return "";\n        }\n\n        @Override\n        String getType() { return "Lion"; }\n    }\n\n    static class Perroquet extends Animal {\n        String phrase;\n\n        Perroquet(String nom, String phrase) {\n            super(nom);\n            this.phrase = phrase;\n        }\n\n        @Override\n        String crier() {\n            // TODO: retournez nom + " dit : " + phrase\n            return "";\n        }\n\n        @Override\n        String getType() { return "Perroquet"; }\n    }\n\n    public static void main(String[] args) {\n        Animal[] zoo = {\n            new Lion("Simba"),\n            new Perroquet("Coco", "Bonjour !"),\n            new Lion("Mufasa"),\n            new Perroquet("Jacko", "Au revoir !")\n        };\n\n        for (Animal a : zoo) {\n            System.out.println("[" + a.getType() + "] " + a.crier());\n        }\n    }\n}',
    E'public class Main {\n\n    static class Animal {\n        String nom;\n\n        Animal(String nom) {\n            this.nom = nom;\n        }\n\n        String crier() {\n            return nom + " !";\n        }\n\n        String getType() { return "Animal"; }\n    }\n\n    static class Lion extends Animal {\n        Lion(String nom) {\n            super(nom);\n        }\n\n        @Override\n        String crier() {\n            return nom + " rugit !";\n        }\n\n        @Override\n        String getType() { return "Lion"; }\n    }\n\n    static class Perroquet extends Animal {\n        String phrase;\n\n        Perroquet(String nom, String phrase) {\n            super(nom);\n            this.phrase = phrase;\n        }\n\n        @Override\n        String crier() {\n            return nom + " dit : " + phrase;\n        }\n\n        @Override\n        String getType() { return "Perroquet"; }\n    }\n\n    public static void main(String[] args) {\n        Animal[] zoo = {\n            new Lion("Simba"),\n            new Perroquet("Coco", "Bonjour !"),\n            new Lion("Mufasa"),\n            new Perroquet("Jacko", "Au revoir !")\n        };\n\n        for (Animal a : zoo) {\n            System.out.println("[" + a.getType() + "] " + a.crier());\n        }\n    }\n}',
    'output.contains("Simba rugit") && output.contains("Coco dit") && output.contains("Mufasa") && output.contains("Jacko")',
    E'Lion.crier() : retournez nom + " rugit !". Perroquet.crier() : retournez nom + " dit : " + phrase. Le champ phrase est initialise dans le constructeur de Perroquet. Le polymorphisme fait que meme si le tableau est Animal[], Java appelle automatiquement la bonne version de crier() selon le type reel de chaque objet (Lion ou Perroquet).',
    'HARD', 100, 3
FROM lessons l WHERE l.slug = 'heritage-polymorphisme';

-- =============================================
-- DEFIS QUOTIDIENS (semaine du 17 avril 2026)
-- =============================================

-- Defi du 17 avril : Classe Personne (V18 exercice 1 de classes-et-objets)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-17', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'classes-et-objets' AND e.title = 'Classe Personne';

-- Defi du 18 avril : Compte Bancaire (V18 exercice 2 de classes-et-objets)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-18', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'classes-et-objets' AND e.title = 'Compte Bancaire';

-- Defi du 19 avril : Gestion de livres (V18 exercice 3 de classes-et-objets)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-19', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'classes-et-objets' AND e.title = 'Gestion de livres';

-- Defi du 20 avril : Heritage Animal (V20 exercice 1 de heritage)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-20', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'heritage-polymorphisme' AND e.title = 'Heritage Animal';

-- Defi du 21 avril : Salaires Employes (V20 exercice 2 de heritage)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-21', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'heritage-polymorphisme' AND e.title = 'Salaires Employes';

-- Defi du 22 avril : Zoo Polymorphe (V20 exercice 3 de heritage)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-22', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'heritage-polymorphisme' AND e.title = 'Zoo Polymorphe';

-- Defi du 23 avril : Calculateur geometrique (recyclage V16 - revisions methodes)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-23', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'methodes' AND e.title = 'Calculateur geometrique';
