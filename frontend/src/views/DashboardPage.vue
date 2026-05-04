<template>
  <MainLayout>
    <div class="dash">

      <!-- Header -->
      <div class="dash-header">
        <div>
          <p class="dash-eyebrow">Tableau de bord</p>
          <h1 class="dash-title">
            Bonjour, <span class="dash-name">{{ authStore.user?.username }}</span>
          </h1>
        </div>
      </div>

      <!-- Bento stats -->
      <div class="bento-stats">
        <!-- Skeleton -->
        <template v-if="loadingStats">
          <div v-for="i in 4" :key="i" class="stat-card stat-skeleton"></div>
        </template>

        <template v-else>
          <!-- XP -->
          <div class="stat-card stat-amber">
            <span class="stat-eyebrow">Experience</span>
            <div class="stat-value">{{ stats.totalXp.toLocaleString() }}</div>
            <span class="stat-label">points XP</span>
          </div>

          <!-- Niveau -->
          <div class="stat-card stat-accent">
            <span class="stat-eyebrow">Niveau actuel</span>
            <div class="stat-value">{{ stats.currentLevel }}</div>
            <span class="stat-label">sur l'echelle</span>
          </div>

          <!-- Streak -->
          <div class="stat-card stat-orange">
            <span class="stat-eyebrow">Serie en cours</span>
            <div class="stat-value">{{ stats.currentStreak }}<span class="stat-unit">j</span></div>
            <span class="stat-label">consecutifs</span>
          </div>

          <!-- Badges -->
          <div class="stat-card stat-base">
            <span class="stat-eyebrow">Badges</span>
            <div class="stat-value">{{ stats.badgesCount }}</div>
            <span class="stat-label">debloqués</span>
          </div>
        </template>
      </div>

      <!-- Milieu : Progression + Defi -->
      <div class="dash-mid">

        <!-- Progression XP -->
        <div class="card">
          <div class="card-header">
            <span class="card-title">Progression</span>
            <span class="card-badge">Niv. {{ stats.currentLevel }}</span>
          </div>

          <div class="progress-block">
            <div class="progress-labels">
              <span class="progress-from">{{ stats.totalXp }} XP</span>
              <span class="progress-to">{{ stats.xpForNextLevel }} XP restants</span>
            </div>
            <div class="progress-track">
              <div class="progress-fill" :style="{ width: progressPercent + '%' }"></div>
            </div>
            <div class="progress-pct">{{ progressPercent }}%</div>
          </div>

          <div class="mini-stats">
            <div class="mini-stat mini-green">
              <div class="mini-val">{{ stats.exercisesCompleted }}</div>
              <div class="mini-label">Exercices completes</div>
            </div>
            <div class="mini-stat mini-accent">
              <div class="mini-val">{{ stats.quizzesPassed }}</div>
              <div class="mini-label">Quiz reussis</div>
            </div>
          </div>
        </div>

        <!-- Defi du jour -->
        <div class="card">
          <div class="card-header">
            <span class="card-title">Defi du jour</span>
            <span v-if="todayChallenge" class="card-badge card-badge--amber">+{{ todayChallenge.xpReward }} XP</span>
          </div>

          <div v-if="todayChallenge" class="challenge-body">
            <h3 class="challenge-name">{{ todayChallenge.title }}</h3>
            <p class="challenge-desc">{{ todayChallenge.description }}</p>
            <div class="challenge-tags">
              <span class="tag tag--amber">+{{ todayChallenge.xpReward }} XP</span>
              <span class="tag tag--green">Bonus +{{ todayChallenge.bonusXp }} XP</span>
            </div>
            <router-link to="/challenge" class="btn-primary">Relever le defi</router-link>
          </div>

          <div v-else class="card-empty">
            <div class="empty-icon">—</div>
            <p>Pas de defi disponible aujourd'hui</p>
          </div>
        </div>
      </div>

      <!-- Exercices en cours -->
      <div class="card">
        <div class="card-header">
          <span class="card-title">Exercices en cours</span>
          <span v-if="exercisesInProgress.length" class="card-badge">{{ exercisesInProgress.length }}</span>
        </div>

        <div v-if="exercisesInProgress.length > 0" class="exercise-list">
          <div
            v-for="exercise in exercisesInProgress"
            :key="exercise.exerciseId"
            class="exercise-row"
          >
            <div class="exercise-info">
              <div class="exercise-title">{{ exercise.exerciseTitle }}</div>
              <div class="exercise-meta">{{ exercise.attemptsCount }} tentative{{ exercise.attemptsCount > 1 ? 's' : '' }}</div>
            </div>
            <router-link :to="`/exercises/${exercise.exerciseId}`" class="btn-ghost">Continuer</router-link>
          </div>
        </div>

        <div v-else class="card-empty">
          <div class="empty-icon">✦</div>
          <p>Aucun exercice en cours — commencez un cours !</p>
        </div>
      </div>

    </div>
  </MainLayout>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import MainLayout from '@/components/layout/MainLayout.vue'
import { useAuthStore } from '@/stores/auth'
import api from '@/services/api'

const authStore = useAuthStore()

const stats = ref({
  totalXp: 0,
  currentLevel: 1,
  xpForNextLevel: 1000,
  currentStreak: 0,
  badgesCount: 0,
  exercisesCompleted: 0,
  quizzesPassed: 0
})
const todayChallenge = ref(null)
const exercisesInProgress = ref([])
const loadingStats = ref(true)

const progressPercent = computed(() => {
  const xpInLevel = 1000 - stats.value.xpForNextLevel
  return Math.max(0, Math.min(100, Math.round((xpInLevel / 1000) * 100)))
})

async function fetchDashboard() {
  if (!authStore.user?.id) return
  try {
    const response = await api.get(`/dashboard/${authStore.user.id}/stats`)
    stats.value = response.data
  } catch (error) {
    console.error('Erreur chargement stats:', error)
  } finally {
    loadingStats.value = false
  }
}

async function fetchTodayChallenge() {
  try {
    const response = await api.get('/challenges/today')
    todayChallenge.value = response.data
  } catch (error) {
    console.error('Pas de defi aujourd\'hui')
  }
}

async function fetchExercisesInProgress() {
  if (!authStore.user?.id) return
  try {
    const response = await api.get(`/dashboard/${authStore.user.id}/exercises/in-progress`)
    exercisesInProgress.value = response.data
  } catch (error) {
    console.error('Erreur chargement exercices:', error)
  }
}

watch(() => authStore.user?.id, (userId) => {
  if (userId) {
    fetchDashboard()
    fetchExercisesInProgress()
  }
}, { immediate: true })

onMounted(() => {
  fetchTodayChallenge()
})
</script>

<style scoped>
.dash {
  max-width: 900px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

/* Header */
.dash-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  padding-bottom: 4px;
}

.dash-eyebrow {
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--c-muted);
  margin-bottom: 4px;
}

.dash-title {
  font-family: var(--font-serif);
  font-size: 28px;
  font-weight: 700;
  color: var(--c-text);
  letter-spacing: -0.02em;
  line-height: 1.1;
}

.dash-name {
  color: var(--c-accent-light);
}

/* Bento stats */
.bento-stats {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 10px;
}

.stat-card {
  border-radius: 14px;
  padding: 18px 16px 16px;
  border: 1px solid var(--c-border);
  display: flex;
  flex-direction: column;
  gap: 4px;
  transition: border-color var(--t);
}

.stat-card:hover { border-color: var(--c-border-md); }

.stat-skeleton {
  background: var(--c-surface);
  height: 96px;
  animation: pulse 1.4s ease infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.4; }
}

.stat-base   { background: var(--c-surface); }
.stat-amber  { background: rgba(245, 158, 11, 0.06); border-color: rgba(245, 158, 11, 0.12); }
.stat-accent { background: var(--c-accent-soft); border-color: var(--c-accent-glow); }
.stat-orange { background: rgba(249, 115, 22, 0.06); border-color: rgba(249, 115, 22, 0.12); }

.stat-eyebrow {
  font-size: 10px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.09em;
  color: var(--c-muted);
}

.stat-value {
  font-size: 30px;
  font-weight: 800;
  letter-spacing: -0.03em;
  line-height: 1;
  margin-top: 2px;
}

.stat-amber  .stat-value { color: var(--c-amber); }
.stat-accent .stat-value { color: var(--c-accent-light); }
.stat-orange .stat-value { color: var(--c-orange); }
.stat-base   .stat-value { color: var(--c-text); }

.stat-unit {
  font-size: 14px;
  font-weight: 500;
  opacity: 0.5;
  margin-left: 1px;
}

.stat-label {
  font-size: 11px;
  color: var(--c-muted);
  margin-top: 2px;
}

/* Cards */
.card {
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 16px;
  padding: 22px 24px;
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 18px;
}

.card-title {
  font-size: 13.5px;
  font-weight: 600;
  color: var(--c-text);
  letter-spacing: -0.01em;
}

.card-badge {
  font-size: 11px;
  font-weight: 600;
  color: var(--c-muted);
  background: var(--c-surface-2);
  border: 1px solid var(--c-border);
  padding: 3px 8px;
  border-radius: 100px;
}

.card-badge--amber {
  color: var(--c-amber);
  background: var(--c-amber-soft);
  border-color: rgba(245, 158, 11, 0.2);
}

/* Milieu 2 colonnes */
.dash-mid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
}

/* Progress */
.progress-block { margin-bottom: 18px; }

.progress-labels {
  display: flex;
  justify-content: space-between;
  font-size: 11px;
  color: var(--c-muted);
  margin-bottom: 8px;
}

.progress-track {
  height: 3px;
  background: var(--c-surface-2);
  border-radius: 2px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: var(--c-accent);
  border-radius: 2px;
  transition: width 0.7s ease;
}

.progress-pct {
  font-size: 10px;
  color: var(--c-subtle);
  text-align: right;
  margin-top: 5px;
}

.mini-stats {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 8px;
}

.mini-stat {
  border-radius: 10px;
  padding: 12px 14px;
  border: 1px solid var(--c-border);
}

.mini-green  { background: var(--c-green-soft); border-color: rgba(34, 197, 94, 0.15); }
.mini-accent { background: var(--c-accent-soft); border-color: var(--c-accent-glow); }

.mini-val {
  font-size: 22px;
  font-weight: 800;
  letter-spacing: -0.03em;
  line-height: 1;
}

.mini-green  .mini-val { color: var(--c-green); }
.mini-accent .mini-val { color: var(--c-accent-light); }

.mini-label {
  font-size: 10px;
  color: var(--c-muted);
  margin-top: 4px;
}

/* Challenge */
.challenge-body {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.challenge-name {
  font-size: 14px;
  font-weight: 600;
  color: var(--c-text);
  line-height: 1.4;
}

.challenge-desc {
  font-size: 13px;
  color: var(--c-text-2);
  line-height: 1.6;
}

.challenge-tags {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

.tag {
  font-size: 11px;
  font-weight: 600;
  padding: 3px 8px;
  border-radius: 100px;
  border: 1px solid transparent;
}

.tag--amber {
  color: var(--c-amber);
  background: var(--c-amber-soft);
  border-color: rgba(245, 158, 11, 0.18);
}

.tag--green {
  color: var(--c-green);
  background: var(--c-green-soft);
  border-color: rgba(34, 197, 94, 0.18);
}

/* Buttons */
.btn-primary {
  display: block;
  width: 100%;
  padding: 10px 16px;
  background: var(--c-accent);
  color: #fff;
  text-align: center;
  border-radius: 10px;
  font-size: 13px;
  font-weight: 600;
  letter-spacing: -0.01em;
  transition: opacity var(--t), transform var(--t);
  text-decoration: none;
  margin-top: 4px;
}

.btn-primary:hover { opacity: 0.88; transform: translateY(-1px); }

.btn-ghost {
  padding: 7px 14px;
  border: 1px solid var(--c-border-md);
  border-radius: 9px;
  font-size: 12px;
  font-weight: 600;
  color: var(--c-text-2);
  text-decoration: none;
  transition: color var(--t), border-color var(--t), background var(--t);
  white-space: nowrap;
}

.btn-ghost:hover {
  color: var(--c-text);
  border-color: var(--c-accent);
  background: var(--c-accent-soft);
}

/* Exercise list */
.exercise-list {
  display: flex;
  flex-direction: column;
  gap: 1px;
}

.exercise-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 14px;
  border-radius: 10px;
  background: var(--c-surface-2);
  transition: background var(--t);
}

.exercise-row:hover { background: var(--c-surface-hover); }

.exercise-title {
  font-size: 13.5px;
  font-weight: 500;
  color: var(--c-text);
}

.exercise-meta {
  font-size: 11px;
  color: var(--c-muted);
  margin-top: 2px;
}

/* Empty state */
.card-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 28px 0;
  gap: 8px;
}

.empty-icon {
  font-size: 20px;
  color: var(--c-subtle);
  line-height: 1;
}

.card-empty p {
  font-size: 13px;
  color: var(--c-muted);
}
</style>
