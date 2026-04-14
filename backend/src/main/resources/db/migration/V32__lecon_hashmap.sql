-- V32: Lecon 2 HashMap + Quiz

-- =============================================
-- LECON 2 : HashMap
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'HashMap : paires cle-valeur',
    'hashmap',
    E'HASHMAP EN JAVA : PAIRES CLE-VALEUR\n\nArrayList stocke des elements dans une liste ordonnee. HashMap stocke des PAIRES : pour chaque cle, une valeur associee. C est comme un dictionnaire : on cherche un mot (cle) pour trouver sa definition (valeur).\n\n---\n\nCREER UNE HASHMAP\n\nLa declaration utilise deux types generiques : le type de la cle et le type de la valeur :\n\n  import java.util.HashMap;\n\n  HashMap<String, Integer> ages = new HashMap<>();\n  HashMap<String, String> capitales = new HashMap<>();\n  HashMap<Integer, String> codes = new HashMap<>();\n\nLa premiere paire de < > est le type de la cle, la seconde est le type de la valeur.\n\n---\n\nAJOUTER ET LIRE DES PAIRES\n\n  HashMap<String, String> capitales = new HashMap<>();\n\n  // Ajouter une paire cle -> valeur\n  capitales.put("France", "Paris");\n  capitales.put("Espagne", "Madrid");\n  capitales.put("Italie", "Rome");\n  capitales.put("Allemagne", "Berlin");\n\n  // Lire la valeur associee a une cle\n  System.out.println(capitales.get("France"));   // Paris\n  System.out.println(capitales.get("Italie"));   // Rome\n  System.out.println(capitales.get("Japon"));    // null (cle absente)\n\n  // Verifier si une cle existe\n  System.out.println(capitales.containsKey("Espagne")); // true\n  System.out.println(capitales.containsKey("Chine"));   // false\n\n  // Nombre de paires\n  System.out.println(capitales.size()); // 4\n\n---\n\nMODIFIER ET SUPPRIMER\n\n  HashMap<String, Integer> scores = new HashMap<>();\n  scores.put("Alice", 100);\n  scores.put("Bob", 85);\n  scores.put("Clara", 92);\n\n  // Modifier une valeur : put() ecrase l ancienne valeur\n  scores.put("Bob", 90); // Bob passe de 85 a 90\n\n  // Supprimer une paire par sa cle\n  scores.remove("Clara");\n\n  System.out.println(scores.get("Bob"));   // 90\n  System.out.println(scores.get("Clara")); // null (supprime)\n  System.out.println(scores.size());       // 2\n\n---\n\nPARCOURIR UNE HASHMAP\n\nOn parcourt les cles avec keySet() :\n\n  HashMap<String, Integer> notes = new HashMap<>();\n  notes.put("Maths", 18);\n  notes.put("Physique", 15);\n  notes.put("Francais", 14);\n\n  for (String matiere : notes.keySet()) {\n      System.out.println(matiere + " : " + notes.get(matiere));\n  }\n  // Maths : 18\n  // Physique : 15\n  // Francais : 14\n\nAttention : HashMap ne garantit PAS l ordre d insertion. L ordre d affichage peut differer de l ordre d insertion.\n\ngetOrDefault() pour eviter null :\n\n  // Retourne la valeur si la cle existe, sinon la valeur par defaut\n  int note = notes.getOrDefault("Histoire", 0);\n  System.out.println(note); // 0 car "Histoire" n est pas dans la map\n\n---\n\nCOMPTEUR DE MOTS : EXEMPLE CLASSIQUE\n\nHashMap est ideal pour compter des occurrences :\n\n  String[] mots = {"chat", "chien", "chat", "oiseau", "chien", "chat"};\n  HashMap<String, Integer> compteur = new HashMap<>();\n\n  for (String mot : mots) {\n      // Si le mot existe deja, incrementer ; sinon initialiser a 1\n      int count = compteur.getOrDefault(mot, 0);\n      compteur.put(mot, count + 1);\n  }\n\n  for (String mot : compteur.keySet()) {\n      System.out.println(mot + " : " + compteur.get(mot));\n  }\n  // chat : 3\n  // chien : 2\n  // oiseau : 1\n\n---\n\nARRAYLIST vs HASHMAP\n\nArrayList :\n  - Stocke des elements dans une liste ordonnee\n  - Acces par index numerique : liste.get(0)\n  - Recherche d un element : O(n) - parcours lineaire\n  - Ideal quand l ordre compte et qu on parcourt souvent\n\nHashMap :\n  - Stocke des paires cle-valeur\n  - Acces par cle : map.get("nom")\n  - Recherche par cle : O(1) - acces quasi instantane\n  - Ideal pour les associations et la recherche rapide par identifiant\n\nBravo ! Vous maitrisez maintenant les deux collections fondamentales de Java.',
    2,
    45
FROM chapters c WHERE c.slug = 'collections-java';

-- =============================================
-- QUIZ : HashMap
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - HashMap',
    'Testez vos connaissances sur les paires cle-valeur avec HashMap',
    300, 70, 100
FROM lessons l WHERE l.slug = 'hashmap';

-- Question 1 : definition HashMap
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Qu est-ce qu une HashMap en Java ?',
        'SINGLE_CHOICE',
        'Une HashMap stocke des PAIRES cle-valeur : chaque cle unique est associee a une valeur. Pensez a un dictionnaire : le mot est la cle, la definition est la valeur. On declare la HashMap avec deux types generiques : HashMap<TypeCle, TypeValeur>. L acces par cle est quasi instantane (O(1)), ce qui rend HashMap tres efficace pour la recherche rapide.',
        1
    FROM quizzes qz WHERE qz.title = 'Quiz - HashMap'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Une liste ordonnee d elements', false, 1 FROM q
UNION ALL SELECT q.id, 'Une structure de paires cle-valeur', true, 2 FROM q
UNION ALL SELECT q.id, 'Un tableau de taille fixe', false, 3 FROM q
UNION ALL SELECT q.id, 'Une file d attente d elements', false, 4 FROM q;

-- Question 2 : put()
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode ajoute ou modifie une paire cle-valeur dans une HashMap ?',
        'SINGLE_CHOICE',
        'La methode put(cle, valeur) ajoute une nouvelle paire ou ECRASE la valeur existante si la cle est deja presente. Par exemple : scores.put("Alice", 100) puis scores.put("Alice", 110) : la deuxieme instruction remplace la premiere, Alice aura 110. C est pourquoi on dit que les cles sont uniques dans une HashMap.',
        2
    FROM quizzes qz WHERE qz.title = 'Quiz - HashMap'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'add(cle, valeur)', false, 1 FROM q
UNION ALL SELECT q.id, 'set(cle, valeur)', false, 2 FROM q
UNION ALL SELECT q.id, 'put(cle, valeur)', true, 3 FROM q
UNION ALL SELECT q.id, 'insert(cle, valeur)', false, 4 FROM q;

-- Question 3 : get()
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que retourne map.get("cle") si la cle n existe pas dans la HashMap ?',
        'SINGLE_CHOICE',
        'Si la cle n existe pas, get() retourne null et non une exception. C est pourquoi il est prudent d utiliser containsKey() avant get() ou d utiliser getOrDefault(cle, valeurDefaut). getOrDefault("cle", 0) retourne 0 si la cle est absente au lieu de null, ce qui evite les NullPointerException lors d operations arithmetiques.',
        3
    FROM quizzes qz WHERE qz.title = 'Quiz - HashMap'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Une exception IndexOutOfBoundsException', false, 1 FROM q
UNION ALL SELECT q.id, 'La valeur 0 par defaut', false, 2 FROM q
UNION ALL SELECT q.id, 'null', true, 3 FROM q
UNION ALL SELECT q.id, 'Une chaine vide ""', false, 4 FROM q;

-- Question 4 : containsKey
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode verifie si une cle existe dans une HashMap ?',
        'SINGLE_CHOICE',
        'containsKey(cle) retourne true si la cle est presente dans la map, false sinon. Il existe aussi containsValue(valeur) pour chercher une valeur, mais cette operation est plus lente O(n) car elle doit parcourir toutes les entrees. containsKey() est O(1) grace au mecanisme de hashage. Exemple : if (map.containsKey("Alice")) { System.out.println(map.get("Alice")); }',
        4
    FROM quizzes qz WHERE qz.title = 'Quiz - HashMap'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'hasKey(cle)', false, 1 FROM q
UNION ALL SELECT q.id, 'exists(cle)', false, 2 FROM q
UNION ALL SELECT q.id, 'containsKey(cle)', true, 3 FROM q
UNION ALL SELECT q.id, 'includes(cle)', false, 4 FROM q;

-- Question 5 : keySet
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle methode retourne toutes les cles d une HashMap pour les parcourir ?',
        'SINGLE_CHOICE',
        'keySet() retourne un Set contenant toutes les cles de la HashMap. On l utilise typiquement dans une boucle for-each : for (String cle : map.keySet()) { System.out.println(cle + " -> " + map.get(cle)); }. Attention : l ordre d iteration n est pas garanti par HashMap. Si l ordre d insertion est important, utilisez LinkedHashMap a la place.',
        5
    FROM quizzes qz WHERE qz.title = 'Quiz - HashMap'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'getKeys()', false, 1 FROM q
UNION ALL SELECT q.id, 'keys()', false, 2 FROM q
UNION ALL SELECT q.id, 'keySet()', true, 3 FROM q
UNION ALL SELECT q.id, 'allKeys()', false, 4 FROM q;

-- Question 6 : getOrDefault
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'A quoi sert la methode getOrDefault(cle, valeurParDefaut) ?',
        'SINGLE_CHOICE',
        'getOrDefault(cle, defaut) retourne la valeur associee a la cle si elle existe, ou defaut si la cle est absente. C est tres utile pour le comptage : int count = map.getOrDefault(mot, 0); map.put(mot, count + 1); initialise le compteur a 0 si le mot n a jamais ete vu, puis l incremente. Cela evite de tester containsKey() separement et simplifie le code.',
        6
    FROM quizzes qz WHERE qz.title = 'Quiz - HashMap'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Elle modifie la valeur par defaut de toutes les cles', false, 1 FROM q
UNION ALL SELECT q.id, 'Elle retourne la valeur si la cle existe, sinon la valeur par defaut', true, 2 FROM q
UNION ALL SELECT q.id, 'Elle supprime la cle si la valeur est nulle', false, 3 FROM q
UNION ALL SELECT q.id, 'Elle ajoute la cle uniquement si elle n existe pas encore', false, 4 FROM q;
