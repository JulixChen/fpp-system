<script setup>
import { ref, reactive, onMounted } from 'vue'
import { getLikesByUser, addLike, updateLike, deleteLike, getProducts } from '@/api/likeApi'

// 查詢用的 UserId
const userId = ref('A1236456789')

// 從後端查回來的喜好清單
const items = ref([])

// 共用狀態
const loading = ref(false)
const error = ref('')

const products = ref([])

// 表單資料：同時拿來做「新增」與「編輯」
const form = reactive({
  userId: 'A1236456789',
  productNo: '',
  orderQty: 1,
  account: '',
})

onMounted(async () => {
  try {
    const { data } = await getProducts()
    products.value = data
  } catch (e) {
    console.error('載入商品失敗', e)
  }
})

// 是否目前在「編輯模式」
const isEditing = ref(false)
// 正在編輯的那筆 SN
const editingSn = ref(null)

// 重新載入清單
const fetchLikes = async () => {
  loading.value = true
  error.value = ''
  items.value = []

  try {
    const { data } = await getLikesByUser(userId.value)
    items.value = data

    // 查詢時，順便把表單 userId 同步一下
    form.userId = userId.value
  } catch (e) {
    console.error(e)
    error.value = '查詢失敗，請確認後端已啟動，且 UserID 在資料庫中存在。'
  } finally {
    loading.value = false
  }
}

// 清空表單、回到新增模式
const resetForm = () => {
  form.userId = userId.value || ''
  form.productNo = ''
  form.orderQty = 1
  form.account = ''
  isEditing.value = false
  editingSn.value = null
}

// 簡單前端檢核
const validateForm = () => {
  if (!form.userId) {
    alert('User ID 不可為空')
    return false
  }
  if (!form.productNo) {
    alert('請輸入商品代號（或商品編號）')
    return false
  }
  if (!form.account) {
    alert('請輸入扣款帳號')
    return false
  }
  if (!form.orderQty || form.orderQty < 1) {
    alert('數量必須大於等於 1')
    return false
  }
  return true
}

// 送出表單：依 isEditing 決定要新增還是更新
const submitForm = async () => {
  if (!validateForm()) {
    return
  }

  loading.value = true
  error.value = ''

  try {
    const payload = {
      userId: form.userId,
      productNo: Number(form.productNo),
      orderQty: Number(form.orderQty),
      account: form.account,
    }

    if (isEditing.value && editingSn.value != null) {
      // 編輯模式 → 呼叫更新 API
      await updateLike(editingSn.value, payload)
    } else {
      // 新增模式 → 呼叫新增 API
      await addLike(payload)
    }

    // 成功後重新查詢清單
    await fetchLikes()
    resetForm()
  } catch (e) {
    console.error(e)
    error.value = isEditing.value ? '更新失敗，請稍後再試。' : '新增失敗，請稍後再試。'
  } finally {
    loading.value = false
  }
}

// 點「編輯」按鈕：把該列資料帶入表單
const startEdit = (item) => {
  isEditing.value = true
  editingSn.value = item.sn

  form.userId = item.userId
  form.productNo = item.productNo
  form.orderQty = item.orderQty
  form.account = item.account
}

// 點「刪除」按鈕：呼叫刪除 API
const removeItem = async (item) => {
  if (!confirm(`確定要刪除 SN=${item.sn} 這筆喜好資料嗎？`)) {
    return
  }

  loading.value = true
  error.value = ''

  try {
    await deleteLike(item.sn)
    await fetchLikes()
  } catch (e) {
    console.error(e)
    error.value = '刪除失敗，請稍後再試。'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="page">
    <h1>FPP 喜好金融商品清單</h1>

    <!-- 查詢區 -->
    <div class="search-bar">
      <label>
        User ID：
        <input v-model="userId" />
      </label>
      <button @click="fetchLikes">查詢喜好清單</button>
    </div>

    <!-- 新增 / 編輯表單 -->
    <div class="form-card">
      <h2>{{ isEditing ? '編輯喜好商品' : '新增喜好商品' }}</h2>

      <div class="form-row">
        <label>
          User ID：
          <input v-model="form.userId" />
        </label>
      </div>

      <div class="form-row">
        <label>
          商品名稱：
          <select v-model="form.productNo">
            <option disabled value="">請選擇商品</option>
            <option v-for="p in products" :key="p.productNo" :value="p.productNo">
              {{ p.productName }}
            </option>
          </select>
        </label>
      </div>

      <div class="form-row">
        <label>
          數量：
          <input v-model.number="form.orderQty" type="number" min="1" />
        </label>
      </div>

      <div class="form-row">
        <label>
          扣款帳號：
          <input v-model="form.account" />
        </label>
      </div>

      <div class="form-actions">
        <button @click="submitForm">
          {{ isEditing ? '儲存修改' : '新增喜好' }}
        </button>
        <button v-if="isEditing" type="button" class="secondary" @click="resetForm">
          取消編輯
        </button>
      </div>
    </div>

    <!-- 狀態訊息 -->
    <p v-if="loading">處理中...</p>
    <p v-if="error" class="error">{{ error }}</p>

    <!-- 結果清單 -->
    <table v-if="items.length" class="result-table">
      <thead>
        <tr>
          <th>SN</th>
          <th>商品名稱</th>
          <th>數量</th>
          <th>扣款帳號</th>
          <th>總金額</th>
          <th>總手續費</th>
          <th>使用者姓名</th>
          <th>Email</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in items" :key="item.sn">
          <td>{{ item.sn }}</td>
          <td>{{ item.productName }}</td>
          <td>{{ item.orderQty }}</td>
          <td>{{ item.account }}</td>
          <td>{{ item.totalAmount }}</td>
          <td>{{ item.totalFee }}</td>
          <td>{{ item.userName }}</td>
          <td>{{ item.email }}</td>
          <td>
            <button @click="startEdit(item)">編輯</button>
            <button class="danger" @click="removeItem(item)">刪除</button>
          </td>
        </tr>
      </tbody>
    </table>

    <p v-else-if="!loading && !error">尚無資料</p>
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
  font-size: 24px;
  margin-bottom: 16px;
}

.search-bar {
  margin-bottom: 16px;
}

.search-bar input {
  padding: 4px 8px;
  margin-left: 4px;
}

.search-bar button {
  margin-left: 8px;
  padding: 4px 12px;
}

/* 表單區塊 */
.form-card {
  margin-bottom: 20px;
  padding: 16px;
  border-radius: 6px;
  border: 1px solid #e5e7eb;
  background: #f9fafb;
}

.form-card h2 {
  margin: 0 0 12px;
  font-size: 18px;
}

.form-row {
  margin-bottom: 8px;
}

.form-row input {
  padding: 4px 8px;
  margin-left: 4px;
}

.form-actions {
  margin-top: 8px;
}

.form-actions button {
  padding: 4px 12px;
  margin-right: 8px;
}

.form-actions .secondary {
  background: #e5e7eb;
  border: 1px solid #d1d5db;
}

/* 表格 */
.error {
  color: red;
  margin: 8px 0;
}

.result-table {
  border-collapse: collapse;
  min-width: 600px;
}

.result-table th,
.result-table td {
  border: 1px solid #ddd;
  padding: 6px 10px;
  font-size: 14px;
}

.result-table th {
  background: #f5f5f5;
}

.result-table button {
  padding: 2px 8px;
  margin-right: 4px;
  font-size: 12px;
}

.result-table .danger {
  background: #fee2e2;
  border: 1px solid #fca5a5;
}
</style>
