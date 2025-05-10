USE duka;
GO

-- Процедура вставки типа контрагента
CREATE OR ALTER PROCEDURE InsertContragentType
    @contragent_type NVARCHAR(45)
AS
BEGIN
    INSERT INTO duka_contragent_type (contragent_type)
    VALUES (@contragent_type);
END
GO

-- Процедура вставки района
CREATE OR ALTER PROCEDURE InsertDistrict
    @district NVARCHAR(45)
AS
BEGIN
    INSERT INTO duka_district (district)
    VALUES (@district);
END
GO

-- Процедура вставки контрагента
CREATE OR ALTER PROCEDURE InsertContragent
    @first_name NVARCHAR(45),
    @middle_name NVARCHAR(45),
    @last_name NVARCHAR(45),
    @org_name NVARCHAR(45),
    @passport_num NVARCHAR(45),
    @position NVARCHAR(145),
    @login NVARCHAR(45),
    @psw NVARCHAR(45),
    @reg_date NVARCHAR(45),
    @pers_discount FLOAT,
    @contragent_type_id INT,
    @phone NVARCHAR(45),
    @district_id INT
AS
BEGIN
    INSERT INTO duka_contragent (
        first_name, middle_name, last_name, org_name, 
        passport_num, position, login_, psw, reg_date, 
        pers_discount, contragent_type_id_contragent_type, 
        phone, district_id_district
    )
    VALUES (
        @first_name, @middle_name, @last_name, @org_name,
        @passport_num, @position, @login, @psw, @reg_date,
        @pers_discount, @contragent_type_id, @phone, @district_id
    );
END
GO

-- Процедура вставки должности
CREATE OR ALTER PROCEDURE InsertPosition
    @position NVARCHAR(45)
AS
BEGIN
    INSERT INTO duka_positions (positions)
    VALUES (@position);
END
GO

-- Процедура вставки сотрудника
CREATE OR ALTER PROCEDURE InsertEmployee
    @first_name NVARCHAR(45),
    @middle_name NVARCHAR(45),
    @last_name NVARCHAR(45),
    @reg_date DATE,
    @login NVARCHAR(45),
    @password NVARCHAR(45),
    @phone NVARCHAR(45),
    @month_salary FLOAT,
    @position_id INT
AS
BEGIN
    INSERT INTO duka_employee (
        first_name, middle_name, last_name, reg_date,
        emp_login, emp_password, emp_phone, emp_month_salary,
        positions_id_positions
    )
    VALUES (
        @first_name, @middle_name, @last_name, @reg_date,
        @login, @password, @phone, @month_salary, @position_id
    );
END
GO

-- Процедура вставки категории товара
CREATE OR ALTER PROCEDURE InsertGoodsCategory
    @category NVARCHAR(45)
AS
BEGIN
    INSERT INTO duka_goods_category (goods_category)
    VALUES (@category);
END
GO

-- Процедура вставки товара
CREATE OR ALTER PROCEDURE InsertGoods
    @name NVARCHAR(145),
    @comments NVARCHAR(245),
    @category_id INT
AS
BEGIN
    INSERT INTO duka_goods (goods_name, goods_comments, goods_category_id_goods_category)
    VALUES (@name, @comments, @category_id);
END
GO

-- Процедура вставки склада
CREATE OR ALTER PROCEDURE InsertWarehouse
    @warehouse NVARCHAR(45)
AS
BEGIN
    INSERT INTO duka_wharehouse (wharehouse)
    VALUES (@warehouse);
END
GO

-- Процедура вставки операции
CREATE OR ALTER PROCEDURE InsertOperation
    @date DATE,
    @doc_num NVARCHAR(45),
    @comments NVARCHAR(145),
    @contragent_id INT,
    @operation_type_id INT,
    @employee_id INT,
    @status_id INT
AS
BEGIN
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
END
GO

-- Процедура вставки позиции операции
CREATE OR ALTER PROCEDURE InsertOperationList
    @quantity NVARCHAR(45),
    @price_with_discount FLOAT,
    @operation_id INT,
    @parent_operation_list_id INT,
    @goods_id INT,
    @warehouse_id INT
AS
BEGIN
    INSERT INTO duka_operation_list (
        quantity, prise_with_discount,
        operations_id_operations, operation_list_id_operation_list,
        goods_id_goods, wharehouse_id_wharehouse
    )
    VALUES (
        @quantity, @price_with_discount,
        @operation_id, @parent_operation_list_id,
        @goods_id, @warehouse_id
    );
END
GO

-- Процедура вставки платежа
CREATE OR ALTER PROCEDURE InsertPayment
    @date DATE,
    @sum FLOAT,
    @comments NVARCHAR(450),
    @operation_id INT,
    @payment_type_id INT
AS
BEGIN
    INSERT INTO duka_payments (
        payment_date, payment_sum, payment_comments,
        operations_id_operations, payment_type_id_payment_type
    )
    VALUES (
        @date, @sum, @comments,
        @operation_id, @payment_type_id
    );
END
GO

-- Процедура вставки акции
CREATE OR ALTER PROCEDURE InsertPromotion
    @name NVARCHAR(45),
    @discount FLOAT,
    @comment NVARCHAR(450),
    @date_start DATE,
    @date_end DATE,
    @event_type_id INT
AS
BEGIN
    INSERT INTO duka_promoutions (
        promoutions_name, discount_value, promoution_comment,
        promoution_date_start, promoution_date_end,
        event_type_id_event_type
    )
    VALUES (
        @name, @discount, @comment,
        @date_start, @date_end, @event_type_id
    );
END
GO

-- Типы контрагентов
INSERT INTO duka_contragent_type (contragent_type) VALUES
  ('Individual'),
  ('Corporate');

-- Районы
INSERT INTO duka_district (district) VALUES
  ('North'),
  ('South'),
  ('East'),
  ('West');

-- Должности сотрудников
INSERT INTO duka_positions (positions) VALUES
  ('Administrator'),
  ('Seller'),
  ('Purchasing Manager'),
  ('Accountant');

-- Статусы операций
INSERT INTO duka_operation_status (operation_status) VALUES
  ('Pending'),
  ('Completed'),
  ('Cancelled');

-- Категории товаров
INSERT INTO duka_goods_category (goods_category) VALUES
  ('Flowers'),
  ('Trees'),
  ('Shrubs');

-- Склады
INSERT INTO duka_wharehouse (wharehouse) VALUES
  ('Main Warehouse'),
  ('Secondary Warehouse');

-- Типы событий для акций
INSERT INTO duka_event_type (id_event_type, event_type) VALUES
  (1, 'Promotion'),
  (2, 'Seasonal'),
  (3, 'Clearance');

-- Акции
INSERT INTO duka_promoutions (
    promoutions_name,
    discount_value,
    promoution_comment,
    promoution_date_start,
    promoution_date_end,
    event_type_id_event_type
) VALUES
  ('Spring Sale', 0.15, '15% off spring items', '2025-03-01', '2025-03-31', 2),
  ('Summer Discount', 0.10, '10% off summer items', '2025-06-01', '2025-06-30', 2);

-- Прайс-листы с привязкой к акциям
INSERT INTO duka_price_list (price_list, goods_id_goods, promoutions_id_promoutions) VALUES
  ('Standard Pricing', 1, 1),
  ('Sale Pricing',     1, 2),
  ('Standard Pricing', 2, 1),
  ('Sale Pricing',     2, 2);

-- Типы списания
INSERT INTO duka_write_off_types (write_off_types) VALUES
  ('Damaged'),
  ('Expired');

-- Причины выплат сотрудникам
INSERT INTO duka_reason_type (reason_type) VALUES
  ('Bonus'),
  ('Reimbursement');

-- Типы пользователей
INSERT INTO duka_user_type (user_type) VALUES
  ('Admin'),
  ('Employee'),
  ('Manager');

-- Налоги
INSERT INTO duka_taxes (taxe_name, tax_rate) VALUES
  ('VAT',        0.12),
  ('Income Tax', 0.10);

-- Контрагенты
INSERT INTO duka_contragent (
    first_name, middle_name, last_name,
    org_name, passport_num, position,
    login_, psw, reg_date, pers_discount,
    contragent_type_id_contragent_type,
    phone, district_id_district
) VALUES
  ('Ivan',  'Ivanovich',  'Petrov', 
   'Petrov LLC', 'AB123456', 'CEO',
   'ipetrov', 'pwd123', '2025-05-10', 0.05,
   2, '0700123000', 1),
  ('Maria', 'Sergeevna',  'Smirnova',
   NULL,        'CD789012', 'Manager',
   'msmirnova','pwd456','2025-05-09', 0.10,
   1, '0700123001', 2);

-- Сотрудники
INSERT INTO duka_employee (
    first_name, middle_name, last_name,
    reg_date, emp_login, emp_password,
    emp_phone, emp_month_salary,
    positions_id_positions
) VALUES
  ('Alex',  'Samuel',   'Johnson',
   '2025-04-01','ajohnson','emp123',
   '0700123002', 2000.00, 1),
  ('Sophie','Theresa',  'Lee',
   '2025-04-15','slee',    'emp456',
   '0700123003', 1800.00, 2);

-- Товары
INSERT INTO duka_goods (
    goods_name, goods_comments, goods_category_id_goods_category
) VALUES
  ('Rose Bouquet', 'Red roses, 12 pcs', 1),
  ('Oak Tree',     'Mature oak, 3m tall', 2);

-- Операции (документы)
INSERT INTO duka_operations (
    operation_date, doc_num, comments,
    contragent_id_contragent,
    operation_type_id_operation_type,
    employee_id_employee,
    operation_status_id_operation_status
) VALUES
  ('2025-05-10', 'DOC001', 'First order',
   1,  /* operation_type */ 1,
   1,  /* employee */ 1,
   1   /* status Pending */);

-- Позиции в операции (запасы/продажи)
INSERT INTO duka_operation_list (
    quantity,
    prise_with_discount,
    operations_id_operations,
    operation_list_id_operation_list,
    goods_id_goods,
    wharehouse_id_wharehouse
) VALUES
  ( 5, 100.0, 1, 1, 1, 1),
  (10,  50.0, 1, 1, 2, 2);

-- Списания
INSERT INTO duka_write_off_list (
    write_off_amount,
    operation_list_id_operation_list,
    write_off_types_id_write_off_types,
    write_off_date,
    write_off_comments
) VALUES
  (2, 1, 1, '2025-04-15', 'Damaged items'),
  (1, 2, 2, '2025-04-16', 'Expired items');

-- Выплаты сотрудникам
INSERT INTO duka_earning_payments (
    earning_payments_amount,
    earning_payments_date,
    earning_payments_comments,
    employee_id_employee,
    reason_type_id_reason_type
) VALUES
  (100.00, '2025-04-30', 'Performance bonus', 1, 1),
  ( 50.00, '2025-04-25', 'Travel reimbursement', 2, 2);

-- Типы и платежи
INSERT INTO duka_payment_type (payment_type) VALUES
  ('Card'),
  ('Cash');

INSERT INTO duka_payments (
    payment_date, payment_sum, payment_comments,
    operations_id_operations, payment_type_id_payment_type
) VALUES
  ('2025-05-10', 200.00, 'Payment for DOC001', 1, 1);

-- Отчёты
INSERT INTO duka_reports (
    id_user, report_date, report_id, user_type_id_user_type
) VALUES
  (1, '2025-05-01 10:00:00', 1001, 1),
  (2, '2025-05-02 11:00:00', 1002, 2);
