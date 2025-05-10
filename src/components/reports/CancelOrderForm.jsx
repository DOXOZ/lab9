import { useState } from "react";
import Input from "../Input";
import Button from "../Button";
import PageContainer from "../PageContainer";

const CancelOrderForm = () => {
  const [orderId, setOrderId] = useState("");
  const [reason, setReason] = useState("");
  const [result, setResult] = useState(null);
  const token = localStorage.getItem("token");

  const handleCancel = async () => {
    const res = await fetch(
      `${import.meta.env.VITE_API_URL}/orders/cancel`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({ Order_ID: Number(orderId), Reason: reason }),
      }
    );
    const json = await res.json();
    setResult(json);
  };

  return (
    <PageContainer title="Отмена заказа">
      <div className="max-w-sm mx-auto space-y-4">
        <Input
          type="number"
          placeholder="ID заказа"
          value={orderId}
          onChange={(e) => setOrderId(e.target.value)}
        />
        <Input
          placeholder="Причина"
          value={reason}
          onChange={(e) => setReason(e.target.value)}
        />
        <Button onClick={handleCancel}>
          Отменить
        </Button>
        {result && (
          <pre className="mt-4 p-3 bg-gray-50 border border-gray-200 rounded-lg">
            {JSON.stringify(result, null, 2)}
          </pre>
        )}
      </div>
    </PageContainer>
  );
};

export default CancelOrderForm; 