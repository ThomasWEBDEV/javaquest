-- V52: Correction schema daily_challenges pour correspondre a l entite DailyChallenge

-- Ajouter les colonnes manquantes (avec valeur par defaut temporaire pour les lignes existantes)
ALTER TABLE daily_challenges
    ADD COLUMN IF NOT EXISTS date DATE,
    ADD COLUMN IF NOT EXISTS title VARCHAR(100),
    ADD COLUMN IF NOT EXISTS description TEXT,
    ADD COLUMN IF NOT EXISTS solution_code TEXT,
    ADD COLUMN IF NOT EXISTS test_code TEXT,
    ADD COLUMN IF NOT EXISTS difficulty VARCHAR(20) DEFAULT 'MEDIUM',
    ADD COLUMN IF NOT EXISTS xp_reward INTEGER DEFAULT 100;

-- Copier challenge_date vers date pour les lignes existantes
UPDATE daily_challenges
SET date = challenge_date
WHERE date IS NULL AND challenge_date IS NOT NULL;

-- Remplir les colonnes obligatoires pour les lignes existantes
UPDATE daily_challenges
SET
    title = COALESCE(title, 'Defi du ' || TO_CHAR(date, 'DD/MM/YYYY')),
    description = COALESCE(description, 'Completez cet exercice pour gagner des XP supplementaires.'),
    solution_code = COALESCE(solution_code, '// Voir exercice associe'),
    test_code = COALESCE(test_code, 'true'),
    difficulty = COALESCE(difficulty, 'MEDIUM'),
    xp_reward = COALESCE(xp_reward, bonus_xp)
WHERE title IS NULL OR description IS NULL OR solution_code IS NULL OR test_code IS NULL;

-- Ajouter la contrainte unique sur date maintenant que toutes les lignes ont une valeur
CREATE UNIQUE INDEX IF NOT EXISTS daily_challenges_date_key ON daily_challenges (date) WHERE date IS NOT NULL;
