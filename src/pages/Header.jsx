import { useNavigate } from "react-router-dom";
import { getUserFromToken } from "../utils/token";

const Header = () => {
  const navigate = useNavigate();
  const user = getUserFromToken();

  const logout = () => {
    localStorage.clear();
    navigate("/login");
  };

  return (
    <div className="flex justify-between items-center px-8 py-5 mb-12 bg-rose-100/60 backdrop-blur-md border border-rose-300 rounded-3xl shadow-2xl text-rose-900 font-serif">
      <div className="text-2xl font-extrabold tracking-wide drop-shadow-sm">
        🌸 Привет, <span className="font-black">{user?.login || "Пользователь"}</span>
      </div>
      <button
        onClick={logout}
        className="px-6 py-2 rounded-full bg-gradient-to-r from-rose-400 to-pink-400 hover:brightness-110 transition-all duration-300 text-rose-900 font-bold shadow-md"
      >
        Выйти
      </button>
    </div>
  );
};

export default Header;
