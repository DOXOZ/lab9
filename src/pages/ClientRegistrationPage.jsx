import { useState } from "react";
import { useNavigate } from "react-router-dom";

const ClientRegistrationPage = () => {
  const [form, setForm] = useState({
    First_Name: "",
    Last_Name: "",
    Client_Type_ID: 1,
    Contacts_ID: 1,
    District_ID: 1,
    Discount: 0,
    Registration_Date: "",
    Workplace: "",
    Position: "",
    Passport_Number: "",
    Login: "",
    Password: "",
  });
  const [error, setError] = useState("");
  const navigate = useNavigate();

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await fetch(
        `${process.env.REACT_APP_API_URL}/clients/register`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(form),
        }
      );

      if (!response.ok) {
        const errText = await response.text();
        setError(errText);
        return;
      }

      navigate("/client-dashboard");
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-rose-100 via-pink-200 to-rose-100 flex items-center justify-center px-6 py-12 font-serif text-rose-900">
      <form
        onSubmit={handleSubmit}
        className="w-full max-w-3xl bg-white/60 backdrop-blur-lg p-10 rounded-3xl border border-rose-300 shadow-2xl space-y-6"
      >
        <h1 className="text-4xl font-extrabold text-center mb-6 tracking-wide drop-shadow-md">
          🌸 Регистрация клиента
        </h1>

        {error && (
          <div className="bg-rose-200/40 border border-rose-400 text-rose-800 px-4 py-3 rounded-lg shadow">
            {error}
          </div>
        )}

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
          <input
            type="text"
            name="First_Name"
            placeholder="First Name"
            value={form.First_Name}
            onChange={handleChange}
            className="p-3 rounded-xl bg-rose-50/70 border border-rose-300 placeholder:text-rose-400 text-rose-900 focus:ring-pink-400"
          />
          <input
            type="text"
            name="Last_Name"
            placeholder="Last Name"
            value={form.Last_Name}
            onChange={handleChange}
            className="p-3 rounded-xl bg-rose-50/70 border border-rose-300 placeholder:text-rose-400 text-rose-900 focus:ring-pink-400"
          />
          {/* ...other inputs similar to above... */}
        </div>

        <button
          type="submit"
          className="w-full py-3 bg-gradient-to-r from-pink-400 to-rose-300 hover:brightness-110 transition-all duration-300 rounded-full font-bold text-rose-900 shadow-lg"
        >
          Зарегистрироваться
        </button>
      </form>
    </div>
  );
};

export default ClientRegistrationPage;
