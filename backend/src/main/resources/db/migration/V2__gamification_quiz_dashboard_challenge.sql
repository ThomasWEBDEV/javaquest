-- User Progress (Gamification)
CREATE TABLE user_progress (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    total_xp INTEGER NOT NULL DEFAULT 0,
    current_level INTEGER NOT NULL DEFAULT 1,
    current_streak INTEGER NOT NULL DEFAULT 0,
    longest_streak INTEGER NOT NULL DEFAULT 0,
    last_activity_date DATE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Badges
CREATE TABLE badges (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT NOT NULL,
    icon_url VARCHAR(255),
    criteria_type VARCHAR(50) NOT NULL,
    criteria_value INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- User Badges
CREATE TABLE user_badges (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    badge_id BIGINT NOT NULL REFERENCES badges(id) ON DELETE CASCADE,
    earned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, badge_id)
);

-- Quizzes
CREATE TABLE quizzes (
    id BIGSERIAL PRIMARY KEY,
    lesson_id BIGINT REFERENCES lessons(id) ON DELETE SET NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    time_limit_seconds INTEGER,
    passing_score INTEGER NOT NULL DEFAULT 70,
    xp_reward INTEGER NOT NULL DEFAULT 100,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Questions
CREATE TABLE questions (
    id BIGSERIAL PRIMARY KEY,
    quiz_id BIGINT NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
    text TEXT NOT NULL,
    question_type VARCHAR(30) NOT NULL DEFAULT 'SINGLE_CHOICE',
    code_snippet TEXT,
    explanation TEXT,
    order_index INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Answers
CREATE TABLE answers (
    id BIGSERIAL PRIMARY KEY,
    question_id BIGINT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    text TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL DEFAULT FALSE,
    order_index INTEGER NOT NULL
);

-- User Exercise Progress
CREATE TABLE user_exercise_progress (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    exercise_id BIGINT NOT NULL REFERENCES exercises(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'NOT_STARTED',
    attempts_count INTEGER NOT NULL DEFAULT 0,
    last_code TEXT,
    completed_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, exercise_id)
);

-- User Quiz Attempts
CREATE TABLE user_quiz_attempts (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    quiz_id BIGINT NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
    score INTEGER NOT NULL,
    correct_answers INTEGER NOT NULL,
    total_questions INTEGER NOT NULL,
    passed BOOLEAN NOT NULL,
    xp_earned INTEGER NOT NULL DEFAULT 0,
    time_spent_seconds INTEGER,
    attempted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Daily Challenges
CREATE TABLE daily_challenges (
    id BIGSERIAL PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    starter_code TEXT,
    solution_code TEXT NOT NULL,
    test_code TEXT NOT NULL,
    hints TEXT,
    difficulty VARCHAR(20) NOT NULL DEFAULT 'MEDIUM',
    xp_reward INTEGER NOT NULL DEFAULT 100,
    bonus_xp INTEGER NOT NULL DEFAULT 50,
    time_limit_minutes INTEGER,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- User Daily Challenges
CREATE TABLE user_daily_challenges (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    challenge_id BIGINT NOT NULL REFERENCES daily_challenges(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'STARTED',
    submitted_code TEXT,
    attempts_count INTEGER NOT NULL DEFAULT 0,
    xp_earned INTEGER NOT NULL DEFAULT 0,
    time_spent_seconds INTEGER,
    started_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    UNIQUE(user_id, challenge_id)
);

-- Index pour performances
CREATE INDEX idx_user_progress_user_id ON user_progress(user_id);
CREATE INDEX idx_user_badges_user_id ON user_badges(user_id);
CREATE INDEX idx_questions_quiz_id ON questions(quiz_id);
CREATE INDEX idx_answers_question_id ON answers(question_id);
CREATE INDEX idx_user_exercise_progress_user_id ON user_exercise_progress(user_id);
CREATE INDEX idx_user_quiz_attempts_user_id ON user_quiz_attempts(user_id);
CREATE INDEX idx_daily_challenges_date ON daily_challenges(date);
CREATE INDEX idx_user_daily_challenges_user_id ON user_daily_challenges(user_id);

-- Badges initiaux
INSERT INTO badges (name, description, criteria_type, criteria_value) VALUES
('Premier Pas', 'Gagnez vos premiers 100 XP', 'XP_TOTAL', 100),
('Apprenti', 'Atteignez le niveau 5', 'LEVEL_REACHED', 5),
('Studieux', 'Completez 10 exercices', 'EXERCISES_COMPLETED', 10),
('Quiz Master', 'Reussissez 5 quiz', 'QUIZZES_PASSED', 5),
('En Feu', 'Maintenez une serie de 7 jours', 'STREAK_DAYS', 7),
('Expert', 'Atteignez le niveau 10', 'LEVEL_REACHED', 10),
('Marathonien', 'Completez 50 exercices', 'EXERCISES_COMPLETED', 50),
('Legende', 'Maintenez une serie de 30 jours', 'STREAK_DAYS', 30);
