-- V75: Chapitre 9 Programmation Concurrente + Lecon 1 threads-runnable + Quiz

-- =============================================
-- CHAPITRE 9 : Programmation Concurrente
-- =============================================

INSERT INTO chapters (title, slug, description, order_index, xp_reward, is_published)
VALUES (
    'Programmation Concurrente',
    'programmation-concurrente',
    'Maitrisez les threads, la synchronisation et les executors pour ecrire des programmes Java capables d executer plusieurs taches en parallele',
    9,
    450,
    true
);

-- =============================================
-- LECON 1 : Threads et Runnable
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Threads et Runnable : les bases de la concurrence',
    'threads-runnable',
    E'THREADS ET RUNNABLE : LES BASES DE LA CONCURRENCE\n\nLa programmation concurrente permet a un programme Java d executer plusieurs taches en parallele. C est une competence cle pour les applications modernes qui doivent rester repondantes tout en traitant des operations longues.\n\n---\n\nQU EST-CE QU UN THREAD ?\n\nUn processus est un programme en cours d execution avec son propre espace memoire.\nUn thread (fil d execution) est une unite d execution legere a l interieur d un processus.\n\nPlusieurs threads d un meme processus partagent la meme memoire, ce qui permet :\n- La communication rapide entre threads\n- Le partage de donnees\n- Mais aussi des problemes si plusieurs threads modifient les memes donnees\n\nLa JVM demarre avec au moins deux threads : le thread principal (main) et le thread du ramasse-miettes (garbage collector).\n\n---\n\nCREER UN THREAD AVEC RUNNABLE ET LAMBDA\n\nLa facon la plus simple de creer un thread en Java moderne est d utiliser une expression lambda :\n\n  // Creer un thread avec une lambda\n  Thread t = new Thread(() -> {\n      System.out.println("Bonjour depuis le thread !");\n  });\n\n  // Demarrer le thread\n  t.start();\n\n  System.out.println("Bonjour depuis le thread principal !");\n\nIMPORTANT : t.start() cree un nouveau thread et execute la tache en parallele.\nt.run() execute la tache dans le thread courant, sans parallelisme.\n\n---\n\nIMPLEMENTER RUNNABLE\n\nRunnable est une interface fonctionnelle avec une seule methode run(). On peut aussi creer une classe qui l implemente :\n\n  public class MaTache implements Runnable {\n      @Override\n      public void run() {\n          System.out.println("Tache en cours dans : " + Thread.currentThread().getName());\n      }\n  }\n\n  // Utilisation\n  Thread t = new Thread(new MaTache());\n  t.start();\n\nAvec Java 8+, les lambdas remplacent avantageusement les classes anonymes Runnable.\n\n---\n\nTHREAD.SLEEP : METTRE EN PAUSE\n\nThread.sleep(ms) met le thread courant en pause pendant le nombre de millisecondes indique :\n\n  Thread t = new Thread(() -> {\n      System.out.println("Debut");\n      try {\n          Thread.sleep(1000); // pause de 1 seconde\n      } catch (InterruptedException e) {\n          Thread.currentThread().interrupt();\n      }\n      System.out.println("Fin apres 1 seconde");\n  });\n  t.start();\n\nThread.sleep() peut lever une InterruptedException si le thread est interrompu pendant son sommeil.\n\n---\n\nNOM ET IDENTITE DU THREAD\n\n  // Obtenir le thread courant\n  Thread courant = Thread.currentThread();\n\n  // Nom du thread\n  System.out.println(courant.getName()); // ex: "main", "Thread-0"\n\n  // Donner un nom personnalise\n  Thread t = new Thread(() -> {\n      System.out.println("Je suis : " + Thread.currentThread().getName());\n  }, "MonThread");\n  t.start();\n\n  // ID unique du thread\n  System.out.println(courant.getId());\n\n---\n\nCYCLE DE VIE D UN THREAD\n\nUn thread passe par plusieurs etats :\n\n  NEW       : Thread cree avec new Thread(...), pas encore demarre\n  RUNNABLE  : Apres t.start(), en cours d execution ou pret\n  BLOCKED   : En attente d un verrou (synchronized)\n  WAITING   : En attente indefinie (Object.wait(), Thread.join())\n  TIMED_WAITING : En attente limitee (Thread.sleep(), join(timeout))\n  TERMINATED : La methode run() s est terminee\n\n  Thread t = new Thread(() -> System.out.println("Hello"));\n  System.out.println(t.getState()); // NEW\n  t.start();\n  System.out.println(t.getState()); // RUNNABLE ou TERMINATED\n\n---\n\nLANCER PLUSIEURS THREADS EN PARALLELE\n\n  Thread t1 = new Thread(() -> System.out.println("Thread 1"));\n  Thread t2 = new Thread(() -> System.out.println("Thread 2"));\n  Thread t3 = new Thread(() -> System.out.println("Thread 3"));\n\n  t1.start();\n  t2.start();\n  t3.start();\n\n  // Attendre que tous les threads se terminent\n  t1.join(); // le thread principal attend la fin de t1\n  t2.join();\n  t3.join();\n\n  System.out.println("Tous les threads ont termine");\n\njoin() permet au thread principal d attendre la fin d un autre thread avant de continuer.\n\n---\n\nPROBLEME : LA RACE CONDITION\n\nLorsque plusieurs threads modifient une variable partagee sans synchronisation, on peut observer des comportements impredictibles :\n\n  int[] compteur = {0}; // tableau pour etre accessible dans les lambdas\n\n  Thread t1 = new Thread(() -> {\n      for (int i = 0; i < 1000; i++) compteur[0]++;\n  });\n  Thread t2 = new Thread(() -> {\n      for (int i = 0; i < 1000; i++) compteur[0]++;\n  });\n\n  t1.start();\n  t2.start();\n  t1.join();\n  t2.join();\n\n  // Resultat attendu : 2000, mais on peut obtenir moins !\n  System.out.println(compteur[0]);\n\nC est une race condition : deux threads lisent la meme valeur, incrementent chacun de 1, et ecrivent 1 a la place de 2. La synchronisation (synchronized, AtomicInteger) resout ce probleme.\n\n---\n\nEXEMPLE COMPLET\n\n  public class ExempleThreads {\n      public static void main(String[] args) throws InterruptedException {\n          System.out.println("Principal: debut dans " + Thread.currentThread().getName());\n\n          Thread t1 = new Thread(() -> {\n              System.out.println("T1: demarre dans " + Thread.currentThread().getName());\n              try { Thread.sleep(100); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }\n              System.out.println("T1: termine");\n          }, "Thread-Alice");\n\n          Thread t2 = new Thread(() -> {\n              System.out.println("T2: demarre dans " + Thread.currentThread().getName());\n              System.out.println("T2: termine");\n          }, "Thread-Bob");\n\n          t1.start();\n          t2.start();\n\n          t1.join();\n          t2.join();\n\n          System.out.println("Principal: tous les threads ont termine");\n      }\n  }\n\n---\n\nBONNES PRATIQUES\n\n1. Utilisez toujours t.start() et jamais t.run() pour obtenir le parallelisme.\n2. Appelez join() si le thread principal doit attendre les resultats des threads enfants.\n3. Gerez InterruptedException proprement : appelez Thread.currentThread().interrupt() dans le catch.\n4. Donnez des noms descriptifs a vos threads pour faciliter le debogage.\n5. Evitez de partager des variables mutables entre threads sans synchronisation.\n6. Pour les calculs paralleles simples, preferez les ExecutorService (prochain chapitre).',
    1,
    40
FROM chapters c WHERE c.slug = 'programmation-concurrente';

-- =============================================
-- QUIZ : Threads et Runnable
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Threads et Runnable',
    'Testez vos connaissances sur les threads Java, Runnable et le cycle de vie des threads',
    300, 70, 100
FROM lessons l WHERE l.slug = 'threads-runnable';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment demarrer l execution d un thread t ?',
        'SINGLE_CHOICE',
        't.start() cree un nouveau thread OS et appelle run() dedans de maniere asynchrone. t.run() execute simplement la methode dans le thread courant, sans creer de nouveau thread : il n y a pas de parallelisme.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'threads-runnable'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('t.run()', false, 1),
    ('t.start()', true, 2),
    ('t.execute()', false, 3),
    ('t.launch()', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle interface fonctionnelle represente une tache executable par un thread ?',
        'SINGLE_CHOICE',
        'Runnable est une interface fonctionnelle avec une seule methode void run(). Elle est utilise pour definir la tache qu un thread doit executer. Depuis Java 8, on peut utiliser une lambda a la place d une classe anonyme.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'threads-runnable'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Callable', false, 1),
    ('Runnable', true, 2),
    ('Executable', false, 3),
    ('Task', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que fait Thread.sleep(1000) ?',
        'SINGLE_CHOICE',
        'Thread.sleep(1000) met le thread courant en pause pendant 1000 millisecondes (1 seconde). Pendant ce temps, le thread libere le processeur. Cette methode peut lever une InterruptedException.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'threads-runnable'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Termine le thread apres 1000 iterations', false, 1),
    ('Met le thread courant en pause pendant 1000 millisecondes', true, 2),
    ('Attend que 1000 threads soient termines', false, 3),
    ('Ralentit le thread en le faisant tourner 1000 fois moins vite', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode permet de connaitre le nom du thread courant ?',
        'SINGLE_CHOICE',
        'Thread.currentThread() retourne une reference vers le thread en cours d execution. getName() retourne son nom. On combine les deux : Thread.currentThread().getName(). Le thread principal s appelle "main".',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'threads-runnable'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Thread.name()', false, 1),
    ('Thread.getRunning().name()', false, 2),
    ('Thread.currentThread().getName()', true, 3),
    ('this.getThreadName()', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Qu est-ce qu une race condition ?',
        'SINGLE_CHOICE',
        'Une race condition (condition de course) est un bug qui survient quand plusieurs threads accedent et modifient une meme donnee partagee sans synchronisation. Le resultat depend de l ordre d execution impredictible des threads, ce qui rend le bug difficile a reproduire.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'threads-runnable'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Une exception levee quand un thread demarre trop vite', false, 1),
    ('Un bug cause par plusieurs threads qui accedent et modifient une variable partagee sans synchronisation', true, 2),
    ('Un etat ou un thread court plus vite que les autres', false, 3),
    ('Une erreur de compilation dans un programme concurrent', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la difference entre t.start() et t.run() ?',
        'SINGLE_CHOICE',
        't.start() cree un nouveau thread systeme et execute run() de facon asynchrone dans ce nouveau thread. t.run() appelle simplement la methode run() dans le thread courant, comme un appel de methode ordinaire, sans aucun parallelisme.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'threads-runnable'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Il n y a pas de difference, les deux font la meme chose', false, 1),
    ('t.start() lance un nouveau thread, t.run() execute la tache dans le thread courant', true, 2),
    ('t.run() est plus rapide que t.start()', false, 3),
    ('t.start() peut etre appele plusieurs fois, t.run() une seule fois', false, 4)
) AS opt(text, is_correct, order_index);
