<template>
  <MainLayout>
    <div class="challenge-page">

      <!-- Header -->
      <div class="page-header">
        <p class="page-eyebrow">Quotidien</p>
        <h1 class="page-title">Defi du jour</h1>
      </div>

      <!-- Loading -->
      <div v-if="loading" class="state-center">
        <div class="loading-dot"></div>
        <span class="state-label">Chargement...</span>
      </div>

      <!-- Empty state -->
      <div v-else-if="!challenge" class="card state-center">
        <div class="empty-glyph">◎</div>
        <p class="empty-title">Pas de defi disponible</p>
        <p class="empty-sub">Revenez demain pour un nouveau defi !</p>
      </div>

      <!-- Challenge content -->
      <div v-else class="challenge-grid">

        <!-- Left: Instructions -->
        <div class="card">
          <div class="card-top">
            <div>
              <h2 class="challenge-title">{{ exercise?.title || challenge.title }}</h2>
              <p class="challenge-date">{{ formatDate(challenge.date) }}</p>
            </div>
            <span class="diff-badge" :class="diffClass">{{ diffLabel }}</span>
          </div>

          <p class="challenge-desc">{{ exercise?.description || challenge.description }}</p>

          <div class="tags-row">
            <span class="tag tag-amber">+{{ challenge.xpReward }} XP</span>
            <span class="tag tag-green">Bonus +{{ challenge.bonusXp }} XP</span>
            <span v-if="challenge.timeLimitMinutes" class="tag tag-blue">
              {{ challenge.timeLimitMinutes }} min
            </span>
          </div>

          <div v-if="challenge.hints" class="hint-box">
            <span class="hint-label">Indice</span>
            <p class="hint-text">{{ challenge.hints }}</p>
          </div>

          <!-- Status -->
          <div v-if="userChallenge" class="status-box" :class="statusClass">
            <span class="status-text">{{ statusText }}</span>
            <span v-if="userChallenge.status === 'COMPLETED'" class="status-meta">
              {{ userChallenge.xpEarned }} XP gagnes — {{ userChallenge.attemptsCount }} tentative{{ userChallenge.attemptsCount > 1 ? 's' : '' }}
            </span>
            <span v-else class="status-meta">
              {{ userChallenge.attemptsCount }} tentative{{ userChallenge.attemptsCount > 1 ? 's' : '' }}
            </span>
          </div>
        </div>

        <!-- Right: Code editor -->
        <div class="card">
          <div class="editor-header">
            <span class="editor-label">Editeur Java</span>
            <span v-if="userChallenge?.status === 'COMPLETED'" class="editor-done">Termine</span>
          </div>

          <textarea
            v-model="code"
            :disabled="userChallenge?.status === 'COMPLETED'"
            class="code-editor"
            :class="{ 'code-editor--done': userChallenge?.status === 'COMPLETED' }"
            spellcheck="false"
            placeholder="// Ecrivez votre code Java ici..."
          ></textarea>

          <div class="btn-row">
            <button
              @click="runCode"
              :disabled="executing || userChallenge?.status === 'COMPLETED'"
              class="btn btn-run"
            >
              {{ executing ? 'Execution...' : 'Executer' }}
            </button>
            <button
              @click="submitChallenge"
              :disabled="executing || userChallenge?.status === 'COMPLETED'"
              class="btn btn-submit"
            >
              Soumettre
            </button>
          </div>

          <!-- Output -->
          <div v-if="output" class="output-block" :class="outputSuccess ? 'output-ok' : 'output-err'">
            <span class="output-label">{{ outputSuccess ? 'Succes' : 'Erreur' }}</span>
            <pre class="output-pre">{{ output }}</pre>
          </div>

          <!-- XP toast -->
          <transition name="fade">
            <div v-if="xpToast" class="xp-toast">
              <span class="xp-star">✦</span>
              <span>+{{ xpToastAmount }} XP gagnes !</span>
            </div>
          </transition>

          <!-- Result message -->
          <div v-if="resultMessage" class="result-msg" :class="resultSuccess ? 'result-ok' : 'result-warn'">
            {{ resultMessage }}
          </div>
        </div>

      </div>
    </div>
  </MainLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import MainLayout from '@/components/layout/MainLayout.vue'
import { useAuthStore } from '@/stores/auth'
import api from '@/services/api'

const authStore = useAuthStore()

const challenge    = ref(null)
const exercise     = ref(null)
const userChallenge = ref(null)
const code          = ref('')
const output        = ref('')
const outputSuccess = ref(false)
const resultMessage = ref('')
const resultSuccess = ref(false)
const loading       = ref(true)
const executing     = ref(false)
const xpToast       = ref(false)
const xpToastAmount = ref(0)

function formatDate(date) {
  if (!date) return ''
  return new Date(date).toLocaleDateString('fr-FR', { day: 'numeric', month: 'long', year: 'numeric' })
}

const diffClass = computed(() => {
  switch (challenge.value?.difficulty) {
    case 'EASY':   return 'diff-easy'
    case 'MEDIUM': return 'diff-medium'
    case 'HARD':   return 'diff-hard'
    default:       return 'diff-medium'
  }
})

const diffLabel = computed(() => {
  switch (challenge.value?.difficulty) {
    case 'EASY':   return 'Facile'
    case 'MEDIUM': return 'Moyen'
    case 'HARD':   return 'Difficile'
    default:       return challenge.value?.difficulty || ''
  }
})

const statusClass = computed(() => {
  switch (userChallenge.value?.status) {
    case 'COMPLETED': return 'status-completed'
    case 'STARTED':   return 'status-started'
    case 'FAILED':    return 'status-failed'
    default:          return ''
  }
})

const statusText = computed(() => {
  switch (userChallenge.value?.status) {
    case 'COMPLETED': return 'Defi complete !'
    case 'STARTED':   return 'En cours...'
    case 'FAILED':    return 'Echoue'
    default:          return ''
  }
})

async function fetchChallenge() {
  try {
    const response = await api.get('/challenges/today')
    challenge.value = response.data

    if (response.data.starterCode) {
      code.value = response.data.starterCode
    } else if (response.data.exerciseId) {
      try {
        const exRes = await api.get(`/exercises/${response.data.exerciseId}`)
        exercise.value = exRes.data
        code.value = exRes.data.starterCode || ''
      } catch (e) {
        code.value = ''
      }
    } else {
      code.value = ''
    }

    if (authStore.user?.id) {
      await fetchUserChallenge()
      if (!userChallenge.value || userChallenge.value.status !== 'COMPLETED') {
        await startChallenge()
        await fetchUserChallenge()
      }
    }
  } catch (error) {
    console.error('Pas de defi aujourd\'hui')
  } finally {
    loading.value = false
  }
}

async function startChallenge() {
  if (!authStore.user?.id || !challenge.value?.id) return
  try {
    await api.post(`/challenges/${challenge.value.id}/start/${authStore.user.id}`)
  } catch (error) {
    console.error('Erreur demarrage defi:', error)
  }
}

async function fetchUserChallenge() {
  if (!authStore.user?.id || !challenge.value?.id) return
  try {
    const response = await api.get(`/challenges/${challenge.value.id}/user/${authStore.user.id}`)
    userChallenge.value = response.data
  } catch (error) {
    // Pas encore de participation
  }
}

async function runCode() {
  executing.value = true
  output.value = ''
  resultMessage.value = ''
  try {
    const response = await api.post('/execute', { code: code.value })
    output.value = response.data.output
    outputSuccess.value = response.data.success
  } catch (error) {
    output.value = error.response?.data?.error || 'Erreur d\'execution'
    outputSuccess.value = false
  } finally {
    executing.value = false
  }
}

async function submitChallenge() {
  await runCode()
  if (!authStore.user?.id || !challenge.value?.id) return
  try {
    const response = await api.post(
      `/challenges/${challenge.value.id}/submit/${authStore.user.id}`,
      { code: code.value, success: outputSuccess.value }
    )
    resultMessage.value = response.data.message
    resultSuccess.value  = response.data.success

    if (response.data.completed) {
      xpToastAmount.value = response.data.xpEarned
      xpToast.value = true
      setTimeout(() => { xpToast.value = false }, 4000)
      try {
        const progress = await api.get(`/gamification/progress/${authStore.user.id}`)
        authStore.setProgress(progress.data.totalXp, progress.data.currentLevel)
      } catch (e) { /* ignore */ }
    }
    await fetchUserChallenge()
  } catch (error) {
    console.error('Erreur soumission:', error)
  }
}

onMounted(() => { fetchChallenge() })
</script>

<style scoped>
.challenge-page {
  max-width: 1000px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

/* Header */
.page-header { padding-bottom: 4px; }

.page-eyebrow {
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

/* States */
.state-center {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 24px;
  gap: 10px;
}

.loading-dot {
  width: 8px; height: 8px;
  border-radius: 50%;
  background: var(--c-accent);
  animation: pulse 1.2s ease infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.4; transform: scale(0.8); }
}

.state-label { font-size: 13px; color: var(--c-muted); }

.empty-glyph { font-size: 28px; color: var(--c-subtle); line-height: 1; }
.empty-title { font-size: 16px; font-weight: 600; color: var(--c-text); }
.empty-sub   { font-size: 13px; color: var(--c-muted); }

/* Grid */
.challenge-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}

/* Card */
.card {
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 16px;
  padding: 22px 24px;
  display: flex;
  flex-direction: column;
  gap: 14px;
}

/* Left card */
.card-top {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
}

.challenge-title {
  font-size: 16px;
  font-weight: 700;
  color: var(--c-text);
  letter-spacing: -0.01em;
  line-height: 1.3;
}

.challenge-date {
  font-size: 11px;
  color: var(--c-muted);
  margin-top: 3px;
}

.challenge-desc {
  font-size: 13px;
  color: var(--c-text-2);
  line-height: 1.65;
}

/* Difficulty badge */
.diff-badge {
  font-size: 10px;
  font-weight: 600;
  padding: 3px 8px;
  border-radius: 100px;
  border: 1px solid transparent;
  white-space: nowrap;
  flex-shrink: 0;
}
.diff-easy   { color: var(--c-green);  background: var(--c-green-soft);  border-color: rgba(34,197,94,0.2); }
.diff-medium { color: var(--c-amber);  background: var(--c-amber-soft);  border-color: rgba(245,158,11,0.2); }
.diff-hard   { color: var(--c-orange); background: rgba(249,115,22,0.08); border-color: rgba(249,115,22,0.2); }

/* Tags */
.tags-row { display: flex; gap: 6px; flex-wrap: wrap; }
.tag {
  font-size: 11px;
  font-weight: 600;
  padding: 3px 9px;
  border-radius: 100px;
  border: 1px solid transparent;
}
.tag-amber { color: var(--c-amber);  background: var(--c-amber-soft);  border-color: rgba(245,158,11,0.18); }
.tag-green { color: var(--c-green);  background: var(--c-green-soft);  border-color: rgba(34,197,94,0.18); }
.tag-blue  { color: var(--c-accent-light); background: var(--c-accent-soft); border-color: var(--c-accent-glow); }

/* Hint */
.hint-box {
  background: var(--c-accent-soft);
  border: 1px solid var(--c-accent-glow);
  border-radius: 10px;
  padding: 12px 14px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.hint-label { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; color: var(--c-accent-light); }
.hint-text  { font-size: 13px; color: var(--c-text-2); line-height: 1.5; }

/* Status */
.status-box {
  border-radius: 10px;
  padding: 12px 14px;
  border: 1px solid transparent;
  display: flex;
  flex-direction: column;
  gap: 3px;
}
.status-text { font-size: 13px; font-weight: 600; }
.status-meta { font-size: 11px; opacity: 0.75; }
.status-completed { background: rgba(34,197,94,0.08); border-color: rgba(34,197,94,0.2); color: var(--c-green); }
.status-started   { background: var(--c-accent-soft); border-color: var(--c-accent-glow); color: var(--c-accent-light); }
.status-failed    { background: rgba(239,68,68,0.08); border-color: rgba(239,68,68,0.2); color: #f87171; }

/* Right card — editor */
.editor-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.editor-label { font-size: 11px; font-weight: 600; color: var(--c-muted); text-transform: uppercase; letter-spacing: 0.08em; }
.editor-done  { font-size: 11px; font-weight: 600; color: var(--c-green); background: rgba(34,197,94,0.1); border: 1px solid rgba(34,197,94,0.2); padding: 2px 8px; border-radius: 100px; }

.code-editor {
  width: 100%;
  height: 260px;
  font-family: 'JetBrains Mono', 'Fira Code', monospace;
  font-size: 12.5px;
  line-height: 1.6;
  background: var(--c-surface-2);
  border: 1px solid var(--c-border);
  border-radius: 10px;
  color: var(--c-text);
  padding: 14px 16px;
  resize: none;
  outline: none;
  transition: border-color 0.2s;
}
.code-editor:focus { border-color: var(--c-border-md); }
.code-editor--done { opacity: 0.5; cursor: not-allowed; }

/* Buttons */
.btn-row { display: flex; gap: 8px; }
.btn {
  flex: 1;
  padding: 10px 16px;
  font-size: 13px;
  font-weight: 600;
  border-radius: 10px;
  border: none;
  cursor: pointer;
  transition: opacity 0.18s, transform 0.18s;
  letter-spacing: -0.01em;
}
.btn:disabled { opacity: 0.4; cursor: not-allowed; transform: none !important; }
.btn:not(:disabled):hover { transform: translateY(-1px); }

.btn-run    { background: var(--c-surface-2); color: var(--c-text); border: 1px solid var(--c-border-md); }
.btn-run:not(:disabled):hover { border-color: var(--c-border-strong); }
.btn-submit { background: var(--c-accent); color: #fff; }
.btn-submit:not(:disabled):hover { opacity: 0.88; }

/* Output */
.output-block {
  border-radius: 10px;
  padding: 12px 14px;
  border: 1px solid transparent;
}
.output-label {
  display: block;
  font-size: 10px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  margin-bottom: 6px;
}
.output-pre  { font-family: monospace; font-size: 12px; white-space: pre-wrap; word-break: break-all; margin: 0; }
.output-ok   { background: rgba(34,197,94,0.08); border-color: rgba(34,197,94,0.2); color: var(--c-green); }
.output-err  { background: rgba(239,68,68,0.08); border-color: rgba(239,68,68,0.2); color: #f87171; }

/* XP Toast */
.xp-toast {
  display: flex;
  align-items: center;
  gap: 8px;
  background: var(--c-amber-soft);
  border: 1px solid rgba(245,158,11,0.25);
  color: var(--c-amber);
  padding: 10px 14px;
  border-radius: 10px;
  font-size: 13px;
  font-weight: 600;
}
.xp-star { font-size: 14px; }

/* Result */
.result-msg {
  padding: 10px 14px;
  border-radius: 10px;
  font-size: 13px;
  font-weight: 500;
  border: 1px solid transparent;
}
.result-ok   { background: rgba(34,197,94,0.08); border-color: rgba(34,197,94,0.2); color: var(--c-green); }
.result-warn { background: var(--c-amber-soft);  border-color: rgba(245,158,11,0.2); color: var(--c-amber); }

/* Transitions */
.fade-enter-active, .fade-leave-active { transition: opacity 0.3s; }
.fade-enter-from, .fade-leave-to { opacity: 0; }

@media (max-width: 768px) {
  .challenge-grid { grid-template-columns: 1fr; }
}
</style>
