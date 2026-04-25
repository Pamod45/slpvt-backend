/**
 * Auth validation schemas
 * Validates login and refresh token request bodies
 */

import Joi from 'joi'

export const loginSchema = Joi.object({
  badge_number: Joi.string()
    .trim()
    .required()
    .messages({
      'string.empty': 'Badge number is required',
      'any.required': 'Badge number is required'
    }),

  password: Joi.string()
    .min(6)
    .required()
    .messages({
      'string.empty': 'Password is required',
      'string.min':   'Password must be at least 6 characters',
      'any.required': 'Password is required'
    })
})

export const refreshSchema = Joi.object({
  refresh_token: Joi.string()
    .trim()
    .required()
    .messages({
      'string.empty': 'Refresh token is required',
      'any.required': 'Refresh token is required'
    })
})