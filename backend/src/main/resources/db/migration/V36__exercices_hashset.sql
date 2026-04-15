-- V36: Exercices HashSet (EASY / MEDIUM / HARD)

-- =============================================
-- EXERCICE 1 : Invites Uniques (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Invites Uniques',
    'EASY',
    'Une liste d inscriptions contient des noms en double. Utilisez un HashSet pour compter le nombre d invites uniques et eliminer les doublons.',
    E'import java.util.HashSet;\nimport java.util.ArrayList;\n\npublic class Main {\n    public static void main(String[] args) {\n        ArrayList<String> listeInscriptions = new ArrayList<>();\n        listeInscriptions.add("Alice");\n        listeInscriptions.add("Bob");\n        listeInscriptions.add("Alice");\n        listeInscriptions.add("Charlie");\n        listeInscriptions.add("Bob");\n        listeInscriptions.add("David");\n        listeInscriptions.add("Alice");\n\n        // Creez un HashSet<String> appele invitesUniques\n        // Ajoutez tous les elements de listeInscriptions dans le HashSet\n        // Affichez : "Inscriptions : 7"\n        // Affichez : "Invites uniques : 4"\n    }\n}',
    E'import java.util.HashSet;\nimport java.util.ArrayList;\n\npublic class Main {\n    public static void main(String[] args) {\n        ArrayList<String> listeInscriptions = new ArrayList<>();\n        listeInscriptions.add("Alice");\n        listeInscriptions.add("Bob");\n        listeInscriptions.add("Alice");\n        listeInscriptions.add("Charlie");\n        listeInscriptions.add("Bob");\n        listeInscriptions.add("David");\n        listeInscriptions.add("Alice");\n\n        HashSet<String> invitesUniques = new HashSet<>();\n        for (String nom : listeInscriptions) {\n            invitesUniques.add(nom);\n        }\n\n        System.out.println("Inscriptions : " + listeInscriptions.size());\n        System.out.println("Invites uniques : " + invitesUniques.size());\n    }\n}',
    'output.contains("Inscriptions : 7") && output.contains("Invites uniques : 4")',
    '["Creez un HashSet<String> et parcourez listeInscriptions avec for-each", "La methode add() sur un HashSet ignore automatiquement les doublons", "Utilisez .size() sur la liste ET sur le HashSet pour les deux affichages"]',
    30,
    1
FROM lessons l WHERE l.slug = 'hashset';

-- =============================================
-- EXERCICE 2 : Membres Communs (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Membres Communs',
    'MEDIUM',
    'Deux equipes de projet ont des membres. Trouvez les personnes presentes dans les deux equipes en utilisant un HashSet pour l intersection.',
    E'import java.util.HashSet;\n\npublic class Main {\n    public static void main(String[] args) {\n        String[] equipe1 = {"Alice", "Bob", "Charlie", "David", "Emma"};\n        String[] equipe2 = {"Bob", "Frank", "Alice", "Grace", "Charlie"};\n\n        // Creez un HashSet avec les membres de equipe1\n        // Parcourez equipe2 : si le membre est dans le HashSet, ajoutez-le a un second HashSet "communs"\n        // Affichez "Membres communs :" suivi de chaque nom (un par ligne)\n        // Affichez "Total communs : X"\n    }\n}',
    E'import java.util.HashSet;\n\npublic class Main {\n    public static void main(String[] args) {\n        String[] equipe1 = {"Alice", "Bob", "Charlie", "David", "Emma"};\n        String[] equipe2 = {"Bob", "Frank", "Alice", "Grace", "Charlie"};\n\n        HashSet<String> set1 = new HashSet<>();\n        for (String membre : equipe1) {\n            set1.add(membre);\n        }\n\n        HashSet<String> communs = new HashSet<>();\n        for (String membre : equipe2) {\n            if (set1.contains(membre)) {\n                communs.add(membre);\n            }\n        }\n\n        System.out.println("Membres communs :");\n        for (String nom : communs) {\n            System.out.println(nom);\n        }\n        System.out.println("Total communs : " + communs.size());\n    }\n}',
    'output.contains("Alice") && output.contains("Bob") && output.contains("Charlie") && output.contains("Total communs : 3")',
    '["Commencez par mettre tous les membres de equipe1 dans un premier HashSet", "Pour equipe2, utilisez contains() sur le premier HashSet pour tester la presence", "Stockez les membres communs dans un deuxieme HashSet pour eviter les doublons"]',
    50,
    2
FROM lessons l WHERE l.slug = 'hashset';

-- =============================================
-- EXERCICE 3 : Mots Importants (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Mots Importants',
    'HARD',
    'Filtrez les mots sans interet (stopwords) d un texte pour extraire uniquement les mots importants. Chaque mot important ne doit apparaitre qu une seule fois.',
    E'import java.util.HashSet;\n\npublic class Main {\n    public static void main(String[] args) {\n        String[] stopwords = {"le", "la", "les", "de", "du", "un", "une", "et", "en", "au"};\n        String texte = "le chat de la voisine et un chien au jardin mangent du poisson en silence";\n        String[] mots = texte.split(" ");\n\n        // Creez un HashSet<String> de stopwords\n        // Creez un HashSet<String> pour les mots importants\n        // Pour chaque mot du texte : ajoutez-le aux mots importants seulement s il n est pas un stopword\n        // Affichez "Mots importants :" suivi de chaque mot (un par ligne)\n        // Affichez "Nombre de mots importants : X"\n    }\n}',
    E'import java.util.HashSet;\n\npublic class Main {\n    public static void main(String[] args) {\n        String[] stopwords = {"le", "la", "les", "de", "du", "un", "une", "et", "en", "au"};\n        String texte = "le chat de la voisine et un chien au jardin mangent du poisson en silence";\n        String[] mots = texte.split(" ");\n\n        HashSet<String> stops = new HashSet<>();\n        for (String s : stopwords) {\n            stops.add(s);\n        }\n\n        HashSet<String> motsImportants = new HashSet<>();\n        for (String mot : mots) {\n            if (!stops.contains(mot)) {\n                motsImportants.add(mot);\n            }\n        }\n\n        System.out.println("Mots importants :");\n        for (String mot : motsImportants) {\n            System.out.println(mot);\n        }\n        System.out.println("Nombre de mots importants : " + motsImportants.size());\n    }\n}',
    'output.contains("chat") && output.contains("poisson") && output.contains("Nombre de mots importants : 7")',
    '["Commencez par charger tous les stopwords dans un premier HashSet", "Utilisez !stops.contains(mot) pour filtrer les mots a garder", "Le HashSet motsImportants elimine automatiquement les eventuels doublons dans le texte", "Les 7 mots importants sont : chat, voisine, chien, jardin, mangent, poisson, silence"]',
    80,
    3
FROM lessons l WHERE l.slug = 'hashset';
