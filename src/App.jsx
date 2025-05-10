import { Routes, Route } from "react-router-dom";
import HomePage from "./pages/HomePage";
import AuthPage from "./pages/AuthPage";
import ClientRegistrationPage from "./pages/ClientRegistrationPage";
import { 
  AdminDashboard,
  SellerDashboard,
  PurchasingManagerDashboard,
  AccountantDashboard,
  ClientDashboard
} from "./pages/Dashboard";
import CreateEmployeePage from "./pages/CreateEmployeePage";
import ProtectedRoute from "./pages/ProtectedRoute";
import AddClientContact from "./pages/AddContact";

import {
  BreakEvenReport,
  OrdersSummaryReport,
  ClientDebtsReport,
  PromotionsReport,
  SupplierDebtReport,
  ProfitLossReport,
  ProductProfitReport,
  TaxesReport,
  SalariesReport,
  SupplyPaymentsReport,
  DefectiveProductsReport,
  WarehouseProductsReport,
  PriceListReport,
  OrderCompositionReport,
  ClientOrdersReport,
  CanceledOrdersReport,
  ProductSalesReport,
  SalesByClientsReport,
  SalesByWarehouseReport,
  ClientPaymentReport,
  WarehouseRemaindersReport,
  SellersClientOrdersReport
} from "./pages/Reports";
import OrderPaymentForm from "./pages/OrderPaymentForm";

import ClientOrderDetails from "./pages/ClientOrderDetails";

function App() {
  return (
    <Routes>
      <Route path="/" element={<HomePage />} />
      <Route path="/login" element={<AuthPage />} />
      <Route path="/register" element={<ClientRegistrationPage />} />

      <Route element={<ProtectedRoute />}>
      <Route path="/client-dashboard" element={<ClientDashboard />} />
      <Route path="/admin-dashboard" element={<AdminDashboard />} />
      <Route path="/admin/create-employee" element={<CreateEmployeePage />} />
      <Route path="/seller-dashboard" element={<SellerDashboard />} />
      <Route path="/purchasing-dashboard" element={<PurchasingManagerDashboard />} />
      <Route path="/accountant-dashboard" element={<AccountantDashboard />} />

      <Route path="/client/add-contact" element={<AddClientContact />} />
      <Route path="/order-payment" element={<OrderPaymentForm />} />
        {/* Отчёты */}
        <Route path="/reports/seller-orders" element={<SellersClientOrdersReport />} />
        <Route path="/reports/warehouse-remainders" element={<WarehouseRemaindersReport />} />
        <Route path="/reports/client-payments" element={<ClientPaymentReport />} />
        <Route path="/client-order/:id" element={<ClientOrderDetails />} />
        <Route path="/reports/break-even" element={<BreakEvenReport />} />
        <Route path="/reports/orders" element={<OrdersSummaryReport />} />
        <Route path="/reports/client-debts" element={<ClientDebtsReport />} />
        <Route path="/reports/promotions" element={<PromotionsReport />} />
        <Route path="/reports/supply-debt" element={<SupplierDebtReport />} />
        <Route path="/reports/profit-loss" element={<ProfitLossReport />} />
        <Route path="/reports/product-profit" element={<ProductProfitReport />} />
        <Route path="/reports/taxes" element={<TaxesReport />} />
        <Route path="/reports/salaries" element={<SalariesReport />} />
        <Route path="/reports/supply-payments" element={<SupplyPaymentsReport />} />
        <Route path="/reports/defective-products" element={<DefectiveProductsReport />} />
        <Route path="/reports/warehouse" element={<WarehouseProductsReport />} />
        <Route path="/reports/price-list" element={<PriceListReport />} />
        <Route path="/reports/order-receipt" element={<OrderCompositionReport />} />
        <Route path="/reports/client-orders" element={<ClientOrdersReport />} />
        <Route path="/reports/canceled-orders" element={<CanceledOrdersReport />} />
        <Route path="/reports/product-sales" element={<ProductSalesReport />} />
        <Route path="/reports/sales-by-clients" element={<SalesByClientsReport />} />
        <Route path="/reports/sales-by-warehouse" element={<SalesByWarehouseReport />} />
      </Route>
    </Routes>
  );
}

export default App;
