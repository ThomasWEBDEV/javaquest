-- V85: Defis quotidiens semaine 21-27 aout 2025 - revision Callable, Future et revision generale

-- Jeudi 21 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-21', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'callable-future' AND e.title = 'Mon Premier Callable';

-- Vendredi 22 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-22', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'callable-future' AND e.title = 'Calcul Asynchrone';

-- Samedi 23 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-23', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'threads-runnable' AND e.title = 'Calcul en Parallele';

-- Dimanche 24 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-24', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'callable-future' AND e.title = 'Traitement avec invokeAll';

-- Lundi 25 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-25', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'callable-future' AND e.title = 'Calcul Asynchrone';

-- Mardi 26 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-26', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'callable-future' AND e.title = 'Traitement avec invokeAll';

-- Mercredi 27 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-27', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'callable-future' AND e.title = 'Traitement avec invokeAll';
