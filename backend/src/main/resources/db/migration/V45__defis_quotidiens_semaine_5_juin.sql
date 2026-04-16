-- V45: Defis quotidiens semaine du 5 au 11 juin 2026

-- Defi du 5 juin : Division Securisee (V42 exercice 1 - EASY try/catch)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-05', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'try-catch-finally' AND e.title = 'Division Securisee';

-- Defi du 6 juin : NoteInvalideException (V44 exercice 1 - EASY exception perso)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-06', e.id, 100
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'exceptions-personnalisees' AND e.title = 'NoteInvalideException';

-- Defi du 7 juin : Parseur Securise (V42 exercice 2 - MEDIUM try/catch)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-07', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'try-catch-finally' AND e.title = 'Parseur Securise';

-- Defi du 8 juin : SoldeInsuffisantException (V44 exercice 2 - MEDIUM exception perso)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-08', e.id, 150
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'exceptions-personnalisees' AND e.title = 'SoldeInsuffisantException';

-- Defi du 9 juin : Calculatrice Robuste (V42 exercice 3 - HARD try/catch)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-09', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'try-catch-finally' AND e.title = 'Calculatrice Robuste';

-- Defi du 10 juin : Systeme de Validation (V44 exercice 3 - HARD exception perso)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-10', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'exceptions-personnalisees' AND e.title = 'Systeme de Validation';

-- Defi du 11 juin : Mots Uniques Tries (V39 exercice 3 - revision TreeSet HARD)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2026-06-11', e.id, 200
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'treemap-treeset' AND e.title = 'Mots Uniques Tries';
