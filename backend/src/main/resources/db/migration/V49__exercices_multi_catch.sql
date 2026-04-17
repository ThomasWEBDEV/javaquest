-- V49: Exercices Multi-catch et propagation (EASY / MEDIUM / HARD)

-- =============================================
-- EXERCICE 1 : Analyseur de Types (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Analyseur de Types',
    'EASY',
    'Implementez analyser() qui tente de convertir une chaine en Integer, puis en Double, et retourne une description du type detecte. Utilisez un bloc try/catch distinct pour chaque tentative.',
    E'public class Main {\n\n    public static String analyser(String valeur) {\n        // 1. Tentez Integer.parseInt(valeur)\n        //    Si succes : retournez "Entier : " + valeur\n        // 2. En cas de NumberFormatException, tentez Double.parseDouble(valeur)\n        //    Si succes : retournez "Decimal : " + valeur\n        // 3. En cas de nouvelle NumberFormatException :\n        //    retournez "Texte : " + valeur\n    }\n\n    public static void main(String[] args) {\n        String[] valeurs = {"42", "3.14", "bonjour", "-100", "1e5"};\n        for (String v : valeurs) {\n            System.out.println(analyser(v));\n        }\n    }\n}',
    E'public class Main {\n\n    public static String analyser(String valeur) {\n        try {\n            Integer.parseInt(valeur);\n            return "Entier : " + valeur;\n        } catch (NumberFormatException e1) {\n            try {\n                Double.parseDouble(valeur);\n                return "Decimal : " + valeur;\n            } catch (NumberFormatException e2) {\n                return "Texte : " + valeur;\n            }\n        }\n    }\n\n    public static void main(String[] args) {\n        String[] valeurs = {"42", "3.14", "bonjour", "-100", "1e5"};\n        for (String v : valeurs) {\n            System.out.println(analyser(v));\n        }\n    }\n}',
    'output.contains("Entier : 42") && output.contains("Decimal : 3.14") && output.contains("Texte : bonjour") && output.contains("Entier : -100") && output.contains("Decimal : 1e5")',
    '["Utilisez deux try/catch imbriques : le catch du premier contient le second try", "Integer.parseInt rejette 3.14 et 1e5 (notation scientifique), mais Double.parseDouble les accepte", "Si les deux parseDouble echouent, c est du texte : retournez simplement la chaine avec le prefixe"]',
    30,
    1
FROM lessons l WHERE l.slug = 'multi-catch-propagation';

-- =============================================
-- EXERCICE 2 : Convertisseur avec Propagation (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Convertisseur avec Propagation',
    'MEDIUM',
    'Implementez getConfigInt() qui lit une valeur depuis une Map, puis la convertit en entier. Encapsulez les erreurs techniques (cle absente ou valeur non-numerique) dans une ConfigException metier en conservant la cause originale.',
    E'import java.util.HashMap;\nimport java.util.Map;\n\npublic class Main {\n\n    static class ConfigException extends RuntimeException {\n        public ConfigException(String message, Throwable cause) {\n            super(message, cause);\n        }\n    }\n\n    static Map<String, String> config = new HashMap<>();\n    static {\n        config.put("port", "8080");\n        config.put("timeout", "trente");\n        config.put("max_users", "500");\n    }\n\n    public static int getConfigInt(String cle) {\n        // 1. Recuperez la valeur avec config.get(cle)\n        // 2. Si null : lancez ConfigException("Cle absente : " + cle, null)\n        // 3. Tentez Integer.parseInt(valeur)\n        // 4. Si NumberFormatException : lancez ConfigException\n        //    avec message "Valeur invalide pour " + cle + " : " + valeur\n        //    et la cause originale (l exception NumberFormatException)\n    }\n\n    public static void main(String[] args) {\n        String[] cles = {"port", "timeout", "debug"};\n\n        for (String cle : cles) {\n            try {\n                int valeur = getConfigInt(cle);\n                System.out.println(cle + " = " + valeur);\n            } catch (ConfigException e) {\n                System.out.println("Erreur config : " + e.getMessage());\n                if (e.getCause() != null) {\n                    System.out.println("  Cause : " + e.getCause().getClass().getSimpleName());\n                }\n            }\n        }\n    }\n}',
    E'import java.util.HashMap;\nimport java.util.Map;\n\npublic class Main {\n\n    static class ConfigException extends RuntimeException {\n        public ConfigException(String message, Throwable cause) {\n            super(message, cause);\n        }\n    }\n\n    static Map<String, String> config = new HashMap<>();\n    static {\n        config.put("port", "8080");\n        config.put("timeout", "trente");\n        config.put("max_users", "500");\n    }\n\n    public static int getConfigInt(String cle) {\n        String valeur = config.get(cle);\n        if (valeur == null) {\n            throw new ConfigException("Cle absente : " + cle, null);\n        }\n        try {\n            return Integer.parseInt(valeur);\n        } catch (NumberFormatException e) {\n            throw new ConfigException("Valeur invalide pour " + cle + " : " + valeur, e);\n        }\n    }\n\n    public static void main(String[] args) {\n        String[] cles = {"port", "timeout", "debug"};\n\n        for (String cle : cles) {\n            try {\n                int valeur = getConfigInt(cle);\n                System.out.println(cle + " = " + valeur);\n            } catch (ConfigException e) {\n                System.out.println("Erreur config : " + e.getMessage());\n                if (e.getCause() != null) {\n                    System.out.println("  Cause : " + e.getCause().getClass().getSimpleName());\n                }\n            }\n        }\n    }\n}',
    'output.contains("port = 8080") && output.contains("Valeur invalide pour timeout : trente") && output.contains("Cause : NumberFormatException") && output.contains("Cle absente : debug")',
    '["Verifiez null avec config.get(cle) == null avant de tenter le parsing", "Pour la ConfigException due a NumberFormatException, passez l exception originale comme second argument : new ConfigException(message, e)", "getCause() retourne null si la ConfigException a ete creee avec null comme cause (cas cle absente)"]',
    50,
    2
FROM lessons l WHERE l.slug = 'multi-catch-propagation';

-- =============================================
-- EXERCICE 3 : Ressource Simulee (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Ressource Simulee',
    'HARD',
    'Creez une classe ConnexionBD qui implemente AutoCloseable. Utilisez try-with-resources pour garantir que close() est toujours appele, meme quand executer() leve une exception. Observez l ordre des messages dans les deux scenarios.',
    E'public class Main {\n\n    // Implementez ConnexionBD avec AutoCloseable\n    // Constructeur(String serveur) : affiche "Connexion etablie : " + serveur\n    // executer(String requete) : retourne "Resultat de : " + requete\n    //   Si requete.equals("ERREUR") : lancez RuntimeException("Erreur SQL : syntaxe invalide")\n    // close() : affiche "Connexion fermee : " + serveur\n\n    public static void main(String[] args) {\n        // Test 1 : execution normale avec try-with-resources\n        System.out.println("--- Test normal ---");\n        try (ConnexionBD bd = new ConnexionBD("localhost")) {\n            System.out.println(bd.executer("SELECT * FROM users"));\n        }\n\n        // Test 2 : exception pendant l execution\n        System.out.println("--- Test avec erreur ---");\n        try (ConnexionBD bd = new ConnexionBD("localhost")) {\n            System.out.println(bd.executer("ERREUR"));\n        } catch (RuntimeException e) {\n            System.out.println("Caught : " + e.getMessage());\n        }\n    }\n}',
    E'public class Main {\n\n    static class ConnexionBD implements AutoCloseable {\n        private String serveur;\n\n        public ConnexionBD(String serveur) {\n            this.serveur = serveur;\n            System.out.println("Connexion etablie : " + serveur);\n        }\n\n        public String executer(String requete) {\n            if (requete.equals("ERREUR")) {\n                throw new RuntimeException("Erreur SQL : syntaxe invalide");\n            }\n            return "Resultat de : " + requete;\n        }\n\n        @Override\n        public void close() {\n            System.out.println("Connexion fermee : " + serveur);\n        }\n    }\n\n    public static void main(String[] args) {\n        System.out.println("--- Test normal ---");\n        try (ConnexionBD bd = new ConnexionBD("localhost")) {\n            System.out.println(bd.executer("SELECT * FROM users"));\n        }\n\n        System.out.println("--- Test avec erreur ---");\n        try (ConnexionBD bd = new ConnexionBD("localhost")) {\n            System.out.println(bd.executer("ERREUR"));\n        } catch (RuntimeException e) {\n            System.out.println("Caught : " + e.getMessage());\n        }\n    }\n}',
    'output.contains("Connexion etablie : localhost") && output.contains("Resultat de : SELECT * FROM users") && output.contains("Connexion fermee : localhost") && output.contains("Caught : Erreur SQL : syntaxe invalide")',
    '["ConnexionBD doit implementer AutoCloseable : class ConnexionBD implements AutoCloseable", "La methode close() est appelee automatiquement a la fin du bloc try, avant que le catch ne soit execute", "Observez le Test 2 : Connexion fermee apparait AVANT Caught, prouvant que close() est garanti"]',
    80,
    3
FROM lessons l WHERE l.slug = 'multi-catch-propagation';
