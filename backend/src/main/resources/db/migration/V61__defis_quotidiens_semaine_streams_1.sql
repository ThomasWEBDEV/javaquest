-- V61: Defis quotidiens Streams Java - Semaine 26 juin - 2 juillet 2025

-- Defi du 26 juin : Filtrage de Notes (V54 exercice 1 - EASY introduction-streams)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-06-26', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'introduction-streams' AND e.title = 'Filtrage de Notes';

-- Defi du 27 juin : Transformation de Prenoms (V54 exercice 2 - MEDIUM introduction-streams)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-06-27', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'introduction-streams' AND e.title = 'Transformation de Prenoms';

-- Defi du 28 juin : Analyse de Produits (V54 exercice 3 - HARD introduction-streams)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-06-28', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'introduction-streams' AND e.title = 'Analyse de Produits';

-- Defi du 29 juin : Statistiques de Notes (V56 exercice 1 - EASY streams-reduction-agregation)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-06-29', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'streams-reduction-agregation' AND e.title = 'Statistiques de Notes';

-- Defi du 30 juin : Analyse de Prix (V56 exercice 2 - MEDIUM streams-reduction-agregation)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-06-30', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'streams-reduction-agregation' AND e.title = 'Analyse de Prix';

-- Defi du 1 juillet : Calcul de Panier (V56 exercice 3 - HARD streams-reduction-agregation)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-01', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'streams-reduction-agregation' AND e.title = 'Calcul de Panier';

-- Defi du 2 juillet : Villes Uniques (V58 exercice 1 - EASY streams-avances)
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-02', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'streams-avances' AND e.title = 'Villes Uniques';
