<template>
  <aside class="sidebar">
    <!-- Navigation -->
    <nav class="sidebar-nav">
      <router-link
        v-for="item in menuItems"
        :key="item.path"
        :to="item.path"
        class="sidebar-item"
        :class="{ 'is-active': isActive(item.path) }"
      >
        <span class="sidebar-icon" v-html="item.icon"></span>
        <span class="sidebar-label">{{ item.label }}</span>
      </router-link>
    </nav>

    <!-- Stats bento -->
    <div class="sidebar-stats">
      <!-- Streak -->
      <div class="sidebar-streak">
        <div class="streak-top">
          <span class="stat-eyebrow">Serie en cours</span>
          <span class="streak-fire">&#128293;</span>
        </div>
        <div class="streak-val">
          {{ streak }}<span class="streak-unit">j</span>
        </div>
      </div>

      <!-- XP + Level -->
      <div class="sidebar-xp">
        <div class="xp-top">
          <span class="stat-eyebrow">Experience</span>
          <span class="xp-lvl-badge">Niv.&nbsp;{{ authStore.level }}</span>
        </div>
        <div class="xp-val">{{ authStore.xp.toLocaleString() }}</div>
        <div class="xp-bar">
          <div class="xp-fill" :style="{ width: xpBarWidth + '%' }"></div>
        </div>
        <div class="xp-hint">{{ xpBarWidth }}% vers le niveau suivant</div>
      </div>
    </div>
  </aside>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import api from '@/services/api'

const authStore = useAuthStore()
const route     = useRoute()
const streak    = ref(0)

const menuItems = [
  {
    path:  '/dashboard',
    label: 'Dashboard',
    icon:  `<svg width="15" height="15" fill="none" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1.5" stroke="currentColor" stroke-width="1.6"/><rect x="14" y="3" width="7" height="7" rx="1.5" stroke="currentColor" stroke-width="1.6"/><rect x="3" y="14" width="7" height="7" rx="1.5" stroke="currentColor" stroke-width="1.6"/><rect x="14" y="14" width="7" height="7" rx="1.5" stroke="currentColor" stroke-width="1.6"/></svg>`,
  },
  {
    path:  '/courses',
    label: 'Cours',
    icon:  `<svg width="15" height="15" fill="none" viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 016.5 17H20" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 014 19.5v-15A2.5 2.5 0 016.5 2z" stroke="currentColor" stroke-width="1.6"/></svg>`,
  },
  {
    path:  '/challenge',
    label: 'Defi du jour',
    icon:  `<svg width="15" height="15" fill="none" viewBox="0 0 24 24"><path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z" stroke="currentColor" stroke-width="1.6" stroke-linejoin="round"/></svg>`,
  },
  {
    path:  '/quizzes',
    label: 'Quiz',
    icon:  `<svg width="15" height="15" fill="none" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="1.6"/><path d="M12 8v4M12 16h.01" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/></svg>`,
  },
  {
    path:  '/profile',
    label: 'Profil',
    icon:  `<svg width="15" height="15" fill="none" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4" stroke="currentColor" stroke-width="1.6"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/></svg>`,
  },
]

const XP_PER_LEVEL = 500

const xpBarWidth = computed(() => {
  const xpInLevel = authStore.xp % XP_PER_LEVEL
  return Math.min(100, Math.round((xpInLevel / XP_PER_LEVEL) * 100))
})

function isActive(path) {
  return route.path === path || route.path.startsWith(path + '/')
}

async function fetchStreak() {
  if (!authStore.isAuthenticated || !authStore.user?.id) return
  try {
    const response = await api.get(`/gamification/progress/${authStore.user.id}`)
    streak.value = response.data.currentStreak
  } catch (error) {
    console.error('Erreur chargement streak:', error)
  }
}

onMounted(() => { fetchStreak() })
</script>

<style scoped>
.sidebar {
  width: 210px;
  flex-shrink: 0;
  background: var(--c-surface);
  border-right: 1px solid var(--c-border);
  min-height: calc(100vh - 56px);
  display: flex;
  flex-direction: column;
  padding: 14px 10px 20px;
  gap: 0;
}

/* Navigation */
.sidebar-nav {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 1px;
}

.sidebar-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 11px;
  border-radius: 9px;
  font-size: 13.5px;
  font-weight: 500;
  color: var(--c-muted);
  transition: color var(--t), background var(--t);
  position: relative;
  text-decoration: none;
}

.sidebar-item:hover {
  color: var(--c-text);
  background: var(--c-surface-2);
}

.sidebar-item.is-active {
  color: var(--c-text);
  background: var(--c-surface-2);
}

.sidebar-item.is-active::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 2.5px;
  height: 16px;
  background: var(--c-accent);
  border-radius: 0 2px 2px 0;
}

.sidebar-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  opacity: 0.65;
  transition: opacity var(--t);
}

.sidebar-item:hover .sidebar-icon,
.sidebar-item.is-active .sidebar-icon {
  opacity: 1;
}

.sidebar-label {
  line-height: 1;
}

/* Stats */
.sidebar-stats {
  margin-top: 14px;
  padding-top: 14px;
  border-top: 1px solid var(--c-border);
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.stat-eyebrow {
  font-size: 10px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--c-subtle);
}

/* Streak card */
.sidebar-streak {
  background: linear-gradient(135deg, #1a0c07 0%, #1f1108 100%);
  border: 1px solid rgba(249, 115, 22, 0.14);
  border-radius: 12px;
  padding: 13px 14px 11px;
}

.streak-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 6px;
}

.streak-fire {
  font-size: 15px;
  line-height: 1;
}

.streak-val {
  font-size: 26px;
  font-weight: 800;
  color: var(--c-orange);
  line-height: 1;
  letter-spacing: -0.03em;
}

.streak-unit {
  font-size: 13px;
  font-weight: 500;
  color: rgba(249, 115, 22, 0.55);
  margin-left: 2px;
}

/* XP card */
.sidebar-xp {
  background: var(--c-surface-2);
  border: 1px solid var(--c-border);
  border-radius: 12px;
  padding: 13px 14px 11px;
}

.xp-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 6px;
}

.xp-lvl-badge {
  font-size: 11px;
  font-weight: 700;
  color: var(--c-accent-light);
  background: var(--c-accent-soft);
  padding: 2px 7px;
  border-radius: 100px;
}

.xp-val {
  font-size: 20px;
  font-weight: 800;
  color: var(--c-text);
  letter-spacing: -0.02em;
  line-height: 1;
  margin-bottom: 10px;
}

.xp-bar {
  height: 3px;
  background: var(--c-border);
  border-radius: 2px;
  overflow: hidden;
  margin-bottom: 6px;
}

.xp-fill {
  height: 100%;
  background: var(--c-accent);
  border-radius: 2px;
  transition: width 0.6s ease;
}

.xp-hint {
  font-size: 10px;
  color: var(--c-subtle);
}
</style>
