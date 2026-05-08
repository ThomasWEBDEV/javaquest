<template>
  <MainLayout>
    <div class="exercise-page">

      <div class="exercise-top">
        <button @click="$router.back()" class="btn-back">&#8592; Retour</button>
        <span v-if="lessonExercises.length > 1" class="ex-counter">
          Exercice {{ currentIndex + 1 }} / {{ lessonExercises.length }}
        </span>
      </div>

      <div v-if="loading" class="loading">Chargement de l'exercice...</div>

      <div v-else-if="exercise" class="exercise-grid">

        <!-- Instructions -->
        <div class="instructions-panel">
          <div class="instructions-top">
            <h1 class="exercise-title">{{ exercise.title }}</h1>
            <span class="diff-badge" :class="`diff-${(exercise.difficulty || '').toLowerCase()}`">
              {{ difficultyLabel }}
            </span>
          </div>

          <p class="exercise-desc">{{ exercise.description }}</p>

          <div v-if="parsedHints.length > 0" class="hints-block">
            <div class="hints-header">
              <span class="hint-glyph">&#10022;</span>
              <span class="hints-title">Indices</span>
            </div>
            <ul class="hints-list">
              <li v-for="(hint, i) in parsedHints" :key="i" class="hint-item">
                <span class="hint-num">{{ i + 1 }}</span>
                <span>{{ hint }}</span>
              </li>
            </ul>
          </div>

          <div class="instructions-footer">
            <span class="xp-tag">+{{ exercise.xpReward }} XP</span>
          </div>
        </div>

        <!-- Editor -->
        <div class="editor-panel">

          <div class="window-bar">
            <div class="window-dots">
              <span class="dot-r"></span>
              <span class="dot-y"></span>
              <span class="dot-g"></span>
            </div>
            <span class="window-title">Main.java</span>
            <div style="width: 64px"></div>
          </div>

          <textarea
            ref="editorRef"
            v-model="code"
            @keydown.tab.prevent="handleTab"
            class="code-editor"
            placeholder="// Ecrivez votre code Java ici..."
            spellcheck="false"
            autocomplete="off"
            autocorrect="off"
            autocapitalize="off"
          ></textarea>

          <div v-if="alreadyCompleted" class="completed-banner">
            <span class="completed-check">&#10003;</span>
            <div>
              <div class="completed-title">Exercice deja complete !</div>
              <div class="completed-sub">Vous avez deja reussi cet exercice.</div>
            </div>
          </div>

          <div class="editor-actions">
            <button
              @click="runCode()"
              :disabled="executing || alreadyCompleted"
              class="btn-run"
            >
              <span v-if="executing" class="spin">&#8635;</span>
              {{ executing ? 'Execution...' : '&#9654; Executer' }}
            </button>
            <button
              @click="submitCode"
              :disabled="executing || alreadyCompleted"
              class="btn-submit"
            >
              &#10003; Soumettre
            </button>
          </div>

          <transition name="fade">
            <div v-if="xpToast" class="xp-toast-wrap">
              <div class="xp-toast">
                <span class="toast-star">&#11088;</span>
                <div>
                  <div class="toast-title">Exercice reussi !</div>
                  <div class="toast-sub">+{{ exercise?.xpReward }} XP gagnes</div>
                </div>
              </div>
              <div class="nav-actions">
                <router-link
                  v-if="nextExercise"
                  :to="`/exercises/${nextExercise.id}`"
                  class="btn-next-ex"
                >Exercice suivant &#8594;</router-link>
                <router-link
                  v-else-if="exercise?.lessonId"
                  :to="`/lessons/${exercise.lessonId}`"
                  class="btn-next-ex"
                >Retour a la lecon &#10003;</router-link>
              </div>
            </div>
          </transition>

          <div v-if="output" class="output-panel" :class="outputSuccess ? 'out-success' : 'out-error'">
            <div class="output-header">
              <span>{{ outputSuccess ? '&#10003; Succes' : '&#10007; Erreur' }}</span>
            </div>
            <div class="output-body">
              <pre class="output-pre">{{ output }}</pre>
            </div>
          </div>

        </div>
      </div>

      <div v-else class="empty">Exercice introuvable.</div>
    </div>
  </MainLayout>
</template>

<script setup>
import { ref, computed, nextTick, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import MainLayout from '@/components/layout/MainLayout.vue'
import { useAuthStore } from '@/stores/auth'
import api from '@/services/api'

const route = useRoute()
const authStore = useAuthStore()

const exercise = ref(null)
const lessonExercises = ref([])
const code = ref('')
const output = ref('')
const outputSuccess = ref(false)
const loading = ref(true)
const executing = ref(false)
const xpToast = ref(false)
const alreadyCompleted = ref(false)
const editorRef = ref(null)

const difficultyClass = computed(() => {
  switch (exercise.value?.difficulty) {
    case 'EASY': return 'bg-green-100 text-green-700'
    case 'MEDIUM': return 'bg-yellow-100 text-yellow-700'
    case 'HARD': return 'bg-red-100 text-red-700'
    default: return 'bg-gray-100 text-gray-700'
  }
})

const difficultyLabel = computed(() => {
  switch (exercise.value?.difficulty) {
    case 'EASY': return 'Facile'
    case 'MEDIUM': return 'Moyen'
    case 'HARD': return 'Difficile'
    default: return exercise.value?.difficulty || ''
  }
})

const parsedHints = computed(() => {
  if (!exercise.value?.hints) return []
  try {
    const parsed = JSON.parse(exercise.value.hints)
    return Array.isArray(parsed) ? parsed : [exercise.value.hints]
  } catch {
    return [exercise.value.hints]
  }
})

const currentIndex = computed(() => {
  if (!exercise.value || !lessonExercises.value.length) return 0
  return lessonExercises.value.findIndex(e => e.id === exercise.value.id)
})

const nextExercise = computed(() => {
  const idx = currentIndex.value
  if (idx >= 0 && idx < lessonExercises.value.length - 1) {
    return lessonExercises.value[idx + 1]
  }
  return null
})

function handleTab(event) {
  const textarea = event.target
  const start = textarea.selectionStart
  const end = textarea.selectionEnd
  code.value = code.value.substring(0, start) + '    ' + code.value.substring(end)
  nextTick(() => {
    textarea.selectionStart = textarea.selectionEnd = start + 4
  })
}

async function fetchExercise() {
  try {
    const response = await api.get(`/exercises/${route.params.exerciseId}`)
    exercise.value = response.data
    code.value = response.data.starterCode || ''

    if (response.data.lessonId) {
      const listRes = await api.get(`/exercises/lesson/${response.data.lessonId}`)
      lessonExercises.value = listRes.data
    }

    if (authStore.user?.id) {
      try {
        const progressRes = await api.get(`/dashboard/${authStore.user.id}/exercises/${route.params.exerciseId}/progress`)
        if (progressRes.data?.status === 'COMPLETED') {
          alreadyCompleted.value = true
        }
      } catch {
        // Pas encore de progression
      }
    }
  } catch (error) {
    console.error('Erreur chargement exercice:', error)
  } finally {
    loading.value = false
  }
}

async function runCode(exerciseId = null) {
  executing.value = true
  output.value = ''
  try {
    const payload = { code: code.value }
    if (exerciseId) payload.exerciseId = exerciseId
    const response = await api.post('/execute', payload)
    output.value = response.data.output
    outputSuccess.value = response.data.success
  } catch (error) {
    output.value = error.response?.data?.error || "Erreur d'execution"
    outputSuccess.value = false
  } finally {
    executing.value = false
  }
}

async function submitCode() {
  await runCode(exercise.value?.id)
  if (outputSuccess.value && authStore.user?.id) {
    try {
      await api.post(`/dashboard/${authStore.user.id}/exercises/${exercise.value.id}/attempt`, {
        code: code.value,
        success: true
      })
      output.value += '\n\nBravo ! Exercice complete !'
      xpToast.value = true
      setTimeout(() => { xpToast.value = false }, 8000)
      const progress = await api.get(`/gamification/progress/${authStore.user.id}`)
      authStore.setProgress(progress.data.totalXp, progress.data.currentLevel)
    } catch (error) {
      console.error('Erreur soumission:', error)
    }
  }
}

onMounted(() => {
  fetchExercise()
})
</script>

<style scoped>
.exercise-page {
  max-width: 1100px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 18px;
}

.exercise-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.btn-back {
  font-size: 13px;
  font-weight: 500;
  color: var(--c-accent-light);
  background: transparent;
  border: none;
  padding: 0;
  transition: opacity var(--t);
}
.btn-back:hover { opacity: 0.75; }
.ex-counter {
  font-size: 12px;
  font-family: var(--font-mono);
  color: var(--c-muted);
}

.loading {
  text-align: center;
  padding: 64px 0;
  font-size: 13px;
  color: var(--c-muted);
  animation: pulse 1.4s ease infinite;
}
@keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.4; } }

/* Grid */
.exercise-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  align-items: start;
}

/* Instructions */
.instructions-panel {
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 18px;
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.instructions-top {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
}
.exercise-title {
  font-family: var(--font-serif);
  font-size: 20px;
  font-weight: 700;
  color: var(--c-text);
  letter-spacing: -0.02em;
  line-height: 1.25;
  flex: 1;
}

.diff-badge {
  font-size: 10px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  padding: 4px 10px;
  border-radius: 100px;
  flex-shrink: 0;
}
.diff-easy { background: var(--c-green-soft); color: var(--c-green); border: 1px solid rgba(34, 197, 94, 0.2); }
.diff-medium { background: var(--c-amber-soft); color: var(--c-amber-light); border: 1px solid rgba(245, 158, 11, 0.2); }
.diff-hard { background: var(--c-red-soft); color: var(--c-red); border: 1px solid rgba(239, 68, 68, 0.2); }

.exercise-desc {
  font-size: 13px;
  color: var(--c-text-2);
  line-height: 1.75;
}

.hints-block {
  background: var(--c-surface-2);
  border: 1px solid var(--c-border);
  border-radius: 12px;
  padding: 14px 16px;
}
.hints-header {
  display: flex;
  align-items: center;
  gap: 6px;
  margin-bottom: 10px;
}
.hint-glyph { color: var(--c-amber); font-size: 14px; }
.hints-title {
  font-size: 10px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--c-amber-light);
}
.hints-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.hint-item {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  font-size: 12px;
  color: var(--c-text-2);
}
.hint-num {
  width: 16px;
  height: 16px;
  border-radius: 100px;
  background: var(--c-amber-soft);
  border: 1px solid rgba(245, 158, 11, 0.2);
  color: var(--c-amber-light);
  font-size: 10px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  margin-top: 1px;
}

.instructions-footer {
  padding-top: 4px;
  border-top: 1px solid var(--c-border);
}
.xp-tag {
  font-size: 12px;
  font-weight: 600;
  color: var(--c-amber-light);
  background: var(--c-amber-soft);
  padding: 4px 12px;
  border-radius: 100px;
  border: 1px solid rgba(245, 158, 11, 0.18);
}

/* Editor */
.editor-panel {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.window-bar {
  background: #1a1a1e;
  border: 1px solid var(--c-border-md);
  border-bottom: none;
  border-radius: 12px 12px 0 0;
  padding: 10px 14px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.window-dots { display: flex; align-items: center; gap: 6px; }
.dot-r { width: 10px; height: 10px; border-radius: 100px; background: #ff5f56; }
.dot-y { width: 10px; height: 10px; border-radius: 100px; background: #ffbd2e; }
.dot-g { width: 10px; height: 10px; border-radius: 100px; background: #27c93f; }
.window-title { font-size: 11px; font-family: var(--font-mono); color: var(--c-muted); }

.code-editor {
  width: 100%;
  height: 320px;
  font-family: var(--font-mono);
  font-size: 13px;
  line-height: 1.7;
  background: #0d0d10;
  color: #86efac;
  border: 1px solid var(--c-border-md);
  border-top: none;
  border-radius: 0 0 12px 12px;
  padding: 16px 18px;
  resize: none;
  outline: none;
  margin-top: -10px;
}
.code-editor::placeholder { color: var(--c-subtle); }

.completed-banner {
  display: flex;
  align-items: center;
  gap: 12px;
  background: var(--c-green-soft);
  border: 1px solid rgba(34, 197, 94, 0.2);
  border-radius: 12px;
  padding: 14px 16px;
}
.completed-check {
  font-size: 18px;
  color: var(--c-green);
  font-weight: 700;
}
.completed-title { font-size: 14px; font-weight: 600; color: var(--c-green); }
.completed-sub { font-size: 12px; color: var(--c-muted); margin-top: 2px; }

.editor-actions { display: flex; gap: 10px; }
.btn-run {
  flex: 1;
  padding: 12px;
  background: var(--c-green);
  color: white;
  border: none;
  border-radius: 10px;
  font-size: 13px;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  transition: opacity var(--t), transform var(--t);
}
.btn-run:hover:not(:disabled) { opacity: 0.88; transform: translateY(-1px); }
.btn-run:disabled { opacity: 0.4; }
.btn-submit {
  flex: 1;
  padding: 12px;
  background: var(--c-accent);
  color: white;
  border: none;
  border-radius: 10px;
  font-size: 13px;
  font-weight: 600;
  transition: opacity var(--t), transform var(--t);
}
.btn-submit:hover:not(:disabled) { opacity: 0.88; transform: translateY(-1px); }
.btn-submit:disabled { opacity: 0.4; }
.spin { display: inline-block; animation: spin 1s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

.xp-toast-wrap { display: flex; flex-direction: column; gap: 8px; }
.xp-toast {
  display: flex;
  align-items: center;
  gap: 10px;
  background: var(--c-amber-soft);
  border: 1px solid rgba(245, 158, 11, 0.2);
  border-radius: 12px;
  padding: 14px 16px;
}
.toast-star { font-size: 20px; }
.toast-title { font-size: 14px; font-weight: 600; color: var(--c-amber-light); }
.toast-sub { font-size: 12px; color: var(--c-muted); margin-top: 2px; }
.nav-actions { display: flex; gap: 8px; }
.btn-next-ex {
  flex: 1;
  padding: 11px;
  background: var(--c-accent);
  color: white;
  border-radius: 10px;
  text-decoration: none;
  font-size: 13px;
  font-weight: 600;
  text-align: center;
  transition: opacity var(--t), transform var(--t);
}
.btn-next-ex:hover { opacity: 0.88; transform: translateY(-1px); }

.output-panel {
  border-radius: 12px;
  overflow: hidden;
  border: 1px solid transparent;
}
.out-success { border-color: rgba(34, 197, 94, 0.2); }
.out-error { border-color: rgba(239, 68, 68, 0.2); }
.output-header {
  padding: 8px 14px;
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
}
.out-success .output-header { background: var(--c-green-soft); color: var(--c-green); }
.out-error .output-header { background: var(--c-red-soft); color: var(--c-red); }
.output-body { background: #0d0d10; padding: 14px 16px; }
.output-pre {
  font-family: var(--font-mono);
  font-size: 12px;
  color: var(--c-text-2);
  white-space: pre-wrap;
  margin: 0;
}

.empty {
  text-align: center;
  padding: 48px 0;
  font-size: 13px;
  color: var(--c-muted);
}

.fade-enter-active, .fade-leave-active { transition: opacity 0.4s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>
