-- V83: Defis quotidiens semaine 7-13 aout 2025 - revision threads et Runnable

-- Jeudi 7 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-07', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'threads-runnable' AND e.title = 'Mon Premier Thread';

-- Vendredi 8 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-08', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'threads-runnable' AND e.title = 'Compteur Parallele';

-- Samedi 9 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-09', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'threads-runnable' AND e.title = 'Mon Premier Thread';

-- Dimanche 10 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-10', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'threads-runnable' AND e.title = 'Calcul en Parallele';

-- Lundi 11 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-11', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'threads-runnable' AND e.title = 'Compteur Parallele';

-- Mardi 12 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-12', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'threads-runnable' AND e.title = 'Calcul en Parallele';

-- Mercredi 13 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-13', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'threads-runnable' AND e.title = 'Calcul en Parallele';
