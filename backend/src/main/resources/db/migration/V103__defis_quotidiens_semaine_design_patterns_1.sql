-- V103: Defis quotidiens semaine 28 aout - 3 septembre 2025 - revision Singleton et Observer Pattern

-- Jeudi 28 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-28', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'singleton-factory' AND e.title = 'Logger Singleton';

-- Vendredi 29 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-29', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'observer-pattern' AND e.title = 'EventBus avec Lambdas';

-- Samedi 30 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-30', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'singleton-factory' AND e.title = 'ShapeFactory - Formes Geometriques';

-- Dimanche 31 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-31', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'observer-pattern' AND e.title = 'StockMarket - Cours des Actions';

-- Lundi 1 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-01', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'singleton-factory' AND e.title = 'ShapeFactory - Formes Geometriques';

-- Mardi 2 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-02', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'observer-pattern' AND e.title = 'NewsAgency - Agence de Presse';

-- Mercredi 3 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-03', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'singleton-factory' AND e.title = 'InventoryManager Singleton et ProductFactory';
