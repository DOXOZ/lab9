const Input = ({ type = "text", value, onChange, placeholder, className = "" }) => {
  return (
    <input
      type={type}
      value={value}
      onChange={onChange}
      placeholder={placeholder}
      className={`w-full p-3 rounded-lg border border-gray-300 ${className}`}
    />
  );
};

export default Input; 