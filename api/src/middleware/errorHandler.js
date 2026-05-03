/**
 * Global error handler middleware
 * Must have exactly 4 parameters for Express to recognise it as error handler
 * Catches all errors thrown from controllers and services
 * Returns consistent error response format per WSO2 guidelines
 */

import { AppError } from '../utils/errors.js'
import { error } from '../utils/response.js'
import logger from '../utils/logger.js'
import { env } from '../config/environment.js'

const errorHandler = (err, req, res, next) => {

  // log the error with request context
  logger.error(err.message, {
    status:    err.status || 500,
    path:      req.originalUrl,
    method:    req.method,
    requestId: req.headers['x-request-id'] || null,
    stack:     err.stack
  })

  // known application error — thrown intentionally from service layer
  if (err instanceof AppError) {
    return res.status(err.status).json(
      error(
        err.status,
        err.message,
        err.description || null,
        err.errors      || [] 
      )
    )
  }

  // Joi validation error — thrown by validate middleware
  if (err.isJoi || err.name === 'ValidationError') {
    return res.status(422).json(
      error(
        422,
        'Validation failed',
        'One or more fields in the request are invalid',
        err.details?.map(d => ({
          field:   d.context?.key || null,
          message: d.message
        })) || []
      )
    )
  }

  // Malformed JSON body — Express body-parser parse failure
  if (err.type === 'entity.parse.failed') {
    return res.status(400).json(
      error(400, 'Invalid JSON', 'The request body contains malformed JSON')
    )
  }

  // JWT errors
  if (err.name === 'JsonWebTokenError') {
    return res.status(401).json(
      error(401, 'Invalid token', 'The provided token is malformed or invalid')
    )
  }

  if (err.name === 'TokenExpiredError') {
    return res.status(401).json(
      error(401, 'Token expired', 'The provided token has expired')
    )
  }

  // PostgreSQL unique constraint violation
  if (err.code === '23505') {
    return res.status(409).json(
      error(409, 'Resource already exists', 'A record with this value already exists')
    )
  }

  // PostgreSQL foreign key violation
  if (err.code === '23503') {
    return res.status(422).json(
      error(422, 'Referenced resource not found', 'A referenced record does not exist')
    )
  }

  // unhandled error — do not leak stack trace in production
  return res.status(500).json(
    error(
      500,
      'Internal server error',
      env.isDev ? err.message : null
    )
  )
}

export default errorHandler