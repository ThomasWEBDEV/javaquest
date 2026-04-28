-- V94: Defis quotidiens semaine 18-24 septembre 2025 - revision Architecture MVC Controllers

-- Jeudi 18 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-18', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-controllers' AND e.title = 'MealController - Lister et Ajouter';

-- Vendredi 19 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-19', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-controllers' AND e.title = 'Application Complete - 2 Controllers';

-- Samedi 20 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-20', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-controllers' AND e.title = 'MealController - Lister et Ajouter';

-- Dimanche 21 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-21', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-controllers' AND e.title = 'BaseRepository avec Generiques';

-- Lundi 22 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-22', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-controllers' AND e.title = 'Application Complete - 2 Controllers';

-- Mardi 23 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-23', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-controllers' AND e.title = 'BaseRepository avec Generiques';

-- Mercredi 24 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-24', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-controllers' AND e.title = 'BaseRepository avec Generiques';
