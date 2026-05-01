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

export const findDivisionalSecretariatsByDistrict = async (districtId, pagination) => {
  const { offset, limit, sort_by, order } = pagination
  
  const total = await db('divisional_secretariats').where({ district_id: districtId }).count('ds_division_id as count').first()

  const data = await db('divisional_secretariats as ds')
    .leftJoin('districts as d', 'ds.district_id', 'd.district_id')
    .leftJoin('provinces as p', 'd.province_id', 'p.province_id')
    .where({ 'ds.district_id': districtId })
    .select(
      'ds.ds_division_slug',
      'ds.name',
      'd.district_slug',
      'd.name as district_name',
      'p.province_slug',
      'p.name as province_name'
    )
    .orderBy(`ds.${sort_by}`, order)
    .limit(limit)
    .offset(offset)

  return {
    count: parseInt(total.count),
    data
  }
}
