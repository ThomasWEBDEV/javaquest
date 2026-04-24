<template>
  <MainLayout>
    <div class="max-w-4xl mx-auto">
      <div v-if="loading" class="text-center py-16">
        <div class="animate-pulse text-gray-400">Chargement de la leçon...</div>
      </div>

      <div v-else-if="lesson">
        <!-- Fil d'Ariane -->
        <nav class="flex items-center gap-2 text-sm text-gray-500 mb-6">
          <router-link to="/courses" class="hover:text-indigo-600 transition-colors">Cours</router-link>
          <span>/</span>
          <router-link
            v-if="lesson.chapterId"
            :to="`/courses/${lesson.chapterSlug || lesson.chapterId}`"
            class="hover:text-indigo-600 transition-colors"
          >{{ lesson.chapterTitle || 'Chapitre' }}</router-link>
          <span v-if="lesson.chapterId">/</span>
          <span class="text-gray-800 font-medium">{{ lesson.title }}</span>
        </nav>

        <!-- En-tête leçon -->
        <div class="bg-gradient-to-br from-indigo-600 to-indigo-800 rounded-2xl p-8 mb-8 text-white">
          <div class="flex items-start justify-between gap-4">
            <div>
              <p class="text-indigo-200 text-sm font-medium mb-2 uppercase tracking-wide">
                Leçon {{ lesson.orderIndex }}
              </p>
              <h1 class="text-3xl font-bold leading-tight">{{ lesson.title }}</h1>
            </div>
            <div class="shrink-0 bg-white/20 backdrop-blur rounded-xl px-4 py-3 text-center">
              <div class="text-2xl font-bold">+{{ lesson.xpReward }}</div>
              <div class="text-indigo-200 text-xs">XP</div>
            </div>
          </div>
        </div>

        <!-- Contenu de la leçon -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8 mb-8">
          <div class="lesson-content space-y-4">
            <template v-for="(block, i) in contentBlocks" :key="i">
              <!-- Séparateur -->
              <hr v-if="block.type === 'divider'" class="border-gray-200 my-6" />

              <!-- Titre de section -->
              <h2 v-else-if="block.type === 'header'" class="text-xl font-bold text-gray-900 mt-6 mb-2 pt-2">
                {{ block.text }}
              </h2>

              <!-- Bloc de code -->
              <div v-else-if="block.type === 'code'" class="relative group">
                <div class="absolute top-3 right-3 text-xs text-gray-500 font-mono bg-gray-800 px-2 py-0.5 rounded opacity-60">Java</div>
                <pre class="bg-gray-950 text-green-300 p-5 rounded-xl font-mono text-sm overflow-x-auto leading-relaxed">{{ block.lines.join('\n') }}</pre>
              </div>

              <!-- Texte normal -->
              <p v-else class="text-gray-700 leading-relaxed whitespace-pre-line">{{ block.text }}</p>
            </template>
          </div>
        </div>

        <!-- Actions : quiz et exercices -->
        <div class="grid gap-4" :class="quizzes.length > 0 ? 'sm:grid-cols-2' : 'grid-cols-1'">
          <!-- Exercices -->
          <router-link
            :to="`/lessons/${lesson.id}/exercises`"
            class="group flex items-center gap-5 bg-white rounded-2xl shadow-sm border border-gray-100 p-6 hover:border-emerald-300 hover:shadow-md transition-all"
          >
            <div class="w-14 h-14 bg-emerald-100 group-hover:bg-emerald-200 rounded-2xl flex items-center justify-center text-2xl transition-colors shrink-0">
              💻
            </div>
            <div>
              <h3 class="font-bold text-gray-900 mb-1">Exercices pratiques</h3>
              <p class="text-sm text-gray-500">Mettez en pratique ce que vous venez d'apprendre</p>
            </div>
            <span class="ml-auto text-emerald-600 font-bold text-lg group-hover:translate-x-1 transition-transform">→</span>
          </router-link>

          <!-- Quiz -->
          <router-link
            v-for="quiz in quizzes"
            :key="quiz.id"
            :to="`/quizzes/${quiz.id}`"
            class="group flex items-center gap-5 bg-white rounded-2xl shadow-sm border border-gray-100 p-6 hover:border-indigo-300 hover:shadow-md transition-all"
          >
            <div class="w-14 h-14 bg-indigo-100 group-hover:bg-indigo-200 rounded-2xl flex items-center justify-center text-2xl transition-colors shrink-0">
              🧠
            </div>
            <div>
              <h3 class="font-bold text-gray-900 mb-1">{{ quiz.title }}</h3>
              <p class="text-sm text-gray-500">
                <span v-if="quiz.timeLimitSeconds">{{ Math.floor(quiz.timeLimitSeconds / 60) }} min</span>
                <span v-if="quiz.xpReward"> · +{{ quiz.xpReward }} XP</span>
              </p>
            </div>
            <span class="ml-auto text-indigo-600 font-bold text-lg group-hover:translate-x-1 transition-transform">→</span>
          </router-link>
        </div>
      </div>

      <div v-else class="text-center py-12 text-gray-500">
        Leçon introuvable.
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
const lesson = ref(null)
const quizzes = ref([])
const loading = ref(true)

const contentBlocks = computed(() => {
  if (!lesson.value?.content) return []
  const blocks = []
  const lines = lesson.value.content.split('\n')
  let codeLines = []
  let inCode = false

  function flushCode() {
    if (codeLines.length > 0) {
      // Trim leading spaces to normalize indentation
      const minIndent = Math.min(...codeLines.filter(l => l.trim()).map(l => l.match(/^ */)[0].length))
      blocks.push({ type: 'code', lines: codeLines.map(l => l.substring(minIndent)) })
      codeLines = []
    }
    inCode = false
  }

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i]
    const trimmed = line.trim()

    if (trimmed === '---') {
      if (inCode) flushCode()
      blocks.push({ type: 'divider' })
      continue
    }

    // Code block detection: line starts with 2+ spaces (and is not empty)
    if (line.startsWith('  ') && trimmed.length > 0) {
      inCode = true
      codeLines.push(line)
      continue
    }

    // Empty line inside code block = separator, flush code
    if (trimmed === '' && inCode) {
      // Look ahead: if next non-empty line is also code, keep going
      const nextNonEmpty = lines.slice(i + 1).find(l => l.trim() !== '')
      if (nextNonEmpty && nextNonEmpty.startsWith('  ')) {
        codeLines.push('')
        continue
      }
      flushCode()
      continue
    }

    if (inCode) flushCode()

    if (trimmed === '') continue

    // Section header detection: all uppercase + long enough
    const isHeader = trimmed === trimmed.toUpperCase()
      && trimmed.length > 4
      && /[A-Z]/.test(trimmed)
      && !/^[0-9]/.test(trimmed)

    if (isHeader) {
      blocks.push({ type: 'header', text: trimmed })
    } else {
      // Merge consecutive text lines
      const last = blocks[blocks.length - 1]
      if (last && last.type === 'text') {
        last.text += '\n' + trimmed
      } else {
        blocks.push({ type: 'text', text: trimmed })
      }
    }
  }

  if (inCode) flushCode()
  return blocks
})

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
