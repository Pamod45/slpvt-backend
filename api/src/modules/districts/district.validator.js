/**
 * District validation schemas
 * Used for creating and updating district records
 */

import Joi from 'joi'

export const districtParamsSchema = Joi.object({
  districtSlug: Joi.string()
    .pattern(/^[a-z]+(?:-[a-z]+)*$/)
    .min(2)
    .max(50)
    .required()
    .messages({
      'string.pattern.base': 'District slug must be a valid slug (e.g. colombo, nuwara-eliya)',
      'string.min':          'District slug is too short',
      'string.max':          'District slug is too long',
      'any.required':        'District slug is required'
    })
})

export const districtQuerySchema = Joi.object({
  name:   Joi.string().optional().allow(''),
  offset: Joi.number().integer().min(0).default(0),
  limit:  Joi.number().integer().min(1).max(100).default(20),
  sortBy: Joi.string().valid('name', 'created_at').default('name'),
  order:  Joi.string().valid('asc', 'desc').default('asc')
})
