import * as locationRepository from './location.repository.js'
import * as vehicleRepository from '../vehicles/vehicle.repository.js'
import * as provinceRepository from '../provinces/province.repository.js'
import * as districtRepository from '../districts/district.repository.js'
import * as dsRepository from '../divisional-secretariats/divisional-secretariat.repository.js'
import { formatLiveLocation, formatLiveLocationWithVehicle, formatHistoryPing } from './location.presenter.js'
import { NotFoundError, UnprocessableError } from '../../utils/errors.js'
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

export const getLiveLocations = async ({ province_slug, district_slug, ds_division_slug }) => {
  let boundaries = []

  if (ds_division_slug) {
    const ds = await dsRepository.findBySlug(ds_division_slug)
    if (!ds) throw new NotFoundError('DS division not found')

    const boundary = await locationRepository.findDSBoundaryById(ds.ds_division_id)
    if (!boundary) throw new NotFoundError('No boundary data found for this DS division')

    boundaries = [boundary]

  } else if (district_slug) {
    const district = await districtRepository.findBySlug(district_slug)
    if (!district) throw new NotFoundError('District not found')

    const boundary = await locationRepository.findDistrictBoundaryById(district.district_id)
    if (!boundary) throw new NotFoundError('No boundary data found for this district')

    boundaries = [boundary]

  } else if (province_slug) {
    const province = await provinceRepository.findBySlug(province_slug)
    if (!province) throw new NotFoundError('Province not found')

    const districtIds = await districtRepository.findIdsByProvinceId(province.province_id)
    if (!districtIds.length) throw new NotFoundError('No districts found for this province')

    boundaries = await locationRepository.findDistrictBoundariesByIds(districtIds)
    if (!boundaries.length) throw new NotFoundError('No boundary data found for this province')
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
