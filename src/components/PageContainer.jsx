const PageContainer = ({ children, title }) => {
  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-100 to-gray-200 p-8 font-sans text-gray-900">
      {title && (
        <h2 className="text-4xl font-bold text-center mb-8 tracking-wide">
          {title}
        </h2>
      )}
      {children}
    </div>
  );
};

export default PageContainer; 