-- V50: Defis quotidiens semaine du 12 au 18 juin 2026

-- Defi du 12 juin : Recherche de Contact (V47 exercice 1 - EASY Optional)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-12', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'optional-streams-securises' AND e.title = 'Recherche de Contact';

-- Defi du 13 juin : Analyseur de Types (V49 exercice 1 - EASY multi-catch)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-13', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'multi-catch-propagation' AND e.title = 'Analyseur de Types';

-- Defi du 14 juin : Parseur avec Optional (V47 exercice 2 - MEDIUM Optional)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-14', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'optional-streams-securises' AND e.title = 'Parseur avec Optional';

-- Defi du 15 juin : Convertisseur avec Propagation (V49 exercice 2 - MEDIUM multi-catch)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-15', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'multi-catch-propagation' AND e.title = 'Convertisseur avec Propagation';

-- Defi du 16 juin : Gestionnaire de Configuration (V47 exercice 3 - HARD Optional)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-16', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'optional-streams-securises' AND e.title = 'Gestionnaire de Configuration';

-- Defi du 17 juin : Ressource Simulee (V49 exercice 3 - HARD try-with-resources)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-17', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'multi-catch-propagation' AND e.title = 'Ressource Simulee';

-- Defi du 18 juin : Systeme de Validation (V44 exercice 3 - revision HARD exceptions perso)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-18', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'exceptions-personnalisees' AND e.title = 'Systeme de Validation';
