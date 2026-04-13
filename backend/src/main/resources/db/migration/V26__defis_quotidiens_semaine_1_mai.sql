-- V26: Defis quotidiens semaine du 1 au 7 mai 2026

-- Defi du 1 mai : Compte Bancaire (V25 exercice 1 - EASY)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-01', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'encapsulation-avancee' AND e.title = 'Compte Bancaire';

-- Defi du 2 mai : Produit avec Validation (V25 exercice 2 - MEDIUM)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-02', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'encapsulation-avancee' AND e.title = 'Produit avec Validation';

-- Defi du 3 mai : Etudiant avec Notes (V25 exercice 3 - HARD)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-03', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'encapsulation-avancee' AND e.title = 'Etudiant avec Notes';

-- Defi du 4 mai : Formes Geometriques (V22 exercice 1 - revision abstraites)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-04', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'classes-abstraites-interfaces' AND e.title = 'Formes Geometriques';

-- Defi du 5 mai : Catalogue Media (V22 exercice 2 - revision interfaces)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-05', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'classes-abstraites-interfaces' AND e.title = 'Catalogue Media';

-- Defi du 6 mai : Salaires Employes (V20 exercice 2 - revision heritage)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-06', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'heritage-polymorphisme' AND e.title = 'Salaires Employes';

-- Defi du 7 mai : Vehicules et Interface Rechargeable (V22 exercice 3 - revision HARD)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-05-07', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'classes-abstraites-interfaces' AND e.title = 'Vehicules et Interface Rechargeable';
