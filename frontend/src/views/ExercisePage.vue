<template>
  <MainLayout>
    <div class="max-w-6xl mx-auto">
      <div v-if="loading" class="text-center py-12">
        <div class="text-gray-500">Chargement...</div>
      </div>

      <div v-else-if="exercise" class="grid lg:grid-cols-2 gap-6">
        <!-- Instructions -->
        <div class="bg-white rounded-xl shadow p-6">
          <div class="flex items-center justify-between mb-4">
            <h1 class="text-2xl font-bold text-gray-900">{{ exercise.title }}</h1>
            <span 
              class="px-3 py-1 rounded-full text-sm font-medium"
              :class="difficultyClass"
            >
              {{ exercise.difficulty }}
            </span>
          </div>
          <p class="text-gray-600 mb-6">{{ exercise.description }}</p>
          
          <div v-if="exercise.hints" class="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
            <h3 class="font-semibold text-yellow-800 mb-2">Indice</h3>
            <p class="text-yellow-700 text-sm">{{ exercise.hints }}</p>
          </div>

          <div class="mt-6 flex items-center space-x-4">
            <span class="px-3 py-1 bg-yellow-100 text-yellow-700 rounded-full text-sm">
              +{{ exercise.xpReward }} XP
            </span>
          </div>
        </div>

        <!-- Code Editor -->
        <div class="bg-white rounded-xl shadow p-6">
          <h2 class="text-lg font-semibold text-gray-900 mb-4">Editeur de code</h2>
          <textarea
            v-model="code"
            class="w-full h-64 font-mono text-sm bg-gray-900 text-green-400 p-4 rounded-lg resize-none"
            placeholder="// Ecrivez votre code Java ici..."
          ></textarea>

          <div class="flex space-x-4 mt-4">
            <button
              @click="runCode"
              :disabled="executing"
              class="flex-1 py-3 bg-green-600 text-white font-semibold rounded-lg hover:bg-green-700 transition-colors disabled:opacity-50"
            >
              {{ executing ? 'Execution...' : 'Executer' }}
            </button>
            <button
              @click="submitCode"
              :disabled="executing"
              class="flex-1 py-3 bg-indigo-600 text-white font-semibold rounded-lg hover:bg-indigo-700 transition-colors disabled:opacity-50"
            >
              Soumettre
            </button>
          </div>

          <!-- Toast XP -->
          <transition name="fade">
            <div
              v-if="xpToast"
              class="mt-4 flex items-center space-x-2 bg-yellow-50 border border-yellow-300 text-yellow-800 px-4 py-3 rounded-lg font-semibold"
            >
              <span class="text-xl">⭐</span>
              <span>+{{ exercise?.xpReward }} XP gagnés !</span>
            </div>
          </transition>

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
        </div>
      </div>
    </div>
  </MainLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import MainLayout from '@/components/layout/MainLayout.vue'
import { useAuthStore } from '@/stores/auth'
import api from '@/services/api'

const route = useRoute()
const authStore = useAuthStore()

const exercise = ref(null)
const code = ref('')
const output = ref('')
const outputSuccess = ref(false)
const loading = ref(true)
const executing = ref(false)
const xpToast = ref(false)

const difficultyClass = computed(() => {
  switch (exercise.value?.difficulty) {
    case 'EASY': return 'bg-green-100 text-green-700'
    case 'MEDIUM': return 'bg-yellow-100 text-yellow-700'
    case 'HARD': return 'bg-red-100 text-red-700'
    default: return 'bg-gray-100 text-gray-700'
  }
})

async function fetchExercise() {
  try {
    const response = await api.get(`/exercises/${route.params.exerciseId}`)
    exercise.value = response.data
    code.value = response.data.starterCode || ''
  } catch (error) {
    console.error('Erreur chargement exercice:', error)
  } finally {
    loading.value = false
  }
}

async function runCode(exerciseId = null) {
  executing.value = true
  output.value = ''
  try {
    const payload = { code: code.value }
    if (exerciseId) payload.exerciseId = exerciseId
    const response = await api.post('/execute', payload)
    output.value = response.data.output
    outputSuccess.value = response.data.success
  } catch (error) {
    output.value = error.response?.data?.error || 'Erreur d\'execution'
    outputSuccess.value = false
  } finally {
    executing.value = false
  }
}

async function submitCode() {
  await runCode(exercise.value?.id)
  if (outputSuccess.value && authStore.user?.id) {
    try {
      await api.post(`/dashboard/${authStore.user.id}/exercises/${exercise.value.id}/attempt`, {
        code: code.value,
        success: true
      })
      output.value += '\n\nBravo! Exercice complete!'
      xpToast.value = true
      setTimeout(() => { xpToast.value = false }, 4000)
    } catch (error) {
      console.error('Erreur soumission:', error)
    }
  }
}

onMounted(() => {
  fetchExercise()
})
</script>

<style scoped>
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.4s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>
