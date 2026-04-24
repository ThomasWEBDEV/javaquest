<template>
  <MainLayout>
    <div class="max-w-5xl mx-auto">
      <!-- En-tête -->
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">Cours Java</h1>
        <p class="text-gray-500">Progressez à votre rythme avec un curriculum complet de {{ chapters.length }} chapitres.</p>
      </div>

      <div v-if="loading" class="grid md:grid-cols-2 lg:grid-cols-3 gap-5">
        <div
          v-for="n in 6"
          :key="n"
          class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 animate-pulse"
        >
          <div class="w-12 h-12 rounded-xl bg-gray-200 mb-4"></div>
          <div class="h-5 bg-gray-200 rounded mb-2 w-3/4"></div>
          <div class="h-3 bg-gray-100 rounded mb-1"></div>
          <div class="h-3 bg-gray-100 rounded w-2/3"></div>
        </div>
      </div>

      <div v-else class="grid md:grid-cols-2 lg:grid-cols-3 gap-5">
        <router-link
          v-for="chapter in chapters"
          :key="chapter.id"
          :to="`/courses/${chapter.slug}`"
          class="group flex flex-col bg-white rounded-2xl shadow-sm border border-gray-100 p-6 hover:shadow-md hover:border-indigo-200 transition-all"
        >
          <!-- Icône + numéro -->
          <div class="flex items-center justify-between mb-4">
            <div
              class="w-12 h-12 rounded-xl flex items-center justify-center text-2xl"
              :class="chapterBg(chapter.orderIndex)"
            >
              {{ chapterEmoji(chapter.orderIndex) }}
            </div>
            <span class="text-xs font-semibold text-gray-400 bg-gray-100 px-2 py-1 rounded-full">
              Ch. {{ chapter.orderIndex }}
            </span>
          </div>

          <!-- Titre + description -->
          <h3 class="text-lg font-bold text-gray-900 mb-2 group-hover:text-indigo-700 transition-colors">
            {{ chapter.title }}
          </h3>
          <p class="text-gray-500 text-sm leading-relaxed flex-1">{{ chapter.description }}</p>

          <!-- Footer -->
          <div class="flex items-center justify-between mt-5 pt-4 border-t border-gray-100">
            <span class="text-xs text-gray-400">
              {{ chapter.lessonCount || 0 }} leçon{{ (chapter.lessonCount || 0) > 1 ? 's' : '' }}
            </span>
            <span class="text-xs font-semibold text-indigo-600 bg-indigo-50 px-2 py-1 rounded-full">
              {{ chapter.xpReward }} XP
            </span>
          </div>
        </router-link>
      </div>

      <div v-if="!loading && chapters.length === 0" class="text-center py-16 text-gray-400">
        Aucun chapitre disponible.
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

const CHAPTER_CONFIG = [
  { emoji: '☕', bg: 'bg-orange-100' },
  { emoji: '🔢', bg: 'bg-blue-100' },
  { emoji: '🔀', bg: 'bg-purple-100' },
  { emoji: '🏗️', bg: 'bg-green-100' },
  { emoji: '📦', bg: 'bg-yellow-100' },
  { emoji: '⚠️', bg: 'bg-red-100' },
  { emoji: '🌊', bg: 'bg-cyan-100' },
  { emoji: '📁', bg: 'bg-slate-100' },
  { emoji: '⚡', bg: 'bg-violet-100' },
  { emoji: '🎨', bg: 'bg-pink-100' },
]

function chapterEmoji(orderIndex) {
  return CHAPTER_CONFIG[(orderIndex - 1) % CHAPTER_CONFIG.length]?.emoji || '📖'
}

function chapterBg(orderIndex) {
  return CHAPTER_CONFIG[(orderIndex - 1) % CHAPTER_CONFIG.length]?.bg || 'bg-gray-100'
}

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
