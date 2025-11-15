USE FPP;
GO

-- 1) 新增
CREATE OR ALTER PROCEDURE usp_AddLikeItem
    @UserID     VARCHAR(20),
    @ProductNo  INT,
    @OrderQty   INT,
    @Account    VARCHAR(20)
    AS
BEGIN
    SET NOCOUNT ON;

    IF @OrderQty <= 0
BEGIN
        RAISERROR('OrderQty must be > 0', 16, 1);
        RETURN;
END

BEGIN TRY
BEGIN TRAN;

        DECLARE @Price DECIMAL(18,2),
                @FeeRate DECIMAL(8,4),
                @TotalAmount DECIMAL(18,2),
                @TotalFee DECIMAL(18,2),
                @SN INT;

SELECT @Price = Price, @FeeRate = FeeRate
FROM Product
WHERE No = @ProductNo;

IF @Price IS NULL
BEGIN
            RAISERROR('Product not found', 16, 1);
ROLLBACK TRAN; RETURN;
END

        SET @TotalAmount = @Price * @OrderQty;
        SET @TotalFee    = @TotalAmount * @FeeRate;

INSERT INTO LikeList (UserID, ProductNo, OrderQty, Account, TotalFee, TotalAmount)
VALUES (@UserID, @ProductNo, @OrderQty, @Account, @TotalFee, @TotalAmount);

SET @SN = SCOPE_IDENTITY();

INSERT INTO LikeListLog (SNSaved, UserID, Action)
VALUES (@SN, @UserID, N'ADD');

COMMIT TRAN;
END TRY
BEGIN CATCH
IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
END CATCH
END;
GO

-- 2) 查詢
CREATE OR ALTER PROCEDURE usp_GetLikeListByUser
    @UserID VARCHAR(20)
    AS
BEGIN
    SET NOCOUNT ON;

SELECT
    ll.SN,
    p.ProductName,
    ll.OrderQty,
    ll.Account,
    ll.TotalAmount,
    ll.TotalFee,
    u.Email,
    u.UserName
FROM LikeList ll
         JOIN Product p ON ll.ProductNo = p.No
         JOIN [User] u ON ll.UserID = u.UserID
WHERE ll.UserID = @UserID
ORDER BY ll.SN;
END;
GO

-- 3) 更新
CREATE OR ALTER PROCEDURE usp_UpdateLikeItem
    @SN         INT,
    @Account    VARCHAR(20),
    @OrderQty   INT
    AS
BEGIN
    SET NOCOUNT ON;

    IF @OrderQty <= 0
BEGIN
        RAISERROR('OrderQty must be > 0', 16, 1);
        RETURN;
END

BEGIN TRY
BEGIN TRAN;

        DECLARE @ProductNo INT, @Price DECIMAL(18,2), @FeeRate DECIMAL(8,4),
                @TotalAmount DECIMAL(18,2), @TotalFee DECIMAL(18,2), @UserID VARCHAR(20);

SELECT @ProductNo = ProductNo, @UserID = UserID
FROM LikeList WHERE SN = @SN;

IF @ProductNo IS NULL
BEGIN
            RAISERROR('Like item not found', 16, 1);
ROLLBACK TRAN; RETURN;
END

SELECT @Price = Price, @FeeRate = FeeRate
FROM Product WHERE No = @ProductNo;

SET @TotalAmount = @Price * @OrderQty;
        SET @TotalFee    = @TotalAmount * @FeeRate;

UPDATE LikeList
SET Account = @Account,
    OrderQty = @OrderQty,
    TotalAmount = @TotalAmount,
    TotalFee = @TotalFee
WHERE SN = @SN;

INSERT INTO LikeListLog (SNSaved, UserID, Action)
VALUES (@SN, @UserID, N'UPDATE');

COMMIT TRAN;
END TRY
BEGIN CATCH
IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
END CATCH
END;
GO

-- 4) 刪除
CREATE OR ALTER PROCEDURE usp_DeleteLikeItem
    @SN INT
    AS
BEGIN
    SET NOCOUNT ON;

BEGIN TRY
BEGIN TRAN;

        DECLARE @UserID VARCHAR(20);
SELECT @UserID = UserID FROM LikeList WHERE SN = @SN;

IF @UserID IS NULL
BEGIN
            RAISERROR('Like item not found', 16, 1);
ROLLBACK TRAN; RETURN;
END

INSERT INTO LikeListLog (SNSaved, UserID, Action)
VALUES (@SN, @UserID, N'DELETE');

DELETE FROM LikeList WHERE SN = @SN;

COMMIT TRAN;
END TRY
BEGIN CATCH
IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
END CATCH
END;
GO
