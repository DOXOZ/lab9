import { useState, useEffect } from 'react';
import { fetchData } from '../utils/api';
import Table from './Table';

export const createReport = (title, endpoint, columns) => {
  return function ReportPage() {
    const [data, setData] = useState([]);
    const token = localStorage.getItem("token");

    useEffect(() => {
      fetchData(endpoint, token, setData);
    }, [endpoint, token]);

    return (
      <div className="min-h-screen bg-gradient-to-br from-gray-100 to-gray-200 p-8 font-sans text-gray-900">
        <h2 className="text-4xl font-bold text-center mb-10 tracking-wide">
          {title}
        </h2>
        <Table columns={columns} data={data} />
      </div>
    );
  };
}; 