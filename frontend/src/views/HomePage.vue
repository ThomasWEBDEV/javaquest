<template>
  <div class="min-h-screen bg-gradient-to-br from-indigo-900 via-purple-900 to-indigo-800">
    <!-- Hero Section -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-20 pb-16">
      <div class="text-center">
        <h1 class="text-5xl md:text-6xl font-extrabold text-white mb-6">
          Apprenez <span class="text-yellow-400">Java</span> en vous amusant
        </h1>
        <p class="text-xl text-indigo-200 mb-10 max-w-2xl mx-auto">
          JavaQuest transforme l'apprentissage de Java en une aventure interactive. 
          Gagnez de l'XP, debloquez des badges et devenez un expert Java.
        </p>
        <div class="flex justify-center space-x-4">
          <router-link 
            to="/register"
            class="px-8 py-4 bg-yellow-400 text-indigo-900 font-bold rounded-lg hover:bg-yellow-300 transition-colors text-lg"
          >
            Commencer gratuitement
          </router-link>
          <router-link 
            to="/courses"
            class="px-8 py-4 bg-transparent border-2 border-white text-white font-bold rounded-lg hover:bg-white hover:text-indigo-900 transition-colors text-lg"
          >
            Voir les cours
          </router-link>
        </div>
      </div>
    </div>

    <!-- Features Section -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
      <div class="grid md:grid-cols-3 gap-8">
        <div class="bg-white/10 backdrop-blur-lg rounded-xl p-8 text-center">
          <div class="w-16 h-16 bg-yellow-400 rounded-full flex items-center justify-center mx-auto mb-4">
            <span class="text-3xl">💻</span>
          </div>
          <h3 class="text-xl font-bold text-white mb-2">Editeur de code integre</h3>
          <p class="text-indigo-200">Ecrivez et executez du code Java directement dans votre navigateur.</p>
        </div>
        <div class="bg-white/10 backdrop-blur-lg rounded-xl p-8 text-center">
          <div class="w-16 h-16 bg-green-400 rounded-full flex items-center justify-center mx-auto mb-4">
            <span class="text-3xl">🏆</span>
          </div>
          <h3 class="text-xl font-bold text-white mb-2">Systeme de gamification</h3>
          <p class="text-indigo-200">Gagnez de l'XP, montez de niveau et debloquez des badges.</p>
        </div>
        <div class="bg-white/10 backdrop-blur-lg rounded-xl p-8 text-center">
          <div class="w-16 h-16 bg-purple-400 rounded-full flex items-center justify-center mx-auto mb-4">
            <span class="text-3xl">📅</span>
          </div>
          <h3 class="text-xl font-bold text-white mb-2">Defis quotidiens</h3>
          <p class="text-indigo-200">Un nouveau defi chaque jour pour maintenir votre serie.</p>
        </div>
      </div>
    </div>

    <!-- Stats Section -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
      <div class="bg-white/5 backdrop-blur-lg rounded-2xl p-8">
        <div class="grid md:grid-cols-4 gap-8 text-center">
          <div>
            <div class="text-4xl font-bold text-yellow-400">15</div>
            <div class="text-indigo-200">Chapitres</div>
          </div>
          <div>
            <div class="text-4xl font-bold text-green-400">100+</div>
            <div class="text-indigo-200">Exercices</div>
          </div>
          <div>
            <div class="text-4xl font-bold text-purple-400">50+</div>
            <div class="text-indigo-200">Quiz</div>
          </div>
          <div>
            <div class="text-4xl font-bold text-red-400">365</div>
            <div class="text-indigo-200">Defis quotidiens</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
</script>
