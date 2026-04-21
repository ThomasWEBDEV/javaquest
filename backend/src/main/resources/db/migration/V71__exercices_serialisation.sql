-- V71: Exercices serialisation Java (Serializable, ObjectOutputStream, ObjectInputStream, transient)

-- =============================================
-- EXERCICE 1 : Personne Serialisable (EASY)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Personne Serialisable',
    'EASY',
    'Creez une classe Personne implements Serializable avec les champs nom (String) et age (int). Serialisez un objet Personne dans un fichier temporaire avec ObjectOutputStream, puis deserialisez-le avec ObjectInputStream et affichez le nom et l age.',
    E'import java.io.*;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\n\nclass Personne implements Serializable {\n    private static final long serialVersionUID = 1L;\n    private String nom;\n    private int age;\n\n    public Personne(String nom, int age) {\n        this.nom = nom;\n        this.age = age;\n    }\n\n    // Ajoutez les getters getNom() et getAge()\n}\n\npublic class Main {\n    public static void main(String[] args) throws IOException, ClassNotFoundException {\n        Personne alice = new Personne("Alice", 30);\n        Path fichier = Files.createTempFile("personne", ".dat");\n\n        // Serialisez alice dans fichier avec ObjectOutputStream\n        // Deserialisez depuis fichier avec ObjectInputStream\n        // Affichez le nom et l age\n    }\n}',
    E'import java.io.*;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\n\nclass Personne implements Serializable {\n    private static final long serialVersionUID = 1L;\n    private String nom;\n    private int age;\n\n    public Personne(String nom, int age) {\n        this.nom = nom;\n        this.age = age;\n    }\n\n    public String getNom() { return nom; }\n    public int getAge() { return age; }\n}\n\npublic class Main {\n    public static void main(String[] args) throws IOException, ClassNotFoundException {\n        Personne alice = new Personne("Alice", 30);\n        Path fichier = Files.createTempFile("personne", ".dat");\n\n        try (ObjectOutputStream oos = new ObjectOutputStream(\n                new FileOutputStream(fichier.toFile()))) {\n            oos.writeObject(alice);\n        }\n\n        try (ObjectInputStream ois = new ObjectInputStream(\n                new FileInputStream(fichier.toFile()))) {\n            Personne p = (Personne) ois.readObject();\n            System.out.println(p.getNom());\n            System.out.println(p.getAge());\n        }\n    }\n}',
    'output.contains("Alice") && output.contains("30")',
    '["Utilisez new ObjectOutputStream(new FileOutputStream(fichier.toFile())) pour creer le flux d ecriture", "oos.writeObject(alice) serialise l objet", "Pour lire, utilisez ObjectInputStream et castez le resultat : (Personne) ois.readObject()"]',
    30,
    1
FROM lessons l WHERE l.slug = 'serialisation-java';

-- =============================================
-- EXERCICE 2 : Liste de Produits (MEDIUM)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Liste de Produits',
    'MEDIUM',
    'Creez une classe Produit implements Serializable avec les champs nom (String) et prix (double). Creez une ArrayList de 3 produits, serialisez la liste entiere dans un fichier, deserialisez-la et affichez le nombre de produits puis le nom de chacun.',
    E'import java.io.*;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.util.ArrayList;\nimport java.util.List;\n\nclass Produit implements Serializable {\n    private static final long serialVersionUID = 1L;\n    private String nom;\n    private double prix;\n\n    public Produit(String nom, double prix) {\n        this.nom = nom;\n        this.prix = prix;\n    }\n\n    public String getNom() { return nom; }\n    public double getPrix() { return prix; }\n}\n\npublic class Main {\n    public static void main(String[] args) throws IOException, ClassNotFoundException {\n        List<Produit> produits = new ArrayList<>();\n        // Ajoutez : Ordinateur (999.99), Souris (29.90), Clavier (49.99)\n\n        Path fichier = Files.createTempFile("produits", ".dat");\n\n        // Serialisez la liste entiere avec ObjectOutputStream\n        // Deserialisez la liste avec ObjectInputStream\n        // Affichez le nombre de produits\n        // Affichez le nom de chaque produit\n    }\n}',
    E'import java.io.*;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\nimport java.util.ArrayList;\nimport java.util.List;\n\nclass Produit implements Serializable {\n    private static final long serialVersionUID = 1L;\n    private String nom;\n    private double prix;\n\n    public Produit(String nom, double prix) {\n        this.nom = nom;\n        this.prix = prix;\n    }\n\n    public String getNom() { return nom; }\n    public double getPrix() { return prix; }\n}\n\npublic class Main {\n    public static void main(String[] args) throws IOException, ClassNotFoundException {\n        List<Produit> produits = new ArrayList<>();\n        produits.add(new Produit("Ordinateur", 999.99));\n        produits.add(new Produit("Souris", 29.90));\n        produits.add(new Produit("Clavier", 49.99));\n\n        Path fichier = Files.createTempFile("produits", ".dat");\n\n        try (ObjectOutputStream oos = new ObjectOutputStream(\n                new FileOutputStream(fichier.toFile()))) {\n            oos.writeObject(produits);\n        }\n\n        try (ObjectInputStream ois = new ObjectInputStream(\n                new FileInputStream(fichier.toFile()))) {\n            List<Produit> charges = (List<Produit>) ois.readObject();\n            System.out.println(charges.size());\n            charges.forEach(p -> System.out.println(p.getNom()));\n        }\n    }\n}',
    'output.contains("3") && output.contains("Ordinateur") && output.contains("Souris")',
    '["Vous pouvez serialiser une ArrayList entiere avec writeObject(liste) : ArrayList est Serializable", "Lors de la deserialisation, castez en List<Produit> : (List<Produit>) ois.readObject()", "Le compilateur peut afficher un avertissement de cast non verifie : c est normal"]',
    40,
    2
FROM lessons l WHERE l.slug = 'serialisation-java';

-- =============================================
-- EXERCICE 3 : Champ Confidentiel (HARD)
-- =============================================

INSERT INTO exercises (lesson_id, title, difficulty, description, starter_code, solution_code, test_code, hints, xp_reward, order_index)
SELECT l.id,
    'Champ Confidentiel',
    'HARD',
    'Creez une classe Compte implements Serializable avec titulaire (String), solde (double) et motDePasse (String) marque transient. Serialisez un compte avec motDePasse = "secret123", deserialisez-le et affichez le titulaire, le solde et "Mot de passe: null" pour montrer que le champ transient n est pas sauvegarde.',
    E'import java.io.*;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\n\nclass Compte implements Serializable {\n    private static final long serialVersionUID = 1L;\n    private String titulaire;\n    private double solde;\n    private transient String motDePasse; // Ce champ ne sera pas serialise\n\n    public Compte(String titulaire, double solde, String motDePasse) {\n        this.titulaire = titulaire;\n        this.solde = solde;\n        this.motDePasse = motDePasse;\n    }\n\n    // Ajoutez les getters getTitulaire(), getSolde(), getMotDePasse()\n}\n\npublic class Main {\n    public static void main(String[] args) throws IOException, ClassNotFoundException {\n        Compte compte = new Compte("Alice", 1500.0, "secret123");\n        Path fichier = Files.createTempFile("compte", ".dat");\n\n        // Serialisez le compte\n        // Deserialisez le compte\n        // Affichez le titulaire\n        // Affichez le solde\n        // Affichez "Mot de passe: " + le mot de passe (qui sera null)\n    }\n}',
    E'import java.io.*;\nimport java.nio.file.Files;\nimport java.nio.file.Path;\n\nclass Compte implements Serializable {\n    private static final long serialVersionUID = 1L;\n    private String titulaire;\n    private double solde;\n    private transient String motDePasse;\n\n    public Compte(String titulaire, double solde, String motDePasse) {\n        this.titulaire = titulaire;\n        this.solde = solde;\n        this.motDePasse = motDePasse;\n    }\n\n    public String getTitulaire() { return titulaire; }\n    public double getSolde() { return solde; }\n    public String getMotDePasse() { return motDePasse; }\n}\n\npublic class Main {\n    public static void main(String[] args) throws IOException, ClassNotFoundException {\n        Compte compte = new Compte("Alice", 1500.0, "secret123");\n        Path fichier = Files.createTempFile("compte", ".dat");\n\n        try (ObjectOutputStream oos = new ObjectOutputStream(\n                new FileOutputStream(fichier.toFile()))) {\n            oos.writeObject(compte);\n        }\n\n        try (ObjectInputStream ois = new ObjectInputStream(\n                new FileInputStream(fichier.toFile()))) {\n            Compte c = (Compte) ois.readObject();\n            System.out.println(c.getTitulaire());\n            System.out.println(c.getSolde());\n            System.out.println("Mot de passe: " + c.getMotDePasse());\n        }\n    }\n}',
    'output.contains("Alice") && output.contains("1500.0") && output.contains("null")',
    '["Declarez motDePasse avec le mot-cle transient : private transient String motDePasse", "Apres deserialisation, un champ transient a la valeur par defaut de son type : null pour String", "Le champ "secret123" ne doit PAS apparaitre dans la sortie, seulement null"]',
    50,
    3
FROM lessons l WHERE l.slug = 'serialisation-java';
