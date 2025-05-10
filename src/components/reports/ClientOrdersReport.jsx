import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { fetchData } from "../../utils/api";
import Table from "../Table";
import Button from "../Button";
import PageContainer from "../PageContainer";

const ClientOrdersReport = () => {
  const [data, setData] = useState([]);
  const token = localStorage.getItem("token");
  const navigate = useNavigate();
  const user = token ? JSON.parse(atob(token.split(".")[1])) : {};
  const clientId = user.id;

  useEffect(() => {
    if (clientId) {
      fetchData(`client-orders/${clientId}`, token, setData);
    }
  }, [clientId, token]);

  return (
    <PageContainer title="Мои заказы">
      <Table
        columns={["№ заказа", "Дата", "Стоимость", "№ накладной", "Статус"]}
        data={data}
      />
      <Button variant="link" onClick={() => navigate(-1)} className="mt-6">
        Назад
      </Button>
    </PageContainer>
  );
};

export default ClientOrdersReport; 