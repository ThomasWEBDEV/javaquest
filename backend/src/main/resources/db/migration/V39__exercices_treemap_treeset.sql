-- V39: Exercices TreeMap et TreeSet (EASY / MEDIUM / HARD)

-- =============================================
-- EXERCICE 1 : Dictionnaire Trie (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Dictionnaire Trie',
    'EASY',
    'Vous avez une liste de mots avec leur definition. Utilisez un TreeMap pour les stocker et les afficher dans l ordre alphabetique automatiquement.',
    E'import java.util.TreeMap;\n\npublic class Main {\n    public static void main(String[] args) {\n        // Creez un TreeMap<String, String> appele dictionnaire\n        // Ajoutez ces entrees :\n        // "variable" -> "valeur nommee pouvant changer"\n        // "methode"  -> "bloc de code reutilisable"\n        // "classe"   -> "modele pour creer des objets"\n        // "boucle"   -> "repetition d instructions"\n        // Affichez chaque entree avec le format : "mot : definition"\n    }\n}',
    E'import java.util.TreeMap;\n\npublic class Main {\n    public static void main(String[] args) {\n        TreeMap<String, String> dictionnaire = new TreeMap<>();\n        dictionnaire.put("variable", "valeur nommee pouvant changer");\n        dictionnaire.put("methode", "bloc de code reutilisable");\n        dictionnaire.put("classe", "modele pour creer des objets");\n        dictionnaire.put("boucle", "repetition d instructions");\n\n        for (String mot : dictionnaire.keySet()) {\n            System.out.println(mot + " : " + dictionnaire.get(mot));\n        }\n    }\n}',
    'output.contains("boucle") && output.contains("classe") && output.contains("methode") && output.contains("variable") && output.indexOf("boucle") < output.indexOf("classe") && output.indexOf("classe") < output.indexOf("methode") && output.indexOf("methode") < output.indexOf("variable")',
    '["Creez un TreeMap<String, String> et utilisez put() pour ajouter les entrees", "Parcourez keySet() avec une boucle for-each pour afficher les cles dans l ordre", "Le TreeMap trie automatiquement les cles alphabetiquement a chaque insertion"]',
    30,
    1
FROM lessons l WHERE l.slug = 'treemap-treeset';

-- =============================================
-- EXERCICE 2 : Classement des Etudiants (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Classement des Etudiants',
    'MEDIUM',
    'Vous avez une liste d etudiants avec leurs notes. Utilisez un TreeMap pour les trier par nom, puis affichez le meilleur et le moins bon eleve en utilisant les methodes firstKey/lastKey.',
    E'import java.util.TreeMap;\n\npublic class Main {\n    public static void main(String[] args) {\n        TreeMap<String, Integer> notes = new TreeMap<>();\n        notes.put("Sophie", 14);\n        notes.put("Lucas", 17);\n        notes.put("Emma", 11);\n        notes.put("Nathan", 19);\n        notes.put("Chloe", 13);\n\n        // Affichez "=== Classement ===" puis chaque etudiant : "Prenom : note/20"\n        // Affichez "Premier (alphabetique) : Prenom"\n        // Affichez "Dernier (alphabetique) : Prenom"\n    }\n}',
    E'import java.util.TreeMap;\n\npublic class Main {\n    public static void main(String[] args) {\n        TreeMap<String, Integer> notes = new TreeMap<>();\n        notes.put("Sophie", 14);\n        notes.put("Lucas", 17);\n        notes.put("Emma", 11);\n        notes.put("Nathan", 19);\n        notes.put("Chloe", 13);\n\n        System.out.println("=== Classement ===");\n        for (String etudiant : notes.keySet()) {\n            System.out.println(etudiant + " : " + notes.get(etudiant) + "/20");\n        }\n        System.out.println("Premier (alphabetique) : " + notes.firstKey());\n        System.out.println("Dernier (alphabetique) : " + notes.lastKey());\n    }\n}',
    'output.contains("=== Classement ===") && output.contains("Premier (alphabetique) : Chloe") && output.contains("Dernier (alphabetique) : Sophie") && output.indexOf("Chloe") < output.indexOf("Emma") && output.indexOf("Emma") < output.indexOf("Lucas")',
    '["Parcourez keySet() avec for-each pour afficher dans l ordre alphabetique", "Utilisez firstKey() pour obtenir la premiere cle alphabetique", "Utilisez lastKey() pour obtenir la derniere cle alphabetique"]',
    50,
    2
FROM lessons l WHERE l.slug = 'treemap-treeset';

-- =============================================
-- EXERCICE 3 : Mots Uniques Tries (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Mots Uniques Tries',
    'HARD',
    'Analysez un texte pour extraire tous les mots uniques et les afficher dans l ordre alphabetique. Utilisez un TreeSet pour stocker les mots uniques tries, puis affichez le premier et dernier mot ainsi que le nombre total.',
    E'import java.util.TreeSet;\n\npublic class Main {\n    public static void main(String[] args) {\n        String texte = "le chat mange le poisson et le chien mange la croquette";\n        String[] motsTableau = texte.split(" ");\n\n        // Creez un TreeSet<String> appele motsUniques\n        // Ajoutez tous les mots de motsTableau\n        // Affichez "Mots uniques : N" (N = nombre de mots uniques)\n        // Affichez "Premier mot : X"\n        // Affichez "Dernier mot : X"\n        // Affichez tous les mots uniques tries, un par ligne\n    }\n}',
    E'import java.util.TreeSet;\n\npublic class Main {\n    public static void main(String[] args) {\n        String texte = "le chat mange le poisson et le chien mange la croquette";\n        String[] motsTableau = texte.split(" ");\n\n        TreeSet<String> motsUniques = new TreeSet<>();\n        for (String mot : motsTableau) {\n            motsUniques.add(mot);\n        }\n\n        System.out.println("Mots uniques : " + motsUniques.size());\n        System.out.println("Premier mot : " + motsUniques.first());\n        System.out.println("Dernier mot : " + motsUniques.last());\n        for (String mot : motsUniques) {\n            System.out.println(mot);\n        }\n    }\n}',
    'output.contains("Mots uniques : 8") && output.contains("Premier mot : chat") && output.contains("Dernier mot : poisson")',
    '["Utilisez split(\" \") pour decouper le texte en tableau de mots", "Parcourez le tableau avec for-each et ajoutez chaque mot au TreeSet", "TreeSet ignore les doublons et trie automatiquement, utilisez first() et last() pour les extremes"]',
    80,
    3
FROM lessons l WHERE l.slug = 'treemap-treeset';
