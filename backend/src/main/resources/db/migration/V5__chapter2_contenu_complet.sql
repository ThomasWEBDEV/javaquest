-- V5 : Contenu pédagogique complet - Chapitre 2 : Variables et Types

-- Suppression des données existantes du chapitre 2
DELETE FROM exercises WHERE lesson_id IN (SELECT id FROM lessons WHERE chapter_id = 2);
DELETE FROM lessons WHERE chapter_id = 2;

-- ============================================================
-- LEÇONS DU CHAPITRE 2 : Variables et Types
-- ============================================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward) VALUES
(2, 'Les types primitifs en Java', 'types-primitifs',
'# Les types primitifs en Java

## Qu''est-ce qu''un type primitif ?

En Java, une **variable** est un espace mémoire nommé qui stocke une valeur. Avant de pouvoir utiliser une variable, vous devez déclarer son **type** : le genre de données qu''elle va contenir.

Java possède **8 types primitifs** — les briques de base de tout programme. Contrairement aux objets, les types primitifs sont stockés directement en mémoire (dans la pile) et non sous forme de référence.

## Les 8 types primitifs

### Les entiers

| Type | Taille | Plage de valeurs | Exemple d''utilisation |
|------|--------|------------------|-----------------------|
| `byte` | 8 bits | -128 à 127 | Données binaires, petites valeurs |
| `short` | 16 bits | -32 768 à 32 767 | Rarement utilisé |
| `int` | 32 bits | -2 147 483 648 à 2 147 483 647 | **Le plus courant** pour les entiers |
| `long` | 64 bits | -9,2 × 10¹⁸ à 9,2 × 10¹⁸ | Grands nombres (timestamps, ID) |

```java
byte age = 25;           // Pour de petites valeurs entières
short annee = 2024;      // Un entier sur 16 bits
int population = 67_000_000;  // Séparateur _ pour la lisibilité (Java 7+)
long distanceSoleil = 149_597_870_700L;  // Le L est obligatoire pour les long !
```

**Attention** : Sans le suffixe `L`, Java interprète un grand nombre comme un `int` et lève une erreur de compilation si la valeur dépasse 2 147 483 647.

### Les nombres décimaux (flottants)

| Type | Taille | Précision | Utilisation |
|------|--------|-----------|-------------|
| `float` | 32 bits | ~7 chiffres significatifs | Calculs scientifiques simples |
| `double` | 64 bits | ~15 chiffres significatifs | **Le plus courant** pour les décimaux |

```java
float pi = 3.14159f;        // Le f est obligatoire pour les float !
double poids = 72.5;        // double par défaut
double e = 2.718281828459;  // Meilleure précision avec double
```

**Bonne pratique** : Préférez toujours `double` à `float`. La différence de mémoire est négligeable, mais la précision est bien meilleure.

**Piège classique** : Les calculs en virgule flottante ne sont jamais exactement précis !

```java
System.out.println(0.1 + 0.2);  // Affiche : 0.30000000000000004
// Pour les calculs financiers, utilisez BigDecimal !
```

### Le booléen

```java
boolean estConnecte = true;
boolean aFiniExercice = false;
boolean estAdulte = (age >= 18);  // Le résultat d''une comparaison est un boolean
```

Un `boolean` ne peut avoir que deux valeurs : `true` (vrai) ou `false` (faux). Il est essentiel pour les conditions (`if`, `while`...).

### Le caractère

```java
char lettre = ''A'';        // Notez les guillemets simples !
char chiffre = ''7'';
char symbole = ''@'';
char unicode = ''\u00E9''; // é en Unicode
```

Un `char` stocke un seul caractère Unicode entre **guillemets simples** `''''`. Ne confondez pas avec `String` (guillemets doubles) !

## Déclaration et initialisation

```java
// Déclaration seule (la variable existe mais n''a pas de valeur)
int nombre;

// Initialisation (attribution de la première valeur)
nombre = 42;

// Déclaration + initialisation en une seule ligne (recommandé)
int score = 100;
double temperature = 36.6;
boolean enService = true;
char grade = ''A'';
```

**Règle Java** : Une variable locale doit être initialisée avant d''être utilisée, sinon le compilateur lève une erreur.

```java
int x;
System.out.println(x);  // ERREUR : variable x might not have been initialized
```

## Les constantes : le mot-clé `final`

Pour déclarer une valeur qui ne changera jamais, utilisez `final` :

```java
final int MAX_JOUEURS = 4;
final double TVA = 0.20;
final int ANNEE_NAISSANCE = 1991;

MAX_JOUEURS = 5;  // ERREUR : cannot assign a value to final variable
```

**Convention** : Les constantes sont nommées en `MAJUSCULES_AVEC_UNDERSCORES`.

## Portée des variables (scope)

Une variable n''existe que dans le **bloc** où elle est déclarée :

```java
public static void main(String[] args) {
    int x = 10;  // x est visible dans tout main()

    {
        int y = 20;  // y n''est visible que dans ce bloc
        System.out.println(x + y);  // OK : 30
    }

    System.out.println(x);  // OK : 10
    System.out.println(y);  // ERREUR : y n''existe plus !
}
```

## Valeurs par défaut des champs de classe

Pour les attributs de classe (pas les variables locales), Java fournit des valeurs par défaut :

| Type | Valeur par défaut |
|------|------------------|
| `int`, `long`, `short`, `byte` | `0` |
| `float`, `double` | `0.0` |
| `boolean` | `false` |
| `char` | `''\u0000''` (caractère nul) |
| Objets (String, etc.) | `null` |

## Choisir le bon type

En pratique, voici les choix les plus courants :
- Nombre entier → `int` (ou `long` si > 2 milliards)
- Nombre décimal → `double`
- Vrai/Faux → `boolean`
- Caractère unique → `char`
- Texte → `String` (ce n''est pas un type primitif, mais le plus utilisé !)

Maîtriser les types primitifs est la première étape pour écrire du code Java correct et efficace.',
1, 30),

(2, 'String et chaînes de caractères', 'strings-java',
'# String et chaînes de caractères

## Qu''est-ce qu''une String ?

En Java, `String` est une **classe** (pas un type primitif) qui représente une chaîne de caractères. C''est probablement le type le plus utilisé dans tout programme Java.

```java
String prenom = "Alice";
String message = "Bonjour le monde !";
String vide = "";          // Chaîne vide (pas null !)
String multiligne = "Ligne 1\nLigne 2\nLigne 3";  // \n = saut de ligne
```

## Déclaration et création

Il existe deux façons de créer une String :

```java
// Méthode 1 : Littéral (RECOMMANDÉ — utilise le String Pool)
String s1 = "Bonjour";

// Méthode 2 : new String (évitez cette façon, moins efficace)
String s2 = new String("Bonjour");
```

**Le String Pool** : Java optimise la mémoire en réutilisant les littéraux String identiques. Deux variables initialisées avec `"Bonjour"` pointent vers le même objet en mémoire.

## Concaténation : assembler des chaînes

L''opérateur `+` permet d''assembler plusieurs chaînes et valeurs :

```java
String prenom = "Alice";
int age = 25;

// Concaténation classique avec +
String message = "Je m''appelle " + prenom + " et j''ai " + age + " ans.";
System.out.println(message);
// Affiche : Je m''appelle Alice et j''ai 25 ans.

// Java convertit automatiquement les types primitifs en String lors de la concaténation
System.out.println("Score : " + 42);        // Affiche : Score : 42
System.out.println("Pi = " + 3.14);        // Affiche : Pi = 3.14
System.out.println("Actif : " + true);     // Affiche : Actif : true
```

**Astuce moderne** : Utilisez `String.format()` ou les text blocks (Java 13+) pour un code plus lisible :

```java
// String.format() — style printf
String phrase = String.format("Je m''appelle %s et j''ai %d ans.", prenom, age);

// Text block (Java 15+) — pour les strings multilignes
String json = """
        {
            "prenom": "Alice",
            "age": 25
        }
        """;
```

## Les méthodes essentielles de String

`String` offre une riche bibliothèque de méthodes. Voici les plus importantes :

### Longueur et caractères

```java
String mot = "JavaQuest";

int longueur = mot.length();          // 9
char premier = mot.charAt(0);         // ''J''
char dernier = mot.charAt(mot.length() - 1);  // ''t''
int position = mot.indexOf("Quest");  // 4 (index de la sous-chaîne)
```

### Comparaison

```java
String a = "bonjour";
String b = "BONJOUR";

// JAMAIS utiliser == pour comparer des String !
boolean mauvais = (a == b);                    // false (compare les références)

// Toujours utiliser .equals()
boolean correct = a.equals(b);                 // false (sensible à la casse)
boolean ignoreCase = a.equalsIgnoreCase(b);    // true (ignore la casse)
int comparison = a.compareTo(b);               // ordre lexicographique
```

### Transformation

```java
String texte = "  Bonjour Java !  ";

String majuscules = texte.toUpperCase();    // "  BONJOUR JAVA !  "
String minuscules = texte.toLowerCase();    // "  bonjour java !  "
String sansEspaces = texte.trim();          // "Bonjour Java !" (espaces retirés)
String sansEspacesStrict = texte.strip();   // Identique, mais supporte Unicode

String remplace = texte.replace("Java", "JavaQuest");
// "  Bonjour JavaQuest !  "
```

### Extraction et découpage

```java
String phrase = "Alice,Bob,Charlie,David";

String sousChaine = phrase.substring(0, 5);  // "Alice"
String[] parties = phrase.split(",");         // ["Alice", "Bob", "Charlie", "David"]

String[] mots = "Je code en Java".split(" "); // Découpe par espaces
// mots[0] = "Je", mots[1] = "code", mots[2] = "en", mots[3] = "Java"
```

### Vérifications

```java
String email = "alice@example.com";

boolean estVide = email.isEmpty();              // false
boolean estBlanche = "   ".isBlank();           // true (Java 11+)
boolean commence = email.startsWith("alice");   // true
boolean finit = email.endsWith(".com");         // true
boolean contient = email.contains("@");         // true
```

## L''immuabilité des String

Un concept fondamental : les `String` en Java sont **immuables** (immutables). Une fois créée, une String ne peut pas être modifiée.

```java
String message = "Bonjour";
message.toUpperCase();  // Ne modifie PAS message !
System.out.println(message);  // Affiche toujours : Bonjour

// Il faut récupérer la nouvelle String :
message = message.toUpperCase();
System.out.println(message);  // Maintenant : BONJOUR
```

## StringBuilder : pour les manipulations intensives

Si vous devez construire une String par de nombreuses concaténations dans une boucle, utilisez `StringBuilder` pour de meilleures performances :

```java
// Moins efficace (crée plein d''objets String intermédiaires)
String result = "";
for (int i = 0; i < 1000; i++) {
    result = result + i + ", ";  // Mauvaise pratique en boucle !
}

// Beaucoup plus efficace
StringBuilder sb = new StringBuilder();
for (int i = 0; i < 1000; i++) {
    sb.append(i).append(", ");
}
String result = sb.toString();
```

## Les caractères d''échappement

Pour inclure des caractères spéciaux dans une String :

| Séquence | Caractère | Exemple |
|----------|-----------|---------|
| `\n` | Saut de ligne | `"Ligne1\nLigne2"` |
| `\t` | Tabulation | `"Col1\tCol2"` |
| `\\` | Antislash | `"C:\\Users\\Alice"` |
| `\"` | Guillemet double | `"Il dit \"Bonjour\""` |
| `\'` | Guillemet simple | `''A\'''` |

```java
System.out.println("Colonne1\tColonne2\tColonne3");
System.out.println("Chemin : C:\\Program Files\\Java");
System.out.println("Il a dit : \"Bonjour !\"");
```

Maîtriser la classe `String` est indispensable : vous l''utiliserez dans pratiquement chaque programme Java que vous écrirez !',
2, 30),

(2, 'Opérateurs arithmétiques et logiques', 'operateurs-java',
'# Opérateurs arithmétiques et logiques

## Les opérateurs arithmétiques

Les opérateurs arithmétiques permettent d''effectuer des calculs mathématiques sur des valeurs numériques.

### Opérateurs de base

| Opérateur | Opération | Exemple | Résultat |
|-----------|-----------|---------|----------|
| `+` | Addition | `5 + 3` | `8` |
| `-` | Soustraction | `10 - 4` | `6` |
| `*` | Multiplication | `6 * 7` | `42` |
| `/` | Division | `15 / 4` | `3` (division entière !) |
| `%` | Modulo (reste) | `17 % 5` | `2` |

```java
int a = 17;
int b = 5;

System.out.println(a + b);   // 22
System.out.println(a - b);   // 12
System.out.println(a * b);   // 85
System.out.println(a / b);   // 3 (pas 3.4 !)
System.out.println(a % b);   // 2 (car 17 = 3×5 + 2)
```

### La division entière : attention !

En Java, diviser deux `int` donne un `int` (la partie décimale est **tronquée**, pas arrondie) :

```java
int resultat = 7 / 2;    // 3 (pas 3.5 !)
double exact = 7.0 / 2;  // 3.5 (conversion automatique si l''un est double)
double aussi = 7 / 2.0;  // 3.5
double cast = (double) 7 / 2;  // 3.5 (cast explicite)
```

### Le modulo `%` : un opérateur très utile

Le modulo donne le **reste** de la division euclidienne. Ses utilisations classiques :

```java
// Vérifier si un nombre est pair ou impair
int n = 42;
if (n % 2 == 0) {
    System.out.println(n + " est pair");
} else {
    System.out.println(n + " est impair");
}

// Rester dans les bornes d''un tableau circulaire
int index = (index + 1) % tableau.length;

// Extraire les chiffres d''un nombre
int nombre = 12345;
int chiffresUnites = nombre % 10;      // 5
int chiffresDizaines = (nombre / 10) % 10;  // 4
```

### Priorité des opérateurs

Java respecte les règles mathématiques de priorité :

```java
int resultat = 2 + 3 * 4;    // 14 (pas 20 !) — la multiplication est prioritaire
int avec = (2 + 3) * 4;      // 20 — les parenthèses forcent l''ordre
int complexe = 10 + 6 / 2 - 1;  // 12 (10 + 3 - 1)
```

**Ordre de priorité** (du plus au moins prioritaire) : `()` > `*`, `/`, `%` > `+`, `-`

### Opérateurs d''affectation composée

Ces raccourcis modifient la valeur d''une variable :

```java
int score = 100;
score += 50;   // Équivalent à : score = score + 50  → 150
score -= 20;   // score = score - 20  → 130
score *= 2;    // score = score * 2   → 260
score /= 4;    // score = score / 4   → 65
score %= 10;   // score = score % 10  → 5
```

### Incrémentation et décrémentation

```java
int compteur = 5;

compteur++;   // Post-incrémentation : utilise la valeur PUIS incrémente → 6
++compteur;   // Pré-incrémentation  : incrémente PUIS utilise la valeur → 7
compteur--;   // Post-décrémentation → 6
--compteur;   // Pré-décrémentation  → 5

// La différence pré/post n''importe que dans une expression :
int x = 5;
int a = x++;  // a = 5, x devient 6 (x est utilisé avant d''être incrémenté)
int b = ++x;  // b = 7, x reste 7 (x est incrémenté avant d''être utilisé)
```

## Les opérateurs de comparaison

Ces opérateurs comparent deux valeurs et retournent un `boolean` (`true` ou `false`) :

| Opérateur | Signification | Exemple | Résultat |
|-----------|---------------|---------|----------|
| `==` | Égal à | `5 == 5` | `true` |
| `!=` | Différent de | `5 != 3` | `true` |
| `>` | Supérieur à | `8 > 5` | `true` |
| `<` | Inférieur à | `3 < 1` | `false` |
| `>=` | Supérieur ou égal | `5 >= 5` | `true` |
| `<=` | Inférieur ou égal | `4 <= 3` | `false` |

```java
int age = 20;
boolean estAdulte = age >= 18;    // true
boolean estMineur = age < 18;     // false
boolean exactement20 = age == 20; // true
```

**Ne jamais utiliser `==` pour comparer des String !** Utilisez `.equals()`.

## Les opérateurs logiques

Permettent de combiner plusieurs conditions :

| Opérateur | Nom | Signification | Exemple |
|-----------|-----|---------------|---------|
| `&&` | ET logique | Vrai si LES DEUX sont vrais | `age >= 18 && age <= 65` |
| `\|\|` | OU logique | Vrai si AU MOINS UN est vrai | `role == "admin" \|\| role == "moderateur"` |
| `!` | NON logique | Inverse le booléen | `!estConnecte` |

```java
int age = 25;
double salaire = 35000.0;
boolean estEmploye = true;

// ET : les deux conditions doivent être vraies
boolean eligibleCredit = estEmploye && salaire >= 30000 && age >= 21;

// OU : au moins une condition doit être vraie
boolean acces = role.equals("admin") || role.equals("manager");

// NON : inverse la condition
boolean estInactif = !estConnecte;
```

### Court-circuit (short-circuit evaluation)

Java optimise les opérateurs `&&` et `||` : si le résultat est déterminé par le premier opérande, le second n''est pas évalué :

```java
// Si liste est null, liste.size() n''est PAS appelé (évite NullPointerException)
if (liste != null && liste.size() > 0) {
    // traitement sûr
}

// Si utilisateur n''est pas null, la deuxième condition est inutile
if (utilisateur == null || utilisateur.estInactif()) {
    // accès refusé
}
```

## L''opérateur ternaire

Un raccourci élégant pour les `if/else` simples :

```java
// Syntaxe : condition ? valeurSiVrai : valeurSiFaux
int max = (a > b) ? a : b;

String statut = (age >= 18) ? "Adulte" : "Mineur";

// Évitez les ternaires imbriqués (difficiles à lire) :
// Mal : String note = (score >= 90) ? "A" : (score >= 80) ? "B" : "C";
```

Maîtriser ces opérateurs vous permettra d''écrire des calculs, des conditions et de la logique métier dans vos programmes Java !',
3, 30),

(2, 'Casting et conversions de types', 'casting-java',
'# Casting et conversions de types

## Pourquoi convertir des types ?

En Java, chaque variable a un type précis. Parfois, vous devez convertir une valeur d''un type vers un autre : par exemple, diviser deux entiers et obtenir un résultat décimal, ou récupérer un nombre saisi par l''utilisateur sous forme de `String`.

Il existe deux grandes catégories de conversions : la conversion **automatique** (implicite) et le **casting** (explicite).

## Conversion implicite (Widening)

La conversion implicite, ou **widening** (élargissement), se fait automatiquement quand on passe d''un type à capacité plus petite vers un type à capacité plus grande. Il n''y a pas de risque de perte de données.

**Hiérarchie des conversions implicites** :
```
byte → short → int → long → float → double
                              char ↗
```

```java
// Java convertit automatiquement sans que vous demandiez rien
byte b = 42;
short s = b;        // byte → short : OK automatiquement
int i = s;          // short → int : OK
long l = i;         // int → long : OK
float f = l;        // long → float : OK (attention : légère perte de précision possible)
double d = f;       // float → double : OK

// En pratique, le cas le plus courant :
int entier = 10;
double decimal = entier;  // int → double : automatique
System.out.println(decimal);  // 10.0
```

**Cas fréquent avec les calculs** :

```java
int a = 7;
int b = 2;
double resultat = a / b;         // PIÈGE : 3.0 ! Division entière d''abord
double correct = (double) a / b; // 3.5 — casting explicite nécessaire
```

## Casting explicite (Narrowing)

Le **casting** (ou **narrowing** — rétrécissement) est une conversion manuelle vers un type de plus petite capacité. Elle peut causer une **perte de données** ou de précision, donc Java vous oblige à l''écrire explicitement pour montrer que vous êtes conscient du risque.

**Syntaxe** : `(typeVoulu) valeur`

```java
double pi = 3.14159;
int piEntier = (int) pi;          // 3 (la partie décimale est TRONQUÉE, pas arrondie)
System.out.println(piEntier);     // 3

long grandNombre = 1_234_567_890_123L;
int petitInt = (int) grandNombre; // Troncature ! Résultat imprévisible
System.out.println(petitInt);     // -539222987 (overflow !)

double temperature = 36.7;
int tempEntiere = (int) temperature;  // 36
```

**Arrondi vs troncature** :

```java
double d = 3.9;
int tronque = (int) d;                          // 3 (jamais 4 !)
int arrondi = (int) Math.round(d);              // 4 (utilise Math.round)
long arrondiLong = Math.round(d);               // 4L
```

## Conversions String ↔ Types primitifs

Ces conversions sont extrêmement fréquentes, notamment quand on lit des données utilisateur.

### String → Type primitif (parsing)

```java
// Chaque type primitif a sa classe Wrapper avec une méthode parse
String texte = "42";
int nombre = Integer.parseInt(texte);       // String → int
long grand = Long.parseLong("9876543210");  // String → long
double decimal = Double.parseDouble("3.14");// String → double
boolean bool = Boolean.parseBoolean("true");// String → boolean (insensible à la casse)

// Gestion des erreurs : si la String n''est pas un nombre valide
try {
    int erreur = Integer.parseInt("bonjour"); // Lance NumberFormatException !
} catch (NumberFormatException e) {
    System.out.println("Ce n''est pas un nombre valide");
}
```

### Type primitif → String

```java
// Méthode 1 : concaténation avec "" (simple et idiomatique)
int score = 100;
String scoreStr = "" + score;   // "100"

// Méthode 2 : String.valueOf() (plus explicite, recommandé)
String s1 = String.valueOf(42);       // "42"
String s2 = String.valueOf(3.14);     // "3.14"
String s3 = String.valueOf(true);     // "true"

// Méthode 3 : méthodes des classes Wrapper
String s4 = Integer.toString(42);     // "42"
String s5 = Double.toString(3.14);    // "3.14"
```

## Les classes Wrapper (classes enveloppes)

Chaque type primitif a une **classe Wrapper** correspondante qui offre des méthodes utiles :

| Type primitif | Classe Wrapper | Utilité principale |
|---------------|---------------|-------------------|
| `int` | `Integer` | `parseInt()`, `MAX_VALUE`, `MIN_VALUE` |
| `long` | `Long` | `parseLong()`, opérations sur les bits |
| `double` | `Double` | `parseDouble()`, `isNaN()`, `isInfinite()` |
| `boolean` | `Boolean` | `parseBoolean()` |
| `char` | `Character` | `isDigit()`, `isLetter()`, `toUpperCase()` |

```java
// Valeurs limites
System.out.println(Integer.MAX_VALUE);   // 2147483647
System.out.println(Integer.MIN_VALUE);   // -2147483648
System.out.println(Double.MAX_VALUE);    // 1.7976931348623157E308

// Méthodes utiles de Character
char c = ''A'';
boolean estLettre = Character.isLetter(c);    // true
boolean estChiffre = Character.isDigit(c);    // false
char minuscule = Character.toLowerCase(c);    // ''a''

// Autoboxing / Unboxing (Java 5+) : conversion automatique primitif ↔ Wrapper
Integer obj = 42;           // Autoboxing : int → Integer (automatique)
int prim = obj;             // Unboxing : Integer → int (automatique)
```

## Conversions courantes et pièges à éviter

```java
// PIÈGE 1 : Division entière
int a = 5, b = 2;
double mauvais = a / b;        // 2.0 (division entière d''abord !)
double correct = (double)a / b; // 2.5

// PIÈGE 2 : Overflow silencieux
int max = Integer.MAX_VALUE;  // 2147483647
int overflow = max + 1;       // -2147483648 (overflow sans erreur !)

// PIÈGE 3 : Perte de précision float
float f = 1234567890.1234f;
System.out.println(f);  // 1.23456794E9 (perdu de la précision !)

// BONNE PRATIQUE : Pour les calculs financiers
import java.math.BigDecimal;
BigDecimal montant = new BigDecimal("19.99");
BigDecimal taxe = new BigDecimal("0.20");
BigDecimal total = montant.add(montant.multiply(taxe));
```

Comprendre les conversions de types vous évitera des bugs subtils et vous permettra d''écrire du code Java précis et fiable !',
4, 30);

-- ============================================================
-- EXERCICES DU CHAPITRE 2
-- ============================================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index) VALUES
(
  (SELECT id FROM lessons WHERE slug = 'types-primitifs'),
  'Déclarer et afficher des variables',
  'Déclarez les variables suivantes et affichez-les, chacune sur une ligne :
- Un entier `age` valant 25
- Un nombre décimal `taille` valant 1.75
- Un booléen `estEtudiant` valant true
- Un caractère `initiale` valant ''J''

Format attendu (chaque ligne) : "age: 25", "taille: 1.75", "estEtudiant: true", "initiale: J"',
  'public class Main {
    public static void main(String[] args) {
        // Déclarez vos 4 variables ici

        // Puis affichez-les au format "nomVariable: valeur"

    }
}',
  'public class Main {
    public static void main(String[] args) {
        int age = 25;
        double taille = 1.75;
        boolean estEtudiant = true;
        char initiale = ''J'';

        System.out.println("age: " + age);
        System.out.println("taille: " + taille);
        System.out.println("estEtudiant: " + estEtudiant);
        System.out.println("initiale: " + initiale);
    }
}',
  'output.contains("age: 25") && output.contains("taille: 1.75") && output.contains("estEtudiant: true") && output.contains("initiale: J")',
  'Déclarez chaque variable avec son type : "int age = 25;". Pour afficher, utilisez la concaténation : System.out.println("age: " + age);',
  'EASY', 60, 1
),
(
  (SELECT id FROM lessons WHERE slug = 'operateurs-java'),
  'Calculs arithmétiques',
  'Déclarez deux entiers a = 15 et b = 4, puis affichez le résultat de ces 5 opérations, chacune sur une ligne :
- La somme (a + b)
- La différence (a - b)
- Le produit (a * b)
- Le quotient entier (a / b)
- Le reste de la division (a % b)',
  'public class Main {
    public static void main(String[] args) {
        int a = 15;
        int b = 4;

        // Calculez et affichez les 5 résultats

    }
}',
  'public class Main {
    public static void main(String[] args) {
        int a = 15;
        int b = 4;

        System.out.println(a + b);
        System.out.println(a - b);
        System.out.println(a * b);
        System.out.println(a / b);
        System.out.println(a % b);
    }
}',
  'output.contains("19") && output.contains("11") && output.contains("60") && output.contains("3") && output.contains("3")',
  'Vous pouvez mettre des expressions directement dans println(). 15 / 4 = 3 en division entière (pas 3.75 !). 15 % 4 = 3 (reste de 15÷4 = 3×4 + 3).',
  'EASY', 60, 2
),
(
  (SELECT id FROM lessons WHERE slug = 'strings-java'),
  'Manipulation de String',
  'Déclarez une variable `prenom` avec la valeur "alice" (en minuscules), puis affichez :
1. Le prénom en MAJUSCULES
2. La longueur du prénom (nombre de caractères)
3. Le prénom avec la première lettre en majuscule (capitalize) : concaténez charAt(0) en majuscule avec substring(1)
4. true si le prénom contient la lettre "l"',
  'public class Main {
    public static void main(String[] args) {
        String prenom = "alice";

        // 1. En majuscules

        // 2. Longueur

        // 3. Première lettre en majuscule + reste

        // 4. Contient "l" ?

    }
}',
  'public class Main {
    public static void main(String[] args) {
        String prenom = "alice";

        System.out.println(prenom.toUpperCase());
        System.out.println(prenom.length());
        System.out.println(Character.toUpperCase(prenom.charAt(0)) + prenom.substring(1));
        System.out.println(prenom.contains("l"));
    }
}',
  'output.contains("ALICE") && output.contains("5") && output.contains("Alice") && output.contains("true")',
  'Utilisez : toUpperCase(), length(), charAt(0) avec Character.toUpperCase(), substring(1), et contains(). Chaque méthode retourne une valeur que vous pouvez afficher directement.',
  'EASY', 75, 3
),
(
  (SELECT id FROM lessons WHERE slug = 'casting-java'),
  'Conversions de types',
  'Effectuez et affichez ces 3 conversions :
1. Convertissez le double `prix = 9.99` en int (troncature) et affichez le résultat
2. Convertissez l''int `annee = 2024` en String et affichez sa longueur (doit afficher 4)
3. Parsez la String `"123"` en int, ajoutez 7, et affichez le résultat (doit afficher 130)',
  'public class Main {
    public static void main(String[] args) {
        double prix = 9.99;
        int annee = 2024;
        String nombre = "123";

        // 1. Convertissez prix en int et affichez

        // 2. Convertissez annee en String et affichez sa longueur

        // 3. Parsez nombre, ajoutez 7, affichez le résultat

    }
}',
  'public class Main {
    public static void main(String[] args) {
        double prix = 9.99;
        int annee = 2024;
        String nombre = "123";

        System.out.println((int) prix);
        System.out.println(String.valueOf(annee).length());
        System.out.println(Integer.parseInt(nombre) + 7);
    }
}',
  'output.contains("9") && output.contains("4") && output.contains("130")',
  '1. Utilisez (int) pour caster un double en int. 2. String.valueOf() convertit un int en String, puis .length() donne la longueur. 3. Integer.parseInt() convertit une String en int.',
  'MEDIUM', 90, 4
);
