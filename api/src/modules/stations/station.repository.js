/**
 * Station repository
 * Database operations for the stations table
 */

import db from '../../db/postgres.js'

const BASE_QUERY = () =>
  db('stations')
    .leftJoin('divisional_secretariats as ds', 'stations.ds_division_id', 'ds.ds_division_id')
    .leftJoin('districts as d', db.raw('COALESCE(ds.district_id, stations.district_id) = d.district_id'))
    .leftJoin('provinces as p', db.raw('COALESCE(d.province_id, stations.province_id) = p.province_id'))
    .select(
      'stations.station_id',
      'stations.station_type',
      'stations.name',
      'stations.short_code',
      'stations.contact_number',
      'stations.latitude',
      'stations.longitude',
      'ds.name as ds_division_name',
      'ds.ds_division_slug',
      'd.name as district_name',
      'd.district_slug',
      'p.name as province_name',
      'p.province_slug'
    )

export const findAll = async (pagination) => {
  const { name, station_type, offset, limit, sort_by, order } = pagination

  const totalQuery = db('stations').whereNull('stations.deleted_at').count('station_id as count').first()
  const dataQuery = BASE_QUERY().whereNull('stations.deleted_at')

  if (name) {
    totalQuery.where('stations.name', 'ilike', `%${name}%`)
    dataQuery.where('stations.name', 'ilike', `%${name}%`)
  }

  if (station_type) {
    totalQuery.where('stations.station_type', station_type)
    dataQuery.where('stations.station_type', station_type)
  }

  const total = await totalQuery

  const data = await dataQuery
    .orderBy(`stations.${sort_by}`, order)
    .limit(limit)
    .offset(offset)

  return {
    count: parseInt(total.count),
    data
  }
}

export const findByName = async (name) => {
  return db('stations').where({ name }).whereNull('deleted_at').first()
}

export const findByShortCode = async (shortCode) => {
  return BASE_QUERY().where({ 'stations.short_code': shortCode }).whereNull('stations.deleted_at').first()
}

export const findByType = async (stationType) => {
  return db('stations').where({ station_type: stationType }).whereNull('deleted_at').first()
}

export const countActiveUsersByStation = async (stationId) => {
  const result = await db('users')
    .where({ assigned_station_id: stationId })
    .whereNull('deleted_at')
    .count('user_id as count')
    .first()

  return parseInt(result.count)
}

export const softDelete = async (stationId) => {
  return db('stations')
    .where({ station_id: stationId })
    .update({ deleted_at: db.fn.now() })
}

export const create = async (stationData) => {
  const [newStation] = await db('stations')
    .insert(stationData)
    .returning('*')

  return newStation
}

export const update = async (stationId, stationData) => {
  const [updatedStation] = await db('stations')
    .where({ station_id: stationId })
    .update({ ...stationData, updated_at: db.fn.now() })
    .returning('*')

  return updatedStation
}
