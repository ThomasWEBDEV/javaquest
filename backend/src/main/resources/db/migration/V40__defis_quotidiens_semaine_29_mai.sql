-- V40: Defis quotidiens semaine du 29 mai au 4 juin 2026

-- Defi du 29 mai : Dictionnaire Trie (V39 exercice 1 - EASY TreeMap)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-29', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'treemap-treeset' AND e.title = 'Dictionnaire Trie';

-- Defi du 30 mai : Classement des Etudiants (V39 exercice 2 - MEDIUM TreeMap)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-30', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'treemap-treeset' AND e.title = 'Classement des Etudiants';

-- Defi du 31 mai : Mots Uniques Tries (V39 exercice 3 - HARD TreeSet)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-31', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'treemap-treeset' AND e.title = 'Mots Uniques Tries';

-- Defi du 1 juin : Invites Uniques (V36 exercice 1 - revision HashSet EASY)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-01', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'hashset' AND e.title = 'Invites Uniques';

-- Defi du 2 juin : Annuaire Telephonique (V33 exercice 1 - revision HashMap EASY)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-02', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'hashmap' AND e.title = 'Annuaire Telephonique';

-- Defi du 3 juin : Membres Communs (V36 exercice 2 - revision HashSet MEDIUM)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-03', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'hashset' AND e.title = 'Membres Communs';

-- Defi du 4 juin : Classement des Etudiants (V39 exercice 2 - revision TreeMap MEDIUM)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-04', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'treemap-treeset' AND e.title = 'Classement des Etudiants';
