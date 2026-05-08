<template>
  <MainLayout>
    <div class="lesson-page">

      <div v-if="loading" class="loading">Chargement de la lecon...</div>

      <div v-else-if="lesson">

        <nav class="breadcrumb">
          <router-link to="/courses">Cours</router-link>
          <span class="sep">/</span>
          <router-link
            v-if="lesson.chapterId"
            :to="`/courses/${lesson.chapterSlug || lesson.chapterId}`"
          >{{ lesson.chapterTitle || 'Chapitre' }}</router-link>
          <span v-if="lesson.chapterId" class="sep">/</span>
          <span class="current">{{ lesson.title }}</span>
        </nav>

        <!-- Header -->
        <div class="lesson-header">
          <div class="lesson-header-left">
            <p class="eyebrow">Lecon {{ lesson.orderIndex }}</p>
            <h1 class="lesson-title">{{ lesson.title }}</h1>
          </div>
          <div class="lesson-xp-badge">
            <span class="xp-val">+{{ lesson.xpReward }}</span>
            <span class="xp-lbl">XP</span>
          </div>
        </div>

        <!-- Content -->
        <div class="lesson-content-card">
          <div class="lesson-content">
            <template v-for="(block, i) in contentBlocks" :key="i">
              <hr v-if="block.type === 'divider'" class="content-divider" />
              <h2 v-else-if="block.type === 'header'" class="content-header">{{ block.text }}</h2>
              <div v-else-if="block.type === 'code'" class="code-block">
                <div class="code-lang">Java</div>
                <pre class="code-pre">{{ block.lines.join('\n') }}</pre>
              </div>
              <p v-else class="content-text">{{ block.text }}</p>
            </template>
          </div>
        </div>

        <!-- Actions -->
        <div class="lesson-actions" :class="{ 'two-cols': quizzes.length > 0 }">
          <router-link :to="`/lessons/${lesson.id}/exercises`" class="action-card action-exercises">
            <div class="action-icon">&#10022;</div>
            <div class="action-info">
              <h3>Exercices pratiques</h3>
              <p>Mettez en pratique ce que vous venez d'apprendre</p>
            </div>
            <span class="action-arrow">&#8594;</span>
          </router-link>

          <router-link
            v-for="quiz in quizzes"
            :key="quiz.id"
            :to="`/quizzes/${quiz.id}`"
            class="action-card action-quiz"
          >
            <div class="action-icon">&#9678;</div>
            <div class="action-info">
              <h3>{{ quiz.title }}</h3>
              <p>
                <span v-if="quiz.timeLimitSeconds">{{ Math.floor(quiz.timeLimitSeconds / 60) }} min</span>
                <span v-if="quiz.xpReward"> &middot; +{{ quiz.xpReward }} XP</span>
              </p>
            </div>
            <span class="action-arrow">&#8594;</span>
          </router-link>
        </div>

      </div>

      <div v-else class="empty">Lecon introuvable.</div>
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

    if (line.startsWith('  ') && trimmed.length > 0) {
      inCode = true
      codeLines.push(line)
      continue
    }

    if (trimmed === '' && inCode) {
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

    const isHeader = trimmed === trimmed.toUpperCase()
      && trimmed.length > 4
      && /[A-Z]/.test(trimmed)
      && !/^[0-9]/.test(trimmed)

    if (isHeader) {
      blocks.push({ type: 'header', text: trimmed })
    } else {
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

<style scoped>
.lesson-page {
  max-width: 720px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.breadcrumb {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  color: var(--c-muted);
}
.breadcrumb a { transition: color var(--t); }
.breadcrumb a:hover { color: var(--c-text-2); }
.sep { color: var(--c-subtle); }
.current { color: var(--c-text-2); }

.loading {
  text-align: center;
  padding: 64px 0;
  font-size: 13px;
  color: var(--c-muted);
  animation: pulse 1.4s ease infinite;
}
@keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.4; } }

/* Header */
.lesson-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 18px;
  padding: 24px 28px;
}
.lesson-header-left {
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.eyebrow {
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--c-muted);
}
.lesson-title {
  font-family: var(--font-serif);
  font-size: 26px;
  font-weight: 700;
  color: var(--c-text);
  letter-spacing: -0.02em;
  line-height: 1.2;
}
.lesson-xp-badge {
  display: flex;
  flex-direction: column;
  align-items: center;
  background: var(--c-amber-soft);
  border: 1px solid rgba(245, 158, 11, 0.2);
  border-radius: 12px;
  padding: 12px 18px;
  flex-shrink: 0;
}
.xp-val {
  font-size: 20px;
  font-weight: 700;
  color: var(--c-amber-light);
  line-height: 1;
}
.xp-lbl {
  font-size: 10px;
  color: var(--c-muted);
  margin-top: 3px;
}

/* Content */
.lesson-content-card {
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 18px;
  padding: 28px 32px;
}
.lesson-content {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.content-divider {
  border: none;
  border-top: 1px solid var(--c-border);
  margin: 4px 0;
}
.content-header {
  font-size: 16px;
  font-weight: 700;
  color: var(--c-text);
  padding-top: 8px;
  letter-spacing: -0.01em;
}
.code-block {
  position: relative;
  border-radius: 12px;
  overflow: hidden;
  background: #0d0d10;
  border: 1px solid var(--c-border-md);
}
.code-lang {
  position: absolute;
  top: 10px;
  right: 12px;
  font-size: 10px;
  font-family: var(--font-mono);
  color: var(--c-muted);
  background: rgba(255, 255, 255, 0.05);
  padding: 2px 8px;
  border-radius: 4px;
}
.code-pre {
  font-family: var(--font-mono);
  font-size: 13px;
  color: #86efac;
  padding: 18px 20px;
  overflow-x: auto;
  line-height: 1.7;
  margin: 0;
}
.content-text {
  font-size: 14px;
  color: var(--c-text-2);
  line-height: 1.75;
  white-space: pre-line;
}

/* Actions */
.lesson-actions {
  display: grid;
  gap: 10px;
  grid-template-columns: 1fr;
}
.lesson-actions.two-cols {
  grid-template-columns: 1fr 1fr;
}

.action-card {
  display: flex;
  align-items: center;
  gap: 16px;
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 16px;
  padding: 20px;
  text-decoration: none;
  transition: border-color var(--t), background var(--t), transform var(--t-slow);
}
.action-card:hover {
  border-color: var(--c-border-strong);
  background: var(--c-surface-hover);
  transform: translateY(-2px);
}

.action-icon {
  width: 44px;
  height: 44px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  flex-shrink: 0;
}
.action-exercises .action-icon {
  background: var(--c-green-soft);
  color: var(--c-green);
}
.action-quiz .action-icon {
  background: var(--c-accent-soft);
  color: var(--c-accent-light);
}

.action-info { flex: 1; min-width: 0; }
.action-info h3 {
  font-size: 14px;
  font-weight: 600;
  color: var(--c-text);
  margin-bottom: 2px;
  transition: color var(--t);
}
.action-card:hover .action-info h3 { color: var(--c-accent-light); }
.action-info p {
  font-size: 12px;
  color: var(--c-muted);
}

.action-arrow {
  font-size: 14px;
  color: var(--c-subtle);
  transition: color var(--t), transform var(--t);
  flex-shrink: 0;
}
.action-card:hover .action-arrow {
  color: var(--c-accent-light);
  transform: translateX(3px);
}

.empty {
  text-align: center;
  padding: 48px 0;
  font-size: 13px;
  color: var(--c-muted);
}
</style>
