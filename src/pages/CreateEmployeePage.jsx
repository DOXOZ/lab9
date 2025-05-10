import { useState } from "react";
import { useNavigate } from "react-router-dom";

const CreateEmployeePage = () => {
  const [form, setForm] = useState({
    First_Name: "",
    Last_Name: "",
    Registration_Date: "",
    Phone: "",
    Login: "",
    Password: "",
    Position_ID: "",
  });
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");
  const navigate = useNavigate();

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const token = localStorage.getItem("token");
    try {
      const response = await fetch(
        `${process.env.REACT_APP_API_URL}/employees/register`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
          body: JSON.stringify({ ...form, Position_ID: Number(form.Position_ID) }),
        }
      );

      if (!response.ok) {
        const errorText = await response.text();
        setError(errorText);
        return;
      }

      setSuccess("🌸 Сотрудник успешно создан!");
      setForm({
        First_Name: "",
        Last_Name: "",
        Registration_Date: "",
        Phone: "",
        Login: "",
        Password: "",
        Position_ID: "",
      });
      navigate("/admin-dashboard");
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
          🌸 Создание нового сотрудника
        </h1>

        {error && (
          <div className="bg-rose-200/40 border border-rose-400 text-rose-800 px-4 py-3 rounded-lg shadow">
            {error}
          </div>
        )}
        {success && (
          <div className="bg-green-200/40 border border-green-400 text-green-800 px-4 py-3 rounded-lg shadow">
            {success}
          </div>
        )}

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
          {/* inputs for form fields... */}
        </div>
        <button
          type="submit"
          className="w-full py-3 bg-gradient-to-r from-pink-400 to-rose-300 hover:brightness-110 rounded-full font-bold text-rose-900 shadow-lg"
        >
          Создать
        </button>
      </form>
    </div>
  );
};

export default CreateEmployeePage;
