-- V3: Corrections de schema et de donnees de badges

-- Fix quizzes: chapter_id est NOT NULL dans V1 mais l'entite Quiz utilise lesson_id
ALTER TABLE quizzes ALTER COLUMN chapter_id DROP NOT NULL;
ALTER TABLE quizzes DROP CONSTRAINT IF EXISTS quizzes_chapter_id_key;

-- Fix daily_challenges: anciennes colonnes V1 NOT NULL incompatibles avec la nouvelle entite
ALTER TABLE daily_challenges ALTER COLUMN challenge_date DROP NOT NULL;
ALTER TABLE daily_challenges ALTER COLUMN exercise_id DROP NOT NULL;

-- Fix quiz_questions: question_text est NOT NULL dans V1 mais l'entite utilise 'text'
ALTER TABLE quiz_questions ALTER COLUMN question_text DROP NOT NULL;

-- Fix badges: 'XP_EARNED' n'existe pas dans l'enum BadgeCriteria (doit etre XP_TOTAL)
UPDATE badges SET criteria_type = 'XP_TOTAL' WHERE criteria_type = 'XP_EARNED';

-- Ajout de badges supplementaires
INSERT INTO badges (name, description, criteria_type, criteria_value)
SELECT v.name, v.description, v.criteria_type, v.criteria_value
FROM (VALUES
    ('Explorateur', 'Atteignez le niveau 2', 'LEVEL_REACHED', 2),
    ('Assidu', 'Maintenez une serie de 3 jours', 'STREAK_DAYS', 3),
    ('Expert', 'Gagnez 500 XP au total', 'XP_TOTAL', 500),
    ('Quiz Master', 'Reussissez 3 quiz', 'QUIZZES_PASSED', 3),
    ('Completioniste', 'Completez 5 exercices', 'EXERCISES_COMPLETED', 5)
) AS v(name, description, criteria_type, criteria_value)
WHERE NOT EXISTS (SELECT 1 FROM badges b WHERE b.name = v.name);
