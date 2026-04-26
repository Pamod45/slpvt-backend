/**
 * Province repository
 * All database queries for provinces
 * Scope is not applied here — all authenticated roles can read all provinces
 */

import db from '../../db/postgres.js'

export const findAll = async (pagination) => {
  const { offset, limit, sort_by, order } = pagination

  const total = await db('provinces').count('province_id as count').first()

  const data = await db('provinces')
    .select('province_id', 'name', 'province_slug', 'created_at', 'updated_at')
    .orderBy(sort_by, order)
    .limit(limit)
    .offset(offset)

  return {
    count: parseInt(total.count),
    data
  }
}

export const findById = async (provinceId) => {
  return db('provinces')
    .where({ province_id: provinceId })
    .select('province_id', 'name', 'province_slug', 'created_at', 'updated_at')
    .first()
}

export const findBySlug = async (provinceSlug) => {
  return db('provinces')
    .where({ province_slug: provinceSlug.toLowerCase() })
    .select('province_id', 'name', 'province_slug', 'created_at', 'updated_at')
    .first()
}

export const findDistrictsByProvince = async (provinceId, pagination) => {
  const { offset, limit, sort_by, order } = pagination
  
  const total = await db('districts').where({ province_id: provinceId }).count('district_id as count').first()

  const data = await db('districts')
    .where({ province_id: provinceId})
    .select('district_id', 'name', 'district_slug', 'created_at', 'updated_at')
    .orderBy(sort_by, order)
    .limit(limit)
    .offset(offset)

  return {
    count: parseInt(total.count),
    data
  }
}