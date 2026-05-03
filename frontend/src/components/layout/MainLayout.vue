<template>
  <div class="main-layout">
    <AppHeader />
    <div class="main-layout-body">
      <AppSidebar v-if="authStore.isAuthenticated" />
      <main class="main-content">
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup>
import AppHeader from './AppHeader.vue'
import AppSidebar from './AppSidebar.vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()
</script>

<style scoped>
.main-layout {
  min-height: 100vh;
  background: var(--c-base);
  display: flex;
  flex-direction: column;
}

.main-layout-body {
  display: flex;
  flex: 1;
  min-height: 0;
}

.main-content {
  flex: 1;
  padding: 32px;
  min-width: 0;
  overflow-y: auto;
}
</style>
