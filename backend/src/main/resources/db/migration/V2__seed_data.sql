-- Donnees de demonstration JavaQuest

-- Chapitres
INSERT INTO chapters (title, slug, description, order_index, xp_reward, is_published) VALUES
('Introduction a Java', 'intro-java', 'Decouvrez les bases du langage Java', 1, 100, true),
('Variables et Types', 'variables-types', 'Apprenez a manipuler les donnees', 2, 150, true),
('Structures de Controle', 'structures-controle', 'Maitrisez les conditions et boucles', 3, 200, true);

-- Lecons Chapitre 1
INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward) VALUES
(1, 'Quest-ce que Java', 'quest-ce-que-java', 'Java est un langage oriente objet cree en 1995.', 1, 25),
(1, 'Installation', 'installation', 'Installez le JDK et un IDE comme IntelliJ.', 2, 25);

-- Lecons Chapitre 2
INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward) VALUES
(2, 'Types primitifs', 'types-primitifs', 'Java possede 8 types primitifs: int, double, boolean...', 1, 25),
(2, 'Variables', 'variables', 'Declarez des variables avec int nombre = 10;', 2, 25);

-- Lecons Chapitre 3
INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward) VALUES
(3, 'Conditions if/else', 'conditions', 'Utilisez if/else pour controler le flux.', 1, 25),
(3, 'Boucles', 'boucles', 'Utilisez for et while pour repeter du code.', 2, 25);

-- Exercices
INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index) VALUES
(1, 'Hello World', 'Affichez Bonjour JavaQuest!', 
'public class Main { public static void main(String[] args) { } }',
'public class Main { public static void main(String[] args) { System.out.println("Bonjour JavaQuest!"); } }',
'output.contains("Bonjour")', 'Utilisez System.out.println()', 'EASY', 50, 1),
(3, 'Somme', 'Calculez a + b avec a=5 et b=3',
'public class Main { public static void main(String[] args) { int a = 5; int b = 3; } }',
'public class Main { public static void main(String[] args) { int a = 5; int b = 3; System.out.println(a + b); } }',
'output.contains("8")', 'Utilisez l operateur +', 'EASY', 50, 1);

-- Badges
INSERT INTO badges (name, description, icon_url, criteria_type, criteria_value) VALUES
('Premier Pas', 'Premier exercice complete', '/badges/first.svg', 'EXERCISES_COMPLETED', 1),
('Apprenti', 'Gagnez 100 XP', '/badges/apprenti.svg', 'XP_EARNED', 100);
