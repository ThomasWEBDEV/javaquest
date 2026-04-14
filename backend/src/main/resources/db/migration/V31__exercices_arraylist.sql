-- V31: Exercices ArrayList (lecon 1 Collections Java)

-- =============================================
-- EXERCICE 1 : Liste de Courses (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Liste de Courses',
    'Completez le code pour ajouter 4 articles a la liste de courses : "Pain", "Lait", "Oeufs" et "Beurre". Affichez ensuite chaque article avec une boucle for-each, puis affichez le nombre total d articles avec size(). Une ArrayList vide est deja declaree, ajoutez les elements un par un avec add().',
    E'import java.util.ArrayList;\n\npublic class Main {\n    public static void main(String[] args) {\n        ArrayList<String> courses = new ArrayList<>();\n\n        // TODO: ajoutez "Pain", "Lait", "Oeufs" et "Beurre"\n\n        // TODO: affichez chaque article avec une boucle for-each\n\n        // TODO: affichez "Total : X articles" avec size()\n    }\n}',
    E'import java.util.ArrayList;\n\npublic class Main {\n    public static void main(String[] args) {\n        ArrayList<String> courses = new ArrayList<>();\n\n        courses.add("Pain");\n        courses.add("Lait");\n        courses.add("Oeufs");\n        courses.add("Beurre");\n\n        for (String article : courses) {\n            System.out.println(article);\n        }\n\n        System.out.println("Total : " + courses.size() + " articles");\n    }\n}',
    'output.contains("Pain") && output.contains("Lait") && output.contains("Oeufs") && output.contains("Beurre") && output.contains("Total : 4 articles")',
    E'Utilisez courses.add("Pain"); pour chaque article. La boucle for-each s ecrit : for (String article : courses) { System.out.println(article); }. Pour la taille, concatenez : "Total : " + courses.size() + " articles". size() retourne 4 apres avoir ajoute 4 elements.',
    'EASY', 50, 1
FROM lessons l WHERE l.slug = 'arraylist';

-- =============================================
-- EXERCICE 2 : Filtrer les Nombres Pairs (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Filtrer les Nombres Pairs',
    'Une ArrayList de nombres est fournie. Parcourez-la et ajoutez uniquement les nombres pairs dans une nouvelle ArrayList nomme "pairs". Affichez ensuite chaque nombre pair. Un nombre est pair si le reste de sa division par 2 est egal a zero (n % 2 == 0). La liste d origine contient : 3, 8, 15, 4, 22, 7, 10, 13, 6.',
    E'import java.util.ArrayList;\n\npublic class Main {\n    public static void main(String[] args) {\n        ArrayList<Integer> nombres = new ArrayList<>();\n        nombres.add(3);\n        nombres.add(8);\n        nombres.add(15);\n        nombres.add(4);\n        nombres.add(22);\n        nombres.add(7);\n        nombres.add(10);\n        nombres.add(13);\n        nombres.add(6);\n\n        ArrayList<Integer> pairs = new ArrayList<>();\n\n        // TODO: parcourez nombres et ajoutez les pairs dans la liste pairs\n\n        // TODO: affichez chaque nombre pair\n    }\n}',
    E'import java.util.ArrayList;\n\npublic class Main {\n    public static void main(String[] args) {\n        ArrayList<Integer> nombres = new ArrayList<>();\n        nombres.add(3);\n        nombres.add(8);\n        nombres.add(15);\n        nombres.add(4);\n        nombres.add(22);\n        nombres.add(7);\n        nombres.add(10);\n        nombres.add(13);\n        nombres.add(6);\n\n        ArrayList<Integer> pairs = new ArrayList<>();\n\n        for (int n : nombres) {\n            if (n % 2 == 0) {\n                pairs.add(n);\n            }\n        }\n\n        for (int p : pairs) {\n            System.out.println(p);\n        }\n    }\n}',
    'output.contains("8") && output.contains("4") && output.contains("22") && output.contains("10") && output.contains("6") && !output.contains("3") && !output.contains("15")',
    E'Parcourez nombres avec for (int n : nombres). A l interieur, testez if (n % 2 == 0) : si vrai, faites pairs.add(n). Apres la boucle, parcourez pairs avec une seconde boucle for-each pour afficher chaque element. Les nombres pairs de la liste sont : 8, 4, 22, 10, 6. Les impairs (3, 15, 7, 13) ne doivent pas apparaitre.',
    'MEDIUM', 75, 2
FROM lessons l WHERE l.slug = 'arraylist';

-- =============================================
-- EXERCICE 3 : Gestionnaire de Taches (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Gestionnaire de Taches',
    'Implementez un gestionnaire de taches : ajoutez 4 taches a la liste ("Coder", "Tester", "Documenter", "Deployer"), puis supprimez la tache "Tester" avec remove(), verifiez que "Coder" est bien presente avec contains() et affichez le resultat, puis affichez toutes les taches restantes. La methode remove() avec une String supprime la premiere occurrence de cette valeur.',
    E'import java.util.ArrayList;\n\npublic class Main {\n    public static void main(String[] args) {\n        ArrayList<String> taches = new ArrayList<>();\n\n        // TODO: ajoutez "Coder", "Tester", "Documenter", "Deployer"\n\n        // TODO: supprimez "Tester" avec remove()\n\n        // TODO: verifiez que "Coder" est dans la liste et affichez\n        // "Coder present : true" ou "Coder present : false"\n\n        // TODO: affichez toutes les taches restantes avec une boucle\n    }\n}',
    E'import java.util.ArrayList;\n\npublic class Main {\n    public static void main(String[] args) {\n        ArrayList<String> taches = new ArrayList<>();\n\n        taches.add("Coder");\n        taches.add("Tester");\n        taches.add("Documenter");\n        taches.add("Deployer");\n\n        taches.remove("Tester");\n\n        System.out.println("Coder present : " + taches.contains("Coder"));\n\n        for (String tache : taches) {\n            System.out.println(tache);\n        }\n    }\n}',
    'output.contains("Coder present : true") && output.contains("Coder") && output.contains("Documenter") && output.contains("Deployer") && !output.contains("Tester")',
    E'Ajoutez les 4 taches avec add(). Pour supprimer "Tester" par valeur, utilisez taches.remove("Tester") : cela supprime la premiere occurrence de "Tester". Pour verifier, concatenez : "Coder present : " + taches.contains("Coder"). contains() retourne un boolean donc la concatenation affichera "true" ou "false". La liste finale contient 3 taches : Coder, Documenter, Deployer.',
    'HARD', 100, 3
FROM lessons l WHERE l.slug = 'arraylist';
