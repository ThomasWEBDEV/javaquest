<template>
  <MainLayout>
    <div class="max-w-6xl mx-auto">
      <h1 class="text-3xl font-bold text-gray-900 mb-8">Defi du jour</h1>

      <div v-if="loading" class="text-center py-12">
        <div class="text-gray-500">Chargement...</div>
      </div>

      <div v-else-if="!challenge" class="bg-white rounded-xl shadow p-8 text-center">
        <div class="text-6xl mb-4">😴</div>
        <h2 class="text-2xl font-bold text-gray-900 mb-2">Pas de defi aujourd'hui</h2>
        <p class="text-gray-600">Revenez demain pour un nouveau defi!</p>
      </div>

      <div v-else class="grid lg:grid-cols-2 gap-6">
        <!-- Instructions -->
        <div class="bg-white rounded-xl shadow p-6">
          <div class="flex items-center justify-between mb-4">
            <h2 class="text-2xl font-bold text-gray-900">{{ challenge.title }}</h2>
            <span
              class="px-3 py-1 rounded-full text-sm font-medium"
              :class="difficultyClass"
            >
              {{ difficultyLabel }}
            </span>
          </div>

          <p class="text-gray-600 mb-6">{{ challenge.description }}</p>

          <div class="flex items-center flex-wrap gap-2 mb-6">
            <span class="px-3 py-1 bg-yellow-100 text-yellow-700 rounded-full text-sm">
              +{{ challenge.xpReward }} XP
            </span>
            <span class="px-3 py-1 bg-green-100 text-green-700 rounded-full text-sm">
              Bonus 1er essai: +{{ challenge.bonusXp }} XP
            </span>
            <span v-if="challenge.timeLimitMinutes" class="px-3 py-1 bg-blue-100 text-blue-700 rounded-full text-sm">
              ⏱ {{ challenge.timeLimitMinutes }} min
            </span>
          </div>

          <div v-if="challenge.hints" class="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-4">
            <h3 class="font-semibold text-blue-800 mb-2">Indice</h3>
            <p class="text-blue-700 text-sm">{{ challenge.hints }}</p>
          </div>

          <!-- Status -->
          <div v-if="userChallenge" class="mt-6 p-4 rounded-lg" :class="statusClass">
            <div class="font-semibold">{{ statusText }}</div>
            <div v-if="userChallenge.status === 'COMPLETED'" class="text-sm mt-1">
              XP gagnes: {{ userChallenge.xpEarned }}
            </div>
            <div class="text-sm mt-1">
              Tentatives: {{ userChallenge.attemptsCount }}
            </div>
          </div>
        </div>

        <!-- Code Editor -->
        <div class="bg-white rounded-xl shadow p-6">
          <h2 class="text-lg font-semibold text-gray-900 mb-4">Editeur de code</h2>
          
          <textarea
            v-model="code"
            :disabled="userChallenge?.status === 'COMPLETED'"
            class="w-full h-64 font-mono text-sm bg-gray-900 text-green-400 p-4 rounded-lg resize-none disabled:opacity-50"
            placeholder="// Ecrivez votre code Java ici..."
          ></textarea>

          <div class="flex space-x-4 mt-4">
            <button
              @click="runCode"
              :disabled="executing || userChallenge?.status === 'COMPLETED'"
              class="flex-1 py-3 bg-green-600 text-white font-semibold rounded-lg hover:bg-green-700 transition-colors disabled:opacity-50"
            >
              {{ executing ? 'Execution...' : 'Executer' }}
            </button>
            <button
              @click="submitChallenge"
              :disabled="executing || userChallenge?.status === 'COMPLETED'"
              class="flex-1 py-3 bg-indigo-600 text-white font-semibold rounded-lg hover:bg-indigo-700 transition-colors disabled:opacity-50"
            >
              Soumettre
            </button>
          </div>

          <!-- Output -->
          <div v-if="output" class="mt-4">
            <h3 class="font-semibold text-gray-900 mb-2">Resultat</h3>
            <div 
              class="p-4 rounded-lg font-mono text-sm"
              :class="outputSuccess ? 'bg-green-50 text-green-800' : 'bg-red-50 text-red-800'"
            >
              <pre>{{ output }}</pre>
            </div>
          </div>

          <!-- Toast XP -->
          <transition name="fade">
            <div
              v-if="xpToast"
              class="mt-4 flex items-center space-x-2 bg-yellow-50 border border-yellow-300 text-yellow-800 px-4 py-3 rounded-lg font-semibold"
            >
              <span class="text-xl">⭐</span>
              <span>+{{ xpToastAmount }} XP gagnes!</span>
            </div>
          </transition>

          <!-- Result Message -->
          <div v-if="resultMessage" class="mt-4 p-4 rounded-lg" :class="resultSuccess ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'">
            {{ resultMessage }}
          </div>
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

const challenge = ref(null)
const userChallenge = ref(null)
const code = ref('')
const output = ref('')
const outputSuccess = ref(false)
const resultMessage = ref('')
const resultSuccess = ref(false)
const loading = ref(true)
const executing = ref(false)
const xpToast = ref(false)
const xpToastAmount = ref(0)

const difficultyClass = computed(() => {
  switch (challenge.value?.difficulty) {
    case 'EASY': return 'bg-green-100 text-green-700'
    case 'MEDIUM': return 'bg-yellow-100 text-yellow-700'
    case 'HARD': return 'bg-red-100 text-red-700'
    default: return 'bg-gray-100 text-gray-700'
  }
})

const difficultyLabel = computed(() => {
  switch (challenge.value?.difficulty) {
    case 'EASY': return 'Facile'
    case 'MEDIUM': return 'Moyen'
    case 'HARD': return 'Difficile'
    default: return challenge.value?.difficulty || ''
  }
})

const statusClass = computed(() => {
  switch (userChallenge.value?.status) {
    case 'COMPLETED': return 'bg-green-100 text-green-800'
    case 'STARTED': return 'bg-blue-100 text-blue-800'
    case 'FAILED': return 'bg-red-100 text-red-800'
    default: return 'bg-gray-100 text-gray-800'
  }
})

const statusText = computed(() => {
  switch (userChallenge.value?.status) {
    case 'COMPLETED': return 'Defi complete!'
    case 'STARTED': return 'En cours...'
    case 'FAILED': return 'Echoue'
    default: return ''
  }
})

async function fetchChallenge() {
  try {
    const response = await api.get('/challenges/today')
    challenge.value = response.data
    code.value = response.data.starterCode || ''
    
    if (authStore.user?.id) {
      await startChallenge()
      await fetchUserChallenge()
    }
  } catch (error) {
    console.error('Pas de defi aujourd\'hui')
  } finally {
    loading.value = false
  }
}

async function startChallenge() {
  if (!authStore.user?.id || !challenge.value?.id) return
  try {
    await api.post(`/challenges/${challenge.value.id}/start/${authStore.user.id}`)
  } catch (error) {
    console.error('Erreur demarrage defi:', error)
  }
}

async function fetchUserChallenge() {
  if (!authStore.user?.id || !challenge.value?.id) return
  try {
    const response = await api.get(`/challenges/${challenge.value.id}/user/${authStore.user.id}`)
    userChallenge.value = response.data
  } catch (error) {
    // Pas encore de participation
  }
}

async function runCode() {
  executing.value = true
  output.value = ''
  resultMessage.value = ''
  try {
    const response = await api.post('/execute', { code: code.value })
    output.value = response.data.output
    outputSuccess.value = response.data.success
  } catch (error) {
    output.value = error.response?.data?.error || 'Erreur d\'execution'
    outputSuccess.value = false
  } finally {
    executing.value = false
  }
}

async function submitChallenge() {
  await runCode()
  
  if (!authStore.user?.id || !challenge.value?.id) return
  
  try {
    const response = await api.post(`/challenges/${challenge.value.id}/submit/${authStore.user.id}`, {
      code: code.value,
      success: outputSuccess.value
    })
    
    resultMessage.value = response.data.message
    resultSuccess.value = response.data.success
    
    if (response.data.completed) {
      xpToastAmount.value = response.data.xpEarned
      xpToast.value = true
      setTimeout(() => { xpToast.value = false }, 4000)

      // Mettre a jour le store XP
      if (authStore.user?.id) {
        try {
          const progress = await api.get(`/gamification/progress/${authStore.user.id}`)
          authStore.setProgress(progress.data.totalXp, progress.data.currentLevel)
        } catch (e) {
          console.error('Erreur mise a jour XP:', e)
        }
      }
    }

    await fetchUserChallenge()
  } catch (error) {
    console.error('Erreur soumission:', error)
  }
}

onMounted(() => {
  fetchChallenge()
})
</script>
