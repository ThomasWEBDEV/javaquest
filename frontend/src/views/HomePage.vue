<template>
  <div class="hp">
    <div class="hp-glow-1"></div>
    <div class="hp-glow-2"></div>

    <!-- ── HEADER ── -->
    <header class="hp-header">
      <div class="hp-header-inner">
        <router-link to="/" class="hp-logo">
          <span class="hp-logo-mark">JQ</span>
          <span class="hp-logo-name">JavaQuest</span>
        </router-link>
        <nav class="hp-nav">
          <router-link to="/courses" class="hp-nav-link">Cours</router-link>
          <router-link to="/login" class="hp-nav-link">Connexion</router-link>
          <router-link to="/register" class="hp-nav-cta">Commencer &rarr;</router-link>
        </nav>
      </div>
    </header>

    <!-- ── HERO ── -->
    <section class="hp-hero">
      <div class="hp-hero-left">
        <div class="hp-badge">
          <span class="hp-badge-dot"></span>
          Plateforme interactive Java
        </div>

        <h1 class="hp-h1">
          Maitrisez<br>
          <em>Java</em><br>
          par la pratique.
        </h1>

        <p class="hp-lead">
          JavaQuest transforme l'apprentissage en aventure.<br>
          Exercices en temps reel, defis quotidiens, progression gamifiee.
        </p>

        <div class="hp-actions">
          <router-link to="/register" class="hp-btn-primary">
            Commencer gratuitement
            <svg width="14" height="14" fill="none" viewBox="0 0 14 14">
              <path d="M2 7h10M8 3l4 4-4 4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </router-link>
          <router-link to="/courses" class="hp-btn-ghost">
            Voir le curriculum
          </router-link>
        </div>

        <div class="hp-stats">
          <div class="hp-stat"><strong>15</strong><span>chapitres</span></div>
          <div class="hp-stat-div"></div>
          <div class="hp-stat"><strong>100+</strong><span>exercices</span></div>
          <div class="hp-stat-div"></div>
          <div class="hp-stat"><strong>365</strong><span>defis</span></div>
          <div class="hp-stat-div"></div>
          <div class="hp-stat"><strong>50+</strong><span>quiz</span></div>
        </div>
      </div>

      <div class="hp-hero-right">
        <div class="hp-code-card">
          <div class="hp-code-bar">
            <div class="hp-code-dots">
              <span class="dot-r"></span>
              <span class="dot-y"></span>
              <span class="dot-g"></span>
            </div>
            <span class="hp-code-filename">Main.java</span>
          </div>
          <pre class="hp-code-body"><span class="s-kw">public class</span> <span class="s-cls">Main</span> {
  <span class="s-kw">public static void</span> <span class="s-fn">main</span>(String[] args) {

    List&lt;String&gt; skills = <span class="s-kw">new</span> ArrayList&lt;&gt;();
    skills.<span class="s-fn">add</span>(<span class="s-str">"Java Basics"</span>);
    skills.<span class="s-fn">add</span>(<span class="s-str">"Collections"</span>);
    skills.<span class="s-fn">add</span>(<span class="s-str">"Design Patterns"</span>);

    skills.<span class="s-fn">stream</span>()
      .<span class="s-fn">filter</span>(s -&gt; s.length() &gt; <span class="s-num">8</span>)
      .<span class="s-fn">forEach</span>(System.out::println);
  }
}</pre>
          <div class="hp-code-footer">
            <span class="hp-xp-pill">+ 40 XP</span>
            <span class="hp-tests-ok">&#10003; 3 tests passes</span>
          </div>
        </div>

        <div class="hp-float hp-float-streak">
          <span class="hp-streak-icon">&#128293;</span>
          <div>
            <strong>7 jours</strong>
            <small>Serie active</small>
          </div>
        </div>

        <div class="hp-float hp-float-xp">
          <strong>+ 120 XP</strong>
          <small>Niveau 4 atteint</small>
        </div>
      </div>
    </section>

    <!-- ── FEATURES ── -->
    <section class="hp-features">
      <p class="hp-eyebrow">Fonctionnalites</p>
      <div class="hp-bento">
        <div class="hp-card hp-card-large">
          <div class="hp-card-icon">
            <svg width="20" height="20" fill="none" viewBox="0 0 24 24">
              <rect x="3" y="3" width="18" height="18" rx="3" stroke="currentColor" stroke-width="1.5"/>
              <path d="M8 9l3 3-3 3M13 15h3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <h3>Editeur de code integre</h3>
          <p>Ecrivez et executez du Java directement dans le navigateur. Sandbox JShell avec retour instantane.</p>
          <div class="hp-code-lines">
            <div class="hp-cl" style="width:72%"></div>
            <div class="hp-cl" style="width:88%"></div>
            <div class="hp-cl hp-cl-accent" style="width:55%"></div>
            <div class="hp-cl" style="width:80%"></div>
            <div class="hp-cl" style="width:63%"></div>
          </div>
        </div>

        <div class="hp-card">
          <div class="hp-card-icon hp-icon-amber">
            <svg width="20" height="20" fill="none" viewBox="0 0 24 24">
              <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/>
            </svg>
          </div>
          <h3>Gamification complete</h3>
          <p>XP, niveaux, badges et series — chaque action compte dans votre progression.</p>
        </div>

        <div class="hp-card">
          <div class="hp-card-icon hp-icon-green">
            <svg width="20" height="20" fill="none" viewBox="0 0 24 24">
              <circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="1.5"/>
              <path d="M12 7v5l3 3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
          </div>
          <h3>Defis quotidiens</h3>
          <p>Un nouveau defi chaque jour pour maintenir votre dynamique et votre serie.</p>
        </div>

        <div class="hp-card hp-card-wide">
          <div class="hp-card-icon">
            <svg width="20" height="20" fill="none" viewBox="0 0 24 24">
              <path d="M9 12h6M9 16h4M7 4H5a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2V8l-5-4H7z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <h3>Quiz adaptatifs chronometres</h3>
          <p>Testez vos connaissances apres chaque lecon avec des quiz detailles et 100 XP a la cle.</p>
        </div>
      </div>
    </section>

    <!-- ── CTA FINAL ── -->
    <section class="hp-final-cta">
      <div class="hp-cta-box">
        <p class="hp-cta-eyebrow">Rejoignez la communaute</p>
        <h2 class="hp-cta-h2">
          Pret a commencer<br>votre quete ?
        </h2>
        <router-link to="/register" class="hp-btn-primary hp-btn-lg">
          Creer un compte gratuit &rarr;
        </router-link>
      </div>
    </section>
  </div>
</template>

<script setup>
</script>

<style scoped>
.hp {
  min-height: 100vh;
  background: var(--c-base);
  overflow: hidden;
  position: relative;
}

/* Ambient glows */
.hp-glow-1 {
  position: absolute;
  top: -200px;
  left: -150px;
  width: 700px;
  height: 700px;
  background: radial-gradient(circle, rgba(99, 102, 241, 0.1) 0%, transparent 65%);
  pointer-events: none;
  z-index: 0;
}

.hp-glow-2 {
  position: absolute;
  top: 300px;
  right: -200px;
  width: 600px;
  height: 600px;
  background: radial-gradient(circle, rgba(245, 158, 11, 0.07) 0%, transparent 65%);
  pointer-events: none;
  z-index: 0;
}

/* ── Header ── */
.hp-header {
  position: relative;
  z-index: 10;
  border-bottom: 1px solid var(--c-border);
}

.hp-header-inner {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.hp-logo {
  display: flex;
  align-items: center;
  gap: 10px;
}

.hp-logo-mark {
  width: 32px;
  height: 32px;
  background: var(--c-accent);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 700;
  color: white;
  letter-spacing: -0.01em;
  flex-shrink: 0;
}

.hp-logo-name {
  font-size: 16px;
  font-weight: 600;
  letter-spacing: -0.02em;
  color: var(--c-text);
}

.hp-nav {
  display: flex;
  align-items: center;
  gap: 4px;
}

.hp-nav-link {
  padding: 6px 12px;
  font-size: 14px;
  font-weight: 500;
  color: var(--c-muted);
  border-radius: 8px;
  transition: color var(--t), background var(--t);
}

.hp-nav-link:hover {
  color: var(--c-text);
  background: var(--c-surface);
}

.hp-nav-cta {
  padding: 7px 16px;
  background: var(--c-accent);
  color: white;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  transition: background var(--t), transform var(--t);
}

.hp-nav-cta:hover {
  background: var(--c-accent-light);
  transform: translateY(-1px);
}

/* ── Hero ── */
.hp-hero {
  position: relative;
  z-index: 1;
  max-width: 1200px;
  margin: 0 auto;
  padding: 96px 2rem 80px;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 64px;
  align-items: center;
}

.hp-badge {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 5px 14px;
  background: var(--c-surface);
  border: 1px solid var(--c-border-md);
  border-radius: 100px;
  font-size: 12px;
  font-weight: 500;
  color: var(--c-muted);
  margin-bottom: 28px;
}

.hp-badge-dot {
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

.hp-h1 {
  font-family: var(--font-serif);
  font-size: clamp(48px, 5.5vw, 76px);
  font-weight: 700;
  line-height: 1.02;
  letter-spacing: -0.03em;
  color: var(--c-text);
  margin-bottom: 24px;
}

.hp-h1 em {
  font-style: italic;
  color: var(--c-accent-light);
}

.hp-lead {
  font-size: 16px;
  color: var(--c-text-2);
  line-height: 1.75;
  margin-bottom: 36px;
  max-width: 420px;
}

.hp-actions {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 40px;
  flex-wrap: wrap;
}

.hp-btn-primary {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 11px 22px;
  background: var(--c-accent);
  color: white;
  border-radius: 10px;
  font-size: 14px;
  font-weight: 600;
  transition: background var(--t), transform var(--t), box-shadow var(--t);
}

.hp-btn-primary:hover {
  background: var(--c-accent-light);
  transform: translateY(-1px);
  box-shadow: 0 8px 28px var(--c-accent-glow);
}

.hp-btn-ghost {
  display: inline-flex;
  align-items: center;
  padding: 11px 22px;
  border: 1px solid var(--c-border-md);
  color: var(--c-text-2);
  border-radius: 10px;
  font-size: 14px;
  font-weight: 500;
  transition: border-color var(--t), color var(--t), background var(--t);
}

.hp-btn-ghost:hover {
  border-color: var(--c-border-strong);
  color: var(--c-text);
  background: var(--c-surface);
}

.hp-stats {
  display: flex;
  align-items: center;
  gap: 20px;
  flex-wrap: wrap;
}

.hp-stat {
  display: flex;
  flex-direction: column;
}

.hp-stat strong {
  font-size: 20px;
  font-weight: 700;
  color: var(--c-text);
  line-height: 1.2;
  letter-spacing: -0.02em;
}

.hp-stat span {
  font-size: 11px;
  color: var(--c-muted);
  margin-top: 2px;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  font-weight: 500;
}

.hp-stat-div {
  width: 1px;
  height: 30px;
  background: var(--c-border);
  flex-shrink: 0;
}

/* Hero right */
.hp-hero-right {
  position: relative;
}

.hp-code-card {
  background: var(--c-surface);
  border: 1px solid var(--c-border-md);
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 24px 64px rgba(0, 0, 0, 0.55);
}

.hp-code-bar {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 11px 16px;
  border-bottom: 1px solid var(--c-border);
  background: var(--c-surface-2);
}

.hp-code-dots {
  display: flex;
  gap: 6px;
}

.hp-code-dots span {
  width: 10px;
  height: 10px;
  border-radius: 50%;
}

.dot-r { background: #ff5f57; }
.dot-y { background: #ffbd2e; }
.dot-g { background: #28c840; }

.hp-code-filename {
  font-size: 12px;
  color: var(--c-muted);
  font-weight: 500;
  margin: 0 auto;
}

.hp-code-body {
  padding: 20px;
  font-family: var(--font-mono);
  font-size: 12.5px;
  line-height: 1.8;
  color: var(--c-text-2);
  overflow-x: auto;
  margin: 0;
}

.s-kw  { color: #c792ea; }
.s-cls { color: #82aaff; }
.s-fn  { color: #89ddff; }
.s-str { color: #c3e88d; }
.s-num { color: #f78c6c; }

.hp-code-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 11px 20px;
  border-top: 1px solid var(--c-border);
  background: var(--c-surface-2);
}

.hp-xp-pill {
  font-size: 12px;
  font-weight: 700;
  color: var(--c-amber);
  background: var(--c-amber-soft);
  padding: 3px 10px;
  border-radius: 100px;
  border: 1px solid rgba(245, 158, 11, 0.2);
}

.hp-tests-ok {
  font-size: 12px;
  color: var(--c-green);
  font-weight: 500;
}

/* Floating cards */
.hp-float {
  position: absolute;
  background: rgba(28, 28, 31, 0.9);
  border: 1px solid var(--c-border-md);
  border-radius: 12px;
  padding: 12px 16px;
  box-shadow: 0 8px 28px rgba(0, 0, 0, 0.45);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
}

.hp-float-streak {
  bottom: -22px;
  left: -28px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.hp-streak-icon {
  font-size: 20px;
}

.hp-float-streak strong {
  display: block;
  font-size: 14px;
  font-weight: 700;
  color: var(--c-text);
  line-height: 1.2;
}

.hp-float-streak small {
  font-size: 11px;
  color: var(--c-muted);
}

.hp-float-xp {
  top: -18px;
  right: -18px;
  text-align: center;
}

.hp-float-xp strong {
  display: block;
  font-size: 15px;
  font-weight: 700;
  color: var(--c-amber);
  line-height: 1.2;
}

.hp-float-xp small {
  font-size: 11px;
  color: var(--c-muted);
}

/* ── Features ── */
.hp-features {
  position: relative;
  z-index: 1;
  max-width: 1200px;
  margin: 0 auto;
  padding: 80px 2rem 60px;
}

.hp-eyebrow {
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--c-muted);
  margin-bottom: 20px;
}

.hp-bento {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
}

.hp-card {
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 16px;
  padding: 28px;
  transition: border-color var(--t), background var(--t);
}

.hp-card:hover {
  border-color: var(--c-border-md);
  background: var(--c-surface-hover);
}

.hp-card-large { grid-column: span 2; }
.hp-card-wide  { grid-column: span 2; }

.hp-card h3 {
  font-size: 15px;
  font-weight: 600;
  color: var(--c-text);
  margin: 16px 0 8px;
  letter-spacing: -0.01em;
}

.hp-card p {
  font-size: 13.5px;
  color: var(--c-muted);
  line-height: 1.65;
}

.hp-card-icon {
  width: 38px;
  height: 38px;
  background: var(--c-accent-soft);
  border: 1px solid rgba(99, 102, 241, 0.15);
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--c-accent-light);
}

.hp-icon-amber {
  background: var(--c-amber-soft);
  border-color: rgba(245, 158, 11, 0.15);
  color: var(--c-amber);
}

.hp-icon-green {
  background: var(--c-green-soft);
  border-color: rgba(34, 197, 94, 0.15);
  color: var(--c-green);
}

.hp-code-lines {
  margin-top: 22px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.hp-cl {
  height: 7px;
  background: var(--c-surface-2);
  border-radius: 4px;
}

.hp-cl-accent {
  background: var(--c-accent-soft);
  border: 1px solid rgba(99, 102, 241, 0.18);
}

/* ── Final CTA ── */
.hp-final-cta {
  position: relative;
  z-index: 1;
  padding: 40px 2rem 100px;
}

.hp-cta-box {
  max-width: 1200px;
  margin: 0 auto;
  background: var(--c-surface);
  border: 1px solid var(--c-border-md);
  border-radius: 24px;
  padding: 72px 40px;
  text-align: center;
  position: relative;
  overflow: hidden;
}

.hp-cta-box::before {
  content: '';
  position: absolute;
  top: -100px;
  left: 50%;
  transform: translateX(-50%);
  width: 400px;
  height: 400px;
  background: radial-gradient(circle, var(--c-accent-glow) 0%, transparent 65%);
  pointer-events: none;
}

.hp-cta-eyebrow {
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.12em;
  color: var(--c-accent-light);
  margin-bottom: 16px;
}

.hp-cta-h2 {
  font-family: var(--font-serif);
  font-size: clamp(30px, 4vw, 50px);
  font-weight: 700;
  line-height: 1.1;
  letter-spacing: -0.025em;
  color: var(--c-text);
  margin-bottom: 32px;
}

.hp-btn-lg {
  padding: 13px 28px !important;
  font-size: 15px !important;
}

/* ── Responsive ── */
@media (max-width: 900px) {
  .hp-hero {
    grid-template-columns: 1fr;
    padding: 60px 1.5rem 40px;
    gap: 40px;
  }

  .hp-hero-right {
    display: none;
  }

  .hp-bento {
    grid-template-columns: 1fr 1fr;
  }

  .hp-card-large,
  .hp-card-wide {
    grid-column: span 2;
  }
}

@media (max-width: 560px) {
  .hp-bento {
    grid-template-columns: 1fr;
  }

  .hp-card-large,
  .hp-card-wide {
    grid-column: span 1;
  }

  .hp-stats {
    gap: 14px;
  }

  .hp-cta-box {
    padding: 40px 20px;
  }
}
</style>
