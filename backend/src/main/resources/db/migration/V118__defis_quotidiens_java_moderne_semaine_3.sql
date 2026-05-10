-- V118: Defis quotidiens semaine 25-31 mai 2026 - revision complete Java Moderne

-- Lundi 25 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-25', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'sealed-classes' AND e.title = 'Formes Geometriques Sealed';

-- Mardi 26 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-26', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'text-blocks-var' AND e.title = 'Template HTML avec Text Blocks';

-- Mercredi 27 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-27', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'records-java' AND e.title = 'Records et Stream - Catalogue de livres';

-- Jeudi 28 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-28', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'sealed-classes' AND e.title = 'Resultat Sealed - Parsing Securise';

-- Vendredi 29 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-29', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'sealed-classes' AND e.title = 'Mini Evaluateur d Expressions Sealed';

-- Samedi 30 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-30', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'text-blocks-var' AND e.title = 'Generateur de Rapport avec var';

-- Dimanche 31 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-31', e.id, 45
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'pattern-matching' AND e.title = 'Switch Pattern Matching - Evaluateur de valeurs';
