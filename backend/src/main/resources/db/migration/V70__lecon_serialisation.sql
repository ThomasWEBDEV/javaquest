-- V70: Lecon 4 Fichiers et IO - Serialisation Java (Serializable, ObjectStream, transient) + Quiz

-- =============================================
-- LECON 4 : Serialisation Java
-- =============================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward)
SELECT c.id,
    'Serialisation Java : Serializable et ObjectStream',
    'serialisation-java',
    E'SERIALISATION JAVA : SERIALIZABLE ET OBJECTSTREAM\n\nLa serialisation est le mecanisme qui permet de convertir un objet Java en flux d octets pour le sauvegarder dans un fichier ou le transmettre sur un reseau. La deserialisation est l operation inverse.\n\n---\n\nQU EST-CE QUE LA SERIALISATION ?\n\nImaginons que vous avez un objet Java en memoire. La serialisation transforme cet objet en une sequence d octets que vous pouvez :\n- Ecrire dans un fichier pour le persister\n- Envoyer sur le reseau a une autre application\n- Stocker en cache\n\nLa deserialisation reconstruit l objet original a partir de ces octets.\n\n---\n\nL INTERFACE SERIALIZABLE\n\nPour qu une classe soit serialisable, elle doit implementer java.io.Serializable :\n\n  import java.io.Serializable;\n\n  public class Personne implements Serializable {\n      private String nom;\n      private int age;\n\n      public Personne(String nom, int age) {\n          this.nom = nom;\n          this.age = age;\n      }\n\n      public String getNom() { return nom; }\n      public int getAge() { return age; }\n\n      @Override\n      public String toString() {\n          return nom + " (" + age + " ans)";\n      }\n  }\n\nSerializable est une interface marqueur : elle ne declare aucune methode. Sa presence indique simplement a la JVM que la classe peut etre serialisee.\n\nATTENTION : Tous les champs de la classe doivent etre serialisables (types primitifs, String, collections...). Une reference a un objet non serialisable levera une NotSerializableException.\n\n---\n\nOBJECTOUTPUTSTREAM : ECRIRE UN OBJET\n\nObjectOutputStream permet d ecrire un objet dans un flux de sortie (fichier, reseau...) :\n\n  import java.io.FileOutputStream;\n  import java.io.IOException;\n  import java.io.ObjectOutputStream;\n  import java.nio.file.Files;\n  import java.nio.file.Path;\n\n  Personne alice = new Personne("Alice", 30);\n  Path fichier = Files.createTempFile("personne", ".dat");\n\n  try (ObjectOutputStream oos = new ObjectOutputStream(\n          new FileOutputStream(fichier.toFile()))) {\n      oos.writeObject(alice);\n      System.out.println("Objet serialise avec succes");\n  } catch (IOException e) {\n      System.out.println("Erreur : " + e.getMessage());\n  }\n\n---\n\nOBJECTINPUTSTREAM : LIRE UN OBJET\n\nObjectInputStream reconstruit l objet depuis le fichier :\n\n  import java.io.FileInputStream;\n  import java.io.IOException;\n  import java.io.ObjectInputStream;\n\n  try (ObjectInputStream ois = new ObjectInputStream(\n          new FileInputStream(fichier.toFile()))) {\n      Personne personne = (Personne) ois.readObject();\n      System.out.println("Nom : " + personne.getNom());\n      System.out.println("Age : " + personne.getAge());\n  } catch (IOException | ClassNotFoundException e) {\n      System.out.println("Erreur : " + e.getMessage());\n  }\n\nreadObject() peut lever deux exceptions :\n- IOException : probleme de lecture du fichier\n- ClassNotFoundException : la classe de l objet n est pas dans le classpath\n\n---\n\nLE MOT-CLE TRANSIENT\n\nLe mot-cle transient exclut un champ de la serialisation. Ce champ sera null apres deserialisation :\n\n  import java.io.Serializable;\n\n  public class Compte implements Serializable {\n      private String titulaire;\n      private double solde;\n      private transient String motDePasse; // non serialise\n\n      // constructeur, getters...\n  }\n\nApres deserialisation, motDePasse sera null car il n a pas ete sauvegarde.\n\nUtilisez transient pour les champs :\n- Contenant des donnees sensibles (mots de passe)\n- Non serialisables (connexions, threads...)\n- Derivables ou inutiles a sauvegarder\n\n---\n\nSERIALVERSIONUID\n\nserialVersionUID permet de gerer la compatibilite entre versions de la classe :\n\n  public class Personne implements Serializable {\n      private static final long serialVersionUID = 1L;\n      // champs...\n  }\n\nSi vous modifiez la classe sans changer serialVersionUID, Java verifie la compatibilite automatiquement. Si les versions sont incompatibles, une InvalidClassException est levee lors de la deserialisation.\n\nBonne pratique : toujours declarer serialVersionUID explicitement pour avoir le controle.\n\n---\n\nEXEMPLE COMPLET : LISTE D OBJETS\n\n  import java.io.*;\n  import java.nio.file.Files;\n  import java.nio.file.Path;\n  import java.util.ArrayList;\n  import java.util.List;\n\n  public class GestionProduits {\n      public static void main(String[] args) throws IOException, ClassNotFoundException {\n          List<Personne> personnes = new ArrayList<>();\n          personnes.add(new Personne("Alice", 30));\n          personnes.add(new Personne("Bob", 25));\n          personnes.add(new Personne("Charlie", 35));\n\n          Path fichier = Files.createTempFile("personnes", ".dat");\n\n          // Serialisation de la liste entiere\n          try (ObjectOutputStream oos = new ObjectOutputStream(\n                  new FileOutputStream(fichier.toFile()))) {\n              oos.writeObject(personnes);\n          }\n\n          // Deserialisation\n          try (ObjectInputStream ois = new ObjectInputStream(\n                  new FileInputStream(fichier.toFile()))) {\n              List<Personne> chargees = (List<Personne>) ois.readObject();\n              System.out.println("Nombre : " + chargees.size());\n              chargees.forEach(System.out::println);\n          }\n      }\n  }\n\n---\n\nBONNES PRATIQUES ET LIMITES\n\n1. Toujours declarer serialVersionUID pour maitriser la compatibilite.\n2. Utilisez transient pour les donnees sensibles ou non serialisables.\n3. La serialisation Java est specifique a Java (non interoperable avec d autres langages).\n4. Preferez JSON (avec Jackson) ou XML pour l interoperabilite et la lisibilite.\n5. Ne deserializez JAMAIS des donnees venant de sources non fiables : risque de securite.\n6. La serialisation inclut l etat de l objet mais pas le code : la classe doit exister a la deserialisation.',
    4,
    40
FROM chapters c WHERE c.slug = 'fichiers-io';

-- =============================================
-- QUIZ : Serialisation Java
-- =============================================

INSERT INTO quizzes (lesson_id, title, description, time_limit_seconds, passing_score, xp_reward)
SELECT l.id,
    'Quiz - Serialisation Java',
    'Testez vos connaissances sur Serializable, ObjectOutputStream, ObjectInputStream et transient',
    300, 70, 100
FROM lessons l WHERE l.slug = 'serialisation-java';

-- Question 1
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle interface doit implementer une classe pour etre serialisable ?',
        'SINGLE_CHOICE',
        'java.io.Serializable est une interface marqueur (sans methodes) qui indique a la JVM que les objets de cette classe peuvent etre convertis en flux d octets. Sans cette interface, une NotSerializableException est levee.',
        1
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'serialisation-java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('java.io.Persistable', false, 1),
    ('java.io.Serializable', true, 2),
    ('java.io.Storable', false, 3),
    ('java.io.Saveable', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 2
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle classe permet d ecrire un objet dans un fichier ?',
        'SINGLE_CHOICE',
        'ObjectOutputStream est la classe qui serialise un objet et ecrit les octets dans un flux de sortie. On l utilise avec new ObjectOutputStream(new FileOutputStream(fichier)) et la methode writeObject().',
        2
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'serialisation-java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('ObjectInputStream', false, 1),
    ('FileWriter', false, 2),
    ('ObjectOutputStream', true, 3),
    ('BufferedWriter', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 3
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Que fait le mot-cle transient sur un champ ?',
        'SINGLE_CHOICE',
        'Un champ declare transient est exclu de la serialisation : sa valeur n est pas sauvegardee. Apres deserialisation, ce champ aura sa valeur par defaut (null pour les objets, 0 pour les entiers, false pour les booleens).',
        3
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'serialisation-java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Il rend le champ immuable', false, 1),
    ('Il exclut le champ de la serialisation', true, 2),
    ('Il rend le champ accessible depuis d autres packages', false, 3),
    ('Il force le champ a etre initialise', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 4
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'A quoi sert serialVersionUID ?',
        'SINGLE_CHOICE',
        'serialVersionUID est un identifiant de version utilise pour verifier que la classe a laquelle appartient un objet serialise est compatible avec la classe chargee lors de la deserialisation. S ils different, une InvalidClassException est levee.',
        4
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'serialisation-java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('A identifier chaque objet de facon unique en memoire', false, 1),
    ('A verifier la compatibilite entre versions lors de la deserialisation', true, 2),
    ('A chiffrer les donnees serialisees', false, 3),
    ('A limiter le nombre d instances d une classe', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 5
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Quelle exception peut lever readObject() en plus d IOException ?',
        'SINGLE_CHOICE',
        'readObject() peut lever ClassNotFoundException si la classe de l objet a deserialiser n est pas disponible dans le classpath de l application qui deserialise. C est pourquoi on utilise souvent catch (IOException | ClassNotFoundException e).',
        5
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'serialisation-java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('NullPointerException', false, 1),
    ('ClassNotFoundException', true, 2),
    ('IllegalArgumentException', false, 3),
    ('SerializationException', false, 4)
) AS opt(text, is_correct, order_index);

-- Question 6
WITH q AS (
    INSERT INTO quiz_questions (quiz_id, text, question_type, explanation, order_index)
    SELECT qz.id,
        'Comment deserialiser un objet Personne depuis un fichier ?',
        'SINGLE_CHOICE',
        'On utilise ObjectInputStream avec new ObjectInputStream(new FileInputStream(fichier)), puis ois.readObject() retourne un Object que l on caste en Personne. Le cast est necessaire car readObject() retourne Object.',
        6
    FROM quizzes qz
    INNER JOIN lessons l ON qz.lesson_id = l.id
    WHERE l.slug = 'serialisation-java'
    RETURNING id
)
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
SELECT q.id, opt.text, opt.is_correct, opt.order_index
FROM q,
(VALUES
    ('Personne p = Files.readObject(fichier, Personne.class)', false, 1),
    ('Personne p = (Personne) ois.readObject() avec ObjectInputStream', true, 2),
    ('Personne p = ObjectInputStream.load(fichier)', false, 3),
    ('Personne p = new Personne(Files.readAllBytes(fichier))', false, 4)
) AS opt(text, is_correct, order_index);
