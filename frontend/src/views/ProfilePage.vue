<template>
  <MainLayout>
    <div class="max-w-4xl mx-auto">
      <h1 class="text-3xl font-bold text-gray-900 mb-8">Mon Profil</h1>

      <div class="grid md:grid-cols-3 gap-6">
        <!-- User Info -->
        <div class="md:col-span-1">
          <div class="bg-white rounded-xl shadow p-6 text-center">
            <div class="w-24 h-24 bg-indigo-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <span class="text-4xl text-indigo-600 font-bold">
                {{ authStore.user?.username?.charAt(0).toUpperCase() }}
              </span>
            </div>
            <h2 class="text-xl font-bold text-gray-900">{{ authStore.user?.username }}</h2>
            <p class="text-gray-500">{{ authStore.user?.email }}</p>
            
            <div class="mt-6 pt-6 border-t">
              <div class="text-3xl font-bold text-indigo-600">Niveau {{ stats.currentLevel }}</div>
              <div class="text-sm text-gray-500 mt-1">{{ stats.totalXp }} XP total</div>
            </div>
          </div>
        </div>

        <!-- Stats -->
        <div class="md:col-span-2">
          <div class="bg-white rounded-xl shadow p-6 mb-6">
            <h2 class="text-xl font-bold text-gray-900 mb-4">Statistiques</h2>
            
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
              <div class="text-center p-4 bg-gray-50 rounded-lg">
                <div class="text-2xl font-bold text-green-600">{{ stats.exercisesCompleted }}</div>
                <div class="text-sm text-gray-500">Exercices</div>
              </div>
              <div class="text-center p-4 bg-gray-50 rounded-lg">
                <div class="text-2xl font-bold text-blue-600">{{ stats.quizzesPassed }}</div>
                <div class="text-sm text-gray-500">Quiz reussis</div>
              </div>
              <div class="text-center p-4 bg-gray-50 rounded-lg">
                <div class="text-2xl font-bold text-orange-600">{{ stats.currentStreak }}</div>
                <div class="text-sm text-gray-500">Serie actuelle</div>
              </div>
              <div class="text-center p-4 bg-gray-50 rounded-lg">
                <div class="text-2xl font-bold text-purple-600">{{ stats.longestStreak }}</div>
                <div class="text-sm text-gray-500">Meilleure serie</div>
              </div>
            </div>

            <div class="mt-6">
              <div class="flex justify-between text-sm text-gray-600 mb-2">
                <span>Progression vers niveau {{ stats.currentLevel + 1 }}</span>
                <span>{{ stats.xpForNextLevel }} XP restants</span>
              </div>
              <div class="w-full bg-gray-200 rounded-full h-3">
                <div 
                  class="bg-indigo-600 h-3 rounded-full transition-all"
                  :style="{ width: progressPercent + '%' }"
                ></div>
              </div>
            </div>
          </div>

          <!-- Badges -->
          <div class="bg-white rounded-xl shadow p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-4">Mes Badges</h2>
            
            <div v-if="badges.length > 0" class="grid grid-cols-2 md:grid-cols-3 gap-4">
              <div 
                v-for="badge in badges" 
                :key="badge.id"
                class="p-4 bg-gradient-to-br from-yellow-50 to-yellow-100 rounded-lg text-center border border-yellow-200"
              >
                <div class="text-3xl mb-2">🏆</div>
                <div class="font-semibold text-gray-900">{{ badge.name }}</div>
                <div class="text-xs text-gray-500 mt-1">{{ badge.description }}</div>
              </div>
            </div>
            <div v-else class="text-center py-8 text-gray-500">
              Aucun badge pour le moment. Continuez a apprendre!
            </div>
          </div>
        </div>
      </div>

      <!-- Quiz History -->
      <div class="bg-white rounded-xl shadow p-6 mt-6">
        <h2 class="text-xl font-bold text-gray-900 mb-4">Historique des Quiz</h2>
        
        <div v-if="quizHistory.length > 0" class="space-y-3">
          <div 
            v-for="attempt in quizHistory" 
            :key="attempt.attemptedAt"
            class="flex items-center justify-between p-4 bg-gray-50 rounded-lg"
          >
            <div>
              <div class="font-medium text-gray-900">{{ attempt.quizTitle }}</div>
              <div class="text-sm text-gray-500">
                {{ new Date(attempt.attemptedAt).toLocaleDateString('fr-FR') }}
              </div>
            </div>
            <div class="text-right">
              <div 
                class="font-bold"
                :class="attempt.passed ? 'text-green-600' : 'text-red-600'"
              >
                {{ attempt.score }}%
              </div>
              <div class="text-sm text-gray-500">
                {{ attempt.correctAnswers }}/{{ attempt.totalQuestions }}
              </div>
            </div>
          </div>
        </div>
        <div v-else class="text-center py-8 text-gray-500">
          Aucun quiz complete
        </div>
      </div>
    </div>
  </MainLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
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

onMounted(() => {
  fetchStats()
  fetchBadges()
  fetchQuizHistory()
})
</script>
