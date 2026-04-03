<template>
  <MainLayout>
    <div class="max-w-7xl mx-auto">
      <h1 class="text-3xl font-bold text-gray-900 mb-8">Quiz</h1>

      <div v-if="loading" class="text-center py-12">
        <div class="text-gray-500">Chargement...</div>
      </div>

      <div v-else class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
        <router-link
          v-for="quiz in quizzes"
          :key="quiz.id"
          :to="`/quizzes/${quiz.id}`"
          class="bg-white rounded-xl shadow hover:shadow-lg transition-shadow p-6 relative"
        >
          <!-- Badge complétion -->
          <div
            v-if="bestScores[quiz.id]"
            class="absolute top-4 right-4 flex items-center space-x-1 text-xs font-semibold px-2 py-1 rounded-full"
            :class="bestScores[quiz.id].passed ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-600'"
          >
            <span>{{ bestScores[quiz.id].passed ? '✅' : '📝' }}</span>
            <span>{{ bestScores[quiz.id].score }}%</span>
          </div>

          <h3 class="text-xl font-bold text-gray-900 mb-2 pr-16">{{ quiz.title }}</h3>
          <p class="text-gray-600 text-sm mb-4">{{ quiz.description }}</p>
          <div class="flex items-center justify-between">
            <span class="text-sm text-gray-500">{{ quiz.questionCount }} questions</span>
            <span class="px-3 py-1 bg-yellow-100 text-yellow-700 rounded-full text-sm">
              +{{ quiz.xpReward }} XP
            </span>
          </div>
          <div class="mt-4 text-sm text-gray-500">
            Score minimum: {{ quiz.passingScore }}%
          </div>
        </router-link>
      </div>

      <div v-if="!loading && quizzes.length === 0" class="text-center py-12">
        <div class="text-gray-500">Aucun quiz disponible</div>
      </div>
    </div>
  </MainLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
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
    // Garder le meilleur score par quiz
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

onMounted(async () => {
  await fetchQuizzes()
  fetchQuizHistory()
})
</script>
