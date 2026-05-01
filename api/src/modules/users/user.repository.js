/**
 * User repository
 * Database operations for users table
 */

import db from '../../db/postgres.js'

export const findAll = async (pagination, filters = {}) => {
  const { offset, limit, sort_by, order } = pagination

  const query = db('users').whereNull('users.deleted_at')

  if (filters.system_role) {
    query.where('users.system_role', filters.system_role)
  }
  if (filters.first_name) {
    query.where('users.first_name', 'ilike', `%${filters.first_name}%`)
  }
  if (filters.last_name) {
    query.where('users.last_name', 'ilike', `%${filters.last_name}%`)
  }

  const needsLocation = filters.station_id || filters.district_id || filters.province_id || filters.district_slug || filters.province_slug

  if (needsLocation) {
    query.leftJoin('stations', 'users.assigned_station_id', 'stations.station_id')
  }

  // --- Strict Normalized Geographic Roll-up Logic ---

  if (filters.province_slug) {
    const provinceSubquery = db('provinces').select('province_id').where('slug', filters.province_slug)
    const districtSubquery = db('districts').select('district_id').whereIn('province_id', provinceSubquery)
    const dsSubquery = db('divisional_secretariats').select('ds_division_id').whereIn('district_id', districtSubquery)
    
    query.where(function() {
      this.whereIn('stations.province_id', provinceSubquery)
          .orWhereIn('stations.district_id', districtSubquery)
          .orWhereIn('stations.ds_division_id', dsSubquery)
    })
  } else if (filters.district_slug) {
    const districtSubquery = db('districts').select('district_id').where('slug', filters.district_slug)
    const dsSubquery = db('divisional_secretariats').select('ds_division_id').whereIn('district_id', districtSubquery)
    
    query.where(function() {
      this.whereIn('stations.district_id', districtSubquery)
          .orWhereIn('stations.ds_division_id', dsSubquery)
    })
  }

  if (filters.province_id) {
    const districtSubquery = db('districts').select('district_id').where('province_id', filters.province_id)
    const dsSubquery = db('divisional_secretariats').select('ds_division_id').whereIn('district_id', districtSubquery)

    query.where(function() {
      this.where('stations.province_id', filters.province_id)
          .orWhereIn('stations.district_id', districtSubquery)
          .orWhereIn('stations.ds_division_id', dsSubquery)
    })
  } else if (filters.district_id) {
    const dsSubquery = db('divisional_secretariats').select('ds_division_id').where('district_id', filters.district_id)

    query.where(function() {
      this.where('stations.district_id', filters.district_id)
          .orWhereIn('stations.ds_division_id', dsSubquery)
    })
  } else if (filters.station_id) {
    query.where('users.assigned_station_id', filters.station_id)
  }

  const countQuery = query.clone()
  const total = await countQuery.count('users.user_id as count').first()

  if (!needsLocation) {
    query.leftJoin('stations', 'users.assigned_station_id', 'stations.station_id')
  }

  const data = await query
    .select(
      'users.badge_number', 
      'users.first_name', 
      'users.last_name', 
      'users.system_role', 
      'stations.short_code as station_short_code'
    )
    .orderBy(`users.${sort_by}`, order)
    .limit(limit)
    .offset(offset)

  return {
    count: parseInt(total.count),
    data
  }
}

export const findByBadgeNumber = async (badgeNumber) => {
  return db('users')
    .leftJoin('stations', 'users.assigned_station_id', 'stations.station_id')
    .where({ 'users.badge_number': badgeNumber })
    .whereNull('users.deleted_at')
    .select(
      'users.*',
      'stations.short_code as station_short_code',
      'stations.station_type as station_type'
    )
    .first()
}

export const findById = async (userId) => {
  return db('users')
    .where({ user_id: userId })
    .first()
}

export const create = async (userData) => {
  const [newUser] = await db('users')
    .insert(userData)
    .returning(['user_id', 'badge_number', 'first_name', 'last_name', 'system_role', 'assigned_station_id'])

  return newUser
}

export const update = async (badgeNumber, userData) => {
  const [updatedUser] = await db('users')
    .where({ badge_number: badgeNumber })
    .update({ ...userData, updated_at: db.fn.now() })
    .returning(['user_id', 'badge_number', 'first_name', 'last_name', 'system_role', 'assigned_station_id', 'deleted_at'])

  return updatedUser
}

export const markDeletedAt = async (badgeNumber) => {
  const [deletedUser] = await db('users')
    .where({ badge_number: badgeNumber })
    .update({ deleted_at: db.fn.now(), updated_at: db.fn.now() })
    .returning(['user_id', 'badge_number', 'system_role', 'deleted_at'])

  return deletedUser
}
