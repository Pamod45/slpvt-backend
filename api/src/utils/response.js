/**
 * Response formatters
 * Consistent response envelope across all endpoints
 * Pagination wrapper builds next and previous links automatically
 */

/**
 * Paginated collection response
 * Used by all GET collection endpoints
 */
export const paginated = (req, data, count, pagination) => {
  const { offset, limit } = pagination
  
  // Combine baseUrl and path, then remove any trailing slash to keep consistent URLs
  const rawUrl = `${req.baseUrl}${req.path}`
  const baseUrl = rawUrl.endsWith('/') ? rawUrl.slice(0, -1) : rawUrl

  const query = { ...req.query }

  const nextOffset = offset + limit
  const prevOffset = offset - limit

  const buildUrl = (newOffset) => {
    const params = new URLSearchParams({
      ...query,
      offset: newOffset,
      limit
    })
    return `${baseUrl}?${params.toString()}`
  }

  return {
    count,
    offset,
    limit,
    next:     nextOffset < count ? buildUrl(nextOffset) : null,
    previous: prevOffset >= 0    ? buildUrl(prevOffset) : null,
    data
  }
}

/**
 * Single resource response
 * Used by GET single resource endpoints
 */
export const single = (data) => ({
  data
})

/**
 * Success response with message
 * Used by POST controller endpoints like mark-stolen
 */
export const success = (message, data = null) => ({
  message,
  ...(data && { data })
})

/**
 * Created response
 * Used internally — controller sets 201 status and Location header
 */
export const created = (data) => ({
  data
})

/**
 * Error response envelope
 * Matches WSO2 error format
 * Used by global error handler
 */
export const error = (code, message, description = null, errors = []) => ({
  code,
  message,
  ...(description && { description }),
  ...(errors.length > 0 && { errors })
})