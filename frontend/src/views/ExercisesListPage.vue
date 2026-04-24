<template>
  <MainLayout>
    <div class="max-w-4xl mx-auto">
      <!-- Fil d'Ariane -->
      <nav class="flex items-center gap-2 text-sm text-gray-500 mb-6">
        <router-link to="/courses" class="hover:text-indigo-600 transition-colors">Cours</router-link>
        <span>/</span>
        <router-link
          v-if="lessonId"
          :to="`/lessons/${lessonId}`"
          class="hover:text-indigo-600 transition-colors"
        >{{ lessonTitle || 'Leçon' }}</router-link>
        <span>/</span>
        <span class="text-gray-800 font-medium">Exercices</span>
      </nav>

      <div v-if="loading" class="text-center py-16">
        <div class="animate-pulse text-gray-400">Chargement des exercices...</div>
      </div>

      <div v-else>
        <!-- En-tête -->
        <div class="mb-8">
          <h1 class="text-2xl font-bold text-gray-900 mb-1">Exercices pratiques</h1>
          <p v-if="lessonTitle" class="text-gray-500">{{ lessonTitle }}</p>
        </div>

        <!-- Résumé XP -->
        <div class="flex gap-3 mb-6">
          <div
            v-for="difficulty in difficultyStats"
            :key="difficulty.label"
            class="flex items-center gap-2 px-4 py-2 rounded-xl text-sm font-medium border"
            :class="difficulty.style"
          >
            <span>{{ difficulty.count }}x {{ difficulty.label }}</span>
          </div>
        </div>

        <div v-if="exercises.length > 0" class="space-y-4">
          <router-link
            v-for="(exercise, index) in exercises"
            :key="exercise.id"
            :to="`/exercises/${exercise.id}`"
            class="group flex items-center gap-5 bg-white rounded-2xl shadow-sm border border-gray-100 p-6 hover:border-indigo-300 hover:shadow-md transition-all"
          >
            <!-- Numéro -->
            <div
              class="w-10 h-10 rounded-xl flex items-center justify-center font-bold text-sm shrink-0 transition-colors"
              :class="difficultyNumBg(exercise.difficulty)"
            >
              {{ index + 1 }}
            </div>

            <!-- Contenu -->
            <div class="flex-1 min-w-0">
              <div class="flex items-center gap-3 mb-1">
                <h3 class="font-semibold text-gray-900 group-hover:text-indigo-700 transition-colors">
                  {{ exercise.title }}
                </h3>
                <span
                  class="shrink-0 px-2 py-0.5 rounded-full text-xs font-semibold uppercase tracking-wide"
                  :class="difficultyClass(exercise.difficulty)"
                >
                  {{ difficultyLabel(exercise.difficulty) }}
                </span>
              </div>
              <p class="text-gray-500 text-sm leading-relaxed line-clamp-2">{{ exercise.description }}</p>
            </div>

            <!-- XP + action -->
            <div class="shrink-0 flex flex-col items-end gap-2">
              <span class="px-3 py-1 bg-yellow-50 text-yellow-700 border border-yellow-200 rounded-full text-xs font-semibold">
                +{{ exercise.xpReward }} XP
              </span>
              <span class="text-gray-400 group-hover:text-indigo-600 group-hover:translate-x-1 transition-all font-bold text-lg">→</span>
            </div>
          </router-link>
        </div>

        <div v-else class="bg-white rounded-2xl shadow-sm border border-gray-100 p-12 text-center text-gray-400">
          Aucun exercice disponible pour cette leçon.
        </div>

        <!-- Retour leçon -->
        <div class="mt-8 text-center">
          <router-link
            v-if="lessonId"
            :to="`/lessons/${lessonId}`"
            class="inline-flex items-center gap-2 text-indigo-600 hover:text-indigo-800 font-medium transition-colors"
          >
            ← Retour à la leçon
          </router-link>
        </div>
      </div>
    </div>
  </MainLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import MainLayout from '@/components/layout/MainLayout.vue'
import api from '@/services/api'

const route = useRoute()
const lessonId = route.params.lessonId
const exercises = ref([])
const lessonTitle = ref('')
const loading = ref(true)

const difficultyStats = computed(() => {
  const counts = { EASY: 0, MEDIUM: 0, HARD: 0 }
  exercises.value.forEach(e => { if (counts[e.difficulty] !== undefined) counts[e.difficulty]++ })
  return [
    { label: 'Facile', count: counts.EASY, style: 'bg-green-50 text-green-700 border-green-200' },
    { label: 'Moyen', count: counts.MEDIUM, style: 'bg-yellow-50 text-yellow-700 border-yellow-200' },
    { label: 'Difficile', count: counts.HARD, style: 'bg-red-50 text-red-700 border-red-200' },
  ].filter(s => s.count > 0)
})

function difficultyClass(difficulty) {
  switch (difficulty) {
    case 'EASY': return 'bg-green-100 text-green-700'
    case 'MEDIUM': return 'bg-yellow-100 text-yellow-700'
    case 'HARD': return 'bg-red-100 text-red-700'
    default: return 'bg-gray-100 text-gray-700'
  }
}

function difficultyNumBg(difficulty) {
  switch (difficulty) {
    case 'EASY': return 'bg-green-50 text-green-600 group-hover:bg-green-100'
    case 'MEDIUM': return 'bg-yellow-50 text-yellow-600 group-hover:bg-yellow-100'
    case 'HARD': return 'bg-red-50 text-red-600 group-hover:bg-red-100'
    default: return 'bg-gray-50 text-gray-600'
  }
}

function difficultyLabel(difficulty) {
  switch (difficulty) {
    case 'EASY': return 'Facile'
    case 'MEDIUM': return 'Moyen'
    case 'HARD': return 'Difficile'
    default: return difficulty
  }
}

async function fetchData() {
  try {
    const [lessonRes, exercisesRes] = await Promise.all([
      api.get(`/courses/lessons/${lessonId}`),
      api.get(`/exercises/lesson/${lessonId}`)
    ])
    lessonTitle.value = lessonRes.data.title
    exercises.value = exercisesRes.data
  } catch (error) {
    console.error('Erreur chargement exercices:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchData()
})
</script>
