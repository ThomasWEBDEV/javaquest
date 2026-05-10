-- V116: Defis quotidiens semaine 11-17 mai 2026 - revision Java Moderne (Records + Pattern Matching)

-- Lundi 11 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-11', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'records-java' AND e.title = 'Record Couleur RGB';

-- Mardi 12 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-12', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'pattern-matching' AND e.title = 'Switch Expression - Jours de la semaine';

-- Mercredi 13 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-13', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'records-java' AND e.title = 'Record Produit avec validation';

-- Jeudi 14 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-14', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'pattern-matching' AND e.title = 'Pattern Matching instanceof - Formateur de valeurs';

-- Vendredi 15 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-15', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'sealed-classes' AND e.title = 'Formes Geometriques Sealed';

-- Samedi 16 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-16', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'records-java' AND e.title = 'Records et Stream - Catalogue de livres';

-- Dimanche 17 mai
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-17', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'pattern-matching' AND e.title = 'Switch Pattern Matching - Evaluateur de valeurs';
