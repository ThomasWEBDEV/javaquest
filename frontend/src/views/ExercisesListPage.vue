<template>
  <MainLayout>
    <div class="exercises-page">

      <nav class="breadcrumb">
        <router-link to="/courses">Cours</router-link>
        <span class="sep">/</span>
        <router-link v-if="lessonId" :to="`/lessons/${lessonId}`">{{ lessonTitle || 'Lecon' }}</router-link>
        <span class="sep">/</span>
        <span class="current">Exercices</span>
      </nav>

      <div v-if="loading" class="loading">Chargement des exercices...</div>

      <div v-else>
        <div class="exercises-header">
          <div>
            <p class="eyebrow">Pratique</p>
            <h1 class="page-title">Exercices pratiques</h1>
            <p v-if="lessonTitle" class="lesson-name">{{ lessonTitle }}</p>
          </div>
        </div>

        <div v-if="difficultyStats.length > 0" class="diff-stats">
          <span
            v-for="d in difficultyStats"
            :key="d.label"
            class="diff-pill"
            :class="`diff-${d.key}`"
          >{{ d.count }}&times; {{ d.label }}</span>
        </div>

        <div v-if="exercises.length > 0" class="exercises-list">
          <router-link
            v-for="(exercise, index) in exercises"
            :key="exercise.id"
            :to="`/exercises/${exercise.id}`"
            class="exercise-row"
          >
            <span class="ex-num" :class="`num-${(exercise.difficulty || '').toLowerCase()}`">
              {{ String(index + 1).padStart(2, '0') }}
            </span>
            <div class="ex-info">
              <div class="ex-title-row">
                <h3 class="ex-name">{{ exercise.title }}</h3>
                <span class="ex-diff" :class="`diff-${(exercise.difficulty || '').toLowerCase()}`">
                  {{ difficultyLabel(exercise.difficulty) }}
                </span>
              </div>
              <p class="ex-desc">{{ exercise.description }}</p>
            </div>
            <div class="ex-right">
              <span class="ex-xp">+{{ exercise.xpReward }} XP</span>
              <span class="ex-arrow">&#8594;</span>
            </div>
          </router-link>
        </div>

        <div v-else class="empty">&#9676; Aucun exercice disponible pour cette lecon.</div>

        <div class="back-wrap">
          <router-link v-if="lessonId" :to="`/lessons/${lessonId}`" class="back-btn">
            &#8592; Retour a la lecon
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
    { label: 'Facile', count: counts.EASY, key: 'easy' },
    { label: 'Moyen', count: counts.MEDIUM, key: 'medium' },
    { label: 'Difficile', count: counts.HARD, key: 'hard' },
  ].filter(s => s.count > 0)
})

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

<style scoped>
.exercises-page {
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
.exercises-header { display: flex; flex-direction: column; gap: 4px; }
.eyebrow {
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--c-muted);
  margin-bottom: 4px;
}
.page-title {
  font-family: var(--font-serif);
  font-size: 26px;
  font-weight: 700;
  color: var(--c-text);
  letter-spacing: -0.02em;
  line-height: 1.1;
}
.lesson-name {
  font-size: 13px;
  color: var(--c-muted);
  margin-top: 4px;
}

/* Difficulty stats */
.diff-stats {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}
.diff-pill {
  font-size: 11px;
  font-weight: 600;
  padding: 4px 12px;
  border-radius: 100px;
  border: 1px solid transparent;
}
.diff-easy { background: var(--c-green-soft); color: var(--c-green); border-color: rgba(34, 197, 94, 0.2); }
.diff-medium { background: var(--c-amber-soft); color: var(--c-amber-light); border-color: rgba(245, 158, 11, 0.2); }
.diff-hard { background: var(--c-red-soft); color: var(--c-red); border-color: rgba(239, 68, 68, 0.2); }

/* List */
.exercises-list {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.exercise-row {
  display: flex;
  align-items: center;
  gap: 16px;
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 14px;
  padding: 16px 20px;
  text-decoration: none;
  transition: border-color var(--t), background var(--t), transform var(--t-slow);
}
.exercise-row:hover {
  border-color: var(--c-border-strong);
  background: var(--c-surface-hover);
  transform: translateY(-1px);
}

.ex-num {
  font-size: 11px;
  font-weight: 700;
  font-family: var(--font-mono);
  width: 24px;
  flex-shrink: 0;
  letter-spacing: 0.06em;
}
.num-easy { color: var(--c-green); }
.num-medium { color: var(--c-amber-light); }
.num-hard { color: var(--c-red); }
.num- { color: var(--c-subtle); }

.ex-info { flex: 1; min-width: 0; display: flex; flex-direction: column; gap: 4px; }
.ex-title-row { display: flex; align-items: center; gap: 8px; }
.ex-name {
  font-size: 14px;
  font-weight: 600;
  color: var(--c-text);
  transition: color var(--t);
}
.exercise-row:hover .ex-name { color: var(--c-accent-light); }

.ex-diff {
  font-size: 10px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.07em;
  padding: 2px 8px;
  border-radius: 100px;
  flex-shrink: 0;
}

.ex-desc {
  font-size: 12px;
  color: var(--c-muted);
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.ex-right {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 4px;
  flex-shrink: 0;
}
.ex-xp {
  font-size: 11px;
  font-weight: 600;
  color: var(--c-amber-light);
  background: var(--c-amber-soft);
  padding: 3px 10px;
  border-radius: 100px;
  border: 1px solid rgba(245, 158, 11, 0.15);
}
.ex-arrow {
  font-size: 13px;
  color: var(--c-subtle);
  transition: color var(--t), transform var(--t);
}
.exercise-row:hover .ex-arrow {
  color: var(--c-accent-light);
  transform: translateX(3px);
}

.empty {
  text-align: center;
  padding: 48px 0;
  font-size: 13px;
  color: var(--c-muted);
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 16px;
}

.back-wrap { text-align: center; padding: 8px 0; }
.back-btn {
  font-size: 13px;
  font-weight: 500;
  color: var(--c-accent-light);
  transition: opacity var(--t);
}
.back-btn:hover { opacity: 0.75; }
</style>
