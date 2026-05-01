import Joi from 'joi'

export const boundaryCrossingSchema = Joi.object({
  from: Joi.date().iso().required(),
  to: Joi.date().iso().greater(Joi.ref('from')).required(),

  // Exactly one of these geometric scope slugs must be provided
  provinceSlug:  Joi.string(),
  districtSlug:  Joi.string(),
  dsDivisionSlug: Joi.string(),
  offset: Joi.number().integer().min(0).default(0),
  limit:  Joi.number().integer().min(1).max(100).default(20)
}).or('provinceSlug', 'districtSlug', 'dsDivisionSlug')
