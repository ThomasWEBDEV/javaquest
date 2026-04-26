<template>
  <div class="min-h-screen bg-gradient-to-br from-indigo-950 via-indigo-900 to-purple-900 overflow-hidden">

    <!-- Header -->
    <header class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-6 flex items-center justify-between">
      <div class="flex items-center gap-2">
        <span class="text-2xl">☕</span>
        <span class="text-xl font-extrabold text-white tracking-tight">JavaQuest</span>
      </div>
      <div class="flex items-center gap-3">
        <router-link
          to="/login"
          class="px-4 py-2 text-sm font-medium text-indigo-200 hover:text-white transition-colors"
        >
          Connexion
        </router-link>
        <router-link
          to="/register"
          class="px-5 py-2 text-sm font-semibold text-indigo-900 bg-yellow-400 hover:bg-yellow-300 rounded-xl transition-colors"
        >
          S'inscrire
        </router-link>
      </div>
    </header>

    <!-- Cercles décoratifs -->
    <div class="absolute top-20 left-1/4 w-96 h-96 bg-purple-600/20 rounded-full blur-3xl pointer-events-none"></div>
    <div class="absolute top-40 right-1/4 w-64 h-64 bg-indigo-400/20 rounded-full blur-3xl pointer-events-none"></div>

    <!-- Hero Section -->
    <div class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-24 pb-20 text-center">
      <div class="inline-flex items-center gap-2 px-4 py-2 bg-white/10 backdrop-blur rounded-full text-indigo-200 text-sm font-medium mb-8 border border-white/10">
        <span class="w-2 h-2 bg-green-400 rounded-full animate-pulse"></span>
        Plateforme d'apprentissage Java interactive
      </div>

      <h1 class="text-5xl md:text-7xl font-extrabold text-white mb-6 leading-tight">
        Apprenez <span class="text-transparent bg-clip-text bg-gradient-to-r from-yellow-400 to-orange-400">Java</span><br/>
        en vous amusant
      </h1>
      <p class="text-xl text-indigo-300 mb-12 max-w-2xl mx-auto leading-relaxed">
        JavaQuest transforme l'apprentissage de Java en une aventure interactive.
        Gagnez de l'XP, debloquez des badges et devenez un expert Java.
      </p>

      <div class="flex flex-col sm:flex-row justify-center gap-4">
        <router-link
          to="/register"
          class="px-10 py-4 bg-gradient-to-r from-yellow-400 to-orange-400 text-indigo-900 font-bold rounded-2xl hover:opacity-90 transition-opacity text-lg shadow-lg shadow-yellow-500/30"
        >
          Commencer gratuitement →
        </router-link>
        <router-link
          to="/courses"
          class="px-10 py-4 bg-white/10 backdrop-blur border border-white/20 text-white font-bold rounded-2xl hover:bg-white/20 transition-colors text-lg"
        >
          Voir les cours
        </router-link>
      </div>
    </div>

    <!-- Features Section -->
    <div class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
      <h2 class="text-center text-3xl font-bold text-white mb-12">Tout ce qu'il vous faut pour progresser</h2>
      <div class="grid md:grid-cols-3 gap-6">
        <div class="bg-white/5 backdrop-blur-lg border border-white/10 rounded-2xl p-8 hover:bg-white/10 transition-colors group">
          <div class="w-14 h-14 bg-yellow-400/20 border border-yellow-400/30 rounded-2xl flex items-center justify-center mb-5 group-hover:scale-110 transition-transform">
            <span class="text-2xl">💻</span>
          </div>
          <h3 class="text-xl font-bold text-white mb-3">Editeur de code integre</h3>
          <p class="text-indigo-300 leading-relaxed">Ecrivez et executez du code Java directement dans votre navigateur, sans installation.</p>
        </div>
        <div class="bg-white/5 backdrop-blur-lg border border-white/10 rounded-2xl p-8 hover:bg-white/10 transition-colors group">
          <div class="w-14 h-14 bg-green-400/20 border border-green-400/30 rounded-2xl flex items-center justify-center mb-5 group-hover:scale-110 transition-transform">
            <span class="text-2xl">🏆</span>
          </div>
          <h3 class="text-xl font-bold text-white mb-3">Systeme de gamification</h3>
          <p class="text-indigo-300 leading-relaxed">Gagnez de l'XP a chaque exercice, montez de niveau et debloquez des badges exclusifs.</p>
        </div>
        <div class="bg-white/5 backdrop-blur-lg border border-white/10 rounded-2xl p-8 hover:bg-white/10 transition-colors group">
          <div class="w-14 h-14 bg-purple-400/20 border border-purple-400/30 rounded-2xl flex items-center justify-center mb-5 group-hover:scale-110 transition-transform">
            <span class="text-2xl">📅</span>
          </div>
          <h3 class="text-xl font-bold text-white mb-3">Defis quotidiens</h3>
          <p class="text-indigo-300 leading-relaxed">Un nouveau defi chaque jour pour maintenir votre serie et progresser regulierement.</p>
        </div>
      </div>
    </div>

    <!-- Stats Section -->
    <div class="relative z-10 max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-12 pb-24">
      <div class="bg-white/5 backdrop-blur-lg border border-white/10 rounded-3xl p-10">
        <div class="grid grid-cols-2 md:grid-cols-4 gap-8 text-center">
          <div>
            <div class="text-4xl font-extrabold text-yellow-400 mb-1">15</div>
            <div class="text-indigo-300 text-sm">Chapitres</div>
          </div>
          <div>
            <div class="text-4xl font-extrabold text-green-400 mb-1">100+</div>
            <div class="text-indigo-300 text-sm">Exercices</div>
          </div>
          <div>
            <div class="text-4xl font-extrabold text-purple-400 mb-1">50+</div>
            <div class="text-indigo-300 text-sm">Quiz</div>
          </div>
          <div>
            <div class="text-4xl font-extrabold text-red-400 mb-1">365</div>
            <div class="text-indigo-300 text-sm">Defis quotidiens</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
</script>
