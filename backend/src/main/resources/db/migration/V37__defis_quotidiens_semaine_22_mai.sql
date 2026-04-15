-- V37: Defis quotidiens semaine du 22 au 28 mai 2026

-- Defi du 22 mai : Invites Uniques (V36 exercice 1 - EASY HashSet)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-22', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'hashset' AND e.title = 'Invites Uniques';

-- Defi du 23 mai : Membres Communs (V36 exercice 2 - MEDIUM HashSet)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-23', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'hashset' AND e.title = 'Membres Communs';

-- Defi du 24 mai : Mots Importants (V36 exercice 3 - HARD HashSet)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-24', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'hashset' AND e.title = 'Mots Importants';

-- Defi du 25 mai : Filtrer les Nombres Pairs (V31 exercice 2 - revision ArrayList MEDIUM)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-25', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'arraylist' AND e.title = 'Filtrer les Nombres Pairs';

-- Defi du 26 mai : Inventaire de Magasin (V33 exercice 3 - revision HashMap HARD)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-26', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'hashmap' AND e.title = 'Inventaire de Magasin';

-- Defi du 27 mai : Gestionnaire de Taches (V31 exercice 3 - revision ArrayList HARD)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-27', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'arraylist' AND e.title = 'Gestionnaire de Taches';

-- Defi du 28 mai : Compteur de Votes (V33 exercice 2 - revision HashMap MEDIUM)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-28', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'hashmap' AND e.title = 'Compteur de Votes';
