-- V77: Lecon 2 Programmation Concurrente - synchronized et AtomicInteger + Quiz

-- =============================================
-- LECON 2 : Synchronisation et AtomicInteger
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Synchronisation : synchronized et AtomicInteger',
    'synchronized-atomic',
    E'SYNCHRONISATION : SYNCHRONIZED ET ATOMICINTEGER\n\nLa lecon precedente a montre le probleme de la race condition : plusieurs threads qui modifient une variable partagee obtiennent des resultats incorrects. Cette lecon presente les deux principales solutions en Java.\n\n---\n\nLE MOT-CLE SYNCHRONIZED\n\nsynchronized garantit qu un seul thread a la fois peut executer un bloc de code. C est un verrou (lock) mutuel.\n\n  public class Compteur {\n      private int valeur = 0;\n\n      // Methode synchronisee : un seul thread a la fois\n      public synchronized void incrementer() {\n          valeur++;\n      }\n\n      public synchronized int getValeur() {\n          return valeur;\n      }\n  }\n\nQuand un thread entre dans une methode synchronized, il acquiert le verrou de l objet. Les autres threads qui tentent d entrer dans une methode synchronized du meme objet sont bloques jusqu a ce que le verrou soit libere.\n\n---\n\nBLOC SYNCHRONIZED\n\nOn peut aussi synchroniser un bloc specifique plutot qu une methode entiere, ce qui est plus efficace :\n\n  public class Compteur {\n      private int valeur = 0;\n      private final Object verrou = new Object();\n\n      public void incrementer() {\n          // Code non synchronise possible avant\n          synchronized (verrou) {\n              valeur++; // section critique\n          }\n          // Code non synchronise possible apres\n      }\n  }\n\nC est preferable de synchroniser le moins possible : les blocs synchronized reduisent le parallelisme.\n\n---\n\nATOMICINTEGER : LA SOLUTION MODERNE\n\nLe package java.util.concurrent.atomic fournit des classes thread-safe sans synchronized. AtomicInteger est la plus courante :\n\n  import java.util.concurrent.atomic.AtomicInteger;\n\n  AtomicInteger compteur = new AtomicInteger(0);\n\n  // Operations atomiques (thread-safe sans synchronized)\n  compteur.incrementAndGet();     // ++compteur, retourne la nouvelle valeur\n  compteur.getAndIncrement();     // compteur++, retourne l ancienne valeur\n  compteur.addAndGet(5);          // compteur += 5, retourne la nouvelle valeur\n  compteur.decrementAndGet();     // --compteur\n  int val = compteur.get();       // lire la valeur\n  compteur.set(100);              // ecrire une valeur\n\n---\n\nCOMPARAISON : RACE CONDITION vs SYNCHRONISE vs ATOMIC\n\n  // Version dangereuse (race condition)\n  int[] compteur = {0};\n  Thread t1 = new Thread(() -> { for (int i=0;i<10000;i++) compteur[0]++; });\n  Thread t2 = new Thread(() -> { for (int i=0;i<10000;i++) compteur[0]++; });\n  // Resultat souvent < 20000 !\n\n  // Version synchronisee\n  Compteur c = new Compteur(); // classe avec methode synchronized\n  Thread t1 = new Thread(() -> { for (int i=0;i<10000;i++) c.incrementer(); });\n  Thread t2 = new Thread(() -> { for (int i=0;i<10000;i++) c.incrementer(); });\n  // Resultat toujours 20000\n\n  // Version AtomicInteger (plus simple et plus performante)\n  AtomicInteger atomic = new AtomicInteger(0);\n  Thread t1 = new Thread(() -> { for (int i=0;i<10000;i++) atomic.incrementAndGet(); });\n  Thread t2 = new Thread(() -> { for (int i=0;i<10000;i++) atomic.incrementAndGet(); });\n  // Resultat toujours 20000\n\n---\n\nLE MOT-CLE VOLATILE\n\nvolatile garantit que la valeur d une variable est lue depuis la memoire principale et non depuis un cache local du thread :\n\n  private volatile boolean actif = true;\n\n  // Thread producteur\n  Thread producteur = new Thread(() -> {\n      try { Thread.sleep(100); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }\n      actif = false; // visible par tous les threads\n  });\n\n  // Thread consommateur\n  Thread consommateur = new Thread(() -> {\n      while (actif) { /* travaille */ }\n      System.out.println("Arrete !");\n  });\n\nvolatile ne protege pas contre les race conditions sur les operations composees (comme i++). Utilisez synchronized ou AtomicInteger pour ca.\n\n---\n\nLE DEADLOCK\n\nUn deadlock (interblocage) survient quand deux threads s attendent mutuellement :\n\n  Object verrou1 = new Object();\n  Object verrou2 = new Object();\n\n  Thread t1 = new Thread(() -> {\n      synchronized (verrou1) {\n          System.out.println("T1 a verrou1, attend verrou2");\n          synchronized (verrou2) { System.out.println("T1 a les deux"); }\n      }\n  });\n\n  Thread t2 = new Thread(() -> {\n      synchronized (verrou2) { // T2 prend verrou2 en premier\n          System.out.println("T2 a verrou2, attend verrou1");\n          synchronized (verrou1) { System.out.println("T2 a les deux"); }\n      }\n  });\n\nSolution : toujours acquerir les verrous dans le meme ordre dans tous les threads.\n\n---\n\nATOMICREFERENCE ET AUTRES CLASSES ATOMIQUES\n\nLe package atomic offre plusieurs classes :\n\n  AtomicInteger   : entier thread-safe\n  AtomicLong      : long thread-safe\n  AtomicBoolean   : boolean thread-safe\n  AtomicReference : reference objet thread-safe\n\n  AtomicBoolean running = new AtomicBoolean(true);\n  running.set(false);\n  if (running.compareAndSet(true, false)) {\n      // change de true a false seulement si la valeur actuelle est true\n  }\n\ncompareAndSet est une operation CAS (Compare-And-Swap) : elle modifie la valeur seulement si elle correspond a la valeur attendue. C est la base des algorithmes lock-free.\n\n---\n\nEXEMPLE COMPLET : COMPTEUR THREAD-SAFE\n\n  import java.util.concurrent.atomic.AtomicInteger;\n\n  public class ExempleAtomic {\n      public static void main(String[] args) throws InterruptedException {\n          AtomicInteger compteur = new AtomicInteger(0);\n\n          Thread[] threads = new Thread[10];\n          for (int i = 0; i < 10; i++) {\n              threads[i] = new Thread(() -> {\n                  for (int j = 0; j < 1000; j++) {\n                      compteur.incrementAndGet();\n                  }\n              });\n          }\n\n          for (Thread t : threads) t.start();\n          for (Thread t : threads) t.join();\n\n          System.out.println("Resultat: " + compteur.get()); // toujours 10000\n      }\n  }\n\n---\n\nBONNES PRATIQUES\n\n1. Preferez AtomicInteger a synchronized pour les compteurs simples : plus rapide, plus lisible.\n2. Minimisez la taille des blocs synchronized : synchronisez uniquement ce qui est necessaire.\n3. Evitez de tenir plusieurs verrous en meme temps : risque de deadlock.\n4. Toujours acquerir les verrous dans le meme ordre si vous devez en tenir plusieurs.\n5. volatile pour les drapeaux (boolean), AtomicInteger pour les compteurs, synchronized pour les operations complexes.',
    2,
    40
FROM chapters c WHERE c.slug = 'programmation-concurrente';

-- =============================================
-- QUIZ : synchronized et AtomicInteger
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Synchronisation et AtomicInteger',
    'Testez vos connaissances sur la synchronisation, les classes atomiques et la protection des donnees partagees',
    300, 70, 100
FROM lessons l WHERE l.slug = 'synchronized-atomic';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que garantit le mot-cle synchronized sur une methode ?',
        'SINGLE_CHOICE',
        'synchronized garantit qu un seul thread a la fois peut executer la methode sur cet objet. Les autres threads qui tentent d y acceder sont bloques jusqu a ce que le verrou soit libere. Cela empeche les race conditions sur les donnees partagees.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'synchronized-atomic'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('La methode s execute deux fois plus vite', false, 1),
    ('Un seul thread a la fois peut executer la methode sur cet objet', true, 2),
    ('La methode ne peut etre appelee qu une seule fois', false, 3),
    ('La methode est executee par tous les threads en meme temps', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode d AtomicInteger permet d incrementer la valeur et de retourner la nouvelle valeur ?',
        'SINGLE_CHOICE',
        'incrementAndGet() est equivalent a ++i : elle incremente la valeur et retourne la nouvelle valeur. getAndIncrement() est equivalent a i++ : elle retourne l ancienne valeur puis incremente. Les deux sont atomiques et thread-safe.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'synchronized-atomic'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('getAndIncrement()', false, 1),
    ('incrementAndGet()', true, 2),
    ('increment()', false, 3),
    ('addOne()', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la difference entre volatile et synchronized ?',
        'SINGLE_CHOICE',
        'volatile garantit la visibilite : les modifications d une variable sont immediatement visibles par tous les threads. synchronized garantit a la fois la visibilite ET l atomicite. volatile ne protege pas i++ (operation composee), synchronized oui.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'synchronized-atomic'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('volatile et synchronized font exactement la meme chose', false, 1),
    ('volatile garantit la visibilite mais pas l atomicite, synchronized garantit les deux', true, 2),
    ('volatile est plus lent que synchronized', false, 3),
    ('synchronized est uniquement pour les methodes, volatile pour les variables', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Qu est-ce qu un deadlock (interblocage) ?',
        'SINGLE_CHOICE',
        'Un deadlock survient quand deux threads ou plus s attendent mutuellement pour liberer un verrou. Thread A attend le verrou de Thread B, et Thread B attend le verrou de Thread A. Le programme est bloque indefiniment. La solution est d acquerir les verrous toujours dans le meme ordre.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'synchronized-atomic'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Un thread qui boucle indefiniment sans s arreter', false, 1),
    ('Une situation ou deux threads s attendent mutuellement pour liberer un verrou', true, 2),
    ('Une exception levee quand deux threads accedent a la meme methode', false, 3),
    ('Un thread qui ne peut pas demarrer car un autre thread est en cours', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pourquoi AtomicInteger est-il prefere a synchronized pour un simple compteur ?',
        'SINGLE_CHOICE',
        'AtomicInteger utilise des operations CAS (Compare-And-Swap) au niveau CPU, qui sont plus performantes que synchronized. synchronized bloque les threads en attente, AtomicInteger utilise un mecanisme non-bloquant (lock-free). Pour un compteur simple, AtomicInteger est plus efficace et son code est plus lisible.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'synchronized-atomic'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('AtomicInteger est plus simple a ecrire et plus performant car il utilise des operations lock-free', true, 1),
    ('AtomicInteger est uniquement utile pour les nombres negatifs', false, 2),
    ('synchronized ne fonctionne pas avec les entiers', false, 3),
    ('AtomicInteger fonctionne sans import', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la bonne pratique pour eviter les deadlocks quand on utilise plusieurs verrous ?',
        'SINGLE_CHOICE',
        'La regie d or pour eviter les deadlocks est d acquerir les verrous toujours dans le meme ordre dans tous les threads. Si Thread A et Thread B acquerent toujours verrou1 avant verrou2, il n y a pas de deadlock possible.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'synchronized-atomic'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Utiliser un seul thread pour toutes les operations sur les verrous', false, 1),
    ('Toujours acquerir les verrous dans le meme ordre dans tous les threads', true, 2),
    ('Ne jamais utiliser plus d un verrou par programme', false, 3),
    ('Appeler Thread.sleep() entre chaque acquisition de verrou', false, 4)
) AS opt(text, is_correct, order_index);
