# JavaQuest - Plateforme d'Apprentissage Java

![Java](https://img.shields.io/badge/Java-21-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.5-green)
![Vue.js](https://img.shields.io/badge/Vue.js-3-brightgreen)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue)
![Redis](https://img.shields.io/badge/Redis-7-red)
![Docker](https://img.shields.io/badge/Docker-Compose-blue)

## Presentation

JavaQuest est une application web interactive permettant d'apprendre Java de A a Z.

Le projet propose une approche ludique et progressive avec un editeur de code integre, des exercices a correction automatique, un systeme de gamification complet (XP, niveaux, badges) et un suivi de progression personnalise.

L'application est concue pour un apprentissage autonome et complet, couvrant tous les aspects du langage Java : des fondamentaux jusqu'aux concepts avances (Streams, Concurrence, Design Patterns).

## Fonctionnalites

### Apprentissage
- [ ] Cours interactifs par chapitres progressifs
- [ ] Editeur de code avec execution en temps reel (JShell)
- [ ] Exercices avec correction automatique
- [ ] Quiz de validation par chapitre

### Gamification
- [ ] Systeme XP et niveaux
- [ ] Badges et recompenses
- [ ] Defis quotidiens
- [ ] Tableau de bord personnel

### Technique
- [x] API REST Spring Boot
- [x] Authentification JWT
- [x] Base de donnees PostgreSQL
- [x] Cache Redis
- [x] Frontend Vue.js 3
- [ ] Execution de code sandboxee

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
| Base de donnees | PostgreSQL 16 |
| Cache | Redis 7 |
| Execution code | JShell API (sandboxe) |
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
│       │   ├── course/         # Chapitres et lecons
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

## Contenu Pedagogique Prevu

| # | Chapitre | Statut |
|---|----------|--------|
| 1 | Fondamentaux (variables, types, operateurs) | A faire |
| 2 | Structures de controle (if, switch, boucles) | A faire |
| 3 | Tableaux et Strings | A faire |
| 4 | POO - Bases (classes, objets, methodes) | A faire |
| 5 | POO - Avance (heritage, polymorphisme) | A faire |
| 6 | Interfaces et classes abstraites | A faire |
| 7 | Gestion des exceptions | A faire |
| 8 | Collections (List, Set, Map) | A faire |
| 9 | Generics | A faire |
| 10 | Streams et lambdas | A faire |
| 11 | I/O et fichiers | A faire |
| 12 | Concurrence et threads | A faire |
| 13 | JDBC et bases de donnees | A faire |
| 14 | Tests unitaires (JUnit) | A faire |
| 15 | Design patterns | A faire |

## Avancement

### Phase 1 : Setup (Terminee)
- [x] Initialisation repo Git + GitHub
- [x] Structure du projet
- [x] Configuration Maven
- [x] Docker Compose (PostgreSQL + Redis)
- [x] Classe principale Spring Boot
- [x] Configuration application
- [x] Schema base de donnees (Flyway)
- [x] Entite User + Repository
- [x] Configuration securite
- [x] Tests initiaux
- [x] Frontend Vue.js + Vite + Tailwind

### Phase 2 : Authentification (Terminee)
- [x] Service JWT (generation, validation tokens)
- [x] DTOs (RegisterRequest, LoginRequest, AuthResponse)
- [x] AuthService (inscription, connexion)
- [x] AuthController (endpoints register/login)
- [x] CustomUserDetailsService
- [x] Filtre JWT
- [x] Integration SecurityConfig
- [x] Tests unitaires JwtService (5 tests)
- [x] Tests unitaires AuthService (7 tests)
- [x] Tests integration AuthController (8 tests)

### Phase 3 : Module Cours (En cours)
- [x] Entites Chapter/Lesson
- [x] Repositories
- [x] CourseService (CRUD)
- [ ] DTOs cours
- [ ] CourseController
- [ ] Tests cours
- [ ] Affichage frontend

### Phase 4 : Editeur de Code
- [ ] Integration JShell
- [ ] Sandbox securise
- [ ] Interface editeur

### Phase 5 : Exercices
- [ ] Correction automatique
- [ ] Feedback detaille
- [ ] Historique tentatives

### Phase 6 : Gamification
- [ ] Systeme XP/niveaux
- [ ] Attribution badges
- [ ] Calcul streaks

### Phase 7 : Quiz
- [ ] QCM par chapitre
- [ ] Scoring

### Phase 8 : Dashboard
- [ ] Stats personnelles
- [ ] Graphiques progression

### Phase 9 : Defis Quotidiens
- [ ] Generation automatique
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

Couverture actuelle : 22 tests
- JwtServiceTest : 5 tests
- AuthServiceTest : 7 tests
- AuthControllerTest : 8 tests
- HealthControllerTest : 1 test
- JavaQuestApplicationTests : 1 test

## Auteur

Thomas Feret

Developpeur Full Stack - Bretagne - Mars 2026

GitHub : https://github.com/ThomasWEBDEV

## Licence

MIT License - Libre utilisation a des fins educatives et professionnelles.
