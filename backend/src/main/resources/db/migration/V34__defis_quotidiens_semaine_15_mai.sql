-- V34: Defis quotidiens semaine du 15 au 21 mai 2026

-- Defi du 15 mai : Liste de Courses (V31 exercice 1 - EASY ArrayList)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-15', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'arraylist' AND e.title = 'Liste de Courses';

-- Defi du 16 mai : Filtrer les Nombres Pairs (V31 exercice 2 - MEDIUM ArrayList)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-16', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'arraylist' AND e.title = 'Filtrer les Nombres Pairs';

-- Defi du 17 mai : Gestionnaire de Taches (V31 exercice 3 - HARD ArrayList)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-17', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'arraylist' AND e.title = 'Gestionnaire de Taches';

-- Defi du 18 mai : Annuaire Telephonique (V33 exercice 1 - EASY HashMap)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-18', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'hashmap' AND e.title = 'Annuaire Telephonique';

-- Defi du 19 mai : Compteur de Votes (V33 exercice 2 - MEDIUM HashMap)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-19', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'hashmap' AND e.title = 'Compteur de Votes';

-- Defi du 20 mai : Inventaire de Magasin (V33 exercice 3 - HARD HashMap)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-20', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'hashmap' AND e.title = 'Inventaire de Magasin';

-- Defi du 21 mai : Point avec equals et toString (V28 exercice 3 - revision POO)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-21', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'concepts-avances' AND e.title = 'Point avec equals et toString';
