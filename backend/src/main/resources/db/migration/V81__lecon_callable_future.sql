-- V81: Lecon 4 Programmation Concurrente - Callable et Future + Quiz

-- =============================================
-- LECON 4 : Callable et Future
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Callable et Future : resultats asynchrones',
    'callable-future',
    E'CALLABLE ET FUTURE : RESULTATS ASYNCHRONES\n\nRunnable et execute() permettent de lancer des taches sans recuperer de resultat. Mais que faire quand une tache doit retourner une valeur ? C est la qu interviennent Callable et Future.\n\n---\n\nCALLABLE : UNE TACHE AVEC RESULTAT\n\nCallable<V> est une interface fonctionnelle avec une methode call() qui retourne une valeur de type V :\n\n  import java.util.concurrent.Callable;\n\n  // Callable qui retourne un entier\n  Callable<Integer> tache = () -> {\n      int somme = 0;\n      for (int i = 1; i <= 100; i++) somme += i;\n      return somme; // retourne 5050\n  };\n\n  // Callable qui retourne une chaine\n  Callable<String> analyse = () -> {\n      Thread.sleep(100); // simule un traitement long\n      return "Analyse terminee";\n  };\n\nDifference avec Runnable :\n- Runnable : void run() - pas de retour, pas d exception checked\n- Callable<V> : V call() - retourne V, peut lever des exceptions checked\n\n---\n\nFUTURE : RECUPERER LE RESULTAT PLUS TARD\n\nQuand on soumet un Callable avec submit(), on obtient un Future<V> :\n\n  ExecutorService pool = Executors.newFixedThreadPool(2);\n\n  // Soumettre un Callable : la tache commence en arriere-plan\n  Future<Integer> futur = pool.submit(() -> {\n      Thread.sleep(100);\n      return 42;\n  });\n\n  // Faire autre chose pendant que la tache s execute...\n  System.out.println("La tache est en cours...");\n\n  // Recuperer le resultat (bloque si la tache n est pas encore terminee)\n  int resultat = futur.get();\n  System.out.println("Resultat: " + resultat); // 42\n\n  pool.shutdown();\n\n---\n\nMETHODES DE FUTURE\n\n  Future<Integer> f = pool.submit(() -> calcul());\n\n  // Attendre et recuperer le resultat (bloque jusqu a la fin)\n  Integer val = f.get();\n\n  // Attendre avec timeout (leve TimeoutException si trop long)\n  Integer val2 = f.get(5, TimeUnit.SECONDS);\n\n  // Verifier si la tache est terminee (sans bloquer)\n  boolean fini = f.isDone();\n\n  // Annuler la tache (true = interrompre si en cours)\n  boolean annule = f.cancel(true);\n\n  // Verifier si la tache a ete annulee\n  boolean estAnnule = f.isCancelled();\n\n---\n\nPLUSIEURS CALLABLES EN PARALLELE\n\nL interet de Callable est de lancer plusieurs calculs en parallele et d attendre tous les resultats :\n\n  import java.util.concurrent.*;\n  import java.util.ArrayList;\n  import java.util.List;\n\n  ExecutorService pool = Executors.newFixedThreadPool(4);\n  List<Future<Integer>> futurs = new ArrayList<>();\n\n  // Lancer 4 calculs en parallele\n  for (int i = 1; i <= 4; i++) {\n      final int num = i;\n      futurs.add(pool.submit(() -> num * num)); // 1, 4, 9, 16\n  }\n\n  // Attendre et afficher tous les resultats\n  int total = 0;\n  for (Future<Integer> f : futurs) {\n      total += f.get();\n  }\n\n  System.out.println("Somme des carres: " + total); // 1+4+9+16 = 30\n  pool.shutdown();\n\n---\n\nGESTION DES EXCEPTIONS DANS CALLABLE\n\nSi le Callable leve une exception, elle est capturee dans le Future. Elle est rethrown quand on appelle get() sous forme d ExecutionException :\n\n  Future<Integer> f = pool.submit(() -> {\n      if (true) throw new RuntimeException("Erreur de calcul");\n      return 42;\n  });\n\n  try {\n      int val = f.get();\n  } catch (ExecutionException e) {\n      System.out.println("Exception dans la tache: " + e.getCause().getMessage());\n  } catch (InterruptedException e) {\n      Thread.currentThread().interrupt();\n  }\n\n---\n\nINVOKEALL : LANCER UNE LISTE DE CALLABLES\n\n  List<Callable<String>> taches = new ArrayList<>();\n  taches.add(() -> "Resultat A");\n  taches.add(() -> "Resultat B");\n  taches.add(() -> "Resultat C");\n\n  // invokeAll() lance toutes les taches et attend qu elles soient toutes terminees\n  List<Future<String>> resultats = pool.invokeAll(taches);\n\n  for (Future<String> r : resultats) {\n      System.out.println(r.get());\n  }\n\ninvokeAny() lance toutes les taches et retourne le resultat de la premiere qui se termine avec succes.\n\n---\n\nEXEMPLE COMPLET : DIVISION DU TRAVAIL\n\n  import java.util.concurrent.*;\n\n  public class ExempleCallable {\n      public static void main(String[] args) throws Exception {\n          ExecutorService pool = Executors.newFixedThreadPool(2);\n\n          // Deux calculs en parallele\n          Future<Long> somme1 = pool.submit(() -> {\n              long s = 0;\n              for (int i = 1; i <= 500; i++) s += i;\n              return s; // 125250\n          });\n\n          Future<Long> somme2 = pool.submit(() -> {\n              long s = 0;\n              for (int i = 501; i <= 1000; i++) s += i;\n              return s; // 375375\n          });\n\n          long total = somme1.get() + somme2.get();\n          System.out.println("Total 1-1000: " + total); // 500500\n\n          pool.shutdown();\n      }\n  }\n\n---\n\nBONNES PRATIQUES\n\n1. Utilisez Callable quand la tache doit retourner une valeur ou lever une exception.\n2. Appelez f.get() apres avoir soumis toutes les taches pour maximiser le parallelisme.\n3. Gerez toujours ExecutionException dans le catch de f.get().\n4. Utilisez f.get(timeout, unit) pour eviter d attendre indefiniment.\n5. invokeAll() est pratique pour soumettre et attendre une liste homogene de taches.',
    4,
    40
FROM chapters c WHERE c.slug = 'programmation-concurrente';

-- =============================================
-- QUIZ : Callable et Future
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Callable et Future',
    'Testez vos connaissances sur les taches asynchrones avec Callable et Future en Java',
    300, 70, 100
FROM lessons l WHERE l.slug = 'callable-future';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la principale difference entre Callable et Runnable ?',
        'SINGLE_CHOICE',
        'Runnable.run() est void : il n a pas de valeur de retour et ne peut pas lever d exceptions checked. Callable.call() retourne une valeur de type V et peut lever des exceptions checked. Callable est donc utilise quand la tache doit produire un resultat.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'callable-future'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Callable est plus rapide que Runnable', false, 1),
    ('Callable.call() retourne une valeur et peut lever des exceptions, Runnable.run() est void', true, 2),
    ('Callable necessite plusieurs threads, Runnable fonctionne avec un seul', false, 3),
    ('Il n y a pas de difference, les deux font la meme chose', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment soumettre un Callable a un ExecutorService ?',
        'SINGLE_CHOICE',
        'pool.submit(callable) soumet un Callable et retourne un Future<V>. execute() n accepte que des Runnable et ne retourne rien. submit() peut aussi accepter un Runnable, dans ce cas le Future retourne null. Pour un Callable avec valeur de retour, il faut obligatoirement submit().',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'callable-future'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('pool.execute(callable)', false, 1),
    ('pool.submit(callable)', true, 2),
    ('pool.run(callable)', false, 3),
    ('pool.call(callable)', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que se passe-t-il quand on appelle future.get() et que la tache n est pas encore terminee ?',
        'SINGLE_CHOICE',
        'future.get() est une methode bloquante : si la tache n est pas terminee, le thread appelant attend (bloque) jusqu a ce qu elle le soit. C est le mecanisme de synchronisation entre le thread qui a soumis la tache et celui qui l execute. On peut utiliser get(timeout, unit) pour limiter le temps d attente.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'callable-future'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Une exception est levee immediatement', false, 1),
    ('Le thread appelant bloque jusqu a ce que la tache soit terminee', true, 2),
    ('get() retourne null et on doit rappeler plus tard', false, 3),
    ('La tache est annulee automatiquement', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle exception est levee par future.get() si le Callable a lance une exception ?',
        'SINGLE_CHOICE',
        'Si le Callable a leve une exception pendant son execution, future.get() leve une ExecutionException. La cause reelle (l exception originale) est accessible via e.getCause(). InterruptedException est levee si le thread appelant est interrompu pendant l attente.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'callable-future'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('L exception originale est rethrown directement', false, 1),
    ('ExecutionException (avec la cause accessible via getCause())', true, 2),
    ('RuntimeException', false, 3),
    ('CallableException', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pourquoi faut-il soumettre TOUTES les taches avant d appeler get() sur les Futures ?',
        'SINGLE_CHOICE',
        'Si on appelle get() immediatement apres chaque submit(), le thread principal bloque a chaque fois, annulant le benefice du parallelisme. En soumettant d abord toutes les taches, elles demarrent toutes en parallele. On appelle ensuite get() sur chaque Future : si une tache est deja terminee, get() retourne immediatement.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'callable-future'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('get() ne fonctionne que sur les taches qui sont deja terminees', false, 1),
    ('Pour maximiser le parallelisme : les taches s executent simultanement, et on recupere les resultats ensuite', true, 2),
    ('Sinon un deadlock se produit', false, 3),
    ('C est une obligation technique de l API Java', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que fait pool.invokeAll(listeTaches) ?',
        'SINGLE_CHOICE',
        'invokeAll() prend une liste de Callable, les soumet tous au pool, attend que TOUS soient termines, et retourne une List<Future<V>> avec les resultats dans le meme ordre que la liste d entree. C est plus pratique que de faire submit() + get() manuellement pour chaque tache.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'callable-future'
    RETURNING id
)
INSERT INTO quiz_options (question_id, text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Soumet une tache et retourne le premier resultat disponible', false, 1),
    ('Soumet toutes les taches, attend qu elles soient toutes terminees, et retourne la liste des Futures', true, 2),
    ('Soumet toutes les taches sans attendre et retourne void', false, 3),
    ('Annule toutes les taches en attente dans le pool', false, 4)
) AS opt(text, is_correct, order_index);
