import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/HomePage.vue')
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/LoginPage.vue'),
    meta: { guest: true }
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/views/RegisterPage.vue'),
    meta: { guest: true }
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: () => import('@/views/DashboardPage.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/courses',
    name: 'Courses',
    component: () => import('@/views/CoursesPage.vue')
  },
  {
    path: '/courses/:chapterId',
    name: 'Chapter',
    component: () => import('@/views/ChapterPage.vue')
  },
  {
    path: '/lessons/:lessonId',
    name: 'Lesson',
    component: () => import('@/views/LessonPage.vue')
  },
  {
    path: '/lessons/:lessonId/exercises',
    name: 'ExercisesList',
    component: () => import('@/views/ExercisesListPage.vue')
  },
  {
    path: '/exercises/:exerciseId',
    name: 'Exercise',
    component: () => import('@/views/ExercisePage.vue')
  },
  {
    path: '/quizzes',
    name: 'Quizzes',
    component: () => import('@/views/QuizzesPage.vue')
  },
  {
    path: '/quizzes/:quizId',
    name: 'Quiz',
    component: () => import('@/views/QuizPage.vue')
  },
  {
    path: '/challenge',
    name: 'DailyChallenge',
    component: () => import('@/views/ChallengePage.vue')
  },
  {
    path: '/profile',
    name: 'Profile',
    component: () => import('@/views/ProfilePage.vue'),
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// Navigation guards
router.beforeEach((to, from, next) => {
  const authStore = useAuthStore()

  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    next({ name: 'Login', query: { redirect: to.fullPath } })
  } else if (to.meta.guest && authStore.isAuthenticated) {
    next({ name: 'Dashboard' })
  } else {
    next()
  }
})

export default router
