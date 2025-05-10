// src/pages/Reports.jsx
import React from "react";
import { createReport } from "../components/ReportFactory";
export { default as ClientOrdersReport } from "../components/reports/ClientOrdersReport";
export { default as CancelOrderFormReport } from "../components/reports/CancelOrderForm";
export { default as OrderPaymentsForPeriodReport } from "../components/reports/OrderPaymentsForPeriod";

// Статические отчёты
export const BreakEvenReport = createReport(
  "Точка безубыточности",
  "break-even",
  ["Номер", "Дата", "Тип товара", "Товар", "Цена покупки", "Цена продажи", "Прибыль"]
);

export const DeliveriesBySupplierReport = createReport(
  "Поставки по поставщикам",
  "deliveries-by-supplier",
  ["Номер", "Дата", "Поставщик", "Тип товара", "Товар", "Кол-во", "Цена", "Склад"]
);

export const SupplierDebtReport = createReport(
  "Задолженность поставщиков",
  "supplier-debt",
  ["Номер", "Номер поставки", "Поставщик", "Дедлайн", "Сумма к оплате", "Задолженность"]
);

export const TaxesReport = createReport(
  "Налоги",
  "taxes",
  ["Номер", "Название налога", "Сумма", "Дата начала", "Дата окончания"]
);

export const SalariesReport = createReport(
  "Зарплаты сотрудников",
  "salaries",
  ["Номер", "Дата", "Начислено", "Оплачено", "Сотрудник"]
);

export const ProfitLossReport = createReport(
  "Отчет о прибылях и убытках",
  "profit-loss",
  ["Номер", "Расход", "Доходы", "Налоги", "Прибыль"]
);

export const SupplyPaymentsReport = createReport(
  "Оплата поставок",
  "supply-payments",
  ["Номер", "Дата", "Сумма", "Поставщик", "Сотрудник", "Тип оплаты"]
);

export const DefectiveProductsReport = createReport(
  "Бракованные товары",
  "defective-products",
  ["Номер", "Дата обнаружения", "Дата поставки", "Тип товаров", "Товар", "Количество", "Цена", "Поставщик"]
);

export const WarehouseProductsReport = createReport(
  "Товары на складе",
  "warehouse-products",
  ["Номер", "Тип товаров", "Товар", "Цена", "Количество", "Номер поставки", "Номер склада"]
);

export const PriceListReport = createReport(
  "Прайс-лист",
  "price-list",
  ["Номер", "Категория товара", "Товар", "Цена товара"]
);

export const OrdersSummaryReport = createReport(
  "Сводка по заказам",
  "orders-summary",
  ["Номер", "Дата", "Клиент", "Сумма", "Статус"]
);

export const ClientDebtsReport = createReport(
  "Задолженности клиентов",
  "client-debts",
  ["Номер", "Дата", "Клиент", "Сумма задолженности", "Дата последней оплаты", "Срок погашения"]
);

export const PromotionsReport = createReport(
  "Акции",
  "promotions",
  ["Номер", "Название", "Описание", "Дата начала", "Дата окончания", "Скидка"]
);

export const ProductProfitReport = createReport(
  "Прибыль по товарам",
  "product-profit",
  ["Номер", "Товар", "Количество продаж", "Выручка", "Затраты", "Прибыль"]
);

export const OrderCompositionReport = createReport(
  "Состав заказа",
  "order-composition",
  ["Номер", "Заказ", "Товар", "Количество", "Цена", "Сумма"]
);

export const CanceledOrdersReport = createReport(
  "Отмененные заказы",
  "canceled-orders",
  ["Номер", "Дата", "Клиент", "Причина отмены", "Сумма"]
);

export const ProductSalesReport = createReport(
  "Продажи товаров",
  "product-sales",
  ["Номер", "Товар", "Количество", "Сумма продаж", "Период"]
);

export const SalesByClientsReport = createReport(
  "Продажи по клиентам",
  "sales-by-clients",
  ["Номер", "Клиент", "Количество заказов", "Сумма покупок", "Средний чек"]
);

export const SalesByWarehouseReport = createReport(
  "Продажи по складам",
  "sales-by-warehouse",
  ["Номер", "Склад", "Количество отгрузок", "Сумма продаж"]
);

export const ClientPaymentReport = createReport(
  "Оплаты клиентов",
  "client-payments",
  ["Номер", "Дата", "Клиент", "Сумма", "Тип оплаты"]
);

export const SellersClientOrdersReport = createReport(
  "Заказы клиентов продавца",
  "sellers-client-orders",
  ["Номер", "Дата", "Клиент", "Сумма", "Статус"]
);

export const WarehouseRemaindersReport = createReport(
  "Остатки на складе",
  "warehouse-remainders",
  ["Номер", "Склад", "Тип товара", "Товар", "Количество", "Цена"]
);
