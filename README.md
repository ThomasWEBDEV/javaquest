# JavaQuest - Plateforme d'Apprentissage Java

![Java](https://img.shields.io/badge/Java-21-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.5-green)
![Vue.js](https://img.shields.io/badge/Vue.js-3-brightgreen)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue)
![Redis](https://img.shields.io/badge/Redis-7-red)
![Docker](https://img.shields.io/badge/Docker-Compose-blue)

## Présentation

JavaQuest est une application web interactive permettant d'apprendre Java de A à Z.

Le projet propose une approche ludique et progressive avec un éditeur de code intégré, des exercices à correction automatique, un système de gamification complet (XP, niveaux, badges) et un suivi de progression personnalisé.

L'application est conçue pour un apprentissage autonome et complet, couvrant tous les aspects du langage Java : des fondamentaux jusqu'aux concepts avancés (Streams, Concurrence, Design Patterns).

## Fonctionnalités

### Apprentissage
- [ ] Cours interactifs par chapitres progressifs
- [ ] Éditeur de code avec exécution en temps réel (JShell)
- [ ] Exercices avec correction automatique
- [ ] Quiz de validation par chapitre

### Gamification
- [ ] Système XP et niveaux
- [ ] Badges et récompenses
- [ ] Défis quotidiens
- [ ] Tableau de bord personnel

### Technique
- [x] API REST Spring Boot
- [x] Authentification JWT
- [x] Base de données PostgreSQL
- [x] Cache Redis
- [x] Frontend Vue.js 3
- [ ] Exécution de code sandboxée

## Architecture
```
[Frontend Vue.js] <──> [API Spring Boot] <──> [PostgreSQL]
                              |
                           [Redis]
                              |
                        [JShell Engine]
```

## Stack Technique

| Couche | Technologie |
|--------|-------------|
| Backend | Java 21 + Spring Boot 3.2 |
| Frontend | Vue.js 3 + Vite + Tailwind CSS 4 |
| Base de données | PostgreSQL 16 |
| Cache | Redis 7 |
| Exécution code | JShell API (sandboxé) |
| Conteneurisation | Docker + Compose |
| Tests | JUnit 5 + Mockito |
| Versioning | Git / GitHub |

## Structure du Projet
```
javaquest/
├── backend/                    # API Spring Boot
│   └── src/
│       ├── main/java/com/javaquest/
│       │   ├── auth/           # Authentification JWT
│       │   ├── config/         # Configuration Spring
│       │   ├── course/         # Chapitres et leçons
│       │   ├── exercise/       # Exercices
│       │   ├── execution/      # Moteur JShell
│       │   ├── gamification/   # XP, badges, niveaux
│       │   ├── quiz/           # QCM
│       │   └── user/           # Utilisateurs
│       └── resources/
│           └── db/migration/   # Scripts Flyway
├── frontend/                   # Application Vue.js
│   └── src/
├── docs/                       # Documentation
├── docker-compose.yml          # Services PostgreSQL + Redis
└── README.md
```

## Contenu Pédagogique Prévu

| # | Chapitre | Statut |
|---|----------|--------|
| 1 | Fondamentaux (variables, types, opérateurs) | A faire |
| 2 | Structures de contrôle (if, switch, boucles) | A faire |
| 3 | Tableaux et Strings | A faire |
| 4 | POO - Bases (classes, objets, méthodes) | A faire |
| 5 | POO - Avancé (héritage, polymorphisme) | A faire |
| 6 | Interfaces et classes abstraites | A faire |
| 7 | Gestion des exceptions | A faire |
| 8 | Collections (List, Set, Map) | A faire |
| 9 | Generics | A faire |
| 10 | Streams et lambdas | A faire |
| 11 | I/O et fichiers | A faire |
| 12 | Concurrence et threads | A faire |
| 13 | JDBC et bases de données | A faire |
| 14 | Tests unitaires (JUnit) | A faire |
| 15 | Design patterns | A faire |

## Avancement

### Phase 1 : Setup (En cours)
- [x] Initialisation repo Git + GitHub
- [x] Structure du projet
- [x] Configuration Maven
- [x] Docker Compose (PostgreSQL + Redis)
- [x] Classe principale Spring Boot
- [x] Configuration application
- [x] Schema base de données (Flyway)
- [x] Entité User + Repository
- [x] Configuration sécurité
- [x] Tests initiaux
- [x] Frontend Vue.js + Vite + Tailwind

### Phase 2 : Authentification
- [ ] Endpoints inscription/connexion
- [ ] Service JWT
- [ ] Tests authentification

### Phase 3 : Module Cours
- [ ] Entités Chapter/Lesson
- [ ] API CRUD
- [ ] Affichage frontend

### Phase 4 : Éditeur de Code
- [ ] Intégration JShell
- [ ] Sandbox sécurisé
- [ ] Interface éditeur

### Phase 5 : Exercices
- [ ] Correction automatique
- [ ] Feedback détaillé
- [ ] Historique tentatives

### Phase 6 : Gamification
- [ ] Système XP/niveaux
- [ ] Attribution badges
- [ ] Calcul streaks

### Phase 7 : Quiz
- [ ] QCM par chapitre
- [ ] Scoring

### Phase 8 : Dashboard
- [ ] Stats personnelles
- [ ] Graphiques progression

### Phase 9 : Défis Quotidiens
- [ ] Génération automatique
- [ ] Bonus XP

### Phase 10 : Polish
- [ ] Tests complets
- [ ] Documentation API
- [ ] Optimisations

## Lancement
```bash
# Cloner le projet
git clone https://github.com/ThomasWEBDEV/javaquest.git
cd javaquest

# Lancer les services
docker compose up -d

# Lancer le backend
cd backend
mvn spring-boot:run

# Lancer le frontend (autre terminal)
cd frontend
npm install
npm run dev
```

| Service | URL |
|---------|-----|
| API | http://localhost:8080/api |
| Frontend | http://localhost:5173 |
| PostgreSQL | localhost:5432 |
| Redis | localhost:6379 |

## Tests
```bash
cd backend
mvn test
```

## Auteur

**Thomas Feret**

Développeur Full Stack - Bretagne - Mars 2026

GitHub : https://github.com/ThomasWEBDEV

## Licence

MIT License - Libre utilisation à des fins éducatives et professionnelles.
