<template>
  <MainLayout>
    <div class="quiz-page">

      <!-- Skeleton -->
      <div v-if="loading" class="skeleton-wrap">
        <div class="skeleton-header"></div>
        <div class="skeleton-body"></div>
      </div>

      <!-- Quiz en cours -->
      <div v-else-if="!submitted && questions.length > 0">

        <div class="quiz-header">
          <div class="quiz-header-top">
            <h1 class="quiz-title">{{ quiz?.title }}</h1>
            <div class="quiz-header-meta">
              <span
                v-if="timeLeft !== null"
                class="timer"
                :class="{ 'timer-urgent': timeLeft <= 30 }"
              >&#9203; {{ formattedTime }}</span>
              <span class="progress-counter">{{ currentIndex + 1 }} / {{ questions.length }}</span>
            </div>
          </div>
          <div class="progress-bar-wrap">
            <div
              class="progress-bar"
              :style="{ width: ((currentIndex + 1) / questions.length * 100) + '%' }"
            ></div>
          </div>
          <div class="progress-dots">
            <div
              v-for="(q, i) in questions"
              :key="q.id"
              class="dot"
              :class="i < currentIndex ? 'dot-done' : i === currentIndex ? 'dot-active' : 'dot-pending'"
            ></div>
          </div>
        </div>

        <div class="question-card">
          <h2 class="question-text">{{ currentQuestion.text }}</h2>

          <div v-if="currentQuestion.codeSnippet" class="question-code">
            <pre>{{ currentQuestion.codeSnippet }}</pre>
          </div>

          <!-- Choix multiple -->
          <div v-if="currentQuestion.questionType === 'MULTIPLE_CHOICE'" class="answers-list">
            <label
              v-for="answer in currentQuestion.answers"
              :key="answer.id"
              class="answer-option"
              :class="{ 'answer-selected': selectedAnswers[currentQuestion.id]?.includes(answer.id) }"
            >
              <div class="answer-check" :class="{ 'checked': selectedAnswers[currentQuestion.id]?.includes(answer.id) }">
                <span v-if="selectedAnswers[currentQuestion.id]?.includes(answer.id)">&#10003;</span>
              </div>
              <input type="checkbox" :value="answer.id" v-model="selectedAnswers[currentQuestion.id]" class="hidden-input" />
              <span class="answer-text">{{ answer.text }}</span>
            </label>
          </div>

          <!-- Choix unique -->
          <div v-else class="answers-list">
            <button
              v-for="(answer, idx) in currentQuestion.answers"
              :key="answer.id"
              @click="selectedAnswers[currentQuestion.id] = [answer.id]"
              class="answer-option"
              :class="{ 'answer-selected': selectedAnswers[currentQuestion.id]?.[0] === answer.id }"
            >
              <div
                class="answer-letter"
                :class="{ 'letter-selected': selectedAnswers[currentQuestion.id]?.[0] === answer.id }"
              >{{ ['A', 'B', 'C', 'D'][idx] }}</div>
              <span class="answer-text">{{ answer.text }}</span>
            </button>
          </div>

          <div class="quiz-nav">
            <button v-if="currentIndex > 0" @click="currentIndex--" class="btn-prev">&#8592; Precedent</button>
            <div v-else></div>
            <button
              v-if="currentIndex < questions.length - 1"
              @click="currentIndex++"
              class="btn-next"
            >Suivant &#8594;</button>
            <button
              v-else
              @click="submitQuiz"
              :disabled="submitting"
              class="btn-submit"
            >{{ submitting ? 'Envoi...' : '&#10003; Terminer' }}</button>
          </div>
        </div>
      </div>

      <!-- Resultats -->
      <div v-else-if="submitted && result" class="results-card">
        <div class="score-ring-wrap">
          <svg width="128" height="128" viewBox="0 0 120 120" class="score-svg">
            <circle cx="60" cy="60" r="50" fill="none" stroke="var(--c-border-md)" stroke-width="10"/>
            <circle
              cx="60" cy="60" r="50" fill="none"
              :stroke="result.passed ? 'var(--c-green)' : 'var(--c-red)'"
              stroke-width="10"
              stroke-linecap="round"
              :stroke-dasharray="314"
              :stroke-dashoffset="314 - (314 * result.score / 100)"
              class="score-circle"
            />
          </svg>
          <div class="score-label" :class="result.passed ? 'score-pass' : 'score-fail'">
            {{ result.score }}%
          </div>
        </div>

        <h2 class="result-title">{{ result.passed ? 'Reussi !' : 'Dommage...' }}</h2>
        <p class="result-sub">{{ result.correctAnswers }}/{{ result.totalQuestions }} bonnes reponses</p>

        <transition name="fade">
          <div v-if="result.passed && result.xpEarned > 0" class="xp-badge">
            <span class="xp-star">&#11088;</span>
            <div>
              <div class="xp-badge-label">XP gagnes</div>
              <div class="xp-badge-val">+{{ result.xpEarned }} XP</div>
            </div>
          </div>
        </transition>

        <div v-if="result.questionResults?.length > 0" class="q-results">
          <div
            v-for="(qr, index) in result.questionResults"
            :key="qr.questionId"
            class="q-result-row"
            :class="qr.correct ? 'q-correct' : 'q-wrong'"
          >
            <span class="q-result-icon">{{ qr.correct ? '&#10003;' : '&#10007;' }}</span>
            <div class="q-result-info">
              <div class="q-result-text">{{ questionForId(qr.questionId)?.text || 'Question ' + (index + 1) }}</div>
              <div v-if="!qr.correct && qr.explanation" class="q-result-expl">{{ qr.explanation }}</div>
            </div>
          </div>
        </div>

        <router-link to="/quizzes" class="btn-back-quizzes">Retour aux quiz</router-link>
      </div>

      <!-- Pas de questions -->
      <div v-else-if="!loading" class="empty-state">
        <p>Ce quiz ne contient pas encore de questions.</p>
        <router-link to="/quizzes" class="empty-link">Retour aux quiz</router-link>
      </div>

    </div>
  </MainLayout>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRoute } from 'vue-router'
import MainLayout from '@/components/layout/MainLayout.vue'
import { useAuthStore } from '@/stores/auth'
import api from '@/services/api'

const route = useRoute()
const authStore = useAuthStore()

const quiz = ref(null)
const questions = ref([])
const currentIndex = ref(0)
const selectedAnswers = ref({})
const submitted = ref(false)
const submitting = ref(false)
const result = ref(null)
const loading = ref(true)
const timeLeft = ref(null)
let timerInterval = null

const formattedTime = computed(() => {
  if (timeLeft.value === null) return ''
  const m = Math.floor(timeLeft.value / 60)
  const s = timeLeft.value % 60
  return `${m}:${s.toString().padStart(2, '0')}`
})

function startTimer(seconds) {
  timeLeft.value = seconds
  timerInterval = setInterval(() => {
    timeLeft.value--
    if (timeLeft.value <= 0) {
      clearInterval(timerInterval)
      submitQuiz()
    }
  }, 1000)
}

onUnmounted(() => {
  if (timerInterval) clearInterval(timerInterval)
})

const currentQuestion = computed(() => questions.value[currentIndex.value] || {})

function questionForId(id) {
  return questions.value.find(q => q.id === id)
}

async function fetchQuiz() {
  try {
    const [quizRes, questionsRes] = await Promise.all([
      api.get(`/quizzes/${route.params.quizId}`),
      api.get(`/quizzes/${route.params.quizId}/questions`)
    ])
    quiz.value = quizRes.data
    questions.value = questionsRes.data
    questions.value.forEach(q => { selectedAnswers.value[q.id] = [] })
    if (quiz.value.timeLimitSeconds > 0) {
      startTimer(quiz.value.timeLimitSeconds)
    }
  } catch (error) {
    console.error('Erreur chargement quiz:', error)
  } finally {
    loading.value = false
  }
}

async function submitQuiz() {
  if (submitting.value) return
  if (timerInterval) clearInterval(timerInterval)
  submitting.value = true
  try {
    const response = await api.post(`/quizzes/${route.params.quizId}/submit`, {
      answers: selectedAnswers.value
    })
    result.value = response.data
    submitted.value = true

    if (result.value.passed && result.value.xpEarned > 0 && authStore.user?.id) {
      try {
        const progress = await api.get(`/gamification/progress/${authStore.user.id}`)
        authStore.setProgress(progress.data.totalXp, progress.data.currentLevel)
      } catch (e) {
        console.error('Erreur mise a jour XP:', e)
      }
    }
  } catch (error) {
    console.error('Erreur soumission quiz:', error)
  } finally {
    submitting.value = false
  }
}

onMounted(() => {
  fetchQuiz()
})
</script>

<style scoped>
.quiz-page {
  max-width: 640px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

/* Skeleton */
.skeleton-wrap { display: flex; flex-direction: column; gap: 16px; }
.skeleton-header {
  height: 88px;
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 16px;
  animation: pulse 1.4s ease infinite;
}
.skeleton-body {
  height: 320px;
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 16px;
  animation: pulse 1.4s ease infinite;
  animation-delay: 0.2s;
}
@keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.4; } }

/* Header */
.quiz-header {
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 16px;
  padding: 18px 20px 14px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.quiz-header-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}
.quiz-title {
  font-size: 16px;
  font-weight: 700;
  color: var(--c-text);
  flex: 1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.quiz-header-meta {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-shrink: 0;
}
.timer {
  font-size: 13px;
  font-weight: 700;
  font-family: var(--font-mono);
  color: var(--c-text-2);
  background: var(--c-surface-2);
  border: 1px solid var(--c-border);
  padding: 4px 10px;
  border-radius: 8px;
}
.timer-urgent {
  color: var(--c-red);
  border-color: rgba(239, 68, 68, 0.3);
  background: var(--c-red-soft);
  animation: pulse 0.8s ease infinite;
}
.progress-counter {
  font-size: 12px;
  font-weight: 600;
  font-family: var(--font-mono);
  color: var(--c-muted);
  background: var(--c-surface-2);
  border: 1px solid var(--c-border);
  padding: 4px 10px;
  border-radius: 8px;
}

.progress-bar-wrap {
  width: 100%;
  height: 3px;
  background: var(--c-surface-2);
  border-radius: 100px;
  overflow: hidden;
}
.progress-bar {
  height: 100%;
  background: var(--c-accent);
  border-radius: 100px;
  transition: width 0.4s ease;
}

.progress-dots {
  display: flex;
  gap: 4px;
  flex-wrap: wrap;
}
.dot {
  width: 6px;
  height: 6px;
  border-radius: 100px;
  transition: background 0.2s;
}
.dot-done { background: var(--c-accent); }
.dot-active { background: var(--c-accent-light); width: 14px; }
.dot-pending { background: var(--c-subtle); }

/* Question */
.question-card {
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 18px;
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.question-text {
  font-size: 16px;
  font-weight: 600;
  color: var(--c-text);
  line-height: 1.6;
}
.question-code {
  background: #0d0d10;
  border: 1px solid var(--c-border-md);
  border-radius: 10px;
  padding: 16px;
  font-family: var(--font-mono);
  font-size: 12px;
  color: #86efac;
  overflow-x: auto;
}
.question-code pre { margin: 0; }

/* Answers */
.answers-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.answer-option {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 14px 16px;
  border: 1px solid var(--c-border-md);
  border-radius: 12px;
  cursor: pointer;
  transition: border-color var(--t), background var(--t);
  background: var(--c-surface-2);
  text-align: left;
  width: 100%;
}
.answer-option:hover { border-color: var(--c-accent-glow); background: var(--c-accent-soft); }
.answer-selected {
  border-color: var(--c-accent) !important;
  background: var(--c-accent-soft) !important;
}
.hidden-input { display: none; }

.answer-check {
  width: 18px;
  height: 18px;
  border-radius: 4px;
  border: 1.5px solid var(--c-border-strong);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  font-size: 11px;
  font-weight: 700;
  color: white;
  transition: background var(--t), border-color var(--t);
}
.checked {
  background: var(--c-accent);
  border-color: var(--c-accent);
}

.answer-letter {
  width: 30px;
  height: 30px;
  border-radius: 8px;
  border: 1.5px solid var(--c-border-strong);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 700;
  font-family: var(--font-mono);
  color: var(--c-muted);
  flex-shrink: 0;
  transition: background var(--t), border-color var(--t), color var(--t);
}
.letter-selected {
  background: var(--c-accent);
  border-color: var(--c-accent);
  color: white;
}

.answer-text {
  font-size: 14px;
  color: var(--c-text-2);
  flex: 1;
}
.answer-selected .answer-text { color: var(--c-text); }

/* Navigation */
.quiz-nav {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  padding-top: 4px;
}
.btn-prev {
  padding: 10px 20px;
  border: 1px solid var(--c-border-md);
  border-radius: 10px;
  background: transparent;
  color: var(--c-text-2);
  font-size: 13px;
  font-weight: 500;
  transition: border-color var(--t), background var(--t);
}
.btn-prev:hover { border-color: var(--c-border-strong); background: var(--c-surface-2); }
.btn-next {
  padding: 10px 24px;
  background: var(--c-accent);
  color: white;
  border: none;
  border-radius: 10px;
  font-size: 13px;
  font-weight: 600;
  transition: opacity var(--t), transform var(--t);
}
.btn-next:hover { opacity: 0.88; transform: translateY(-1px); }
.btn-submit {
  padding: 10px 24px;
  background: var(--c-green);
  color: white;
  border: none;
  border-radius: 10px;
  font-size: 13px;
  font-weight: 600;
  transition: opacity var(--t), transform var(--t);
}
.btn-submit:hover { opacity: 0.88; transform: translateY(-1px); }
.btn-submit:disabled { opacity: 0.5; transform: none; }

/* Results */
.results-card {
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 18px;
  padding: 36px 28px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 16px;
  text-align: center;
}
.score-ring-wrap { position: relative; width: 128px; height: 128px; }
.score-svg { transform: rotate(-90deg); }
.score-circle { transition: stroke-dashoffset 1s ease; }
.score-label {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 22px;
  font-weight: 800;
  font-family: var(--font-mono);
}
.score-pass { color: var(--c-green); }
.score-fail { color: var(--c-red); }

.result-title {
  font-family: var(--font-serif);
  font-size: 24px;
  font-weight: 700;
  color: var(--c-text);
}
.result-sub { font-size: 13px; color: var(--c-muted); margin-top: -8px; }

.xp-badge {
  display: flex;
  align-items: center;
  gap: 12px;
  background: var(--c-amber-soft);
  border: 1px solid rgba(245, 158, 11, 0.2);
  padding: 14px 20px;
  border-radius: 14px;
}
.xp-star { font-size: 22px; }
.xp-badge-label { font-size: 11px; color: var(--c-muted); }
.xp-badge-val { font-size: 16px; font-weight: 700; color: var(--c-amber-light); }

.q-results {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 6px;
  text-align: left;
}
.q-result-row {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 10px 14px;
  border-radius: 10px;
  border: 1px solid transparent;
}
.q-correct { background: var(--c-green-soft); border-color: rgba(34, 197, 94, 0.15); }
.q-wrong { background: var(--c-red-soft); border-color: rgba(239, 68, 68, 0.15); }
.q-result-icon {
  font-size: 13px;
  font-weight: 700;
  flex-shrink: 0;
  margin-top: 1px;
}
.q-correct .q-result-icon { color: var(--c-green); }
.q-wrong .q-result-icon { color: var(--c-red); }
.q-result-text { font-size: 13px; font-weight: 500; color: var(--c-text-2); }
.q-result-expl { font-size: 12px; color: var(--c-muted); margin-top: 2px; }

.btn-back-quizzes {
  display: inline-block;
  padding: 11px 28px;
  background: var(--c-accent);
  color: white;
  border-radius: 10px;
  font-size: 13px;
  font-weight: 600;
  text-decoration: none;
  transition: opacity var(--t), transform var(--t);
}
.btn-back-quizzes:hover { opacity: 0.88; transform: translateY(-1px); }

/* Empty */
.empty-state {
  text-align: center;
  padding: 48px;
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 18px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  align-items: center;
  color: var(--c-muted);
  font-size: 14px;
}
.empty-link {
  color: var(--c-accent-light);
  font-weight: 500;
  transition: opacity var(--t);
}
.empty-link:hover { opacity: 0.75; }

.fade-enter-active, .fade-leave-active { transition: opacity 0.3s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>
