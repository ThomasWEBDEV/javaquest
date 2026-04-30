<template>
  <MainLayout>
    <div class="max-w-4xl mx-auto">

      <div v-if="loading" class="space-y-5">
        <!-- Skeleton hero -->
        <div class="bg-white rounded-2xl border border-gray-100 p-8 animate-pulse">
          <div class="flex items-center gap-6">
            <div class="w-20 h-20 bg-gray-200 rounded-2xl shrink-0"></div>
            <div class="flex-1">
              <div class="h-7 bg-gray-200 rounded-lg w-48 mb-2"></div>
              <div class="h-4 bg-gray-100 rounded w-64 mb-4"></div>
              <div class="h-2.5 bg-gray-100 rounded-full"></div>
            </div>
          </div>
        </div>
        <div class="grid grid-cols-4 gap-4">
          <div v-for="i in 4" :key="i" class="bg-white rounded-2xl border border-gray-100 p-5 animate-pulse">
            <div class="h-8 bg-gray-200 rounded-lg mb-2"></div>
            <div class="h-4 bg-gray-100 rounded w-20 mx-auto"></div>
          </div>
        </div>
      </div>

      <div v-else>
        <!-- Hero profil -->
        <div class="bg-gradient-to-br from-indigo-600 to-purple-700 rounded-2xl p-8 mb-6 text-white">
          <div class="flex items-center gap-6">
            <div class="w-20 h-20 bg-white/20 backdrop-blur rounded-2xl flex items-center justify-center shrink-0">
              <span class="text-4xl font-extrabold text-white">
                {{ authStore.user?.username?.charAt(0).toUpperCase() }}
              </span>
            </div>
            <div class="flex-1 min-w-0">
              <div class="text-indigo-200 text-sm font-medium mb-1">Niveau {{ stats.currentLevel }}</div>
              <h1 class="text-2xl font-bold truncate">{{ authStore.user?.username }}</h1>
              <p class="text-indigo-300 text-sm truncate">{{ authStore.user?.email }}</p>
              <div class="mt-4">
                <div class="flex justify-between text-xs text-indigo-300 mb-1">
                  <span>{{ stats.totalXp }} XP</span>
                  <span>{{ stats.xpForNextLevel }} XP pour niveau {{ stats.currentLevel + 1 }}</span>
                </div>
                <div class="w-full bg-white/20 rounded-full h-2 overflow-hidden">
                  <div
                    class="bg-yellow-400 h-2 rounded-full transition-all duration-700"
                    :style="{ width: progressPercent + '%' }"
                  ></div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Stats grid -->
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
          <div class="bg-white rounded-2xl border border-gray-100 p-5 text-center hover:shadow-sm transition-shadow">
            <div class="text-2xl mb-1">💪</div>
            <div class="text-2xl font-bold text-green-600">{{ stats.exercisesCompleted }}</div>
            <div class="text-xs text-gray-400 mt-1">Exercices</div>
          </div>
          <div class="bg-white rounded-2xl border border-gray-100 p-5 text-center hover:shadow-sm transition-shadow">
            <div class="text-2xl mb-1">🧠</div>
            <div class="text-2xl font-bold text-blue-600">{{ stats.quizzesPassed }}</div>
            <div class="text-xs text-gray-400 mt-1">Quiz reussis</div>
          </div>
          <div class="bg-white rounded-2xl border border-gray-100 p-5 text-center hover:shadow-sm transition-shadow">
            <div class="text-2xl mb-1">🔥</div>
            <div class="text-2xl font-bold text-orange-500">{{ stats.currentStreak }}</div>
            <div class="text-xs text-gray-400 mt-1">Serie actuelle</div>
          </div>
          <div class="bg-white rounded-2xl border border-gray-100 p-5 text-center hover:shadow-sm transition-shadow">
            <div class="text-2xl mb-1">🏅</div>
            <div class="text-2xl font-bold text-purple-600">{{ stats.longestStreak }}</div>
            <div class="text-xs text-gray-400 mt-1">Meilleure serie</div>
          </div>
        </div>

        <!-- Badges -->
        <div class="bg-white rounded-2xl border border-gray-100 p-6 mb-6">
          <div class="flex items-center justify-between mb-5">
            <h2 class="text-lg font-bold text-gray-900 flex items-center gap-2">
              <span class="w-8 h-8 bg-yellow-100 rounded-lg flex items-center justify-center text-sm">🏆</span>
              Mes Badges
            </h2>
            <span v-if="badges.length > 0" class="text-xs font-semibold text-gray-400 bg-gray-100 px-3 py-1 rounded-full">
              {{ badges.length }} obtenu{{ badges.length > 1 ? 's' : '' }}
            </span>
          </div>

          <div v-if="badges.length > 0" class="grid grid-cols-2 md:grid-cols-3 gap-3">
            <div
              v-for="badge in badges"
              :key="badge.id"
              class="relative bg-gradient-to-br from-yellow-50 to-amber-50 border border-yellow-200 rounded-2xl p-4 text-center hover:shadow-md transition-shadow"
            >
              <div class="text-3xl mb-2">{{ badgeIcon(badge.criteriaType) }}</div>
              <div class="font-semibold text-gray-900 text-sm">{{ badge.name }}</div>
              <div class="text-xs text-gray-500 mt-1 leading-tight">{{ badge.description }}</div>
              <div v-if="badge.earnedAt" class="text-xs text-yellow-600 font-medium mt-2">
                {{ new Date(badge.earnedAt).toLocaleDateString('fr-FR') }}
              </div>
            </div>
          </div>
          <div v-else class="flex flex-col items-center py-10 text-gray-400">
            <span class="text-4xl mb-3">🔒</span>
            <p class="text-sm">Aucun badge pour le moment. Continuez a apprendre !</p>
          </div>
        </div>

        <!-- Historique Quiz -->
        <div class="bg-white rounded-2xl border border-gray-100 p-6">
          <h2 class="text-lg font-bold text-gray-900 mb-5 flex items-center gap-2">
            <span class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center text-sm">📋</span>
            Historique des Quiz
          </h2>
          <div v-if="quizHistory.length > 0" class="space-y-2">
            <div
              v-for="attempt in quizHistory"
              :key="attempt.attemptedAt"
              class="flex items-center justify-between p-4 bg-gray-50 hover:bg-indigo-50 rounded-xl transition-colors group"
            >
              <div>
                <div class="font-medium text-gray-900 group-hover:text-indigo-700 transition-colors text-sm">{{ attempt.quizTitle }}</div>
                <div class="text-xs text-gray-400 mt-0.5">
                  {{ new Date(attempt.attemptedAt).toLocaleDateString('fr-FR') }}
                </div>
              </div>
              <div class="text-right">
                <div
                  class="font-bold text-sm"
                  :class="attempt.passed ? 'text-green-600' : 'text-red-500'"
                >
                  {{ attempt.score }}%
                </div>
                <div class="text-xs text-gray-400">{{ attempt.correctAnswers }}/{{ attempt.totalQuestions }}</div>
                <div v-if="attempt.xpEarned > 0" class="text-xs text-yellow-600 font-semibold">+{{ attempt.xpEarned }} XP</div>
              </div>
            </div>
          </div>
          <div v-else class="flex flex-col items-center py-10 text-gray-400">
            <span class="text-4xl mb-3">📝</span>
            <p class="text-sm">Aucun quiz complete pour l'instant</p>
          </div>
        </div>
      </div>
    </div>
  </MainLayout>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
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
const loading = ref(true)

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
  } finally {
    loading.value = false
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

function badgeIcon(criteriaType) {
  switch (criteriaType) {
    case 'XP_TOTAL': return '⭐'
    case 'LEVEL_REACHED': return '🎯'
    case 'EXERCISES_COMPLETED': return '💪'
    case 'STREAK_DAYS': return '🔥'
    case 'QUIZZES_PASSED': return '🧠'
    case 'CHAPTERS_COMPLETED': return '📚'
    default: return '🏆'
  }
}

// Déclenche le chargement dès que user est disponible (gère le refresh de page)
watch(() => authStore.user?.id, (userId) => {
  if (userId) {
    fetchStats()
    fetchBadges()
    fetchQuizHistory()
  }
}, { immediate: true })
</script>
