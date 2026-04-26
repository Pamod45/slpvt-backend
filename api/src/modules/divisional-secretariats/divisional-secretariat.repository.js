/**
 * Divisional Secretariat repository
 * All database queries for divisional secretariats
 */

import db from '../../db/postgres.js'

export const findAll = async (pagination) => {
  const { offset, limit, sort_by, order } = pagination

  const total = await db('divisional_secretariats').count('ds_division_id as count').first()

  const data = await db('divisional_secretariats')
    .select('ds_division_id', 'district_id', 'name', 'ds_division_slug', 'created_at', 'updated_at')
    .orderBy(sort_by, order)
    .limit(limit)
    .offset(offset)

  return {
    count: parseInt(total.count),
    data
  }
}

export const findBySlug = async (dsSlug) => {
  return db('divisional_secretariats')
    .where({ ds_division_slug: dsSlug.toLowerCase() })
    .select('ds_division_id', 'district_id', 'name', 'ds_division_slug', 'created_at', 'updated_at')
    .first()
}
