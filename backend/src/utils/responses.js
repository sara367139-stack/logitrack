const requestId = () => `req_${Date.now()}_${Math.random().toString(36).slice(2, 8)}`;

const ok = (res, data, meta = {}) => res.status(200).json({ data, meta });

const fail = (res, status, code, message, fields = {}) => res.status(status).json({
  error: { code, message, fields, requestId: requestId() },
});

const paginate = (items, query) => {
  const page = Math.max(1, Number(query.page || 1));
  const pageSize = Math.min(100, Math.max(1, Number(query.pageSize || 20)));
  const total = items.length;
  const totalPages = Math.max(1, Math.ceil(total / pageSize));
  return {
    data: items.slice((page - 1) * pageSize, page * pageSize),
    meta: { page, pageSize, total, totalPages },
  };
};

module.exports = { ok, fail, paginate };
