const Button = ({ onClick, children, variant = "primary", className = "" }) => {
  const baseStyles = "py-3 font-bold rounded-lg transition-colors duration-200";
  const variants = {
    primary: "bg-blue-500 hover:bg-blue-600 text-white w-full",
    link: "text-blue-600 underline",
  };

  return (
    <button
      onClick={onClick}
      className={`${baseStyles} ${variants[variant]} ${className}`}
    >
      {children}
    </button>
  );
};

export default Button; 