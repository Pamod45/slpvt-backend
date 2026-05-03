import * as locationRepository from '../locations/location.repository.js'
import * as vehicleRepository from '../vehicles/vehicle.repository.js'
import * as provinceRepository from '../provinces/province.repository.js'
import * as districtRepository from '../districts/district.repository.js'
import * as dsRepository from '../divisional-secretariats/divisional-secretariat.repository.js'
import { NotFoundError } from '../../utils/errors.js'
import booleanPointInPolygon from '@turf/boolean-point-in-polygon'
import { point, multiPolygon, polygon } from '@turf/helpers'
import { ForbiddenError } from '../../utils/errors.js'

const enforceScope = (user, provinceId, districtId) => {
  if (user.role === 'SUPER_ADMIN') return;

  if (user.role === 'PROVINCIAL_COMMANDER') {
    if (user.province_id !== provinceId) {
      throw new ForbiddenError('You do not have permission to view reports outside your assigned province.');
    }
  } else if (user.role === 'DISTRICT_COMMANDER') {
    if (user.district_id !== districtId) {
      throw new ForbiddenError('You do not have permission to view reports outside your assigned district.');
    }
  } else {
    throw new ForbiddenError('Insufficient administrative role to view this report.');
  }
}

export const calculateBoundaryCrossings = async (query, user) => {
  const { provinceSlug, districtSlug, dsDivisionSlug, from, to } = query
  const fromDate = new Date(from)
  const toDate = new Date(to)

  let boundaries = []

  if (dsDivisionSlug) {
    const ds = await dsRepository.findBySlug(dsDivisionSlug)
    if (!ds) throw new NotFoundError('DS division not found')
    enforceScope(user, ds.province_id, ds.district_id)

    const boundary = await locationRepository.findDSBoundaryById(ds.ds_division_id)
    if (!boundary) throw new NotFoundError('No boundary data found for this DS division')
    boundaries = [boundary]

  } else if (districtSlug) {
    const district = await districtRepository.findBySlug(districtSlug)
    if (!district) throw new NotFoundError('District not found')
    enforceScope(user, district.province_id, district.district_id)

    const boundary = await locationRepository.findDistrictBoundaryById(district.district_id)
    if (!boundary) throw new NotFoundError('No boundary data found for this district')
    boundaries = [boundary]

  } else if (provinceSlug) {
    const province = await provinceRepository.findBySlug(provinceSlug)
    if (!province) throw new NotFoundError('Province not found')
    
    if (user.role === 'DISTRICT_COMMANDER') {
      throw new ForbiddenError('District commanders cannot run reports at the full provincial level.');
    }
    enforceScope(user, province.province_id, null)

    const districtIds = await districtRepository.findIdsByProvinceId(province.province_id)
    if (!districtIds.length) throw new NotFoundError('No districts found for this province')

    boundaries = await locationRepository.findDistrictBoundariesByIds(districtIds)
    if (!boundaries.length) throw new NotFoundError('No boundary data found for this province')
  }
  
  const turfPolygons = boundaries.map(b => {
    if (b.boundary.type === 'Polygon') {
      return polygon(b.boundary.coordinates)
    } else {
      return multiPolygon(b.boundary.coordinates)
    }
  })

  const isInside = (lon, lat) => {
    const pingPoint = point([lon, lat])
    return turfPolygons.some(poly => booleanPointInPolygon(pingPoint, poly))
  }

  const candidateDeviceIds = await locationRepository.findDevicesInsideBoundariesBetweenTimes(boundaries, fromDate, toDate)
  
  if (!candidateDeviceIds.length) return []

  const rawPings = await locationRepository.findHistoryForDevicesBetweenTimes(candidateDeviceIds, fromDate, toDate)
  
  const pingsByDevice = {}
  rawPings.forEach(ping => {
    if (!pingsByDevice[ping.device_id]) pingsByDevice[ping.device_id] = []
    pingsByDevice[ping.device_id].push(ping)
  })

  const crossings = []
  
  for (const deviceId of Object.keys(pingsByDevice)) {
    const pings = pingsByDevice[deviceId] 

    let previousState = null

    for (let i = 0; i < pings.length; i++) {
        const ping = pings[i]
        const [lon, lat] = ping.location.coordinates
        
        const currentState = isInside(lon, lat)

        if (previousState !== null && previousState !== currentState) {
            crossings.push({
                device_id: deviceId,
                event: currentState ? 'entry' : 'exit',
                pinged_at: ping.pinged_at,
                coordinates: { latitude: lat, longitude: lon },
                battery_level: ping.battery_level
            })
        }
        previousState = currentState
    }
  }

  if (!crossings.length) return []

  const vehicles = await vehicleRepository.findByDeviceIds(Object.keys(pingsByDevice))
  const vehicleMap = {}
  vehicles.forEach(v => { vehicleMap[v.device_id] = v })

  return crossings
    .filter(c => vehicleMap[c.device_id])
    .map(c => ({
      registration_number: vehicleMap[c.device_id].registration_number,
      police_status: vehicleMap[c.device_id].police_status,
      event: c.event,
      pinged_at: c.pinged_at,
      coordinates: c.coordinates,
      battery_level: c.battery_level
    }))
    .sort((a, b) => a.pinged_at - b.pinged_at)
}
