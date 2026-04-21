-- V76: Exercices threads et Runnable (Thread, start, join, sleep)

-- =============================================
-- EXERCICE 1 : Mon Premier Thread (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Mon Premier Thread',
    'EASY',
    'Creez un thread qui affiche "Thread demarre", attend 10ms avec Thread.sleep(10), puis affiche "Thread termine". Affichez "Principal: avant" avant de demarrer le thread. Utilisez t.join() pour attendre la fin du thread, puis affichez "Principal: apres".',
    E'public class Main {\n    public static void main(String[] args) throws InterruptedException {\n        System.out.println("Principal: avant");\n\n        // Creez un thread qui :\n        // 1. Affiche "Thread demarre"\n        // 2. Attend 10ms avec Thread.sleep(10)\n        // 3. Affiche "Thread termine"\n\n        // Demarrez le thread avec t.start()\n        // Attendez sa fin avec t.join()\n\n        System.out.println("Principal: apres");\n    }\n}',
    E'public class Main {\n    public static void main(String[] args) throws InterruptedException {\n        System.out.println("Principal: avant");\n\n        Thread t = new Thread(() -> {\n            System.out.println("Thread demarre");\n            try {\n                Thread.sleep(10);\n            } catch (InterruptedException e) {\n                Thread.currentThread().interrupt();\n            }\n            System.out.println("Thread termine");\n        });\n\n        t.start();\n        t.join();\n\n        System.out.println("Principal: apres");\n    }\n}',
    'output.contains("Thread demarre") && output.contains("Thread termine") && output.contains("Principal: avant")',
    '["Creez le thread avec new Thread(() -> { ... })", "Gerez InterruptedException dans le catch de Thread.sleep() avec Thread.currentThread().interrupt()", "Appelez t.join() pour que le thread principal attende la fin du thread avant d afficher \"Principal: apres\""]',
    30,
    1
FROM lessons l WHERE l.slug = 'threads-runnable';

-- =============================================
-- EXERCICE 2 : Compteur Parallele (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Compteur Parallele',
    'MEDIUM',
    'Creez 3 threads. Chaque thread i (1, 2, 3) doit afficher "Thread i demarre". Demarrez tous les threads avec start(), puis appelez join() sur chacun. Affichez "Tous les threads ont termine" apres les trois join().',
    E'public class Main {\n    public static void main(String[] args) throws InterruptedException {\n        // Creez 3 threads\n        // Thread 1 : affiche "Thread 1 demarre"\n        // Thread 2 : affiche "Thread 2 demarre"\n        // Thread 3 : affiche "Thread 3 demarre"\n\n        // Demarrez les 3 threads\n        // Appelez join() sur chacun\n\n        System.out.println("Tous les threads ont termine");\n    }\n}',
    E'public class Main {\n    public static void main(String[] args) throws InterruptedException {\n        Thread t1 = new Thread(() -> System.out.println("Thread 1 demarre"));\n        Thread t2 = new Thread(() -> System.out.println("Thread 2 demarre"));\n        Thread t3 = new Thread(() -> System.out.println("Thread 3 demarre"));\n\n        t1.start();\n        t2.start();\n        t3.start();\n\n        t1.join();\n        t2.join();\n        t3.join();\n\n        System.out.println("Tous les threads ont termine");\n    }\n}',
    'output.contains("Thread 1 demarre") && output.contains("Thread 2 demarre") && output.contains("Thread 3 demarre") && output.contains("Tous les threads ont termine")',
    '["Creez chaque thread avec new Thread(() -> System.out.println(\"Thread X demarre\"))", "Appelez start() sur les 3 threads avant d appeler join() pour qu ils s executent en parallele", "join() bloque le thread principal jusqu a ce que le thread se termine"]',
    40,
    2
FROM lessons l WHERE l.slug = 'threads-runnable';

-- =============================================
-- EXERCICE 3 : Calcul en Parallele (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Calcul en Parallele',
    'HARD',
    'Creez 2 threads : le premier calcule la somme de 1 a 50, le second la somme de 51 a 100. Stockez les resultats dans un tableau int[] resultats = new int[2]. Apres join() des 2 threads, affichez "Somme 1-50: 1275", "Somme 51-100: 3775" et "Total: 5050".',
    E'public class Main {\n    public static void main(String[] args) throws InterruptedException {\n        int[] resultats = new int[2];\n\n        // Thread 1 : calcule la somme de 1 a 50\n        // Stocke le resultat dans resultats[0]\n\n        // Thread 2 : calcule la somme de 51 a 100\n        // Stocke le resultat dans resultats[1]\n\n        // Demarrez les 2 threads et attendez leur fin avec join()\n\n        // Affichez les resultats\n        System.out.println("Somme 1-50: " + resultats[0]);\n        System.out.println("Somme 51-100: " + resultats[1]);\n        System.out.println("Total: " + (resultats[0] + resultats[1]));\n    }\n}',
    E'public class Main {\n    public static void main(String[] args) throws InterruptedException {\n        int[] resultats = new int[2];\n\n        Thread t1 = new Thread(() -> {\n            int somme = 0;\n            for (int i = 1; i <= 50; i++) {\n                somme += i;\n            }\n            resultats[0] = somme;\n        });\n\n        Thread t2 = new Thread(() -> {\n            int somme = 0;\n            for (int i = 51; i <= 100; i++) {\n                somme += i;\n            }\n            resultats[1] = somme;\n        });\n\n        t1.start();\n        t2.start();\n\n        t1.join();\n        t2.join();\n\n        System.out.println("Somme 1-50: " + resultats[0]);\n        System.out.println("Somme 51-100: " + resultats[1]);\n        System.out.println("Total: " + (resultats[0] + resultats[1]));\n    }\n}',
    'output.contains("Somme 1-50: 1275") && output.contains("Somme 51-100: 3775") && output.contains("Total: 5050")',
    '["Utilisez un tableau int[] pour stocker les resultats car les variables locales ne peuvent pas etre modifiees dans une lambda", "Dans chaque thread, calculez la somme avec une boucle for et stockez dans resultats[0] ou resultats[1]", "Appelez join() sur les deux threads avant d afficher les resultats pour etre sur qu ils ont termine"]',
    50,
    3
FROM lessons l WHERE l.slug = 'threads-runnable';
