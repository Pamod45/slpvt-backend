/**
 * Province validation schemas
 * Used for creating and updating province records
 */

import Joi from 'joi'

export const provinceParamsSchema = Joi.object({
  provinceSlug: Joi.string()
    .pattern(/^[a-z]+(?:-[a-z]+)*$/)
    .min(2)
    .max(50)
    .required()
    .messages({
      'string.pattern.base': 'Province slug must be a valid slug (e.g. western, north-western)',
      'string.min':          'Province slug is too short',
      'string.max':          'Province slug is too long',
      'any.required':        'Province slug is required'
    })
})

export const provinceQuerySchema = Joi.object({
  offset:   Joi.number().integer().min(0).default(0),
  limit:    Joi.number().integer().min(1).max(100).default(20),
  sort_by:  Joi.string().valid('name', 'created_at').default('name'),
  order:    Joi.string().valid('asc', 'desc').default('asc')
})