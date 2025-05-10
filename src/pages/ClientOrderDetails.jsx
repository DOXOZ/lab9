import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";

const ClientOrderDetails = () => {
  const { id } = useParams();
  const [data, setData] = useState([]);
  const [error, setError] = useState("");
  const token = localStorage.getItem("token");
  const client = token ? JSON.parse(atob(token.split(".")[1])) : null;
  const clientId = client?.id;

  useEffect(() => {
    if (!token || !id || !clientId) return;

    fetch(
      `${import.meta.env.VITE_API_URL}/reports/client-order-composition/${id}?clientId=${clientId}`,
      {
        headers: { Authorization: `Bearer ${token}` },
      }
    )
      .then((res) => res.json())
      .then((json) => {
        if (json.success) {
          setData(json.data);
        } else {
          setError(json.message || "Unknown error");
        }
      })
      .catch((err) => setError("Failed to load data: " + err.message));
  }, [id, token, clientId]);

  const columns = ["№ строки", "Товар", "Цена со скидкой", "Количество", "Стоимость"];

  return (
    <div className="min-h-screen px-6 py-12 bg-gradient-to-br from-pink-100 via-rose-200 to-rose-100 text-rose-900 font-serif">
      <div className="max-w-5xl mx-auto">
        <h2 className="text-4xl font-extrabold mb-8 text-center tracking-wide drop-shadow-md">
          🌸 Состав заказа №{id}
        </h2>

        {error && (
          <p className="mb-6 bg-rose-200/40 border border-rose-400 text-rose-700 px-4 py-3 rounded-lg shadow">
            {error}
          </p>
        )}

        <div className="overflow-x-auto rounded-3xl shadow-2xl bg-white/60 backdrop-blur-lg p-4 border border-rose-300">
          <table className="min-w-full text-sm text-rose-900">
            <thead>
              <tr className="bg-rose-200/50">
                {columns.map((col, i) => (
                  <th
                    key={i}
                    className="px-6 py-4 border-b-2 border-rose-300 font-bold text-left tracking-wide uppercase"
                  >
                    {col}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {data.map((row, i) => (
                <tr
                  key={i}
                  className={
                    i % 2 === 0
                      ? "bg-rose-50/70 hover:bg-rose-100 transition"
                      : "bg-rose-100/80 hover:bg-rose-200 transition"
                  }
                >
                  {columns.map((col, j) => (
                    <td key={j} className="px-6 py-4 border-b border-rose-200">
                      {row[col]}
                    </td>
                  ))}
                </tr>
              ))}
              {data.length === 0 && !error && (
                <tr>
                  <td colSpan={columns.length} className="text-center py-8 text-rose-500 italic">
                    🌸 Нет данных для отображения.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default ClientOrderDetails;
