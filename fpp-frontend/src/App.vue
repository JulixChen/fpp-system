<script setup>
import { RouterLink, RouterView } from 'vue-router'
</script>

<template>
  <div class="app">
    <header class="top-nav">
      <div class="logo">金融商品喜好紀錄系統 FPP</div>
      <nav>
        <RouterLink to="/">首頁</RouterLink>
        <RouterLink to="/about">關於</RouterLink>
      </nav>
    </header>

    <main class="main">
      <RouterView />
    </main>
  </div>
</template>

<style scoped>
.app {
  min-height: 100vh;
  background: #f8fafc;
}

.top-nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 24px;
  background: white;
  border-bottom: 1px solid #e5e7eb;
}

.logo {
  font-weight: 700;
  color: #16a34a;
}

nav a {
  margin-left: 16px;
  text-decoration: none;
  color: #374151;
}

nav a.router-link-active {
  color: #16a34a;
  font-weight: 600;
}

.main {
  padding: 24px;
}
</style>
