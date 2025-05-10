import React from 'react';
import { Menu } from 'antd';
import { Link, useLocation } from 'react-router-dom';

const { SubMenu } = Menu;

const ReportNavigation = () => {
  const location = useLocation();

  const reportGroups = {
    'Финансовые отчеты': [
      { key: 'break-even', label: 'Точка безубыточности' },
      { key: 'profit-loss', label: 'Прибыли и убытки' },
      { key: 'taxes', label: 'Налоги' },
      { key: 'client-debts', label: 'Задолженности клиентов' },
      { key: 'supplier-debt', label: 'Задолженность поставщиков' }
    ],
    'Складские отчеты': [
      { key: 'warehouse-remainders', label: 'Остатки на складе' },
      { key: 'warehouse-products', label: 'Товары на складе' },
      { key: 'defective-products', label: 'Бракованные товары' }
    ],
    'Отчеты по продажам': [
      { key: 'product-sales', label: 'Продажи товаров' },
      { key: 'sales-by-clients', label: 'Продажи по клиентам' },
      { key: 'orders-summary', label: 'Сводка по заказам' },
      { key: 'canceled-orders', label: 'Отмененные заказы' },
      { key: 'sellers-client-orders', label: 'Заказы клиентов продавца' }
    ],
    'Отчеты по оплатам': [
      { key: 'client-payment', label: 'Оплаты клиентов' },
      { key: 'supply-payments', label: 'Оплата поставок' },
      { key: 'salaries', label: 'Зарплаты сотрудников' }
    ],
    'Справочные отчеты': [
      { key: 'price-list', label: 'Прайс-лист' },
      { key: 'promotions', label: 'Акции' },
      { key: 'deliveries-by-supplier', label: 'Поставки по поставщикам' }
    ]
  };

  return (
    <Menu
      mode="inline"
      selectedKeys={[location.pathname.split('/').pop()]}
      style={{ width: 256 }}
    >
      {Object.entries(reportGroups).map(([groupName, reports]) => (
        <SubMenu key={groupName} title={groupName}>
          {reports.map(report => (
            <Menu.Item key={report.key}>
              <Link to={`/reports/${report.key}`}>{report.label}</Link>
            </Menu.Item>
          ))}
        </SubMenu>
      ))}
    </Menu>
  );
};

export default ReportNavigation; 