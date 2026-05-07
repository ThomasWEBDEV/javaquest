-- V105: Defis quotidiens semaine 11-17 septembre 2025 - revision generale Design Patterns

-- Jeudi 11 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-11', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'singleton-factory' AND e.title = 'Logger Singleton';

-- Vendredi 12 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-12', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'observer-pattern' AND e.title = 'StockMarket - Cours des Actions';

-- Samedi 13 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-13', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'strategy-pattern' AND e.title = 'TextFormatter - Formatage Multi-Strategies';

-- Dimanche 14 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-14', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'builder-pattern' AND e.title = 'QueryBuilder - Constructeur de Requetes SQL';

-- Lundi 15 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-15', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'observer-pattern' AND e.title = 'NewsAgency - Agence de Presse';

-- Mardi 16 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-16', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'builder-pattern' AND e.title = 'QueryBuilder - Constructeur de Requetes SQL';

-- Mercredi 17 septembre
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-09-17', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'singleton-factory' AND e.title = 'InventoryManager Singleton et ProductFactory';
