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
    ('Поставщик'),
    ('Покупатель'),
    ('Сотрудник'),
    ('Партнер');

-- Районы
INSERT INTO duka_district (district) VALUES
    ('Центральный'),
    ('Северный'),
    ('Южный'),
    ('Восточный'),
    ('Западный');

-- Должности
INSERT INTO duka_positions (positions) VALUES
    ('Директор'),
    ('Менеджер по продажам'),
    ('Менеджер по закупкам'),
    ('Бухгалтер'),
    ('Кладовщик'),
    ('Продавец-консультант');

-- Статусы операций
INSERT INTO duka_operation_status (operation_status) VALUES
    ('Новая'),
    ('В обработке'),
    ('Выполнена'),
    ('Отменена'),
    ('На согласовании'),
    ('Ожидает оплаты');

-- Категории товаров
INSERT INTO duka_goods_category (goods_category) VALUES
    ('Электроника'),
    ('Бытовая техника'),
    ('Компьютеры'),
    ('Смартфоны'),
    ('Аксессуары'),
    ('Комплектующие');

-- Склады
INSERT INTO duka_wharehouse (wharehouse) VALUES
    ('Основной склад'),
    ('Склад электроники'),
    ('Склад бытовой техники'),
    ('Транзитный склад'),
    ('Склад брака');

-- Типы событий
INSERT INTO duka_event_type (id_event_type, event_type) VALUES
    (1, 'Сезонная распродажа'),
    (2, 'Праздничная акция'),
    (3, 'Специальное предложение'),
    (4, 'Распродажа остатков'),
    (5, 'Акция для постоянных клиентов');

-- Типы операций
INSERT INTO duka_operation_type (operation_type) VALUES
    ('Продажа'),
    ('Закупка'),
    ('Возврат от покупателя'),
    ('Возврат поставщику'),
    ('Перемещение между складами'),
    ('Списание'),
    ('Инвентаризация');

-- Типы списания
INSERT INTO duka_write_off_types (write_off_types) VALUES
    ('Брак'),
    ('Истек срок годности'),
    ('Повреждение при хранении'),
    ('Кража'),
    ('Потеря товарного вида');

-- Причины выплат
INSERT INTO duka_reason_type (reason_type) VALUES
    ('Заработная плата'),
    ('Премия'),
    ('Компенсация'),
    ('Больничный'),
    ('Отпускные'),
    ('Командировочные');

-- Типы пользователей
INSERT INTO duka_user_type (user_type) VALUES
    ('Администратор'),
    ('Менеджер'),
    ('Продавец'),
    ('Кладовщик'),
    ('Бухгалтер');

-- Типы оплаты
INSERT INTO duka_payment_type (payment_type) VALUES
    ('Наличные'),
    ('Банковская карта'),
    ('Банковский перевод'),
    ('Электронный платеж'),
    ('В кредит');

-- Налоги
INSERT INTO duka_taxes (taxe_name, tax_rate) VALUES
    ('НДС', 0.20),
    ('Налог на прибыль', 0.20),
    ('НДФЛ', 0.13),
    ('Страховые взносы', 0.30);

-- Сотрудники
INSERT INTO duka_employee (
    first_name, middle_name, last_name,
    reg_date, emp_login, emp_password,
    emp_phone, emp_month_salary,
    positions_id_positions
) VALUES
    ('Иван', 'Петрович', 'Сидоров', '2023-01-15', 'isidorov', 'pass123', '+7900111222', 80000.00, 1),
    ('Мария', 'Ивановна', 'Петрова', '2023-02-01', 'mpetrova', 'pass124', '+7900111223', 60000.00, 2),
    ('Петр', 'Сергеевич', 'Иванов', '2023-02-15', 'pivanov', 'pass125', '+7900111224', 65000.00, 3),
    ('Анна', 'Михайловна', 'Козлова', '2023-03-01', 'akozlova', 'pass126', '+7900111225', 55000.00, 4),
    ('Сергей', 'Александрович', 'Новиков', '2023-03-15', 'snovikov', 'pass127', '+7900111226', 45000.00, 5);

-- Контрагенты
INSERT INTO duka_contragent (
    first_name, middle_name, last_name,
    org_name, passport_num, position,
    login_, psw, reg_date, pers_discount,
    contragent_type_id_contragent_type,
    phone, district_id_district
) VALUES
    ('Алексей', 'Владимирович', 'Смирнов', 'ООО "Электроника"', '4510123456', 'Директор', 
    'asmirnov', 'pass128', '2023-01-10', 0.10, 1, '+7900111227', 1),
    ('Ольга', 'Петровна', 'Васильева', 'ИП Васильева', '4510123457', 'ИП',
    'ovasileva', 'pass129', '2023-01-20', 0.05, 2, '+7900111228', 2),
    ('Дмитрий', 'Сергеевич', 'Морозов', 'ООО "ТехноМир"', '4510123458', 'Менеджер',
    'dmorozov', 'pass130', '2023-02-05', 0.07, 1, '+7900111229', 3);

-- Товары
INSERT INTO duka_goods (
    goods_name, goods_comments,
    goods_category_id_goods_category
) VALUES
    ('Смартфон Samsung Galaxy S21', 'Флагманский смартфон', 4),
    ('Ноутбук Lenovo IdeaPad', 'Офисный ноутбук', 3),
    ('Холодильник LG', 'Двухкамерный холодильник', 2),
    ('Микроволновая печь Samsung', 'С грилем', 2),
    ('Клавиатура Logitech', 'Механическая клавиатура', 5);

-- Акции
INSERT INTO duka_promoutions (
    promoutions_name, discount_value,
    promoution_comment, promoution_date_start,
    promoution_date_end, event_type_id_event_type
) VALUES
    ('Новогодняя распродажа', 0.20, 'Скидки до 20% на всю электронику', '2023-12-20', '2024-01-10', 2),
    ('Весенняя акция', 0.15, 'Скидки на бытовую технику', '2024-03-01', '2024-03-31', 1),
    ('Чёрная пятница', 0.30, 'Максимальные скидки', '2023-11-24', '2023-11-26', 3);

-- Операции
INSERT INTO duka_operations (
    operation_date, doc_num, comments,
    contragent_id_contragent,
    operation_type_id_operation_type,
    employee_id_employee,
    operation_status_id_operation_status
) VALUES
    ('2023-11-01', 'ПН-0001', 'Поступление товара', 1, 2, 3, 3),
    ('2023-11-02', 'РН-0001', 'Продажа клиенту', 2, 1, 2, 3),
    ('2023-11-03', 'ВП-0001', 'Возврат от покупателя', 2, 3, 2, 3);

-- Позиции операций
INSERT INTO duka_operation_list (
    quantity, prise_with_discount,
    operations_id_operations,
    operation_list_id_operation_list,
    goods_id_goods,
    wharehouse_id_wharehouse
) VALUES
    ('10', 45000.00, 1, 1, 1, 1),
    ('5', 35000.00, 1, 1, 2, 1),
    ('1', 47000.00, 2, 2, 1, 1);

-- Платежи
INSERT INTO duka_payments (
    payment_date, payment_sum,
    payment_comments,
    operations_id_operations,
    payment_type_id_payment_type
) VALUES
    ('2023-11-01', 500000.00, 'Оплата поставки', 1, 3),
    ('2023-11-02', 47000.00, 'Оплата покупки', 2, 2);

-- Списания
INSERT INTO duka_write_off_list (
    write_off_amount,
    operation_list_id_operation_list,
    write_off_types_id_write_off_types,
    write_off_date,
    write_off_comments
) VALUES
    (1, 1, 1, '2023-11-10', 'Брак при приемке'),
    (1, 2, 3, '2023-11-15', 'Повреждение при хранении');

-- Выплаты сотрудникам
INSERT INTO duka_earning_payments (
    earning_payments_amount,
    earning_payments_date,
    earning_payments_comments,
    employee_id_employee,
    reason_type_id_reason_type
) VALUES
    (80000.00, '2023-11-05', 'Зарплата за октябрь', 1, 1),
    (60000.00, '2023-11-05', 'Зарплата за октябрь', 2, 1),
    (10000.00, '2023-11-10', 'Премия за выполнение плана', 2, 2);

-- Прайс-лист
INSERT INTO duka_price_list (
    price_list,
    goods_id_goods,
    promoutions_id_promoutions
) VALUES
    (47000.00, 1, NULL),
    (37000.00, 1, 1),
    (35000.00, 2, NULL),
    (29750.00, 2, 1);

-- Отчеты
INSERT INTO duka_reports (
    id_user,
    report_date,
    report_id,
    user_type_id_user_type
) VALUES
    (1, '2023-11-01 10:00:00', 1, 1),
    (2, '2023-11-01 11:00:00', 2, 2),
    (3, '2023-11-01 12:00:00', 3, 3);
