-- V82: Exercices Callable et Future

-- =============================================
-- EXERCICE 1 : Mon Premier Callable (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Mon Premier Callable',
    'EASY',
    'Creez un ExecutorService a 2 threads. Soumettez un Callable<String> qui retourne "Bonjour depuis Callable". Recuperez le resultat avec future.get() et affichez "Resultat: " + le resultat. Appelez pool.shutdown().',
    E'import java.util.concurrent.*;\n\npublic class Main {\n    public static void main(String[] args) throws Exception {\n        ExecutorService pool = Executors.newFixedThreadPool(2);\n\n        // Soumettez un Callable<String> qui retourne "Bonjour depuis Callable"\n        // Recuperez le Future<String>\n\n        // Recuperez le resultat avec get()\n\n        // Affichez "Resultat: " + resultat\n\n        pool.shutdown();\n    }\n}',
    E'import java.util.concurrent.*;\n\npublic class Main {\n    public static void main(String[] args) throws Exception {\n        ExecutorService pool = Executors.newFixedThreadPool(2);\n\n        Future<String> futur = pool.submit(() -> "Bonjour depuis Callable");\n\n        String resultat = futur.get();\n        System.out.println("Resultat: " + resultat);\n\n        pool.shutdown();\n    }\n}',
    'output.contains("Resultat: Bonjour depuis Callable")',
    '["Utilisez pool.submit(() -> \"Bonjour depuis Callable\") pour soumettre le Callable et obtenir un Future<String>", "Appelez futur.get() pour recuperer la valeur retournee par le Callable", "La signature throws Exception dans main permet de ne pas gerer ExecutionException manuellement"]',
    30,
    1
FROM lessons l WHERE l.slug = 'callable-future';

-- =============================================
-- EXERCICE 2 : Calcul Asynchrone (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Calcul Asynchrone',
    'MEDIUM',
    'Creez un pool de 2 threads. Lancez deux Callable<Long> en parallele : le premier calcule la somme de 1 a 1000, le second la somme de 1001 a 2000. Recuperez les deux resultats et affichez "Somme 1-1000: 500500", "Somme 1001-2000: 1500500" et "Total: 2001000".',
    E'import java.util.concurrent.*;\n\npublic class Main {\n    public static void main(String[] args) throws Exception {\n        ExecutorService pool = Executors.newFixedThreadPool(2);\n\n        // Soumettez deux Callable<Long> :\n        // Callable 1 : somme de 1 a 1000\n        // Callable 2 : somme de 1001 a 2000\n\n        // Recuperez les resultats avec get()\n\n        // Affichez les resultats\n        pool.shutdown();\n    }\n}',
    E'import java.util.concurrent.*;\n\npublic class Main {\n    public static void main(String[] args) throws Exception {\n        ExecutorService pool = Executors.newFixedThreadPool(2);\n\n        Future<Long> futur1 = pool.submit(() -> {\n            long somme = 0;\n            for (int i = 1; i <= 1000; i++) somme += i;\n            return somme;\n        });\n\n        Future<Long> futur2 = pool.submit(() -> {\n            long somme = 0;\n            for (int i = 1001; i <= 2000; i++) somme += i;\n            return somme;\n        });\n\n        long somme1 = futur1.get();\n        long somme2 = futur2.get();\n\n        System.out.println("Somme 1-1000: " + somme1);\n        System.out.println("Somme 1001-2000: " + somme2);\n        System.out.println("Total: " + (somme1 + somme2));\n\n        pool.shutdown();\n    }\n}',
    'output.contains("Somme 1-1000: 500500") && output.contains("Somme 1001-2000: 1500500") && output.contains("Total: 2001000")',
    '["Soumettez les deux Callable avant d appeler get() sur l un ou l autre pour qu ils s executent en parallele", "Utilisez long (pas int) pour stocker la somme afin d eviter le debordement", "Somme de 1 a n = n*(n+1)/2 : somme 1-1000 = 500500, somme 1001-2000 = 1500500"]',
    40,
    2
FROM lessons l WHERE l.slug = 'callable-future';

-- =============================================
-- EXERCICE 3 : InvokeAll (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Traitement avec invokeAll',
    'HARD',
    'Creez un pool de 3 threads et une liste de 5 Callable<Integer> : chacun retourne son index * 10 (0, 10, 20, 30, 40). Utilisez invokeAll() pour les executer tous. Parcourez les Futures, calculez la somme des resultats et affichez "Resultats collectes: 5" puis "Somme: 100".',
    E'import java.util.concurrent.*;\nimport java.util.*;\n\npublic class Main {\n    public static void main(String[] args) throws Exception {\n        ExecutorService pool = Executors.newFixedThreadPool(3);\n\n        // Creez une List<Callable<Integer>> avec 5 callables\n        // Callable i retourne i * 10 (0, 10, 20, 30, 40)\n        List<Callable<Integer>> taches = new ArrayList<>();\n        for (int i = 0; i < 5; i++) {\n            // Ajoutez chaque callable\n        }\n\n        // Utilisez invokeAll() pour executer toutes les taches\n\n        // Parcourez les Futures et calculez la somme\n        int somme = 0;\n        int count = 0;\n\n        System.out.println("Resultats collectes: " + count);\n        System.out.println("Somme: " + somme);\n\n        pool.shutdown();\n    }\n}',
    E'import java.util.concurrent.*;\nimport java.util.*;\n\npublic class Main {\n    public static void main(String[] args) throws Exception {\n        ExecutorService pool = Executors.newFixedThreadPool(3);\n\n        List<Callable<Integer>> taches = new ArrayList<>();\n        for (int i = 0; i < 5; i++) {\n            final int num = i;\n            taches.add(() -> num * 10);\n        }\n\n        List<Future<Integer>> resultats = pool.invokeAll(taches);\n\n        int somme = 0;\n        int count = 0;\n        for (Future<Integer> f : resultats) {\n            somme += f.get();\n            count++;\n        }\n\n        System.out.println("Resultats collectes: " + count);\n        System.out.println("Somme: " + somme);\n\n        pool.shutdown();\n    }\n}',
    'output.contains("Resultats collectes: 5") && output.contains("Somme: 100")',
    '["Copiez i dans une variable final int num = i avant de l utiliser dans la lambda", "pool.invokeAll(taches) retourne une List<Future<Integer>> dans le meme ordre que la liste d entree", "0 + 10 + 20 + 30 + 40 = 100"]',
    50,
    3
FROM lessons l WHERE l.slug = 'callable-future';
