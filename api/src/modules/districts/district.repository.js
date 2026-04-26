/**
 * District repository
 * All database queries for districts
 */

import db from '../../db/postgres.js'

export const findAll = async (pagination) => {
  const { offset, limit, sort_by, order } = pagination

  const total = await db('districts').count('district_id as count').first()

  const data = await db('districts')
    .select('district_id', 'province_id', 'name', 'district_slug', 'created_at', 'updated_at')
    .orderBy(sort_by, order)
    .limit(limit)
    .offset(offset)

  return {
    count: parseInt(total.count),
    data
  }
}

export const findBySlug = async (districtSlug) => {
  return db('districts')
    .where({ district_slug: districtSlug.toLowerCase() })
    .select('district_id', 'province_id', 'name', 'district_slug', 'created_at', 'updated_at')
    .first()
}

export const findDivisionalSecretariatsByDistrict = async (districtId, pagination) => {
  const { offset, limit, sort_by, order } = pagination
  
  const total = await db('divisional_secretariats').where({ district_id: districtId }).count('ds_division_id as count').first()

  const data = await db('divisional_secretariats')
    .where({ district_id: districtId })
    .select('ds_division_id', 'name', 'ds_division_slug', 'created_at', 'updated_at')
    .orderBy(sort_by, order)
    .limit(limit)
    .offset(offset)

  return {
    count: parseInt(total.count),
    data
  }
}
