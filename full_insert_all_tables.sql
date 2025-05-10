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

-- Заполнение типов контрагентов
INSERT INTO duka_contragent_type (contragent_type) VALUES
    (N'Поставщик'),
    (N'Клиент'),
    (N'Партнер'),
    (N'Сотрудник');

-- Заполнение районов
INSERT INTO duka_district (district) VALUES
    (N'Центральный'),
    (N'Северный'),
    (N'Южный'),
    (N'Западный'),
    (N'Восточный');

-- Заполнение должностей
INSERT INTO duka_positions (positions) VALUES
    (N'Директор'),
    (N'Менеджер по продажам'),
    (N'Бухгалтер'),
    (N'Кладовщик'),
    (N'Продавец-консультант');

-- Заполнение статусов операций
INSERT INTO duka_operation_status (operation_status) VALUES
    (N'Новая'),
    (N'В обработке'),
    (N'Выполнена'),
    (N'Отменена'),
    (N'На согласовании');

-- Заполнение категорий товаров
INSERT INTO duka_goods_category (goods_category) VALUES
    (N'Цветы срезанные'),
    (N'Горшечные растения'),
    (N'Букеты'),
    (N'Подарочная упаковка'),
    (N'Аксессуары');

-- Заполнение складов
INSERT INTO duka_wharehouse (wharehouse) VALUES
    (N'Основной склад'),
    (N'Холодильная камера'),
    (N'Торговый зал'),
    (N'Склад упаковки');

-- Заполнение типов событий
INSERT INTO duka_event_type (event_type) VALUES
    (N'Сезонная акция'),
    (N'Праздничная распродажа'),
    (N'Специальное предложение'),
    (N'Распродажа');

-- Заполнение типов списания
INSERT INTO duka_write_off_types (write_off_types) VALUES
    (N'Порча товара'),
    (N'Истек срок годности'),
    (N'Брак при поставке'),
    (N'Недостача');

-- Заполнение причин платежа
INSERT INTO duka_reason_type (reason_type) VALUES
    (N'Зарплата'),
    (N'Премия'),
    (N'Компенсация'),
    (N'Аванс');

-- Заполнение типов оплаты
INSERT INTO duka_payment_type (payment_type) VALUES
    (N'Наличные'),
    (N'Банковская карта'),
    (N'Безналичный расчет'),
    (N'Электронный платеж');

-- Заполнение налогов
INSERT INTO duka_taxes (taxe_name, tax_rate) VALUES
    (N'НДС', 0.20),
    (N'Налог на прибыль', 0.20),
    (N'НДФЛ', 0.13),
    (N'Страховые взносы', 0.30);

-- Заполнение типов пользователей
INSERT INTO duka_user_type (user_type) VALUES
    (N'Администратор'),
    (N'Менеджер'),
    (N'Продавец'),
    (N'Кладовщик');

-- Заполнение типов операций
INSERT INTO duka_operation_type (operation_type) VALUES
    (N'Продажа'),
    (N'Поступление'),
    (N'Возврат'),
    (N'Списание'),
    (N'Инвентаризация');

-- Заполнение контрагентов
INSERT INTO duka_contragent (
    first_name, middle_name, last_name, org_name, 
    passport_num, position, login_, psw, 
    reg_date, pers_discount, contragent_type_id_contragent_type, 
    phone, district_id_district
) VALUES
    (N'Иван', N'Петрович', N'Сидоров', N'ООО Цветочный рай',
    N'4510123456', N'Директор', N'isidorov', N'pass123',
    '2024-01-01', 0.05, 1, N'+7(900)123-45-67', 1),
    
    (N'Мария', N'Ивановна', N'Петрова', N'ИП Петрова',
    N'4511234567', N'ИП', N'mpetrova', N'pass456',
    '2024-01-02', 0.10, 2, N'+7(900)234-56-78', 2),
    
    (N'Алексей', N'Сергеевич', N'Иванов', N'Цветочная база',
    N'4512345678', N'Менеджер', N'aivanov', N'pass789',
    '2024-01-03', 0.15, 3, N'+7(900)345-67-89', 3);

-- Заполнение сотрудников
INSERT INTO duka_employee (
    first_name, middle_name, last_name,
    reg_date, emp_login, emp_password,
    emp_phone, emp_month_salary, positions_id_positions
) VALUES
    (N'Петр', N'Иванович', N'Смирнов',
    '2024-01-01', N'psmironov', N'emp123',
    N'+7(900)111-22-33', 50000.00, 1),
    
    (N'Анна', N'Петровна', N'Иванова',
    '2024-01-02', N'aivanova', N'emp456',
    N'+7(900)222-33-44', 40000.00, 2),
    
    (N'Сергей', N'Алексеевич', N'Петров',
    '2024-01-03', N'spetrov', N'emp789',
    N'+7(900)333-44-55', 35000.00, 3);

-- Заполнение товаров
INSERT INTO duka_goods (
    goods_name, goods_comments,
    goods_category_id_goods_category
) VALUES
    (N'Роза красная', N'Эквадор, 60 см',
    1),
    (N'Орхидея Фаленопсис', N'2 цветоноса',
    2),
    (N'Букет "Весенний"', N'15 тюльпанов',
    3),
    (N'Лента атласная', N'Ширина 2 см, красная',
    4);

-- Заполнение акций
INSERT INTO duka_promoutions (
    promoutions_name, discount_value,
    promoution_comment, promoution_date_start,
    promoution_date_end, event_type_id_event_type
) VALUES
    (N'8 марта', 0.15,
    N'Скидка на все букеты', '2024-03-01',
    '2024-03-08', 1),
    
    (N'День рождения', 0.10,
    N'Скидка в день рождения', '2024-01-01',
    '2024-12-31', 3);

-- Заполнение прайс-листа
INSERT INTO duka_price_list (
    price_list, goods_id_goods,
    promoutions_id_promoutions
) VALUES
    (N'100.00', 1, 1),
    (N'1500.00', 2, 1),
    (N'2000.00', 3, 2),
    (N'50.00', 4, 2);

-- Заполнение операций
INSERT INTO duka_operations (
    operation_date, doc_num,
    comments, contragent_id_contragent,
    operation_type_id_operation_type,
    employee_id_employee,
    operation_status_id_operation_status
) VALUES
    ('2024-01-10', N'ПН-0001',
    N'Поступление цветов', 1,
    2, 1, 3),
    
    ('2024-01-11', N'РН-0001',
    N'Продажа букета', 2,
    1, 2, 3);

-- Заполнение списка операций
INSERT INTO duka_operation_list (
    quantity, prise_with_discount,
    operations_id_operations,
    operation_list_id_operation_list,
    goods_id_goods, wharehouse_id_wharehouse
) VALUES
    (N'100', 80.00,
    1, 1, 1, 1),

    (N'1', 2000.00,
    2, 1, 3, 3);

-- Заполнение списаний
INSERT INTO duka_write_off_list (
    write_off_amount,
    operation_list_id_operation_list,
    write_off_types_id_write_off_types,
    write_off_date, write_off_comments
) VALUES
    (5.00, 1, 1,
    '2024-01-15', N'Порча при хранении'),

    (1.00, 1, 2,
    '2024-01-16', N'Истек срок реализации');

-- Заполнение выплат сотрудникам
INSERT INTO duka_earning_payments (
    earning_payments_amount,
    earning_payments_date,
    earning_payments_comments,
    employee_id_employee,
    reason_type_id_reason_type
) VALUES
    (50000.00, '2024-01-25',
    N'Зарплата за январь', 1, 1),
    
    (40000.00, '2024-01-25',
    N'Зарплата за январь', 2, 1),
    
    (5000.00, '2024-01-15',
    N'Премия', 1, 2);

-- Заполнение платежей
INSERT INTO duka_payments (
    payment_date, payment_sum,
    payment_comments,
    operations_id_operations,
    payment_type_id_payment_type
) VALUES
    ('2024-01-10', 8000.00,
    N'Оплата поставки', 1, 3),

    ('2024-01-11', 2000.00,
    N'Оплата заказа', 2, 2);

-- Заполнение отчетов
INSERT INTO duka_reports (
    id_user, report_date,
    report_id, user_type_id_user_type
) VALUES
    (1, '2024-01-31 10:00:00',
    1, 1),
    
    (2, '2024-01-31 11:00:00',
    2, 2);
