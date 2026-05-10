-- V117: Defis quotidiens semaine 18-24 mai 2026 - revision Java Moderne (Sealed Classes + Text Blocks)

-- Lundi 18 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-18', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'text-blocks-var' AND e.title = 'Text Block JSON Simple';

-- Mardi 19 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-19', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'sealed-classes' AND e.title = 'Resultat Sealed - Parsing Securise';

-- Mercredi 20 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-20', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'text-blocks-var' AND e.title = 'Template HTML avec Text Blocks';

-- Jeudi 21 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-21', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'records-java' AND e.title = 'Record Produit avec validation';

-- Vendredi 22 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-22', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'sealed-classes' AND e.title = 'Mini Evaluateur d Expressions Sealed';

-- Samedi 23 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-23', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'text-blocks-var' AND e.title = 'Generateur de Rapport avec var';

-- Dimanche 24 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-24', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'pattern-matching' AND e.title = 'Switch Pattern Matching - Evaluateur de valeurs';
