-- V10: Contenu detaille de la lecon Conditions + QCMs

-- =============================================
-- CONTENU RICHE : Conditions
-- =============================================

UPDATE lessons SET content = E'CONDITIONS ET BRANCHEMENTS EN JAVA\n\nLes structures conditionnelles permettent a un programme de prendre des decisions : executer tel bloc de code si une condition est vraie, tel autre sinon. C est le fondement de toute logique applicative.\n\n---\n\nIF / ELSE IF / ELSE\n\nSyntaxe de base :\n\n  if (condition) {\n      // execute si condition est true\n  } else if (autreCondition) {\n      // execute si la premiere est false et celle-ci est true\n  } else {\n      // execute si aucune condition precedente n est true\n  }\n\nExemple concret :\n\n  int score = 75;\n\n  if (score >= 90) {\n      System.out.println("Excellent !");\n  } else if (score >= 70) {\n      System.out.println("Bien !");\n  } else if (score >= 50) {\n      System.out.println("Passable");\n  } else {\n      System.out.println("Insuffisant");\n  }\n  // Affiche : "Bien !"\n\nPoints importants :\n- La condition doit etre un boolean (true ou false)\n- Les blocs else if et else sont optionnels\n- Seul le premier bloc dont la condition est vraie est execute, les suivants sont ignores\n- Les accolades { } sont facultatives pour un seul statement, mais TOUJOURS recommandees\n\n---\n\nOPERATEURS DE COMPARAISON\n\n  ==   egal a\n  !=   different de\n  >    superieur a\n  <    inferieur a\n  >=   superieur ou egal a\n  <=   inferieur ou egal a\n\nATTENTION : == compare les valeurs pour les types primitifs, mais les references pour les objets.\nPour les Strings, utilisez toujours .equals().\n\n---\n\nOPERATEURS LOGIQUES\n\nLes operateurs logiques combinent plusieurs conditions :\n\n  &&  ET logique : true seulement si les DEUX conditions sont true\n  ||  OU logique : true si AU MOINS UNE condition est true\n  !   NON logique : inverse la valeur booleenne\n\nExemples :\n\n  int age = 25;\n  boolean aPermis = true;\n\n  // ET : les deux conditions doivent etre vraies\n  if (age >= 18 && aPermis) {\n      System.out.println("Peut conduire");\n  }\n\n  // OU : au moins une condition vraie\n  if (age < 12 || age > 65) {\n      System.out.println("Tarif reduit");\n  }\n\n  // NON : inverse la condition\n  if (!aPermis) {\n      System.out.println("Pas de permis");\n  }\n\nCourt-circuit (short-circuit evaluation) :\n- Avec &&, si la premiere condition est false, la seconde n est pas evaluee\n- Avec ||, si la premiere condition est true, la seconde n est pas evaluee\nCela evite des erreurs (ex: tester obj != null && obj.length() > 0)\n\n---\n\nL OPERATEUR TERNAIRE\n\nL operateur ternaire est un if/else compact sur une ligne :\n\n  // Syntaxe : condition ? valeurSiVrai : valeurSiFaux\n\n  int age = 20;\n  String statut = age >= 18 ? "majeur" : "mineur";\n  System.out.println(statut);   // "majeur"\n\n  // Equivalent long :\n  String statut;\n  if (age >= 18) {\n      statut = "majeur";\n  } else {\n      statut = "mineur";\n  }\n\nConseils : utilisez le ternaire pour des conditions simples. Pour les logiques complexes, preferez if/else pour la lisibilite.\n\n---\n\nSWITCH CLASSIQUE\n\nLe switch teste l egalite d une variable contre plusieurs valeurs :\n\n  int jour = 3;\n\n  switch (jour) {\n      case 1:\n          System.out.println("Lundi");\n          break;\n      case 2:\n          System.out.println("Mardi");\n          break;\n      case 3:\n          System.out.println("Mercredi");\n          break;\n      default:\n          System.out.println("Autre jour");\n  }\n\nATTENTION au fall-through : sans break, l execution continue dans le case suivant !\n\n  switch (jour) {\n      case 1:\n      case 2:\n      case 3:\n      case 4:\n      case 5:\n          System.out.println("Jour de semaine");   // pour 1, 2, 3, 4 ou 5\n          break;\n      case 6:\n      case 7:\n          System.out.println("Weekend");   // pour 6 ou 7\n          break;\n  }\n\n---\n\nSWITCH EXPRESSION (Java 14+)\n\nJava 14 a introduit une syntaxe moderne pour switch, plus concise et sans risque de fall-through :\n\n  // Avec fleche -> (pas besoin de break)\n  String nomJour = switch (jour) {\n      case 1 -> "Lundi";\n      case 2 -> "Mardi";\n      case 3 -> "Mercredi";\n      case 4 -> "Jeudi";\n      case 5 -> "Vendredi";\n      case 6 -> "Samedi";\n      case 7 -> "Dimanche";\n      default -> "Invalide";\n  };\n\n  // Plusieurs valeurs dans un case\n  String typeJour = switch (jour) {\n      case 1, 2, 3, 4, 5 -> "Semaine";\n      case 6, 7 -> "Weekend";\n      default -> "Invalide";\n  };\n\n---\n\nCONDITIONS IMBRIQUEES\n\nOn peut imbriquer des if dans d autres if pour des logiques complexes :\n\n  int temperature = 22;\n  boolean ilPleut = false;\n\n  if (temperature > 15) {\n      if (!ilPleut) {\n          System.out.println("Bonne journee pour sortir !");\n      } else {\n          System.out.println("Il fait chaud mais il pleut...");\n      }\n  } else {\n      System.out.println("Il fait froid, restez au chaud.");\n  }\n\nConseils : au-dela de 2-3 niveaux d imbrication, refactorisez en methodes separees ou utilisez des conditions combinees avec && / || pour aplatir la logique.'
WHERE slug = 'conditions';

-- =============================================
-- QUIZ : Conditions
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Conditions et branchements',
    'Testez votre maitrise de if/else, switch, operateurs logiques et ternaire',
    300, 70, 100
FROM lessons l WHERE l.slug = 'conditions';

-- Question 1 : operateur ET
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel operateur logique retourne true seulement si les DEUX conditions sont vraies ?',
        'SINGLE_CHOICE',
        'L operateur && (ET logique) retourne true uniquement si les deux operandes sont true. L operateur || (OU logique) retourne true si au moins un operande est true.',
        1
    FROM quizzes qz WHERE qz.title = 'Quiz - Conditions et branchements'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, '||', false, 1 FROM q
UNION ALL SELECT q.id, '&&', true, 2 FROM q
UNION ALL SELECT q.id, '!', false, 3 FROM q
UNION ALL SELECT q.id, '&', false, 4 FROM q;

-- Question 2 : fall-through switch
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Dans un switch classique, que se passe-t-il si on oublie le mot-cle break apres un case ?',
        'SINGLE_CHOICE',
        'Sans break, Java continue d executer le code des cases suivants (fall-through). C est un comportement voulu dans certains cas (regrouper des cases) mais souvent source de bugs. Le switch expression avec -> (Java 14+) resout ce probleme.',
        2
    FROM quizzes qz WHERE qz.title = 'Quiz - Conditions et branchements'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Le programme s arrete', false, 1 FROM q
UNION ALL SELECT q.id, 'Une erreur de compilation est generee', false, 2 FROM q
UNION ALL SELECT q.id, 'L execution continue dans les cases suivants', true, 3 FROM q
UNION ALL SELECT q.id, 'Le case default est execute', false, 4 FROM q;

-- Question 3 : operateur ternaire
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la valeur de : String r = (10 > 5) ? "grand" : "petit"; ?',
        'SINGLE_CHOICE',
        'La condition 10 > 5 est true, donc l operateur ternaire retourne la valeur a gauche des deux-points : "grand".',
        3
    FROM quizzes qz WHERE qz.title = 'Quiz - Conditions et branchements'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, '"petit"', false, 1 FROM q
UNION ALL SELECT q.id, '"grand"', true, 2 FROM q
UNION ALL SELECT q.id, 'true', false, 3 FROM q
UNION ALL SELECT q.id, 'Erreur de compilation', false, 4 FROM q;

-- Question 4 : short-circuit
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Avec l operateur &&, que se passe-t-il si la premiere condition est false ?',
        'SINGLE_CHOICE',
        'C est le court-circuit (short-circuit evaluation). Si la premiere condition de && est false, le resultat global est forcement false, donc Java n evalue pas la seconde condition. Cela est utile pour eviter des NullPointerException : if (obj != null && obj.length() > 0).',
        4
    FROM quizzes qz WHERE qz.title = 'Quiz - Conditions et branchements'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'La seconde condition est quand meme evaluee', false, 1 FROM q
UNION ALL SELECT q.id, 'La seconde condition n est pas evaluee', true, 2 FROM q
UNION ALL SELECT q.id, 'Une exception est levee', false, 3 FROM q
UNION ALL SELECT q.id, 'Le resultat est null', false, 4 FROM q;

-- Question 5 : switch expression Java 14
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel avantage principal offre le switch expression avec -> introduit en Java 14 ?',
        'SINGLE_CHOICE',
        'Le switch expression avec -> elimine le fall-through : chaque case est independant et ne necessite pas de break. Il permet aussi d affecter directement le resultat a une variable. Plusieurs valeurs peuvent etre listees dans un meme case avec une virgule.',
        5
    FROM quizzes qz WHERE qz.title = 'Quiz - Conditions et branchements'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Il est plus rapide a l execution', false, 1 FROM q
UNION ALL SELECT q.id, 'Il elimine le risque de fall-through et est plus concis', true, 2 FROM q
UNION ALL SELECT q.id, 'Il fonctionne avec tous les types Java', false, 3 FROM q
UNION ALL SELECT q.id, 'Il remplace completement if/else', false, 4 FROM q;

-- Question 6 : condition booleenne
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Parmi ces conditions Java, laquelle est incorrecte ?',
        'SINGLE_CHOICE',
        'En Java, la condition d un if doit etre un boolean. Ecrire if (x) ou x est un int est invalide (contrairement au C). Il faut explicitement ecrire if (x != 0). Les trois autres options sont des expressions booleennes valides.',
        6
    FROM quizzes qz WHERE qz.title = 'Quiz - Conditions et branchements'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'if (age >= 18 && age < 65)', false, 1 FROM q
UNION ALL SELECT q.id, 'if (!estConnecte)', false, 2 FROM q
UNION ALL SELECT q.id, 'if (score)', true, 3 FROM q
UNION ALL SELECT q.id, 'if (nom.equals("Alice"))', false, 4 FROM q;
