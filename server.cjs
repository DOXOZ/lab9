// server.js
require("dotenv").config();
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const jwt = require("jsonwebtoken");
const { sql, poolPromise } = require("./db.cjs");

const app = express();
app.use(bodyParser.json());
app.use(cors());

const PORT = process.env.PORT || 5000;
// JWT-секрет захардкожен в коде, не в .env
const SECRET_KEY = "my_secret_key";

// Middleware: проверка токена
function verifyToken(req, res, next) {
  const auth = req.headers.authorization || "";
  const token = auth.startsWith("Bearer ") ? auth.slice(7) : null;
  if (!token) return res.status(403).json({ message: "No token provided" });

  try {
    req.user = jwt.verify(token, SECRET_KEY);
    next();
  } catch {
    res.status(401).json({ message: "Invalid or expired token" });
  }
}

// ------------------ AUTH ------------------
app.post("/api/auth", async (req, res) => {
  try {
    const { userType, login, password } = req.body;
    const pool = await poolPromise;

    const result = await pool
      .request()
      .input("userType", sql.VarChar, userType)
      .input("login",    sql.VarChar, login)
      .input("password", sql.VarChar, password)
      .query("EXEC sp_AuthenticateUser @userType, @login, @password");

    const user = result.recordset[0];
    if (!user || user.Error) {
      return res.status(401).json({ success: false, message: "Invalid credentials" });
    }

    const id    = user.Client_ID || user.Employee_ID;
    const token = jwt.sign({ id, login: user.Login, userType }, SECRET_KEY, { expiresIn: "1h" });

    res.json({
      success: true,
      token,
      user: { id, name: `${user.First_Name} ${user.Last_Name}`, userType }
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ------------------ CLIENTS ------------------
app.get("/api/clients", verifyToken, async (_, res) => {
  const pool   = await poolPromise;
  const result = await pool.request().query("EXEC sp_GetClients");
  res.json({ success: true, data: result.recordset });
});

app.get("/api/clients/:id", verifyToken, async (req, res) => {
  const pool   = await poolPromise;
  const result = await pool
    .request()
    .input("Client_ID", sql.Int, req.params.id)
    .query("EXEC sp_GetClientById @Client_ID");
  res.json({ success: true, data: result.recordset });
});

app.post("/api/clients/register", async (req, res) => {
  const pool = await poolPromise;
  const {
    First_Name, Last_Name, Client_Type_ID, Contacts_ID,
    District_ID, Discount, Registration_Date, Workplace,
    Position, Passport_Number, Login, Password
  } = req.body;

  const result = await pool
    .request()
    .input("First_Name",        sql.VarChar, First_Name)
    .input("Last_Name",         sql.VarChar, Last_Name)
    .input("Client_Type_ID",    sql.Int,     Client_Type_ID)
    .input("Contacts_ID",       sql.Int,     Contacts_ID)
    .input("District_ID",       sql.Int,     District_ID)
    .input("Discount",          sql.Float,   Discount)
    .input("Registration_Date", sql.VarChar, Registration_Date)
    .input("Workplace",         sql.VarChar, Workplace)
    .input("Position",          sql.VarChar, Position)
    .input("Passport_Number",   sql.VarChar, Passport_Number)
    .input("Login",             sql.VarChar, Login)
    .input("Password",          sql.VarChar, Password)
    .query(`
      EXEC sp_RegisterClient 
        @First_Name, @Last_Name, @Client_Type_ID, @Contacts_ID, 
        @District_ID, @Discount, @Registration_Date, @Workplace, 
        @Position, @Passport_Number, @Login, @Password
    `);

  res.json({ success: true, data: result.recordset });
});

app.post("/api/clients/contact", async (req, res) => {
  const pool = await poolPromise;
  const { Contact_Info, Contact_Type_ID } = req.body;

  const result = await pool
    .request()
    .input("Contact_Info",     sql.VarChar, Contact_Info)
    .input("Contact_Type_ID",  sql.Int,     Contact_Type_ID)
    .query("EXEC sp_AddClientContact @Contact_Info, @Contact_Type_ID");

  res.json({ success: true, data: result.recordset });
});

// ------------------ EMPLOYEES ------------------
app.get("/api/employees", verifyToken, async (_, res) => {
  const pool   = await poolPromise;
  const result = await pool.request().query("EXEC sp_GetEmployees");
  res.json({ success: true, data: result.recordset });
});

app.get("/api/employees/:id", verifyToken, async (req, res) => {
  const pool   = await poolPromise;
  const result = await pool
    .request()
    .input("Employee_ID", sql.Int, req.params.id)
    .query("EXEC sp_GetEmployeeById @Employee_ID");
  res.json({ success: true, data: result.recordset });
});

app.post("/api/employees/register", async (req, res) => {
  const {
    First_Name, Last_Name, Registration_Date,
    Phone, Login, Password, Position_ID
  } = req.body;
  const pool = await poolPromise;

  const result = await pool
    .request()
    .input("First_Name",         sql.VarChar, First_Name)
    .input("Last_Name",          sql.VarChar, Last_Name)
    .input("Registration_Date",  sql.Date,    Registration_Date)
    .input("Phone",              sql.VarChar, Phone)
    .input("Login",              sql.VarChar, Login)
    .input("Password",           sql.VarChar, Password)
    .input("Position_ID",        sql.Int,     Position_ID)
    .query(`
      EXEC sp_RegisterEmployee 
        @First_Name, @Last_Name, @Registration_Date, 
        @Phone, @Login, @Password, @Position_ID
    `);

  res.json({ success: true, data: result.recordset });
});

// ------------------ REPORTS ------------------
const reportRoutes = {
  "break-even":            "sp_GetBreakEvenPoint",
  "get-all-orders":        "sp_GetAllClientOrders",
  "warehouse-remainder":   "sp_GetWarehouseProductRemainders",
  "deliveries-by-supplier":"sp_GetDeliveriesBySupplier",
  "supplier-debt":         "sp_GetSupplierDebt",
  "supply-product-profit": "sp_GetSupplyProductProfit",
  "taxes":                 "sp_GetTaxes",
  "salaries":              "sp_GetSalaries",
  "sales-promotions":      "sp_GetCurrentPromotionDiscounts",
  "profit-loss":           "sp_GetProfitLossReport",
  "supply-payments":       "sp_GetSupplyPayments",
  "defective-products":    "sp_GetDefectiveProducts",
  "warehouse-products":    "sp_GetWarehouseProducts",
  "price-list":            "sp_GetPriceList",
  "client-debts":          "sp_GetClientDebts",
  "canceled-orders":       "sp_GetCanceledOrders",
  "product-sales":         "sp_GetProductSales",
  "orders-summary":        "sp_GetOrdersSummary",
  "sales-by-clients":      "sp_GetSalesByClients",
  "sales-by-warehouse":    "sp_GetSalesByWarehouse"
};

for (const [route, procedure] of Object.entries(reportRoutes)) {
  app.get(`/api/reports/${route}`, verifyToken, async (req, res) => {
    const pool   = await poolPromise;
    const result = await pool.request().query(`EXEC ${procedure}`);
    res.json({ success: true, data: result.recordset });
  });
}

// Добавление оплаты заказа
app.post("/api/payments/add", verifyToken, async (req, res) => {
  const { Order_ID, Amount, Payment_Type_ID, Comment } = req.body;
  const pool = await poolPromise;

  try {
    const result = await pool.request()
      .input("Order_ID",        sql.Int,      Order_ID)
      .input("Amount",          sql.Decimal(10,2), Amount)
      .input("Payment_Type_ID", sql.Int,      Payment_Type_ID)
      .input("Comment",         sql.VarChar(255), Comment)
      .execute("sp_AddOrderPayment");

    res.json({ success: true, data: result.recordset });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// ------------------ DYNAMIC REPORTS ------------------
// Заказы клиента по ID
app.get("/api/reports/client-orders/:id", verifyToken, async (req, res) => {
  try {
    const clientId = parseInt(req.params.id, 10);
    if (isNaN(clientId)) {
      return res.status(400).json({ success: false, message: "Invalid Client ID" });
    }

    const pool   = await poolPromise;
    const result = await pool.request()
      .input("Client_ID", sql.Int, clientId)
      .execute("sp_GetClientOrders");

    res.json({ success: true, data: result.recordset });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

app.get("/api/reports/client-order-composition/:id", verifyToken, async (req, res) => {
  try {
    const orderId  = parseInt(req.params.id, 10);
    const clientId = parseInt(req.query.clientId, 10);
    if (isNaN(orderId) || isNaN(clientId)) {
      return res.status(400).json({ success: false, message: "Invalid IDs" });
    }

    const pool   = await poolPromise;
    const result = await pool.request()
      .input("Client_ID", sql.Int, clientId)
      .input("Order_ID",  sql.Int, orderId)
      .execute("sp_GetOrderComposition");

    res.json({ success: true, data: result.recordset });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// Оплата за период
app.get("/api/reports/order-payments", verifyToken, async (req, res) => {
  const { StartDate, EndDate } = req.query;
  const pool = await poolPromise;

  const result = await pool.request()
    .input("StartDate", sql.Date, StartDate)
    .input("EndDate",   sql.Date, EndDate)
    .query("EXEC sp_GetOrderPaymentsForPeriod @StartDate, @EndDate");

  res.json({ success: true, data: result.recordset });
});

// Отмена заказа
app.post("/api/orders/cancel", verifyToken, async (req, res) => {
  const { Order_ID, Reason } = req.body;
  const pool = await poolPromise;

  try {
    const result = await pool.request()
      .input("Order_ID", sql.Int,      Order_ID)
      .input("Reason",   sql.VarChar, Reason)
      .query("EXEC sp_CancelOrder @Order_ID, @Reason");

    res.json({ success: true, data: result.recordset });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

app.listen(PORT, () => {
  console.log(`🚀 Server is running on port ${PORT}`);
});
