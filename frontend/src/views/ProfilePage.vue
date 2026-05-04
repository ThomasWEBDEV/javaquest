<template>
  <MainLayout>
    <div class="profile">

      <!-- Skeleton -->
      <div v-if="loading" class="profile-skeleton">
        <div class="skeleton-hero"></div>
        <div class="skeleton-grid">
          <div v-for="i in 4" :key="i" class="skeleton-stat"></div>
        </div>
      </div>

      <template v-else>

        <!-- Hero profil -->
        <div class="profile-hero">
          <div class="avatar">
            <span class="avatar-letter">{{ authStore.user?.username?.charAt(0).toUpperCase() }}</span>
          </div>
          <div class="profile-info">
            <p class="profile-eyebrow">Niveau {{ stats.currentLevel }}</p>
            <h1 class="profile-name">{{ authStore.user?.username }}</h1>
            <p class="profile-email">{{ authStore.user?.email }}</p>
            <div class="profile-progress">
              <div class="progress-labels">
                <span>{{ stats.totalXp.toLocaleString() }} XP</span>
                <span>{{ stats.xpForNextLevel }} XP pour niv. {{ stats.currentLevel + 1 }}</span>
              </div>
              <div class="progress-track">
                <div class="progress-fill" :style="{ width: progressPercent + '%' }"></div>
              </div>
            </div>
          </div>
        </div>

        <!-- Stats grid -->
        <div class="stats-grid">
          <div class="stat-tile stat-green">
            <div class="stat-val">{{ stats.exercisesCompleted }}</div>
            <div class="stat-lbl">Exercices</div>
          </div>
          <div class="stat-tile stat-accent">
            <div class="stat-val">{{ stats.quizzesPassed }}</div>
            <div class="stat-lbl">Quiz reussis</div>
          </div>
          <div class="stat-tile stat-orange">
            <div class="stat-val">{{ stats.currentStreak }}<span class="stat-unit">j</span></div>
            <div class="stat-lbl">Serie actuelle</div>
          </div>
          <div class="stat-tile stat-amber">
            <div class="stat-val">{{ stats.longestStreak }}<span class="stat-unit">j</span></div>
            <div class="stat-lbl">Meilleure serie</div>
          </div>
        </div>

        <!-- Badges -->
        <div class="card">
          <div class="card-header">
            <span class="card-title">Badges</span>
            <span v-if="badges.length" class="card-count">{{ badges.length }} obtenus</span>
          </div>

          <div v-if="badges.length > 0" class="badges-grid">
            <div v-for="badge in badges" :key="badge.id" class="badge-item">
              <div class="badge-icon">{{ badgeIcon(badge.criteriaType) }}</div>
              <div class="badge-name">{{ badge.name }}</div>
              <div class="badge-desc">{{ badge.description }}</div>
              <div v-if="badge.earnedAt" class="badge-date">
                {{ new Date(badge.earnedAt).toLocaleDateString('fr-FR') }}
              </div>
            </div>
          </div>

          <div v-else class="card-empty">
            <div class="empty-glyph">◎</div>
            <p>Aucun badge pour le moment — continuez a apprendre !</p>
          </div>
        </div>

        <!-- Historique Quiz -->
        <div class="card">
          <div class="card-header">
            <span class="card-title">Historique des Quiz</span>
          </div>

          <div v-if="quizHistory.length > 0" class="quiz-list">
            <div v-for="attempt in quizHistory" :key="attempt.attemptedAt" class="quiz-row">
              <div class="quiz-info">
                <div class="quiz-title">{{ attempt.quizTitle }}</div>
                <div class="quiz-date">{{ new Date(attempt.attemptedAt).toLocaleDateString('fr-FR') }}</div>
              </div>
              <div class="quiz-result">
                <div class="quiz-score" :class="attempt.passed ? 'score-pass' : 'score-fail'">
                  {{ attempt.score }}%
                </div>
                <div class="quiz-detail">{{ attempt.correctAnswers }}/{{ attempt.totalQuestions }}</div>
                <div v-if="attempt.xpEarned > 0" class="quiz-xp">+{{ attempt.xpEarned }} XP</div>
              </div>
            </div>
          </div>

          <div v-else class="card-empty">
            <div class="empty-glyph">◎</div>
            <p>Aucun quiz complete pour l'instant</p>
          </div>
        </div>

      </template>
    </div>
  </MainLayout>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import MainLayout from '@/components/layout/MainLayout.vue'
import { useAuthStore } from '@/stores/auth'
import api from '@/services/api'

const authStore = useAuthStore()

const stats = ref({
  totalXp: 0,
  currentLevel: 1,
  xpForNextLevel: 1000,
  currentStreak: 0,
  longestStreak: 0,
  exercisesCompleted: 0,
  quizzesPassed: 0
})
const badges = ref([])
const quizHistory = ref([])
const loading = ref(true)

const progressPercent = computed(() => {
  const xpInLevel = 1000 - stats.value.xpForNextLevel
  return Math.max(0, Math.min(100, Math.round((xpInLevel / 1000) * 100)))
})

async function fetchStats() {
  if (!authStore.user?.id) return
  try {
    const response = await api.get(`/dashboard/${authStore.user.id}/stats`)
    stats.value = response.data
  } catch (error) {
    console.error('Erreur chargement stats:', error)
  } finally {
    loading.value = false
  }
}

async function fetchBadges() {
  if (!authStore.user?.id) return
  try {
    const response = await api.get(`/gamification/badges/${authStore.user.id}`)
    badges.value = response.data
  } catch (error) {
    console.error('Erreur chargement badges:', error)
  }
}

async function fetchQuizHistory() {
  if (!authStore.user?.id) return
  try {
    const response = await api.get(`/dashboard/${authStore.user.id}/quizzes/history`)
    quizHistory.value = response.data
  } catch (error) {
    console.error('Erreur chargement historique:', error)
  }
}

function badgeIcon(criteriaType) {
  switch (criteriaType) {
    case 'XP_TOTAL': return '★'
    case 'LEVEL_REACHED': return '◈'
    case 'EXERCISES_COMPLETED': return '◆'
    case 'STREAK_DAYS': return '◉'
    case 'QUIZZES_PASSED': return '◇'
    case 'CHAPTERS_COMPLETED': return '▣'
    default: return '✦'
  }
}

watch(() => authStore.user?.id, (userId) => {
  if (userId) {
    fetchStats()
    fetchBadges()
    fetchQuizHistory()
  }
}, { immediate: true })
</script>

<style scoped>
.profile {
  max-width: 820px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 14px;
}

/* Skeleton */
.profile-skeleton { display: flex; flex-direction: column; gap: 14px; }
.skeleton-hero { height: 120px; border-radius: 16px; background: var(--c-surface); animation: pulse 1.4s ease infinite; }
.skeleton-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; }
.skeleton-stat { height: 80px; border-radius: 12px; background: var(--c-surface); animation: pulse 1.4s ease infinite; }

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.4; }
}

/* Hero */
.profile-hero {
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 18px;
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 22px;
}

.avatar {
  width: 72px;
  height: 72px;
  border-radius: 16px;
  background: var(--c-accent-soft);
  border: 1px solid var(--c-accent-glow);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.avatar-letter {
  font-family: var(--font-serif);
  font-size: 30px;
  font-weight: 700;
  color: var(--c-accent-light);
  line-height: 1;
}

.profile-info { flex: 1; min-width: 0; }

.profile-eyebrow {
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.09em;
  color: var(--c-accent-light);
  margin-bottom: 2px;
}

.profile-name {
  font-family: var(--font-serif);
  font-size: 22px;
  font-weight: 700;
  color: var(--c-text);
  letter-spacing: -0.02em;
  line-height: 1.1;
}

.profile-email {
  font-size: 12px;
  color: var(--c-muted);
  margin-bottom: 14px;
  margin-top: 2px;
}

.profile-progress {}

.progress-labels {
  display: flex;
  justify-content: space-between;
  font-size: 11px;
  color: var(--c-muted);
  margin-bottom: 6px;
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

/* Stats grid */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 10px;
}

.stat-tile {
  border-radius: 13px;
  padding: 16px 14px;
  border: 1px solid var(--c-border);
  text-align: center;
}

.stat-green  { background: var(--c-green-soft);  border-color: rgba(34, 197, 94, 0.15); }
.stat-accent { background: var(--c-accent-soft);  border-color: var(--c-accent-glow); }
.stat-orange { background: rgba(249, 115, 22, 0.06); border-color: rgba(249, 115, 22, 0.12); }
.stat-amber  { background: var(--c-amber-soft);  border-color: rgba(245, 158, 11, 0.15); }

.stat-val {
  font-size: 26px;
  font-weight: 800;
  letter-spacing: -0.03em;
  line-height: 1;
}

.stat-green  .stat-val { color: var(--c-green); }
.stat-accent .stat-val { color: var(--c-accent-light); }
.stat-orange .stat-val { color: var(--c-orange); }
.stat-amber  .stat-val { color: var(--c-amber); }

.stat-unit {
  font-size: 13px;
  font-weight: 500;
  opacity: 0.5;
  margin-left: 1px;
}

.stat-lbl {
  font-size: 11px;
  color: var(--c-muted);
  margin-top: 5px;
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

.card-count {
  font-size: 11px;
  font-weight: 600;
  color: var(--c-muted);
  background: var(--c-surface-2);
  border: 1px solid var(--c-border);
  padding: 3px 8px;
  border-radius: 100px;
}

/* Badges */
.badges-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
}

.badge-item {
  background: var(--c-surface-2);
  border: 1px solid var(--c-border);
  border-radius: 12px;
  padding: 16px 14px;
  text-align: center;
  transition: border-color var(--t);
}

.badge-item:hover { border-color: var(--c-amber); }

.badge-icon {
  font-size: 22px;
  color: var(--c-amber);
  line-height: 1;
  margin-bottom: 8px;
}

.badge-name {
  font-size: 12px;
  font-weight: 600;
  color: var(--c-text);
  margin-bottom: 4px;
}

.badge-desc {
  font-size: 11px;
  color: var(--c-muted);
  line-height: 1.5;
}

.badge-date {
  font-size: 10px;
  color: var(--c-subtle);
  margin-top: 6px;
  font-family: var(--font-mono);
}

/* Quiz history */
.quiz-list {
  display: flex;
  flex-direction: column;
  gap: 1px;
}

.quiz-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 11px 14px;
  border-radius: 10px;
  background: var(--c-surface-2);
  transition: background var(--t);
}

.quiz-row:hover { background: var(--c-surface-hover); }

.quiz-title {
  font-size: 13px;
  font-weight: 500;
  color: var(--c-text);
}

.quiz-date {
  font-size: 11px;
  color: var(--c-muted);
  margin-top: 2px;
  font-family: var(--font-mono);
}

.quiz-result {
  text-align: right;
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 1px;
}

.quiz-score {
  font-size: 14px;
  font-weight: 700;
  letter-spacing: -0.02em;
}

.score-pass { color: var(--c-green); }
.score-fail { color: var(--c-red); }

.quiz-detail {
  font-size: 11px;
  color: var(--c-muted);
}

.quiz-xp {
  font-size: 11px;
  font-weight: 600;
  color: var(--c-amber);
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

.empty-glyph {
  font-size: 18px;
  color: var(--c-subtle);
}

.card-empty p {
  font-size: 13px;
  color: var(--c-muted);
}
</style>
