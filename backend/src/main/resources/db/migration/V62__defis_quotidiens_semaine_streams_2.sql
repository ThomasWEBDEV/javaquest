-- V62: Defis quotidiens Streams Java - Semaine 3-9 juillet 2025

-- Defi du 3 juillet : Mots Cles Extraits (V58 exercice 2 - MEDIUM streams-avances)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-03', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'streams-avances' AND e.title = 'Mots Cles Extraits';

-- Defi du 4 juillet : Pagination de Resultats (V58 exercice 3 - HARD streams-avances)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-04', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'streams-avances' AND e.title = 'Pagination de Resultats';

-- Defi du 5 juillet : Grouper par Premiere Lettre (V60 exercice 1 - EASY collectors-avances)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-05', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'collectors-avances' AND e.title = 'Grouper par Premiere Lettre';

-- Defi du 6 juillet : Bulletin Scolaire (V60 exercice 2 - MEDIUM collectors-avances)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-06', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'collectors-avances' AND e.title = 'Bulletin Scolaire';

-- Defi du 7 juillet : Catalogue de Langages (V60 exercice 3 - HARD collectors-avances)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-07', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'collectors-avances' AND e.title = 'Catalogue de Langages';

-- Defi du 8 juillet : Filtrage de Notes (V54 exercice 1 - revision EASY introduction-streams)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-08', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'introduction-streams' AND e.title = 'Filtrage de Notes';

-- Defi du 9 juillet : Calcul de Panier (V56 exercice 3 - revision HARD streams-reduction-agregation)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-09', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'streams-reduction-agregation' AND e.title = 'Calcul de Panier';
