-- V72: Defis quotidiens semaine 17-23 juillet 2025 - revision lecture et ecriture de fichiers

-- Jeudi 17 juillet
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-17', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'lecture-fichiers' AND e.title = 'Mon Premier Fichier';

-- Vendredi 18 juillet
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-18', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'ecriture-fichiers' AND e.title = 'Journal de Bord';

-- Samedi 19 juillet
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-19', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'lecture-fichiers' AND e.title = 'Filtrage de Lignes';

-- Dimanche 20 juillet
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-20', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'ecriture-fichiers' AND e.title = 'Rapport de Ventes';

-- Lundi 21 juillet
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-21', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'lecture-fichiers' AND e.title = 'Statistiques de Fichier';

-- Mardi 22 juillet
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-22', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'ecriture-fichiers' AND e.title = 'Systeme de Log';

-- Mercredi 23 juillet
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-23', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'ecriture-fichiers' AND e.title = 'Systeme de Log';
