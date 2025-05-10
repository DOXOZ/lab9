USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'duka')
BEGIN
    ALTER DATABASE duka SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE duka;
END
GO

CREATE DATABASE duka;
GO

USE duka;
GO

-- 1. Тип контрагента
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_contragent_type') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_contragent_type (
        id_contragent_type INT IDENTITY(1,1) PRIMARY KEY,
        contragent_type VARCHAR(50) NOT NULL
    );
END
GO

-- 2. Район
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_district') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_district (
        id_district INT IDENTITY(1,1) PRIMARY KEY,
        district VARCHAR(50) NOT NULL
    );
END
GO

-- 3. Контрагент
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_contragent') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_contragent (
        id_contragent INT IDENTITY(1,1) PRIMARY KEY,
        first_name VARCHAR(50) NOT NULL,
        middle_name VARCHAR(50),
        last_name VARCHAR(50) NOT NULL,
        org_name VARCHAR(100),
        passport_num VARCHAR(20),
        position VARCHAR(50),
        login_ VARCHAR(50) NOT NULL,
        psw VARCHAR(50) NOT NULL,
        reg_date DATE NOT NULL,
        pers_discount DECIMAL(5,2),
        contragent_type_id_contragent_type INT NOT NULL,
        phone VARCHAR(20),
        district_id_district INT,
        FOREIGN KEY (contragent_type_id_contragent_type) REFERENCES duka_contragent_type(id_contragent_type),
        FOREIGN KEY (district_id_district) REFERENCES duka_district(id_district)
    );
END
GO

-- Indexes for contragent
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_contragent_contragent_type'
)
BEGIN
    CREATE INDEX idx_duka_contragent_contragent_type 
        ON duka_contragent (contragent_type_id_contragent_type);
END
GO
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_contragent_district'
)
BEGIN
    CREATE INDEX idx_duka_contragent_district 
        ON duka_contragent (district_id_district);
END
GO

-- 4. Должности
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_positions') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_positions (
        id_positions INT IDENTITY(1,1) PRIMARY KEY,
        positions VARCHAR(50) NOT NULL
    );
END
GO

-- 5. Сотрудник
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_employee') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_employee (
        id_employee INT IDENTITY(1,1) PRIMARY KEY,
        first_name VARCHAR(50) NOT NULL,
        middle_name VARCHAR(50),
        last_name VARCHAR(50) NOT NULL,
        reg_date DATE NOT NULL,
        emp_login VARCHAR(50) NOT NULL,
        emp_password VARCHAR(50) NOT NULL,
        emp_phone VARCHAR(20),
        emp_month_salary DECIMAL(10,2),
        positions_id_positions INT NOT NULL,
        FOREIGN KEY (positions_id_positions) REFERENCES duka_positions(id_positions)
    );
END
GO

-- Index for employee
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_employee_positions'
)
BEGIN
    CREATE INDEX idx_duka_employee_positions 
        ON duka_employee (positions_id_positions);
END
GO

-- 6. Статус операции
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_operation_status') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_operation_status (
        id_operation_status INT IDENTITY(1,1) PRIMARY KEY,
        operation_status VARCHAR(50) NOT NULL
    );
END
GO

-- 7. Операции
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_operations') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_operations (
        id_operations INT IDENTITY(1,1) PRIMARY KEY,
        operation_date DATE NOT NULL,
        doc_num VARCHAR(20) NOT NULL,
        comments TEXT,
        contragent_id_contragent INT NOT NULL,
        operation_type_id_operation_type INT NOT NULL,
        employee_id_employee INT NOT NULL,
        operation_status_id_operation_status INT NOT NULL,
        FOREIGN KEY (contragent_id_contragent) REFERENCES duka_contragent(id_contragent),
        FOREIGN KEY (operation_type_id_operation_type) REFERENCES duka_operation_type(id_operation_type),
        FOREIGN KEY (employee_id_employee) REFERENCES duka_employee(id_employee),
        FOREIGN KEY (operation_status_id_operation_status) REFERENCES duka_operation_status(id_operation_status)
    );
END
GO

-- Indexes for operations
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_operations_contragent'
)
BEGIN
    CREATE INDEX idx_duka_operations_contragent 
        ON duka_operations (contragent_id_contragent);
END
GO
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_operations_employee'
)
BEGIN
    CREATE INDEX idx_duka_operations_employee 
        ON duka_operations (employee_id_employee);
END
GO
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_operations_status'
)
BEGIN
    CREATE INDEX idx_duka_operations_status 
        ON duka_operations (operation_status_id_operation_status);
END
GO

-- 8. Категория товара
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_goods_category') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_goods_category (
        id_goods_category INT IDENTITY(1,1) PRIMARY KEY,
        goods_category VARCHAR(50) NOT NULL
    );
END
GO

-- 9. Товары
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_goods') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_goods (
        id_goods INT IDENTITY(1,1) PRIMARY KEY,
        goods_name VARCHAR(100) NOT NULL,
        goods_comments TEXT,
        goods_category_id_goods_category INT NOT NULL,
        FOREIGN KEY (goods_category_id_goods_category) REFERENCES duka_goods_category(id_goods_category)
    );
END
GO

-- Index for goods
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_goods_category'
)
BEGIN
    CREATE INDEX idx_duka_goods_category 
        ON duka_goods (goods_category_id_goods_category);
END
GO

-- 10. Склад
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_wharehouse') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_wharehouse (
        id_wharehouse INT IDENTITY(1,1) PRIMARY KEY,
        wharehouse VARCHAR(50) NOT NULL
    );
END
GO

-- 11. Список позиций операции
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_operation_list') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_operation_list (
        id_operation_list INT IDENTITY(1,1) PRIMARY KEY,
        quantity DECIMAL(10,2) NOT NULL,
        prise_with_discount DECIMAL(10,2) NOT NULL,
        operations_id_operations INT NOT NULL,
        operation_list_id_operation_list INT,
        goods_id_goods INT NOT NULL,
        wharehouse_id_wharehouse INT NOT NULL,
        FOREIGN KEY (operations_id_operations) REFERENCES duka_operations(id_operations),
        FOREIGN KEY (operation_list_id_operation_list) REFERENCES duka_operation_list(id_operation_list),
        FOREIGN KEY (goods_id_goods) REFERENCES duka_goods(id_goods),
        FOREIGN KEY (wharehouse_id_wharehouse) REFERENCES duka_wharehouse(id_wharehouse)
    );
END
GO

-- Indexes for operation_list
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_oplist_operations'
)
BEGIN
    CREATE INDEX idx_duka_oplist_operations 
        ON duka_operation_list (operations_id_operations);
END
GO
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_oplist_parent'
)
BEGIN
    CREATE INDEX idx_duka_oplist_parent 
        ON duka_operation_list (operation_list_id_operation_list);
END
GO
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_oplist_goods'
)
BEGIN
    CREATE INDEX idx_duka_oplist_goods 
        ON duka_operation_list (goods_id_goods);
END
GO
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_oplist_wh'
)
BEGIN
    CREATE INDEX idx_duka_oplist_wh 
        ON duka_operation_list (wharehouse_id_wharehouse);
END
GO

-- 12. Тип события
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_event_type') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_event_type (
        id_event_type INT PRIMARY KEY,
        event_type VARCHAR(50) NOT NULL
    );
END
GO

-- 13. Акции (промоушены)
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_promoutions') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_promoutions (
        id_promoutions INT IDENTITY(1,1) PRIMARY KEY,
        promoutions_name VARCHAR(100) NOT NULL,
        discount_value DECIMAL(5,2) NOT NULL,
        promoution_comment TEXT,
        promoution_date_start DATE NOT NULL,
        promoution_date_end DATE NOT NULL,
        event_type_id_event_type INT NOT NULL,
        FOREIGN KEY (event_type_id_event_type) REFERENCES duka_event_type(id_event_type)
    );
END
GO

-- Index for promoutions
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_promoutions_event'
)
BEGIN
    CREATE INDEX idx_duka_promoutions_event 
        ON duka_promoutions (event_type_id_event_type);
END
GO

-- 14. Прайс-лист
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_price_list') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_price_list (
        id_price_list INT IDENTITY(1,1) PRIMARY KEY,
        price_list DECIMAL(10,2) NOT NULL,
        goods_id_goods INT NOT NULL,
        promoutions_id_promoutions INT,
        FOREIGN KEY (goods_id_goods) REFERENCES duka_goods(id_goods),
        FOREIGN KEY (promoutions_id_promoutions) REFERENCES duka_promoutions(id_promoutions)
    );
END
GO

-- Indexes for price_list
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_pricelist_goods'
)
BEGIN
    CREATE INDEX idx_duka_pricelist_goods 
        ON duka_price_list (goods_id_goods);
END
GO
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_pricelist_prom'
)
BEGIN
    CREATE INDEX idx_duka_pricelist_prom 
        ON duka_price_list (promoutions_id_promoutions);
END
GO

-- 15. Тип списания
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_write_off_types') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_write_off_types (
        id_write_off_types INT IDENTITY(1,1) PRIMARY KEY,
        write_off_types VARCHAR(50) NOT NULL
    );
END
GO

-- 16. Списание
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_write_off_list') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_write_off_list (
        id_write_off_list INT IDENTITY(1,1) PRIMARY KEY,
        write_off_amount DECIMAL(10,2) NOT NULL,
        operation_list_id_operation_list INT NOT NULL,
        write_off_types_id_write_off_types INT NOT NULL,
        write_off_date DATE NOT NULL,
        write_off_comments TEXT,
        FOREIGN KEY (operation_list_id_operation_list) REFERENCES duka_operation_list(id_operation_list),
        FOREIGN KEY (write_off_types_id_write_off_types) REFERENCES duka_write_off_types(id_write_off_types)
    );
END
GO

-- Indexes for write_off_list
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_wolist_oplist'
)
BEGIN
    CREATE INDEX idx_duka_wolist_oplist 
        ON duka_write_off_list (operation_list_id_operation_list);
END
GO
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_wolist_type'
)
BEGIN
    CREATE INDEX idx_duka_wolist_type 
        ON duka_write_off_list (write_off_types_id_write_off_types);
END
GO

-- 17. Причина платежа/списания
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_reason_type') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_reason_type (
        id_reason_type INT IDENTITY(1,1) PRIMARY KEY,
        reason_type VARCHAR(50) NOT NULL
    );
END
GO

-- 18. Выплаты сотрудникам
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_earning_payments') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_earning_payments (
        id_earning_payments INT IDENTITY(1,1) PRIMARY KEY,
        earning_payments_amount DECIMAL(10,2) NOT NULL,
        earning_payments_date DATE NOT NULL,
        earning_payments_comments TEXT,
        employee_id_employee INT NOT NULL,
        reason_type_id_reason_type INT NOT NULL,
        FOREIGN KEY (employee_id_employee) REFERENCES duka_employee(id_employee),
        FOREIGN KEY (reason_type_id_reason_type) REFERENCES duka_reason_type(id_reason_type)
    );
END
GO

-- Indexes for earning_payments
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_epay_employee'
)
BEGIN
    CREATE INDEX idx_duka_epay_employee 
        ON duka_earning_payments (employee_id_employee);
END
GO
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_epay_reason'
)
BEGIN
    CREATE INDEX idx_duka_epay_reason 
        ON duka_earning_payments (reason_type_id_reason_type);
END
GO

-- 19. Тип оплаты
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_payment_type') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_payment_type (
        id_payment_type INT IDENTITY(1,1) PRIMARY KEY,
        payment_type VARCHAR(50) NOT NULL
    );
END
GO

-- 20. Платежи по операциям
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_payments') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_payments (
        id_payments INT IDENTITY(1,1) PRIMARY KEY,
        payment_date DATE NOT NULL,
        payment_sum DECIMAL(10,2) NOT NULL,
        payment_comments TEXT,
        operations_id_operations INT NOT NULL,
        payment_type_id_payment_type INT NOT NULL,
        FOREIGN KEY (operations_id_operations) REFERENCES duka_operations(id_operations),
        FOREIGN KEY (payment_type_id_payment_type) REFERENCES duka_payment_type(id_payment_type)
    );
END
GO

-- Indexes for payments
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_pay_ops'
)
BEGIN
    CREATE INDEX idx_duka_pay_ops 
        ON duka_payments (operations_id_operations);
END
GO
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_pay_type'
)
BEGIN
    CREATE INDEX idx_duka_pay_type 
        ON duka_payments (payment_type_id_payment_type);
END
GO

-- 21. Налоги
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_taxes') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_taxes (
        id_taxes INT IDENTITY(1,1) PRIMARY KEY,
        taxe_name VARCHAR(50) NOT NULL,
        tax_rate DECIMAL(5,2) NOT NULL
    );
END
GO

-- 22. Тип пользователя (для отчётов)
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_user_type') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_user_type (
        id_user_type INT IDENTITY(1,1) PRIMARY KEY,
        user_type VARCHAR(50) NOT NULL
    );
END
GO

-- 23. Отчеты
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_reports') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_reports (
        id_reports INT IDENTITY(1,1) PRIMARY KEY,
        id_user INT NOT NULL,
        report_date DATETIME NOT NULL,
        report_id INT NOT NULL,
        user_type_id_user_type INT NOT NULL,
        FOREIGN KEY (user_type_id_user_type) REFERENCES duka_user_type(id_user_type)
    );
END
GO

-- Index for reports
IF NOT EXISTS (
    SELECT * FROM sys.indexes 
    WHERE name = 'idx_duka_reports_user_type'
)
BEGIN
    CREATE INDEX idx_duka_reports_user_type 
        ON duka_reports (user_type_id_user_type);
END
GO

-- 24. Тип операции
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'duka_operation_type') 
      AND type = N'U'
)
BEGIN
    CREATE TABLE duka_operation_type (
        id_operation_type INT IDENTITY(1,1) PRIMARY KEY,
        operation_type VARCHAR(50) NOT NULL
    );
END
GO

-- Создание хранимых процедур

-- Процедура для получения остатков на складе
CREATE OR ALTER PROCEDURE GetWarehouseRemainders
    @warehouse_id INT = NULL
AS
BEGIN
    SELECT 
        w.wharehouse as 'Склад',
        gc.goods_category as 'Тип товара',
        g.goods_name as 'Товар',
        SUM(CAST(ol.quantity AS float)) as 'Количество',
        AVG(ol.prise_with_discount) as 'Цена'
    FROM duka_operation_list ol
    JOIN duka_wharehouse w ON w.id_wharehouse = ol.wharehouse_id_wharehouse
    JOIN duka_goods g ON g.id_goods = ol.goods_id_goods
    JOIN duka_goods_category gc ON gc.id_goods_category = g.goods_category_id_goods_category
    WHERE (@warehouse_id IS NULL OR w.id_wharehouse = @warehouse_id)
    GROUP BY w.wharehouse, gc.goods_category, g.goods_name;
END
GO

-- Процедура для получения задолженностей клиентов
CREATE OR ALTER PROCEDURE GetClientDebts
AS
BEGIN
    SELECT 
        c.org_name as 'Клиент',
        SUM(p.payment_sum) as 'Сумма задолженности',
        MAX(p.payment_date) as 'Дата последней оплаты'
    FROM duka_contragent c
    JOIN duka_operations o ON o.contragent_id_contragent = c.id_contragent
    JOIN duka_payments p ON p.operations_id_operations = o.id_operations
    GROUP BY c.org_name
    HAVING SUM(p.payment_sum) > 0;
END
GO

-- Процедура для получения прибыли по товарам
CREATE OR ALTER PROCEDURE GetProductProfit
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SELECT 
        g.goods_name as 'Товар',
        COUNT(DISTINCT o.id_operations) as 'Количество продаж',
        SUM(ol.prise_with_discount * CAST(ol.quantity AS float)) as 'Выручка',
        SUM(ol.prise_with_discount * CAST(ol.quantity AS float)) * 0.7 as 'Затраты',
        SUM(ol.prise_with_discount * CAST(ol.quantity AS float)) * 0.3 as 'Прибыль'
    FROM duka_goods g
    JOIN duka_operation_list ol ON ol.goods_id_goods = g.id_goods
    JOIN duka_operations o ON o.id_operations = ol.operations_id_operations
    WHERE o.operation_date BETWEEN @start_date AND @end_date
    GROUP BY g.goods_name;
END
GO

-- Процедура для получения продаж по складам
CREATE OR ALTER PROCEDURE GetSalesByWarehouse
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SELECT 
        w.wharehouse as 'Склад',
        COUNT(DISTINCT o.id_operations) as 'Количество отгрузок',
        SUM(ol.prise_with_discount * CAST(ol.quantity AS float)) as 'Сумма продаж'
    FROM duka_wharehouse w
    JOIN duka_operation_list ol ON ol.wharehouse_id_wharehouse = w.id_wharehouse
    JOIN duka_operations o ON o.id_operations = ol.operations_id_operations
    WHERE o.operation_date BETWEEN @start_date AND @end_date
    GROUP BY w.wharehouse;
END
GO

-- Процедура для получения зарплат сотрудников
CREATE OR ALTER PROCEDURE GetEmployeeSalaries
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SELECT 
        e.last_name + ' ' + e.first_name as 'Сотрудник',
        ep.earning_payments_date as 'Дата',
        ep.earning_payments_amount as 'Начислено',
        ep.earning_payments_amount as 'Оплачено'
    FROM duka_employee e
    JOIN duka_earning_payments ep ON ep.employee_id_employee = e.id_employee
    WHERE ep.earning_payments_date BETWEEN @start_date AND @end_date;
END
GO

-- Создание триггеров для автоматического обновления данных
GO

CREATE TRIGGER trg_update_stock
ON duka_operation_list
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Обновление остатков на складе
    UPDATE ol
    SET quantity = CASE
        WHEN o.operation_type_id_operation_type IN (2, 3) -- Закупка или возврат от покупателя
        THEN ol.quantity + i.quantity
        WHEN o.operation_type_id_operation_type IN (1, 4) -- Продажа или возврат поставщику
        THEN ol.quantity - i.quantity
        ELSE ol.quantity
    END
    FROM duka_operation_list ol
    JOIN inserted i ON i.goods_id_goods = ol.goods_id_goods 
                   AND i.wharehouse_id_wharehouse = ol.wharehouse_id_wharehouse
    JOIN duka_operations o ON i.operations_id_operations = o.id_operations
    WHERE o.operation_status_id_operation_status = 3; -- Выполнена
END;
GO

CREATE TRIGGER trg_check_stock
ON duka_operation_list
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Проверка наличия достаточного количества товара
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN duka_operations o ON i.operations_id_operations = o.id_operations
        WHERE o.operation_type_id_operation_type = 1 -- Продажа
        AND NOT EXISTS (
            SELECT 1
            FROM duka_operation_list ol
            WHERE ol.goods_id_goods = i.goods_id_goods
            AND ol.wharehouse_id_wharehouse = i.wharehouse_id_wharehouse
            GROUP BY ol.goods_id_goods, ol.wharehouse_id_wharehouse
            HAVING SUM(CASE
                WHEN o.operation_type_id_operation_type IN (2, 3) THEN ol.quantity
                WHEN o.operation_type_id_operation_type IN (1, 4) THEN -ol.quantity
                ELSE 0
            END) >= i.quantity
        )
    )
    BEGIN
        RAISERROR ('Недостаточно товара на складе', 16, 1);
        RETURN;
    END

    -- Если проверка пройдена, вставляем данные
    INSERT INTO duka_operation_list (
        quantity, prise_with_discount, operations_id_operations,
        operation_list_id_operation_list, goods_id_goods, wharehouse_id_wharehouse
    )
    SELECT 
        quantity, prise_with_discount, operations_id_operations,
        operation_list_id_operation_list, goods_id_goods, wharehouse_id_wharehouse
    FROM inserted;
END;
GO

-- Создание представлений для часто используемых запросов
CREATE VIEW view_current_stock
AS
SELECT 
    w.wharehouse,
    g.goods_name,
    gc.goods_category,
    ISNULL(SUM(CASE
        WHEN o.operation_type_id_operation_type IN (2, 3) THEN ol.quantity
        WHEN o.operation_type_id_operation_type IN (1, 4) THEN -ol.quantity
        ELSE 0
    END), 0) as current_quantity,
    MAX(CASE
        WHEN o.operation_type_id_operation_type = 2 THEN ol.prise_with_discount
        ELSE NULL
    END) as last_purchase_price
FROM duka_wharehouse w
CROSS JOIN duka_goods g
JOIN duka_goods_category gc ON g.goods_category_id_goods_category = gc.id_goods_category
LEFT JOIN duka_operation_list ol ON g.id_goods = ol.goods_id_goods 
                                AND w.id_wharehouse = ol.wharehouse_id_wharehouse
LEFT JOIN duka_operations o ON ol.operations_id_operations = o.id_operations
                          AND o.operation_status_id_operation_status = 3
GROUP BY w.wharehouse, g.goods_name, gc.goods_category;
GO

CREATE VIEW view_current_prices
AS
SELECT 
    g.goods_name,
    gc.goods_category,
    pl.price_list as base_price,
    ISNULL(p.discount_value, 0) as current_discount,
    CASE 
        WHEN p.id_promoutions IS NOT NULL 
        AND GETDATE() BETWEEN p.promoution_date_start AND p.promoution_date_end
        THEN pl.price_list * (1 - p.discount_value)
        ELSE pl.price_list
    END as current_price,
    p.promoutions_name as active_promotion
FROM duka_goods g
JOIN duka_goods_category gc ON g.goods_category_id_goods_category = gc.id_goods_category
LEFT JOIN duka_price_list pl ON g.id_goods = pl.goods_id_goods
LEFT JOIN duka_promoutions p ON pl.promoutions_id_promoutions = p.id_promoutions
                            AND GETDATE() BETWEEN p.promoution_date_start AND p.promoution_date_end;
GO

CREATE VIEW view_employee_performance
AS
SELECT 
    e.last_name + ' ' + e.first_name as employee_name,
    p.positions as position,
    COUNT(DISTINCT o.id_operations) as total_operations,
    SUM(ol.quantity * ol.prise_with_discount) as total_sales_amount,
    AVG(ol.quantity * ol.prise_with_discount) as avg_operation_amount,
    MAX(o.operation_date) as last_operation_date
FROM duka_employee e
JOIN duka_positions p ON e.positions_id_positions = p.id_positions
LEFT JOIN duka_operations o ON e.id_employee = o.employee_id_employee
LEFT JOIN duka_operation_list ol ON o.id_operations = ol.operations_id_operations
WHERE o.operation_type_id_operation_type = 1 -- Продажа
AND o.operation_status_id_operation_status = 3 -- Выполнена
GROUP BY e.last_name, e.first_name, p.positions;
GO