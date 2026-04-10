-- V11: Contenu detaille de la lecon Boucles + QCMs

-- =============================================
-- CONTENU RICHE : Boucles
-- =============================================

UPDATE lessons SET content = E'BOUCLES ET ITERATIONS EN JAVA\n\nUne boucle repete un bloc d instructions tant qu une condition est verifiee. Java propose quatre structures de repetition : for, while, do-while et le for-each (boucle amelioree).\n\n---\n\nLA BOUCLE FOR\n\nSyntaxe :\n\n  for (initialisation; condition; incrementation) {\n      // corps de la boucle\n  }\n\nLes trois parties de l en-tete sont executees dans cet ordre :\n  1. initialisation : executee UNE seule fois au depart\n  2. condition : verifiee AVANT chaque iteration\n  3. incrementation : executee APRES chaque iteration\n\nExemples :\n\n  // Compter de 1 a 5\n  for (int i = 1; i <= 5; i++) {\n      System.out.println(i);   // 1, 2, 3, 4, 5\n  }\n\n  // Compter a rebours\n  for (int i = 10; i >= 0; i--) {\n      System.out.println(i);   // 10, 9, 8, ..., 0\n  }\n\n  // Incrementer de 2 en 2\n  for (int i = 0; i <= 10; i += 2) {\n      System.out.println(i);   // 0, 2, 4, 6, 8, 10\n  }\n\nUtilisez for quand vous connaissez a l avance le nombre d iterations.\n\n---\n\nLA BOUCLE WHILE\n\nSyntaxe :\n\n  while (condition) {\n      // corps de la boucle\n      // IMPORTANT : modifier la condition pour eviter une boucle infinie !\n  }\n\nLa condition est verifiee AVANT chaque iteration. Si elle est false des le debut, le corps n est jamais execute.\n\nExemples :\n\n  // Diviser par 2 jusqu a atteindre 1\n  int n = 100;\n  while (n > 1) {\n      n = n / 2;\n      System.out.println(n);   // 50, 25, 12, 6, 3, 1\n  }\n\n  // Lire une saisie valide (simulation)\n  int tentatives = 0;\n  int maxTentatives = 3;\n  while (tentatives < maxTentatives) {\n      tentatives++;\n      System.out.println("Tentative " + tentatives);\n  }\n\nUtilisez while quand le nombre d iterations est inconnu et depend d une condition.\n\n---\n\nLA BOUCLE DO-WHILE\n\nSyntaxe :\n\n  do {\n      // corps de la boucle\n  } while (condition);\n\nDifference cle avec while : le corps est execute AU MOINS UNE FOIS, car la condition est verifiee APRES la premiere iteration.\n\nExemple :\n\n  int nombre = 0;\n  do {\n      System.out.println("Valeur : " + nombre);\n      nombre++;\n  } while (nombre < 3);\n  // Affiche : Valeur : 0, Valeur : 1, Valeur : 2\n\nUtilisation typique : menus, validation de saisie.\n\n---\n\nBREAK ET CONTINUE\n\nbreak : sort immediatement de la boucle\ncontinue : saute le reste de l iteration courante et passe a la suivante\n\n  // break : arreter quand on trouve 5\n  for (int i = 0; i < 10; i++) {\n      if (i == 5) break;\n      System.out.println(i);   // 0, 1, 2, 3, 4\n  }\n\n  // continue : sauter les nombres pairs\n  for (int i = 0; i < 10; i++) {\n      if (i % 2 == 0) continue;\n      System.out.println(i);   // 1, 3, 5, 7, 9\n  }\n\n---\n\nLA BOUCLE FOR-EACH (BOUCLE AMELIOREE)\n\nSyntaxe :\n\n  for (type element : collection) {\n      // utiliser element\n  }\n\nPlus lisible pour parcourir des tableaux ou des collections :\n\n  int[] scores = {85, 92, 78, 95, 88};\n\n  // Avec for classique\n  for (int i = 0; i < scores.length; i++) {\n      System.out.println(scores[i]);\n  }\n\n  // Avec for-each (plus lisible !)\n  for (int score : scores) {\n      System.out.println(score);\n  }\n\nLimite du for-each : impossible de modifier l index ou d acceder a l indice de l element. Dans ces cas, utilisez le for classique.\n\n---\n\nBOUCLES IMBRIQUEES\n\nOn peut placer une boucle dans une autre pour traiter des structures 2D :\n\n  // Table de multiplication\n  for (int i = 1; i <= 3; i++) {\n      for (int j = 1; j <= 3; j++) {\n          System.out.print(i * j + " ");\n      }\n      System.out.println();   // Saut de ligne\n  }\n  // Affiche :\n  // 1 2 3\n  // 2 4 6\n  // 3 6 9\n\nATTENTION : les boucles imbriquees peuvent etre lentes. Une boucle dans une boucle dans une boucle = complexite cubique !\n\n---\n\nPIEGES COURANTS\n\nBoucle infinie :\n  while (true) { ... }   // ne se termine jamais sauf avec break\n  for (;;) { ... }       // equivalent, ne se termine jamais\n\nErreur de borne (off-by-one) :\n  for (int i = 0; i < 5; i++)    // 5 iterations : 0, 1, 2, 3, 4 (CORRECT)\n  for (int i = 0; i <= 5; i++)   // 6 iterations : 0, 1, 2, 3, 4, 5 (souvent un bug)\n\nModification de variable de boucle :\n  for (int i = 0; i < 5; i++) {\n      i++;   // MAUVAISE PRATIQUE : la boucle ne fait que 3 iterations au lieu de 5\n  }'
WHERE slug = 'boucles';

-- =============================================
-- QUIZ : Boucles
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Boucles et iterations',
    'Testez votre maitrise des boucles for, while, do-while, break et continue',
    300, 70, 100
FROM lessons l WHERE l.slug = 'boucles';

-- Question 1 : boucle for
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Combien de fois le corps de cette boucle s execute-t-il ? for (int i = 0; i < 5; i++)',
        'SINGLE_CHOICE',
        'La variable i commence a 0 et la condition est i < 5. Les valeurs de i sont 0, 1, 2, 3, 4 soit 5 iterations. La boucle s arrete quand i vaut 5 car 5 < 5 est false.',
        1
    FROM quizzes qz WHERE qz.title = 'Quiz - Boucles et iterations'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, '4 fois', false, 1 FROM q
UNION ALL SELECT q.id, '5 fois', true, 2 FROM q
UNION ALL SELECT q.id, '6 fois', false, 3 FROM q
UNION ALL SELECT q.id, 'Indefiniment', false, 4 FROM q;

-- Question 2 : do-while vs while
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la difference principale entre do-while et while ?',
        'SINGLE_CHOICE',
        'Dans une boucle do-while, le corps est execute AU MOINS UNE FOIS car la condition est evaluee apres la premiere iteration. Dans une boucle while, si la condition est false des le debut, le corps n est jamais execute.',
        2
    FROM quizzes qz WHERE qz.title = 'Quiz - Boucles et iterations'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'do-while est plus rapide que while', false, 1 FROM q
UNION ALL SELECT q.id, 'do-while execute le corps au moins une fois', true, 2 FROM q
UNION ALL SELECT q.id, 'do-while ne peut pas utiliser break', false, 3 FROM q
UNION ALL SELECT q.id, 'Il n y a aucune difference', false, 4 FROM q;

-- Question 3 : break
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que fait l instruction break dans une boucle ?',
        'SINGLE_CHOICE',
        'break interrompt immediatement la boucle courante et l execution reprend apres la boucle. Il est souvent utilise pour sortir d une boucle quand une condition particuliere est atteinte, par exemple trouver un element dans un tableau.',
        3
    FROM quizzes qz WHERE qz.title = 'Quiz - Boucles et iterations'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Elle met en pause la boucle', false, 1 FROM q
UNION ALL SELECT q.id, 'Elle saute a l iteration suivante', false, 2 FROM q
UNION ALL SELECT q.id, 'Elle sort immediatement de la boucle', true, 3 FROM q
UNION ALL SELECT q.id, 'Elle recommence la boucle depuis le debut', false, 4 FROM q;

-- Question 4 : continue
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle instruction saute le reste de l iteration courante et passe a la suivante ?',
        'SINGLE_CHOICE',
        'continue interrompt l iteration courante et passe directement a la prochaine verification de la condition (puis a la prochaine iteration si la condition est vraie). Le reste du code de l iteration courante est ignore.',
        4
    FROM quizzes qz WHERE qz.title = 'Quiz - Boucles et iterations'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'break', false, 1 FROM q
UNION ALL SELECT q.id, 'skip', false, 2 FROM q
UNION ALL SELECT q.id, 'next', false, 3 FROM q
UNION ALL SELECT q.id, 'continue', true, 4 FROM q;

-- Question 5 : for-each
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Pour parcourir tous les elements d un tableau int[] notes, quelle syntaxe for-each est correcte ?',
        'SINGLE_CHOICE',
        'La syntaxe du for-each est : for (type element : tableau). Pour un int[], on ecrit for (int note : notes). Cette syntaxe est plus lisible que le for classique et evite les erreurs d index.',
        5
    FROM quizzes qz WHERE qz.title = 'Quiz - Boucles et iterations'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'for (notes.each note)', false, 1 FROM q
UNION ALL SELECT q.id, 'foreach (int note in notes)', false, 2 FROM q
UNION ALL SELECT q.id, 'for (int note : notes)', true, 3 FROM q
UNION ALL SELECT q.id, 'for (note in notes)', false, 4 FROM q;

-- Question 6 : boucle infinie
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel est le risque principal si l on oublie de modifier la variable de condition dans une boucle while ?',
        'SINGLE_CHOICE',
        'Si la variable controlant la condition du while n est jamais modifiee, la condition reste toujours true et la boucle ne se termine jamais : c est une boucle infinie. Le programme se bloque et consomme 100% du CPU. Il faut toujours s assurer que la condition deviendra false a un moment.',
        6
    FROM quizzes qz WHERE qz.title = 'Quiz - Boucles et iterations'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'La boucle s arrete automatiquement apres 1000 iterations', false, 1 FROM q
UNION ALL SELECT q.id, 'Une boucle infinie se produit et le programme se bloque', true, 2 FROM q
UNION ALL SELECT q.id, 'Java leve une exception LoopException', false, 3 FROM q
UNION ALL SELECT q.id, 'La boucle s execute exactement une fois', false, 4 FROM q;
