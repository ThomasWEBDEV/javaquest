-- V33: Exercices HashMap (lecon 2 Collections Java)

-- =============================================
-- EXERCICE 1 : Annuaire Telephonique (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Annuaire Telephonique',
    'Completez le code pour creer un annuaire telephonique avec une HashMap<String, String> (nom -> numero). Ajoutez trois contacts : "Alice" avec "06-11-22-33-44", "Bob" avec "07-55-66-77-88" et "Clara" avec "06-99-00-11-22". Affichez ensuite le numero de "Bob" avec get(), puis le nombre de contacts avec size().',
    E'import java.util.HashMap;\n\npublic class Main {\n    public static void main(String[] args) {\n        HashMap<String, String> annuaire = new HashMap<>();\n\n        // TODO: ajoutez Alice, Bob et Clara avec leur numero\n\n        // TODO: affichez le numero de Bob\n        // format attendu : "Numero de Bob : 07-55-66-77-88"\n\n        // TODO: affichez le nombre de contacts\n        // format attendu : "Contacts : 3"\n    }\n}',
    E'import java.util.HashMap;\n\npublic class Main {\n    public static void main(String[] args) {\n        HashMap<String, String> annuaire = new HashMap<>();\n\n        annuaire.put("Alice", "06-11-22-33-44");\n        annuaire.put("Bob", "07-55-66-77-88");\n        annuaire.put("Clara", "06-99-00-11-22");\n\n        System.out.println("Numero de Bob : " + annuaire.get("Bob"));\n        System.out.println("Contacts : " + annuaire.size());\n    }\n}',
    'output.contains("Numero de Bob : 07-55-66-77-88") && output.contains("Contacts : 3")',
    E'Utilisez annuaire.put("Alice", "06-11-22-33-44"); pour ajouter chaque contact. get("Bob") retourne la valeur associee a la cle "Bob". Pour le nombre, concatenez : "Contacts : " + annuaire.size(). Apres 3 put(), size() retourne 3.',
    'EASY', 50, 1
FROM lessons l WHERE l.slug = 'hashmap';

-- =============================================
-- EXERCICE 2 : Compteur de Votes (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Compteur de Votes',
    'Un tableau de votes est fourni. Chaque vote est le nom d un candidat. Comptez le nombre de votes pour chaque candidat en utilisant une HashMap<String, Integer> et getOrDefault(). Affichez ensuite les resultats de chaque candidat en parcourant keySet(). Le tableau contient : "Alice", "Bob", "Alice", "Clara", "Bob", "Alice", "Bob", "Clara", "Alice".',
    E'import java.util.HashMap;\n\npublic class Main {\n    public static void main(String[] args) {\n        String[] votes = {"Alice", "Bob", "Alice", "Clara", "Bob", "Alice", "Bob", "Clara", "Alice"};\n        HashMap<String, Integer> resultats = new HashMap<>();\n\n        // TODO: parcourez votes et comptez les voix de chaque candidat\n        // utilisez getOrDefault(candidat, 0) pour initialiser a 0\n\n        // TODO: affichez les resultats\n        // format attendu : "Alice : 4", "Bob : 3", "Clara : 2"\n    }\n}',
    E'import java.util.HashMap;\n\npublic class Main {\n    public static void main(String[] args) {\n        String[] votes = {"Alice", "Bob", "Alice", "Clara", "Bob", "Alice", "Bob", "Clara", "Alice"};\n        HashMap<String, Integer> resultats = new HashMap<>();\n\n        for (String candidat : votes) {\n            int count = resultats.getOrDefault(candidat, 0);\n            resultats.put(candidat, count + 1);\n        }\n\n        for (String candidat : resultats.keySet()) {\n            System.out.println(candidat + " : " + resultats.get(candidat));\n        }\n    }\n}',
    'output.contains("Alice : 4") && output.contains("Bob : 3") && output.contains("Clara : 2")',
    E'Pour chaque vote dans votes, recuperez le compteur actuel : int count = resultats.getOrDefault(candidat, 0);. Cela retourne 0 si le candidat n a pas encore de voix. Puis mettez a jour : resultats.put(candidat, count + 1);. Apres le comptage, parcourez resultats.keySet() pour afficher chaque paire. Alice a 4 voix (positions 0,2,5,8), Bob 3 (1,4,6), Clara 2 (3,7).',
    'MEDIUM', 75, 2
FROM lessons l WHERE l.slug = 'hashmap';

-- =============================================
-- EXERCICE 3 : Inventaire de Magasin (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index)
SELECT l.id,
    'Inventaire de Magasin',
    'Gerez un inventaire de magasin avec une HashMap<String, Integer> (produit -> quantite). Ajoutez "Pommes" (50), "Bananes" (30) et "Oranges" (20). Ensuite : vendez 15 Pommes (decrementez), verifiez si "Mangues" est en stock avec containsKey() et affichez "Mangues en stock : false", puis affichez tous les produits et quantites. Pommes doit afficher 35 apres la vente.',
    E'import java.util.HashMap;\n\npublic class Main {\n    public static void main(String[] args) {\n        HashMap<String, Integer> inventaire = new HashMap<>();\n\n        // TODO: ajoutez Pommes (50), Bananes (30), Oranges (20)\n\n        // TODO: vendez 15 Pommes\n        // recuperez la quantite actuelle, soustrayez 15, remettez avec put()\n\n        // TODO: affichez "Mangues en stock : " + le resultat de containsKey("Mangues")\n\n        // TODO: affichez tous les produits et quantites\n        // format : "Pommes : 35", "Bananes : 30", "Oranges : 20"\n    }\n}',
    E'import java.util.HashMap;\n\npublic class Main {\n    public static void main(String[] args) {\n        HashMap<String, Integer> inventaire = new HashMap<>();\n\n        inventaire.put("Pommes", 50);\n        inventaire.put("Bananes", 30);\n        inventaire.put("Oranges", 20);\n\n        inventaire.put("Pommes", inventaire.get("Pommes") - 15);\n\n        System.out.println("Mangues en stock : " + inventaire.containsKey("Mangues"));\n\n        for (String produit : inventaire.keySet()) {\n            System.out.println(produit + " : " + inventaire.get(produit));\n        }\n    }\n}',
    'output.contains("Mangues en stock : false") && output.contains("Pommes : 35") && output.contains("Bananes : 30") && output.contains("Oranges : 20")',
    E'Ajoutez les 3 produits avec put(). Pour vendre 15 Pommes, utilisez la valeur actuelle : inventaire.put("Pommes", inventaire.get("Pommes") - 15); Cela lit 50, soustrait 15, remet 35. containsKey("Mangues") retourne false car Mangues n a jamais ete ajoute. Parcourez keySet() pour afficher tous les produits avec leur quantite.',
    'HARD', 100, 3
FROM lessons l WHERE l.slug = 'hashmap';
