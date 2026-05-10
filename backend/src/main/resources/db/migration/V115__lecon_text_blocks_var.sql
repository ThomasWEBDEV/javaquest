-- V115: Lecon 4 Java Moderne - Text Blocks et var + Quiz + Exercices

-- =============================================
-- LECON 4 : Text Blocks et var
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Text Blocks et var',
    'text-blocks-var',
    E'TEXT BLOCKS ET VAR\n\nJava 10 a introduit var pour l inference de type locale, et Java 15 a stabilise les text blocks (""") pour les chaines multilignes. Ces deux fonctionnalites reduisent la verbosité du code sans sacrifier la lisibilite.\n\n---\n\nVAR : INFERENCE DE TYPE LOCALE (Java 10+)\n\nvar permet au compilateur de deduire le type automatiquement a partir de la valeur.\n\n  // Sans var (verbeux)\n  ArrayList<String> liste = new ArrayList<String>();\n  Map<String, List<Integer>> map = new HashMap<String, List<Integer>>();\n\n  // Avec var (concis)\n  var liste = new ArrayList<String>();\n  var map   = new HashMap<String, List<Integer>>();\n\n  // var dans une boucle\n  for (var element : liste) {\n      System.out.println(element.toUpperCase()); // element est de type String\n  }\n\n  // var pour les types longs\n  var stream = liste.stream().filter(s -> s.length() > 3);\n\nvar ne change pas le typage : Java reste statiquement type. C est juste le compilateur qui deduit le type, pas vous.\n\n---\n\nRESTRICTIONS DE VAR\n\nvar est UNIQUEMENT utilisable pour les variables locales. Ces usages sont INTERDITS :\n\n  var champ;               // INTERDIT : champ de classe\n  var parametre(var x) {}  // INTERDIT : parametre de methode\n  var[] tableau = ...;     // INTERDIT : tableau de var\n  var x = null;            // INTERDIT : null n a pas de type\n\n---\n\nTEXT BLOCKS (Java 15+)\n\nLes text blocks utilisent trois guillemets """ pour les chaines multilignes :\n\n  // Avant : concatenation et \\n manuels\n  String html = "<html>\\n" +\n                "  <body>\\n" +\n                "    <p>Bonjour</p>\\n" +\n                "  </body>\\n" +\n                "</html>";\n\n  // Avec text block\n  String html = """\n          <html>\n            <body>\n              <p>Bonjour</p>\n            </body>\n          </html>\n          """;\n\nL indentation commune est automatiquement supprimee. Les """ fermants determinent le niveau d indentation de base.\n\n---\n\nTEXT BLOCK + FORMATTED()\n\nOn peut combiner text blocks et formatted() pour l interpolation :\n\n  var nom = "Alice";\n  var age = 30;\n\n  var json = """\n          {\n              "nom": "%s",\n              "age": %d\n          }\n          """.formatted(nom, age);\n\n  System.out.println(json);\n  // {\n  //     "nom": "Alice",\n  //     "age": 30\n  // }\n\n---\n\nTEXT BLOCK + VAR : COMBINAISON EFFICACE\n\n  var requete = """\n          SELECT u.nom, u.email\n          FROM utilisateurs u\n          WHERE u.actif = true\n          ORDER BY u.nom\n          LIMIT 10;\n          """;\n\n  var etudiants = List.of("Alice", "Bob", "Charlie");\n\n  var sb = new StringBuilder();\n  for (var etudiant : etudiants) {\n      sb.append("""\n              - %s\n              """.formatted(etudiant));\n  }\n\n  System.out.println(requete);\n  System.out.println(sb);\n\n---\n\nCARACTERISTIQUES DES TEXT BLOCKS\n\n  // Guillemets dans le text block : pas d echappement necessaire\n  var json = """\n          { "cle": "valeur" }\n          """;\n\n  // Pas de newline final si """ est sur la meme ligne que le dernier contenu\n  var court = """\n          une ligne""";\n\n  // stripIndent() supprime l indentation (fait automatiquement par """)\n  // translateEscapes() pour les \\t, \\n dans une String normale\n\n---\n\nBONNES PRATIQUES\n\n- Utilisez var quand le type est evident depuis le contexte (new ArrayList<>(), .stream(), etc.).\n- Evitez var quand le type apporte de l information (List<Commande> plutot que var).\n- Utilisez text blocks pour JSON, HTML, SQL, XML : plus lisibles et sans echappement.\n- Combinez text block et formatted() pour l interpolation de variables.\n- Les """ fermants sur leur propre ligne ajoutent un newline final.',
    4,
    40
FROM chapters c WHERE c.slug = 'java-moderne';

-- =============================================
-- QUIZ : Text Blocks et var
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Text Blocks et var',
    'Testez vos connaissances sur l inference de type var et les text blocks multilignes de Java moderne',
    300, 70, 100
FROM lessons l WHERE l.slug = 'text-blocks-var';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que fait le mot-cle var en Java ?',
        'SINGLE_CHOICE',
        'var permet l inference de type locale : le compilateur deduit automatiquement le type de la variable a partir de la valeur assignee. Java reste statiquement type : c est le compilateur qui determine le type, pas la JVM. var ne cree pas de type dynamique comme en JavaScript.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'text-blocks-var'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Il rend Java dynamiquement type comme JavaScript', false, 1),
    ('Il permet au compilateur de deduire le type d une variable locale', true, 2),
    ('Il cree une variable nullable qui peut changer de type', false, 3),
    ('Il remplace le mot-cle Object pour les types generiques', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Lequel de ces usages de var est INTERDIT ?',
        'SINGLE_CHOICE',
        'var est uniquement utilisable pour les variables locales (dans le corps d une methode). Il est interdit pour les champs de classe, les parametres de methodes, les types de retour, et var x = null (null n a pas de type que le compilateur pourrait deduire).',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'text-blocks-var'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('var liste = new ArrayList<String>()', false, 1),
    ('for (var item : collection) {}', false, 2),
    ('var x = null', true, 3),
    ('var stream = liste.stream()', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment s ecrit un text block en Java ?',
        'SINGLE_CHOICE',
        'Un text block commence par trois guillemets doubles """, suivi d un retour a la ligne obligatoire, puis le contenu, puis """ fermants. On ne peut pas commencer le contenu sur la meme ligne que les """ ouvrants. C est la principale difference avec les Strings normales.',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'text-blocks-var'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Avec des backticks comme en JavaScript : `mon texte`', false, 1),
    ('Avec trois guillemets : """ suivi d un saut de ligne puis le contenu', true, 2),
    ('Avec le mot-cle textblock devant la String : textblock "..."', false, 3),
    ('Avec @TextBlock en annotation avant la variable', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment interpoler des variables dans un text block ?',
        'SINGLE_CHOICE',
        'Java ne supporte pas l interpolation directe dans les text blocks (pas de ${variable}). On utilise la methode formatted() apres le text block, exactement comme String.format() mais en style fluent. Par exemple : """{ "nom": "%s" }""".formatted(nom). C est la methode recommandee.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'text-blocks-var'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('En ecrivant directement ${nom} dans le text block', false, 1),
    ('En utilisant .formatted(valeurs) apres le text block avec %s/%d', true, 2),
    ('En concatenant avec + avant les """', false, 3),
    ('Les text blocks ne supportent pas les variables, il faut une String normale', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que se passe-t-il avec l indentation dans un text block ?',
        'SINGLE_CHOICE',
        'Java supprime automatiquement l indentation commune a toutes les lignes du text block. La position des """ fermants determine le niveau d indentation de base. Les espaces supplementaires d indentation dans le texte sont preserves. Cela permet d ecrire un text block indenté dans le code sans que l indentation du code soit incluse dans la chaine.',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'text-blocks-var'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('L indentation est entierement preservee, y compris les espaces de code source', false, 1),
    ('L indentation est entierement supprimee et le texte est aligne a gauche', false, 2),
    ('L indentation commune est automatiquement supprimee selon la position des """', true, 3),
    ('L indentation est convertie en tabulations pour la portabilite', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Dans quel cas var est-il le plus recommande ?',
        'SINGLE_CHOICE',
        'var est recommande quand le type est evident depuis le contexte : new ArrayList<>(), le resultat d un stream, une boucle for-each, etc. Il n est pas recommande quand le type apporte de l information au lecteur (List<Commande> est plus parlant que var). L objectif est la lisibilite, pas la concision a tout prix.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'text-blocks-var'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Pour tous les types, y compris les champs de classe et les parametres', false, 1),
    ('Uniquement pour les types primitifs comme int, double, boolean', false, 2),
    ('Quand le type est evident depuis la valeur assignee (new X(), stream, etc.)', true, 3),
    ('Uniquement dans les boucles for-each, pas ailleurs', false, 4)
) AS opt(text, is_correct, order_index);

-- =============================================
-- EXERCICE 1 : Text Block JSON Simple (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Text Block JSON Simple',
    'EASY',
    'Utilisez var et un text block pour creer une fiche produit JSON. Declarez trois variables avec var : nom = "Clavier Mecanique", prix = 89.99 et stock = 15. Creez un text block json avec formatted() pour produire un objet JSON valide avec ces trois champs (utilisez %s pour nom, %.2f pour prix et %d pour stock). Affichez le JSON, puis affichez "En stock : " + stock + " unites" sur une deuxieme ligne.',
    E'public class Main {\n    public static void main(String[] args) {\n        // TODO: var nom = ..., var prix = ..., var stock = ...\n\n        // TODO: var json = """\n        //         {\n        //             ...\n        //         }\n        //         """.formatted(...);\n\n        System.out.println(json);\n        System.out.println("En stock : " + stock + " unites");\n    }\n}',
    E'public class Main {\n    public static void main(String[] args) {\n        var nom   = "Clavier Mecanique";\n        var prix  = 89.99;\n        var stock = 15;\n\n        var json = """\n                {\n                    "nom": "%s",\n                    "prix": %.2f,\n                    "stock": %d\n                }\n                """.formatted(nom, prix, stock);\n\n        System.out.println(json);\n        System.out.println("En stock : " + stock + " unites");\n    }\n}',
    'output.contains("Clavier Mecanique") && output.contains("89.99") && output.contains("\"stock\"") && output.contains("15") && output.contains("En stock : 15 unites")',
    '["Declarez les variables avec var : var nom = \"Clavier Mecanique\"; var prix = 89.99; var stock = 15;", "Le text block commence par \"\"\" suivi d un saut de ligne OBLIGATOIRE. Fermez avec \"\"\" sur sa propre ligne. Ensuite .formatted(nom, prix, stock) pour injecter les valeurs.", "Utilisez %s pour String, %.2f pour double (2 decimales), %d pour int dans le formatted()."]',
    30,
    1
FROM lessons l WHERE l.slug = 'text-blocks-var';

-- =============================================
-- EXERCICE 2 : Template HTML avec Text Blocks (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Template HTML avec Text Blocks',
    'MEDIUM',
    'Creez une methode statique String genererSection(String titre, List<String> elements) qui retourne un bloc HTML avec un text block. Le HTML doit contenir une balise section avec un h2 pour le titre et une liste ul avec les elements en li. Utilisez var dans la methode pour le StringBuilder des items. Dans le main, creez deux sections : "Langages" avec ["Java", "Python", "JavaScript"] et "Frameworks" avec ["Spring Boot", "Micronaut", "Quarkus"]. Affichez les deux sections.',
    E'import java.util.List;\n\npublic class Main {\n    static String genererSection(String titre, List<String> elements) {\n        // TODO: var items = new StringBuilder();\n        // for (var el : elements) { items.append("  <li>" + el + "</li>\\n"); }\n        // return text block avec formatted(titre, items)\n        return "";\n    }\n\n    public static void main(String[] args) {\n        var langages   = List.of("Java", "Python", "JavaScript");\n        var frameworks = List.of("Spring Boot", "Micronaut", "Quarkus");\n\n        System.out.println(genererSection("Langages", langages));\n        System.out.println(genererSection("Frameworks", frameworks));\n    }\n}',
    E'import java.util.List;\n\npublic class Main {\n    static String genererSection(String titre, List<String> elements) {\n        var items = new StringBuilder();\n        for (var el : elements) {\n            items.append("  <li>").append(el).append("</li>\\n");\n        }\n\n        return """\n                <section>\n                  <h2>%s</h2>\n                  <ul>\n                %s  </ul>\n                </section>\n                """.formatted(titre, items);\n    }\n\n    public static void main(String[] args) {\n        var langages   = List.of("Java", "Python", "JavaScript");\n        var frameworks = List.of("Spring Boot", "Micronaut", "Quarkus");\n\n        System.out.println(genererSection("Langages", langages));\n        System.out.println(genererSection("Frameworks", frameworks));\n    }\n}',
    'output.contains("<h2>Langages</h2>") && output.contains("<li>Java</li>") && output.contains("<li>Python</li>") && output.contains("<h2>Frameworks</h2>") && output.contains("<li>Spring Boot</li>")',
    '["Construisez les items avec var items = new StringBuilder(); puis for (var el : elements) { items.append(\"  <li>\" + el + \"</li>\\n\"); }", "Le text block retourne : return \"\"\"\n                <section>\\n  <h2>%s</h2>\\n  <ul>\\n%s  </ul>\\n</section>\\n\"\"\".formatted(titre, items);", "Dans le text block, %s sera remplace par le titre et le deuxieme %s par le StringBuilder (appel automatique de toString())."]',
    40,
    2
FROM lessons l WHERE l.slug = 'text-blocks-var';

-- =============================================
-- EXERCICE 3 : Generateur de Rapport avec var (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Generateur de Rapport avec var',
    'HARD',
    'Creez un record Etudiant(String nom, int note). Dans le main, utilisez var pour creer une liste de 4 etudiants : Alice 18, Bob 12, Charlie 15, Diana 9. Utilisez var et des streams pour calculer la moyenne et filtrer les admis (note >= 10). Affichez un rapport en text block avec formatted() : nombre d etudiants, moyenne (1 decimale), nombre d admis. Puis affichez la liste des admis avec leur mention : "Tres bien" si note >= 16, "Bien" si >= 14, "Passable" sinon. Utilisez un text block et var pour la mention egalement.',
    E'import java.util.List;\n\n// TODO: record Etudiant(String nom, int note)\n\npublic class Main {\n    public static void main(String[] args) {\n        var etudiants = List.of(\n            new Etudiant("Alice", 18),\n            new Etudiant("Bob", 12),\n            new Etudiant("Charlie", 15),\n            new Etudiant("Diana", 9)\n        );\n\n        // TODO: var moyenne = ... (stream mapToInt -> average)\n        // TODO: var admis = ... (stream filter note >= 10 -> toList)\n\n        // TODO: text block rapport avec formatted()\n        // "=== RAPPORT ===" + nb etudiants + moyenne + nb admis\n\n        // TODO: afficher les admis avec leur mention\n    }\n}',
    E'import java.util.List;\n\nrecord Etudiant(String nom, int note) {}\n\npublic class Main {\n    public static void main(String[] args) {\n        var etudiants = List.of(\n            new Etudiant("Alice", 18),\n            new Etudiant("Bob", 12),\n            new Etudiant("Charlie", 15),\n            new Etudiant("Diana", 9)\n        );\n\n        var moyenne = etudiants.stream()\n            .mapToInt(Etudiant::note)\n            .average()\n            .orElse(0.0);\n\n        var admis = etudiants.stream()\n            .filter(e -> e.note() >= 10)\n            .toList();\n\n        var rapport = """\n                === RAPPORT DE NOTES ===\n                Etudiants : %d\n                Moyenne   : %.1f / 20\n                Admis     : %d / %d\n                """.formatted(etudiants.size(), moyenne, admis.size(), etudiants.size());\n\n        System.out.println(rapport);\n        System.out.println("=== ETUDIANTS ADMIS ===");\n\n        for (var e : admis) {\n            var mention = e.note() >= 16 ? "Tres bien" : e.note() >= 14 ? "Bien" : "Passable";\n            var ligne = """\n                    %s : %d/20 - %s\n                    """.formatted(e.nom(), e.note(), mention);\n            System.out.print(ligne);\n        }\n    }\n}',
    'output.contains("RAPPORT DE NOTES") && output.contains("Moyenne") && output.contains("Admis     : 3 / 4") && output.contains("ETUDIANTS ADMIS") && output.contains("Alice") && output.contains("Tres bien") && output.contains("Bob") && output.contains("Passable")',
    '["Pour la moyenne : var moyenne = etudiants.stream().mapToInt(Etudiant::note).average().orElse(0.0);. Pour les admis : var admis = etudiants.stream().filter(e -> e.note() >= 10).toList();", "Le text block rapport : \"\"\"\n=== RAPPORT DE NOTES ===\\nEtudiants : %d\\nMoyenne : %.1f / 20\\nAdmis : %d / %d\\n\"\"\".formatted(etudiants.size(), moyenne, admis.size(), etudiants.size())", "Pour la mention dans la boucle : var mention = e.note() >= 16 ? \"Tres bien\" : e.note() >= 14 ? \"Bien\" : \"Passable\";. L operateur ternaire imbrique evite un if-else verbeux."]',
    50,
    3
FROM lessons l WHERE l.slug = 'text-blocks-var';
