<template>
  <MainLayout>
    <div class="max-w-3xl mx-auto">
      <div v-if="loading" class="text-center py-12">
        <div class="text-gray-500">Chargement...</div>
      </div>

      <div v-else>
        <router-link
          v-if="lessonId"
          :to="`/lessons/${lessonId}`"
          class="text-indigo-600 hover:underline mb-6 inline-block"
        >
          &larr; Retour a la lecon
        </router-link>

        <h1 class="text-3xl font-bold text-gray-900 mb-2">Exercices pratiques</h1>
        <p v-if="lessonTitle" class="text-gray-500 mb-8">{{ lessonTitle }}</p>

        <div v-if="exercises.length > 0" class="space-y-4">
          <router-link
            v-for="exercise in exercises"
            :key="exercise.id"
            :to="`/exercises/${exercise.id}`"
            class="bg-white rounded-xl shadow p-6 block hover:shadow-md transition-shadow group"
          >
            <div class="flex items-start justify-between">
              <div class="flex-1">
                <div class="flex items-center gap-3 mb-2">
                  <h3 class="text-lg font-semibold text-gray-900">{{ exercise.title }}</h3>
                  <span
                    class="px-2 py-0.5 rounded-full text-xs font-medium"
                    :class="difficultyClass(exercise.difficulty)"
                  >
                    {{ difficultyLabel(exercise.difficulty) }}
                  </span>
                </div>
                <p class="text-gray-600 text-sm">{{ exercise.description }}</p>
              </div>
              <div class="ml-4 flex flex-col items-end gap-2">
                <span class="px-3 py-1 bg-yellow-100 text-yellow-700 rounded-full text-sm font-medium whitespace-nowrap">
                  +{{ exercise.xpReward }} XP
                </span>
                <span class="px-4 py-2 bg-indigo-600 text-white rounded-lg text-sm group-hover:bg-indigo-700 transition-colors whitespace-nowrap">
                  Commencer
                </span>
              </div>
            </div>
          </router-link>
        </div>

        <div v-else class="bg-white rounded-xl shadow p-8 text-center text-gray-500">
          Aucun exercice disponible pour cette lecon.
        </div>
      </div>
    </div>
  </MainLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import MainLayout from '@/components/layout/MainLayout.vue'
import api from '@/services/api'

const route = useRoute()
const lessonId = route.params.lessonId
const exercises = ref([])
const lessonTitle = ref('')
const loading = ref(true)

function difficultyClass(difficulty) {
  switch (difficulty) {
    case 'EASY': return 'bg-green-100 text-green-700'
    case 'MEDIUM': return 'bg-yellow-100 text-yellow-700'
    case 'HARD': return 'bg-red-100 text-red-700'
    default: return 'bg-gray-100 text-gray-700'
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
