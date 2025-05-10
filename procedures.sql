USE [duka];
GO

--------------------------------------------------------------------------------
-- 1. sp_GetClients: возвращает всех клиентов
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetClients
AS
BEGIN
    SELECT * FROM dbo.Client;
END;
GO

--------------------------------------------------------------------------------
-- 2. sp_GetClientById: возвращает клиента по Client_ID
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetClientById
    @Client_ID INT
AS
BEGIN
    SELECT * 
    FROM dbo.Client 
    WHERE Client_ID = @Client_ID;
END;
GO

--------------------------------------------------------------------------------
-- 3. sp_RegisterClient: добавляет нового клиента
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_RegisterClient
    @First_Name        VARCHAR(45),
    @Last_Name         VARCHAR(45),
    @Client_Type_ID    INT,
    @Contacts_ID       INT,
    @District_ID       INT,
    @Discount          FLOAT,
    @Registration_Date VARCHAR(45),
    @Workplace         VARCHAR(45),
    @Position          VARCHAR(45),
    @Passport_Number   VARCHAR(45),
    @Login             VARCHAR(45),
    @Password          VARCHAR(100)
AS
BEGIN
    INSERT INTO dbo.Client 
        (Client_ID, First_Name, Last_Name, Client_Type_ID, Contacts_ID, District_ID, Discount, Registration_Date, Workplace, Position, Passport_Number, Login, Password)
    VALUES 
        (
          (SELECT ISNULL(MAX(Client_ID), 0) + 1 FROM dbo.Client),
          @First_Name, @Last_Name, @Client_Type_ID, @Contacts_ID, @District_ID, @Discount, @Registration_Date, @Workplace, @Position, @Passport_Number, @Login, @Password
        );
END;
GO

--------------------------------------------------------------------------------
-- 4. sp_AddClientContact: добавляет контакт для клиента
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_AddClientContact
    @Contact_Info     VARCHAR(45),
    @Contact_Type_ID  INT
AS
BEGIN
    INSERT INTO dbo.Contacts 
        (Contacts_ID, Contact_Info, Contact_Type_ID)
    VALUES
        (
          (SELECT ISNULL(MAX(Contacts_ID), 0) + 1 FROM dbo.Contacts),
          @Contact_Info,
          @Contact_Type_ID
        );
END;
GO

--------------------------------------------------------------------------------
-- 5. sp_GetEmployees: все сотрудники
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetEmployees
AS
BEGIN
    SELECT * FROM dbo.Employee;
END;
GO

--------------------------------------------------------------------------------
-- 6. sp_GetEmployeeById: сотрудник по Employee_ID
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetEmployeeById
    @Employee_ID INT
AS
BEGIN
    SELECT * 
    FROM dbo.Employee 
    WHERE Employee_ID = @Employee_ID;
END;
GO

--------------------------------------------------------------------------------
-- 7. sp_RegisterEmployee: добавить нового сотрудника
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_RegisterEmployee
    @First_Name        VARCHAR(45),
    @Last_Name         VARCHAR(45),
    @Registration_Date DATE,
    @Phone             VARCHAR(45),
    @Login             VARCHAR(45),
    @Password          VARCHAR(45),
    @Position_ID       INT
AS
BEGIN
    INSERT INTO dbo.Employee
        (Employee_ID, First_Name, Last_Name, Registration_Date, Phone, Login, Password, Position_ID)
    VALUES
        (
          (SELECT ISNULL(MAX(Employee_ID), 0) + 1 FROM dbo.Employee),
          @First_Name, @Last_Name, @Registration_Date, @Phone, @Login, @Password, @Position_ID
        );
END;
GO

--------------------------------------------------------------------------------
-- 8. sp_AuthenticateUser: авторизация клиента или сотрудника
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_AuthenticateUser
    @userType VARCHAR(50),
    @login    VARCHAR(45),
    @password VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF (@userType = 'client')
    BEGIN
        SELECT * 
        FROM dbo.Client 
        WHERE Login = @login AND Password = @password;
    END
    ELSE IF (@userType IN ('seller', 'purchasing_manager', 'accountant', 'administrator'))
    BEGIN
        DECLARE @ExpectedPositionID INT;

        SET @ExpectedPositionID = CASE @userType
            WHEN 'administrator'         THEN 1
            WHEN 'seller'                THEN 2
            WHEN 'purchasing_manager'    THEN 3
            WHEN 'accountant'            THEN 4
        END;

        SELECT * 
        FROM dbo.Employee 
        WHERE Login = @login 
          AND Password = @password 
          AND Position_ID = @ExpectedPositionID;
    END
    ELSE
    BEGIN
        SELECT 'Invalid user type' AS Error;
    END
END;
GO

--------------------------------------------------------------------------------
-- 9. sp_GetBreakEvenPoint: точка безубыточности
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetBreakEvenPoint
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY p.Product_ID)                           AS [Номер],
        cat.Category_Name                                               AS [Тип товара],
        p.Product_Name                                                 AS [Товар],
        sl.Price                                                       AS [Цена покупки],
        pl.Price                                                       AS [Цена продажи],
        (pl.Price - sl.Price)                                          AS [Прибыль]
    FROM dbo.Product p
    JOIN dbo.Category cat             ON p.Category_ID = cat.Category_ID
    LEFT JOIN dbo.Supply_List sl      ON p.Product_ID    = sl.Product_ID
    LEFT JOIN dbo.Price_List pl       ON p.Product_ID    = pl.Product_ID;
END;
GO

--------------------------------------------------------------------------------
-- 10. sp_GetDeliveriesBySupplier: поставки по поставщикам
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetDeliveriesBySupplier
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY s.Supply_ID)                   AS [Номер],
        s.Supply_Date                                          AS [Дата],
        sup.Company_Name                                       AS [Поставщик],
        cat.Category_Name                                      AS [Тип товара],
        p.Product_Name                                         AS [Товар],
        sl.Quantity                                            AS [Кол-во],
        sl.Price                                               AS [Цена],
        w.Warehouse_Name                                       AS [Склад]
    FROM dbo.Supply s
    JOIN dbo.Supplier sup           ON s.Supplier_ID    = sup.Supplier_ID
    JOIN dbo.Supply_List sl         ON s.Supply_ID      = sl.Supply_ID
    JOIN dbo.Product p              ON sl.Product_ID    = p.Product_ID
    JOIN dbo.Category cat           ON p.Category_ID    = cat.Category_ID
    JOIN dbo.Warehouse w            ON sl.Warehouse_ID  = w.Warehouse_ID;
END;
GO

--------------------------------------------------------------------------------
-- 11. sp_GetSupplierDebt: задолженность поставщиков
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetSupplierDebt
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY s.Supply_ID)                          AS [Номер],
        s.Supply_ID                                                AS [Номер поставки],
        sup.Company_Name                                           AS [Поставщик],
        DATEADD(day, 30, s.Supply_Date)                            AS [Дедлайн],
        ISNULL(SUM(sp.Amount), 0)                                   AS [Сумма оплате],
        (
            (SELECT ISNULL(SUM(CAST(sl.Price AS INT) * CAST(sl.Quantity AS INT)), 0)
             FROM dbo.Supply_List sl 
             WHERE sl.Supply_ID = s.Supply_ID)
            - ISNULL(SUM(sp.Amount), 0)
        )                                                            AS [Задолженность]
    FROM dbo.Supply s
    JOIN dbo.Supplier sup           ON s.Supplier_ID  = sup.Supplier_ID
    LEFT JOIN dbo.Supply_Payment sp  ON s.Supply_ID    = sp.Supply_ID
    GROUP BY s.Supply_ID, s.Supply_Date, sup.Company_Name;
END;
GO

--------------------------------------------------------------------------------
-- 12. sp_GetSupplyProductProfit: прибыль по поставкам
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetSupplyProductProfit
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY s.Supply_ID)                   AS [Номер],
        cat.Category_Name                                      AS [Тип товара],
        p.Product_Name                                         AS [Товар],
        sl.Price                                               AS [Цена покупки],
        pl.Price                                               AS [Цена продажи],
        s.Supply_ID                                            AS [Номер поставки],
        (pl.Price - sl.Price)                                  AS [Прибыль]
    FROM dbo.Supply s
    JOIN dbo.Supply_List sl         ON s.Supply_ID      = sl.Supply_ID
    JOIN dbo.Product p              ON sl.Product_ID    = p.Product_ID
    JOIN dbo.Category cat           ON p.Category_ID    = cat.Category_ID
    LEFT JOIN dbo.Price_List pl     ON p.Product_ID      = pl.Product_ID;
END;
GO

--------------------------------------------------------------------------------
-- 13. sp_GetTaxes: налоги
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetTaxes
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY Tax_ID)                       AS [Номер],
        [Name_]                                                  AS [Название налога],
        Tax_Rate                                                 AS [Сумма],
        GETDATE()                                                AS [Дата начала],
        DATEADD(month, 1, GETDATE())                            AS [Дата окончания]
    FROM dbo.Tax;
END;
GO

--------------------------------------------------------------------------------
-- 14. sp_GetSalaries: зарплаты
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetSalaries
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY s.Salary_ID)                         AS [Номер],
        s.Salary_Date                                                 AS [Дата],
        s.Salary_Amount                                               AS [Начисленно],
        ISNULL(s.Salary_Amount - s.Bonus, 0)                           AS [Оплачено],
        CONCAT(e.First_Name, ' ', e.Last_Name)                         AS [Сотрудник]
    FROM dbo.Salary s
    JOIN dbo.Employee e            ON s.Employee_ID    = e.Employee_ID;
END;
GO

--------------------------------------------------------------------------------
-- 15. sp_GetSalesByPromotions: продажи по акциям
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetSalesByPromotions
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY o.Order_ID)                               AS [Номер],
        e.Event_Name                                                     AS [Акция],
        o.Order_ID                                                       AS [Заказ],
        o.Order_Date                                                     AS [Дата],
        (
          SELECT SUM(od.Discounted_Price * od.Quantity)
          FROM dbo.Order_Details od
          WHERE od.Order_ID = o.Order_ID
        )                                                                AS [Сумма]
    FROM dbo.Order_ o
    LEFT JOIN dbo.Discount d        ON o.Discount_ID = d.Discount_ID
    LEFT JOIN dbo.Events e          ON d.Event_ID     = e.Event_ID;
END;
GO

--------------------------------------------------------------------------------
-- 16. sp_GetProfitLossReport: отчет о прибылях и убытках
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetProfitLossReport
AS
BEGIN
    DECLARE @Revenue   INT, @Expenses INT, @Taxes INT;
    SELECT @Revenue  = ISNULL(SUM(Amount),  0) FROM dbo.Payment;
    SELECT @Expenses = ISNULL(SUM(Salary_Amount), 0) FROM dbo.Salary;
    SELECT @Taxes    = ISNULL(SUM(Tax_Rate),     0) FROM dbo.Tax;

    SELECT
        1                                   AS [Номер],
        @Expenses                           AS [Расход],
        @Revenue                            AS [Доходы],
        @Taxes                              AS [Налоги],
        (@Revenue - @Expenses - @Taxes)     AS [Прибыль];
END;
GO

--------------------------------------------------------------------------------
-- 17. sp_GetSupplyPayments: оплата поставок
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetSupplyPayments
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY sp.Supply_Payment_ID)      AS [Номер],
        sp.Date_                                          AS [Дата],
        sp.Amount                                         AS [Сумма],
        sup.Company_Name                                  AS [Поставщик],
        NULL                                              AS [Сотрудник],
        pt.Payment_Type                                   AS [Тип оплаты]
    FROM dbo.Supply_Payment sp
    JOIN dbo.Supply s            ON sp.Supply_ID    = s.Supply_ID
    JOIN dbo.Supplier sup        ON s.Supplier_ID   = sup.Supplier_ID
    JOIN dbo.Payment_Type pt     ON sp.Payment_Type_ID = pt.Payment_Type_ID;
END;
GO

--------------------------------------------------------------------------------
-- 18. sp_GetDefectiveProducts: бракованные товары
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetDefectiveProducts
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY pw.Product_WriteOff_ID)     AS [Номер],
        s.Supply_Date                                    AS [Дата поставки],
        cat.Category_Name                                AS [Тип товаров],
        p.Product_Name                                   AS [Товар],
        pw.Quantity                                      AS [Количество],
        sl.Price                                         AS [Цена],
        sup.Company_Name                                 AS [Поставщик]
    FROM dbo.Product_WriteOff pw
    JOIN dbo.Product p            ON pw.Product_ID       = p.Product_ID
    JOIN dbo.Category cat         ON p.Category_ID       = cat.Category_ID
    LEFT JOIN dbo.Supply_List sl  ON p.Product_ID        = sl.Product_ID
    LEFT JOIN dbo.Supply s        ON sl.Supply_ID        = s.Supply_ID
    LEFT JOIN dbo.Supplier sup    ON s.Supplier_ID       = sup.Supplier_ID;
END;
GO

--------------------------------------------------------------------------------
-- 19. sp_GetWarehouseProducts: товары на складе
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetWarehouseProducts
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY sl.Supply_List_ID)     AS [Номер],
        cat.Category_Name                                AS [Тип товаров],
        p.Product_Name                                   AS [Товар],
        sl.Price                                         AS [Цена],
        sl.Quantity                                      AS [Количество],
        sl.Supply_ID                                     AS [Номер поставки],
        sl.Warehouse_ID                                  AS [Номер склада]
    FROM dbo.Supply_List sl
    JOIN dbo.Product p            ON sl.Product_ID       = p.Product_ID
    JOIN dbo.Category cat         ON p.Category_ID       = cat.Category_ID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_GetWarehouseProductRemainders
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY sl.Supply_List_ID)     AS [Номер],
        cat.Category_Name                                AS [Тип товаров],
        p.Product_Name                                   AS [Товар],
        sl.Price                                         AS [Цена],
        sl.Quantity                                      AS [Поставлено],
        ISNULL((SELECT SUM(od.Quantity) FROM dbo.Order_Details od WHERE od.Supply_List_ID = sl.Supply_List_ID), 0) AS [Продано],
        (sl.Quantity - ISNULL((SELECT SUM(od.Quantity) FROM dbo.Order_Details od WHERE od.Supply_List_ID = sl.Supply_List_ID), 0)) AS [Остаток],
        sl.Supply_ID                                     AS [Номер поставки],
        sl.Warehouse_ID                                  AS [Номер склада]
    FROM dbo.Supply_List sl
    JOIN dbo.Product p            ON sl.Product_ID       = p.Product_ID
    JOIN dbo.Category cat         ON p.Category_ID       = cat.Category_ID;
END;
GO

--------------------------------------------------------------------------------
-- 20. sp_GetPriceList: прайс-лист
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetPriceList
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY pl.Price_List_ID)     AS [Номер],
        cat.Category_Name                                AS [Категория товара],
        p.Product_Name                                   AS [Товар],
        pl.Price                                         AS [Цена товара]
    FROM dbo.Price_List pl
    JOIN dbo.Product p            ON pl.Product_ID       = p.Product_ID
    JOIN dbo.Category cat         ON p.Category_ID       = cat.Category_ID;
END;
GO

--------------------------------------------------------------------------------
-- 21. sp_GetOrderComposition: состав заказа (чек)
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetOrderComposition
    @Client_ID INT,
    @Order_ID  INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM dbo.Order_ WHERE Order_ID = @Order_ID AND Client_ID = @Client_ID
    )
    BEGIN
        SELECT TOP 0
            od.Order_Details_ID      AS [№ строки],
            p.Product_Name           AS [Товар],
            od.Discounted_Price      AS [Цена со скидкой],
            od.Quantity              AS [Количество],
            (od.Discounted_Price * od.Quantity) AS [Стоимость]
        FROM dbo.Order_Details od
        JOIN dbo.Supply_List sl    ON od.Supply_List_ID = sl.Supply_List_ID
        JOIN dbo.Product p         ON sl.Product_ID     = p.Product_ID;
        RETURN;
    END

    SELECT 
        od.Order_Details_ID      AS [№ строки],
        p.Product_Name           AS [Товар],
        od.Discounted_Price      AS [Цена со скидкой],
        od.Quantity              AS [Количество],
        (od.Discounted_Price * od.Quantity) AS [Стоимость]
    FROM dbo.Order_Details od
    JOIN dbo.Supply_List sl    ON od.Supply_List_ID = sl.Supply_List_ID
    JOIN dbo.Product p         ON sl.Product_ID     = p.Product_ID
    JOIN dbo.Order_ o          ON od.Order_ID       = o.Order_ID
    WHERE o.Order_ID = @Order_ID
      AND o.Client_ID = @Client_ID;
END;
GO

--------------------------------------------------------------------------------
-- 22. sp_GetClientOrders: заказы клиента по ID
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetClientOrders
    @Client_ID INT
AS
BEGIN
    SELECT 
        o.Order_ID         AS [№ заказа],
        o.Order_Date       AS [Дата],
        SUM(p.Amount)      AS [Стоимость],
        o.Invoice_Number   AS [№ накладной],
        os.Order_Status    AS [Статус]
    FROM dbo.Order_ o
    JOIN dbo.Order_Status os ON o.Order_Status_ID = os.Order_Status_ID
    JOIN dbo.Payment p        ON p.Order_ID        = o.Order_ID
    WHERE o.Client_ID = @Client_ID
    GROUP BY o.Order_ID, o.Order_Date, o.Invoice_Number, os.Order_Status;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_GetAllClientOrders
AS
BEGIN
    SELECT 
        o.Order_ID         AS [№ заказа],
        o.Order_Date       AS [Дата],
        SUM(p.Amount)      AS [Стоимость],
        o.Invoice_Number   AS [№ накладной],
        os.Order_Status    AS [Статус],
        (c.First_Name + ' ' + c.Last_Name) AS [Клиент]
    FROM dbo.Order_ o
    JOIN dbo.Order_Status os ON o.Order_Status_ID = os.Order_Status_ID
    JOIN dbo.Payment p        ON p.Order_ID        = o.Order_ID
    JOIN dbo.Client c         ON o.Client_ID       = c.Client_ID
    GROUP BY o.Order_ID, o.Order_Date, o.Invoice_Number, os.Order_Status, c.First_Name, c.Last_Name;
END;
GO

--------------------------------------------------------------------------------
-- 23. sp_CancelOrder: отмена заказа
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_CancelOrder
    @Order_ID INT,
    @Reason   VARCHAR(255)
AS
BEGIN
    UPDATE dbo.Order_
    SET Order_Status_ID = (
            SELECT TOP 1 Order_Status_ID 
            FROM dbo.Order_Status 
            WHERE Order_Status = 'Cancelled' 
            ORDER BY Order_Status_ID
        ),
        Comment = @Reason
    WHERE Order_ID = @Order_ID;

    SELECT * FROM dbo.Order_ WHERE Order_ID = @Order_ID;
END;
GO

--------------------------------------------------------------------------------
-- 24. sp_GetOrderPaymentsForPeriod: оплаты за период
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetOrderPaymentsForPeriod
    @StartDate DATE,
    @EndDate   DATE
AS
BEGIN
    SELECT 
        o.Order_ID        AS [Номер],
        o.Order_Date      AS [Дата заказа],
        SUM(od.Discounted_Price * od.Quantity) AS [Сумма к оплате],
        ISNULL(paid.TotalPaid, 0)            AS [Сумма оплаты]
    FROM dbo.Order_ o
    JOIN dbo.Order_Details od ON o.Order_ID = od.Order_ID
    LEFT JOIN (
        SELECT Order_ID, SUM(Amount) AS TotalPaid
        FROM dbo.Payment
        GROUP BY Order_ID
    ) AS paid ON o.Order_ID = paid.Order_ID
    WHERE o.Order_Date BETWEEN @StartDate AND @EndDate
    GROUP BY o.Order_ID, o.Order_Date, paid.TotalPaid;
END;
GO

--------------------------------------------------------------------------------
-- 25. sp_GetCurrentPromotionDiscounts: текущие скидки
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetCurrentPromotionDiscounts
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY d.Discount_ID)      AS [Номер],
        e.Event_Name                                AS [Название акции],
        d.Discount_Value                            AS [Скидка],
        GETDATE()                                   AS [Дата начала],
        DATEADD(day, 10, GETDATE())                 AS [Дата окончания]
    FROM dbo.Discount d
    LEFT JOIN dbo.Events e ON d.Event_ID = e.Event_ID;
END;
GO

--------------------------------------------------------------------------------
-- 26. sp_GetClientDebts: задолженности клиентов
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetClientDebts
AS
BEGIN
    SELECT 
        o.Order_ID                               AS [№ заказа],
        (
            SELECT SUM(od.Discounted_Price * od.Quantity)
            FROM dbo.Order_Details od
            WHERE od.Order_ID = o.Order_ID
        )                                        AS [Сумма к оплате],
        (
            SELECT SUM(p.Amount)
            FROM dbo.Payment p
            WHERE p.Order_ID = o.Order_ID
        )                                        AS [Фактическая сумма оплаты],
        DATEADD(day, 30, o.Order_Date)           AS [Дата дедлайна платежа]
    FROM dbo.Order_ o;
END;
GO

--------------------------------------------------------------------------------
-- 27. sp_AddOrderPayment: добавить оплату заказа
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_AddOrderPayment
    @Order_ID         INT,
    @Amount           DECIMAL(10,2),
    @Payment_Type_ID  INT,
    @Comment          VARCHAR(255)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.Order_ WHERE Order_ID = @Order_ID)
    BEGIN
        RAISERROR('Order does not exist.', 16, 1);
        RETURN;
    END

    INSERT INTO dbo.Payment 
        (Payment_ID, Payment_Type_ID, Amount, Date_, Comment, Order_ID)
    VALUES
        (
          (SELECT ISNULL(MAX(Payment_ID), 0) + 1 FROM dbo.Payment),
          @Payment_Type_ID, @Amount, GETDATE(), @Comment, @Order_ID
        );

    SELECT * FROM dbo.Payment WHERE Order_ID = @Order_ID;
END;
GO

--------------------------------------------------------------------------------
-- 28. sp_GetCanceledOrders: отменённые заказы
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetCanceledOrders
AS
BEGIN
    SELECT 
        o.Order_ID                  AS [Номер заказа],
        o.Order_Date                AS [Дата заказа],
        o.Comment                   AS [Причина отмены],
        pt.Payment_Type             AS [Тип оплаты]
    FROM dbo.Order_ o
    JOIN dbo.Order_Status os      ON o.Order_Status_ID = os.Order_Status_ID
    LEFT JOIN dbo.Payment p        ON o.Order_ID        = p.Order_ID
    LEFT JOIN dbo.Payment_Type pt  ON p.Payment_Type_ID  = pt.Payment_Type_ID
    WHERE os.Order_Status = 'Cancelled';
END;
GO

--------------------------------------------------------------------------------
-- 29. sp_GetProductSales: продажи по товарам
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetProductSales
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY p.Product_ID)              AS [Номер],
        cat.Category_Name                                   AS [Тип товара],
        p.Product_Name                                      AS [Товар],
        sl.Price                                            AS [Цена],
        od.Quantity                                         AS [Кол-во]
    FROM dbo.Order_Details od
    JOIN dbo.Supply_List sl      ON od.Supply_List_ID = sl.Supply_List_ID
    JOIN dbo.Product p           ON sl.Product_ID      = p.Product_ID
    JOIN dbo.Category cat        ON p.Category_ID      = cat.Category_ID;
END;
GO

--------------------------------------------------------------------------------
-- 30. sp_GetSalesByClients: продажи по клиентам
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetSalesByClients
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY c.Client_ID)             AS [Номер],
        (c.First_Name + ' ' + c.Last_Name)                  AS [ФИО],
        (SELECT ISNULL(SUM(Amount), 0) FROM dbo.Payment WHERE Order_ID = o.Order_ID) AS [Оплачено],
        c.Discount                                         AS [Скидка клиента],
        e.Event_Name                                       AS [Акция]
    FROM dbo.Order_ o
    JOIN dbo.Client c             ON o.Client_ID    = c.Client_ID
    LEFT JOIN dbo.Discount d      ON o.Discount_ID  = d.Discount_ID
    LEFT JOIN dbo.Events e        ON d.Event_ID     = e.Event_ID;
END;
GO

--------------------------------------------------------------------------------
-- 31. sp_GetSalesByWarehouse: продажи по складу
--------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_GetSalesByWarehouse
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY sl.Supply_List_ID)     AS [Номер],
        cat.Category_Name                                AS [Тип товара],
        p.Product_Name                                   AS [Товар],
        sl.Price                                         AS [Цена],
        sl.Quantity                                      AS [Количество]
    FROM dbo.Supply_List sl
    JOIN dbo.Product p            ON sl.Product_ID       = p.Product_ID
    JOIN dbo.Category cat         ON p.Category_ID       = cat.Category_ID;
END;
GO

-- Процедура для получения отчета о точке безубыточности
CREATE OR ALTER PROCEDURE GetBreakEvenReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY o.operation_date) as 'Номер',
        o.operation_date as 'Дата',
        g.goods_name as 'Товар',
        gc.goods_category as 'Категория',
        ol.quantity as 'Количество',
        ol.prise_with_discount as 'Цена продажи',
        (ol.quantity * ol.prise_with_discount) as 'Выручка',
        (SELECT TOP 1 ol2.prise_with_discount 
         FROM duka_operation_list ol2 
         JOIN duka_operations o2 ON ol2.operations_id_operations = o2.id_operations
         WHERE ol2.goods_id_goods = ol.goods_id_goods 
         AND o2.operation_type_id_operation_type = 2 -- Закупка
         ORDER BY o2.operation_date DESC) as 'Цена закупки',
        ((ol.quantity * ol.prise_with_discount) - 
         (ol.quantity * (SELECT TOP 1 ol2.prise_with_discount 
                        FROM duka_operation_list ol2 
                        JOIN duka_operations o2 ON ol2.operations_id_operations = o2.id_operations
                        WHERE ol2.goods_id_goods = ol.goods_id_goods 
                        AND o2.operation_type_id_operation_type = 2
                        ORDER BY o2.operation_date DESC))) as 'Прибыль'
    FROM duka_operations o
    JOIN duka_operation_list ol ON o.id_operations = ol.operations_id_operations
    JOIN duka_goods g ON ol.goods_id_goods = g.id_goods
    JOIN duka_goods_category gc ON g.goods_category_id_goods_category = gc.id_goods_category
    WHERE o.operation_type_id_operation_type = 1 -- Продажа
    AND o.operation_date BETWEEN @StartDate AND @EndDate
    ORDER BY o.operation_date;
END;
GO

-- Процедура для получения отчета о поставках по поставщикам
CREATE OR ALTER PROCEDURE GetDeliveriesBySupplierReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY o.operation_date) as 'Номер',
        o.operation_date as 'Дата',
        c.org_name as 'Поставщик',
        g.goods_name as 'Товар',
        gc.goods_category as 'Категория',
        ol.quantity as 'Количество',
        ol.prise_with_discount as 'Цена',
        (ol.quantity * ol.prise_with_discount) as 'Сумма',
        o.doc_num as 'Номер документа',
        os.operation_status as 'Статус'
    FROM duka_operations o
    JOIN duka_operation_list ol ON o.id_operations = ol.operations_id_operations
    JOIN duka_contragent c ON o.contragent_id_contragent = c.id_contragent
    JOIN duka_goods g ON ol.goods_id_goods = g.id_goods
    JOIN duka_goods_category gc ON g.goods_category_id_goods_category = gc.id_goods_category
    JOIN duka_operation_status os ON o.operation_status_id_operation_status = os.id_operation_status
    WHERE o.operation_type_id_operation_type = 2 -- Закупка
    AND c.contragent_type_id_contragent_type = 1 -- Поставщик
    AND o.operation_date BETWEEN @StartDate AND @EndDate
    ORDER BY o.operation_date;
END;
GO

-- Процедура для получения отчета по налогам
CREATE OR ALTER PROCEDURE GetTaxesReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY t.id_taxes) as 'Номер',
        t.taxe_name as 'Налог',
        t.tax_rate as 'Ставка',
        SUM(ol.quantity * ol.prise_with_discount) as 'Налогооблагаемая база',
        SUM(ol.quantity * ol.prise_with_discount * t.tax_rate) as 'Сумма налога'
    FROM duka_taxes t
    CROSS JOIN duka_operations o
    JOIN duka_operation_list ol ON o.id_operations = ol.operations_id_operations
    WHERE o.operation_type_id_operation_type = 1 -- Продажа
    AND o.operation_date BETWEEN @StartDate AND @EndDate
    GROUP BY t.id_taxes, t.taxe_name, t.tax_rate;
END;
GO

-- Процедура для получения отчета о прибылях и убытках
CREATE OR ALTER PROCEDURE GetProfitLossReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    WITH Sales AS (
        SELECT 
            SUM(ol.quantity * ol.prise_with_discount) as total_sales
        FROM duka_operations o
        JOIN duka_operation_list ol ON o.id_operations = ol.operations_id_operations
        WHERE o.operation_type_id_operation_type = 1 -- Продажа
        AND o.operation_date BETWEEN @StartDate AND @EndDate
    ),
    Purchases AS (
        SELECT 
            SUM(ol.quantity * ol.prise_with_discount) as total_purchases
        FROM duka_operations o
        JOIN duka_operation_list ol ON o.id_operations = ol.operations_id_operations
        WHERE o.operation_type_id_operation_type = 2 -- Закупка
        AND o.operation_date BETWEEN @StartDate AND @EndDate
    ),
    Salaries AS (
        SELECT 
            SUM(earning_payments_amount) as total_salaries
        FROM duka_earning_payments
        WHERE earning_payments_date BETWEEN @StartDate AND @EndDate
    ),
    WriteOffs AS (
        SELECT 
            SUM(ol.prise_with_discount * w.write_off_amount) as total_writeoffs
        FROM duka_write_off_list w
        JOIN duka_operation_list ol ON w.operation_list_id_operation_list = ol.id_operation_list
        WHERE w.write_off_date BETWEEN @StartDate AND @EndDate
    )
    SELECT
        1 as 'Номер',
        'Выручка' as 'Показатель',
        ISNULL(total_sales, 0) as 'Сумма'
    FROM Sales
    UNION ALL
    SELECT 2, 'Себестоимость продаж', ISNULL(total_purchases, 0) FROM Purchases
    UNION ALL
    SELECT 3, 'Валовая прибыль', ISNULL(total_sales, 0) - ISNULL(total_purchases, 0)
    FROM Sales, Purchases
    UNION ALL
    SELECT 4, 'Расходы на зарплату', ISNULL(total_salaries, 0) FROM Salaries
    UNION ALL
    SELECT 5, 'Списания', ISNULL(total_writeoffs, 0) FROM WriteOffs
    UNION ALL
    SELECT 6, 'Чистая прибыль', 
           ISNULL(total_sales, 0) - ISNULL(total_purchases, 0) - 
           ISNULL(total_salaries, 0) - ISNULL(total_writeoffs, 0)
    FROM Sales, Purchases, Salaries, WriteOffs
    ORDER BY 'Номер';
END;
GO

-- Процедура для получения отчета по оплатам поставщикам
CREATE OR ALTER PROCEDURE GetSupplyPaymentsReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY p.payment_date) as 'Номер',
        p.payment_date as 'Дата платежа',
        c.org_name as 'Поставщик',
        o.doc_num as 'Номер документа',
        o.operation_date as 'Дата поставки',
        p.payment_sum as 'Сумма платежа',
        pt.payment_type as 'Способ оплаты',
        p.payment_comments as 'Комментарий'
    FROM duka_payments p
    JOIN duka_operations o ON p.operations_id_operations = o.id_operations
    JOIN duka_contragent c ON o.contragent_id_contragent = c.id_contragent
    JOIN duka_payment_type pt ON p.payment_type_id_payment_type = pt.id_payment_type
    WHERE o.operation_type_id_operation_type = 2 -- Закупка
    AND c.contragent_type_id_contragent_type = 1 -- Поставщик
    AND p.payment_date BETWEEN @StartDate AND @EndDate
    ORDER BY p.payment_date;
END;
GO

-- Процедура для получения отчета по товарам на складе
CREATE OR ALTER PROCEDURE GetWarehouseProductsReport
AS
BEGIN
    WITH StockMovements AS (
        SELECT 
            ol.goods_id_goods,
            ol.wharehouse_id_wharehouse,
            CASE 
                WHEN o.operation_type_id_operation_type = 2 THEN ol.quantity -- Закупка
                WHEN o.operation_type_id_operation_type = 1 THEN -ol.quantity -- Продажа
                WHEN o.operation_type_id_operation_type = 3 THEN ol.quantity -- Возврат от покупателя
                WHEN o.operation_type_id_operation_type = 4 THEN -ol.quantity -- Возврат поставщику
            END as quantity_change
        FROM duka_operation_list ol
        JOIN duka_operations o ON ol.operations_id_operations = o.id_operations
        WHERE o.operation_status_id_operation_status = 3 -- Выполнена
    )
    SELECT 
        ROW_NUMBER() OVER (ORDER BY w.wharehouse, g.goods_name) as 'Номер',
        w.wharehouse as 'Склад',
        gc.goods_category as 'Категория',
        g.goods_name as 'Товар',
        ISNULL(SUM(sm.quantity_change), 0) as 'Количество',
        (SELECT TOP 1 prise_with_discount 
         FROM duka_operation_list ol2
         JOIN duka_operations o2 ON ol2.operations_id_operations = o2.id_operations
         WHERE ol2.goods_id_goods = g.id_goods
         AND o2.operation_type_id_operation_type = 2 -- Закупка
         ORDER BY o2.operation_date DESC) as 'Цена'
    FROM duka_wharehouse w
    CROSS JOIN duka_goods g
    JOIN duka_goods_category gc ON g.goods_category_id_goods_category = gc.id_goods_category
    LEFT JOIN StockMovements sm ON sm.goods_id_goods = g.id_goods 
                               AND sm.wharehouse_id_wharehouse = w.id_wharehouse
    GROUP BY w.id_wharehouse, w.wharehouse, g.id_goods, g.goods_name, gc.goods_category
    HAVING ISNULL(SUM(sm.quantity_change), 0) > 0
    ORDER BY w.wharehouse, g.goods_name;
END;
GO

-- Процедура для получения прайс-листа
CREATE OR ALTER PROCEDURE GetPriceListReport
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY gc.goods_category, g.goods_name) as 'Номер',
        gc.goods_category as 'Категория',
        g.goods_name as 'Товар',
        g.goods_comments as 'Описание',
        pl.price_list as 'Цена без скидки',
        ISNULL(p.discount_value, 0) as 'Скидка',
        CASE 
            WHEN p.discount_value IS NOT NULL 
            THEN pl.price_list * (1 - p.discount_value)
            ELSE pl.price_list
        END as 'Цена со скидкой',
        CASE 
            WHEN p.promoutions_name IS NOT NULL 
            THEN p.promoutions_name + ' (' + 
                 CONVERT(VARCHAR, p.promoution_date_start, 104) + ' - ' + 
                 CONVERT(VARCHAR, p.promoution_date_end, 104) + ')'
            ELSE ''
        END as 'Акция'
    FROM duka_goods g
    JOIN duka_goods_category gc ON g.goods_category_id_goods_category = gc.id_goods_category
    LEFT JOIN duka_price_list pl ON g.id_goods = pl.goods_id_goods
    LEFT JOIN duka_promoutions p ON pl.promoutions_id_promoutions = p.id_promoutions
    WHERE pl.price_list IS NOT NULL
    ORDER BY gc.goods_category, g.goods_name;
END;
GO

-- Процедура для получения сводки по заказам
CREATE OR ALTER PROCEDURE GetOrdersSummaryReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY o.operation_date) as 'Номер',
        o.operation_date as 'Дата',
        o.doc_num as 'Номер документа',
        c.org_name as 'Клиент',
        e.last_name + ' ' + e.first_name as 'Менеджер',
        COUNT(ol.id_operation_list) as 'Количество позиций',
        SUM(ol.quantity) as 'Общее количество',
        SUM(ol.quantity * ol.prise_with_discount) as 'Сумма',
        os.operation_status as 'Статус'
    FROM duka_operations o
    JOIN duka_operation_list ol ON o.id_operations = ol.operations_id_operations
    JOIN duka_contragent c ON o.contragent_id_contragent = c.id_contragent
    JOIN duka_employee e ON o.employee_id_employee = e.id_employee
    JOIN duka_operation_status os ON o.operation_status_id_operation_status = os.id_operation_status
    WHERE o.operation_type_id_operation_type = 1 -- Продажа
    AND o.operation_date BETWEEN @StartDate AND @EndDate
    GROUP BY o.id_operations, o.operation_date, o.doc_num, c.org_name, 
             e.last_name, e.first_name, os.operation_status
    ORDER BY o.operation_date;
END;
GO

-- Процедура для получения отчета по акциям
CREATE OR ALTER PROCEDURE GetPromotionsReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY p.promoution_date_start) as 'Номер',
        p.promoutions_name as 'Название акции',
        et.event_type as 'Тип акции',
        p.promoution_date_start as 'Дата начала',
        p.promoution_date_end as 'Дата окончания',
        p.discount_value * 100 as 'Скидка %',
        COUNT(DISTINCT g.id_goods) as 'Количество товаров',
        COUNT(DISTINCT o.id_operations) as 'Количество продаж',
        SUM(ol.quantity) as 'Продано единиц',
        SUM(ol.quantity * ol.prise_with_discount) as 'Сумма продаж',
        p.promoution_comment as 'Комментарий'
    FROM duka_promoutions p
    JOIN duka_event_type et ON p.event_type_id_event_type = et.id_event_type
    LEFT JOIN duka_price_list pl ON p.id_promoutions = pl.promoutions_id_promoutions
    LEFT JOIN duka_goods g ON pl.goods_id_goods = g.id_goods
    LEFT JOIN duka_operation_list ol ON g.id_goods = ol.goods_id_goods
    LEFT JOIN duka_operations o ON ol.operations_id_operations = o.id_operations
                               AND o.operation_date BETWEEN p.promoution_date_start AND p.promoution_date_end
                               AND o.operation_type_id_operation_type = 1 -- Продажа
    WHERE p.promoution_date_start <= @EndDate
    AND p.promoution_date_end >= @StartDate
    GROUP BY p.id_promoutions, p.promoutions_name, et.event_type,
             p.promoution_date_start, p.promoution_date_end,
             p.discount_value, p.promoution_comment
    ORDER BY p.promoution_date_start;
END;
GO

-- Процедура для получения состава заказа
CREATE OR ALTER PROCEDURE GetOrderCompositionReport
    @OrderId INT
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY g.goods_name) as 'Номер',
        g.goods_name as 'Товар',
        gc.goods_category as 'Категория',
        g.goods_comments as 'Описание',
        ol.quantity as 'Количество',
        ol.prise_with_discount as 'Цена',
        (ol.quantity * ol.prise_with_discount) as 'Сумма',
        w.wharehouse as 'Склад',
        ISNULL(p.promoutions_name, '') as 'Применённая акция',
        ISNULL(p.discount_value * 100, 0) as 'Скидка %'
    FROM duka_operations o
    JOIN duka_operation_list ol ON o.id_operations = ol.operations_id_operations
    JOIN duka_goods g ON ol.goods_id_goods = g.id_goods
    JOIN duka_goods_category gc ON g.goods_category_id_goods_category = gc.id_goods_category
    JOIN duka_wharehouse w ON ol.wharehouse_id_wharehouse = w.id_wharehouse
    LEFT JOIN duka_price_list pl ON g.id_goods = pl.goods_id_goods
    LEFT JOIN duka_promoutions p ON pl.promoutions_id_promoutions = p.id_promoutions
                                AND o.operation_date BETWEEN p.promoution_date_start AND p.promoution_date_end
    WHERE o.id_operations = @OrderId
    ORDER BY g.goods_name;
END;
GO

-- Процедура для получения отчета по отмененным заказам
CREATE OR ALTER PROCEDURE GetCanceledOrdersReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY o.operation_date) as 'Номер',
        o.operation_date as 'Дата',
        o.doc_num as 'Номер документа',
        c.org_name as 'Клиент',
        e.last_name + ' ' + e.first_name as 'Менеджер',
        COUNT(ol.id_operation_list) as 'Количество позиций',
        SUM(ol.quantity * ol.prise_with_discount) as 'Сумма',
        o.comments as 'Причина отмены'
    FROM duka_operations o
    JOIN duka_operation_list ol ON o.id_operations = ol.operations_id_operations
    JOIN duka_contragent c ON o.contragent_id_contragent = c.id_contragent
    JOIN duka_employee e ON o.employee_id_employee = e.id_employee
    WHERE o.operation_type_id_operation_type = 1 -- Продажа
    AND o.operation_status_id_operation_status = 4 -- Отменена
    AND o.operation_date BETWEEN @StartDate AND @EndDate
    GROUP BY o.id_operations, o.operation_date, o.doc_num, c.org_name,
             e.last_name, e.first_name, o.comments
    ORDER BY o.operation_date;
END;
GO

-- Процедура для получения отчета по продажам товаров
CREATE OR ALTER PROCEDURE GetProductSalesReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY gc.goods_category, g.goods_name) as 'Номер',
        gc.goods_category as 'Категория',
        g.goods_name as 'Товар',
        COUNT(DISTINCT o.id_operations) as 'Количество продаж',
        SUM(ol.quantity) as 'Продано единиц',
        AVG(ol.prise_with_discount) as 'Средняя цена',
        SUM(ol.quantity * ol.prise_with_discount) as 'Общая сумма',
        (SELECT TOP 1 ol2.prise_with_discount 
         FROM duka_operation_list ol2
         JOIN duka_operations o2 ON ol2.operations_id_operations = o2.id_operations
         WHERE ol2.goods_id_goods = g.id_goods
         AND o2.operation_type_id_operation_type = 2 -- Закупка
         ORDER BY o2.operation_date DESC) as 'Текущая закупочная цена'
    FROM duka_goods g
    JOIN duka_goods_category gc ON g.goods_category_id_goods_category = gc.id_goods_category
    LEFT JOIN duka_operation_list ol ON g.id_goods = ol.goods_id_goods
    LEFT JOIN duka_operations o ON ol.operations_id_operations = o.id_operations
                               AND o.operation_type_id_operation_type = 1 -- Продажа
                               AND o.operation_status_id_operation_status = 3 -- Выполнена
                               AND o.operation_date BETWEEN @StartDate AND @EndDate
    GROUP BY gc.goods_category, g.id_goods, g.goods_name
    HAVING SUM(ol.quantity) > 0
    ORDER BY gc.goods_category, g.goods_name;
END;
GO

-- Процедура для получения отчета по продажам в разрезе клиентов
CREATE OR ALTER PROCEDURE GetSalesByClientsReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY SUM(ol.quantity * ol.prise_with_discount) DESC) as 'Номер',
        c.org_name as 'Клиент',
        d.district as 'Район',
        COUNT(DISTINCT o.id_operations) as 'Количество заказов',
        SUM(ol.quantity) as 'Количество товаров',
        SUM(ol.quantity * ol.prise_with_discount) as 'Сумма продаж',
        MAX(o.operation_date) as 'Последняя покупка',
        c.pers_discount * 100 as 'Персональная скидка %'
    FROM duka_contragent c
    JOIN duka_district d ON c.district_id_district = d.id_district
    JOIN duka_operations o ON c.id_contragent = o.contragent_id_contragent
    JOIN duka_operation_list ol ON o.id_operations = ol.operations_id_operations
    WHERE o.operation_type_id_operation_type = 1 -- Продажа
    AND o.operation_status_id_operation_status = 3 -- Выполнена
    AND o.operation_date BETWEEN @StartDate AND @EndDate
    GROUP BY c.id_contragent, c.org_name, d.district, c.pers_discount
    ORDER BY SUM(ol.quantity * ol.prise_with_discount) DESC;
END;
GO

-- Процедура для получения отчета по оплатам клиентов
CREATE OR ALTER PROCEDURE GetClientPaymentReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY p.payment_date) as 'Номер',
        p.payment_date as 'Дата платежа',
        c.org_name as 'Клиент',
        o.doc_num as 'Номер документа',
        o.operation_date as 'Дата продажи',
        p.payment_sum as 'Сумма платежа',
        pt.payment_type as 'Способ оплаты',
        e.last_name + ' ' + e.first_name as 'Принял',
        p.payment_comments as 'Комментарий'
    FROM duka_payments p
    JOIN duka_operations o ON p.operations_id_operations = o.id_operations
    JOIN duka_contragent c ON o.contragent_id_contragent = c.id_contragent
    JOIN duka_payment_type pt ON p.payment_type_id_payment_type = pt.id_payment_type
    JOIN duka_employee e ON o.employee_id_employee = e.id_employee
    WHERE o.operation_type_id_operation_type = 1 -- Продажа
    AND p.payment_date BETWEEN @StartDate AND @EndDate
    ORDER BY p.payment_date;
END;
GO

-- Процедура для получения отчета по заказам клиентов продавца
CREATE OR ALTER PROCEDURE GetSellersClientOrdersReport
    @SellerId INT,
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY o.operation_date) as 'Номер',
        o.operation_date as 'Дата',
        o.doc_num as 'Номер документа',
        c.org_name as 'Клиент',
        COUNT(ol.id_operation_list) as 'Позиций',
        SUM(ol.quantity) as 'Количество',
        SUM(ol.quantity * ol.prise_with_discount) as 'Сумма',
        os.operation_status as 'Статус',
        ISNULL(p.payment_sum, 0) as 'Оплачено',
        CASE 
            WHEN p.payment_sum IS NULL THEN 'Не оплачен'
            WHEN p.payment_sum < SUM(ol.quantity * ol.prise_with_discount) THEN 'Частично оплачен'
            ELSE 'Полностью оплачен'
        END as 'Статус оплаты'
    FROM duka_operations o
    JOIN duka_operation_list ol ON o.id_operations = ol.operations_id_operations
    JOIN duka_contragent c ON o.contragent_id_contragent = c.id_contragent
    JOIN duka_operation_status os ON o.operation_status_id_operation_status = os.id_operation_status
    LEFT JOIN duka_payments p ON o.id_operations = p.operations_id_operations
    WHERE o.operation_type_id_operation_type = 1 -- Продажа
    AND o.employee_id_employee = @SellerId
    AND o.operation_date BETWEEN @StartDate AND @EndDate
    GROUP BY o.id_operations, o.operation_date, o.doc_num, c.org_name,
             os.operation_status, p.payment_sum
    ORDER BY o.operation_date;
END;
GO

-- Процедуры для работы с операциями
CREATE OR ALTER PROCEDURE UpdateOperationStatus
    @operation_id INT,
    @status_id INT,
    @comments NVARCHAR(145) = NULL
AS
BEGIN
    UPDATE duka_operations
    SET operation_status_id_operation_status = @status_id,
        comments = ISNULL(@comments, comments)
    WHERE id_operations = @operation_id;
END
GO

-- Процедура для создания новой операции с позициями
CREATE OR ALTER PROCEDURE CreateOperationWithItems
    @date DATE,
    @doc_num NVARCHAR(45),
    @comments NVARCHAR(145),
    @contragent_id INT,
    @operation_type_id INT,
    @employee_id INT,
    @status_id INT,
    @items duka_operation_items READONLY
AS
BEGIN
    BEGIN TRANSACTION;
    
    DECLARE @operation_id INT;
    
    INSERT INTO duka_operations (
        operation_date, doc_num, comments,
        contragent_id_contragent, operation_type_id_operation_type,
        employee_id_employee, operation_status_id_operation_status
    )
    VALUES (
        @date, @doc_num, @comments,
        @contragent_id, @operation_type_id,
        @employee_id, @status_id
    );
    
    SET @operation_id = SCOPE_IDENTITY();
    
    INSERT INTO duka_operation_list (
        quantity, prise_with_discount,
        operations_id_operations, operation_list_id_operation_list,
        goods_id_goods, wharehouse_id_wharehouse
    )
    SELECT 
        quantity, price_with_discount,
        @operation_id, parent_operation_list_id,
        goods_id, warehouse_id
    FROM @items;
    
    COMMIT TRANSACTION;
    
    SELECT @operation_id AS created_operation_id;
END
GO

-- Процедура для обновления цен в прайс-листе
CREATE OR ALTER PROCEDURE UpdatePriceList
    @goods_id INT,
    @new_price FLOAT,
    @promotion_id INT = NULL
AS
BEGIN
    UPDATE duka_price_list
    SET price_list = @new_price
    WHERE goods_id_goods = @goods_id
    AND (@promotion_id IS NULL OR promoutions_id_promoutions = @promotion_id);
END
GO

-- Процедура для расчета остатков на складе
CREATE OR ALTER PROCEDURE CalculateWarehouseStock
    @warehouse_id INT = NULL,
    @goods_id INT = NULL
AS
BEGIN
    SELECT 
        w.wharehouse as 'Склад',
        g.goods_name as 'Товар',
        gc.goods_category as 'Категория',
        SUM(CAST(ol.quantity as float)) as 'Количество',
        AVG(ol.prise_with_discount) as 'Средняя цена'
    FROM duka_operation_list ol
    JOIN duka_wharehouse w ON w.id_wharehouse = ol.wharehouse_id_wharehouse
    JOIN duka_goods g ON g.id_goods = ol.goods_id_goods
    JOIN duka_goods_category gc ON gc.id_goods_category = g.goods_category_id_goods_category
    WHERE (@warehouse_id IS NULL OR w.id_wharehouse = @warehouse_id)
    AND (@goods_id IS NULL OR g.id_goods = @goods_id)
    GROUP BY w.wharehouse, g.goods_name, gc.goods_category;
END
GO

-- Процедура для создания списания
CREATE OR ALTER PROCEDURE CreateWriteOff
    @operation_list_id INT,
    @write_off_type_id INT,
    @amount FLOAT,
    @comments NVARCHAR(245),
    @date DATE = NULL
AS
BEGIN
    INSERT INTO duka_write_off_list (
        write_off_amount,
        operation_list_id_operation_list,
        write_off_types_id_write_off_types,
        write_off_date,
        write_off_comments
    )
    VALUES (
        @amount,
        @operation_list_id,
        @write_off_type_id,
        ISNULL(@date, GETDATE()),
        @comments
    );
END
GO

-- Процедура для создания выплаты сотруднику
CREATE OR ALTER PROCEDURE CreateEmployeePayment
    @employee_id INT,
    @amount FLOAT,
    @reason_type_id INT,
    @comments NVARCHAR(545),
    @date DATE = NULL
AS
BEGIN
    INSERT INTO duka_earning_payments (
        earning_payments_amount,
        earning_payments_date,
        earning_payments_comments,
        employee_id_employee,
        reason_type_id_reason_type
    )
    VALUES (
        @amount,
        ISNULL(@date, GETDATE()),
        @comments,
        @employee_id,
        @reason_type_id
    );
END
GO

-- Процедура для создания акции
CREATE OR ALTER PROCEDURE CreatePromotion
    @name NVARCHAR(45),
    @discount FLOAT,
    @comment NVARCHAR(450),
    @start_date DATE,
    @end_date DATE,
    @event_type_id INT,
    @goods_ids duka_goods_list READONLY
AS
BEGIN
    BEGIN TRANSACTION;
    
    DECLARE @promotion_id INT;
    
    INSERT INTO duka_promoutions (
        promoutions_name,
        discount_value,
        promoution_comment,
        promoution_date_start,
        promoution_date_end,
        event_type_id_event_type
    )
    VALUES (
        @name,
        @discount,
        @comment,
        @start_date,
        @end_date,
        @event_type_id
    );
    
    SET @promotion_id = SCOPE_IDENTITY();
    
    -- Создаем записи в прайс-листе для товаров со скидкой
    INSERT INTO duka_price_list (
        price_list,
        goods_id_goods,
        promoutions_id_promoutions
    )
    SELECT 
        (SELECT price_list * (1 - @discount) 
         FROM duka_price_list 
         WHERE goods_id_goods = goods_id 
         AND promoutions_id_promoutions IS NULL),
        goods_id,
        @promotion_id
    FROM @goods_ids;
    
    COMMIT TRANSACTION;
    
    SELECT @promotion_id AS created_promotion_id;
END
GO

-- Процедура для получения истории операций контрагента
CREATE OR ALTER PROCEDURE GetContragentHistory
    @contragent_id INT,
    @start_date DATE = NULL,
    @end_date DATE = NULL
AS
BEGIN
    SELECT 
        o.operation_date as 'Дата',
        o.doc_num as 'Документ',
        ot.operation_type as 'Тип операции',
        os.operation_status as 'Статус',
        g.goods_name as 'Товар',
        ol.quantity as 'Количество',
        ol.prise_with_discount as 'Цена',
        ol.prise_with_discount * CAST(ol.quantity as float) as 'Сумма',
        e.last_name + ' ' + e.first_name as 'Сотрудник'
    FROM duka_operations o
    JOIN duka_operation_type ot ON ot.id_operation_type = o.operation_type_id_operation_type
    JOIN duka_operation_status os ON os.id_operation_status = o.operation_status_id_operation_status
    JOIN duka_operation_list ol ON ol.operations_id_operations = o.id_operations
    JOIN duka_goods g ON g.id_goods = ol.goods_id_goods
    JOIN duka_employee e ON e.id_employee = o.employee_id_employee
    WHERE o.contragent_id_contragent = @contragent_id
    AND (@start_date IS NULL OR o.operation_date >= @start_date)
    AND (@end_date IS NULL OR o.operation_date <= @end_date)
    ORDER BY o.operation_date DESC;
END
GO

-- Создание пользовательских типов данных для параметров процедур
CREATE TYPE duka_operation_items AS TABLE
(
    quantity NVARCHAR(45),
    price_with_discount FLOAT,
    parent_operation_list_id INT,
    goods_id INT,
    warehouse_id INT
);
GO

CREATE TYPE duka_goods_list AS TABLE
(
    goods_id INT
);
GO
