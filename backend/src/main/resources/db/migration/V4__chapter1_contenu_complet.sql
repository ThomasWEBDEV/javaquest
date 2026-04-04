-- V4 : Contenu pédagogique complet - Chapitre 1 : Introduction à Java

-- Suppression des données existantes du chapitre 1
DELETE FROM exercises WHERE lesson_id IN (SELECT id FROM lessons WHERE chapter_id = 1);
DELETE FROM lessons WHERE chapter_id = 1;

-- ============================================================
-- LEÇONS DU CHAPITRE 1 : Introduction à Java
-- ============================================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward) VALUES
(1, 'Histoire et origines de Java', 'histoire-java',
'# Histoire et origines de Java

## Les débuts : le projet Oak (1991)

Java est né en **1991** dans les laboratoires de **Sun Microsystems**, initié par **James Gosling** et son équipe. À l''origine, le projet s''appelait **"Oak"** (chêne en anglais), inspiré par un arbre visible depuis le bureau de Gosling. L''objectif initial était modeste : créer un langage pour les appareils électroniques grand public — télécommandes, décodeurs câble, grille-pains intelligents...

Les systèmes embarqués de l''époque imposaient des contraintes sévères : peu de mémoire, processeurs variés, fiabilité absolue requise. Ces contraintes forgèrent les caractéristiques fondamentales de Java : **robustesse**, **portabilité**, et **sécurité**.

## La révolution Internet (1995)

En **1995**, tout changea avec l''explosion d''Internet. Sun Microsystems reconnut le potentiel immense de Java pour le web et rebaptisa officiellement le projet **"Java"**. Le langage fut présenté lors de la conférence SunWorld avec une démonstration spectaculaire : une applet Java s''exécutant directement dans le navigateur Netscape Navigator.

Cette démonstration marqua le début d''une nouvelle ère. Java promettait quelque chose de révolutionnaire : **"Write Once, Run Anywhere"** (Écrire une fois, exécuter partout).

Contrairement à C ou C++, qui compilent en code machine spécifique à chaque processeur, Java compile en **bytecode**, un format intermédiaire compris par la **Machine Virtuelle Java (JVM)**. Ce bytecode peut s''exécuter identiquement sur Windows, Linux, macOS, ou n''importe quel système disposant d''une JVM.

```java
// Ce code écrit sur Windows...
System.out.println("Bonjour depuis Java !");
// ...s''exécute AUSSI sur Linux, macOS, Android...
// sans modification !
```

## L''essor et la domination (2000-2010)

Au tournant du millénaire, Java s''imposa comme **le** langage d''entreprise de référence :

- **Java EE** (Enterprise Edition) pour les applications serveur de grande envergure
- **JDBC** pour la connexion aux bases de données relationnelles
- **Swing** pour la création d''interfaces graphiques portables
- Les **Servlets** et **JSP** pour le web dynamique côté serveur

Des entreprises comme Amazon, eBay, LinkedIn et Twitter construisirent leurs systèmes critiques en Java. Le langage devint le standard pour les systèmes bancaires, les applications hospitalières, et les grandes plateformes e-commerce.

## Java et Android (2007-présent)

En 2007, Google choisit Java comme langage principal pour le développement d''applications **Android**. Cette décision exposa Java à des millions de nouveaux développeurs et applications mobiles.

Aujourd''hui, même si **Kotlin** est devenu le langage recommandé pour Android, l''immense écosystème Java reste omniprésent. Des milliards d''appareils Android tournent sur du code Java ou Kotlin, qui compile vers la même machine virtuelle.

## Oracle et l''ère moderne (2010-présent)

En **2010**, Oracle racheta Sun Microsystems pour 7,4 milliards de dollars. Depuis, Oracle assure le développement de Java avec un rythme de publication accéléré depuis Java 9 : une nouvelle version tous les **6 mois**, avec des versions **LTS** (Long Term Support) tous les 2 ans.

| Version | Année | Statut |
|---------|-------|--------|
| Java 8  | 2014  | LTS — encore massivement utilisé |
| Java 11 | 2018  | LTS |
| Java 17 | 2021  | LTS |
| Java 21 | 2023  | LTS — version actuelle recommandée |

Java 21 apporte des fonctionnalités modernes comme les **Virtual Threads**, le **Pattern Matching**, et les **Records**, rendant le langage plus expressif et performant que jamais.

## Pourquoi apprendre Java aujourd''hui ?

1. **Marché de l''emploi** : Java est constamment dans le top 3 des langages les plus demandés au monde
2. **Communauté immense** : Des milliers de bibliothèques open-source disponibles via Maven Central
3. **Performance** : La JVM moderne rivalise avec les langages compilés nativement grâce au JIT
4. **Polyvalence** : Web, mobile, big data (Hadoop, Spark), microservices (Spring Boot)...
5. **Fondations solides** : Maîtriser Java vous donnera d''excellentes bases pour tout langage orienté objet

Java fête ses 30 ans et reste plus pertinent que jamais. C''est un choix excellent pour débuter votre parcours de développeur !',
1, 25),

(1, 'La JVM : Machine Virtuelle Java', 'jvm-java',
'# La JVM : Machine Virtuelle Java

## Qu''est-ce que la JVM ?

La **Java Virtual Machine** (JVM, Machine Virtuelle Java) est le composant fondamental qui permet à Java de tenir sa promesse "Write Once, Run Anywhere". C''est un programme qui simule un ordinateur virtuel capable de comprendre et d''exécuter le **bytecode Java**.

Imaginez la JVM comme un traducteur universel : votre code Java est d''abord traduit dans un langage intermédiaire (le bytecode), puis la JVM traduit ce bytecode en instructions spécifiques à votre processeur et système d''exploitation.

## Le pipeline complet d''exécution

```
MonProgramme.java    →    MonProgramme.class    →    Résultat
  (Code source)           (Bytecode JVM)
       ↑                        ↑                        ↑
  Vous l''écrivez          javac compile             java exécute
```

### Étape 1 — Écriture du code source

Vous créez un fichier texte `.java` avec votre code :

```java
public class Exemple {
    public static void main(String[] args) {
        System.out.println("Bonjour depuis la JVM !");
    }
}
```

### Étape 2 — Compilation en bytecode

La commande `javac` transforme votre code en bytecode :

```bash
javac Exemple.java
# Produit : Exemple.class (format binaire, non lisible directement)
```

Le bytecode est **indépendant de tout système d''exploitation**. Un même fichier `.class` fonctionnera identiquement sur Windows, Linux et macOS.

### Étape 3 — Exécution par la JVM

La commande `java` lance la JVM qui charge et exécute le bytecode :

```bash
java Exemple
# Bonjour depuis la JVM !
```

## Les composants internes de la JVM

### Le Class Loader (Chargeur de classes)

Le Class Loader charge les fichiers `.class` en mémoire à la demande. Il utilise le chargement **lazy** (paresseux) : une classe n''est chargée que quand elle est utilisée pour la première fois. Cela économise de la mémoire et accélère le démarrage.

### Le JIT Compiler (Compilateur Just-In-Time)

Le **JIT** est le secret des performances de Java. Au lieu d''interpréter chaque instruction bytecode une par une, le JIT analyse votre code pendant l''exécution et compile les parties les plus fréquemment utilisées directement en **code machine natif** et optimisé.

```
Interprétation initiale → Détection du "code chaud" → Compilation JIT → Exécution native rapide
```

Résultat : un programme Java qui tourne depuis quelques secondes peut devenir aussi rapide qu''un programme C++, car le JIT a eu le temps d''optimiser les chemins d''exécution critiques.

### Le Garbage Collector (Ramasse-miettes)

Le **Garbage Collector** (GC) est l''un des plus grands avantages de Java par rapport à C/C++. Il gère automatiquement la mémoire :

```java
// En C++, vous devez libérer la mémoire manuellement
// Oublier = fuite mémoire, libérer deux fois = crash !

// En Java, le GC s''en charge :
String message = new String("Temporaire");
// ... utilisation de message ...
// Quand message n''est plus référencé, le GC libère la mémoire automatiquement !
```

Les GC modernes (G1GC, ZGC, Shenandoah) sont très sophistiqués et causent des pauses quasi imperceptibles.

### Les zones mémoire de la JVM

| Zone | Rôle | Contenu |
|------|------|---------|
| **Heap (Tas)** | Mémoire principale | Objets créés avec `new` |
| **Stack (Pile)** | Mémoire par thread | Variables locales, appels de méthodes |
| **Method Area** | Code des classes | Définitions de classes et méthodes statiques |
| **PC Register** | Registre d''instruction | Instruction courante en cours d''exécution |

## JVM, JRE et JDK : quelle différence ?

Ces trois acronymes sont souvent confondus. Voici la hiérarchie :

```
JDK (Java Development Kit)
├── JRE (Java Runtime Environment)
│   ├── JVM (Java Virtual Machine)
│   └── Bibliothèques standard Java (java.lang, java.util...)
└── Outils de développement
    ├── javac  — compilateur
    ├── javadoc — générateur de documentation
    ├── jdb    — débogueur
    └── jshell — REPL interactif
```

- **JVM** : Le moteur d''exécution du bytecode
- **JRE** : JVM + bibliothèques → Pour **exécuter** des programmes Java
- **JDK** : JRE + outils → Pour **développer** des programmes Java

**En tant que développeur Java, vous avez besoin du JDK !**

## La JVM : bien plus que Java

Un fait souvent méconnu : la JVM peut exécuter bien d''autres langages que Java !

- **Kotlin** : Langage moderne, concurrent de Java sur Android
- **Scala** : Langage fonctionnel et objet, populaire pour le Big Data (Spark)
- **Groovy** : Langage dynamique, utilisé dans les scripts Gradle
- **Clojure** : Dialecte de Lisp sur la JVM

Apprendre Java, c''est maîtriser une plateforme entière et ouvrir les portes de tout un écosystème !',
2, 25),

(1, 'Votre premier programme Java', 'premier-programme',
'# Votre premier programme Java

## La structure de base

Tout programme Java suit une structure précise et obligatoire. Voici le traditionnel "Hello World" :

```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

Ce petit programme contient tous les éléments fondamentaux de Java. Décortiquons-le ensemble.

## Analyse élément par élément

### 1. La déclaration de classe

```java
public class HelloWorld {
    // contenu de la classe
}
```

En Java, **tout code doit appartenir à une classe**. Cette ligne déclare une classe publique nommée `HelloWorld`.

| Mot-clé | Rôle |
|---------|------|
| `public` | Modificateur d''accès : la classe est accessible depuis n''importe où |
| `class` | Mot-clé qui déclare une classe |
| `HelloWorld` | Nom de la classe |

**Règle absolue** : Le nom de la classe `public` doit correspondre exactement au nom du fichier `.java`. Notre classe `HelloWorld` doit être dans un fichier `HelloWorld.java`.

**Convention de nommage** : Les noms de classes utilisent le **PascalCase** (chaque mot commence par une majuscule) : `MaClasse`, `CalculateurBMI`, `GestionnaireEtudiants`.

### 2. La méthode main : le point d''entrée

```java
public static void main(String[] args) {
    // instructions du programme
}
```

C''est le **point d''entrée** de tout programme Java. Quand vous exécutez un programme, la JVM cherche précisément cette méthode pour savoir où commencer.

| Mot-clé | Signification |
|---------|---------------|
| `public` | Accessible depuis n''importe où (nécessaire pour la JVM) |
| `static` | Appartient à la classe, pas à une instance (la JVM peut l''appeler sans créer d''objet) |
| `void` | Ne retourne aucune valeur |
| `main` | Nom recherché automatiquement par la JVM au démarrage |
| `String[] args` | Tableau pour les arguments passés en ligne de commande |

**Cette signature est immuable !** Si vous oubliez `static` ou changez le type des paramètres, la JVM ne trouvera pas le point d''entrée et lèvera une erreur.

### 3. Afficher du texte : System.out.println

```java
System.out.println("Hello, World!");
```

Cette instruction affiche du texte dans la console.

- `System` : Classe de la bibliothèque standard Java
- `out` : Flux de sortie standard (la console)
- `println` : Méthode qui affiche le texte **et** ajoute un saut de ligne

Les variantes d''affichage :

```java
System.out.println("Avec saut de ligne");         // Passe à la ligne après
System.out.print("Sans saut de ligne");            // Reste sur la même ligne
System.out.printf("Bonjour %s, tu as %d ans\n", "Alice", 25); // Formaté
System.out.println(42);                            // Affiche un nombre
System.out.println(3.14 * 2);                      // Calcule et affiche
```

### 4. Le point-virgule `;`

Chaque **instruction** en Java se termine par un point-virgule. C''est l''une des erreurs les plus fréquentes :

```java
System.out.println("Correct");   // ✓ Point-virgule présent
System.out.println("Erreur")     // ✗ Erreur de compilation !
```

## Les règles syntaxiques essentielles

### Les accolades `{}`

Les accolades délimitent les **blocs de code**. Chaque ouvrante `{` doit avoir sa fermante `}` :

```java
public class MaClasse {              // Ouvre la classe
    public static void main(...) {   // Ouvre main
        System.out.println("OK");    // Instruction
    }                                // Ferme main
}                                    // Ferme la classe
```

### La sensibilité à la casse

Java distingue rigoureusement majuscules et minuscules :

```java
String texte = "Correct";    // ✓ String avec S majuscule
string texte = "Erreur";     // ✗ "string" n''existe pas en Java

System.out.println("OK");    // ✓
system.out.println("PAS");   // ✗ "system" n''existe pas
```

### Les commentaires

```java
// Commentaire sur une seule ligne — ignoré par le compilateur

/* Commentaire
   sur plusieurs lignes */

/**
 * Commentaire Javadoc — utilisé pour générer la documentation officielle
 * @param args les arguments de la ligne de commande
 */
```

## Un programme complet et commenté

```java
/**
 * Programme de bienvenue dans JavaQuest
 */
public class Bienvenue {
    public static void main(String[] args) {
        // Affichage de l''en-tête
        System.out.println("╔══════════════════════════════╗");
        System.out.println("║   Bienvenue dans JavaQuest ! ║");
        System.out.println("╚══════════════════════════════╝");

        // Informations
        System.out.println("Java est génial !");
        System.out.println("Je commence mon apprentissage.");

        /* Ce programme affiche 5 lignes au total */
        System.out.println("Bonne chance à tous !");
    }
}
```

## Les erreurs de débutant à éviter

| Erreur | Exemple incorrect | Correction |
|--------|------------------|------------|
| Nom de fichier ≠ classe | `MonProg.java` avec `class Main` | Renommez l''un des deux |
| Oublier le `;` | `println("OK")` | `println("OK");` |
| Mauvaise casse | `system.out.println` | `System.out.println` |
| Accolade non fermée | `{ ... ` | `{ ... }` |
| Guillemets oubliés | `println(Bonjour)` | `println("Bonjour")` |

## À retenir absolument

- Tout programme Java est contenu dans une **classe**
- L''exécution commence toujours dans la méthode **`main`**
- **`System.out.println()`** affiche du texte dans la console
- Java est **sensible à la casse** (majuscules/minuscules différentes)
- Chaque instruction se termine par un **`;`**',
3, 25),

(1, 'Compilation et exécution', 'compilation-java',
'# Compilation et exécution en Java

## Le cycle de développement Java

Développer en Java suit un cycle bien défini, appelé **Edit-Compile-Run** :

```
1. ÉCRIRE   → MonProgramme.java (code source lisible)
       ↓
2. COMPILER → javac MonProgramme.java → MonProgramme.class (bytecode)
       ↓
3. EXÉCUTER → java MonProgramme → Résultat dans la console
       ↓
4. ANALYSER → Corriger et recommencer si nécessaire
```

Comprendre ce cycle est fondamental pour tout développeur Java.

## La commande `javac` : le compilateur

`javac` (**Java Compiler**) est l''outil qui transforme votre code source en bytecode.

### Utilisation de base

```bash
# Compiler un seul fichier
javac HelloWorld.java

# Si la compilation réussit : aucun message, le fichier HelloWorld.class est créé
# Si des erreurs existent : le compilateur les affiche avec les numéros de ligne
```

### Lire et comprendre les erreurs de compilation

```bash
$ javac HelloWorld.java
HelloWorld.java:3: error: ';' expected
        System.out.println("Bonjour")
                                     ^
1 error
```

Le compilateur vous indique précisément :
- **Le fichier** : `HelloWorld.java`
- **La ligne** : `3`
- **Le problème** : `';' expected` — il manque un point-virgule
- **L''endroit exact** : le symbole `^` pointe la position problématique

### Options utiles de javac

```bash
# Compiler tous les fichiers .java du dossier courant
javac *.java

# Placer les .class compilés dans un dossier spécifique
javac -d out/ MonProgramme.java

# Voir des avertissements supplémentaires
javac -Xlint MonProgramme.java

# Cibler une version Java spécifique
javac --release 17 MonProgramme.java
```

## La commande `java` : exécuter le programme

`java` lance la JVM et exécute votre programme compilé.

```bash
# Exécuter le programme (sans l''extension .class !)
java HelloWorld

# Avec des arguments de ligne de commande
java HelloWorld Alice 25
```

**Important** : On utilise le **nom de la classe**, pas le nom du fichier `.class` !

### Récupérer les arguments en ligne de commande

```java
public class Salutation {
    public static void main(String[] args) {
        // args contient les arguments passés lors du lancement
        if (args.length > 0) {
            System.out.println("Bonjour " + args[0] + " !");
        } else {
            System.out.println("Bonjour inconnu !");
        }
    }
}
```

```bash
$ java Salutation Alice
Bonjour Alice !

$ java Salutation
Bonjour inconnu !
```

## Les IDEs : simplifier le développement

En pratique, les développeurs utilisent des **IDEs** (Integrated Development Environments) qui automatisent la compilation et l''exécution :

### IntelliJ IDEA (recommandé pour Java)

```
Shift + F10    → Exécuter le programme
F9             → Déboguer
Ctrl + F9      → Compiler uniquement
Alt + Enter    → Suggestions d''import / corrections rapides
```

### Eclipse

```
Ctrl + F11    → Exécuter
F11           → Déboguer
Ctrl + B      → Build (compiler tout le projet)
```

### VS Code (avec l''extension Java)

```
F5            → Exécuter / Déboguer
Ctrl + Shift + P → Ouvrir la palette de commandes Java
```

Les IDEs offrent bien plus que la simple compilation :
- **Coloration syntaxique** — rend le code lisible en un coup d''œil
- **Auto-complétion** — suggestions intelligentes pendant la frappe
- **Détection d''erreurs en temps réel** — souligne les problèmes avant même de compiler
- **Débogage intégré** — exécution pas à pas pour comprendre les bugs
- **Refactoring** — renommage automatique, extraction de méthodes...

## Maven et Gradle : pour les projets réels

Pour les projets avec de nombreux fichiers et bibliothèques externes, des outils de **build** automatisent tout :

### Maven (utilisé dans JavaQuest !)

```xml
<!-- pom.xml — fichier de configuration Maven -->
<project>
    <groupId>com.javaquest</groupId>
    <artifactId>backend</artifactId>
    <version>1.0.0</version>
    <dependencies>
        <!-- Les bibliothèques sont téléchargées automatiquement -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>
</project>
```

```bash
mvn compile          # Compiler
mvn test             # Lancer les tests
mvn package          # Créer un fichier JAR exécutable
mvn spring-boot:run  # Lancer l''application
```

### Gradle

```groovy
// build.gradle
dependencies {
    implementation ''org.springframework.boot:spring-boot-starter-web''
}
```

```bash
./gradlew build   # Compiler et packager
./gradlew test    # Lancer les tests
./gradlew bootRun # Démarrer l''application
```

## Récapitulatif des outils

| Outil | Rôle | Commande de base |
|-------|------|-----------------|
| `javac` | Compiler le code source en bytecode | `javac Fichier.java` |
| `java` | Exécuter le bytecode | `java NomClasse` |
| `jar` | Créer une archive exécutable | `jar cf app.jar *.class` |
| Maven | Gérer un projet complet | `mvn package` |
| Gradle | Gérer un projet complet | `./gradlew build` |

Avec un IDE moderne, ces commandes sont exécutées en un seul raccourci. Mais comprendre ce qui se passe en coulisse est essentiel pour diagnostiquer les problèmes et maîtriser Java en profondeur !',
4, 25);

-- ============================================================
-- EXERCICES DU CHAPITRE 1
-- ============================================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index) VALUES
(
  (SELECT id FROM lessons WHERE slug = 'histoire-java'),
  'Hello JavaQuest !',
  'Créez votre tout premier programme Java ! Affichez le message "Bonjour JavaQuest !" dans la console. C''est la grande tradition chez les développeurs Java de commencer par un "Hello World". À vous de jouer !',
  'public class Main {
    public static void main(String[] args) {
        // Affichez "Bonjour JavaQuest !" ici

    }
}',
  'public class Main {
    public static void main(String[] args) {
        System.out.println("Bonjour JavaQuest !");
    }
}',
  'output.contains("Bonjour JavaQuest !")',
  'Utilisez System.out.println() pour afficher du texte dans la console. N''oubliez pas les guillemets autour du texte et le point-virgule à la fin !',
  'EASY', 50, 1
),
(
  (SELECT id FROM lessons WHERE slug = 'jvm-java'),
  'Trois messages JVM',
  'Affichez exactement 3 messages dans la console, chacun sur une ligne séparée :
1. "Java est puissant !"
2. "La JVM est magique !"
3. "J''adore programmer !"

Chaque message doit apparaître sur sa propre ligne.',
  'public class Main {
    public static void main(String[] args) {
        // Affichez les 3 messages sur 3 lignes séparées

    }
}',
  'public class Main {
    public static void main(String[] args) {
        System.out.println("Java est puissant !");
        System.out.println("La JVM est magique !");
        System.out.println("J''adore programmer !");
    }
}',
  'output.contains("Java est puissant !") && output.contains("La JVM est magique !") && output.contains("J''adore programmer !")',
  'Utilisez System.out.println() une fois pour chaque ligne à afficher. Chaque appel crée automatiquement un saut de ligne.',
  'EASY', 50, 2
),
(
  (SELECT id FROM lessons WHERE slug = 'premier-programme'),
  'Carte de visite',
  'Créez un programme qui affiche une mini carte de visite sur 4 lignes. Votre sortie doit contenir exactement ces 4 préfixes :
- Une ligne commençant par "Nom:"
- Une ligne commençant par "Prenom:"
- Une ligne commençant par "Langage:"
- Une ligne commençant par "Niveau:"

Choisissez vos propres valeurs !',
  'public class Main {
    public static void main(String[] args) {
        // Affichez votre carte de visite sur 4 lignes
        // Exemple : System.out.println("Nom: Dupont");

    }
}',
  'public class Main {
    public static void main(String[] args) {
        System.out.println("Nom: Dupont");
        System.out.println("Prenom: Alice");
        System.out.println("Langage: Java");
        System.out.println("Niveau: Debutant");
    }
}',
  'output.contains("Nom:") && output.contains("Prenom:") && output.contains("Langage:") && output.contains("Niveau:")',
  'Chaque System.out.println() affiche une ligne. Commencez chaque appel par le préfixe requis suivi de votre valeur.',
  'EASY', 50, 3
),
(
  (SELECT id FROM lessons WHERE slug = 'compilation-java'),
  'Calculatrice basique',
  'Affichez le résultat de 3 opérations mathématiques. Votre programme doit afficher :
- Le résultat de 10 + 5 (doit afficher 15)
- Le résultat de 20 - 8 (doit afficher 12)
- Le résultat de 6 * 7 (doit afficher 42)

Chaque résultat sur une ligne séparée. Astuce : vous pouvez mettre des calculs directement dans println() !',
  'public class Main {
    public static void main(String[] args) {
        // Calculez et affichez les résultats
        // 10 + 5 :

        // 20 - 8 :

        // 6 * 7 :

    }
}',
  'public class Main {
    public static void main(String[] args) {
        System.out.println(10 + 5);
        System.out.println(20 - 8);
        System.out.println(6 * 7);
    }
}',
  'output.contains("15") && output.contains("12") && output.contains("42")',
  'Vous pouvez écrire des expressions mathématiques directement dans println() : System.out.println(3 + 4) affiche 7. Pas besoin de guillemets pour les nombres !',
  'EASY', 75, 4
);
