<script setup></script>

<template>
  <div class="page">
    <h1>關於 FPP 系統</h1>
    <p>這是玉山銀行新人後端實作題的前端畫面，用於展示：</p>
    <ul>
      <li>查詢使用者的喜好金融商品清單</li>
      <li>透過 REST API 呼叫 Spring Boot 後端</li>
      <li>前後端分離：Vue 3 + Vite + Axios</li>
    </ul>
  </div>
</template>

<style scoped>
.page {
  padding: 24px;
  font-family:
    system-ui,
    -apple-system,
    BlinkMacSystemFont,
    'Segoe UI',
    sans-serif;
}

h1 {
  font-size: 22px;
  margin-bottom: 12px;
}
</style>
