<template>
  <MainLayout>
    <div class="max-w-6xl mx-auto">
      <!-- Navigation retour -->
      <div class="mb-5">
        <button
          @click="$router.back()"
          class="inline-flex items-center gap-1 text-indigo-600 hover:text-indigo-800 font-medium transition-colors"
        >
          ← Retour
        </button>
      </div>

      <div v-if="loading" class="text-center py-12">
        <div class="animate-pulse text-gray-400">Chargement de l'exercice...</div>
      </div>

      <div v-else-if="exercise" class="grid lg:grid-cols-2 gap-6 items-start">
        <!-- Panneau instructions -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
          <div class="flex items-start justify-between mb-5 gap-3">
            <h1 class="text-2xl font-bold text-gray-900 leading-tight">{{ exercise.title }}</h1>
            <span
              class="shrink-0 px-3 py-1 rounded-full text-xs font-semibold uppercase tracking-wide"
              :class="difficultyClass"
            >
              {{ difficultyLabel }}
            </span>
          </div>

          <p class="text-gray-600 leading-relaxed mb-6">{{ exercise.description }}</p>

          <!-- Indices -->
          <div v-if="parsedHints.length > 0" class="bg-amber-50 border border-amber-200 rounded-xl p-4">
            <div class="flex items-center gap-2 mb-3">
              <span class="text-amber-500 text-lg">💡</span>
              <h3 class="font-semibold text-amber-800 text-sm uppercase tracking-wide">Indices</h3>
            </div>
            <ul class="space-y-2">
              <li
                v-for="(hint, i) in parsedHints"
                :key="i"
                class="flex items-start gap-2 text-amber-700 text-sm"
              >
                <span class="mt-1 w-4 h-4 shrink-0 rounded-full bg-amber-200 flex items-center justify-center text-xs font-bold text-amber-800">{{ i + 1 }}</span>
                <span>{{ hint }}</span>
              </li>
            </ul>
          </div>

          <div class="mt-6 pt-4 border-t border-gray-100 flex items-center gap-3">
            <span class="px-3 py-1 bg-yellow-50 text-yellow-700 border border-yellow-200 rounded-full text-sm font-medium">
              +{{ exercise.xpReward }} XP
            </span>
          </div>
        </div>

        <!-- Panneau éditeur -->
        <div class="flex flex-col gap-4">
          <!-- Barre d'outils éditeur -->
          <div class="bg-gray-800 rounded-t-2xl px-4 py-3 flex items-center justify-between">
            <div class="flex items-center gap-2">
              <div class="w-3 h-3 rounded-full bg-red-500"></div>
              <div class="w-3 h-3 rounded-full bg-yellow-500"></div>
              <div class="w-3 h-3 rounded-full bg-green-500"></div>
            </div>
            <span class="text-gray-400 text-xs font-mono">Main.java</span>
            <div class="w-16"></div>
          </div>

          <!-- Zone de code -->
          <div class="-mt-4">
            <textarea
              ref="editorRef"
              v-model="code"
              @keydown.tab.prevent="handleTab"
              class="w-full h-80 font-mono text-sm bg-gray-900 text-green-300 px-4 py-4 rounded-b-2xl resize-none outline-none leading-relaxed"
              placeholder="// Ecrivez votre code Java ici..."
              spellcheck="false"
              autocomplete="off"
              autocorrect="off"
              autocapitalize="off"
            ></textarea>
          </div>

          <!-- Boutons -->
          <div class="flex gap-3">
            <button
              @click="runCode()"
              :disabled="executing"
              class="flex-1 py-3 bg-emerald-600 text-white font-semibold rounded-xl hover:bg-emerald-700 active:bg-emerald-800 transition-colors disabled:opacity-50 flex items-center justify-center gap-2"
            >
              <span v-if="executing" class="animate-spin">⟳</span>
              <span>{{ executing ? 'Execution...' : '▶ Executer' }}</span>
            </button>
            <button
              @click="submitCode"
              :disabled="executing"
              class="flex-1 py-3 bg-indigo-600 text-white font-semibold rounded-xl hover:bg-indigo-700 active:bg-indigo-800 transition-colors disabled:opacity-50 flex items-center justify-center gap-2"
            >
              ✓ Soumettre
            </button>
          </div>

          <!-- Toast XP -->
          <transition name="fade">
            <div
              v-if="xpToast"
              class="flex items-center gap-3 bg-yellow-50 border border-yellow-300 text-yellow-800 px-4 py-3 rounded-xl font-semibold"
            >
              <span class="text-2xl">⭐</span>
              <div>
                <div>Exercice réussi !</div>
                <div class="text-sm font-normal">+{{ exercise?.xpReward }} XP gagnés</div>
              </div>
            </div>
          </transition>

          <!-- Résultat -->
          <div v-if="output" class="rounded-xl overflow-hidden border" :class="outputSuccess ? 'border-green-200' : 'border-red-200'">
            <div
              class="px-4 py-2 text-xs font-semibold uppercase tracking-wide flex items-center gap-2"
              :class="outputSuccess ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'"
            >
              <span>{{ outputSuccess ? '✓ Succès' : '✗ Erreur' }}</span>
            </div>
            <div class="p-4 bg-gray-950 font-mono text-sm overflow-x-auto">
              <pre class="text-gray-200 whitespace-pre-wrap">{{ output }}</pre>
            </div>
          </div>
        </div>
      </div>

      <div v-else class="text-center py-12 text-gray-500">
        Exercice introuvable.
      </div>
    </div>
  </MainLayout>
</template>

<script setup>
import { ref, computed, nextTick, onMounted } from 'vue'
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
const editorRef = ref(null)

const difficultyClass = computed(() => {
  switch (exercise.value?.difficulty) {
    case 'EASY': return 'bg-green-100 text-green-700'
    case 'MEDIUM': return 'bg-yellow-100 text-yellow-700'
    case 'HARD': return 'bg-red-100 text-red-700'
    default: return 'bg-gray-100 text-gray-700'
  }
})

const difficultyLabel = computed(() => {
  switch (exercise.value?.difficulty) {
    case 'EASY': return 'Facile'
    case 'MEDIUM': return 'Moyen'
    case 'HARD': return 'Difficile'
    default: return exercise.value?.difficulty || ''
  }
})

const parsedHints = computed(() => {
  if (!exercise.value?.hints) return []
  try {
    const parsed = JSON.parse(exercise.value.hints)
    return Array.isArray(parsed) ? parsed : [exercise.value.hints]
  } catch {
    return [exercise.value.hints]
  }
})

function handleTab(event) {
  const textarea = event.target
  const start = textarea.selectionStart
  const end = textarea.selectionEnd
  code.value = code.value.substring(0, start) + '    ' + code.value.substring(end)
  nextTick(() => {
    textarea.selectionStart = textarea.selectionEnd = start + 4
  })
}

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
    output.value = error.response?.data?.error || "Erreur d'execution"
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
      output.value += '\n\nBravo ! Exercice complete !'
      xpToast.value = true
      setTimeout(() => { xpToast.value = false }, 5000)
      const progress = await api.get(`/gamification/progress/${authStore.user.id}`)
      authStore.setProgress(progress.data.totalXp, progress.data.currentLevel)
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
