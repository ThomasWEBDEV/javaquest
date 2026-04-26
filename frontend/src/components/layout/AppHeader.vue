<template>
  <header class="bg-white/90 backdrop-blur-sm sticky top-0 z-30 border-b border-gray-100">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between items-center h-16">
        <!-- Logo -->
        <router-link to="/" class="flex items-center gap-2 group">
          <span class="text-xl">☕</span>
          <span class="text-xl font-extrabold text-gray-900 tracking-tight group-hover:text-indigo-600 transition-colors">
            Java<span class="text-indigo-600 group-hover:text-indigo-700">Quest</span>
          </span>
        </router-link>

        <!-- Navigation -->
        <nav class="hidden md:flex items-center gap-1">
          <router-link
            v-for="item in navItems"
            :key="item.path"
            :to="item.path"
            class="px-4 py-2 rounded-xl text-sm font-medium transition-colors"
            :class="isActive(item.path)
              ? 'bg-indigo-50 text-indigo-700'
              : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'"
          >
            {{ item.label }}
          </router-link>
        </nav>

        <!-- User zone -->
        <div class="flex items-center gap-3">
          <template v-if="authStore.isAuthenticated">
            <!-- XP + niveau compact -->
            <div class="hidden sm:flex items-center gap-1.5 bg-gray-50 rounded-xl px-3 py-1.5 text-sm">
              <span class="text-yellow-500 font-bold">{{ authStore.xp }}</span>
              <span class="text-gray-300">XP</span>
              <span class="w-px h-3 bg-gray-200 mx-0.5"></span>
              <span class="text-indigo-600 font-bold">Niv. {{ authStore.level }}</span>
            </div>

            <!-- Avatar avec initiale -->
            <router-link
              to="/profile"
              class="w-9 h-9 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-xl flex items-center justify-center text-white font-bold text-sm hover:opacity-90 transition-opacity"
              :title="authStore.user?.username"
            >
              {{ authStore.user?.username?.charAt(0).toUpperCase() || '?' }}
            </router-link>

            <button
              @click="logout"
              class="px-3 py-2 text-xs font-medium text-gray-500 hover:bg-gray-100 rounded-xl transition-colors"
            >
              Déco
            </button>
          </template>
          <template v-else>
            <router-link
              to="/login"
              class="px-4 py-2 text-sm font-medium text-gray-600 hover:bg-gray-50 rounded-xl transition-colors"
            >
              Connexion
            </router-link>
            <router-link
              to="/register"
              class="px-4 py-2 text-sm font-semibold text-white bg-indigo-600 hover:bg-indigo-700 rounded-xl transition-colors"
            >
              S'inscrire
            </router-link>
          </template>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup>
import { onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import api from '@/services/api'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()

const navItems = [
  { path: '/courses',   label: 'Cours' },
  { path: '/quizzes',   label: 'Quiz' },
  { path: '/challenge', label: 'Défi du jour' },
  { path: '/dashboard', label: 'Dashboard' },
]

function isActive(path) {
  return route.path === path || route.path.startsWith(path + '/')
}

async function fetchProgress() {
  if (!authStore.isAuthenticated || !authStore.user?.id) return
  try {
    const response = await api.get(`/gamification/progress/${authStore.user.id}`)
    authStore.setProgress(response.data.totalXp, response.data.currentLevel)
  } catch (error) {
    console.error('Erreur chargement progression:', error)
  }
}

function logout() {
  authStore.logout()
  router.push('/login')
}

onMounted(() => {
  fetchProgress()
})
</script>
