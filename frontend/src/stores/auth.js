import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import api from '@/services/api'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  const token = ref(localStorage.getItem('token'))
  const xp = ref(0)
  const level = ref(1)

  const isAuthenticated = computed(() => !!token.value)

  async function login(username, password) {
    try {
      const response = await api.post('/auth/login', { username, password })
      token.value = response.data.token
      user.value = {
        username: response.data.username,
        email: response.data.email
      }
      localStorage.setItem('token', response.data.token)
      return { success: true }
    } catch (error) {
      return {
        success: false,
        error: error.response?.data?.error || 'Erreur de connexion'
      }
    }
  }

  async function register(username, email, password) {
    try {
      const response = await api.post('/auth/register', { username, email, password })
      token.value = response.data.token
      user.value = {
        username: response.data.username,
        email: response.data.email
      }
      localStorage.setItem('token', response.data.token)
      return { success: true }
    } catch (error) {
      return {
        success: false,
        error: error.response?.data?.error || 'Erreur d\'inscription'
      }
    }
  }

  function setProgress(totalXp, currentLevel) {
    xp.value = totalXp
    level.value = currentLevel
  }

  function logout() {
    token.value = null
    user.value = null
    xp.value = 0
    level.value = 1
    localStorage.removeItem('token')
  }

  async function fetchUser() {
    if (!token.value) return
    try {
      const response = await api.get('/auth/me')
      user.value = response.data
    } catch (error) {
      logout()
    }
  }

  return {
    user,
    token,
    xp,
    level,
    isAuthenticated,
    login,
    register,
    logout,
    fetchUser,
    setProgress
  }
})
