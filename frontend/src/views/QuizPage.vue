<template>
  <MainLayout>
    <div class="max-w-3xl mx-auto">
      <div v-if="loading" class="space-y-4">
        <div class="bg-white rounded-2xl border border-gray-100 p-6 animate-pulse">
          <div class="h-7 bg-gray-200 rounded-lg w-64 mb-4"></div>
          <div class="h-3 bg-gray-100 rounded-full"></div>
        </div>
        <div class="bg-white rounded-2xl border border-gray-100 p-6 animate-pulse">
          <div class="h-6 bg-gray-200 rounded-lg w-3/4 mb-6"></div>
          <div class="space-y-3">
            <div v-for="i in 4" :key="i" class="h-14 bg-gray-100 rounded-xl"></div>
          </div>
        </div>
      </div>

      <!-- Quiz en cours -->
      <div v-else-if="!submitted && questions.length > 0">
        <!-- Header -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5 mb-5">
          <div class="flex items-center justify-between mb-4">
            <h1 class="text-xl font-bold text-gray-900 truncate mr-4">{{ quiz?.title }}</h1>
            <div class="flex items-center gap-3 shrink-0">
              <span
                v-if="timeLeft !== null"
                class="text-sm font-bold px-3 py-1.5 rounded-xl"
                :class="timeLeft <= 30 ? 'bg-red-100 text-red-700 animate-pulse' : 'bg-gray-100 text-gray-600'"
              >
                ⏱ {{ formattedTime }}
              </span>
              <span class="text-sm font-semibold text-gray-500 bg-gray-100 px-3 py-1.5 rounded-xl">
                {{ currentIndex + 1 }} / {{ questions.length }}
              </span>
            </div>
          </div>
          <!-- Barre progression -->
          <div class="w-full bg-gray-100 rounded-full h-2.5 overflow-hidden">
            <div
              class="bg-gradient-to-r from-indigo-500 to-purple-500 h-2.5 rounded-full transition-all duration-500"
              :style="{ width: ((currentIndex + 1) / questions.length * 100) + '%' }"
            ></div>
          </div>
          <!-- Points indicateurs -->
          <div class="flex justify-between mt-2">
            <div
              v-for="(q, i) in questions"
              :key="q.id"
              class="w-2 h-2 rounded-full transition-colors"
              :class="i < currentIndex ? 'bg-indigo-400' : i === currentIndex ? 'bg-indigo-600' : 'bg-gray-200'"
            ></div>
          </div>
        </div>

        <!-- Question -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
          <h2 class="text-lg font-semibold text-gray-900 mb-5 leading-relaxed">{{ currentQuestion.text }}</h2>

          <div v-if="currentQuestion.codeSnippet" class="bg-gray-950 text-green-300 p-4 rounded-xl font-mono text-sm mb-6 overflow-x-auto">
            <pre>{{ currentQuestion.codeSnippet }}</pre>
          </div>

          <!-- Choix multiples (checkbox) -->
          <div v-if="currentQuestion.questionType === 'MULTIPLE_CHOICE'" class="space-y-3">
            <label
              v-for="answer in currentQuestion.answers"
              :key="answer.id"
              class="flex items-center gap-4 p-4 border-2 rounded-xl cursor-pointer transition-all select-none"
              :class="selectedAnswers[currentQuestion.id]?.includes(answer.id)
                ? 'border-indigo-500 bg-indigo-50 text-indigo-900'
                : 'border-gray-200 hover:border-indigo-200 hover:bg-gray-50'"
            >
              <div
                class="w-5 h-5 rounded border-2 flex items-center justify-center shrink-0 transition-colors"
                :class="selectedAnswers[currentQuestion.id]?.includes(answer.id)
                  ? 'border-indigo-500 bg-indigo-500'
                  : 'border-gray-300'"
              >
                <span v-if="selectedAnswers[currentQuestion.id]?.includes(answer.id)" class="text-white text-xs font-bold">✓</span>
              </div>
              <input type="checkbox" :value="answer.id" v-model="selectedAnswers[currentQuestion.id]" class="hidden" />
              <span class="flex-1 text-sm">{{ answer.text }}</span>
            </label>
          </div>

          <!-- Choix unique (radio) -->
          <div v-else class="space-y-3">
            <button
              v-for="(answer, idx) in currentQuestion.answers"
              :key="answer.id"
              @click="selectedAnswers[currentQuestion.id] = [answer.id]"
              class="w-full flex items-center gap-4 p-4 border-2 rounded-xl cursor-pointer transition-all text-left"
              :class="selectedAnswers[currentQuestion.id]?.[0] === answer.id
                ? 'border-indigo-500 bg-indigo-50'
                : 'border-gray-200 hover:border-indigo-200 hover:bg-gray-50'"
            >
              <div
                class="w-8 h-8 rounded-xl border-2 flex items-center justify-center shrink-0 font-bold text-sm transition-colors"
                :class="selectedAnswers[currentQuestion.id]?.[0] === answer.id
                  ? 'border-indigo-500 bg-indigo-500 text-white'
                  : 'border-gray-300 text-gray-400'"
              >
                {{ ['A','B','C','D'][idx] }}
              </div>
              <span class="flex-1 text-sm text-gray-800">{{ answer.text }}</span>
            </button>
          </div>

          <div class="flex justify-between mt-8 gap-3">
            <button
              v-if="currentIndex > 0"
              @click="currentIndex--"
              class="px-6 py-3 border-2 border-gray-200 rounded-xl hover:bg-gray-50 transition-colors font-medium text-gray-600 text-sm"
            >
              ← Précédent
            </button>
            <div v-else></div>

            <button
              v-if="currentIndex < questions.length - 1"
              @click="currentIndex++"
              class="px-8 py-3 bg-indigo-600 text-white rounded-xl hover:bg-indigo-700 transition-colors font-semibold text-sm"
            >
              Suivant →
            </button>
            <button
              v-else
              @click="submitQuiz"
              :disabled="submitting"
              class="px-8 py-3 bg-gradient-to-r from-green-500 to-emerald-600 text-white rounded-xl hover:opacity-90 transition-opacity font-semibold text-sm disabled:opacity-50"
            >
              {{ submitting ? 'Envoi...' : '✓ Terminer le quiz' }}
            </button>
          </div>
        </div>
      </div>

      <!-- Resultats -->
      <div v-else-if="submitted && result" class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8 text-center">
        <!-- Score visuel -->
        <div class="relative w-32 h-32 mx-auto mb-6">
          <svg class="w-32 h-32 -rotate-90" viewBox="0 0 120 120">
            <circle cx="60" cy="60" r="50" fill="none" stroke="#e5e7eb" stroke-width="10"/>
            <circle
              cx="60" cy="60" r="50" fill="none"
              :stroke="result.passed ? '#10b981' : '#ef4444'"
              stroke-width="10"
              stroke-linecap="round"
              :stroke-dasharray="314"
              :stroke-dashoffset="314 - (314 * result.score / 100)"
              class="transition-all duration-1000"
            />
          </svg>
          <div class="absolute inset-0 flex flex-col items-center justify-center">
            <span class="text-2xl font-extrabold" :class="result.passed ? 'text-green-600' : 'text-red-500'">{{ result.score }}%</span>
          </div>
        </div>

        <h2 class="text-2xl font-bold text-gray-900 mb-2">
          {{ result.passed ? 'Félicitations !' : 'Dommage...' }}
        </h2>
        <p class="text-gray-500 mb-6">
          {{ result.correctAnswers }}/{{ result.totalQuestions }} bonnes réponses
        </p>

        <!-- Toast XP -->
        <transition name="fade">
          <div
            v-if="result.passed && result.xpEarned > 0"
            class="inline-flex items-center gap-3 bg-yellow-50 border border-yellow-200 text-yellow-800 px-6 py-3 rounded-2xl font-semibold mb-6"
          >
            <span class="text-2xl">⭐</span>
            <div class="text-left">
              <div class="text-sm font-normal text-yellow-600">XP gagnés</div>
              <div>+{{ result.xpEarned }} XP</div>
            </div>
          </div>
        </transition>

        <!-- Résultats par question -->
        <div v-if="result.questionResults?.length > 0" class="text-left mt-4 space-y-2 mb-6">
          <div
            v-for="(qr, index) in result.questionResults"
            :key="qr.questionId"
            class="flex items-start gap-3 p-3 rounded-xl"
            :class="qr.correct ? 'bg-green-50 border border-green-100' : 'bg-red-50 border border-red-100'"
          >
            <span class="text-lg shrink-0">{{ qr.correct ? '✅' : '❌' }}</span>
            <div class="text-sm">
              <div class="font-medium text-gray-800">{{ questionForId(qr.questionId)?.text || 'Question ' + (index + 1) }}</div>
              <div v-if="!qr.correct && qr.explanation" class="text-gray-500 mt-0.5">{{ qr.explanation }}</div>
            </div>
          </div>
        </div>

        <router-link
          to="/quizzes"
          class="inline-block px-8 py-3 bg-indigo-600 text-white rounded-xl hover:bg-indigo-700 transition-colors font-semibold"
        >
          Retour aux quiz
        </router-link>
      </div>

      <!-- Aucune question -->
      <div v-else-if="!loading" class="bg-white rounded-2xl shadow-sm border border-gray-100 p-10 text-center">
        <p class="text-gray-500 mb-4">Ce quiz ne contient pas encore de questions.</p>
        <router-link to="/quizzes" class="text-indigo-600 hover:underline font-medium">
          Retour aux quiz
        </router-link>
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

    questions.value.forEach(q => {
      selectedAnswers.value[q.id] = []
    })

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
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
