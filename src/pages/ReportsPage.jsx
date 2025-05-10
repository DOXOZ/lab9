import React from 'react';
import { Layout } from 'antd';
import { Routes, Route, Navigate } from 'react-router-dom';
import ReportNavigation from '../components/ReportNavigation';
import * as Reports from './Reports';

const { Sider, Content } = Layout;

const ReportsPage = () => {
  return (
    <Layout style={{ minHeight: '100vh' }}>
      <Sider width={256} theme="light">
        <ReportNavigation />
      </Sider>
      <Content style={{ padding: '0 24px' }}>
        <Routes>
          <Route path="/" element={<Navigate to="break-even" replace />} />
          <Route path="/break-even" element={<Reports.BreakEvenReport />} />
          <Route path="/deliveries-by-supplier" element={<Reports.DeliveriesBySupplierReport />} />
          <Route path="/taxes" element={<Reports.TaxesReport />} />
          <Route path="/profit-loss" element={<Reports.ProfitLossReport />} />
          <Route path="/supply-payments" element={<Reports.SupplyPaymentsReport />} />
          <Route path="/warehouse-products" element={<Reports.WarehouseProductsReport />} />
          <Route path="/price-list" element={<Reports.PriceListReport />} />
          <Route path="/orders-summary" element={<Reports.OrdersSummaryReport />} />
          <Route path="/promotions" element={<Reports.PromotionsReport />} />
          <Route path="/order-composition" element={<Reports.OrderCompositionReport />} />
          <Route path="/canceled-orders" element={<Reports.CanceledOrdersReport />} />
          <Route path="/product-sales" element={<Reports.ProductSalesReport />} />
          <Route path="/sales-by-clients" element={<Reports.SalesByClientsReport />} />
          <Route path="/client-payment" element={<Reports.ClientPaymentReport />} />
          <Route path="/sellers-client-orders" element={<Reports.SellersClientOrdersReport />} />
          <Route path="/warehouse-remainders" element={<Reports.WarehouseRemaindersReport />} />
          <Route path="/supplier-debt" element={<Reports.SupplierDebtReport />} />
          <Route path="/salaries" element={<Reports.SalariesReport />} />
          <Route path="/defective-products" element={<Reports.DefectiveProductsReport />} />
          <Route path="/client-debts" element={<Reports.ClientDebtsReport />} />
        </Routes>
      </Content>
    </Layout>
  );
};

export default ReportsPage; 