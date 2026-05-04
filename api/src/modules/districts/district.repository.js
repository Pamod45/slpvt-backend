/**
 * District repository
 * All database queries for districts
 */

import db from '../../db/postgres.js'

export const findAll = async (pagination) => {
  const { name, offset, limit, sort_by, order } = pagination

  const totalQuery = db('districts').count('district_id as count').first()
  const dataQuery = db('districts')
    .leftJoin('provinces', 'districts.province_id', 'provinces.province_id')
    .leftJoin('divisional_secretariats as ds', 'districts.district_id', 'ds.district_id')
    .select(
      'districts.district_slug',
      'districts.name',
      'provinces.province_slug',
      'provinces.name as province_name',
      db.raw('COUNT(ds.ds_division_id) as ds_division_count')
    )
    .groupBy('districts.district_id', 'provinces.province_id')

  if (name) {
    totalQuery.where('districts.name', 'ilike', `%${name}%`)
    dataQuery.where('districts.name', 'ilike', `%${name}%`)
  }

  const total = await totalQuery

  const data = await dataQuery
    .orderBy(`districts.${sort_by}`, order)
    .limit(limit)
    .offset(offset)

  return {
    count: parseInt(total.count),
    data
  }
}

export const findBySlug = async (districtSlug) => {
  return db('districts')
    .leftJoin('provinces', 'districts.province_id', 'provinces.province_id')
    .leftJoin('divisional_secretariats as ds', 'districts.district_id', 'ds.district_id')
    .where({ 'districts.district_slug': districtSlug.toLowerCase() })
    .select(
      'districts.district_id',
      'provinces.province_id',
      'districts.district_slug',
      'districts.name',
      'provinces.province_slug',
      'provinces.name as province_name',
      db.raw('COUNT(ds.ds_division_id) as ds_division_count')
    )
    .groupBy('districts.district_id', 'provinces.province_id')
    .first()
}

export const findIdsByProvinceId = async (provinceId) => {
  return db('districts')
    .where({ province_id: provinceId })
    .pluck('district_id')
}

export const findAllIds = async () => {
  return db('districts').pluck('district_id')
}

export const findAllByProvinceId = async (provinceId, pagination) => {
  const { offset, limit, sort_by, order } = pagination

  const total = await db('districts').where({ province_id: provinceId }).count('district_id as count').first()

  const data = await db('districts')
    .leftJoin('provinces', 'districts.province_id', 'provinces.province_id')
    .leftJoin('divisional_secretariats as ds', 'districts.district_id', 'ds.district_id')
    .where({ 'districts.province_id': provinceId })
    .select(
      'districts.district_slug',
      'districts.name',
      'provinces.province_slug',
      'provinces.name as province_name',
      db.raw('COUNT(ds.ds_division_id) as ds_division_count')
    )
    .groupBy('districts.district_id', 'provinces.province_id')
    .orderBy(`districts.${sort_by}`, order)
    .limit(limit)
    .offset(offset)

  return { count: parseInt(total.count), data }
}

