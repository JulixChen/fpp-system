📌 ESUN Bank Backend Test – Financial Product Preference System
(金融商品喜好系統)
🧩 專案介紹

此專案為玉山銀行 Java Backend Test，實作金融商品喜好系統。
使用者可新增、查詢、修改、刪除自己喜好的金融商品，並查看完整清單。

後端使用 Spring Boot + SQL Server，前端使用 Vue 3 + Vite 開發，並以 RESTful API 進行溝通。

📁 專案結構
fpp-system/
 ├── FPP/                   # 後端 (Spring Boot)
 ├── fpp-frontend/          # 前端 (Vue 3 + Vite)
 └── .gitignore

🚀 技術架構
✔ Backend – Spring Boot

Spring Boot 3

Spring Web

Spring Data JDBC

SQL Server (JDBC)

Global Exception Handling

Multi-layer architecture
Controller → Service → Repository

Store Procedure / Parameterized Query

✔ Frontend – Vue 3 + Vite

Vue 3 Composition API

Axios（呼叫後端 API）

Vite

Routing（Home、Add、Edit Page）

RWD Table UI

🗄 資料庫結構（SQL Server）

主要資料表如下：

User
欄位	說明
UserID	使用者身分證字號
UserName	使用者姓名
Email	Email

Product
欄位	說明
No	產品代號
ProductName	商品名稱
Price	商品價格
FeeRate	手續費率

LikeList
欄位	說明
SN	編號
UserID	使用者
ProductNo	商品代號
OrderQty	數量
Account	扣款帳號

📌 功能列表（CRUD 全實作）
功能	說明
➕ 新增喜好商品	依 UserID 建立喜好紀錄
📄 查詢喜好清單	取得使用者所有商品喜好
✏ 修改喜好商品	修改數量、扣款帳號（商品名稱不得更改）
❌ 刪除喜好商品	刪除特定 SN

📡 API 文件
🔍 查詢使用者所有喜好清單
GET /api/likes/{userId}

➕ 新增喜好
POST /api/likes


Body：

{
  "userId": "A123456789",
  "productNo": 1,
  "orderQty": 2,
  "account": "1111999666"
}

✏ 更新喜好
PUT /api/likes/{sn}

❌ 刪除喜好
DELETE /api/likes/{sn}

📦 查詢全部商品
GET /api/products

🖥 服務啟動方式
🔧 1. 啟動後端（Spring Boot）

在 FPP 專案下執行：

mvn spring-boot:run


後端將啟動於：

http://localhost:8080

🎨 2. 啟動前端（Vue 3）
cd fpp-frontend
npm install
npm run dev


前端預設執行於：

http://localhost:5173
