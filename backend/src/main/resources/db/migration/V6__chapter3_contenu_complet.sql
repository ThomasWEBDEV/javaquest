-- V6 : Contenu pédagogique complet - Chapitre 3 : Structures de Contrôle

-- Suppression des données existantes du chapitre 3
DELETE FROM exercises WHERE lesson_id IN (SELECT id FROM lessons WHERE chapter_id = 3);
DELETE FROM lessons WHERE chapter_id = 3;

-- ============================================================
-- LEÇONS DU CHAPITRE 3 : Structures de Contrôle
-- ============================================================

INSERT INTO lessons (chapter_id, title, slug, content, order_index, xp_reward) VALUES
(3, 'if, else et conditions', 'conditions-java',
'# if, else et conditions

## Pourquoi les structures conditionnelles ?

Un programme qui exécute toujours les mêmes instructions dans le même ordre ne peut pas faire grand-chose d''utile. Les **structures conditionnelles** permettent à votre programme de prendre des décisions : faire une chose dans certains cas, autre chose dans d''autres cas.

C''est la base de toute logique de programmation.

## La structure `if`

La structure la plus simple : exécuter un bloc **seulement si** une condition est vraie.

```java
// Syntaxe
if (condition) {
    // Instructions exécutées si la condition est true
}

// Exemple
int age = 20;
if (age >= 18) {
    System.out.println("Vous êtes majeur.");
}
// Si age est inférieur à 18, rien ne s''affiche
```

La **condition** est une expression qui s''évalue en `boolean` (`true` ou `false`). Elle est toujours entourée de parenthèses.

## La structure `if / else`

Pour exécuter une chose si la condition est vraie, et **autre chose** si elle est fausse :

```java
int age = 15;

if (age >= 18) {
    System.out.println("Vous pouvez voter.");
} else {
    System.out.println("Vous ne pouvez pas encore voter.");
}
// Affiche : Vous ne pouvez pas encore voter.
```

Le bloc `else` est optionnel. Il ne s''exécute que si la condition du `if` est `false`.

## La structure `if / else if / else`

Pour tester plusieurs conditions en cascade :

```java
int score = 72;
String mention;

if (score >= 90) {
    mention = "Excellent";
} else if (score >= 80) {
    mention = "Très bien";
} else if (score >= 70) {
    mention = "Bien";
} else if (score >= 60) {
    mention = "Passable";
} else {
    mention = "Insuffisant";
}

System.out.println("Mention : " + mention);
// Affiche : Mention : Bien
```

**Ordre important** : Java teste les conditions dans l''ordre. Dès qu''une condition est `true`, son bloc est exécuté et les autres `else if` sont ignorés.

## Les conditions imbriquées

On peut imbriquer des `if` dans d''autres `if` :

```java
boolean estConnecte = true;
String role = "admin";

if (estConnecte) {
    if (role.equals("admin")) {
        System.out.println("Accès au panneau d''administration");
    } else {
        System.out.println("Accès utilisateur standard");
    }
} else {
    System.out.println("Veuillez vous connecter");
}
```

**Bonne pratique** : Évitez une imbrication trop profonde (> 3 niveaux). Cela rend le code difficile à lire. Utilisez des conditions combinées avec `&&` et `||` quand c''est possible.

## Combiner les conditions

```java
int temperature = 25;
boolean soleil = true;

// ET logique : les deux doivent être vraies
if (temperature > 20 && soleil) {
    System.out.println("Parfait pour aller à la plage !");
}

// OU logique : au moins une doit être vraie
if (temperature < 0 || temperature > 40) {
    System.out.println("Conditions extrêmes !");
}

// NON logique : inverse la condition
boolean pluie = false;
if (!pluie) {
    System.out.println("Pas de pluie, sortons !");
}
```

## L''opérateur ternaire : if/else en une ligne

Pour des conditions simples, l''opérateur ternaire est très pratique :

```java
// Syntaxe : condition ? valeurSiVrai : valeurSiFaux
int a = 10, b = 20;
int max = (a > b) ? a : b;
System.out.println("Maximum : " + max);  // Maximum : 20

String statut = (age >= 18) ? "Adulte" : "Mineur";
```

## Pièges courants

### Le `=` au lieu de `==`

```java
int x = 5;
if (x = 10) { // ERREUR de compilation ! = n''est pas une condition
if (x == 10) { // CORRECT : comparaison
```

### Comparer des String

```java
String nom = "Alice";
if (nom == "Alice") { // DANGEREUX ! Compare les références, pas les valeurs
if (nom.equals("Alice")) { // CORRECT : compare les contenus
if ("Alice".equals(nom)) { // ENCORE MIEUX : évite NullPointerException si nom est null
```

### Les accolades optionnelles (déconseillé)

```java
// Sans accolades : seulement l''instruction suivante est dans le if
if (condition)
    System.out.println("Dans le if");
    System.out.println("TOUJOURS exécuté !");  // PAS dans le if !

// Avec accolades : toujours préférable
if (condition) {
    System.out.println("Dans le if");
    System.out.println("Aussi dans le if");
}
```

**Bonne pratique** : Mettez toujours des accolades, même pour une seule instruction. Cela évite les bugs lors de futures modifications.

## Exemple complet : calculateur de remise

```java
double prix = 150.0;
int quantite = 5;
String typeClient = "premium";
double remise = 0;

if (typeClient.equals("premium")) {
    remise = 0.20;  // 20% pour les clients premium
} else if (quantite >= 10) {
    remise = 0.15;  // 15% pour les commandes de 10+
} else if (quantite >= 5) {
    remise = 0.10;  // 10% pour les commandes de 5+
} else {
    remise = 0.0;   // Pas de remise
}

double total = prix * quantite * (1 - remise);
System.out.printf("Total avec %.0f%% de remise : %.2f€%n",
    remise * 100, total);
// Affiche : Total avec 20% de remise : 600,00€
```

Maîtriser les structures conditionnelles est indispensable — elles sont présentes dans pratiquement toutes les méthodes Java que vous écrirez !',
1, 35),

(3, 'L''instruction switch', 'switch-java',
'# L''instruction switch

## Pourquoi utiliser switch ?

Quand vous devez comparer une même variable à de nombreuses valeurs possibles, enchaîner des `if / else if` devient vite laborieux et difficile à lire :

```java
// Avec if/else : verbeux pour beaucoup de cas
if (jour == 1) {
    System.out.println("Lundi");
} else if (jour == 2) {
    System.out.println("Mardi");
} else if (jour == 3) {
    System.out.println("Mercredi");
// ... 4 autres else if ...
```

L''instruction `switch` est bien plus élégante pour ce cas.

## La syntaxe classique de switch

```java
int jour = 3;

switch (jour) {
    case 1:
        System.out.println("Lundi");
        break;
    case 2:
        System.out.println("Mardi");
        break;
    case 3:
        System.out.println("Mercredi");
        break;
    case 4:
        System.out.println("Jeudi");
        break;
    case 5:
        System.out.println("Vendredi");
        break;
    case 6:
        System.out.println("Samedi");
        break;
    case 7:
        System.out.println("Dimanche");
        break;
    default:
        System.out.println("Numéro de jour invalide");
}
// Affiche : Mercredi
```

## Les éléments clés

### `switch (expression)`
L''expression peut être de type : `int`, `byte`, `short`, `char`, `String`, ou une **enum**.

### `case valeur:`
Définit un cas à tester. Si l''expression correspond à la valeur, l''exécution commence ici.

### `break`
**Crucial !** Arrête l''exécution du switch et passe à la suite du code. Sans `break`, l''exécution continue dans le cas suivant (**fall-through**).

### `default`
Cas par défaut, exécuté si aucun `case` ne correspond. Similaire au `else` final.

## Le fall-through : un comportement à connaître

Sans `break`, Java continue l''exécution dans les cases suivants — c''est le **fall-through** :

```java
int n = 2;
switch (n) {
    case 1:
        System.out.println("un");  // N''est pas exécuté
    case 2:
        System.out.println("deux"); // Exécuté
    case 3:
        System.out.println("trois"); // Aussi exécuté (fall-through !)
    default:
        System.out.println("autre"); // Aussi exécuté !
}
// Affiche : deux, trois, autre (pas de break !)
```

Le fall-through peut être utilisé intentionnellement pour regrouper des cas :

```java
int mois = 4; // Avril
int jours;

switch (mois) {
    case 1: case 3: case 5:
    case 7: case 8: case 10: case 12:
        jours = 31;
        break;
    case 4: case 6:
    case 9: case 11:
        jours = 30;
        break;
    case 2:
        jours = 28; // Simplifié, sans les années bissextiles
        break;
    default:
        jours = -1;
}
System.out.println("Mois " + mois + " : " + jours + " jours");
// Affiche : Mois 4 : 30 jours
```

## switch avec des String (Java 7+)

Depuis Java 7, les `String` sont supportées dans switch :

```java
String saison = "été";

switch (saison) {
    case "printemps":
        System.out.println("Les fleurs éclosent.");
        break;
    case "été":
        System.out.println("Il fait chaud, direction la plage !");
        break;
    case "automne":
        System.out.println("Les feuilles tombent.");
        break;
    case "hiver":
        System.out.println("Il neige peut-être...");
        break;
    default:
        System.out.println("Saison inconnue");
}
```

**Attention** : La comparaison est sensible à la casse. `"Été"` ne correspond pas à `"été"`.

## Switch Expression (Java 14+)

Java 14 a introduit une syntaxe moderne plus concise et sans risque de fall-through accidentel :

```java
// Ancienne syntaxe
String typeJour;
switch (jour) {
    case 6: case 7:
        typeJour = "Weekend";
        break;
    default:
        typeJour = "Semaine";
}

// Nouvelle syntaxe (switch expression avec ->)
String typeJour = switch (jour) {
    case 6, 7 -> "Weekend";
    default -> "Semaine";
};

// Avec des blocs pour la logique complexe
String description = switch (saison) {
    case "été" -> {
        System.out.println("Calcul de l''été...");
        yield "Chaud et ensoleillé";  // yield remplace return dans un switch
    }
    case "hiver" -> "Froid et enneigé";
    default -> "Autre saison";
};
```

## Quand utiliser switch vs if/else ?

| Cas | Recommandation |
|-----|----------------|
| Comparer une variable à plusieurs valeurs fixes | **switch** |
| Conditions avec des plages (`age >= 18`) | **if/else** |
| Conditions combinées (`a > 0 && b < 10`) | **if/else** |
| Plus de 5 cas sur la même variable | **switch** |
| Types `String`, `int`, `char`, `enum` | **switch** possible |

## Exemple complet : simulateur de menu

```java
int choix = 2;

System.out.println("=== Menu JavaQuest ===");
System.out.println("1. Nouvelle leçon");
System.out.println("2. Mes progrès");
System.out.println("3. Classement");
System.out.println("4. Quitter");

switch (choix) {
    case 1:
        System.out.println("Chargement de la prochaine leçon...");
        break;
    case 2:
        System.out.println("Affichage de vos progrès...");
        break;
    case 3:
        System.out.println("Chargement du classement...");
        break;
    case 4:
        System.out.println("À bientôt !");
        break;
    default:
        System.out.println("Option invalide. Choisissez entre 1 et 4.");
}
```

L''instruction `switch` est un outil puissant pour rendre votre code plus lisible et maintenable quand vous gérez de nombreux cas discrets !',
2, 35),

(3, 'La boucle for', 'boucle-for',
'# La boucle for

## Pourquoi les boucles ?

Imaginez devoir afficher les nombres de 1 à 100. Écrire 100 `System.out.println()` serait absurde ! Les **boucles** permettent de répéter un bloc d''instructions un certain nombre de fois.

La boucle `for` est la plus utilisée quand on sait à l''avance **combien de fois** on veut répéter.

## La syntaxe de base

```java
for (initialisation; condition; mise_à_jour) {
    // Instructions répétées
}
```

Les trois parties séparées par `;` :
1. **Initialisation** : exécutée une seule fois au début (souvent `int i = 0`)
2. **Condition** : testée avant chaque itération — si `false`, la boucle s''arrête
3. **Mise à jour** : exécutée après chaque itération (souvent `i++`)

## Exemples fondamentaux

```java
// Afficher les nombres de 1 à 5
for (int i = 1; i <= 5; i++) {
    System.out.println(i);
}
// Affiche : 1, 2, 3, 4, 5

// Afficher les nombres pairs de 0 à 10
for (int i = 0; i <= 10; i += 2) {
    System.out.println(i);
}
// Affiche : 0, 2, 4, 6, 8, 10

// Décompte : de 5 à 1
for (int i = 5; i >= 1; i--) {
    System.out.print(i + " ");
}
System.out.println("Décollage !");
// Affiche : 5 4 3 2 1 Décollage !
```

## Suivre l''exécution pas à pas

Traçons l''exécution de `for (int i = 0; i < 3; i++)` :

| Étape | i | Condition `i < 3` | Corps exécuté ? | Après |
|-------|---|-------------------|-----------------|-------|
| Début | 0 | 0 < 3 = true | Oui | i = 1 |
| Tour 2 | 1 | 1 < 3 = true | Oui | i = 2 |
| Tour 3 | 2 | 2 < 3 = true | Oui | i = 3 |
| Fin | 3 | 3 < 3 = false | Non — sortie | — |

**Total : 3 itérations** (i = 0, 1, 2)

## Utiliser la variable de boucle

La variable `i` (ou n''importe quel nom) est disponible dans le corps de la boucle :

```java
// Table de multiplication du 7
System.out.println("Table du 7 :");
for (int i = 1; i <= 10; i++) {
    System.out.println("7 × " + i + " = " + (7 * i));
}

// Calcul de la somme de 1 à 100
int somme = 0;
for (int i = 1; i <= 100; i++) {
    somme += i;  // Équivalent à : somme = somme + i
}
System.out.println("Somme de 1 à 100 = " + somme);  // 5050
```

## Les tableaux et la boucle for

Les boucles `for` sont souvent utilisées avec des tableaux :

```java
// Déclaration d''un tableau
int[] notes = {15, 18, 12, 20, 14};

// Parcourir avec un for classique (accès par index)
int total = 0;
for (int i = 0; i < notes.length; i++) {
    System.out.println("Note " + (i + 1) + " : " + notes[i]);
    total += notes[i];
}
System.out.println("Moyenne : " + (double) total / notes.length);

// Parcourir avec un for-each (plus simple, mais pas d''index)
for (int note : notes) {
    System.out.println("Note : " + note);
}
```

## La boucle for-each (enhanced for)

Introduite en Java 5, la boucle `for-each` simplifie le parcours de collections :

```java
// Syntaxe : for (TypeElement element : collection)
String[] langages = {"Java", "Kotlin", "Python", "JavaScript"};

for (String langage : langages) {
    System.out.println("J''aime " + langage + " !");
}

// Avec une liste (List)
import java.util.List;
List<Integer> nombres = List.of(1, 2, 3, 4, 5);
for (int n : nombres) {
    System.out.print(n * n + " ");  // Affiche les carrés : 1 4 9 16 25
}
```

## Les boucles imbriquées

On peut imbriquer des boucles pour traiter des structures à 2 dimensions :

```java
// Table de multiplication
for (int i = 1; i <= 5; i++) {
    for (int j = 1; j <= 5; j++) {
        System.out.printf("%4d", i * j);  // Formaté sur 4 caractères
    }
    System.out.println();  // Saut de ligne après chaque ligne
}
/*
   1   2   3   4   5
   2   4   6   8  10
   3   6   9  12  15
   4   8  12  16  20
   5  10  15  20  25
*/

// Afficher un triangle d''étoiles
for (int ligne = 1; ligne <= 5; ligne++) {
    for (int etoile = 1; etoile <= ligne; etoile++) {
        System.out.print("* ");
    }
    System.out.println();
}
/*
*
* *
* * *
* * * *
* * * * *
*/
```

## `break` et `continue` dans les boucles

```java
// break : sortir immédiatement de la boucle
for (int i = 0; i < 10; i++) {
    if (i == 5) break;  // Arrête la boucle quand i == 5
    System.out.print(i + " ");
}
// Affiche : 0 1 2 3 4

// continue : passer à l''itération suivante
for (int i = 0; i < 10; i++) {
    if (i % 2 == 0) continue;  // Saute les nombres pairs
    System.out.print(i + " ");
}
// Affiche : 1 3 5 7 9
```

## Boucle for avec plusieurs variables

```java
// Initialisation et mise à jour multiples (séparées par des virgules)
for (int i = 0, j = 10; i < j; i++, j--) {
    System.out.println("i=" + i + ", j=" + j);
}
// Affiche : i=0, j=10 ; i=1, j=9 ; ... ; i=4, j=6
```

La boucle `for` est un outil fondamental de la programmation. Maîtrisez-la et vous pourrez traiter des listes, calculer des sommes, parcourir des matrices, et bien plus encore !',
3, 35),

(3, 'Boucles while et do-while', 'boucle-while',
'# Boucles while et do-while

## Quand utiliser while plutôt que for ?

La boucle `for` est idéale quand on sait à l''avance combien d''itérations effectuer. La boucle `while` est plus adaptée quand on répète **tant qu''une condition est vraie**, sans savoir à l''avance combien de fois.

Exemples typiques : lire des données jusqu''à la fin d''un fichier, attendre une réponse valide de l''utilisateur, jouer une partie de jeu jusqu''à la victoire ou la défaite...

## La boucle `while`

```java
// Syntaxe
while (condition) {
    // Instructions répétées tant que condition == true
}
```

La condition est testée **avant** chaque itération. Si elle est `false` dès le départ, le corps n''est jamais exécuté.

```java
// Exemple : compter jusqu''à 5
int compteur = 1;
while (compteur <= 5) {
    System.out.println(compteur);
    compteur++;  // CRUCIAL : toujours modifier la condition, sinon boucle infinie !
}
// Affiche : 1, 2, 3, 4, 5

// Exemple : trouver la première puissance de 2 supérieure à 1000
int puissance = 1;
int exposant = 0;
while (puissance <= 1000) {
    puissance *= 2;
    exposant++;
}
System.out.println("2^" + exposant + " = " + puissance + " > 1000");
// Affiche : 2^10 = 1024 > 1000
```

## La boucle `do-while`

La variante `do-while` exécute le corps **au moins une fois**, puis teste la condition :

```java
// Syntaxe
do {
    // Instructions exécutées au moins une fois
} while (condition);
```

```java
// Exemple : s''assurer que l''utilisateur entre un nombre positif
// (simulation avec une variable — en vrai on lirait depuis le clavier)
int nombre;
int tentative = 0;

do {
    tentative++;
    nombre = tentative * 3 - 5;  // Simule des entrées : -2, 1, 4...
    System.out.println("Tentative " + tentative + " : " + nombre);
} while (nombre <= 0);

System.out.println("Nombre positif obtenu : " + nombre);
/*
Tentative 1 : -2
Tentative 2 : 1
Nombre positif obtenu : 1
*/
```

**Différence clé** :
- `while` : la condition est testée **avant** → le corps peut ne jamais s''exécuter
- `do-while` : la condition est testée **après** → le corps s''exécute au moins **une fois**

## Comparaison while / for

La boucle `while` et la boucle `for` sont interchangeables. Voici la correspondance :

```java
// Avec for
for (int i = 0; i < 5; i++) {
    System.out.println(i);
}

// Équivalent avec while
int i = 0;        // Initialisation
while (i < 5) {   // Condition
    System.out.println(i);
    i++;           // Mise à jour
}
```

**Règle de bonne pratique** :
- Utilisez `for` quand le nombre d''itérations est connu à l''avance
- Utilisez `while` quand vous bouclez jusqu''à ce qu''une condition change

## `break` et `continue`

Ces mots-clés fonctionnent de la même façon dans toutes les boucles :

```java
// break : sortir immédiatement de la boucle
int n = 1;
while (true) {  // Boucle apparemment infinie...
    if (n > 100) break;  // ...mais break la stoppe
    System.out.print(n + " ");
    n *= 2;
}
// Affiche : 1 2 4 8 16 32 64

// continue : passer à l''itération suivante
int i = 0;
while (i < 10) {
    i++;
    if (i % 3 == 0) continue;  // Saute les multiples de 3
    System.out.print(i + " ");
}
// Affiche : 1 2 4 5 7 8 10
```

## La boucle infinie

Une boucle infinie tourne indéfiniment si la condition reste toujours `true`. Elle est parfois intentionnelle (serveurs, jeux...) avec un `break` pour en sortir :

```java
// Boucle de jeu typique
boolean partieEnCours = true;
int tour = 0;

while (partieEnCours) {
    tour++;
    System.out.println("Tour " + tour);

    if (tour >= 5) {
        System.out.println("Partie terminée après " + tour + " tours !");
        partieEnCours = false;  // Condition de sortie
    }
}
```

**Attention** : Une boucle infinie accidentelle (oubli de mise à jour) bloque votre programme !

```java
int x = 0;
while (x < 10) {
    System.out.println(x);
    // OUBLI de x++ → boucle infinie ! Le programme ne s''arrête jamais
}
```

## Algorithmes classiques avec while

### Suite de Fibonacci

```java
int a = 0, b = 1;
System.out.print("Fibonacci : " + a + " " + b);
while (b < 100) {
    int temp = a + b;
    a = b;
    b = temp;
    System.out.print(" " + b);
}
// Affiche : Fibonacci : 0 1 1 2 3 5 8 13 21 34 55 89 144
```

### Algorithme d''Euclide (PGCD)

```java
int p = 48, q = 18;
while (q != 0) {
    int reste = p % q;
    p = q;
    q = reste;
}
System.out.println("PGCD = " + p);  // 6
```

## Récapitulatif des boucles Java

| Boucle | Condition testée | Quand utiliser |
|--------|-----------------|----------------|
| `for` | Avant chaque tour | Nombre d''itérations connu |
| `for-each` | — | Parcourir une collection |
| `while` | Avant chaque tour | Condition externe, nombre inconnu |
| `do-while` | Après chaque tour | Au moins une exécution garantie |

Avec les boucles `while` et `do-while` dans votre boîte à outils, vous pouvez maintenant implémenter des algorithmes itératifs de toute complexité !',
4, 35);

-- ============================================================
-- EXERCICES DU CHAPITRE 3
-- ============================================================

INSERT INTO exercises (lesson_id, title, description, starter_code, solution_code, test_code, hints, difficulty, xp_reward, order_index) VALUES
(
  (SELECT id FROM lessons WHERE slug = 'conditions-java'),
  'Majorité et catégorie d''âge',
  'Déclarez une variable `age` valant 16, puis :
1. Affichez "Majeur" si age >= 18, sinon affichez "Mineur"
2. Affichez la catégorie avec if/else if/else :
   - age < 13 : "Enfant"
   - age < 18 : "Adolescent"
   - age < 65 : "Adulte"
   - Sinon : "Senior"',
  'public class Main {
    public static void main(String[] args) {
        int age = 16;

        // 1. Majeur ou Mineur ?

        // 2. Catégorie d''âge

    }
}',
  'public class Main {
    public static void main(String[] args) {
        int age = 16;

        if (age >= 18) {
            System.out.println("Majeur");
        } else {
            System.out.println("Mineur");
        }

        if (age < 13) {
            System.out.println("Enfant");
        } else if (age < 18) {
            System.out.println("Adolescent");
        } else if (age < 65) {
            System.out.println("Adulte");
        } else {
            System.out.println("Senior");
        }
    }
}',
  'output.contains("Mineur") && output.contains("Adolescent")',
  'Pour la question 1 : utilisez if (age >= 18) {...} else {...}. Pour la question 2 : enchaînez des else if avec les seuils d''âge dans l''ordre croissant.',
  'EASY', 70, 1
),
(
  (SELECT id FROM lessons WHERE slug = 'switch-java'),
  'Jours de la semaine',
  'Déclarez `int jour = 3` et utilisez un switch pour afficher le nom du jour correspondant :
- 1 → "Lundi", 2 → "Mardi", 3 → "Mercredi", 4 → "Jeudi", 5 → "Vendredi"
- 6 → "Samedi", 7 → "Dimanche"
- Autre → "Jour invalide"

Ensuite, avec un deuxième switch (ou en ajoutant des cases), affichez si c''est un "Jour de semaine" ou un "Weekend".',
  'public class Main {
    public static void main(String[] args) {
        int jour = 3;

        // Switch pour afficher le nom du jour

        // Switch pour afficher Jour de semaine ou Weekend

    }
}',
  'public class Main {
    public static void main(String[] args) {
        int jour = 3;

        switch (jour) {
            case 1: System.out.println("Lundi"); break;
            case 2: System.out.println("Mardi"); break;
            case 3: System.out.println("Mercredi"); break;
            case 4: System.out.println("Jeudi"); break;
            case 5: System.out.println("Vendredi"); break;
            case 6: System.out.println("Samedi"); break;
            case 7: System.out.println("Dimanche"); break;
            default: System.out.println("Jour invalide");
        }

        switch (jour) {
            case 1: case 2: case 3: case 4: case 5:
                System.out.println("Jour de semaine");
                break;
            case 6: case 7:
                System.out.println("Weekend");
                break;
            default:
                System.out.println("Jour invalide");
        }
    }
}',
  'output.contains("Mercredi") && output.contains("Jour de semaine")',
  'Pour chaque case, n''oubliez pas le break ! Pour regrouper plusieurs cases (weekend), écrivez "case 6: case 7:" sur des lignes séparées avant le bloc commun.',
  'EASY', 70, 2
),
(
  (SELECT id FROM lessons WHERE slug = 'boucle-for'),
  'Somme et table de multiplication',
  'Utilisez des boucles for pour :
1. Calculer et afficher la somme des entiers de 1 à 10 (doit afficher "Somme: 55")
2. Afficher la table de multiplication de 3, de 3×1 jusqu''à 3×5, format : "3 x 1 = 3"',
  'public class Main {
    public static void main(String[] args) {
        // 1. Somme de 1 à 10
        int somme = 0;
        // Votre boucle for ici

        System.out.println("Somme: " + somme);

        // 2. Table du 3 (de 1 à 5)
        // Votre boucle for ici

    }
}',
  'public class Main {
    public static void main(String[] args) {
        int somme = 0;
        for (int i = 1; i <= 10; i++) {
            somme += i;
        }
        System.out.println("Somme: " + somme);

        for (int i = 1; i <= 5; i++) {
            System.out.println("3 x " + i + " = " + (3 * i));
        }
    }
}',
  'output.contains("Somme: 55") && output.contains("3 x 1 = 3") && output.contains("3 x 5 = 15")',
  'Pour la somme : initialisez somme = 0, puis dans la boucle faites somme += i. Pour la table : la boucle va de 1 à 5, affichez "3 x " + i + " = " + (3*i).',
  'EASY', 80, 3
),
(
  (SELECT id FROM lessons WHERE slug = 'boucle-while'),
  'FizzBuzz',
  'FizzBuzz est un exercice classique de programmation. Affichez les nombres de 1 à 20 avec ces règles :
- Si le nombre est divisible par 3 ET par 5 : affiche "FizzBuzz"
- Si le nombre est divisible par 3 seulement : affiche "Fizz"
- Si le nombre est divisible par 5 seulement : affiche "Buzz"
- Sinon : affiche le nombre

Indice : utilisez l''opérateur modulo (%) pour tester la divisibilité.',
  'public class Main {
    public static void main(String[] args) {
        // FizzBuzz de 1 à 20
        int i = 1;
        while (i <= 20) {
            // Votre logique ici

            i++;
        }
    }
}',
  'public class Main {
    public static void main(String[] args) {
        int i = 1;
        while (i <= 20) {
            if (i % 3 == 0 && i % 5 == 0) {
                System.out.println("FizzBuzz");
            } else if (i % 3 == 0) {
                System.out.println("Fizz");
            } else if (i % 5 == 0) {
                System.out.println("Buzz");
            } else {
                System.out.println(i);
            }
            i++;
        }
    }
}',
  'output.contains("FizzBuzz") && output.contains("Fizz") && output.contains("Buzz") && output.contains("1") && output.contains("7")',
  'Testez d''abord la condition la plus spécifique (divisible par 3 ET 5) avant les conditions individuelles. Un nombre est divisible par 3 si n % 3 == 0. N''oubliez pas d''incrémenter i à la fin de chaque tour !',
  'MEDIUM', 100, 4
);
