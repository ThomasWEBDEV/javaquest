-- V92: Defis quotidiens semaine 4-10 septembre 2025 - revision Modelisation MVC

-- Jeudi 4 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-04', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-modeles' AND e.title = 'La Classe Meal';

-- Vendredi 5 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-05', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-modeles' AND e.title = 'La Classe Customer';

-- Samedi 6 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-06', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-modeles' AND e.title = 'La Classe Meal';

-- Dimanche 7 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-07', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-modeles' AND e.title = 'Commande - Lier Meal et Customer';

-- Lundi 8 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-08', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-modeles' AND e.title = 'La Classe Customer';

-- Mardi 9 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-09', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-modeles' AND e.title = 'Commande - Lier Meal et Customer';

-- Mercredi 10 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-10', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'mvc-modeles' AND e.title = 'Commande - Lier Meal et Customer';
