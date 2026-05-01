import Joi from 'joi'

export const locationHistoryQuerySchema = Joi.object({
  from:   Joi.date().iso(),
  to:     Joi.date().iso(),
  lat:    Joi.number().min(-90).max(90),
  lng:    Joi.number().min(-180).max(180),
  radius: Joi.number().integer().min(1).max(50000),
  offset: Joi.number().integer().min(0).default(0),
  limit:  Joi.number().integer().min(1).max(500).default(20)
}).and('lat', 'lng', 'radius')
  .messages({ 'object.and': 'lat, lng and radius must all be provided together' })

export const liveLocationsQuerySchema = Joi.object({
  provinceSlug:   Joi.string(),
  districtSlug:   Joi.string(),
  dsDivisionSlug: Joi.string(),
  offset: Joi.number().integer().min(0).default(0),
  limit:  Joi.number().integer().min(1).max(100).default(20)
}).xor('provinceSlug', 'districtSlug', 'dsDivisionSlug')
  .messages({
    'object.xor': 'Exactly one of provinceSlug, districtSlug, or dsDivisionSlug is required'
  })

export const pingSchema = Joi.object({
  location: Joi.object({
    type: Joi.string()
      .valid('Point')
      .required(),
    coordinates: Joi.array()
      .items(Joi.number())
      .length(2)
      .required()
      .description('[longitude, latitude]')
  }).required(),

  battery_level: Joi.number()
    .integer()
    .min(0)
    .max(100)
    .required(),

  pinged_at: Joi.date()
    .iso()
    .required()
})
