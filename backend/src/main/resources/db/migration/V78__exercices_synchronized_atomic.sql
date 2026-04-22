-- V78: Exercices synchronisation - synchronized et AtomicInteger

-- =============================================
-- EXERCICE 1 : Compteur Thread-Safe avec AtomicInteger (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Compteur Thread-Safe',
    'EASY',
    'Creez un AtomicInteger compteur initialise a 0. Lancez 5 threads, chacun incrementant le compteur 1000 fois avec incrementAndGet(). Attendez la fin de tous les threads avec join(), puis affichez "Resultat: 5000".',
    E'import java.util.concurrent.atomic.AtomicInteger;\n\npublic class Main {\n    public static void main(String[] args) throws InterruptedException {\n        AtomicInteger compteur = new AtomicInteger(0);\n\n        // Creez 5 threads, chacun incrementant le compteur 1000 fois\n        Thread[] threads = new Thread[5];\n        for (int i = 0; i < 5; i++) {\n            // TODO: creez chaque thread\n        }\n\n        // Demarrez tous les threads\n        // Attendez leur fin avec join()\n\n        System.out.println("Resultat: " + compteur.get());\n    }\n}',
    E'import java.util.concurrent.atomic.AtomicInteger;\n\npublic class Main {\n    public static void main(String[] args) throws InterruptedException {\n        AtomicInteger compteur = new AtomicInteger(0);\n\n        Thread[] threads = new Thread[5];\n        for (int i = 0; i < 5; i++) {\n            threads[i] = new Thread(() -> {\n                for (int j = 0; j < 1000; j++) {\n                    compteur.incrementAndGet();\n                }\n            });\n        }\n\n        for (Thread t : threads) t.start();\n        for (Thread t : threads) t.join();\n\n        System.out.println("Resultat: " + compteur.get());\n    }\n}',
    'output.contains("Resultat: 5000")',
    '["Creez un tableau Thread[] threads = new Thread[5] et remplissez-le dans une boucle", "Dans chaque thread, utilisez une boucle for pour appeler compteur.incrementAndGet() 1000 fois", "Demarrez tous les threads avec t.start() puis attendez-les avec t.join() dans deux boucles separees"]',
    30,
    1
FROM lessons l WHERE l.slug = 'synchronized-atomic';

-- =============================================
-- EXERCICE 2 : Methode Synchronisee (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Banque Thread-Safe',
    'MEDIUM',
    'Creez une classe Banque avec un champ int solde = 1000 et deux methodes synchronized : deposer(int montant) qui ajoute au solde, et retirer(int montant) qui soustrait du solde. Lancez 2 threads : le premier depose 500 dix fois, le second retire 200 dix fois. Affichez "Solde final: 4000".',
    E'public class Main {\n    static int solde = 1000;\n\n    // Creez une methode synchronized deposer(int montant)\n    // Creez une methode synchronized retirer(int montant)\n\n    public static void main(String[] args) throws InterruptedException {\n        // Thread 1 : deposer 500 dix fois\n        // Thread 2 : retirer 200 dix fois\n\n        // Attendez la fin des 2 threads\n\n        System.out.println("Solde final: " + solde);\n    }\n}',
    E'public class Main {\n    static int solde = 1000;\n\n    public static synchronized void deposer(int montant) {\n        solde += montant;\n    }\n\n    public static synchronized void retirer(int montant) {\n        solde -= montant;\n    }\n\n    public static void main(String[] args) throws InterruptedException {\n        Thread t1 = new Thread(() -> {\n            for (int i = 0; i < 10; i++) {\n                deposer(500);\n            }\n        });\n\n        Thread t2 = new Thread(() -> {\n            for (int i = 0; i < 10; i++) {\n                retirer(200);\n            }\n        });\n\n        t1.start();\n        t2.start();\n        t1.join();\n        t2.join();\n\n        System.out.println("Solde final: " + solde);\n    }\n}',
    'output.contains("Solde final: 4000")',
    '["Ajoutez synchronized sur les deux methodes deposer et retirer pour les rendre thread-safe", "Calcul : solde initial 1000 + 500*10 deposits = +5000, -200*10 retraits = -2000, total = 1000 + 5000 - 2000 = 4000", "Verifiez que vos methodes sont bien static synchronized pour que les deux threads partagent le meme verrou"]',
    40,
    2
FROM lessons l WHERE l.slug = 'synchronized-atomic';

-- =============================================
-- EXERCICE 3 : Drapeau Volatile (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Drapeau volatile',
    'HARD',
    'Utilisez un AtomicInteger operations initialise a 0 et un AtomicInteger total initialise a 0. Lancez 3 threads : chacun incremente operations de 1 et additionne sa valeur (thread 1 : +10, thread 2 : +20, thread 3 : +30) dans total avec addAndGet(). Attendez leur fin et affichez "Operations: 3" puis "Total: 60".',
    E'import java.util.concurrent.atomic.AtomicInteger;\n\npublic class Main {\n    public static void main(String[] args) throws InterruptedException {\n        AtomicInteger operations = new AtomicInteger(0);\n        AtomicInteger total = new AtomicInteger(0);\n\n        // Thread 1 : operations++ et total += 10\n        // Thread 2 : operations++ et total += 20\n        // Thread 3 : operations++ et total += 30\n\n        // Demarrez les 3 threads et attendez leur fin\n\n        System.out.println("Operations: " + operations.get());\n        System.out.println("Total: " + total.get());\n    }\n}',
    E'import java.util.concurrent.atomic.AtomicInteger;\n\npublic class Main {\n    public static void main(String[] args) throws InterruptedException {\n        AtomicInteger operations = new AtomicInteger(0);\n        AtomicInteger total = new AtomicInteger(0);\n\n        Thread t1 = new Thread(() -> {\n            operations.incrementAndGet();\n            total.addAndGet(10);\n        });\n\n        Thread t2 = new Thread(() -> {\n            operations.incrementAndGet();\n            total.addAndGet(20);\n        });\n\n        Thread t3 = new Thread(() -> {\n            operations.incrementAndGet();\n            total.addAndGet(30);\n        });\n\n        t1.start();\n        t2.start();\n        t3.start();\n\n        t1.join();\n        t2.join();\n        t3.join();\n\n        System.out.println("Operations: " + operations.get());\n        System.out.println("Total: " + total.get());\n    }\n}',
    'output.contains("Operations: 3") && output.contains("Total: 60")',
    '["Utilisez operations.incrementAndGet() pour compter les operations", "Utilisez total.addAndGet(valeur) pour ajouter une valeur au total de facon thread-safe", "10 + 20 + 30 = 60 et 3 threads = 3 operations"]',
    50,
    3
FROM lessons l WHERE l.slug = 'synchronized-atomic';
