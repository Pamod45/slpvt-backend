/**
 * Divisional Secretariat validation schemas
 * Used for reading divisional secretariat records
 */

import Joi from 'joi'

export const dsParamsSchema = Joi.object({
  dsSlug: Joi.string()
    .pattern(/^[a-z]+(?:-[a-z]+)*$/)
    .min(2)
    .max(50)
    .required()
    .messages({
      'string.pattern.base': 'DS slug must be a valid slug (e.g. colombo, homagama)',
      'string.min':          'DS slug is too short',
      'string.max':          'DS slug is too long',
      'any.required':        'DS slug is required'
    })
})

export const dsQuerySchema = Joi.object({
  offset:   Joi.number().integer().min(0).default(0),
  limit:    Joi.number().integer().min(1).max(100).default(20),
  sort_by:  Joi.string().valid('name', 'created_at').default('name'),
  order:    Joi.string().valid('asc', 'desc').default('asc')
})
