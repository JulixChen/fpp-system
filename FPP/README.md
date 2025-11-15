### 關於 LikeList.OrderQty 欄位

題目原始欄位名稱為 "Order Name（購買數量）"，但該命名容易誤導。
本專案依實務慣例與語意清楚性，將「購買數量」統一命名為 OrderQty。

為了方便測試，我在 DB 初始化腳本中預先建立了數筆 User 與 Product 範例資料，
面試官可直接用這些資料透過 Postman 呼叫 API 驗證功能，
若需要也可以自行新增更多 User/Product 再測試新增喜好清單。
