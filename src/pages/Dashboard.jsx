import { Link } from "react-router-dom";
import Header from "./Header";

const DashboardCard = ({ to, label }) => (
  <Link
    to={to}
    className="block p-6 rounded-3xl shadow-md bg-gradient-to-br from-pink-100 via-rose-200 to-rose-100 text-rose-900 hover:shadow-2xl hover:scale-[1.03] hover:brightness-110 transition-all duration-300 font-semibold backdrop-blur-md border border-rose-300"
  >
    <span className="text-lg tracking-wide">{label}</span>
  </Link>
);

const createDashboard = (title, links) => () => (
  <div className="min-h-screen bg-gradient-to-br from-rose-100 via-pink-200 to-rose-100 px-6 py-12 font-serif text-rose-900">
    <Header />
    <h1 className="text-5xl font-extrabold mb-12 text-center tracking-wide drop-shadow-md">
      {title}
    </h1>
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8 max-w-7xl mx-auto">
      {links.map(([path, label]) => (
        <DashboardCard key={path} to={path} label={label} />
      ))}
    </div>
  </div>
);

export const AdminDashboard = createDashboard("👑 Админ-панель", [
  ["/admin/create-employee", "Создание сотрудника"],
  ["/reports/break-even", "Точка безубыточности"],
  // ...
]);

export const SellerDashboard = createDashboard("🛒 Панель продавца", [
  ["/reports/price-list", "Прайс-лист"],
  ["/reports/seller-orders", "Сводка заказов"],
  // ...
]);

export const PurchasingManagerDashboard = createDashboard("📦 Закупки", [
  ["/reports/supply-debt", "Задолженности поставщиков"],
  // ...
]);

export const AccountantDashboard = createDashboard("💰 Бухгалтерия", [
  ["/reports/client-debts", "Задолженности клиентов"],
  // ...
]);

export const ClientDashboard = createDashboard("👤 Кабинет клиента", [
  ["/reports/price-list", "Прайс-лист"],
  ["/order-payment", "Оплата заказа"],
  ["/reports/client-orders", "Мои заказы"],
  ["/client/add-contact", "Добавить контакт"],
]);
