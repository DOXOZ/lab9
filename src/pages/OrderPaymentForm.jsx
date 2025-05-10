import { useState } from "react";

const OrderPaymentForm = () => {
  const [orderId, setOrderId] = useState("");
  const [amount, setAmount] = useState("");
  const [paymentTypeId, setPaymentTypeId] = useState("1");
  const [comment, setComment] = useState("");
  const [result, setResult] = useState(null);
  const token = localStorage.getItem("token");

  const handleSubmit = async (e) => {
    e.preventDefault();

    const response = await fetch(
      `${process.env.REACT_APP_API_URL}/payments/add`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
          Order_ID: parseInt(orderId),
          Amount: parseFloat(amount),
          Payment_Type_ID: parseInt(paymentTypeId),
          Comment: comment,
        }),
      }
    );

    const data = await response.json();
    setResult(data);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-rose-100 via-pink-200 to-rose-100 px-6 py-12 flex items-center justify-center font-serif text-rose-900">
      <div className="w-full max-w-xl bg-white/60 backdrop-blur-lg border border-rose-300 p-10 rounded-3xl shadow-2xl">
        <h2 className="text-5xl font-extrabold mb-8 text-center tracking-wide drop-shadow-md">
          💳 Оплата заказа
        </h2>

        <form onSubmit={handleSubmit} className="space-y-6">
          <input
            className="w-full p-4 rounded-xl bg-rose-50/70 border border-rose-300 placeholder:text-rose-400 text-rose-900 focus:outline-none focus:ring-2 focus:ring-pink-400"
            placeholder="ID заказа"
            value={orderId}
            onChange={(e) => setOrderId(e.target.value)}
            required
          />

          <input
            type="number"
            className="w-full p-4 rounded-xl bg-rose-50/70 border border-rose-300 placeholder:text-rose-400 text-rose-900 focus:outline-none focus:ring-2 focus:ring-pink-400"
            placeholder="Сумма оплаты"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
            required
          />

          <select
            value={paymentTypeId}
            onChange={(e) => setPaymentTypeId(e.target.value)}
            className="w-full p-4 rounded-xl bg-rose-50/70 border border-rose-300 text-rose-900 focus:outline-none focus:ring-2 focus:ring-pink-400"
          >
            <option value="1">Card</option>
            <option value="2">Cash</option>
          </select>

          <textarea
            className="w-full p-4 rounded-xl bg-rose-50/70 border border-rose-300 placeholder:text-rose-400 text-rose-900 focus:outline-none focus:ring-2 focus:ring-pink-400"
            placeholder="Комментарий"
            value={comment}
            onChange={(e) => setComment(e.target.value)}
          />

          <button
            type="submit"
            className="w-full py-3 bg-gradient-to-r from-pink-400 to-rose-300 hover:brightness-110 transition-all duration-300 rounded-full font-bold text-rose-900 shadow-lg"
          >
            Оплатить
          </button>

          {result && (
            <pre className="mt-6 bg-rose-50 p-4 rounded-lg text-sm text-rose-800">
              {JSON.stringify(result, null, 2)}
            </pre>
          )}
        </form>
      </div>
    </div>
  );
};

export default OrderPaymentForm;
