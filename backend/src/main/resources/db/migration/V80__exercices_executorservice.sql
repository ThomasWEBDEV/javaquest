-- V80: Exercices ExecutorService et thread pools

-- =============================================
-- EXERCICE 1 : Mon Premier Pool (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Mon Premier Pool',
    'EASY',
    'Creez un ExecutorService avec un pool fixe de 2 threads. Soumettez 4 taches avec execute() : chacune affiche "Tache X executee" (X de 1 a 4). Appelez shutdown() puis awaitTermination(5, TimeUnit.SECONDS). Affichez "Pool termine" apres.',
    E'import java.util.concurrent.ExecutorService;\nimport java.util.concurrent.Executors;\nimport java.util.concurrent.TimeUnit;\n\npublic class Main {\n    public static void main(String[] args) throws InterruptedException {\n        // Creez un pool fixe de 2 threads\n\n        // Soumettez 4 taches qui affichent "Tache 1 executee", "Tache 2 executee", etc.\n\n        // Arretez le pool proprement\n\n        System.out.println("Pool termine");\n    }\n}',
    E'import java.util.concurrent.ExecutorService;\nimport java.util.concurrent.Executors;\nimport java.util.concurrent.TimeUnit;\n\npublic class Main {\n    public static void main(String[] args) throws InterruptedException {\n        ExecutorService pool = Executors.newFixedThreadPool(2);\n\n        for (int i = 1; i <= 4; i++) {\n            final int num = i;\n            pool.execute(() -> System.out.println("Tache " + num + " executee"));\n        }\n\n        pool.shutdown();\n        pool.awaitTermination(5, TimeUnit.SECONDS);\n\n        System.out.println("Pool termine");\n    }\n}',
    'output.contains("Tache 1 executee") && output.contains("Tache 2 executee") && output.contains("Tache 3 executee") && output.contains("Tache 4 executee") && output.contains("Pool termine")',
    '["Utilisez Executors.newFixedThreadPool(2) pour creer le pool", "Dans la boucle, la variable i doit etre copiee dans une variable final pour etre utilisee dans la lambda : final int num = i", "Appelez pool.shutdown() puis pool.awaitTermination(5, TimeUnit.SECONDS) pour attendre la fin"]',
    30,
    1
FROM lessons l WHERE l.slug = 'executorservice-pool';

-- =============================================
-- EXERCICE 2 : Traitement Parallele (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Traitement Parallele de Donnees',
    'MEDIUM',
    'Creez un pool de 3 threads. Traitez un tableau de 6 noms : {"Alice", "Bob", "Charlie", "Diana", "Eve", "Frank"}. Pour chaque nom, soumettez une tache qui affiche "Bonjour " + nom. Apres shutdown() et awaitTermination(), affichez "Traitement termine : 6 noms".',
    E'import java.util.concurrent.ExecutorService;\nimport java.util.concurrent.Executors;\nimport java.util.concurrent.TimeUnit;\n\npublic class Main {\n    public static void main(String[] args) throws InterruptedException {\n        String[] noms = {"Alice", "Bob", "Charlie", "Diana", "Eve", "Frank"};\n\n        // Creez un pool de 3 threads\n\n        // Pour chaque nom, soumettez une tache qui affiche "Bonjour " + nom\n\n        // Arretez le pool et attendez la fin\n\n        System.out.println("Traitement termine : " + noms.length + " noms");\n    }\n}',
    E'import java.util.concurrent.ExecutorService;\nimport java.util.concurrent.Executors;\nimport java.util.concurrent.TimeUnit;\n\npublic class Main {\n    public static void main(String[] args) throws InterruptedException {\n        String[] noms = {"Alice", "Bob", "Charlie", "Diana", "Eve", "Frank"};\n\n        ExecutorService pool = Executors.newFixedThreadPool(3);\n\n        for (String nom : noms) {\n            pool.execute(() -> System.out.println("Bonjour " + nom));\n        }\n\n        pool.shutdown();\n        pool.awaitTermination(5, TimeUnit.SECONDS);\n\n        System.out.println("Traitement termine : " + noms.length + " noms");\n    }\n}',
    'output.contains("Bonjour Alice") && output.contains("Bonjour Bob") && output.contains("Bonjour Charlie") && output.contains("Traitement termine : 6 noms")',
    '["Utilisez un for-each sur le tableau de noms", "Les variables de boucle for-each sont effectivement finales en Java, donc nom peut etre utilise directement dans la lambda", "Toujours appeler shutdown() avant awaitTermination()"]',
    40,
    2
FROM lessons l WHERE l.slug = 'executorservice-pool';

-- =============================================
-- EXERCICE 3 : Pool avec Compteur Atomique (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Pool et Compteur Atomique',
    'HARD',
    'Creez un pool de 4 threads et un AtomicInteger tachesReussies a 0. Soumettez 10 taches : chaque tache incremente tachesReussies avec incrementAndGet() et affiche "Tache X/10 terminee" ou X est la nouvelle valeur. Apres shutdown() et awaitTermination(), affichez "Bilan: 10/10 taches reussies".',
    E'import java.util.concurrent.ExecutorService;\nimport java.util.concurrent.Executors;\nimport java.util.concurrent.TimeUnit;\nimport java.util.concurrent.atomic.AtomicInteger;\n\npublic class Main {\n    public static void main(String[] args) throws InterruptedException {\n        ExecutorService pool = Executors.newFixedThreadPool(4);\n        AtomicInteger tachesReussies = new AtomicInteger(0);\n\n        // Soumettez 10 taches\n        // Chaque tache : incremente tachesReussies et affiche "Tache X/10 terminee"\n\n        pool.shutdown();\n        pool.awaitTermination(10, TimeUnit.SECONDS);\n\n        System.out.println("Bilan: " + tachesReussies.get() + "/10 taches reussies");\n    }\n}',
    E'import java.util.concurrent.ExecutorService;\nimport java.util.concurrent.Executors;\nimport java.util.concurrent.TimeUnit;\nimport java.util.concurrent.atomic.AtomicInteger;\n\npublic class Main {\n    public static void main(String[] args) throws InterruptedException {\n        ExecutorService pool = Executors.newFixedThreadPool(4);\n        AtomicInteger tachesReussies = new AtomicInteger(0);\n\n        for (int i = 0; i < 10; i++) {\n            pool.execute(() -> {\n                int num = tachesReussies.incrementAndGet();\n                System.out.println("Tache " + num + "/10 terminee");\n            });\n        }\n\n        pool.shutdown();\n        pool.awaitTermination(10, TimeUnit.SECONDS);\n\n        System.out.println("Bilan: " + tachesReussies.get() + "/10 taches reussies");\n    }\n}',
    'output.contains("Bilan: 10/10 taches reussies")',
    '["Utilisez int num = tachesReussies.incrementAndGet() pour obtenir le numero de la tache atomiquement", "Affichez ensuite \"Tache \" + num + \"/10 terminee\" avec ce numero", "awaitTermination() garantit que toutes les taches sont finies avant d afficher le bilan"]',
    50,
    3
FROM lessons l WHERE l.slug = 'executorservice-pool';
