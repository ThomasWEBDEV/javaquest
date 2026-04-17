-- V47: Exercices Optional (EASY / MEDIUM / HARD)

-- =============================================
-- EXERCICE 1 : Recherche de Contact (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Recherche de Contact',
    'EASY',
    'Implementez une methode rechercherContact() qui cherche un prenom dans une liste (sans tenir compte de la casse) et retourne un Optional<String>. Utilisez orElse et map pour afficher les resultats.',
    E'import java.util.Arrays;\nimport java.util.List;\nimport java.util.Optional;\n\npublic class Main {\n    static List<String> contacts = Arrays.asList("Alice", "Bob", "Charlie", "Diana");\n\n    public static Optional<String> rechercherContact(String prenom) {\n        // Utilisez contacts.stream()\n        // .filter() pour chercher (insensible a la casse avec equalsIgnoreCase)\n        // .findFirst() pour retourner un Optional\n    }\n\n    public static void main(String[] args) {\n        Optional<String> res1 = rechercherContact("bob");\n        System.out.println(res1.orElse("Introuvable")); // Bob\n\n        Optional<String> res2 = rechercherContact("Eve");\n        System.out.println(res2.orElse("Introuvable")); // Introuvable\n\n        rechercherContact("alice")\n            .map(String::toUpperCase)\n            .ifPresent(c -> System.out.println("Trouve : " + c)); // Trouve : ALICE\n    }\n}',
    E'import java.util.Arrays;\nimport java.util.List;\nimport java.util.Optional;\n\npublic class Main {\n    static List<String> contacts = Arrays.asList("Alice", "Bob", "Charlie", "Diana");\n\n    public static Optional<String> rechercherContact(String prenom) {\n        return contacts.stream()\n            .filter(c -> c.equalsIgnoreCase(prenom))\n            .findFirst();\n    }\n\n    public static void main(String[] args) {\n        Optional<String> res1 = rechercherContact("bob");\n        System.out.println(res1.orElse("Introuvable")); // Bob\n\n        Optional<String> res2 = rechercherContact("Eve");\n        System.out.println(res2.orElse("Introuvable")); // Introuvable\n\n        rechercherContact("alice")\n            .map(String::toUpperCase)\n            .ifPresent(c -> System.out.println("Trouve : " + c)); // Trouve : ALICE\n    }\n}',
    'output.contains("Bob") && output.contains("Introuvable") && output.contains("Trouve : ALICE")',
    '["contacts.stream().filter(...).findFirst() retourne directement un Optional<String>", "Utilisez equalsIgnoreCase(prenom) dans le filter pour ignorer la casse", "map(String::toUpperCase) transforme la valeur si presente, ifPresent() l affiche"]',
    30,
    1
FROM lessons l WHERE l.slug = 'optional-streams-securises';

-- =============================================
-- EXERCICE 2 : Parseur avec Optional (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Parseur avec Optional',
    'MEDIUM',
    'Implementez parseEntier() qui tente de convertir une chaine en Integer et retourne un Optional<Integer> (vide si la conversion echoue). Enchainez ensuite filter et map pour afficher uniquement les entiers positifs.',
    E'import java.util.Optional;\n\npublic class Main {\n\n    public static Optional<Integer> parseEntier(String s) {\n        // Essayez Integer.parseInt(s)\n        // Si succes : retournez Optional.of(valeur)\n        // En cas de NumberFormatException : retournez Optional.empty()\n    }\n\n    public static void main(String[] args) {\n        String[] valeurs = {"42", "abc", "100", "-7", "3.14"};\n\n        for (String v : valeurs) {\n            String resultat = parseEntier(v)\n                .filter(n -> n > 0)\n                .map(n -> "Positif : " + n)\n                .orElse("Non valide ou negatif : " + v);\n            System.out.println(resultat);\n        }\n    }\n}',
    E'import java.util.Optional;\n\npublic class Main {\n\n    public static Optional<Integer> parseEntier(String s) {\n        try {\n            return Optional.of(Integer.parseInt(s));\n        } catch (NumberFormatException e) {\n            return Optional.empty();\n        }\n    }\n\n    public static void main(String[] args) {\n        String[] valeurs = {"42", "abc", "100", "-7", "3.14"};\n\n        for (String v : valeurs) {\n            String resultat = parseEntier(v)\n                .filter(n -> n > 0)\n                .map(n -> "Positif : " + n)\n                .orElse("Non valide ou negatif : " + v);\n            System.out.println(resultat);\n        }\n    }\n}',
    'output.contains("Positif : 42") && output.contains("Non valide ou negatif : abc") && output.contains("Positif : 100") && output.contains("Non valide ou negatif : -7")',
    '["Dans parseEntier, utilisez try { return Optional.of(Integer.parseInt(s)); } catch (...) { return Optional.empty(); }", "filter(n -> n > 0) retourne Optional.empty() si l entier est negatif ou nul", "La chaine de map/filter ne fait rien si l Optional est vide, orElse fournit le texte par defaut"]',
    50,
    2
FROM lessons l WHERE l.slug = 'optional-streams-securises';

-- =============================================
-- EXERCICE 3 : Gestionnaire de Configuration (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Gestionnaire de Configuration',
    'HARD',
    'Implementez un gestionnaire de configuration qui lit des valeurs depuis une Map<String, String>. La methode getConfig() retourne un Optional<String>, et getConfigInt() utilise flatMap pour convertir en Integer (vide si absent ou non-numerique).',
    E'import java.util.HashMap;\nimport java.util.Map;\nimport java.util.Optional;\n\npublic class Main {\n\n    static Map<String, String> config = new HashMap<>();\n\n    static {\n        config.put("port", "8080");\n        config.put("timeout", "30");\n        config.put("nom_app", "MonApp");\n        config.put("debug", "false");\n    }\n\n    // Retourne la valeur de config pour la cle, ou Optional.empty() si absente\n    public static Optional<String> getConfig(String cle) {\n        // Utilisez Optional.ofNullable() avec config.get(cle)\n    }\n\n    // Retourne la valeur convertie en Integer, ou Optional.empty() si impossible\n    public static Optional<Integer> getConfigInt(String cle) {\n        // Utilisez getConfig(cle).flatMap(v -> {...})\n        // Dans le flatMap, essayez Integer.parseInt(v)\n        // Retournez Optional.of(valeur) si OK\n        // Retournez Optional.empty() si NumberFormatException\n    }\n\n    public static void main(String[] args) {\n        int port = getConfigInt("port").orElse(80);\n        System.out.println("Port : " + port);\n\n        int timeout = getConfigInt("timeout").orElse(60);\n        System.out.println("Timeout : " + timeout + "s");\n\n        int maxConn = getConfigInt("max_connexions").orElse(100);\n        System.out.println("Max connexions : " + maxConn);\n\n        int invalide = getConfigInt("nom_app").orElse(-1);\n        System.out.println("Config invalide : " + invalide);\n\n        getConfig("nom_app")\n            .map(String::toUpperCase)\n            .ifPresent(n -> System.out.println("Application : " + n));\n    }\n}',
    E'import java.util.HashMap;\nimport java.util.Map;\nimport java.util.Optional;\n\npublic class Main {\n\n    static Map<String, String> config = new HashMap<>();\n\n    static {\n        config.put("port", "8080");\n        config.put("timeout", "30");\n        config.put("nom_app", "MonApp");\n        config.put("debug", "false");\n    }\n\n    public static Optional<String> getConfig(String cle) {\n        return Optional.ofNullable(config.get(cle));\n    }\n\n    public static Optional<Integer> getConfigInt(String cle) {\n        return getConfig(cle).flatMap(v -> {\n            try {\n                return Optional.of(Integer.parseInt(v));\n            } catch (NumberFormatException e) {\n                return Optional.empty();\n            }\n        });\n    }\n\n    public static void main(String[] args) {\n        int port = getConfigInt("port").orElse(80);\n        System.out.println("Port : " + port);\n\n        int timeout = getConfigInt("timeout").orElse(60);\n        System.out.println("Timeout : " + timeout + "s");\n\n        int maxConn = getConfigInt("max_connexions").orElse(100);\n        System.out.println("Max connexions : " + maxConn);\n\n        int invalide = getConfigInt("nom_app").orElse(-1);\n        System.out.println("Config invalide : " + invalide);\n\n        getConfig("nom_app")\n            .map(String::toUpperCase)\n            .ifPresent(n -> System.out.println("Application : " + n));\n    }\n}',
    'output.contains("Port : 8080") && output.contains("Timeout : 30s") && output.contains("Max connexions : 100") && output.contains("Config invalide : -1") && output.contains("Application : MONAPP")',
    '["Optional.ofNullable(config.get(cle)) retourne Optional.empty() si la cle est absente (get retourne null)", "flatMap differe de map : il attend que la fonction retourne un Optional, evitant Optional<Optional<Integer>>", "Dans le flatMap, enveloppez Integer.parseInt dans try/catch et retournez Optional.empty() en cas d exception"]',
    80,
    3
FROM lessons l WHERE l.slug = 'optional-streams-securises';
