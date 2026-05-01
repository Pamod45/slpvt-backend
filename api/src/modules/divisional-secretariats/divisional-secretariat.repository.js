/**
 * Divisional Secretariat repository
 * All database queries for divisional secretariats
 */

import db from '../../db/postgres.js'

export const findAll = async (pagination) => {
  const { name, offset, limit, sort_by, order } = pagination

  const totalQuery = db('divisional_secretariats').count('ds_division_id as count').first()
  const dataQuery = db('divisional_secretariats as ds')
    .leftJoin('districts as d', 'ds.district_id', 'd.district_id')
    .leftJoin('provinces as p', 'd.province_id', 'p.province_id')
    .select(
      'ds.ds_division_slug',
      'ds.name',
      'd.district_slug',
      'd.name as district_name',
      'p.province_slug',
      'p.name as province_name'
    )

  if (name) {
    totalQuery.where('name', 'ilike', `%${name}%`)
    dataQuery.where('ds.name', 'ilike', `%${name}%`)
  }

  const total = await totalQuery

  const data = await dataQuery
    .orderBy(`ds.${sort_by}`, order)
    .limit(limit)
    .offset(offset)

  return {
    count: parseInt(total.count),
    data
  }
}

export const findBySlug = async (dsSlug) => {
  return db('divisional_secretariats as ds')
    .leftJoin('districts as d', 'ds.district_id', 'd.district_id')
    .leftJoin('provinces as p', 'd.province_id', 'p.province_id')
    .where({ 'ds.ds_division_slug': dsSlug.toLowerCase() })
    .select(
      'ds.ds_division_id',
      'ds.district_id',
      'd.province_id',
      'ds.ds_division_slug',
      'ds.name',
      'd.district_slug',
      'd.name as district_name',
      'p.province_slug',
      'p.name as province_name'
    )
    .first()
}
