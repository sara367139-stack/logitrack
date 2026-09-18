import { PaginationParams } from '../validation';

export { PaginationParams };

export interface PaginatedResponse<T> {
  data: T[];
  meta: {
    page: number;
    pageSize: number;
    total: number;
    totalPages: number;
  };
}

export function paginate<T>(
  items: T[],
  params: PaginationParams
): PaginatedResponse<T> {
  const { page, pageSize } = params;
  const start = (page - 1) * pageSize;
  const end = start + pageSize;
  
  return {
    data: items.slice(start, end),
    meta: {
      page,
      pageSize,
      total: items.length,
      totalPages: Math.ceil(items.length / pageSize),
    },
  };
}

export interface QueryOptions {
  page: number;
  pageSize: number;
  skip: number;
  limit: number;
  sort?: Record<string, 1 | -1>;
}

export function buildQueryOptions(params: PaginationParams): QueryOptions {
  const { page, pageSize, sortBy, sortOrder } = params;
  const skip = (page - 1) * pageSize;
  const sort: Record<string, 1 | -1> = {};
  
  if (sortBy) {
    sort[sortBy] = sortOrder === 'asc' ? 1 : -1;
  } else {
    sort.createdAt = -1;
  }

  return {
    page,
    pageSize,
    skip,
    limit: pageSize,
    sort,
  };
}