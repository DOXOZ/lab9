const Table = ({ columns, data }) => (
  <table className="w-full text-sm bg-white/60 backdrop-blur-lg border border-gray-300 rounded-lg shadow-lg">
    <thead className="bg-gray-200/50">
      <tr>
        {columns.map((col, i) => (
          <th
            key={i}
            className="px-4 py-2 border-b border-gray-300 font-bold text-gray-900 tracking-wide text-left"
          >
            {col}
          </th>
        ))}
      </tr>
    </thead>
    <tbody>
      {data.map((row, i) => (
        <tr
          key={i}
          className={
            i % 2 === 0
              ? "bg-gray-50/70 hover:bg-gray-100 transition"
              : "bg-gray-100/80 hover:bg-gray-200 transition"
          }
        >
          {columns.map((col, j) => (
            <td key={j} className="px-4 py-2 border-b border-gray-200">
              {row[col]}
            </td>
          ))}
        </tr>
      ))}
      {data.length === 0 && (
        <tr>
          <td
            colSpan={columns.length}
            className="text-center py-8 text-gray-500 italic"
          >
            Данные отсутствуют
          </td>
        </tr>
      )}
    </tbody>
  </table>
);

export default Table; 