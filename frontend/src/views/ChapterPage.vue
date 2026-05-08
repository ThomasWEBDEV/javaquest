<template>
  <MainLayout>
    <div class="chapter-page">

      <nav class="breadcrumb">
        <router-link to="/courses">Cours</router-link>
        <span class="sep">/</span>
        <span class="current">{{ chapter?.title || 'Chapitre' }}</span>
      </nav>

      <div v-if="loading" class="loading">Chargement...</div>

      <div v-else-if="chapter">

        <div class="chapter-header">
          <div class="chapter-icon">{{ chapterEmoji }}</div>
          <div class="chapter-meta">
            <p class="eyebrow">Chapitre {{ chapter.orderIndex }}</p>
            <h1 class="chapter-title">{{ chapter.title }}</h1>
            <p class="chapter-desc">{{ chapter.description }}</p>
          </div>
          <div class="chapter-xp-block">
            <div class="xp-num">{{ chapter.xpReward }}</div>
            <div class="xp-label">XP total</div>
          </div>
        </div>

        <p class="eyebrow section-label">{{ lessons.length }} lecon{{ lessons.length > 1 ? 's' : '' }}</p>

        <div v-if="lessons.length > 0" class="lessons-list">
          <router-link
            v-for="(lesson, index) in lessons"
            :key="lesson.id"
            :to="`/lessons/${lesson.id}`"
            class="lesson-row"
          >
            <span class="lesson-num">{{ String(index + 1).padStart(2, '0') }}</span>
            <div class="lesson-info">
              <span class="lesson-name">{{ lesson.title }}</span>
              <span class="lesson-sub">Lecon {{ lesson.orderIndex }}</span>
            </div>
            <span class="lesson-xp">+{{ lesson.xpReward }} XP</span>
            <span class="lesson-arrow">&#8594;</span>
          </router-link>
        </div>

        <div v-else class="empty">&#9676; Aucune lecon disponible pour ce chapitre.</div>
      </div>

      <div v-else class="empty">Chapitre introuvable.</div>
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

<style scoped>
.chapter-page {
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
.chapter-header {
  display: flex;
  align-items: flex-start;
  gap: 20px;
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 18px;
  padding: 24px;
}

.chapter-icon {
  font-size: 26px;
  width: 52px;
  height: 52px;
  background: var(--c-surface-2);
  border: 1px solid var(--c-border);
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.chapter-meta {
  flex: 1;
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

.chapter-title {
  font-family: var(--font-serif);
  font-size: 24px;
  font-weight: 700;
  color: var(--c-text);
  letter-spacing: -0.02em;
  line-height: 1.2;
}

.chapter-desc {
  font-size: 13px;
  color: var(--c-text-2);
  line-height: 1.6;
}

.chapter-xp-block {
  text-align: center;
  background: var(--c-amber-soft);
  border: 1px solid rgba(245, 158, 11, 0.18);
  border-radius: 12px;
  padding: 14px 18px;
  flex-shrink: 0;
}
.xp-num {
  font-size: 22px;
  font-weight: 700;
  color: var(--c-amber-light);
  line-height: 1;
}
.xp-label {
  font-size: 10px;
  color: var(--c-muted);
  margin-top: 3px;
}

.section-label { margin-top: 4px; }

/* Lessons list */
.lessons-list {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.lesson-row {
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
.lesson-row:hover {
  border-color: var(--c-border-strong);
  background: var(--c-surface-hover);
  transform: translateY(-1px);
}

.lesson-num {
  font-size: 11px;
  font-weight: 700;
  font-family: var(--font-mono);
  color: var(--c-subtle);
  letter-spacing: 0.06em;
  flex-shrink: 0;
  width: 24px;
}

.lesson-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 2px;
  min-width: 0;
}
.lesson-name {
  font-size: 14px;
  font-weight: 600;
  color: var(--c-text);
  transition: color var(--t);
}
.lesson-row:hover .lesson-name { color: var(--c-accent-light); }
.lesson-sub {
  font-size: 11px;
  color: var(--c-muted);
}

.lesson-xp {
  font-size: 11px;
  font-weight: 600;
  color: var(--c-amber-light);
  background: var(--c-amber-soft);
  padding: 3px 10px;
  border-radius: 100px;
  border: 1px solid rgba(245, 158, 11, 0.15);
  flex-shrink: 0;
}

.lesson-arrow {
  font-size: 13px;
  color: var(--c-subtle);
  transition: color var(--t), transform var(--t);
  flex-shrink: 0;
}
.lesson-row:hover .lesson-arrow {
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
</style>
