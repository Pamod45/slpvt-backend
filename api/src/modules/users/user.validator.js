/**
 * User validation schemas
 */

import Joi from 'joi'
import { ROLES } from '../../config/constants.js'

export const userParamsSchema = Joi.object({
  badgeNumber: Joi.string().max(50).required()
})

const roleValues = Object.values(ROLES)

export const userQuerySchema = Joi.object({
  offset:       Joi.number().integer().min(0).default(0),
  limit:        Joi.number().integer().min(1).max(100).default(20),
  sortBy:       Joi.string().valid('first_name', 'last_name', 'badge_number', 'created_at').default('created_at'),
  order:        Joi.string().valid('asc', 'desc').default('desc'),
  systemRole:   Joi.string().valid(...roleValues).optional(),
  firstName:    Joi.string().max(100).optional(),
  lastName:     Joi.string().max(100).optional(),
  districtSlug: Joi.string().max(100).optional(),
  provinceSlug: Joi.string().max(100).optional()
})

export const createUserSchema = Joi.object({
  badge_number:       Joi.string().max(50).required(),
  password:           Joi.string().min(8).max(100).required(),
  system_role:        Joi.string().valid(...roleValues).required(),
  first_name:         Joi.when('system_role', {
    is:        'DATA_REGISTRAR',
    then:      Joi.string().max(100).optional().allow(null),
    otherwise: Joi.string().max(100).required()
  }),
  last_name:          Joi.when('system_role', {
    is:        'DATA_REGISTRAR',
    then:      Joi.string().max(100).optional().allow(null),
    otherwise: Joi.string().max(100).required()
  }),
  station_short_code: Joi.string().max(50).optional().allow(null)
})

export const updateUserSchema = Joi.object({
  first_name:          Joi.string().max(100).optional(),
  last_name:           Joi.string().max(100).optional(),
  system_role:         Joi.string().valid(...roleValues).optional(),
  station_short_code:  Joi.string().max(50).optional().allow(null),
  deleted_at:          Joi.date().iso().optional().allow(null)
}).min(1)

export const updatePasswordSchema = Joi.object({
  old_password: Joi.string().required(),
  new_password: Joi.string().min(8).max(100).required()
})