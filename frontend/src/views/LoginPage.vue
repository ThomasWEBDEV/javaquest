<template>
  <div class="auth-page">
    <!-- ── Panneau gauche : branding ── -->
    <div class="auth-left">
      <div class="auth-left-inner">
        <router-link to="/" class="auth-logo">
          <span class="auth-logo-mark">JQ</span>
          <span class="auth-logo-name">JavaQuest</span>
        </router-link>

        <div class="auth-brand">
          <h2 class="auth-brand-title">
            La pratique cree<br><em>l'expertise.</em>
          </h2>
          <p class="auth-brand-sub">
            Rejoignez des milliers d'apprenants qui progressent chaque jour avec des exercices Java concrets.
          </p>
        </div>

        <div class="auth-code-preview">
          <div class="auth-code-bar">
            <div class="auth-code-dots">
              <span class="dot-r"></span>
              <span class="dot-y"></span>
              <span class="dot-g"></span>
            </div>
            <span>Developer.java</span>
          </div>
          <pre class="auth-code-body"><span class="ak">public class</span> <span class="ac">Developer</span> {
  <span class="ak">private int</span> level = <span class="an">1</span>;

  <span class="ak">public void</span> <span class="af">practice</span>() {
    <span class="ak">this</span>.level++;
    System.out.<span class="af">println</span>(
      <span class="as">"Level "</span> + level + <span class="as">" unlocked!"</span>
    );
  }
}</pre>
        </div>

        <div class="auth-pills">
          <div class="auth-pill">
            <span class="pill-dot"></span>
            Sandbox Java temps reel
          </div>
          <div class="auth-pill auth-pill-amber">
            <svg width="12" height="12" fill="none" viewBox="0 0 24 24">
              <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
            </svg>
            100+ exercices
          </div>
        </div>
      </div>
    </div>

    <!-- ── Panneau droit : formulaire ── -->
    <div class="auth-right">
      <div class="auth-form-wrap">
        <div class="auth-form-header">
          <h1>Connexion</h1>
          <p>Bienvenue ! Continuez votre quete.</p>
        </div>

        <form @submit.prevent="handleLogin" class="auth-form">
          <div v-if="error" class="auth-error">
            <svg width="14" height="14" fill="none" viewBox="0 0 24 24">
              <circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="1.7"/>
              <path d="M12 8v4M12 16h.01" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>
            </svg>
            {{ error }}
          </div>

          <div class="auth-field">
            <label for="username">Nom d'utilisateur</label>
            <input
              id="username"
              v-model="form.username"
              type="text"
              required
              autocomplete="username"
              placeholder="votre_pseudo"
            />
          </div>

          <div class="auth-field">
            <label for="password">Mot de passe</label>
            <input
              id="password"
              v-model="form.password"
              type="password"
              required
              autocomplete="current-password"
              placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;"
            />
          </div>

          <button type="submit" :disabled="loading" class="auth-submit">
            <span v-if="loading" class="auth-spinner"></span>
            {{ loading ? 'Connexion...' : 'Se connecter' }}
          </button>
        </form>

        <p class="auth-switch">
          Pas encore de compte ?
          <router-link to="/register">S'inscrire gratuitement &rarr;</router-link>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router    = useRouter()
const route     = useRoute()
const authStore = useAuthStore()

const form = reactive({ username: '', password: '' })
const loading = ref(false)
const error   = ref('')

async function handleLogin() {
  loading.value = true
  error.value   = ''
  const result  = await authStore.login(form.username, form.password)
  if (result.success) {
    router.push(route.query.redirect || '/dashboard')
  } else {
    error.value = result.error
  }
  loading.value = false
}
</script>

<style scoped>
.auth-page {
  min-height: 100vh;
  display: flex;
  background: var(--c-base);
}

/* ── Left panel ── */
.auth-left {
  width: 52%;
  background: var(--c-surface);
  border-right: 1px solid var(--c-border);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 48px;
  position: relative;
  overflow: hidden;
}

.auth-left::before {
  content: '';
  position: absolute;
  top: -200px;
  left: -150px;
  width: 500px;
  height: 500px;
  background: radial-gradient(circle, rgba(99, 102, 241, 0.1) 0%, transparent 65%);
  pointer-events: none;
}

.auth-left-inner {
  max-width: 420px;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 0;
}

.auth-logo {
  display: inline-flex;
  align-items: center;
  gap: 9px;
  margin-bottom: 48px;
}

.auth-logo-mark {
  width: 30px;
  height: 30px;
  background: var(--c-accent);
  border-radius: 7px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 11px;
  font-weight: 700;
  color: white;
}

.auth-logo-name {
  font-size: 16px;
  font-weight: 600;
  letter-spacing: -0.02em;
  color: var(--c-text);
}

.auth-brand {
  margin-bottom: 36px;
}

.auth-brand-title {
  font-family: var(--font-serif);
  font-size: clamp(28px, 3.5vw, 42px);
  font-weight: 700;
  line-height: 1.08;
  letter-spacing: -0.025em;
  color: var(--c-text);
  margin-bottom: 14px;
}

.auth-brand-title em {
  font-style: italic;
  color: var(--c-accent-light);
}

.auth-brand-sub {
  font-size: 14px;
  color: var(--c-muted);
  line-height: 1.7;
}

/* Code preview */
.auth-code-preview {
  background: var(--c-surface-2);
  border: 1px solid var(--c-border-md);
  border-radius: 12px;
  overflow: hidden;
  margin-bottom: 20px;
}

.auth-code-bar {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 9px 14px;
  border-bottom: 1px solid var(--c-border);
  font-size: 11px;
  color: var(--c-muted);
  font-weight: 500;
}

.auth-code-dots {
  display: flex;
  gap: 5px;
}

.auth-code-dots span {
  width: 9px;
  height: 9px;
  border-radius: 50%;
}

.dot-r { background: #ff5f57; }
.dot-y { background: #ffbd2e; }
.dot-g { background: #28c840; }

.auth-code-body {
  padding: 16px;
  font-family: var(--font-mono);
  font-size: 12px;
  line-height: 1.75;
  color: var(--c-text-2);
  margin: 0;
  overflow: hidden;
}

.ak { color: #c792ea; }
.ac { color: #82aaff; }
.af { color: #89ddff; }
.as { color: #c3e88d; }
.an { color: #f78c6c; }

/* Pills */
.auth-pills {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.auth-pill {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 5px 12px;
  background: var(--c-surface-2);
  border: 1px solid var(--c-border);
  border-radius: 100px;
  font-size: 12px;
  font-weight: 500;
  color: var(--c-muted);
}

.auth-pill-amber {
  color: var(--c-amber);
  background: var(--c-amber-soft);
  border-color: rgba(245, 158, 11, 0.2);
}

.pill-dot {
  width: 6px;
  height: 6px;
  background: var(--c-green);
  border-radius: 50%;
  animation: blink 2s ease infinite;
}

@keyframes blink {
  0%, 100% { opacity: 1; }
  50%       { opacity: 0.35; }
}

/* ── Right panel ── */
.auth-right {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 48px 40px;
}

.auth-form-wrap {
  max-width: 360px;
  width: 100%;
}

.auth-form-header {
  margin-bottom: 32px;
}

.auth-form-header h1 {
  font-size: 24px;
  font-weight: 700;
  letter-spacing: -0.02em;
  color: var(--c-text);
  margin-bottom: 6px;
}

.auth-form-header p {
  font-size: 14px;
  color: var(--c-muted);
}

.auth-error {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 14px;
  background: var(--c-red-soft);
  border: 1px solid rgba(239, 68, 68, 0.2);
  border-radius: 9px;
  font-size: 13px;
  color: #fca5a5;
  margin-bottom: 20px;
}

.auth-form {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.auth-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.auth-field label {
  font-size: 13px;
  font-weight: 500;
  color: var(--c-text-2);
}

.auth-field input {
  width: 100%;
  padding: 10px 14px;
  background: var(--c-surface);
  border: 1px solid var(--c-border-md);
  border-radius: 9px;
  color: var(--c-text);
  font-size: 14px;
  transition: border-color var(--t), box-shadow var(--t);
  outline: none;
}

.auth-field input::placeholder {
  color: var(--c-subtle);
}

.auth-field input:focus {
  border-color: var(--c-accent);
  box-shadow: 0 0 0 3px var(--c-accent-soft);
}

.auth-submit {
  width: 100%;
  padding: 11px;
  background: var(--c-accent);
  color: white;
  border: none;
  border-radius: 9px;
  font-size: 14px;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  margin-top: 4px;
  transition: background var(--t), transform var(--t), box-shadow var(--t);
}

.auth-submit:hover:not(:disabled) {
  background: var(--c-accent-light);
  transform: translateY(-1px);
  box-shadow: 0 6px 20px var(--c-accent-glow);
}

.auth-submit:disabled {
  opacity: 0.55;
  cursor: not-allowed;
}

.auth-spinner {
  width: 14px;
  height: 14px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.auth-switch {
  margin-top: 24px;
  text-align: center;
  font-size: 13.5px;
  color: var(--c-muted);
}

.auth-switch a {
  color: var(--c-accent-light);
  font-weight: 500;
  transition: color var(--t);
}

.auth-switch a:hover {
  color: var(--c-text);
}

/* Responsive */
@media (max-width: 768px) {
  .auth-left {
    display: none;
  }

  .auth-right {
    padding: 40px 24px;
  }
}
</style>
