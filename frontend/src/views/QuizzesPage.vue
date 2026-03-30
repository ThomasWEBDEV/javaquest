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
          class="bg-white rounded-xl shadow hover:shadow-lg transition-shadow p-6"
        >
          <h3 class="text-xl font-bold text-gray-900 mb-2">{{ quiz.title }}</h3>
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
import api from '@/services/api'

const quizzes = ref([])
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

onMounted(() => {
  fetchQuizzes()
})
</script>
