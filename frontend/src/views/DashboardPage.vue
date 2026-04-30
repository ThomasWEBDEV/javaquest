<template>
  <MainLayout>
    <div class="max-w-7xl mx-auto">
      <!-- En-tête -->
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900">Tableau de bord</h1>
        <p class="text-gray-500 mt-1">Votre progression en un coup d'oeil</p>
      </div>

      <!-- Stats Cards -->
      <div class="grid md:grid-cols-4 gap-5 mb-8">
        <!-- Skeleton -->
        <template v-if="loadingStats">
          <div v-for="i in 4" :key="i" class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 animate-pulse">
            <div class="flex items-center justify-between mb-4">
              <div class="w-12 h-12 bg-gray-200 rounded-xl"></div>
              <div class="w-16 h-6 bg-gray-200 rounded-lg"></div>
            </div>
            <div class="w-20 h-8 bg-gray-200 rounded-lg mb-1"></div>
            <div class="w-24 h-4 bg-gray-100 rounded"></div>
          </div>
        </template>

        <!-- XP Total -->
        <div v-else class="bg-gradient-to-br from-yellow-400 to-orange-400 rounded-2xl p-6 text-white shadow-sm">
          <div class="flex items-center justify-between mb-4">
            <div class="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center text-2xl">⭐</div>
            <span class="text-xs font-semibold bg-white/20 px-2 py-1 rounded-full uppercase tracking-wide">XP</span>
          </div>
          <div class="text-3xl font-bold">{{ stats.totalXp.toLocaleString() }}</div>
          <div class="text-yellow-100 text-sm mt-1">Points d'experience</div>
        </div>

        <!-- Niveau -->
        <div v-if="!loadingStats" class="bg-gradient-to-br from-indigo-500 to-purple-600 rounded-2xl p-6 text-white shadow-sm">
          <div class="flex items-center justify-between mb-4">
            <div class="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center text-2xl">🎯</div>
            <span class="text-xs font-semibold bg-white/20 px-2 py-1 rounded-full uppercase tracking-wide">NIV.</span>
          </div>
          <div class="text-3xl font-bold">{{ stats.currentLevel }}</div>
          <div class="text-indigo-200 text-sm mt-1">Niveau actuel</div>
        </div>

        <!-- Série -->
        <div v-if="!loadingStats" class="bg-gradient-to-br from-orange-500 to-red-500 rounded-2xl p-6 text-white shadow-sm">
          <div class="flex items-center justify-between mb-4">
            <div class="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center text-2xl">🔥</div>
            <span class="text-xs font-semibold bg-white/20 px-2 py-1 rounded-full uppercase tracking-wide">SERIE</span>
          </div>
          <div class="text-3xl font-bold">{{ stats.currentStreak }}<span class="text-lg font-normal text-orange-200 ml-1">j</span></div>
          <div class="text-orange-200 text-sm mt-1">Jours consecutifs</div>
        </div>

        <!-- Badges -->
        <div v-if="!loadingStats" class="bg-gradient-to-br from-purple-500 to-pink-500 rounded-2xl p-6 text-white shadow-sm">
          <div class="flex items-center justify-between mb-4">
            <div class="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center text-2xl">🏆</div>
            <span class="text-xs font-semibold bg-white/20 px-2 py-1 rounded-full uppercase tracking-wide">BADGES</span>
          </div>
          <div class="text-3xl font-bold">{{ stats.badgesCount }}</div>
          <div class="text-purple-200 text-sm mt-1">Badges debloqués</div>
        </div>
      </div>

      <!-- Progress Section -->
      <div class="grid md:grid-cols-2 gap-6 mb-6">
        <!-- Progression XP -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
          <h2 class="text-lg font-bold text-gray-900 mb-5 flex items-center gap-2">
            <span class="w-8 h-8 bg-indigo-100 rounded-lg flex items-center justify-center text-sm">📈</span>
            Progression
          </h2>
          <div class="mb-5">
            <div class="flex justify-between text-sm mb-2">
              <span class="font-semibold text-gray-700">Niveau {{ stats.currentLevel }}</span>
              <span class="text-gray-400">{{ stats.xpForNextLevel }} XP pour niveau {{ stats.currentLevel + 1 }}</span>
            </div>
            <div class="w-full bg-gray-100 rounded-full h-3 overflow-hidden">
              <div
                class="bg-gradient-to-r from-indigo-500 to-purple-500 h-3 rounded-full transition-all duration-700"
                :style="{ width: progressPercent + '%' }"
              ></div>
            </div>
            <div class="text-xs text-gray-400 mt-1 text-right">{{ progressPercent }}%</div>
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div class="bg-green-50 rounded-xl p-4 text-center">
              <div class="text-2xl font-bold text-green-600">{{ stats.exercisesCompleted }}</div>
              <div class="text-xs text-gray-500 mt-1">Exercices completes</div>
            </div>
            <div class="bg-blue-50 rounded-xl p-4 text-center">
              <div class="text-2xl font-bold text-blue-600">{{ stats.quizzesPassed }}</div>
              <div class="text-xs text-gray-500 mt-1">Quiz reussis</div>
            </div>
          </div>
        </div>

        <!-- Défi du jour -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
          <h2 class="text-lg font-bold text-gray-900 mb-5 flex items-center gap-2">
            <span class="w-8 h-8 bg-yellow-100 rounded-lg flex items-center justify-center text-sm">⚡</span>
            Defi du jour
          </h2>
          <div v-if="todayChallenge" class="flex flex-col h-full">
            <h3 class="font-semibold text-gray-800 mb-2">{{ todayChallenge.title }}</h3>
            <p class="text-gray-500 text-sm leading-relaxed mb-4">{{ todayChallenge.description }}</p>
            <div class="flex items-center gap-2 mb-5">
              <span class="px-3 py-1 bg-yellow-100 text-yellow-700 rounded-full text-xs font-semibold">
                +{{ todayChallenge.xpReward }} XP
              </span>
              <span class="px-3 py-1 bg-green-100 text-green-700 rounded-full text-xs font-semibold">
                Bonus +{{ todayChallenge.bonusXp }} XP
              </span>
            </div>
            <router-link
              to="/challenge"
              class="mt-auto block w-full py-3 bg-gradient-to-r from-indigo-600 to-purple-600 text-white text-center rounded-xl hover:opacity-90 transition-opacity font-semibold text-sm"
            >
              Relever le defi →
            </router-link>
          </div>
          <div v-else class="flex flex-col items-center justify-center py-8 text-gray-400">
            <span class="text-4xl mb-3">🌙</span>
            <p class="text-sm">Pas de defi disponible aujourd'hui</p>
          </div>
        </div>
      </div>

      <!-- Exercices en cours -->
      <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
        <h2 class="text-lg font-bold text-gray-900 mb-5 flex items-center gap-2">
          <span class="w-8 h-8 bg-emerald-100 rounded-lg flex items-center justify-center text-sm">💻</span>
          Exercices en cours
        </h2>
        <div v-if="exercisesInProgress.length > 0" class="space-y-3">
          <div
            v-for="exercise in exercisesInProgress"
            :key="exercise.exerciseId"
            class="flex items-center justify-between p-4 bg-gray-50 hover:bg-indigo-50 rounded-xl transition-colors group"
          >
            <div>
              <div class="font-medium text-gray-900 group-hover:text-indigo-700 transition-colors">{{ exercise.exerciseTitle }}</div>
              <div class="text-xs text-gray-400 mt-0.5">{{ exercise.attemptsCount }} tentative{{ exercise.attemptsCount > 1 ? 's' : '' }}</div>
            </div>
            <router-link
              :to="`/exercises/${exercise.exerciseId}`"
              class="px-4 py-2 bg-indigo-600 text-white rounded-xl hover:bg-indigo-700 transition-colors text-sm font-medium"
            >
              Continuer →
            </router-link>
          </div>
        </div>
        <div v-else class="flex flex-col items-center justify-center py-10 text-gray-400">
          <span class="text-4xl mb-3">✨</span>
          <p class="text-sm">Aucun exercice en cours — commencez un cours !</p>
        </div>
      </div>
    </div>
  </MainLayout>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
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
const loadingStats = ref(true)

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
  } finally {
    loadingStats.value = false
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

// Déclenche le chargement dès que user est disponible (gère le refresh de page)
watch(() => authStore.user?.id, (userId) => {
  if (userId) {
    fetchDashboard()
    fetchExercisesInProgress()
  }
}, { immediate: true })

onMounted(() => {
  fetchTodayChallenge()
})
</script>
