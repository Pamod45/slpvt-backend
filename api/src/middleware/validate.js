/**
 * Joi validation middleware factory
 * Takes a Joi schema and returns a middleware function
 * Validates request body, query params, and path params
 * Returns 400 with structured error if validation fails
 * Usage: router.post('/vehicles', verifyJWT, validate(createVehicleSchema), controller)
 */

import { ValidationError } from '../utils/errors.js'

// ─────────────────────────────────────────────
// VALIDATE BODY
// used for POST and PUT request bodies
// ─────────────────────────────────────────────

export const validateBody = (schema) => {
  return (req, res, next) => {
    const { error, value } = schema.validate(req.body, {
      abortEarly:   false, 
      stripUnknown: true    
    })

    if (error) {
      const errors = error.details.map(d => ({
        field:   d.context?.key || null,
        message: d.message.replace(/['"]/g, '')
      }))

      return next(
        new ValidationError('Validation failed', errors)
      )
    }

    req.body = value
    next()
  }
}

// ─────────────────────────────────────────────
// VALIDATE QUERY
// used for GET request query parameters
// ─────────────────────────────────────────────

export const validateQuery = (schema) => {
  return (req, res, next) => {
    const { error, value } = schema.validate(req.query, {
      abortEarly:   false,
      stripUnknown: true
    })

    if (error) {
      const errors = error.details.map(d => ({
        field:   d.context?.key || null,
        message: d.message.replace(/['"]/g, '')
      }))
      console.log("Validation Error:", error.details);

      return next(
        new ValidationError('Invalid query parameters', errors)
      )
    }

    req.query = value
    next()
  }
}

// ─────────────────────────────────────────────
// VALIDATE PARAMS
// used for path parameters like :vehicleId
// ─────────────────────────────────────────────

export const validateParams = (schema) => {
  return (req, res, next) => {
    const { error, value } = schema.validate(req.params, {
      abortEarly:   false,
      stripUnknown: true
    })

    if (error) {
      const errors = error.details.map(d => ({
        field:   d.context?.key || null,
        message: d.message.replace(/['"]/g, '')
      }))

      return next(
        new ValidationError('Invalid path parameters', errors)
      )
    }

    req.params = value
    next()
  }
}