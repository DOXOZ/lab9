import { useEffect, useState } from "react";

const DeliveriesBySupplierReportPage = () => {
  const [reportData, setReportData] = useState([]);
  const [error, setError] = useState("");

  const fetchReport = async () => {
    try {
      const token = localStorage.getItem("token");
      const response = await fetch(
        `${process.env.REACT_APP_API_URL}/reports/deliveries-by-supplier`,
        {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
        }
      );
      if (!response.ok) {
        const errorText = await response.text();
        setError(errorText);
        return;
      }
      const data = await response.json();
      setReportData(data.data);
    } catch (err) {
      setError(err.message);
    }
  };

  useEffect(() => {
    fetchReport();
  }, []);

  return (
    <div className="min-h-screen bg-gradient-to-br from-rose-100 via-pink-200 to-rose-100 text-rose-900 px-6 py-12 font-serif">
      <div className="max-w-7xl mx-auto">
        <h1 className="text-5xl font-extrabold text-center mb-12 tracking-wide drop-shadow-md">
          🚚 Поставки по поставщикам
        </h1>

        {error && (
          <div className="bg-rose-200/40 text-rose-800 border border-rose-400 px-6 py-4 rounded-lg shadow mb-8">
            {error}
          </div>
        )}

        {reportData.length > 0 && (
          <div className="overflow-x-auto rounded-3xl shadow-2xl backdrop-blur-lg bg-white/60 p-6 border border-rose-300">
            <table className="min-w-full text-sm text-rose-900">
              <thead className="bg-rose-200/50 rounded-xl">
                <tr>
                  <th className="px-4 py-3 border-b-2 border-rose-300 text-left font-semibold uppercase tracking-wide">
                    Номер
                  </th>
                  <th className="px-4 py-3 border-b-2 border-rose-300 text-left font-semibold uppercase tracking-wide">
                    Дата
                  </th>
                  <th className="px-4 py-3 border-b-2 border-rose-300 text-left font-semibold uppercase tracking-wide">
                    Поставщик
                  </th>
                  <th className="px-4 py-3 border-b-2 border-rose-300 text-left font-semibold uppercase tracking-wide">
                    Тип товара
                  </th>
                  <th className="px-4 py-3 border-b-2 border-rose-300 text-left font-semibold uppercase tracking-wide">
                    Товар
                  </th>
                  <th className="px-4 py-3 border-b-2 border-rose-300 text-left font-semibold uppercase tracking-wide">
                    Кол-во
                  </th>
                  <th className="px-4 py-3 border-b-2 border-rose-300 text-left font-semibold uppercase tracking-wide">
                    Цена
                  </th>
                  <th className="px-4 py-3 border-b-2 border-rose-300 text-left font-semibold uppercase tracking-wide">
                    Склад
                  </th>
                </tr>
              </thead>
              <tbody>
                {reportData.map((row, i) => (
                  <tr
                    key={i}
                    className={
                      i % 2 === 0
                        ? "bg-rose-50/70 hover:bg-rose-100 transition"
                        : "bg-rose-100/80 hover:bg-rose-200 transition"
                    }
                  >
                    <td className="px-4 py-3">{row["Номер"]}</td>
                    <td className="px-4 py-3">{row["Дата"]}</td>
                    <td className="px-4 py-3">{row["Поставщик"]}</td>
                    <td className="px-4 py-3">{row["Тип товара"]}</td>
                    <td className="px-4 py-3">{row["Товар"]}</td>
                    <td className="px-4 py-3">{row["Кол-во"]}</td>
                    <td className="px-4 py-3">{row["Цена"]}</td>
                    <td className="px-4 py-3">{row["Склад"]}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
};

export default DeliveriesBySupplierReportPage;
