<template>
  <MainLayout>
    <div class="max-w-4xl mx-auto">
      <!-- Fil d'Ariane -->
      <nav class="flex items-center gap-2 text-sm text-gray-500 mb-6">
        <router-link to="/courses" class="hover:text-indigo-600 transition-colors">Cours</router-link>
        <span>/</span>
        <span class="text-gray-800 font-medium">{{ chapter?.title || 'Chapitre' }}</span>
      </nav>

      <div v-if="loading" class="text-center py-16">
        <div class="animate-pulse text-gray-400">Chargement...</div>
      </div>

      <div v-else-if="chapter">
        <!-- En-tête chapitre -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8 mb-8">
          <div class="flex items-start gap-5">
            <div class="w-14 h-14 rounded-2xl bg-indigo-100 flex items-center justify-center text-2xl shrink-0">
              {{ chapterEmoji }}
            </div>
            <div class="flex-1">
              <p class="text-indigo-600 text-sm font-medium mb-1">Chapitre {{ chapter.orderIndex }}</p>
              <h1 class="text-3xl font-bold text-gray-900 mb-3">{{ chapter.title }}</h1>
              <p class="text-gray-600 leading-relaxed">{{ chapter.description }}</p>
            </div>
            <div class="shrink-0 text-center bg-indigo-50 rounded-xl px-5 py-3">
              <div class="text-2xl font-bold text-indigo-700">{{ chapter.xpReward }}</div>
              <div class="text-xs text-indigo-400 font-medium">XP total</div>
            </div>
          </div>
        </div>

        <!-- Liste des leçons -->
        <h2 class="text-lg font-bold text-gray-800 mb-4 flex items-center gap-2">
          <span>📚</span>
          <span>{{ lessons.length }} leçon{{ lessons.length > 1 ? 's' : '' }}</span>
        </h2>

        <div v-if="lessons.length > 0" class="space-y-3">
          <router-link
            v-for="(lesson, index) in lessons"
            :key="lesson.id"
            :to="`/lessons/${lesson.id}`"
            class="group flex items-center gap-5 bg-white rounded-2xl shadow-sm border border-gray-100 p-5 hover:border-indigo-300 hover:shadow-md transition-all"
          >
            <!-- Numéro -->
            <div class="w-10 h-10 rounded-xl bg-indigo-50 group-hover:bg-indigo-100 flex items-center justify-center font-bold text-indigo-600 shrink-0 transition-colors">
              {{ index + 1 }}
            </div>

            <!-- Titre + sous-titre -->
            <div class="flex-1 min-w-0">
              <h3 class="font-semibold text-gray-900 group-hover:text-indigo-700 transition-colors">{{ lesson.title }}</h3>
              <p class="text-sm text-gray-400 mt-0.5">Leçon {{ lesson.orderIndex }}</p>
            </div>

            <!-- XP -->
            <span class="shrink-0 px-3 py-1 bg-yellow-50 text-yellow-700 border border-yellow-200 rounded-full text-xs font-semibold">
              +{{ lesson.xpReward }} XP
            </span>

            <!-- Flèche -->
            <span class="shrink-0 text-gray-400 group-hover:text-indigo-600 group-hover:translate-x-1 transition-all font-bold">→</span>
          </router-link>
        </div>

        <div v-else class="bg-white rounded-2xl shadow-sm border border-gray-100 p-10 text-center text-gray-400">
          Aucune leçon disponible pour ce chapitre.
        </div>
      </div>

      <div v-else class="text-center py-12 text-gray-500">
        Chapitre introuvable.
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
const chapter = ref(null)
const lessons = ref([])
const loading = ref(true)

const EMOJIS = ['☕', '🔢', '🔀', '🏗️', '📦', '⚠️', '🌊', '📁', '⚡', '🎨']

const chapterEmoji = computed(() => {
  if (!chapter.value) return '📖'
  return EMOJIS[(chapter.value.orderIndex - 1) % EMOJIS.length] || '📖'
})

async function fetchData() {
  try {
    const chapterResponse = await api.get(`/courses/chapters/${route.params.chapterId}`)
    chapter.value = chapterResponse.data
    const lessonsResponse = await api.get(`/courses/chapters/${chapter.value.id}/lessons`)
    lessons.value = lessonsResponse.data
  } catch (error) {
    console.error('Erreur chargement:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchData()
})
</script>
