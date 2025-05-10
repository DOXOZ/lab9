export const fetchData = async (endpoint, token, setData) => {
  const res = await fetch(
    `${import.meta.env.VITE_API_URL}/reports/${endpoint}`,
    {
      headers: { Authorization: `Bearer ${token}` },
    }
  );
  const json = await res.json();
  setData(json.data || []);
}; 