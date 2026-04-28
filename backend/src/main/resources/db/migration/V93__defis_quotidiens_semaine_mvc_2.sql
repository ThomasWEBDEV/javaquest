-- V93: Defis quotidiens semaine 11-17 septembre 2025 - revision Pattern Repository

-- Jeudi 11 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-11', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-repository' AND e.title = 'MealRepository - Ajouter et Lister';

-- Vendredi 12 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-12', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-repository' AND e.title = 'MealRepository - Recherche et Suppression';

-- Samedi 13 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-13', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-repository' AND e.title = 'MealRepository - Ajouter et Lister';

-- Dimanche 14 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-14', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-repository' AND e.title = 'CustomerRepository Complet';

-- Lundi 15 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-15', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-repository' AND e.title = 'MealRepository - Recherche et Suppression';

-- Mardi 16 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-16', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-repository' AND e.title = 'CustomerRepository Complet';

-- Mercredi 17 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-17', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-repository' AND e.title = 'CustomerRepository Complet';
