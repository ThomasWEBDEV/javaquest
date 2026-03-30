<template>
  <MainLayout>
    <div class="max-w-7xl mx-auto">
      <h1 class="text-3xl font-bold text-gray-900 mb-8">Tableau de bord</h1>

      <!-- Stats Cards -->
      <div class="grid md:grid-cols-4 gap-6 mb-8">
        <div class="bg-white rounded-xl shadow p-6">
          <div class="text-sm text-gray-500 mb-1">XP Total</div>
          <div class="text-3xl font-bold text-yellow-500">{{ stats.totalXp }}</div>
        </div>
        <div class="bg-white rounded-xl shadow p-6">
          <div class="text-sm text-gray-500 mb-1">Niveau</div>
          <div class="text-3xl font-bold text-indigo-600">{{ stats.currentLevel }}</div>
        </div>
        <div class="bg-white rounded-xl shadow p-6">
          <div class="text-sm text-gray-500 mb-1">Serie actuelle</div>
          <div class="text-3xl font-bold text-orange-500">{{ stats.currentStreak }} jours</div>
        </div>
        <div class="bg-white rounded-xl shadow p-6">
          <div class="text-sm text-gray-500 mb-1">Badges</div>
          <div class="text-3xl font-bold text-purple-600">{{ stats.badgesCount }}</div>
        </div>
      </div>

      <!-- Progress Section -->
      <div class="grid md:grid-cols-2 gap-6 mb-8">
        <div class="bg-white rounded-xl shadow p-6">
          <h2 class="text-xl font-bold text-gray-900 mb-4">Progression</h2>
          <div class="mb-4">
            <div class="flex justify-between text-sm text-gray-600 mb-1">
              <span>Niveau {{ stats.currentLevel }}</span>
              <span>{{ stats.xpForNextLevel }} XP pour niveau {{ stats.currentLevel + 1 }}</span>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-3">
              <div 
                class="bg-indigo-600 h-3 rounded-full transition-all"
                :style="{ width: progressPercent + '%' }"
              ></div>
            </div>
          </div>
          <div class="grid grid-cols-2 gap-4 text-center">
            <div>
              <div class="text-2xl font-bold text-green-600">{{ stats.exercisesCompleted }}</div>
              <div class="text-sm text-gray-500">Exercices completes</div>
            </div>
            <div>
              <div class="text-2xl font-bold text-blue-600">{{ stats.quizzesPassed }}</div>
              <div class="text-sm text-gray-500">Quiz reussis</div>
            </div>
          </div>
        </div>

        <div class="bg-white rounded-xl shadow p-6">
          <h2 class="text-xl font-bold text-gray-900 mb-4">Defi du jour</h2>
          <div v-if="todayChallenge" class="space-y-4">
            <h3 class="font-semibold text-gray-800">{{ todayChallenge.title }}</h3>
            <p class="text-gray-600 text-sm">{{ todayChallenge.description }}</p>
            <div class="flex items-center space-x-4">
              <span class="px-3 py-1 bg-yellow-100 text-yellow-700 rounded-full text-sm">
                +{{ todayChallenge.xpReward }} XP
              </span>
              <span class="px-3 py-1 bg-green-100 text-green-700 rounded-full text-sm">
                Bonus: +{{ todayChallenge.bonusXp }} XP
              </span>
            </div>
            <router-link 
              to="/challenge"
              class="block w-full py-2 bg-indigo-600 text-white text-center rounded-lg hover:bg-indigo-700 transition-colors"
            >
              Relever le defi
            </router-link>
          </div>
          <div v-else class="text-gray-500 text-center py-8">
            Pas de defi disponible aujourd'hui
          </div>
        </div>
      </div>

      <!-- Recent Activity -->
      <div class="bg-white rounded-xl shadow p-6">
        <h2 class="text-xl font-bold text-gray-900 mb-4">Exercices en cours</h2>
        <div v-if="exercisesInProgress.length > 0" class="space-y-3">
          <div 
            v-for="exercise in exercisesInProgress" 
            :key="exercise.exerciseId"
            class="flex items-center justify-between p-4 bg-gray-50 rounded-lg"
          >
            <div>
              <div class="font-medium text-gray-900">{{ exercise.exerciseTitle }}</div>
              <div class="text-sm text-gray-500">{{ exercise.attemptsCount }} tentatives</div>
            </div>
            <router-link 
              :to="`/exercises/${exercise.exerciseId}`"
              class="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition-colors text-sm"
            >
              Continuer
            </router-link>
          </div>
        </div>
        <div v-else class="text-gray-500 text-center py-8">
          Aucun exercice en cours
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
  badgesCount: 0,
  exercisesCompleted: 0,
  quizzesPassed: 0
})
const todayChallenge = ref(null)
const exercisesInProgress = ref([])

const progressPercent = computed(() => {
  const xpInLevel = 1000 - stats.value.xpForNextLevel
  return Math.round((xpInLevel / 1000) * 100)
})

async function fetchDashboard() {
  if (!authStore.user?.id) return
  try {
    const response = await api.get(`/dashboard/${authStore.user.id}/stats`)
    stats.value = response.data
  } catch (error) {
    console.error('Erreur chargement stats:', error)
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

onMounted(() => {
  fetchDashboard()
  fetchTodayChallenge()
  fetchExercisesInProgress()
})
</script>
