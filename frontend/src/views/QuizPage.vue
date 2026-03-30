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

          <div class="space-y-3">
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
                class="sr-only"
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
              class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors"
            >
              Terminer
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
        <p class="text-gray-600 mb-6">
          Score: {{ result.score }}% ({{ result.correctAnswers }}/{{ result.totalQuestions }})
        </p>
        <div v-if="result.passed" class="text-yellow-500 font-semibold mb-6">
          +{{ result.xpEarned }} XP gagnes!
        </div>
        <router-link
          to="/quizzes"
          class="inline-block px-6 py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition-colors"
        >
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
import api from '@/services/api'

const route = useRoute()

const quiz = ref(null)
const questions = ref([])
const currentIndex = ref(0)
const selectedAnswers = ref({})
const submitted = ref(false)
const result = ref(null)
const loading = ref(true)

const currentQuestion = computed(() => questions.value[currentIndex.value] || {})

async function fetchQuiz() {
  try {
    const [quizRes, questionsRes] = await Promise.all([
      api.get(`/quizzes/${route.params.quizId}`),
      api.get(`/quizzes/${route.params.quizId}/questions`)
    ])
    quiz.value = quizRes.data
    questions.value = questionsRes.data
    
    // Initialiser les reponses
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
  try {
    const response = await api.post(`/quizzes/${route.params.quizId}/submit`, {
      answers: selectedAnswers.value
    })
    result.value = response.data
    submitted.value = true
  } catch (error) {
    console.error('Erreur soumission quiz:', error)
  }
}

onMounted(() => {
  fetchQuiz()
})
</script>
