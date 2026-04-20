-- V60: Exercices Collectors avances (groupingBy, partitioningBy, joining)

-- =============================================
-- EXERCICE 1 : Grouper par Premiere Lettre (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Grouper par Premiere Lettre',
    'EASY',
    'Vous avez une liste de prenoms. Groupez-les par leur premiere lettre et affichez pour chaque lettre (dans l ordre alphabetique) : la lettre suivie du nombre de prenoms dans ce groupe.',
    E'import java.util.List;\nimport java.util.Map;\nimport java.util.TreeMap;\nimport java.util.stream.Collectors;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<String> prenoms = List.of("Alice", "Anna", "Bob", "Bernard", "Camille", "Charles", "David");\n\n        // Groupez par premiere lettre avec Collectors.groupingBy(p -> p.charAt(0))\n        // Utilisez un TreeMap pour trier les cles alphabetiquement\n        // Affichez chaque entree : lettre + ":" + nombre\n    }\n}',
    E'import java.util.List;\nimport java.util.Map;\nimport java.util.TreeMap;\nimport java.util.stream.Collectors;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<String> prenoms = List.of("Alice", "Anna", "Bob", "Bernard", "Camille", "Charles", "David");\n\n        Map<Character, Long> groupes = new TreeMap<>(\n            prenoms.stream()\n                .collect(Collectors.groupingBy(p -> p.charAt(0), Collectors.counting()))\n        );\n\n        groupes.forEach((lettre, compte) ->\n            System.out.println(lettre + ":" + compte)\n        );\n    }\n}',
    'output.contains("A:2") && output.contains("B:2") && output.contains("C:2") && output.contains("D:1")',
    '["Utilisez Collectors.groupingBy(p -> p.charAt(0), Collectors.counting()) pour grouper et compter en meme temps", "Encapsulez le resultat dans new TreeMap<>(...) pour trier les cles alphabetiquement", "Utilisez forEach((lettre, compte) -> ...) pour afficher les entrees"]',
    30,
    1
FROM lessons l WHERE l.slug = 'collectors-avances';

-- =============================================
-- EXERCICE 2 : Bulletin Scolaire (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Bulletin Scolaire',
    'MEDIUM',
    'Vous avez une liste de notes. Partitionnez-les en deux groupes : recus (>= 10) et recales (< 10). Affichez le nombre de recus, le nombre de recales, et la liste des notes recues jointe par virgule et triee.',
    E'import java.util.List;\nimport java.util.Map;\nimport java.util.stream.Collectors;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<Integer> notes = List.of(14, 8, 17, 6, 12, 9, 15, 11, 5, 13);\n\n        // Partitionnez avec Collectors.partitioningBy(n -> n >= 10)\n        // Affichez le nombre de recus (true)\n        // Affichez le nombre de recales (false)\n        // Affichez les notes recues triees jointes par ", " avec joining()\n    }\n}',
    E'import java.util.List;\nimport java.util.Map;\nimport java.util.stream.Collectors;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<Integer> notes = List.of(14, 8, 17, 6, 12, 9, 15, 11, 5, 13);\n\n        Map<Boolean, List<Integer>> partition = notes.stream()\n            .collect(Collectors.partitioningBy(n -> n >= 10));\n\n        System.out.println(partition.get(true).size());\n        System.out.println(partition.get(false).size());\n\n        String notesRecues = partition.get(true).stream()\n            .sorted()\n            .map(String::valueOf)\n            .collect(Collectors.joining(", "));\n        System.out.println(notesRecues);\n    }\n}',
    'output.contains("6") && output.contains("4") && output.contains("11, 12, 13, 14, 15, 17")',
    '["Utilisez Collectors.partitioningBy(n -> n >= 10) pour obtenir une Map<Boolean, List<Integer>>", "Acces aux recus : partition.get(true), aux recales : partition.get(false)", "Pour joindre les notes triees : .sorted().map(String::valueOf).collect(Collectors.joining(\", \"))"]',
    40,
    2
FROM lessons l WHERE l.slug = 'collectors-avances';

-- =============================================
-- EXERCICE 3 : Catalogue de Langages (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Catalogue de Langages',
    'HARD',
    'Vous avez une liste de langages de programmation. Creez une Map qui associe chaque longueur de nom (en caracteres) aux noms de langages concernes, separes par " | " et tries. Affichez chaque entree triee par longueur croissante.',
    E'import java.util.List;\nimport java.util.Map;\nimport java.util.TreeMap;\nimport java.util.stream.Collectors;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<String> langages = List.of("Go", "Java", "Rust", "Ruby", "Python", "Kotlin", "Scala", "C");\n\n        // Groupez par longueur du nom (String::length)\n        // Pour chaque groupe, triez et joignez avec " | " (Collectors.joining)\n        // Utilisez un TreeMap pour trier par longueur\n        // Affichez chaque entree : longueur + ":" + noms\n    }\n}',
    E'import java.util.List;\nimport java.util.Map;\nimport java.util.TreeMap;\nimport java.util.stream.Collectors;\n\npublic class Main {\n    public static void main(String[] args) {\n        List<String> langages = List.of("Go", "Java", "Rust", "Ruby", "Python", "Kotlin", "Scala", "C");\n\n        Map<Integer, String> catalogue = new TreeMap<>(\n            langages.stream()\n                .collect(Collectors.groupingBy(\n                    String::length,\n                    Collectors.collectingAndThen(\n                        Collectors.toList(),\n                        list -> list.stream().sorted().collect(Collectors.joining(" | "))\n                    )\n                ))\n        );\n\n        catalogue.forEach((longueur, noms) ->\n            System.out.println(longueur + ":" + noms)\n        );\n    }\n}',
    'output.contains("1:C") && output.contains("2:Go") && output.contains("4:Java | Ruby | Rust") && output.contains("6:Kotlin | Python | Scala")',
    '["Utilisez Collectors.groupingBy(String::length, ...) comme premier argument", "En downstream Collector, utilisez Collectors.collectingAndThen(Collectors.toList(), list -> list.stream().sorted().collect(Collectors.joining(\" | \")))", "Encapsulez dans new TreeMap<>(...) pour trier par cle (longueur)"]',
    50,
    3
FROM lessons l WHERE l.slug = 'collectors-avances';
