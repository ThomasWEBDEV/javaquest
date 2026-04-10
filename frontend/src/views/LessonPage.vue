<template>
  <MainLayout>
    <div class="max-w-3xl mx-auto">
      <div v-if="loading" class="text-center py-12">
        <div class="text-gray-500">Chargement...</div>
      </div>

      <div v-else-if="lesson">
        <!-- Navigation retour -->
        <router-link
          v-if="lesson.chapterId"
          :to="`/courses/${lesson.chapterId}`"
          class="text-indigo-600 hover:underline mb-6 inline-block"
        >
          &larr; Retour au chapitre
        </router-link>
        <router-link
          v-else
          to="/courses"
          class="text-indigo-600 hover:underline mb-6 inline-block"
        >
          &larr; Retour aux cours
        </router-link>

        <!-- En-tete lecon -->
        <div class="bg-white rounded-xl shadow p-8 mb-6">
          <div class="flex items-center justify-between mb-4">
            <h1 class="text-3xl font-bold text-gray-900">{{ lesson.title }}</h1>
            <span class="px-3 py-1 bg-yellow-100 text-yellow-700 rounded-full text-sm font-medium">
              +{{ lesson.xpReward }} XP
            </span>
          </div>

          <!-- Contenu de la lecon -->
          <div class="prose prose-gray max-w-none">
            <pre class="whitespace-pre-wrap font-sans text-gray-700 leading-relaxed text-base">{{ lesson.content }}</pre>
          </div>
        </div>

        <!-- Actions : exercices et quiz -->
        <div class="grid gap-4" :class="quizzes.length > 0 ? 'sm:grid-cols-2' : 'grid-cols-1'">
          <!-- Exercices -->
          <router-link
            :to="`/lessons/${lesson.id}/exercises`"
            class="bg-white rounded-xl shadow p-6 flex items-center space-x-4 hover:shadow-md transition-shadow group"
          >
            <div class="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center text-2xl group-hover:bg-green-200 transition-colors">
              &lt;/&gt;
            </div>
            <div>
              <h3 class="font-semibold text-gray-900">Exercices pratiques</h3>
              <p class="text-sm text-gray-500">Mettez en pratique ce que vous avez appris</p>
            </div>
          </router-link>

          <!-- Quiz -->
          <router-link
            v-for="quiz in quizzes"
            :key="quiz.id"
            :to="`/quizzes/${quiz.id}`"
            class="bg-white rounded-xl shadow p-6 flex items-center space-x-4 hover:shadow-md transition-shadow group"
          >
            <div class="w-12 h-12 bg-indigo-100 rounded-xl flex items-center justify-center text-2xl group-hover:bg-indigo-200 transition-colors">
              ?
            </div>
            <div>
              <h3 class="font-semibold text-gray-900">{{ quiz.title }}</h3>
              <p class="text-sm text-gray-500">
                {{ quiz.questionCount || '' }}
                <span v-if="quiz.timeLimitSeconds"> - {{ Math.floor(quiz.timeLimitSeconds / 60) }} min</span>
                <span v-if="quiz.xpReward"> - +{{ quiz.xpReward }} XP</span>
              </p>
            </div>
          </router-link>
        </div>
      </div>

      <div v-else class="text-center py-12 text-gray-500">
        Lecon introuvable.
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
const lesson = ref(null)
const quizzes = ref([])
const loading = ref(true)

async function fetchLesson() {
  try {
    const [lessonRes, quizzesRes] = await Promise.all([
      api.get(`/courses/lessons/${route.params.lessonId}`),
      api.get(`/quizzes/lesson/${route.params.lessonId}`)
    ])
    lesson.value = lessonRes.data
    quizzes.value = quizzesRes.data
  } catch (error) {
    console.error('Erreur chargement lecon:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchLesson()
})
</script>
