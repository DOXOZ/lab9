import { useState } from "react";

const AdminPage = () => {
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [registrationDate, setRegistrationDate] = useState("");
  const [phone, setPhone] = useState("");
  const [login, setLogin] = useState("");
  const [password, setPassword] = useState("");
  const [positionId, setPositionId] = useState("");
  const [error, setError] = useState("");
  const [successMessage, setSuccessMessage] = useState("");

  const createEmployeeHandler = async () => {
    try {
      const token = localStorage.getItem("token");
      const response = await fetch(
        `${process.env.REACT_APP_API_URL}/employees/register`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
          body: JSON.stringify({
            First_Name: firstName,
            Last_Name: lastName,
            Registration_Date: registrationDate,
            Phone: phone,
            Login: login,
            Password: password,
            Position_ID: Number(positionId),
          }),
        }
      );

      if (!response.ok) {
        const errorText = await response.text();
        setError("Error creating employee: " + errorText);
        return;
      }

      const data = await response.json();
      console.log("Employee registration response:", data);
      setSuccessMessage("Employee created successfully.");
      // reset fields
      setFirstName("");
      setLastName("");
      setRegistrationDate("");
      setPhone("");
      setLogin("");
      setPassword("");
      setPositionId("");
    } catch (err) {
      console.error("Error creating employee:", err);
      setError("Error creating employee: " + err.message);
    }
  };

  return (
    <div className="p-8 max-w-2xl mx-auto bg-gradient-to-br from-indigo-950 via-purple-900 to-blue-900 rounded-2xl text-white shadow-2xl">
      <h1 className="text-3xl font-semibold mb-6 text-center">Create New Employee</h1>

      {error && (
        <div className="mb-4 bg-red-500/20 border border-red-400 text-red-300 px-4 py-2 rounded">
          {error}
        </div>
      )}
      {successMessage && (
        <div className="mb-4 bg-green-500/20 border border-green-400 text-green-300 px-4 py-2 rounded">
          {successMessage}
        </div>
      )}

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div>
          <label className="block mb-1 text-sm font-light">First Name</label>
          <input
            type="text"
            value={firstName}
            onChange={(e) => setFirstName(e.target.value)}
            className="w-full p-2 rounded bg-white/10 border border-white/20 placeholder:text-gray-200 text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
            placeholder="Enter first name"
          />
        </div>
        <div>
          <label className="block mb-1 text-sm font-light">Last Name</label>
          <input
            type="text"
            value={lastName}
            onChange={(e) => setLastName(e.target.value)}
            className="w-full p-2 rounded bg-white/10 border border-white/20 placeholder:text-gray-200 text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
            placeholder="Enter last name"
          />
        </div>
        <div>
          <label className="block mb-1 text-sm font-light">Registration Date</label>
          <input
            type="date"
            value={registrationDate}
            onChange={(e) => setRegistrationDate(e.target.value)}
            className="w-full p-2 rounded bg-white/10 border border-white/20 text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
          />
        </div>
        <div>
          <label className="block mb-1 text-sm font-light">Phone</label>
          <input
            type="text"
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
            className="w-full p-2 rounded bg-white/10 border border-white/20 text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
            placeholder="Enter phone"
          />
        </div>
        <div>
          <label className="block mb-1 text-sm font-light">Login</label>
          <input
            type="text"
            value={login}
            onChange={(e) => setLogin(e.target.value)}
            className="w-full p-2 rounded bg-white/10 border border-white/20 text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
            placeholder="Enter login"
          />
        </div>
        <div>
          <label className="block mb-1 text-sm font-light">Password</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="w-full p-2 rounded bg-white/10 border border-white/20 text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
            placeholder="••••••••"
          />
        </div>
        <div>
          <label className="block mb-1 text-sm font-light">Position ID</label>
          <input
            type="number"
            value={positionId}
            onChange={(e) => setPositionId(e.target.value)}
            className="w-full p-2 rounded bg-white/10 border border-white/20 text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
            placeholder="Enter position ID"
          />
        </div>
      </div>

      <button
        onClick={createEmployeeHandler}
        className="mt-6 w-full py-3 bg-gradient-to-r from-purple-500 to-indigo-500 hover:brightness-110 rounded-full font-bold text-white shadow-lg"
      >
        Create
      </button>
    </div>
  );
};

export default AdminPage;
