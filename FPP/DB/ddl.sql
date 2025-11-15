/*
    FPP – Financial Product Preference System
    DDL for MS SQL Server
    說明：
    - 若資料庫 FPP 尚未存在，會自動建立
    - 使用者表：User
    - 產品表：Product
    - 喜好清單表：LikeList
    - 喜好清單異動紀錄：LikeListLog
    - 題目原始欄位為 "Order Name（購買數量）"，本設計採用較清楚命名 OrderQty。
*/

------------------------------------------------------------
-- 1. 建立資料庫（如尚未存在）
------------------------------------------------------------
IF DB_ID(N'FPP') IS NULL
BEGIN
    CREATE DATABASE FPP;
END
GO

USE FPP;
GO

------------------------------------------------------------
-- 2. 建立資料表
------------------------------------------------------------

-- 2.1 User 使用者
IF OBJECT_ID(N'dbo.[User]', N'U') IS NULL
BEGIN
CREATE TABLE dbo.[User] (
    UserID      VARCHAR(20)    NOT NULL PRIMARY KEY,   -- 使用者 ID
    UserName    NVARCHAR(50)   NOT NULL,               -- 使用者名稱
    Email       NVARCHAR(100)  NOT NULL,               -- 電子郵件
    Account     VARCHAR(20)    NOT NULL                -- 預設扣款帳號
    );
END
GO

-- 2.2 Product 產品資料
IF OBJECT_ID(N'dbo.Product', N'U') IS NULL
BEGIN
CREATE TABLE dbo.Product (
                             No           INT IDENTITY(1,1) PRIMARY KEY,        -- 產品流水號
                             ProductName  NVARCHAR(100) NOT NULL,               -- 產品名稱
                             Price        DECIMAL(18, 2) NOT NULL,              -- 產品價格
                             FeeRate      DECIMAL(8, 4)  NOT NULL               -- 手續費率 (0.1=10%, 0.01=1%)
);
END
GO

-- 2.3 LikeList 喜好清單
IF OBJECT_ID(N'dbo.LikeList', N'U') IS NULL
BEGIN
CREATE TABLE dbo.LikeList (
                              SN           INT IDENTITY(1,1) PRIMARY KEY,        -- 流水序號
                              UserID       VARCHAR(20)   NOT NULL,               -- 使用者 ID
                              ProductNo    INT           NOT NULL,               -- 對應 Product.No
                              OrderQty     INT           NOT NULL,               -- 購買數量
                              Account      VARCHAR(20)   NOT NULL,               -- 扣款帳號
                              TotalFee     DECIMAL(18,2) NOT NULL,               -- 總手續費
                              TotalAmount  DECIMAL(18,2) NOT NULL,               -- 預計扣款總金額
                              CONSTRAINT FK_LikeList_User
                                  FOREIGN KEY (UserID) REFERENCES dbo.[User](UserID),
                              CONSTRAINT FK_LikeList_Product
                                  FOREIGN KEY (ProductNo) REFERENCES dbo.Product(No)
);
END
GO

-- 2.4 LikeListLog 喜好清單異動紀錄
IF OBJECT_ID(N'dbo.LikeListLog', N'U') IS NULL
BEGIN
CREATE TABLE dbo.LikeListLog (
                                 LogID      INT IDENTITY(1,1) PRIMARY KEY,          -- Log 流水號
                                 SNSaved    INT          NOT NULL,                  -- 對應 LikeList.SN
                                 UserID     VARCHAR(20)  NOT NULL,                  -- 使用者 ID
                                 Action     NVARCHAR(50) NOT NULL,                  -- 動作 (ADD / UPDATE / DELETE)
                                 CreatedAt  DATETIME     NOT NULL DEFAULT(GETDATE())
);
END
GO

------------------------------------------------------------
-- 3. 初始測試資料（可依需要執行）
------------------------------------------------------------

-- 使用者測試資料
IF NOT EXISTS (SELECT 1 FROM dbo.[User] WHERE UserID = 'A1236456789')
BEGIN
INSERT INTO dbo.[User] (UserID, UserName, Email, Account)
VALUES ('A1236456789', N'王小明', 'test@email.com', '1111999666');
END
GO

-- 產品測試資料
IF NOT EXISTS (SELECT 1 FROM dbo.Product)
BEGIN
INSERT INTO dbo.Product (ProductName, Price, FeeRate)
VALUES
    (N'高收益債券基金', 1000.00, 0.0100),   -- 手續費 1%
    (N'全球股票基金',   1500.00, 0.0050);  -- 手續費 0.5%
END
GO
