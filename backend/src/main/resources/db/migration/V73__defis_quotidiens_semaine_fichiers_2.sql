-- V73: Defis quotidiens semaine 24-30 juillet 2025 - revision gestion des repertoires

-- Jeudi 24 juillet
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-24', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'gestion-repertoires' AND e.title = 'Lister un Repertoire';

-- Vendredi 25 juillet
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-25', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'ecriture-fichiers' AND e.title = 'Journal de Bord';

-- Samedi 26 juillet
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-26', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'gestion-repertoires' AND e.title = 'Compter par Type';

-- Dimanche 27 juillet
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-27', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'ecriture-fichiers' AND e.title = 'Rapport de Ventes';

-- Lundi 28 juillet
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-28', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'gestion-repertoires' AND e.title = 'Taille Totale';

-- Mardi 29 juillet
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-29', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'lecture-fichiers' AND e.title = 'Filtrage de Lignes';

-- Mercredi 30 juillet
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-30', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'ecriture-fichiers' AND e.title = 'Systeme de Log';
