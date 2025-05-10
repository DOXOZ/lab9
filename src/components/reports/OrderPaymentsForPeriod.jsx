import { useState } from "react";
import { fetchData } from "../../utils/api";
import Table from "../Table";
import Input from "../Input";
import Button from "../Button";
import PageContainer from "../PageContainer";

const OrderPaymentsForPeriod = () => {
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [data, setData] = useState([]);
  const token = localStorage.getItem("token");

  const load = async () => {
    fetchData(
      `order-payments?StartDate=${startDate}&EndDate=${endDate}`,
      token,
      setData
    );
  };

  return (
    <PageContainer title="Оплаты заказов за период">
      <div className="max-w-md mx-auto space-y-4">
        <Input
          type="date"
          value={startDate}
          onChange={(e) => setStartDate(e.target.value)}
        />
        <Input
          type="date"
          value={endDate}
          onChange={(e) => setEndDate(e.target.value)}
        />
        <Button onClick={load}>
          Загрузить
        </Button>
      </div>
      <div className="mt-8">
        <Table
          columns={["Номер", "Дата заказа", "Сумма к оплате", "Сумма оплаты"]}
          data={data}
        />
      </div>
    </PageContainer>
  );
};

export default OrderPaymentsForPeriod; 