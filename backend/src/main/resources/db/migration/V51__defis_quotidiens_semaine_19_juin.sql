-- V51: Defis quotidiens semaine du 19 au 25 juin 2026

-- Defi du 19 juin : NoteInvalideException (V44 exercice 1 - revision EASY exceptions perso)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-19', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'exceptions-personnalisees' AND e.title = 'NoteInvalideException';

-- Defi du 20 juin : Recherche de Contact (V47 exercice 1 - revision EASY Optional)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-20', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'optional-streams-securises' AND e.title = 'Recherche de Contact';

-- Defi du 21 juin : SoldeInsuffisantException (V44 exercice 2 - revision MEDIUM exceptions perso)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-21', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'exceptions-personnalisees' AND e.title = 'SoldeInsuffisantException';

-- Defi du 22 juin : Parseur avec Optional (V47 exercice 2 - revision MEDIUM Optional)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-22', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'optional-streams-securises' AND e.title = 'Parseur avec Optional';

-- Defi du 23 juin : Calculatrice Robuste (V42 exercice 3 - revision HARD try/catch)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-23', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'try-catch-finally' AND e.title = 'Calculatrice Robuste';

-- Defi du 24 juin : Gestionnaire de Configuration (V47 exercice 3 - revision HARD Optional)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-24', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'optional-streams-securises' AND e.title = 'Gestionnaire de Configuration';

-- Defi du 25 juin : Ressource Simulee (V49 exercice 3 - revision HARD try-with-resources)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-25', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'multi-catch-propagation' AND e.title = 'Ressource Simulee';
