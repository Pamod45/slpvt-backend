/**
 * Custom error classes
 * Thrown in service layer and caught by global error handler middleware
 * Each error carries a status code so the handler knows what to respond with
 */

export class AppError extends Error {
  constructor (message, status, description = null) {
    super(message)
    this.status      = status
    this.description = description
    this.name        = this.constructor.name
    Error.captureStackTrace(this, this.constructor)
  }
}

export class ValidationError extends AppError {
  constructor (message, errors = []) {
    super(message, 422)
    this.errors = errors
  }
}

export class UnauthorizedError extends AppError {
  constructor (message = 'Authentication required') {
    super(message, 401)
  }
}

export class ForbiddenError extends AppError {
  constructor (message = 'Insufficient permissions') {
    super(message, 403)
  }
}

export class NotFoundError extends AppError {
  constructor (message = 'Resource not found') {
    super(message, 404)
  }
}

export class ConflictError extends AppError {
  constructor (message = 'Resource already exists') {
    super(message, 409)
  }
}

export class UnprocessableError extends AppError {
  constructor (message = 'Business rule violation') {
    super(message, 422)
  }
}

export class RateLimitError extends AppError {
  constructor (message = 'Too many requests') {
    super(message, 429)
  }
}