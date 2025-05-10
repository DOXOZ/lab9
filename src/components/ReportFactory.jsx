import React, { useState, useEffect } from 'react';
import { Table, Space, DatePicker, Button, Select, Input, message } from 'antd';
import axios from 'axios';
import moment from 'moment';

const { RangePicker } = DatePicker;
const { Option } = Select;

export const createReport = (title, endpoint, columns) => {
  return function Report() {
    const [data, setData] = useState([]);
    const [loading, setLoading] = useState(false);
    const [dateRange, setDateRange] = useState([]);
    const [filters, setFilters] = useState({});

    const tableColumns = columns.map(col => ({
      title: col,
      dataIndex: col.toLowerCase().replace(/ /g, '_'),
      key: col.toLowerCase().replace(/ /g, '_'),
      sorter: true
    }));

    const fetchData = async () => {
      try {
        setLoading(true);
        const params = {
          ...filters,
          startDate: dateRange[0]?.format('YYYY-MM-DD'),
          endDate: dateRange[1]?.format('YYYY-MM-DD')
        };

        const response = await axios.get(`/api/reports/${endpoint}`, { params });
        setData(response.data);
      } catch (error) {
        message.error('Ошибка при загрузке данных');
        console.error('Error fetching report data:', error);
      } finally {
        setLoading(false);
      }
    };

    useEffect(() => {
      fetchData();
    }, [dateRange, filters]);

    const handleDateChange = (dates) => {
      setDateRange(dates);
    };

    const handleFilterChange = (key, value) => {
      setFilters(prev => ({
        ...prev,
        [key]: value
      }));
    };

    const renderFilters = () => {
      const filterComponents = [];

      // Добавляем фильтры в зависимости от типа отчета
      if (endpoint === 'warehouse-remainders') {
        filterComponents.push(
          <Select
            key="warehouse"
            style={{ width: 200, marginRight: 16 }}
            placeholder="Выберите склад"
            onChange={(value) => handleFilterChange('warehouse', value)}
            allowClear
          >
            <Option value="1">Основной склад</Option>
            <Option value="2">Холодильная камера</Option>
            <Option value="3">Торговый зал</Option>
          </Select>
        );
      }

      if (endpoint === 'sellers-client-orders') {
        filterComponents.push(
          <Select
            key="seller"
            style={{ width: 200, marginRight: 16 }}
            placeholder="Выберите продавца"
            onChange={(value) => handleFilterChange('seller', value)}
            allowClear
          >
            <Option value="1">Смирнов П.И.</Option>
            <Option value="2">Иванова А.П.</Option>
            <Option value="3">Петров С.А.</Option>
          </Select>
        );
      }

      // Добавляем выбор периода для отчетов с датами
      if (['break-even', 'profit-loss', 'product-sales'].includes(endpoint)) {
        filterComponents.push(
          <RangePicker
            key="date-range"
            onChange={handleDateChange}
            style={{ marginRight: 16 }}
          />
        );
      }

      return filterComponents;
    };

    return (
      <div style={{ padding: '24px' }}>
        <h2>{title}</h2>
        <Space style={{ marginBottom: 16 }}>
          {renderFilters()}
          <Button type="primary" onClick={fetchData}>
            Обновить
          </Button>
        </Space>
        <Table
          columns={tableColumns}
          dataSource={data}
          loading={loading}
          rowKey="номер"
          scroll={{ x: true }}
          pagination={{
            total: data.length,
            pageSize: 10,
            showSizeChanger: true,
            showQuickJumper: true
          }}
        />
      </div>
    );
  };
}; 