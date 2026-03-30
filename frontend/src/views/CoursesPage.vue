<template>
  <MainLayout>
    <div class="max-w-7xl mx-auto">
      <h1 class="text-3xl font-bold text-gray-900 mb-8">Cours Java</h1>

      <div v-if="loading" class="text-center py-12">
        <div class="text-gray-500">Chargement...</div>
      </div>

      <div v-else class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
        <router-link
          v-for="chapter in chapters"
          :key="chapter.id"
          :to="`/courses/${chapter.id}`"
          class="bg-white rounded-xl shadow hover:shadow-lg transition-shadow p-6"
        >
          <div class="flex items-start justify-between mb-4">
            <span class="px-3 py-1 bg-indigo-100 text-indigo-700 rounded-full text-sm font-medium">
              Chapitre {{ chapter.orderIndex }}
            </span>
          </div>
          <h3 class="text-xl font-bold text-gray-900 mb-2">{{ chapter.title }}</h3>
          <p class="text-gray-600 text-sm mb-4">{{ chapter.description }}</p>
          <div class="flex items-center text-sm text-gray-500">
            <span>{{ chapter.lessonCount || 0 }} lecons</span>
          </div>
        </router-link>
      </div>

      <div v-if="!loading && chapters.length === 0" class="text-center py-12">
        <div class="text-gray-500">Aucun chapitre disponible</div>
      </div>
    </div>
  </MainLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import MainLayout from '@/components/layout/MainLayout.vue'
import api from '@/services/api'

const chapters = ref([])
const loading = ref(true)

async function fetchChapters() {
  try {
    const response = await api.get('/courses/chapters')
    chapters.value = response.data
  } catch (error) {
    console.error('Erreur chargement chapitres:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchChapters()
})
</script>
