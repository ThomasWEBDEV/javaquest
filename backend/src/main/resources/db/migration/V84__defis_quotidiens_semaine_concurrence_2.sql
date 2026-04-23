-- V84: Defis quotidiens semaine 14-20 aout 2025 - revision synchronized, atomic et ExecutorService

-- Jeudi 14 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-14', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'synchronized-atomic' AND e.title = 'Compteur Thread-Safe';

-- Vendredi 15 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-15', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'executorservice-pool' AND e.title = 'Mon Premier Pool';

-- Samedi 16 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-16', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'synchronized-atomic' AND e.title = 'Banque Thread-Safe';

-- Dimanche 17 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-17', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'executorservice-pool' AND e.title = 'Traitement Parallele de Donnees';

-- Lundi 18 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-18', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'synchronized-atomic' AND e.title = 'Drapeau volatile';

-- Mardi 19 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-19', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'executorservice-pool' AND e.title = 'Pool et Compteur Atomique';

-- Mercredi 20 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-20', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'executorservice-pool' AND e.title = 'Pool et Compteur Atomique';
