<template>
  <MainLayout>
    <div class="max-w-3xl mx-auto">
      <div v-if="loading" class="text-center py-12">
        <div class="text-gray-500">Chargement...</div>
      </div>

      <!-- Quiz en cours -->
      <div v-else-if="!submitted && questions.length > 0">
        <div class="bg-white rounded-xl shadow p-6 mb-6">
          <div class="flex items-center justify-between mb-4">
            <h1 class="text-2xl font-bold text-gray-900">{{ quiz?.title }}</h1>
            <span class="text-sm text-gray-500">
              Question {{ currentIndex + 1 }} / {{ questions.length }}
            </span>
          </div>
          <div class="w-full bg-gray-200 rounded-full h-2">
            <div
              class="bg-indigo-600 h-2 rounded-full transition-all"
              :style="{ width: ((currentIndex + 1) / questions.length * 100) + '%' }"
            ></div>
          </div>
        </div>

        <div class="bg-white rounded-xl shadow p-6">
          <h2 class="text-xl font-semibold text-gray-900 mb-6">{{ currentQuestion.text }}</h2>

          <div v-if="currentQuestion.codeSnippet" class="bg-gray-900 text-green-400 p-4 rounded-lg font-mono text-sm mb-6">
            <pre>{{ currentQuestion.codeSnippet }}</pre>
          </div>

          <!-- Choix multiples (checkbox) -->
          <div v-if="currentQuestion.questionType === 'MULTIPLE_CHOICE'" class="space-y-3">
            <label
              v-for="answer in currentQuestion.answers"
              :key="answer.id"
              class="flex items-center p-4 border rounded-lg cursor-pointer transition-colors"
              :class="selectedAnswers[currentQuestion.id]?.includes(answer.id) ? 'border-indigo-500 bg-indigo-50' : 'border-gray-200 hover:bg-gray-50'"
            >
              <input
                type="checkbox"
                :value="answer.id"
                v-model="selectedAnswers[currentQuestion.id]"
                class="mr-3 h-4 w-4 text-indigo-600"
              />
              <span class="flex-1">{{ answer.text }}</span>
            </label>
          </div>

          <!-- Choix unique (radio) -->
          <div v-else class="space-y-3">
            <label
              v-for="answer in currentQuestion.answers"
              :key="answer.id"
              class="flex items-center p-4 border rounded-lg cursor-pointer transition-colors"
              :class="selectedAnswers[currentQuestion.id]?.[0] === answer.id ? 'border-indigo-500 bg-indigo-50' : 'border-gray-200 hover:bg-gray-50'"
            >
              <input
                type="radio"
                :name="`question-${currentQuestion.id}`"
                :value="answer.id"
                :checked="selectedAnswers[currentQuestion.id]?.[0] === answer.id"
                @change="selectedAnswers[currentQuestion.id] = [answer.id]"
                class="mr-3 h-4 w-4 text-indigo-600"
              />
              <span class="flex-1">{{ answer.text }}</span>
            </label>
          </div>

          <div class="flex justify-between mt-8">
            <button
              v-if="currentIndex > 0"
              @click="currentIndex--"
              class="px-6 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
            >
              Precedent
            </button>
            <div v-else></div>

            <button
              v-if="currentIndex < questions.length - 1"
              @click="currentIndex++"
              class="px-6 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition-colors"
            >
              Suivant
            </button>
            <button
              v-else
              @click="submitQuiz"
              :disabled="submitting"
              class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors disabled:opacity-50"
            >
              {{ submitting ? 'Envoi...' : 'Terminer' }}
            </button>
          </div>
        </div>
      </div>

      <!-- Resultats -->
      <div v-else-if="submitted && result" class="bg-white rounded-xl shadow p-8 text-center">
        <div
          class="w-24 h-24 rounded-full flex items-center justify-center mx-auto mb-6"
          :class="result.passed ? 'bg-green-100' : 'bg-red-100'"
        >
          <span class="text-4xl">{{ result.passed ? '🎉' : '😔' }}</span>
        </div>
        <h2 class="text-2xl font-bold text-gray-900 mb-2">
          {{ result.passed ? 'Felicitations!' : 'Dommage...' }}
        </h2>
        <p class="text-gray-600 mb-4">
          Score: {{ result.score }}% ({{ result.correctAnswers }}/{{ result.totalQuestions }})
        </p>

        <!-- Toast XP -->
        <transition name="fade">
          <div
            v-if="result.passed && result.xpEarned > 0"
            class="inline-flex items-center space-x-2 bg-yellow-50 border border-yellow-300 text-yellow-800 px-6 py-3 rounded-lg font-semibold mb-6"
          >
            <span class="text-xl">⭐</span>
            <span>+{{ result.xpEarned }} XP gagnes!</span>
          </div>
        </transition>

        <!-- Resultats par question -->
        <div v-if="result.questionResults?.length > 0" class="text-left mt-6 space-y-3 mb-6">
          <div
            v-for="(qr, index) in result.questionResults"
            :key="qr.questionId"
            class="flex items-start p-3 rounded-lg"
            :class="qr.correct ? 'bg-green-50' : 'bg-red-50'"
          >
            <span class="text-lg mr-3 mt-0.5">{{ qr.correct ? '✅' : '❌' }}</span>
            <div class="text-sm text-gray-700">
              <div class="font-medium mb-1">{{ questionForId(qr.questionId)?.text || 'Question ' + (index + 1) }}</div>
              <div v-if="!qr.correct && qr.explanation" class="text-gray-500">{{ qr.explanation }}</div>
            </div>
          </div>
        </div>

        <router-link
          to="/quizzes"
          class="inline-block px-6 py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition-colors"
        >
          Retour aux quiz
        </router-link>
      </div>

      <!-- Aucune question -->
      <div v-else-if="!loading" class="bg-white rounded-xl shadow p-8 text-center">
        <p class="text-gray-500">Ce quiz ne contient pas encore de questions.</p>
        <router-link to="/quizzes" class="mt-4 inline-block text-indigo-600 hover:underline">
          Retour aux quiz
        </router-link>
      </div>
    </div>
  </MainLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
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

    // Initialiser les reponses comme tableau vide pour chaque question
    questions.value.forEach(q => {
      selectedAnswers.value[q.id] = []
    })
  } catch (error) {
    console.error('Erreur chargement quiz:', error)
  } finally {
    loading.value = false
  }
}

async function submitQuiz() {
  submitting.value = true
  try {
    const response = await api.post(`/quizzes/${route.params.quizId}/submit`, {
      answers: selectedAnswers.value
    })
    result.value = response.data
    submitted.value = true

    // Mettre a jour le store XP si l'utilisateur est connecte et a gagne des XP
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
