<template>
  <MainLayout>
    <div class="courses">

      <!-- Header -->
      <div class="courses-header">
        <div>
          <p class="eyebrow">Curriculum</p>
          <h1 class="page-title">Cours Java</h1>
        </div>
        <p class="page-subtitle">{{ chapters.length }} chapitres — du debut jusqu'au niveau avance</p>
      </div>

      <!-- Skeleton -->
      <div v-if="loading" class="chapters-grid">
        <div v-for="n in 6" :key="n" class="chapter-card chapter-skeleton"></div>
      </div>

      <!-- Grid -->
      <div v-else class="chapters-grid">
        <router-link
          v-for="chapter in chapters"
          :key="chapter.id"
          :to="`/courses/${chapter.slug}`"
          class="chapter-card"
        >
          <!-- Top row -->
          <div class="chapter-top">
            <span class="chapter-index">{{ String(chapter.orderIndex).padStart(2, '0') }}</span>
            <span class="chapter-xp">{{ chapter.xpReward }} XP</span>
          </div>

          <!-- Title -->
          <h3 class="chapter-title">{{ chapter.title }}</h3>

          <!-- Description -->
          <p class="chapter-desc">{{ chapter.description }}</p>

          <!-- Footer -->
          <div class="chapter-footer">
            <span class="chapter-lessons">
              {{ chapter.lessonCount || 0 }} lecon{{ (chapter.lessonCount || 0) > 1 ? 's' : '' }}
            </span>
            <span class="chapter-arrow">→</span>
          </div>
        </router-link>
      </div>

      <!-- Empty -->
      <div v-if="!loading && chapters.length === 0" class="courses-empty">
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

<style scoped>
.courses {
  max-width: 960px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 28px;
}

/* Header */
.courses-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
}

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
  font-size: 28px;
  font-weight: 700;
  color: var(--c-text);
  letter-spacing: -0.02em;
  line-height: 1.1;
}

.page-subtitle {
  font-size: 13px;
  color: var(--c-muted);
  text-align: right;
  flex-shrink: 0;
}

/* Grid */
.chapters-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
}

/* Card */
.chapter-card {
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 16px;
  padding: 22px 20px 18px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  text-decoration: none;
  transition: border-color var(--t), background var(--t), transform var(--t-slow);
  cursor: pointer;
}

.chapter-card:hover {
  border-color: var(--c-border-strong);
  background: var(--c-surface-hover);
  transform: translateY(-2px);
}

.chapter-skeleton {
  min-height: 160px;
  animation: pulse 1.4s ease infinite;
  cursor: default;
}

.chapter-skeleton:hover {
  transform: none;
  border-color: var(--c-border);
  background: var(--c-surface);
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.4; }
}

/* Card top */
.chapter-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.chapter-index {
  font-size: 11px;
  font-weight: 700;
  font-family: var(--font-mono);
  color: var(--c-subtle);
  letter-spacing: 0.06em;
}

.chapter-xp {
  font-size: 11px;
  font-weight: 600;
  color: var(--c-accent-light);
  background: var(--c-accent-soft);
  padding: 2px 8px;
  border-radius: 100px;
  border: 1px solid var(--c-accent-glow);
}

/* Title */
.chapter-title {
  font-size: 15px;
  font-weight: 600;
  color: var(--c-text);
  letter-spacing: -0.01em;
  line-height: 1.35;
  transition: color var(--t);
  flex: 1;
}

.chapter-card:hover .chapter-title {
  color: var(--c-accent-light);
}

/* Desc */
.chapter-desc {
  font-size: 12px;
  color: var(--c-muted);
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Footer */
.chapter-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-top: 10px;
  border-top: 1px solid var(--c-border);
  margin-top: auto;
}

.chapter-lessons {
  font-size: 11px;
  color: var(--c-subtle);
  font-weight: 500;
}

.chapter-arrow {
  font-size: 13px;
  color: var(--c-subtle);
  transition: color var(--t), transform var(--t);
}

.chapter-card:hover .chapter-arrow {
  color: var(--c-accent-light);
  transform: translateX(3px);
}

/* Empty */
.courses-empty {
  text-align: center;
  padding: 64px 0;
  font-size: 13px;
  color: var(--c-muted);
}
</style>
