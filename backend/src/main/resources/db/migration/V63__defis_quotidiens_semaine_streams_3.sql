-- V63: Defis quotidiens Streams Java - Semaine 10-16 juillet 2025

-- Defi du 10 juillet : Villes Uniques (V58 exercice 1 - revision EASY streams-avances)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-10', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'streams-avances' AND e.title = 'Villes Uniques';

-- Defi du 11 juillet : Mots Cles Extraits (V58 exercice 2 - revision MEDIUM streams-avances)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-11', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'streams-avances' AND e.title = 'Mots Cles Extraits';

-- Defi du 12 juillet : Analyse de Prix (V56 exercice 2 - revision MEDIUM streams-reduction-agregation)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-12', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'streams-reduction-agregation' AND e.title = 'Analyse de Prix';

-- Defi du 13 juillet : Bulletin Scolaire (V60 exercice 2 - revision MEDIUM collectors-avances)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-13', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'collectors-avances' AND e.title = 'Bulletin Scolaire';

-- Defi du 14 juillet : Grouper par Premiere Lettre (V60 exercice 1 - revision EASY collectors-avances)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-14', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'collectors-avances' AND e.title = 'Grouper par Premiere Lettre';

-- Defi du 15 juillet : Pagination de Resultats (V58 exercice 3 - revision HARD streams-avances)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-15', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'streams-avances' AND e.title = 'Pagination de Resultats';

-- Defi du 16 juillet : Catalogue de Langages (V60 exercice 3 - revision HARD collectors-avances)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-16', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'collectors-avances' AND e.title = 'Catalogue de Langages';
