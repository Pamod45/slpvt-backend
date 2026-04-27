/**
 * Station validation schemas
 * Used for creating, updating and reading station records
 */

import Joi from 'joi'
import { STATION_TYPES } from '../../config/constants.js'

export const stationShortCodeParamsSchema = Joi.object({
  shortCode: Joi.string().max(10).required()
})

const validStationTypes = Object.values(STATION_TYPES)

export const stationQuerySchema = Joi.object({
  name:           Joi.string().optional().allow(''),
  'station-type': Joi.string().valid(...validStationTypes).optional().allow(''),
  offset:         Joi.number().integer().min(0).default(0),
  limit:          Joi.number().integer().min(1).max(100).default(20),
  sort_by:        Joi.string().valid('name', 'short_code', 'created_at', 'station_type').default('name'),
  order:          Joi.string().valid('asc', 'desc').default('asc')
})

export const createStationSchema = Joi.object({
  name: Joi.string().max(150).required(),
  short_code: Joi.string().max(10).required(),
  station_type: Joi.string()
    .valid(...validStationTypes)
    .required(),
  contact_number: Joi.string().max(20).optional().allow(null, ''),
  province_slug: Joi.alternatives().conditional('station_type', {
    is: STATION_TYPES.RANGE_OFFICE,
    then: Joi.string().required().messages({
      'any.required': 'province_slug is required for Range Office'
    }),
    otherwise: Joi.string().optional().allow(null)
  }),
  district_slug: Joi.alternatives().conditional('station_type', {
    is: STATION_TYPES.DIVISION_OFFICE,
    then: Joi.string().required().messages({
      'any.required': 'district_slug is required for Division Office'
    }),
    otherwise: Joi.string().optional().allow(null)
  }),
  ds_division_slug: Joi.alternatives().conditional('station_type', {
    is: STATION_TYPES.POLICE_POST,
    then: Joi.string().required().messages({
      'any.required': 'ds_division_slug is required for Police Post'
    }),
    otherwise: Joi.string().optional().allow(null)
  }),
  latitude: Joi.number().min(-90).max(90).optional().allow(null),
  longitude: Joi.number().min(-180).max(180).optional().allow(null)
})

export const stationUsersQuerySchema = Joi.object({
  offset:  Joi.number().integer().min(0).default(0),
  limit:   Joi.number().integer().min(1).max(100).default(20),
  sort_by: Joi.string().valid('badge_number', 'first_name', 'last_name', 'created_at').default('created_at'),
  order:   Joi.string().valid('asc', 'desc').default('desc')
})

export const updateStationSchema = Joi.object({
  name: Joi.string().max(150).optional(),
  short_code: Joi.string().max(10).optional(),
  station_type: Joi.string()
    .valid(...validStationTypes)
    .optional(),
  contact_number: Joi.string().max(20).optional().allow(null, ''),
  province_slug: Joi.alternatives().conditional('station_type', {
    is: STATION_TYPES.RANGE_OFFICE,
    then: Joi.string().required(),
    otherwise: Joi.string().optional().allow(null)
  }),
  district_slug: Joi.alternatives().conditional('station_type', {
    is: STATION_TYPES.DIVISION_OFFICE,
    then: Joi.string().required(),
    otherwise: Joi.string().optional().allow(null)
  }),
  ds_division_slug: Joi.alternatives().conditional('station_type', {
    is: STATION_TYPES.POLICE_POST,
    then: Joi.string().required(),
    otherwise: Joi.string().optional().allow(null)
  }),
  latitude: Joi.number().min(-90).max(90).optional().allow(null),
  longitude: Joi.number().min(-180).max(180).optional().allow(null)
}).min(1)
