<template>
  <aside class="w-64 bg-white border-r border-gray-100 min-h-screen flex flex-col py-6 px-3">
    <!-- Menu principal -->
    <nav class="space-y-1 flex-1">
      <router-link
        v-for="item in menuItems"
        :key="item.path"
        :to="item.path"
        class="flex items-center gap-3 px-4 py-3 rounded-xl transition-all font-medium text-sm"
        :class="isActive(item.path)
          ? 'bg-indigo-50 text-indigo-700'
          : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'"
      >
        <span class="text-lg">{{ item.icon }}</span>
        <span>{{ item.label }}</span>
        <span
          v-if="isActive(item.path)"
          class="ml-auto w-1.5 h-1.5 rounded-full bg-indigo-500"
        ></span>
      </router-link>
    </nav>

    <!-- Stats en bas -->
    <div class="mt-6 space-y-3 px-1">
      <!-- Streak -->
      <div class="bg-gradient-to-r from-orange-500 to-red-500 rounded-2xl p-4 text-white">
        <div class="flex items-center justify-between mb-1">
          <span class="text-sm font-medium text-orange-100">Série en cours</span>
          <span class="text-xl">🔥</span>
        </div>
        <div class="text-3xl font-bold">{{ streak }}<span class="text-lg font-normal text-orange-200 ml-1">jours</span></div>
      </div>

      <!-- XP + Niveau -->
      <div class="bg-gray-50 rounded-2xl p-4">
        <div class="flex items-center justify-between mb-2">
          <span class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Niveau</span>
          <span class="text-sm font-bold text-indigo-700">{{ authStore.level }}</span>
        </div>
        <div class="text-xl font-bold text-gray-900">{{ authStore.xp }} <span class="text-sm font-normal text-gray-400">XP</span></div>
        <!-- Barre de progression XP approximative -->
        <div class="mt-2 h-1.5 bg-gray-200 rounded-full overflow-hidden">
          <div
            class="h-full bg-indigo-500 rounded-full transition-all"
            :style="{ width: xpBarWidth + '%' }"
          ></div>
        </div>
      </div>
    </div>
  </aside>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import api from '@/services/api'

const authStore = useAuthStore()
const route = useRoute()
const streak = ref(0)

const menuItems = [
  { path: '/dashboard', label: 'Dashboard', icon: '🏠' },
  { path: '/courses',   label: 'Cours',     icon: '📚' },
  { path: '/challenge', label: 'Défi du jour', icon: '⚡' },
  { path: '/quizzes',   label: 'Quiz',      icon: '🧠' },
  { path: '/profile',   label: 'Profil',    icon: '👤' },
]

// Barre XP : XP dans le niveau courant (approximatif : 500 XP par niveau)
const XP_PER_LEVEL = 500
const xpBarWidth = computed(() => {
  const xpInLevel = authStore.xp % XP_PER_LEVEL
  return Math.min(100, Math.round((xpInLevel / XP_PER_LEVEL) * 100))
})

function isActive(path) {
  return route.path === path || route.path.startsWith(path + '/')
}

async function fetchStreak() {
  if (!authStore.isAuthenticated || !authStore.user?.id) return
  try {
    const response = await api.get(`/gamification/progress/${authStore.user.id}`)
    streak.value = response.data.currentStreak
  } catch (error) {
    console.error('Erreur chargement streak:', error)
  }
}

onMounted(() => {
  fetchStreak()
})
</script>
