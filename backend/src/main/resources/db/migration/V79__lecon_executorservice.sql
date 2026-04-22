-- V79: Lecon 3 Programmation Concurrente - ExecutorService et thread pools + Quiz

-- =============================================
-- LECON 3 : ExecutorService et Thread Pools
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'ExecutorService : gerer les threads avec un pool',
    'executorservice-pool',
    E'EXECUTORSERVICE : GERER LES THREADS AVEC UN POOL\n\nCreer manuellement des threads avec new Thread() est simple mais peu adapte a la production. Pour 1000 taches, creer 1000 threads serait catastrophique pour les performances. ExecutorService resout ce probleme avec un pool de threads.\n\n---\n\nQU EST-CE QU UN THREAD POOL ?\n\nUn thread pool (reservoir de threads) est un ensemble de threads pre-crees et reutilisables. Quand vous soumettez une tache :\n\n1. Si un thread du pool est disponible, il execute la tache immediatement\n2. Sinon, la tache est mise en file d attente\n3. Des qu un thread se libere, il prend la prochaine tache en attente\n\nAvantages :\n- Evite le cout de creation/destruction des threads pour chaque tache\n- Limite le nombre de threads actifs (evite la surcharge)\n- Gere automatiquement la file d attente des taches\n\n---\n\nCREER UN EXECUTORSERVICE\n\nLa classe Executors fournit des methodes de fabrique :\n\n  import java.util.concurrent.ExecutorService;\n  import java.util.concurrent.Executors;\n\n  // Pool fixe de 4 threads\n  ExecutorService pool = Executors.newFixedThreadPool(4);\n\n  // Pool avec 1 seul thread (taches executees sequentiellement)\n  ExecutorService monoThread = Executors.newSingleThreadExecutor();\n\n  // Pool qui cree des threads a la demande (0 a l infini, avec timeout)\n  ExecutorService cache = Executors.newCachedThreadPool();\n\n  // Pool avec scheduler pour executer des taches a intervalles reguliers\n  ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(2);\n\n---\n\nSOUMETTRE DES TACHES : execute() ET submit()\n\n  ExecutorService pool = Executors.newFixedThreadPool(4);\n\n  // execute() : pour les Runnable (pas de valeur de retour)\n  pool.execute(() -> System.out.println("Tache 1"));\n  pool.execute(() -> System.out.println("Tache 2"));\n  pool.execute(() -> System.out.println("Tache 3"));\n\n  // submit() : pour les Runnable et Callable, retourne un Future\n  Future<?> futur = pool.submit(() -> System.out.println("Tache 4"));\n\n---\n\nARRETER UN EXECUTORSERVICE\n\nIl est essentiel d arreter proprement le pool pour liberer les ressources :\n\n  ExecutorService pool = Executors.newFixedThreadPool(4);\n\n  // Soumettre des taches...\n  pool.execute(() -> System.out.println("Travail"));\n\n  // shutdown() : n accepte plus de nouvelles taches, attend la fin des taches en cours\n  pool.shutdown();\n\n  // awaitTermination() : attend que toutes les taches soient terminees\n  try {\n      pool.awaitTermination(5, TimeUnit.SECONDS);\n  } catch (InterruptedException e) {\n      Thread.currentThread().interrupt();\n  }\n\n  // shutdownNow() : interrompt les taches en cours et retourne celles en attente\n  List<Runnable> nonExecutees = pool.shutdownNow();\n\n---\n\nEXEMPLE COMPLET : TRAITEMENT EN PARALLELE\n\n  import java.util.concurrent.ExecutorService;\n  import java.util.concurrent.Executors;\n  import java.util.concurrent.TimeUnit;\n\n  public class ExemplePool {\n      public static void main(String[] args) throws InterruptedException {\n          ExecutorService pool = Executors.newFixedThreadPool(3);\n\n          // Soumettre 6 taches pour 3 threads\n          for (int i = 1; i <= 6; i++) {\n              final int num = i;\n              pool.execute(() -> {\n                  System.out.println("Tache " + num + " par " + Thread.currentThread().getName());\n              });\n          }\n\n          pool.shutdown();\n          pool.awaitTermination(10, TimeUnit.SECONDS);\n\n          System.out.println("Toutes les taches sont terminees");\n      }\n  }\n\nAvec 3 threads, les 6 taches sont reparties automatiquement.\n\n---\n\nNOMBRE DE THREADS OPTIMAL\n\nLe choix du nombre de threads depend de la nature des taches :\n\n  // Obtenir le nombre de processeurs disponibles\n  int nbCores = Runtime.getRuntime().availableProcessors();\n\n  // Taches CPU-intensives : nb threads = nb cores\n  ExecutorService cpuPool = Executors.newFixedThreadPool(nbCores);\n\n  // Taches I/O-intensives (fichiers, reseau, base de donnees) :\n  // les threads passent beaucoup de temps a attendre\n  // on peut utiliser davantage de threads\n  ExecutorService ioPool = Executors.newFixedThreadPool(nbCores * 2);\n\n---\n\nEXECUTOR AVEC LISTE DE TACHES\n\n  ExecutorService pool = Executors.newFixedThreadPool(4);\n\n  String[] fichiers = {"doc1.txt", "doc2.txt", "doc3.txt", "doc4.txt", "doc5.txt"};\n\n  for (String fichier : fichiers) {\n      pool.execute(() -> {\n          System.out.println("Traitement de " + fichier + " par " + Thread.currentThread().getName());\n      });\n  }\n\n  pool.shutdown();\n\n---\n\nCOMPARAISON : new Thread() vs ExecutorService\n\n  // Mauvaise pratique : creer un thread par tache\n  for (int i = 0; i < 1000; i++) {\n      new Thread(() -> traiter()).start(); // 1000 threads !\n  }\n\n  // Bonne pratique : reutiliser un pool de threads\n  ExecutorService pool = Executors.newFixedThreadPool(10);\n  for (int i = 0; i < 1000; i++) {\n      pool.execute(() -> traiter()); // max 10 threads actifs\n  }\n  pool.shutdown();\n\n---\n\nBONNES PRATIQUES\n\n1. Toujours appeler shutdown() apres avoir soumis toutes les taches.\n2. Utilisez awaitTermination() si vous devez attendre la fin de toutes les taches.\n3. Preferez newFixedThreadPool() en production pour controler la charge.\n4. Dimensionnez le pool selon la nature des taches : nb_cores pour CPU, nb_cores*2 pour I/O.\n5. Fermez le pool dans un bloc finally pour garantir la liberation des ressources.',
    3,
    40
FROM chapters c WHERE c.slug = 'programmation-concurrente';

-- =============================================
-- QUIZ : ExecutorService et Thread Pools
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - ExecutorService et Thread Pools',
    'Testez vos connaissances sur les pools de threads et l ExecutorService en Java',
    300, 70, 100
FROM lessons l WHERE l.slug = 'executorservice-pool';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la principale raison d utiliser un thread pool plutot que de creer un new Thread() pour chaque tache ?',
        'SINGLE_CHOICE',
        'Creer un nouveau Thread pour chaque tache a un cout : allocation memoire, initialisation, etc. Avec 1000 taches, 1000 threads seraient crees et detruits. Un thread pool reutilise les threads existants, evite ce cout de creation/destruction, et limite le nombre de threads actifs simultanement.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'executorservice-pool'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Un thread pool est plus facile a ecrire', false, 1),
    ('Un thread pool reutilise les threads et limite leur nombre, evitant le cout de creation/destruction', true, 2),
    ('Un thread pool garantit que les taches s executent dans l ordre', false, 3),
    ('Un thread pool empeche les race conditions automatiquement', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment creer un ExecutorService avec exactement 4 threads ?',
        'SINGLE_CHOICE',
        'Executors.newFixedThreadPool(4) cree un pool avec exactement 4 threads. Si toutes les taches soumises sont en cours, les nouvelles taches sont mises en file d attente. newCachedThreadPool() cree des threads a la demande. newSingleThreadExecutor() n a qu un seul thread.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'executorservice-pool'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('new ExecutorService(4)', false, 1),
    ('Executors.newFixedThreadPool(4)', true, 2),
    ('ExecutorService.create(4)', false, 3),
    ('Executors.newThreadPool(4)', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que fait pool.shutdown() ?',
        'SINGLE_CHOICE',
        'shutdown() signale au pool de ne plus accepter de nouvelles taches mais attend que toutes les taches deja soumises (en cours d execution ou en file d attente) se terminent normalement. shutdownNow() interrompt immediatement les taches en cours.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'executorservice-pool'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Interrompt immediatement toutes les taches en cours', false, 1),
    ('N accepte plus de nouvelles taches et attend la fin des taches deja soumises', true, 2),
    ('Supprime toutes les taches en attente mais garde les taches en cours', false, 3),
    ('Vide le pool et supprime tous les threads immediatement', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pour des taches CPU-intensives, quel nombre de threads est generalement recommande pour un pool ?',
        'SINGLE_CHOICE',
        'Pour des taches CPU-intensives (calculs purs), le nombre optimal de threads est egal au nombre de coeurs du processeur (Runtime.getRuntime().availableProcessors()). Avoir plus de threads que de coeurs n ameliore pas les performances car les threads se partagent les memes ressources CPU. Pour les taches I/O, on peut avoir plus de threads.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'executorservice-pool'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Toujours 10 threads, quelle que soit la machine', false, 1),
    ('Le nombre de coeurs du processeur (Runtime.getRuntime().availableProcessors())', true, 2),
    ('Le nombre de taches a executer', false, 3),
    ('1 seul thread pour eviter les conflits', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que se passe-t-il quand on soumet plus de taches qu il n y a de threads disponibles dans un FixedThreadPool ?',
        'SINGLE_CHOICE',
        'Quand tous les threads du pool sont occupes et qu une nouvelle tache est soumise, elle est mise en file d attente (BlockingQueue). Des qu un thread se libere, il prend automatiquement la prochaine tache en attente. Aucune tache n est perdue ou ignoree.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'executorservice-pool'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Une exception est levee et la tache est perdue', false, 1),
    ('La tache est mise en file d attente et executee quand un thread se libere', true, 2),
    ('Un nouveau thread temporaire est cree automatiquement', false, 3),
    ('La tache est ignoree silencieusement', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la difference entre execute() et submit() dans un ExecutorService ?',
        'SINGLE_CHOICE',
        'execute() accepte un Runnable et ne retourne rien (void). submit() accepte un Runnable ou un Callable et retourne un Future qui permet de recuperer le resultat ou d attendre la fin de la tache. Pour des taches avec valeur de retour, il faut utiliser submit() avec un Callable.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'executorservice-pool'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('execute() est plus rapide que submit()', false, 1),
    ('execute() accepte un Runnable (void), submit() retourne un Future permettant de recuperer le resultat', true, 2),
    ('submit() execute la tache immediatement, execute() la met en attente', false, 3),
    ('Il n y a pas de difference, les deux font la meme chose', false, 4)
) AS opt(text, is_correct, order_index);
