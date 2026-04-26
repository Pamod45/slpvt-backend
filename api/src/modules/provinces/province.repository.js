/**
 * Province repository
 * All database queries for provinces
 * Scope is not applied here — all authenticated roles can read all provinces
 */

import db from '../../db/postgres.js'

export const findAll = async (pagination) => {
  const { name, offset, limit, sort_by, order } = pagination

  const totalQuery = db('provinces').count('province_id as count').first()
  const dataQuery = db('provinces')
    .leftJoin('districts', 'provinces.province_id', 'districts.province_id')
    .select(
      'provinces.province_slug', 
      'provinces.name', 
      db.raw('COUNT(districts.district_id) as district_count')
    )
    .groupBy('provinces.province_id')

  if (name) {
    totalQuery.where('provinces.name', 'ilike', `%${name}%`)
    dataQuery.where('provinces.name', 'ilike', `%${name}%`)
  }

  const total = await totalQuery

  const data = await dataQuery
    .orderBy(`provinces.${sort_by}`, order)
    .limit(limit)
    .offset(offset)

  return {
    count: parseInt(total.count),
    data
  }
}

export const findById = async (provinceId) => {
  return db('provinces')
    .leftJoin('districts', 'provinces.province_id', 'districts.province_id')
    .where({ 'provinces.province_id': provinceId })
    .select(
      'provinces.province_slug', 
      'provinces.name', 
      db.raw('COUNT(districts.district_id) as district_count')
    )
    .groupBy('provinces.province_id')
    .first()
}

export const findBySlug = async (provinceSlug) => {
  return db('provinces')
    .leftJoin('districts', 'provinces.province_id', 'districts.province_id')
    .where({ 'provinces.province_slug': provinceSlug.toLowerCase() })
    .select(
      'provinces.province_id',
      'provinces.province_slug', 
      'provinces.name', 
      db.raw('COUNT(districts.district_id) as district_count')
    )
    .groupBy('provinces.province_id')
    .first()
}

export const findDistrictsByProvince = async (provinceId, pagination) => {
  const { offset, limit, sort_by, order } = pagination
  
  const total = await db('districts').where({ province_id: provinceId }).count('district_id as count').first()

  const data = await db('districts')
    .leftJoin('provinces', 'districts.province_id', 'provinces.province_id')
    .leftJoin('divisional_secretariats as ds', 'districts.district_id', 'ds.district_id')
    .where({ 'districts.province_id': provinceId})
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

  return {
    count: parseInt(total.count),
    data
  }
}