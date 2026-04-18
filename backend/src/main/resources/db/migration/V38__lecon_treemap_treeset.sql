-- V38: Lecon 4 Collections - TreeMap et TreeSet + Quiz

-- =============================================
-- LECON 4 : TreeMap et TreeSet
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'TreeMap et TreeSet : collections triees',
    'treemap-treeset',
    E'TREEMAP ET TREESET : COLLECTIONS TRIEES\n\nHashMap et HashSet offrent des performances maximales mais sans ordre garanti. TreeMap et TreeSet sont leurs equivalents TRIES : les elements sont automatiquement ranges par ordre naturel (alphabetique pour String, numerique pour Integer) a chaque insertion.\n\n---\n\nTREEMAP : PAIRES CLE-VALEUR TRIEES PAR CLE\n\n  import java.util.TreeMap;\n\n  TreeMap<String, Integer> scores = new TreeMap<>();\n  scores.put("Charlie", 85);\n  scores.put("Alice", 92);\n  scores.put("Bob", 78);\n\n  for (String nom : scores.keySet()) {\n      System.out.println(nom + " : " + scores.get(nom));\n  }\n  // Alice : 92\n  // Bob : 78\n  // Charlie : 85\n\nLes cles sont triees automatiquement. Les operations put(), get(), remove(), containsKey(), size() sont identiques a HashMap.\n\n---\n\nPREMIER ET DERNIER ELEMENT DANS TREEMAP\n\nTreeMap offre des methodes pour acceder aux extremites du tri :\n\n  TreeMap<String, Integer> notes = new TreeMap<>();\n  notes.put("mathematiques", 16);\n  notes.put("physique", 14);\n  notes.put("informatique", 18);\n  notes.put("biologie", 12);\n\n  System.out.println(notes.firstKey()); // biologie (premier alphabetiquement)\n  System.out.println(notes.lastKey());  // physique (dernier alphabetiquement)\n\n  System.out.println(notes.firstEntry().getValue()); // 12\n  System.out.println(notes.lastEntry().getValue());  // 14\n\n---\n\nSECTIONS D UNE TREEMAP\n\nTreeMap permet d extraire des sous-cartes basees sur les cles :\n\n  TreeMap<Integer, String> jours = new TreeMap<>();\n  jours.put(1, "Lundi");\n  jours.put(2, "Mardi");\n  jours.put(3, "Mercredi");\n  jours.put(4, "Jeudi");\n  jours.put(5, "Vendredi");\n\n  // Jours avant la cle 3 (exclu)\n  System.out.println(jours.headMap(3)); // {1=Lundi, 2=Mardi}\n\n  // Jours a partir de la cle 3 (inclus)\n  System.out.println(jours.tailMap(3)); // {3=Mercredi, 4=Jeudi, 5=Vendredi}\n\n  // Jours entre cle 2 (inclus) et cle 4 (exclu)\n  System.out.println(jours.subMap(2, 4)); // {2=Mardi, 3=Mercredi}\n\n---\n\nTREESET : ELEMENTS UNIQUES ET TRIES\n\n  import java.util.TreeSet;\n\n  TreeSet<String> villes = new TreeSet<>();\n  villes.add("Paris");\n  villes.add("Lyon");\n  villes.add("Marseille");\n  villes.add("Paris"); // doublon ignore\n\n  for (String v : villes) {\n      System.out.println(v);\n  }\n  // Lyon\n  // Marseille\n  // Paris\n\nLes operations add(), remove(), contains(), size() sont identiques a HashSet.\n\n---\n\nPREMIER ET DERNIER ELEMENT DANS TREESET\n\n  TreeSet<Integer> nombres = new TreeSet<>();\n  nombres.add(42);\n  nombres.add(7);\n  nombres.add(99);\n  nombres.add(15);\n\n  System.out.println(nombres.first()); // 7 (le plus petit)\n  System.out.println(nombres.last());  // 99 (le plus grand)\n\n  // Nombres strictement inferieurs a 20\n  System.out.println(nombres.headSet(20)); // [7, 15]\n\n  // Nombres superieurs ou egaux a 20\n  System.out.println(nombres.tailSet(20)); // [42, 99]\n\n---\n\nCAS D USAGE CONCRET\n\nAfficher un classement des etudiants par ordre alphabetique avec leur moyenne :\n\n  TreeMap<String, Double> classement = new TreeMap<>();\n  classement.put("Zoe", 14.5);\n  classement.put("Antoine", 16.0);\n  classement.put("Marie", 15.5);\n  classement.put("Kevin", 13.0);\n\n  System.out.println("=== Classement ===");\n  for (String etudiant : classement.keySet()) {\n      System.out.println(etudiant + " : " + classement.get(etudiant) + "/20");\n  }\n  // Antoine : 16.0/20\n  // Kevin : 13.0/20\n  // Marie : 15.5/20\n  // Zoe : 14.5/20\n\n---\n\nHASH VS TREE : QUAND UTILISER QUOI ?\n\nHashMap / HashSet :\n  - Priorite aux performances maximales\n  - O(1) pour les operations courantes\n  - Ordre des elements non important\n  - Usage : comptages, cache, recherche rapide\n\nTreeMap / TreeSet :\n  - Elements tries automatiquement par ordre naturel\n  - O(log n) pour les operations (un peu plus lent)\n  - Besoin du min, du max, ou d une plage d elements\n  - Usage : classements, dictionnaires, plages de valeurs\n\nRegle pratique : utilisez Hash par defaut et passez a Tree uniquement quand le tri est necessaire.\n\n---\n\nTABLEAU RECAPITULATIF DES 5 COLLECTIONS\n\nArrayList  | Doublons : oui | Ordre : insertion   | Acces : get(index)\nHashSet    | Doublons : non | Ordre : aucun       | Acces : contains()\nTreeSet    | Doublons : non | Ordre : trie        | Acces : first(), last()\nHashMap    | Cles : non     | Ordre : aucun       | Acces : get(cle)\nTreeMap    | Cles : non     | Ordre : trie/cles   | Acces : firstKey(), lastKey()\n\nBravo ! Vous avez complete le chapitre Collections Java. Vous maitrisez maintenant les 5 structures de donnees fondamentales de Java !',
    4,
    40
FROM chapters c WHERE c.slug = 'collections-java';

-- =============================================
-- QUIZ : TreeMap et TreeSet
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - TreeMap et TreeSet',
    'Testez vos connaissances sur les collections triees TreeMap et TreeSet',
    300, 70, 100
FROM lessons l WHERE l.slug = 'treemap-treeset';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la principale difference entre HashMap et TreeMap ?',
        'SINGLE_CHOICE',
        'HashMap ne garantit pas l ordre des cles. TreeMap trie automatiquement les cles par ordre naturel (alphabetique pour String, numerique pour Integer).',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'treemap-treeset'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'TreeMap est plus rapide que HashMap', false, 1),
((SELECT id FROM q), 'TreeMap trie les cles automatiquement, HashMap ne le fait pas', true, 2),
((SELECT id FROM q), 'TreeMap accepte des cles dupliquees, pas HashMap', false, 3),
((SELECT id FROM q), 'HashMap trie les cles, TreeMap ne le fait pas', false, 4);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode de TreeMap retourne la plus petite cle presente ?',
        'SINGLE_CHOICE',
        'firstKey() retourne la plus petite cle (premier dans l ordre naturel). lastKey() retourne la plus grande cle.',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'treemap-treeset'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'minKey()', false, 1),
((SELECT id FROM q), 'getFirst()', false, 2),
((SELECT id FROM q), 'firstKey()', true, 3),
((SELECT id FROM q), 'headKey()', false, 4);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que fait la methode headMap(5) sur une TreeMap<Integer, String> ?',
        'SINGLE_CHOICE',
        'headMap(5) retourne une vue de la carte contenant toutes les entrees dont la cle est strictement inferieure a 5.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'treemap-treeset'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Retourne les 5 premieres entrees de la carte', false, 1),
((SELECT id FROM q), 'Retourne toutes les entrees avec une cle >= 5', false, 2),
((SELECT id FROM q), 'Retourne toutes les entrees avec une cle < 5', true, 3),
((SELECT id FROM q), 'Retourne uniquement l entree avec la cle 5', false, 4);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Un TreeSet<String> contient "Zoe", "Alice", "Marie". Que retourne first() ?',
        'SINGLE_CHOICE',
        'TreeSet trie les String par ordre alphabetique. "Alice" vient en premier, donc first() retourne "Alice".',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'treemap-treeset'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), '"Zoe"', false, 1),
((SELECT id FROM q), '"Alice"', true, 2),
((SELECT id FROM q), '"Marie"', false, 3),
((SELECT id FROM q), 'Le premier element insere', false, 4);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la complexite des operations get() et put() dans un TreeMap ?',
        'SINGLE_CHOICE',
        'TreeMap est base sur un arbre rouge-noir. Les operations sont en O(log n), ce qui est plus lent que HashMap (O(1)) mais garantit le tri des cles.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'treemap-treeset'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'O(1) - acces instantane', false, 1),
((SELECT id FROM q), 'O(n) - parcours lineaire', false, 2),
((SELECT id FROM q), 'O(log n) - arbre equilibre', true, 3),
((SELECT id FROM q), 'O(n2) - comparaison quadratique', false, 4);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Dans quelle situation preferez-vous TreeSet plutot que HashSet ?',
        'SINGLE_CHOICE',
        'TreeSet est prefere quand on a besoin que les elements soient tries automatiquement, ou quand on doit acceder facilement au minimum et au maximum avec first() et last().',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'treemap-treeset'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index) VALUES
((SELECT id FROM q), 'Quand on a besoin des meilleures performances en insertion', false, 1),
((SELECT id FROM q), 'Quand on veut autoriser les doublons dans la collection', false, 2),
((SELECT id FROM q), 'Quand on a besoin que les elements soient tries et d acceder au min/max', true, 3),
((SELECT id FROM q), 'Quand on veut stocker des paires cle-valeur', false, 4);
