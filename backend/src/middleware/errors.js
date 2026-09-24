const { fail } = require('../utils/responses');

const notFound = (req, res) => fail(res, 404, 'NOT_FOUND', 'Route not found');

const errorHandler = (error, req, res, next) => {
  console.error(error);
  if (error.code === 'P2002') return fail(res, 409, 'CONFLICT', 'A unique value already exists');
  if (error.code === 'P2025') return fail(res, 404, 'NOT_FOUND', 'Resource not found');
  return fail(res, 500, 'INTERNAL_SERVER_ERROR', 'Unexpected server error');
};

module.exports = { notFound, errorHandler };
