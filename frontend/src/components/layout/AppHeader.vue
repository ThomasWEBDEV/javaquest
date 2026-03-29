<template>
  <header class="bg-white shadow-sm border-b border-gray-200">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between items-center h-16">
        <!-- Logo -->
        <router-link to="/" class="flex items-center space-x-2">
          <span class="text-2xl font-bold text-indigo-600">JavaQuest</span>
        </router-link>

        <!-- Navigation -->
        <nav class="hidden md:flex items-center space-x-6">
          <router-link 
            to="/courses" 
            class="text-gray-600 hover:text-indigo-600 transition-colors"
          >
            Cours
          </router-link>
          <router-link 
            to="/quizzes" 
            class="text-gray-600 hover:text-indigo-600 transition-colors"
          >
            Quiz
          </router-link>
          <router-link 
            to="/challenge" 
            class="text-gray-600 hover:text-indigo-600 transition-colors"
          >
            Defi du jour
          </router-link>
        </nav>

        <!-- User Menu -->
        <div class="flex items-center space-x-4">
          <template v-if="authStore.isAuthenticated">
            <div class="flex items-center space-x-2 text-sm">
              <span class="text-yellow-500 font-semibold">{{ userXp }} XP</span>
              <span class="text-gray-400">|</span>
              <span class="text-indigo-600 font-semibold">Niv. {{ userLevel }}</span>
            </div>
            <router-link 
              to="/dashboard"
              class="px-4 py-2 text-sm font-medium text-indigo-600 hover:bg-indigo-50 rounded-lg transition-colors"
            >
              Dashboard
            </router-link>
            <button 
              @click="logout"
              class="px-4 py-2 text-sm font-medium text-gray-600 hover:bg-gray-100 rounded-lg transition-colors"
            >
              Deconnexion
            </button>
          </template>
          <template v-else>
            <router-link 
              to="/login"
              class="px-4 py-2 text-sm font-medium text-gray-600 hover:bg-gray-100 rounded-lg transition-colors"
            >
              Connexion
            </router-link>
            <router-link 
              to="/register"
              class="px-4 py-2 text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 rounded-lg transition-colors"
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
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import api from '@/services/api'

const router = useRouter()
const authStore = useAuthStore()

const userXp = ref(0)
const userLevel = ref(1)

async function fetchProgress() {
  if (!authStore.isAuthenticated || !authStore.user?.id) return
  try {
    const response = await api.get(`/gamification/progress/${authStore.user.id}`)
    userXp.value = response.data.totalXp
    userLevel.value = response.data.currentLevel
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
