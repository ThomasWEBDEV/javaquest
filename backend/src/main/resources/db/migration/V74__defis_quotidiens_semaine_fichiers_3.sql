-- V74: Defis quotidiens semaine 31 juillet - 6 aout 2025 - revision serialisation

-- Jeudi 31 juillet
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-07-31', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'serialisation-java' AND e.title = 'Personne Serialisable';

-- Vendredi 1 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-01', e.id, 20
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'lecture-fichiers' AND e.title = 'Mon Premier Fichier';

-- Samedi 2 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-02', e.id, 30
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'serialisation-java' AND e.title = 'Liste de Produits';

-- Dimanche 3 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-03', e.id, 25
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'gestion-repertoires' AND e.title = 'Compter par Type';

-- Lundi 4 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-04', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'serialisation-java' AND e.title = 'Champ Confidentiel';

-- Mardi 5 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-05', e.id, 35
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'gestion-repertoires' AND e.title = 'Taille Totale';

-- Mercredi 6 aout
INSERT INTO daily_challenges (challenge_date, exercise_id, bonus_xp)
SELECT '2025-08-06', e.id, 40
FROM exercises e
INNER JOIN lessons l ON e.lesson_id = l.id
WHERE l.slug = 'lecture-fichiers' AND e.title = 'Statistiques de Fichier';
