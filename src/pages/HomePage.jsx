import { useNavigate } from "react-router-dom";

const HomePage = () => {
  const navigate = useNavigate();

  const clearStorage = () => {
    localStorage.clear();
    alert("🌸 Local storage очищен");
    navigate("/login");
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-rose-100 via-pink-200 to-rose-100 flex flex-col items-center justify-center px-6 py-12 text-rose-900 font-serif">
      <div className="bg-white/60 backdrop-blur-xl border border-rose-300 p-10 rounded-3xl shadow-2xl max-w-md w-full text-center space-y-8">
        <h1 className="text-5xl font-extrabold tracking-wide drop-shadow-md">
          Добро пожаловать 🌸
        </h1>
        <p className="text-lg text-rose-700">Выберите действие:</p>

        <div className="flex flex-col sm:flex-row gap-6 justify-center">
          <button
            onClick={() => navigate("/login")}
            className="flex-1 py-3 bg-gradient-to-r from-pink-400 to-rose-300 hover:brightness-110 transition-all duration-300 rounded-full font-bold shadow-lg text-rose-900"
          >
            🔐 Войти
          </button>
          <button
            onClick={clearStorage}
            className="flex-1 py-3 bg-gradient-to-r from-rose-400 to-pink-400 hover:brightness-110 transition-all duration-300 rounded-full font-bold shadow-lg text-rose-900"
          >
            🗑️ Очистить LocalStorage
          </button>
        </div>
      </div>
    </div>
  );
};

export default HomePage;
