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
