import * as locationRepository from './location.repository.js'
import * as vehicleRepository from '../vehicles/vehicle.repository.js'
import * as provinceRepository from '../provinces/province.repository.js'
import * as districtRepository from '../districts/district.repository.js'
import * as dsRepository from '../divisional-secretariats/divisional-secretariat.repository.js'
import { formatLiveLocation, formatLiveLocationWithVehicle, formatHistoryPing } from './location.presenter.js'
import { NotFoundError, UnprocessableError, ForbiddenError } from '../../utils/errors.js'
import { TIME_WINDOW } from '../../config/constants.js'

export const recordPing = async (device, body) => {
  await locationRepository.insertPing({
    device_id:     device.device_id,
    location:      body.location,
    battery_level: body.battery_level,
    pinged_at:     new Date(body.pinged_at)
  })
}

export const getLiveLocation = async (registrationNumber) => {
  const vehicle = await vehicleRepository.findDeviceIdByRegistrationNumber(registrationNumber)

  if (!vehicle) {
    throw new NotFoundError('Vehicle not found')
  }

  if (!vehicle.device_id) {
    throw new NotFoundError('No tracking device assigned to this vehicle')
  }

  const ping = await locationRepository.findLatestPingByDeviceId(vehicle.device_id)

  if (!ping) {
    throw new NotFoundError('No location data available for this vehicle')
  }

  return formatLiveLocation(ping)
}

const STATION_ROLES    = ['STATION_OFFICER',    'STATION_COMMANDER']
const DISTRICT_ROLES   = ['DISTRICT_OFFICER',   'DISTRICT_COMMANDER']
const PROVINCIAL_ROLES = ['PROVINCIAL_OFFICER', 'PROVINCIAL_COMMANDER']

export const getLiveLocations = async ({ province_slug, district_slug, ds_division_slug }, executor) => {
  const role = executor?.role
  let boundaries = []

  if (ds_division_slug) {
    if (STATION_ROLES.includes(role)) {
      throw new ForbiddenError('Station officers cannot specify a DS division — your boundary is applied automatically')
    }

    const ds = await dsRepository.findBySlug(ds_division_slug)
    if (!ds) throw new NotFoundError('DS division not found')

    if (DISTRICT_ROLES.includes(role) && ds.district_id !== executor.district_id) {
      throw new ForbiddenError('This DS division is outside your district')
    }
    if (PROVINCIAL_ROLES.includes(role) && ds.province_id !== executor.province_id) {
      throw new ForbiddenError('This DS division is outside your province')
    }

    const boundary = await locationRepository.findDSBoundaryById(ds.ds_division_id)
    if (!boundary) throw new NotFoundError('No boundary data found for this DS division')
    boundaries = [boundary]

  } else if (district_slug) {
    if (STATION_ROLES.includes(role)) {
      throw new ForbiddenError('Station officers cannot specify a district — your boundary is applied automatically')
    }

    const district = await districtRepository.findBySlug(district_slug)
    if (!district) throw new NotFoundError('District not found')

    if (DISTRICT_ROLES.includes(role) && district.district_id !== executor.district_id) {
      throw new ForbiddenError('This district is outside your jurisdiction')
    }
    if (PROVINCIAL_ROLES.includes(role) && district.province_id !== executor.province_id) {
      throw new ForbiddenError('This district is outside your province')
    }

    const boundary = await locationRepository.findDistrictBoundaryById(district.district_id)
    if (!boundary) throw new NotFoundError('No boundary data found for this district')
    boundaries = [boundary]

  } else if (province_slug) {
    if (STATION_ROLES.includes(role)) {
      throw new ForbiddenError('Station officers cannot specify a province — your boundary is applied automatically')
    }
    if (DISTRICT_ROLES.includes(role)) {
      throw new ForbiddenError('District officers cannot query at province level')
    }

    const province = await provinceRepository.findBySlug(province_slug)
    if (!province) throw new NotFoundError('Province not found')

    if (PROVINCIAL_ROLES.includes(role) && province.province_id !== executor.province_id) {
      throw new ForbiddenError('This province is outside your jurisdiction')
    }

    const districtIds = await districtRepository.findIdsByProvinceId(province.province_id)
    if (!districtIds.length) throw new NotFoundError('No districts found for this province')
    boundaries = await locationRepository.findDistrictBoundariesByIds(districtIds)
    if (!boundaries.length) throw new NotFoundError('No boundary data found for this province')

  } else {
    // No slug — default to executor's own boundary
    if (STATION_ROLES.includes(role)) {
      const boundary = await locationRepository.findDSBoundaryById(executor.ds_division_id)
      if (!boundary) throw new NotFoundError('No boundary data found for your assigned DS division')
      boundaries = [boundary]
    } else if (DISTRICT_ROLES.includes(role)) {
      const boundary = await locationRepository.findDistrictBoundaryById(executor.district_id)
      if (!boundary) throw new NotFoundError('No boundary data found for your district')
      boundaries = [boundary]
    } else if (PROVINCIAL_ROLES.includes(role)) {
      const districtIds = await districtRepository.findIdsByProvinceId(executor.province_id)
      if (!districtIds.length) throw new NotFoundError('No districts found for your province')
      boundaries = await locationRepository.findDistrictBoundariesByIds(districtIds)
      if (!boundaries.length) throw new NotFoundError('No boundary data found for your province')
    } else {
      // SUPER_ADMIN — no params means all boundaries
      const allDistrictIds = await districtRepository.findAllIds()
      boundaries = await locationRepository.findDistrictBoundariesByIds(allDistrictIds)
    }
  }

  const pings = await locationRepository.findLiveLocationsWithinBoundaries(boundaries)

  if (!pings.length) return []

  const deviceIds = pings.map(p => p.device_id)
  const vehicles  = await vehicleRepository.findByDeviceIds(deviceIds)

  const vehicleMap = {}
  vehicles.forEach(v => { vehicleMap[v.device_id] = v })

  return pings
    .filter(p => vehicleMap[p.device_id])
    .map(p => formatLiveLocationWithVehicle(p, vehicleMap[p.device_id]))
}

export const getLocationHistory = async (registrationNumber, { from, to, lat, lng, radius, offset, limit }) => {
  const vehicle = await vehicleRepository.findDeviceIdByRegistrationNumber(registrationNumber)

  if (!vehicle) throw new NotFoundError('Vehicle not found')
  if (!vehicle.device_id) throw new NotFoundError('No tracking device assigned to this vehicle')

  const now    = new Date()
  const toDate   = to   ? new Date(to)   : now
  const fromDate = from ? new Date(from) : new Date(toDate.getTime() - 60 * 60 * 1000)

  if (toDate <= fromDate) {
    throw new UnprocessableError('to must be after from')
  }

  const diffDays = (toDate - fromDate) / (1000 * 60 * 60 * 24)
  if (diffDays > TIME_WINDOW.MAX_DAYS_HISTORY) {
    throw new UnprocessableError(`Time window cannot exceed ${TIME_WINDOW.MAX_DAYS_HISTORY} days`)
  }

  const spatial = lat !== undefined ? { lat, lng, radius } : null

  const { count, data } = await locationRepository.findHistoryByDeviceId(
    vehicle.device_id,
    fromDate,
    toDate,
    spatial,
    { offset, limit }
  )

  return { count, data: data.map(formatHistoryPing) }
}
