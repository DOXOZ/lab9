// db.cjs
const sql = require("mssql");
require("dotenv").config();

// Проверка наличия необходимых переменных окружения
const requiredEnvVars = ['DB_SERVER', 'DB_USER', 'DB_PASS', 'DB_NAME', 'DB_PORT'];
const missingEnvVars = requiredEnvVars.filter(varName => !process.env[varName]);

if (missingEnvVars.length > 0) {
  console.error('Missing required environment variables:', missingEnvVars.join(', '));
  process.exit(1);
}

// Валидация порта
const dbPort = parseInt(process.env.DB_PORT, 10);
if (isNaN(dbPort)) {
  console.error('Invalid DB_PORT value');
  process.exit(1);
}

const config = {
  server: process.env.DB_SERVER,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
  port: dbPort,
  options: {
    trustServerCertificate: true,
    enableArithAbort: true,
    encrypt: false, // Для локального подключения
    instanceName: 'BARTENDER' // Имя инстанса из server name
  },
  pool: {
    max: 10, // Максимальное количество соединений в пуле
    min: 0, // Минимальное количество соединений в пуле
    idleTimeoutMillis: 30000 // Время простоя соединения
  },
  connectionTimeout: 30000, // Таймаут подключения
  requestTimeout: 30000 // Таймаут запроса
};

// Функция для тестирования подключения
const testConnection = async (pool) => {
  try {
    await pool.request().query('SELECT 1');
    return true;
  } catch (err) {
    console.error("Test query failed:", err);
    return false;
  }
};

const poolPromise = new sql.ConnectionPool(config)
  .connect()
  .then(async pool => {
    console.log(`Connected to database "${config.database}" on ${config.server}`);
    // Проверяем подключение тестовым запросом
    const testResult = await testConnection(pool);
    if (!testResult) {
      console.error("Database connection test failed");
      process.exit(1);
    }
    return pool;
  })
  .catch(err => {
    console.error("Database Connection Error:", err);
    process.exit(1);
  });

module.exports = { sql, poolPromise };
