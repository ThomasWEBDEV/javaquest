-- V29: Defis quotidiens semaine du 8 au 14 mai 2026

-- Defi du 8 mai : Compteur Statique (V28 exercice 1 - EASY)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-08', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'concepts-avances' AND e.title = 'Compteur Statique';

-- Defi du 9 mai : Jours de la Semaine (V28 exercice 2 - MEDIUM)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-09', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'concepts-avances' AND e.title = 'Jours de la Semaine';

-- Defi du 10 mai : Point avec equals et toString (V28 exercice 3 - HARD)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-10', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'concepts-avances' AND e.title = 'Point avec equals et toString';

-- Defi du 11 mai : Compte Bancaire (V25 exercice 1 - revision encapsulation)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-11', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'encapsulation-avancee' AND e.title = 'Compte Bancaire';

-- Defi du 12 mai : Produit avec Validation (V25 exercice 2 - revision setters)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-12', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'encapsulation-avancee' AND e.title = 'Produit avec Validation';

-- Defi du 13 mai : Etudiant avec Notes (V25 exercice 3 - revision hard)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-13', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'encapsulation-avancee' AND e.title = 'Etudiant avec Notes';

-- Defi du 14 mai : Zoo Polymorphe (V20 exercice 3 - revision POO generale)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-14', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'heritage-polymorphisme' AND e.title = 'Zoo Polymorphe';
