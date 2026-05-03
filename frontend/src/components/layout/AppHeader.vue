<template>
  <header class="app-header">
    <div class="app-header-inner">
      <!-- Logo -->
      <router-link to="/" class="app-logo">
        <span class="app-logo-mark">JQ</span>
        <span class="app-logo-name">JavaQuest</span>
      </router-link>

      <!-- Nav center -->
      <nav class="app-nav" v-if="authStore.isAuthenticated">
        <router-link
          v-for="item in navItems"
          :key="item.path"
          :to="item.path"
          class="app-nav-link"
          :class="{ 'is-active': isActive(item.path) }"
        >
          {{ item.label }}
        </router-link>
      </nav>

      <!-- Right zone -->
      <div class="app-header-right">
        <template v-if="authStore.isAuthenticated">
          <div class="app-xp-pill">
            <span class="xp-val">{{ authStore.xp.toLocaleString() }}</span>
            <span class="xp-unit">XP</span>
            <span class="xp-sep"></span>
            <span class="xp-lvl">Niv.&nbsp;{{ authStore.level }}</span>
          </div>

          <router-link
            to="/profile"
            class="app-avatar"
            :title="authStore.user?.username"
          >
            {{ authStore.user?.username?.charAt(0).toUpperCase() || '?' }}
          </router-link>

          <button class="app-logout" @click="logout" title="Deconnexion">
            <svg width="15" height="15" fill="none" viewBox="0 0 24 24">
              <path d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h6a2 2 0 012 2v1" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </button>
        </template>

        <template v-else>
          <router-link to="/login" class="app-nav-link">Connexion</router-link>
          <router-link to="/register" class="app-header-cta">S'inscrire</router-link>
        </template>
      </div>
    </div>
  </header>
</template>

<script setup>
import { watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import api from '@/services/api'

const router = useRouter()
const route  = useRoute()
const authStore = useAuthStore()

const navItems = [
  { path: '/courses',   label: 'Cours' },
  { path: '/quizzes',   label: 'Quiz' },
  { path: '/challenge', label: 'Defi du jour' },
  { path: '/dashboard', label: 'Dashboard' },
]

function isActive(path) {
  return route.path === path || route.path.startsWith(path + '/')
}

async function fetchProgress() {
  if (!authStore.isAuthenticated || !authStore.user?.id) return
  try {
    const response = await api.get(`/gamification/progress/${authStore.user.id}`)
    authStore.setProgress(response.data.totalXp, response.data.currentLevel)
  } catch (error) {
    console.error('Erreur chargement progression:', error)
  }
}

function logout() {
  authStore.logout()
  router.push('/login')
}

watch(() => authStore.user?.id, (userId) => {
  if (userId) fetchProgress()
}, { immediate: true })
</script>

<style scoped>
.app-header {
  position: sticky;
  top: 0;
  z-index: 50;
  background: rgba(9, 9, 11, 0.82);
  border-bottom: 1px solid var(--c-border);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
}

.app-header-inner {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 1.5rem;
  height: 56px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

/* Logo */
.app-logo {
  display: flex;
  align-items: center;
  gap: 9px;
  flex-shrink: 0;
}

.app-logo-mark {
  width: 28px;
  height: 28px;
  background: var(--c-accent);
  border-radius: 7px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 11px;
  font-weight: 700;
  color: white;
  letter-spacing: -0.01em;
  flex-shrink: 0;
}

.app-logo-name {
  font-size: 15px;
  font-weight: 600;
  letter-spacing: -0.02em;
  color: var(--c-text);
}

/* Nav */
.app-nav {
  display: flex;
  align-items: center;
  gap: 2px;
}

.app-nav-link {
  padding: 5px 11px;
  font-size: 13px;
  font-weight: 500;
  color: var(--c-muted);
  border-radius: 7px;
  transition: color var(--t), background var(--t);
  white-space: nowrap;
}

.app-nav-link:hover {
  color: var(--c-text);
  background: var(--c-surface);
}

.app-nav-link.is-active {
  color: var(--c-text);
  background: var(--c-surface-2);
}

/* Right zone */
.app-header-right {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-shrink: 0;
}

.app-xp-pill {
  display: flex;
  align-items: center;
  gap: 5px;
  background: var(--c-surface);
  border: 1px solid var(--c-border-md);
  border-radius: 8px;
  padding: 4px 10px;
}

.xp-val {
  font-size: 13px;
  font-weight: 700;
  color: var(--c-amber);
}

.xp-unit {
  font-size: 10px;
  font-weight: 600;
  color: var(--c-subtle);
  letter-spacing: 0.05em;
}

.xp-sep {
  width: 1px;
  height: 11px;
  background: var(--c-border-md);
}

.xp-lvl {
  font-size: 12px;
  font-weight: 600;
  color: var(--c-accent-light);
}

.app-avatar {
  width: 30px;
  height: 30px;
  background: linear-gradient(135deg, var(--c-accent) 0%, #818cf8 100%);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 700;
  color: white;
  transition: opacity var(--t), transform var(--t);
}

.app-avatar:hover {
  opacity: 0.85;
  transform: scale(1.05);
}

.app-logout {
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--c-subtle);
  border-radius: 7px;
  background: transparent;
  border: none;
  transition: color var(--t), background var(--t);
}

.app-logout:hover {
  color: var(--c-text-2);
  background: var(--c-surface);
}

.app-header-cta {
  padding: 6px 14px;
  background: var(--c-accent);
  color: white;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 600;
  transition: background var(--t);
}

.app-header-cta:hover {
  background: var(--c-accent-light);
}
</style>
