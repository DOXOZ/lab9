import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

const AuthPage = () => {
  const [userType, setUserType] = useState("client");
  const [login, setLogin] = useState("");
  const [password, setPassword] = useState("");
  const [errorMessage, setErrorMessage] = useState("");
  const navigate = useNavigate();

  useEffect(() => {
    const token = localStorage.getItem("token");
    const storedUserType = localStorage.getItem("userType");
    if (token && storedUserType) {
      redirectByUserType(storedUserType);
    }
  }, [navigate]);

  const redirectByUserType = (type) => {
    switch (type) {
      case "client":
        navigate("/client-dashboard");
        break;
      case "seller":
        navigate("/seller-dashboard");
        break;
      case "purchasing_manager":
        navigate("/purchasing-dashboard");
        break;
      case "accountant":
        navigate("/accountant-dashboard");
        break;
      case "administrator":
        navigate("/admin-dashboard");
        break;
      default:
        navigate("/");
    }
  };

  const loginHandler = async () => {
    try {
      const response = await fetch(
        `${import.meta.env.VITE_API_URL}/auth`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ userType, login, password }),
        }
      );
      if (!response.ok) {
        const errorText = await response.text();
        setErrorMessage("Ошибка входа: " + errorText);
        return;
      }
      const data = await response.json();
      localStorage.setItem("token", data.token);
      localStorage.setItem("userType", userType);
      redirectByUserType(userType);
    } catch (err) {
      setErrorMessage("Ошибка: " + err.message);
    }
  };

  const registerHandler = () => {
    navigate("/register");
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-rose-100 via-pink-200 to-rose-100 flex items-center justify-center px-6 py-12 font-serif text-rose-900">
      <div className="bg-white/60 backdrop-blur-lg border border-rose-300 rounded-3xl p-10 w-full max-w-xl shadow-2xl">
        <h1 className="text-5xl font-extrabold text-center mb-8 tracking-wide drop-shadow-md">
          Добро пожаловать 🌸
        </h1>

        {errorMessage && (
          <div className="mb-6 bg-rose-200/40 text-rose-800 border border-rose-400 px-4 py-3 rounded-lg shadow">
            {errorMessage}
          </div>
        )}

        <div className="space-y-6">
          <div>
            <label className="block mb-1 font-semibold">Тип пользователя</label>
            <select
              value={userType}
              onChange={(e) => setUserType(e.target.value)}
              className="w-full p-3 rounded-xl bg-rose-50/70 border border-rose-300 text-rose-900 focus:ring-pink-400"
            >
              <option value="client">Клиент</option>
              <option value="seller">Продавец</option>
              <option value="purchasing_manager">Менеджер закупок</option>
              <option value="accountant">Бухгалтер</option>
              <option value="administrator">Администратор</option>
            </select>
          </div>

          <div>
            <label className="block mb-1 font-semibold">Логин</label>
            <input
              type="text"
              value={login}
              onChange={(e) => setLogin(e.target.value)}
              className="w-full p-3 rounded-xl bg-rose-50/70 border border-rose-300 text-rose-900 focus:ring-pink-400"
              placeholder="Ваш логин"
            />
          </div>

          <div>
            <label className="block mb-1 font-semibold">Пароль</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full p-3 rounded-xl bg-rose-50/70 border border-rose-300 text-rose-900 focus:ring-pink-400"
              placeholder="••••••••"
            />
          </div>

          <div className="flex flex-col gap-4 pt-6">
            <button
              onClick={loginHandler}
              className="w-full py-3 bg-gradient-to-r from-pink-400 to-rose-300 hover:brightness-110 transition-all duration-300 rounded-full font-bold text-rose-900 shadow-lg"
            >
              🌸 Войти
            </button>

            {userType === "client" && (
              <button
                onClick={registerHandler}
                className="w-full py-3 bg-rose-200/50 hover:bg-rose-300 transition-all duration-300 rounded-full font-bold text-rose-800 shadow-md border border-rose-300"
              >
                Зарегистрироваться
              </button>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default AuthPage;
