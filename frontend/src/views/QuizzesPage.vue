<template>
  <MainLayout>
    <div class="quizzes-page">

      <div class="quizzes-header">
        <div>
          <p class="eyebrow">Evaluation</p>
          <h1 class="page-title">Quiz</h1>
        </div>
        <p v-if="!loading" class="quizzes-count">{{ quizzes.length }} quiz disponibles</p>
      </div>

      <div v-if="loading" class="quizzes-grid">
        <div v-for="n in 6" :key="n" class="quiz-card quiz-skeleton"></div>
      </div>

      <div v-else class="quizzes-grid">
        <router-link
          v-for="quiz in quizzes"
          :key="quiz.id"
          :to="`/quizzes/${quiz.id}`"
          class="quiz-card"
        >
          <div class="quiz-card-top">
            <h3 class="quiz-title">{{ quiz.title }}</h3>
            <div
              v-if="bestScores[quiz.id]"
              class="score-badge"
              :class="bestScores[quiz.id].passed ? 'score-pass' : 'score-tried'"
            >
              <span>{{ bestScores[quiz.id].passed ? '&#10003;' : '&#8212;' }}</span>
              {{ bestScores[quiz.id].score }}%
            </div>
          </div>

          <p class="quiz-desc">{{ quiz.description }}</p>

          <div class="quiz-card-footer">
            <div class="quiz-meta">
              <span class="meta-item">{{ quiz.questionCount }} questions</span>
              <span class="meta-sep">&middot;</span>
              <span class="meta-item">min {{ quiz.passingScore }}%</span>
            </div>
            <span class="quiz-xp">+{{ quiz.xpReward }} XP</span>
          </div>

          <span class="quiz-arrow">&#8594;</span>
        </router-link>
      </div>

      <div v-if="!loading && quizzes.length === 0" class="empty">&#9676; Aucun quiz disponible.</div>

    </div>
  </MainLayout>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import MainLayout from '@/components/layout/MainLayout.vue'
import { useAuthStore } from '@/stores/auth'
import api from '@/services/api'

const authStore = useAuthStore()
const quizzes = ref([])
const bestScores = ref({})
const loading = ref(true)

async function fetchQuizzes() {
  try {
    const response = await api.get('/quizzes')
    quizzes.value = response.data
  } catch (error) {
    console.error('Erreur chargement quiz:', error)
  } finally {
    loading.value = false
  }
}

async function fetchQuizHistory() {
  if (!authStore.user?.id) return
  try {
    const response = await api.get(`/dashboard/${authStore.user.id}/quizzes/history`)
    const scores = {}
    for (const attempt of response.data) {
      const existing = scores[attempt.quizId]
      if (!existing || attempt.score > existing.score) {
        scores[attempt.quizId] = { score: attempt.score, passed: attempt.passed }
      }
    }
    bestScores.value = scores
  } catch (error) {
    console.error('Erreur chargement historique:', error)
  }
}

onMounted(() => {
  fetchQuizzes()
})

watch(() => authStore.user?.id, (userId) => {
  if (userId) fetchQuizHistory()
}, { immediate: true })
</script>

<style scoped>
.quizzes-page {
  max-width: 960px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

/* Header */
.quizzes-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
}
.eyebrow {
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--c-muted);
  margin-bottom: 4px;
}
.page-title {
  font-family: var(--font-serif);
  font-size: 28px;
  font-weight: 700;
  color: var(--c-text);
  letter-spacing: -0.02em;
  line-height: 1.1;
}
.quizzes-count {
  font-size: 13px;
  color: var(--c-muted);
  flex-shrink: 0;
}

/* Grid */
.quizzes-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
}

/* Card */
.quiz-card {
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 16px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  text-decoration: none;
  position: relative;
  transition: border-color var(--t), background var(--t), transform var(--t-slow);
}
.quiz-card:hover {
  border-color: var(--c-border-strong);
  background: var(--c-surface-hover);
  transform: translateY(-2px);
}

.quiz-skeleton {
  min-height: 160px;
  animation: pulse 1.4s ease infinite;
  cursor: default;
}
.quiz-skeleton:hover { transform: none; border-color: var(--c-border); background: var(--c-surface); }
@keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.4; } }

.quiz-card-top {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 10px;
}
.quiz-title {
  font-size: 14px;
  font-weight: 600;
  color: var(--c-text);
  line-height: 1.4;
  flex: 1;
  transition: color var(--t);
}
.quiz-card:hover .quiz-title { color: var(--c-accent-light); }

.score-badge {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 11px;
  font-weight: 700;
  padding: 3px 8px;
  border-radius: 100px;
  flex-shrink: 0;
}
.score-pass { background: var(--c-green-soft); color: var(--c-green); border: 1px solid rgba(34, 197, 94, 0.2); }
.score-tried { background: var(--c-surface-2); color: var(--c-muted); border: 1px solid var(--c-border-md); }

.quiz-desc {
  font-size: 12px;
  color: var(--c-muted);
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  flex: 1;
}

.quiz-card-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-top: 10px;
  border-top: 1px solid var(--c-border);
  margin-top: auto;
}
.quiz-meta { display: flex; align-items: center; gap: 4px; }
.meta-item { font-size: 11px; color: var(--c-subtle); }
.meta-sep { font-size: 11px; color: var(--c-subtle); }
.quiz-xp {
  font-size: 11px;
  font-weight: 600;
  color: var(--c-amber-light);
  background: var(--c-amber-soft);
  padding: 2px 8px;
  border-radius: 100px;
  border: 1px solid rgba(245, 158, 11, 0.15);
}

.quiz-arrow {
  position: absolute;
  bottom: 20px;
  right: 20px;
  font-size: 13px;
  color: var(--c-subtle);
  transition: color var(--t), transform var(--t);
  display: none;
}
.quiz-card:hover .quiz-arrow { color: var(--c-accent-light); transform: translateX(3px); }

.empty {
  text-align: center;
  padding: 64px 0;
  font-size: 13px;
  color: var(--c-muted);
}
</style>
