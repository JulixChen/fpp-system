// src/api/likeApi.js
import axios from 'axios'

// 建立一個 axios instance，之後所有呼叫都用這個
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api',
  headers: {
    'Content-Type': 'application/json',
  },
})

// 取得某使用者的喜好清單
export function getLikesByUser(userId) {
  return apiClient.get(`/likes/${userId}`)
}

// 新增喜好商品
export function addLike(data) {
  return apiClient.post('/likes', data)
}

// 更新喜好商品
export function updateLike(sn, data) {
  return apiClient.put(`/likes/${sn}`, data)
}

// 刪除喜好商品
export function deleteLike(sn) {
  return apiClient.delete(`/likes/${sn}`)
}

// 取得商品清單
export function getProducts() {
  return apiClient.get('/products')
}
