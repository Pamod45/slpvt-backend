import Joi from 'joi'
import { DEVICE_ADMIN_STATUS } from '../../config/constants.js'

const validStatuses = Object.values(DEVICE_ADMIN_STATUS)

export const deviceParamsSchema = Joi.object({
  serialNumber: Joi.string().max(100).required()
})

export const deviceQuerySchema = Joi.object({
  admin_status:  Joi.string().valid(...validStatuses).optional(),
  serial_number: Joi.string().max(100).optional(),
  offset:        Joi.number().integer().min(0).default(0),
  limit:         Joi.number().integer().min(1).max(100).default(20),
  sort_by:       Joi.string().valid('serial_number', 'issued_date', 'admin_status', 'created_at').default('created_at'),
  order:         Joi.string().valid('asc', 'desc').default('desc')
})

export const createDeviceSchema = Joi.object({
  serial_number: Joi.string().max(100).required(),
  issued_date:   Joi.date().iso().required(),
  admin_status:  Joi.string().valid(...validStatuses).default('ACTIVE')
})

export const updateDeviceSchema = Joi.object({
  admin_status: Joi.string().valid(...validStatuses).required()
})
