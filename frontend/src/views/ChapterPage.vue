<template>
  <MainLayout>
    <div class="max-w-4xl mx-auto">
      <router-link to="/courses" class="text-indigo-600 hover:underline mb-4 inline-block">
        ← Retour aux cours
      </router-link>

      <div v-if="loading" class="text-center py-12">
        <div class="text-gray-500">Chargement...</div>
      </div>

      <div v-else-if="chapter">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">{{ chapter.title }}</h1>
        <p class="text-gray-600 mb-8">{{ chapter.description }}</p>

        <h2 class="text-xl font-bold text-gray-900 mb-4">Lecons</h2>
        <div class="space-y-4">
          <div
            v-for="lesson in lessons"
            :key="lesson.id"
            class="bg-white rounded-xl shadow p-6"
          >
            <div class="flex items-start justify-between">
              <div class="flex-1">
                <h3 class="text-lg font-semibold text-gray-900 mb-2">{{ lesson.title }}</h3>
                <div class="prose prose-sm text-gray-600" v-html="lesson.content?.substring(0, 200) + '...'"></div>
              </div>
              <router-link
                :to="`/exercises/${lesson.id}`"
                class="ml-4 px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition-colors text-sm whitespace-nowrap"
              >
                Voir exercices
              </router-link>
            </div>
          </div>
        </div>

        <div v-if="lessons.length === 0" class="text-center py-8 text-gray-500">
          Aucune lecon dans ce chapitre
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
const chapter = ref(null)
const lessons = ref([])
const loading = ref(true)

async function fetchChapter() {
  try {
    const response = await api.get(`/courses/chapters/${route.params.chapterId}`)
    chapter.value = response.data
  } catch (error) {
    console.error('Erreur chargement chapitre:', error)
  }
}

async function fetchLessons() {
  try {
    const response = await api.get(`/courses/chapters/${route.params.chapterId}/lessons`)
    lessons.value = response.data
  } catch (error) {
    console.error('Erreur chargement lecons:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchChapter()
  fetchLessons()
})
</script>
