-- V104: Defis quotidiens semaine 4-10 septembre 2025 - revision Strategy Pattern et Builder Pattern

-- Jeudi 4 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-04', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'strategy-pattern' AND e.title = 'DiscountCalculator avec Lambdas';

-- Vendredi 5 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-05', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'builder-pattern' AND e.title = 'Pizza Builder';

-- Samedi 6 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-06', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'strategy-pattern' AND e.title = 'ShoppingCart - Modes de Paiement';

-- Dimanche 7 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-07', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'builder-pattern' AND e.title = 'Computer Builder - Configuration PC';

-- Lundi 8 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-08', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'strategy-pattern' AND e.title = 'ShoppingCart - Modes de Paiement';

-- Mardi 9 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-09', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'builder-pattern' AND e.title = 'Computer Builder - Configuration PC';

-- Mercredi 10 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-10', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'strategy-pattern' AND e.title = 'TextFormatter - Formatage Multi-Strategies';
