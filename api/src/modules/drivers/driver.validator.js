import Joi from 'joi'
import { DRIVER_POLICE_STATUS } from '../../config/constants.js'

const validStatuses = Object.values(DRIVER_POLICE_STATUS)

export const driverParamsSchema = Joi.object({
  licenseNumber: Joi.string().max(50).required()
})

export const driverQuerySchema = Joi.object({
  licenseNumber:  Joi.string().max(50).optional(),
  referenceId:    Joi.string().max(15).optional(),
  firstName:      Joi.string().max(100).optional(),
  lastName:       Joi.string().max(100).optional(),
  policeStatus:   Joi.string().valid(...validStatuses).optional(),
  licenseExpired: Joi.boolean().optional(),
  offset:         Joi.number().integer().min(0).default(0),
  limit:          Joi.number().integer().min(1).max(100).default(20),
  sortBy:         Joi.string().valid('last_name', 'first_name', 'license_number', 'license_expiry_date', 'created_at').default('last_name'),
  order:          Joi.string().valid('asc', 'desc').default('asc')
})

export const driverAssignmentQuerySchema = Joi.object({
  activeOnly: Joi.boolean().optional(),
  sortBy:     Joi.string().valid('assigned_date').default('assigned_date'),
  order:      Joi.string().valid('asc', 'desc').default('desc'),
  offset:     Joi.number().integer().min(0).default(0),
  limit:      Joi.number().integer().min(1).max(100).default(20)
})

export const createDriverSchema = Joi.object({
  driver_reference_id:     Joi.string().max(15).required(),
  first_name:              Joi.string().max(100).required(),
  last_name:               Joi.string().max(100).required(),
  permanent_address:       Joi.string().required(),
  driving_license_number:  Joi.string().max(50).required(),
  license_expiry_date:     Joi.date().iso().required()
})

export const updateDriverSchema = Joi.object({
  police_status: Joi.string().valid(...validStatuses).required()
})
