import Joi from 'joi'
import { VEHICLE_POLICE_STATUS } from '../../config/constants.js'

const validStatuses = Object.values(VEHICLE_POLICE_STATUS)

export const vehicleParamsSchema = Joi.object({
  registrationNumber: Joi.string().max(20).required()
})

export const assignmentParamsSchema = Joi.object({
  registrationNumber: Joi.string().max(20).required(),
  licenseNumber:      Joi.string().max(50).required()
})

export const vehicleQuerySchema = Joi.object({
  registrationNumber: Joi.string().max(20).optional(),
  ownerNic:           Joi.string().max(20).optional(),
  ownerName:          Joi.string().max(200).optional(),
  policeStatus:       Joi.string().valid(...validStatuses).optional(),
  makeModel:          Joi.string().max(100).optional(),
  hasDevice:          Joi.boolean().optional(),
  dsDivisionId:       Joi.string().uuid().optional(),
  districtId:         Joi.string().uuid().optional(),
  provinceId:         Joi.string().uuid().optional(),
  offset:             Joi.number().integer().min(0).default(0),
  limit:              Joi.number().integer().min(1).max(100).default(20),
  sortBy:             Joi.string().valid('registration_number', 'owner_nic', 'police_status', 'created_at').default('created_at'),
  order:              Joi.string().valid('asc', 'desc').default('desc')
})

export const assignmentQuerySchema = Joi.object({
  activeOnly: Joi.boolean().optional(),
  sortBy:     Joi.string().valid('assigned_date').default('assigned_date'),
  order:      Joi.string().valid('asc', 'desc').default('desc'),
  offset:     Joi.number().integer().min(0).default(0),
  limit:      Joi.number().integer().min(1).max(100).default(20)
})

export const createVehicleSchema = Joi.object({
  vehicle_reference_id: Joi.string().max(15).required(),
  registration_number:  Joi.string().max(20).required(),
  chassis_number:       Joi.string().max(50).required(),
  color:                Joi.string().max(50).required(),
  make_model:           Joi.string().max(100).required(),
  owner_nic:            Joi.string().max(20).required(),
  owner_full_name:      Joi.string().max(200).required(),
  owner_contact:        Joi.string().max(20).optional().allow(null, ''),
  ds_division_id:       Joi.string().uuid().required()
})

export const updateVehicleSchema = Joi.object({
  police_status: Joi.string().valid(...validStatuses).optional(),
  device_id:     Joi.string().uuid().optional().allow(null)
}).min(1)

export const createAssignmentSchema = Joi.object({
  license_number: Joi.string().max(50).required(),
  assigned_date:  Joi.date().iso().required()
})

export const closeAssignmentSchema = Joi.object({
  returned_date: Joi.date().iso().required()
})
