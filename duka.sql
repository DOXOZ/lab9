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
        id_contragent_type INT NOT NULL IDENTITY(1,1),
        contragent_type NVARCHAR(45) NULL,
        PRIMARY KEY (id_contragent_type)
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
        id_district INT NOT NULL IDENTITY(1,1),
        district NVARCHAR(45) NULL,
        PRIMARY KEY (id_district)
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
        id_contragent INT NOT NULL IDENTITY(1,1),
        first_name NVARCHAR(45) NULL,
        middle_name NVARCHAR(45) NULL,
        last_name NVARCHAR(45) NULL,
        org_name NVARCHAR(45) NULL,
        passport_num NVARCHAR(45) NULL,
        position NVARCHAR(145) NULL,
        login_ NVARCHAR(45) NULL,
        psw NVARCHAR(45) NULL,
        reg_date NVARCHAR(45) NULL,
        pers_discount FLOAT NULL,
        contragent_type_id_contragent_type INT NOT NULL,
        phone NVARCHAR(45) NULL,
        district_id_district INT NOT NULL,
        PRIMARY KEY (id_contragent),
        CONSTRAINT fk_duka_contragent_type
            FOREIGN KEY (contragent_type_id_contragent_type)
            REFERENCES duka_contragent_type (id_contragent_type),
        CONSTRAINT fk_duka_district
            FOREIGN KEY (district_id_district)
            REFERENCES duka_district (id_district)
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
        id_positions INT NOT NULL IDENTITY(1,1),
        positions NVARCHAR(45) NULL,
        PRIMARY KEY (id_positions)
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
        id_employee INT NOT NULL IDENTITY(1,1),
        first_name NVARCHAR(45) NULL,
        middle_name NVARCHAR(45) NULL,
        last_name NVARCHAR(45) NULL,
        reg_date DATE NULL,
        emp_login NVARCHAR(45) NULL,
        emp_password NVARCHAR(45) NULL,
        emp_phone NVARCHAR(45) NULL,
        emp_month_salary FLOAT NULL,
        positions_id_positions INT NOT NULL,
        PRIMARY KEY (id_employee),
        CONSTRAINT fk_duka_employee_positions
            FOREIGN KEY (positions_id_positions)
            REFERENCES duka_positions (id_positions)
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
        id_operation_status INT NOT NULL IDENTITY(1,1),
        operation_status NVARCHAR(45) NULL,
        PRIMARY KEY (id_operation_status)
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
        id_operations INT NOT NULL IDENTITY(1,1),
        operation_date DATE NULL,
        doc_num NVARCHAR(45) NULL,
        comments NVARCHAR(145) NULL,
        contragent_id_contragent INT NOT NULL,
        operation_type_id_operation_type INT NOT NULL,
        employee_id_employee INT NOT NULL,
        operation_status_id_operation_status INT NOT NULL,
        PRIMARY KEY (id_operations),
        CONSTRAINT fk_duka_operations_contragent
            FOREIGN KEY (contragent_id_contragent)
            REFERENCES duka_contragent (id_contragent),
        CONSTRAINT fk_duka_operations_employee
            FOREIGN KEY (employee_id_employee)
            REFERENCES duka_employee (id_employee),
        CONSTRAINT fk_duka_operations_status
            FOREIGN KEY (operation_status_id_operation_status)
            REFERENCES duka_operation_status (id_operation_status)
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
        id_goods_category INT NOT NULL IDENTITY(1,1),
        goods_category NVARCHAR(45) NULL,
        PRIMARY KEY (id_goods_category)
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
        id_goods INT NOT NULL IDENTITY(1,1),
        goods_name NVARCHAR(145) NULL,
        goods_comments NVARCHAR(245) NULL,
        goods_category_id_goods_category INT NOT NULL,
        PRIMARY KEY (id_goods),
        CONSTRAINT fk_duka_goods_category
            FOREIGN KEY (goods_category_id_goods_category)
            REFERENCES duka_goods_category (id_goods_category)
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
        id_wharehouse INT NOT NULL IDENTITY(1,1),
        wharehouse NVARCHAR(45) NULL,
        PRIMARY KEY (id_wharehouse)
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
        id_operation_list INT NOT NULL IDENTITY(1,1),
        quantity NVARCHAR(45) NULL,
        prise_with_discount FLOAT NULL,
        operations_id_operations INT NOT NULL,
        operation_list_id_operation_list INT NOT NULL,
        goods_id_goods INT NOT NULL,
        wharehouse_id_wharehouse INT NOT NULL,
        PRIMARY KEY (id_operation_list),
        CONSTRAINT fk_duka_oplist_operations
            FOREIGN KEY (operations_id_operations)
            REFERENCES duka_operations (id_operations),
        CONSTRAINT fk_duka_oplist_self
            FOREIGN KEY (operation_list_id_operation_list)
            REFERENCES duka_operation_list (id_operation_list),
        CONSTRAINT fk_duka_oplist_goods
            FOREIGN KEY (goods_id_goods)
            REFERENCES duka_goods (id_goods),
        CONSTRAINT fk_duka_oplist_wh
            FOREIGN KEY (wharehouse_id_wharehouse)
            REFERENCES duka_wharehouse (id_wharehouse)
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
        id_event_type INT NOT NULL,
        event_type NVARCHAR(145) NULL,
        PRIMARY KEY (id_event_type)
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
        id_promoutions INT NOT NULL IDENTITY(1,1),
        promoutions_name NVARCHAR(45) NULL,
        discount_value FLOAT NULL,
        promoution_comment NVARCHAR(450) NULL,
        promoution_date_start DATE NULL,
        promoution_date_end DATE NULL,
        event_type_id_event_type INT NOT NULL,
        PRIMARY KEY (id_promoutions),
        CONSTRAINT fk_duka_promoutions_event
            FOREIGN KEY (event_type_id_event_type)
            REFERENCES duka_event_type (id_event_type)
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
        id_price_list INT NOT NULL IDENTITY(1,1),
        price_list NVARCHAR(45) NULL,
        goods_id_goods INT NOT NULL,
        promoutions_id_promoutions INT NOT NULL,
        PRIMARY KEY (id_price_list),
        CONSTRAINT fk_duka_pricelist_goods
            FOREIGN KEY (goods_id_goods)
            REFERENCES duka_goods (id_goods),
        CONSTRAINT fk_duka_pricelist_prom
            FOREIGN KEY (promoutions_id_promoutions)
            REFERENCES duka_promoutions (id_promoutions)
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
        id_write_off_types INT NOT NULL IDENTITY(1,1),
        write_off_types NVARCHAR(45) NULL,
        PRIMARY KEY (id_write_off_types)
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
        id_write_off_list INT NOT NULL IDENTITY(1,1),
        write_off_amount FLOAT NULL,
        operation_list_id_operation_list INT NOT NULL,
        write_off_types_id_write_off_types INT NOT NULL,
        write_off_date DATE NULL,
        write_off_comments NVARCHAR(245) NULL,
        PRIMARY KEY (id_write_off_list),
        CONSTRAINT fk_duka_wolist_oplist
            FOREIGN KEY (operation_list_id_operation_list)
            REFERENCES duka_operation_list (id_operation_list),
        CONSTRAINT fk_duka_wolist_type
            FOREIGN KEY (write_off_types_id_write_off_types)
            REFERENCES duka_write_off_types (id_write_off_types)
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
        id_reason_type INT NOT NULL IDENTITY(1,1),
        reason_type NVARCHAR(45) NULL,
        PRIMARY KEY (id_reason_type)
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
        id_earning_payments INT NOT NULL IDENTITY(1,1),
        earning_payments_amount FLOAT NULL,
        earning_payments_date DATE NULL,
        earning_payments_comments NVARCHAR(545) NULL,
        employee_id_employee INT NOT NULL,
        reason_type_id_reason_type INT NOT NULL,
        PRIMARY KEY (id_earning_payments),
        CONSTRAINT fk_duka_epay_employee
            FOREIGN KEY (employee_id_employee)
            REFERENCES duka_employee (id_employee),
        CONSTRAINT fk_duka_epay_reason
            FOREIGN KEY (reason_type_id_reason_type)
            REFERENCES duka_reason_type (id_reason_type)
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
        id_payment_type INT NOT NULL IDENTITY(1,1),
        payment_type NVARCHAR(45) NULL,
        PRIMARY KEY (id_payment_type)
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
        id_payments INT NOT NULL IDENTITY(1,1),
        payment_date DATE NULL,
        payment_sum FLOAT NULL,
        payment_comments NVARCHAR(450) NULL,
        operations_id_operations INT NOT NULL,
        payment_type_id_payment_type INT NOT NULL,
        PRIMARY KEY (id_payments),
        CONSTRAINT fk_duka_pay_ops
            FOREIGN KEY (operations_id_operations)
            REFERENCES duka_operations (id_operations),
        CONSTRAINT fk_duka_pay_type
            FOREIGN KEY (payment_type_id_payment_type)
            REFERENCES duka_payment_type (id_payment_type)
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
        id_taxes INT NOT NULL IDENTITY(1,1),
        taxe_name NVARCHAR(450) NULL,
        tax_rate FLOAT NULL,
        PRIMARY KEY (id_taxes)
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
        id_user_type INT NOT NULL IDENTITY(1,1),
        user_type NVARCHAR(45) NULL,
        PRIMARY KEY (id_user_type)
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
        id_reports INT NOT NULL IDENTITY(1,1),
        id_user INT NULL,
        report_date DATETIME NULL,
        report_id INT NULL,
        user_type_id_user_type INT NOT NULL,
        PRIMARY KEY (id_reports),
        CONSTRAINT fk_reports_user_type
            FOREIGN KEY (user_type_id_user_type)
            REFERENCES duka_user_type (id_user_type)
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
        id_operation_type INT NOT NULL IDENTITY(1,1),
        operation_type NVARCHAR(45) NULL,
        PRIMARY KEY (id_operation_type)
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