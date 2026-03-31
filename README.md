# JavaQuest

Plateforme d'apprentissage Java gamifiee.

## Stack Technique

- **Backend**: Java 21, Spring Boot 3.2.5, PostgreSQL 16, Redis 7
- **Frontend**: Vue.js 3, Vite, Tailwind CSS 4, Pinia
- **Auth**: JWT

## Installation

### Prerequis

- Java 21+
- Node.js 18+
- Docker et Docker Compose

### Demarrage

1. **Cloner le projet**
```bash
git clone https://github.com/ThomasWEBDEV/javaquest.git
cd javaquest
```

2. **Demarrer les services Docker**
```bash
docker compose up -d
```

3. **Demarrer le backend**
```bash
cd backend
mvn spring-boot:run
```

4. **Demarrer le frontend**
```bash
cd frontend
npm install
npm run dev
```

5. **Acceder a l'application**
- Frontend: http://localhost:5173
- API: http://localhost:8080/api

## Fonctionnalites

- Authentification (inscription/connexion)
- Cours et chapitres Java
- Exercices avec editeur de code integre
- Execution de code Java via JShell
- Systeme de gamification (XP, niveaux, badges)
- Quiz interactifs
- Defis quotidiens
- Dashboard de progression

## API Endpoints

| Module | Endpoint | Description |
|--------|----------|-------------|
| Auth | POST /api/auth/register | Inscription |
| Auth | POST /api/auth/login | Connexion |
| Cours | GET /api/courses/chapters | Liste des chapitres |
| Exercices | GET /api/exercises/lesson/{id} | Exercices d'une lecon |
| Execution | POST /api/execute | Executer du code Java |
| Gamification | GET /api/gamification/progress/{userId} | Progression utilisateur |
| Quiz | GET /api/quizzes | Liste des quiz |
| Quiz | POST /api/quizzes/{id}/submit | Soumettre un quiz |
| Dashboard | GET /api/dashboard/{userId}/stats | Statistiques |
| Defis | GET /api/challenges/today | Defi du jour |

## Structure du Projet
```
javaquest/
├── backend/
│   └── src/main/java/com/javaquest/
│       ├── auth/          # Authentification JWT
│       ├── config/        # Configuration Spring
│       ├── course/        # Cours, chapitres, lecons
│       ├── exercise/      # Exercices
│       ├── execution/     # JShell sandbox
│       ├── gamification/  # XP, badges, streaks
│       ├── quiz/          # Quiz et questions
│       ├── dashboard/     # Statistiques
│       └── challenge/     # Defis quotidiens
├── frontend/
│   └── src/
│       ├── components/    # Composants Vue
│       ├── views/         # Pages
│       ├── stores/        # Pinia stores
│       ├── services/      # API calls
│       └── router/        # Vue Router
└── docker-compose.yml
```

## Tests
```bash
cd backend
mvn test
```

## Auteur

Thomas FERET
