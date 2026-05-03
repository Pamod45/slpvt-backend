/**
 * Station service
 * Business logic for station operations
 */

import * as stationRepository from './station.repository.js'
import * as provinceRepository from '../provinces/province.repository.js'
import * as districtRepository from '../districts/district.repository.js'
import * as dsRepository from '../divisional-secretariats/divisional-secretariat.repository.js'
import { format } from './station.presenter.js'
import { NotFoundError, ConflictError } from '../../utils/errors.js'
import { STATION_TYPES } from '../../config/constants.js'


const resolveLocationIds = async (data) => {
  const result = { ...data }

  if (result.station_type === STATION_TYPES.POLICE_HEADQUARTERS) {
    delete result.province_slug
    delete result.district_slug
    delete result.ds_division_slug
  } else if (result.station_type === STATION_TYPES.RANGE_OFFICE) {
    delete result.district_slug
    delete result.ds_division_slug
  } else if (result.station_type === STATION_TYPES.DIVISION_OFFICE) {
    delete result.province_slug
    delete result.ds_division_slug
  } else if (result.station_type === STATION_TYPES.POLICE_POST) {
    delete result.province_slug
    delete result.district_slug
  }

  if (result.province_slug) {
    const province = await provinceRepository.findBySlug(result.province_slug)
    if (!province) throw new NotFoundError('Province not found')
    result.province_id = province.province_id
    delete result.province_slug
  }

  if (result.district_slug) {
    const district = await districtRepository.findBySlug(result.district_slug)
    if (!district) throw new NotFoundError('District not found')
    result.district_id = district.district_id
    delete result.district_slug
  }

  if (result.ds_division_slug) {
    const ds = await dsRepository.findBySlug(result.ds_division_slug)
    if (!ds) throw new NotFoundError('DS Division not found')
    result.ds_division_id = ds.ds_division_id
    delete result.ds_division_slug
  }

  return result
}

export const listStations = async (pagination) => {
  const result = await stationRepository.findAll(pagination)
  return { count: result.count, data: result.data.map(format) }
}

export const getStationByShortCode = async (shortCode) => {
  const station = await stationRepository.findByShortCode(shortCode)

  if (!station) {
    throw new NotFoundError('Station not found')
  }

  return format(station)
}

export const createStation = async (data) => {
  if (data.station_type === STATION_TYPES.POLICE_HEADQUARTERS) {
    const existingHq = await stationRepository.findByType(STATION_TYPES.POLICE_HEADQUARTERS)
    if (existingHq) {
      throw new ConflictError('A Police Headquarters already exists')
    }
  }

  const existingName = await stationRepository.findByNameIncludingDeleted(data.name)
  if (existingName) {
    throw new ConflictError('A station with this name already exists')
  }

  const existingCode = await stationRepository.findByShortCodeIncludingDeleted(data.short_code)
  if (existingCode) {
    throw new ConflictError('A station with this short code already exists')
  }

  const stationData = await resolveLocationIds(data)

  await stationRepository.create(stationData)
  const created = await stationRepository.findByShortCode(data.short_code)
  return format(created)
}

export const updateStation = async (shortCode, data) => {
  const station = await stationRepository.findByShortCode(shortCode)

  if (!station) {
    throw new NotFoundError('Station not found')
  }

  if (data.station_type === STATION_TYPES.POLICE_HEADQUARTERS && station.station_type !== STATION_TYPES.POLICE_HEADQUARTERS) {
    const existingHq = await stationRepository.findByType(STATION_TYPES.POLICE_HEADQUARTERS)
    if (existingHq) {
      throw new ConflictError('A Police Headquarters already exists')
    }
  }

  if (data.name && data.name !== station.name) {
    const existingName = await stationRepository.findByNameIncludingDeleted(data.name)
    if (existingName) {
      throw new ConflictError('A station with this name already exists')
    }
  }

  if (data.short_code && data.short_code !== station.short_code) {
    const existingCode = await stationRepository.findByShortCodeIncludingDeleted(data.short_code)
    if (existingCode) {
      throw new ConflictError('A station with this short code already exists')
    }
  }

  const stationData = await resolveLocationIds(data)

  await stationRepository.update(station.station_id, stationData)
  const updated = await stationRepository.findByShortCode(data.short_code ?? shortCode)
  return format(updated)
}

export const deleteStation = async (shortCode) => {
  const station = await stationRepository.findByShortCode(shortCode)

  if (!station) {
    throw new NotFoundError('Station not found')
  }

  const activeUserCount = await stationRepository.countActiveUsersByStation(station.station_id)

  if (activeUserCount > 0) {
    throw new ConflictError('Cannot delete a station that has active users assigned to it')
  }

  await stationRepository.softDelete(station.station_id)
}


