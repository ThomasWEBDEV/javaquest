-- V5: Contenu detaille du chapitre Introduction a Java + QCMs

-- =============================================
-- SCHEMA: Colonnes manquantes pour les entites Quiz et Question
-- =============================================

ALTER TABLE quizzes
    ADD COLUMN IF NOT EXISTS lesson_id BIGINT REFERENCES lessons(id) ON DELETE CASCADE,
    ADD COLUMN IF NOT EXISTS description TEXT,
    ADD COLUMN IF NOT EXISTS time_limit_seconds INTEGER;

ALTER TABLE quiz_questions
    ADD COLUMN IF NOT EXISTS text TEXT,
    ADD COLUMN IF NOT EXISTS code_snippet TEXT;

-- =============================================
-- CONTENU RICHE : Qu'est-ce que Java ?
-- =============================================

UPDATE lessons SET content = E'HISTOIRE DE JAVA\n\nJava est ne en 1991 au sein de Sun Microsystems, dans le cadre du "Green Project" mene par James Gosling et son equipe. A l\'origine, le langage s\'appelait "Oak" et etait destine aux appareils embarques comme les televiseurs interactifs.\n\nEn 1995, Java est presente officiellement lors de la conference SunWorld sous le slogan "Write Once, Run Anywhere" (WORA). Ce principe revolutionnaire signifie qu\'un programme Java compile peut s\'executer sur n\'importe quel systeme d\'exploitation sans aucune modification.\n\nEn 2009, Oracle rachete Sun Microsystems et prend en charge Java. Aujourd\'hui, Java est l\'un des langages les plus utilises au monde avec des dizaines de millions de developpeurs.\n\n---\n\nLA JVM, LE JDK ET LE JRE\n\nLa cle de la portabilite de Java est la JVM (Java Virtual Machine). Plutot que de compiler directement en code machine comme le fait C ou C++, Java compile en bytecode, un langage intermediaire universel que la JVM interprete et execute.\n\n  JDK (Java Development Kit)\n  └── JRE (Java Runtime Environment)\n      └── JVM (Java Virtual Machine)\n\n- JVM : Lit et execute le bytecode Java sur votre machine\n- JRE : La JVM accompagnee des bibliotheques standard de Java\n- JDK : Le JRE avec en plus les outils de developpement (compilateur javac, debugger, etc.)\n\nPour developper en Java, vous avez besoin du JDK. Pour simplement executer un programme Java existant, le JRE suffit.\n\n---\n\nCARACTERISTIQUES PRINCIPALES\n\nJava est un langage oriente objet (OOP) : tout le code est organise en classes et en objets. Cette approche facilite la reutilisation du code et la maintenance des grands projets.\n\nAutres caracteristiques cles :\n\n  Typage statique fort\n  Les types sont declares et verifies a la compilation. Cela detecte de nombreuses erreurs avant meme l\'execution du programme.\n  Exemple : int age = 25;  // impossible de stocker "bonjour" dans un int\n\n  Gestion automatique de la memoire\n  Le Garbage Collector (GC) libere automatiquement la memoire des objets qui ne sont plus utilises. Le developpeur n\'a pas a gerer la memoire manuellement, contrairement au C++.\n\n  Multithreading\n  Java supporte nativement l\'execution simultanee de plusieurs taches (threads), ce qui est essentiel pour les applications modernes.\n\n  Securite\n  Pas d\'acces direct a la memoire vive. La JVM verifie le bytecode avant execution. Java tourne dans un environnement isole (sandbox).\n\n  Ecosysteme gigantesque\n  Des millions de bibliotheques open-source disponibles via Maven ou Gradle.\n\n---\n\nOÙ UTILISE-T-ON JAVA ?\n\nJava est utilise dans de nombreux domaines strategiques :\n\n  Applications Android\n  Java est le langage historique du developpement Android. Des milliards d\'applications Android sont ecrites en Java (ou Kotlin, qui tourne aussi sur la JVM).\n\n  Applications d\'entreprise\n  Spring Boot, Jakarta EE : Java domine les systemes d\'information d\'entreprise, les banques, les assurances, les services publics.\n\n  Big Data et Cloud\n  Apache Hadoop et Apache Spark, les outils de reference du Big Data, sont ecrits en Java. De nombreux services cloud s\'appuient sur Java.\n\n  Serveurs web\n  Des millions de serveurs web dans le monde fonctionnent avec des applications Java, traitant des milliards de requetes par jour.\n\n  Jeux video\n  Minecraft, l\'un des jeux les plus vendus au monde, est entierement programme en Java.\n\nJava est le choix de predilection pour les systemes qui exigent stabilite, performance et scalabilite a grande echelle.'
WHERE slug = 'quest-ce-que-java';

-- =============================================
-- CONTENU RICHE : Installation
-- =============================================

UPDATE lessons SET content = E'INSTALLER JAVA\n\nPour programmer en Java, vous avez besoin du JDK (Java Development Kit). La distribution la plus recommandee pour les debutants est Eclipse Temurin, disponible gratuitement sur adoptium.net.\n\nEtapes d\'installation :\n  1. Rendez-vous sur https://adoptium.net\n  2. Telechargez la derniere version LTS (Long Term Support) du JDK\n  3. Lancez l\'installateur et suivez les instructions\n  4. Ouvrez un terminal et tapez : java -version\n  5. Si vous voyez un numero de version, Java est installe correctement !\n\n---\n\nCHOISIR UN IDE\n\nUn IDE (Integrated Development Environment) est un editeur de code avance qui vous aide a ecrire du Java plus efficacement.\n\n  IntelliJ IDEA (recommande)\n  Disponible sur jetbrains.com/idea\n  La version Community est gratuite et tres complete.\n  Parfait pour les debutants comme pour les professionnels.\n\n  VS Code + Extension Pack for Java\n  Disponible sur code.visualstudio.com\n  Editeur leger et polyvalent.\n  Installez l\'extension "Extension Pack for Java" depuis le marketplace.\n\n  Eclipse IDE\n  Disponible sur eclipse.org\n  IDE historique du monde Java, tres utilise en entreprise.\n\n---\n\nSTRUCTURE D\'UN PROGRAMME JAVA\n\nTout programme Java est organise de la meme facon. Voici le programme minimal :\n\n  public class HelloWorld {\n      public static void main(String[] args) {\n          System.out.println("Bonjour Java !");\n      }\n  }\n\nDecortiquons chaque partie :\n\n  public class HelloWorld\n  Declare une classe publique appelee "HelloWorld".\n  IMPORTANT : le nom du fichier doit correspondre exactement au nom de la classe.\n  Ce fichier doit donc s\'appeler HelloWorld.java\n\n  public static void main(String[] args)\n  C\'est la methode principale, le point d\'entree du programme.\n  La JVM cherche exactement cette signature pour demarrer l\'execution.\n  - public : accessible depuis l\'exterieur\n  - static : appartient a la classe, pas a un objet\n  - void : ne retourne rien\n  - String[] args : tableau des arguments passes en ligne de commande\n\n  System.out.println(...)\n  Affiche une ligne de texte dans la console.\n  System est une classe built-in, out est le flux de sortie standard, println affiche le texte suivi d\'un saut de ligne.\n\n---\n\nCOMPILER ET EXECUTER\n\nJava est un langage compile : votre code source (.java) est transforme en bytecode (.class) avant d\'etre execute.\n\nDans un terminal, depuis le dossier de votre fichier :\n\n  # Compilation : transforme HelloWorld.java en HelloWorld.class\n  javac HelloWorld.java\n\n  # Execution : lance le programme avec la JVM\n  java HelloWorld\n\nVous devriez voir s\'afficher : Bonjour Java !\n\nAvec un IDE comme IntelliJ ou VS Code, il suffit de cliquer sur le bouton "Run" (triangle vert) pour compiler et executer automatiquement.\n\n---\n\nBONNES PRATIQUES DES LE DEBUT\n\n  Convention de nommage\n  - Classes : PascalCase -> HelloWorld, MonProgramme\n  - Variables et methodes : camelCase -> maVariable, calculerTotal\n  - Constantes : UPPER_SNAKE_CASE -> MAX_VALEUR, PI\n\n  Structure des fichiers\n  Un fichier .java = une classe publique.\n  Le nom du fichier doit toujours correspondre au nom de la classe.\n\n  Indentation\n  Indentez toujours votre code de 4 espaces (ou 1 tabulation) par niveau.\n  Un code bien indente est beaucoup plus facile a lire et a maintenir.'
WHERE slug = 'installation';

-- =============================================
-- QUIZ 1 : Qu'est-ce que Java ?
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Quest-ce que Java ?',
    'Testez vos connaissances sur l histoire et les fondamentaux de Java',
    300, 70, 100
FROM lessons l WHERE l.slug = 'quest-ce-que-java';

-- Question 1 : annee de creation
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'En quelle annee Java a-t-il ete presente officiellement au public ?',
        'SINGLE_CHOICE',
        'Java a ete presente publiquement en 1995 lors de la conference SunWorld par Sun Microsystems.',
        1
    FROM quizzes qz WHERE qz.title = 'Quiz - Quest-ce que Java ?'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, '1991', false, 1 FROM q
UNION ALL SELECT q.id, '1995', true, 2 FROM q
UNION ALL SELECT q.id, '1999', false, 3 FROM q
UNION ALL SELECT q.id, '2004', false, 4 FROM q;

-- Question 2 : signification JVM
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que signifie l acronyme JVM ?',
        'SINGLE_CHOICE',
        'JVM signifie Java Virtual Machine. C''est elle qui execute le bytecode Java sur votre systeme.',
        2
    FROM quizzes qz WHERE qz.title = 'Quiz - Quest-ce que Java ?'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Java Version Manager', false, 1 FROM q
UNION ALL SELECT q.id, 'Java Virtual Machine', true, 2 FROM q
UNION ALL SELECT q.id, 'Java Variable Method', false, 3 FROM q
UNION ALL SELECT q.id, 'Java Validation Module', false, 4 FROM q;

-- Question 3 : principe WORA
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel principe de Java signifie "Write Once, Run Anywhere" ?',
        'SINGLE_CHOICE',
        'WORA (Write Once, Run Anywhere) signifie qu''un code Java compile en bytecode peut s''executer sur n''importe quel systeme disposant d''une JVM.',
        3
    FROM quizzes qz WHERE qz.title = 'Quiz - Quest-ce que Java ?'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'OOP (Object-Oriented Programming)', false, 1 FROM q
UNION ALL SELECT q.id, 'GC (Garbage Collection)', false, 2 FROM q
UNION ALL SELECT q.id, 'WORA (Write Once, Run Anywhere)', true, 3 FROM q
UNION ALL SELECT q.id, 'JIT (Just-In-Time compilation)', false, 4 FROM q;

-- Question 4 : createur de Java
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Qui est le createur principal de Java ?',
        'SINGLE_CHOICE',
        'James Gosling, ingenieur chez Sun Microsystems, est le createur principal de Java dans le cadre du Green Project en 1991.',
        4
    FROM quizzes qz WHERE qz.title = 'Quiz - Quest-ce que Java ?'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Linus Torvalds', false, 1 FROM q
UNION ALL SELECT q.id, 'Guido van Rossum', false, 2 FROM q
UNION ALL SELECT q.id, 'Bjarne Stroustrup', false, 3 FROM q
UNION ALL SELECT q.id, 'James Gosling', true, 4 FROM q;

-- Question 5 : Garbage Collector
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quel mecanisme Java libere automatiquement la memoire des objets inutilises ?',
        'SINGLE_CHOICE',
        'Le Garbage Collector (GC) surveille les objets qui ne sont plus references et libere automatiquement la memoire qu''ils occupaient.',
        5
    FROM quizzes qz WHERE qz.title = 'Quiz - Quest-ce que Java ?'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Le compilateur javac', false, 1 FROM q
UNION ALL SELECT q.id, 'Le Garbage Collector', true, 2 FROM q
UNION ALL SELECT q.id, 'La JVM uniquement', false, 3 FROM q
UNION ALL SELECT q.id, 'Le developpeur manuellement', false, 4 FROM q;

-- Question 6 : paradigme de Java
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Java est principalement un langage de quel paradigme ?',
        'SINGLE_CHOICE',
        'Java est un langage oriente objet (OOP). Tout le code est organise autour de classes et d objets qui encapsulent donnees et comportements.',
        6
    FROM quizzes qz WHERE qz.title = 'Quiz - Quest-ce que Java ?'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Fonctionnel', false, 1 FROM q
UNION ALL SELECT q.id, 'Procedural', false, 2 FROM q
UNION ALL SELECT q.id, 'Oriente Objet', true, 3 FROM q
UNION ALL SELECT q.id, 'Logique', false, 4 FROM q;

-- =============================================
-- QUIZ 2 : Installation et premier programme
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Installation et premier programme',
    'Verifiez votre comprehension de l environnement Java et de la structure d un programme',
    240, 70, 75
FROM lessons l WHERE l.slug = 'installation';

-- Question 1 : signification JDK
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que signifie JDK ?',
        'SINGLE_CHOICE',
        'JDK signifie Java Development Kit. C''est l''ensemble d''outils necessaires pour developper des applications Java (compilateur, debugger, JRE...).',
        1
    FROM quizzes qz WHERE qz.title = 'Quiz - Installation et premier programme'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Java Desktop Kit', false, 1 FROM q
UNION ALL SELECT q.id, 'Java Development Kit', true, 2 FROM q
UNION ALL SELECT q.id, 'Java Debug Kernel', false, 3 FROM q
UNION ALL SELECT q.id, 'Java Dynamic Kit', false, 4 FROM q;

-- Question 2 : commande compilation
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle commande permet de compiler un fichier Java HelloWorld.java ?',
        'SINGLE_CHOICE',
        'La commande javac (Java Compiler) compile le fichier source .java en bytecode .class. On ecrit : javac HelloWorld.java',
        2
    FROM quizzes qz WHERE qz.title = 'Quiz - Installation et premier programme'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'java HelloWorld.java', false, 1 FROM q
UNION ALL SELECT q.id, 'compile HelloWorld.java', false, 2 FROM q
UNION ALL SELECT q.id, 'javac HelloWorld.java', true, 3 FROM q
UNION ALL SELECT q.id, 'run HelloWorld.java', false, 4 FROM q;

-- Question 3 : nom du fichier source
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Si votre classe s appelle "MonProgramme", comment doit s appeler le fichier source Java ?',
        'SINGLE_CHOICE',
        'En Java, le nom du fichier source doit correspondre EXACTEMENT au nom de la classe publique. La classe MonProgramme doit donc etre dans MonProgramme.java.',
        3
    FROM quizzes qz WHERE qz.title = 'Quiz - Installation et premier programme'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'main.java', false, 1 FROM q
UNION ALL SELECT q.id, 'programme.java', false, 2 FROM q
UNION ALL SELECT q.id, 'MonProgramme.java', true, 3 FROM q
UNION ALL SELECT q.id, 'monprogramme.java', false, 4 FROM q;

-- Question 4 : methode principale
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle est la signature exacte de la methode principale d un programme Java ?',
        'SINGLE_CHOICE',
        'La methode main doit avoir exactement la signature : public static void main(String[] args). La JVM recherche cette signature precise pour demarrer l''execution.',
        4
    FROM quizzes qz WHERE qz.title = 'Quiz - Installation et premier programme'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'public void main()', false, 1 FROM q
UNION ALL SELECT q.id, 'static main(String args)', false, 2 FROM q
UNION ALL SELECT q.id, 'public static void main(String[] args)', true, 3 FROM q
UNION ALL SELECT q.id, 'void Start(String[] args)', false, 4 FROM q;

-- Question 5 : instruction affichage
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle instruction Java affiche du texte dans la console avec un saut de ligne ?',
        'SINGLE_CHOICE',
        'System.out.println() affiche le texte passe en argument puis ajoute un saut de ligne. System.out.print() fait la meme chose sans saut de ligne.',
        5
    FROM quizzes qz WHERE qz.title = 'Quiz - Installation et premier programme'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, 'Console.log("texte")', false, 1 FROM q
UNION ALL SELECT q.id, 'print("texte")', false, 2 FROM q
UNION ALL SELECT q.id, 'echo("texte")', false, 3 FROM q
UNION ALL SELECT q.id, 'System.out.println("texte")', true, 4 FROM q;
