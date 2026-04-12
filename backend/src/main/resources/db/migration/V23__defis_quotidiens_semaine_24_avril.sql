-- V23: Defis quotidiens semaine du 24 au 30 avril 2026

-- Defi du 24 avril : Formes Geometriques (V22 exercice 1 - EASY)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-24', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'classes-abstraites-interfaces' AND e.title = 'Formes Geometriques';

-- Defi du 25 avril : Catalogue Media (V22 exercice 2 - MEDIUM)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-25', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'classes-abstraites-interfaces' AND e.title = 'Catalogue Media';

-- Defi du 26 avril : Vehicules et Interface Rechargeable (V22 exercice 3 - HARD)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-26', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'classes-abstraites-interfaces' AND e.title = 'Vehicules et Interface Rechargeable';

-- Defi du 27 avril : Classe Personne (V18 exercice 1 - revision classes)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-27', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'classes-et-objets' AND e.title = 'Classe Personne';

-- Defi du 28 avril : Gestion de livres (V18 exercice 3 - revision encapsulation)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-28', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'classes-et-objets' AND e.title = 'Gestion de livres';

-- Defi du 29 avril : Salaires Employes (V20 exercice 2 - revision heritage)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-29', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'heritage-polymorphisme' AND e.title = 'Salaires Employes';

-- Defi du 30 avril : Zoo Polymorphe (V20 exercice 3 - revision polymorphisme)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-04-30', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'heritage-polymorphisme' AND e.title = 'Zoo Polymorphe';
