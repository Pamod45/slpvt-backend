import { LocationPing, DistrictBoundary, DSBoundary } from './location.model.js'
import { ConflictError } from '../../utils/errors.js'

const LIVE_WINDOW_MS = 10 * 60 * 1000 // 10 minutes

export const insertPing = async (pingData) => {
  try {
    const ping = new LocationPing(pingData)
    return await ping.save()
  } catch (err) {
    if (err.code === 11000) {
      throw new ConflictError('A ping from this device at this timestamp already exists')
    }
    throw err
  }
}

export const findLatestPingByDeviceId = async (deviceId) => {
  return LocationPing
    .findOne({ device_id: deviceId })
    .sort({ pinged_at: -1 })
    .lean()
}

export const findHistoryByDeviceId = async (deviceId, fromDate, toDate, spatial, { offset, limit }) => {
  const match = {
    device_id: deviceId,
    pinged_at: { $gte: fromDate, $lte: toDate }
  }

  if (spatial) {
    match.location = {
      $geoWithin: {
        $centerSphere: [[spatial.lng, spatial.lat], spatial.radius / 6378100]
      }
    }
  }

  const result = await LocationPing.aggregate([
    { $match: match },
    { $sort: { pinged_at: 1 } },
    {
      $facet: {
        total: [{ $count: 'count' }],
        data:  [{ $skip: offset }, { $limit: limit }]
      }
    }
  ])

  return {
    count: result[0]?.total[0]?.count || 0,
    data:  result[0]?.data || []
  }
}

// ─────────────────────────────────────────────
// BOUNDARY LOOKUPS
// ─────────────────────────────────────────────

export const findDistrictBoundaryById = async (districtId) => {
  return DistrictBoundary.findOne({ district_id: districtId }).lean()
}

export const findDistrictBoundariesByIds = async (districtIds) => {
  return DistrictBoundary.find({ district_id: { $in: districtIds } }).lean()
}

export const findDSBoundaryById = async (dsDivisionId) => {
  return DSBoundary.findOne({ ds_division_id: dsDivisionId }).lean()
}

// ─────────────────────────────────────────────
// SPATIAL LIVE LOCATION QUERY
// Returns the latest ping per device within the last 10 minutes
// that falls inside any of the provided GeoJSON boundaries
// ─────────────────────────────────────────────

export const findLiveLocationsWithinBoundaries = async (boundaries) => {
  const now = new Date()
  const since = new Date(now.getTime() - LIVE_WINDOW_MS)
  
  // const now = new Date("2026-05-01T22:04:00.000Z")
  // const since = new Date("2026-05-01T21:54:00.000Z")

  const geoConditions = boundaries.map(b => ({
    location: { $geoWithin: { $geometry: b.boundary } }
  }))

  return LocationPing.aggregate([
    {
      $match: {
        pinged_at: { $gte: since, $lte: now },
        $or: geoConditions
      }
    },
    { $sort: { pinged_at: -1 } },
    {
      $group: {
        _id:  '$device_id',
        doc:  { $first: '$$ROOT' }
      }
    },
    { $replaceRoot: { newRoot: '$doc' } }
  ])
}

// ─────────────────────────────────────────────
// BOUNDARY CROSSING REPORT FUNCTIONS
// ─────────────────────────────────────────────

export const findDevicesInsideBoundariesBetweenTimes = async (boundaries, fromDate, toDate) => {
  const geoConditions = boundaries.map(b => ({
    location: { $geoWithin: { $geometry: b.boundary } }
  }))

  const result = await LocationPing.aggregate([
    {
      $match: {
        pinged_at: { $gte: fromDate, $lte: toDate },
        $or: geoConditions
      }
    },
    { $group: { _id: '$device_id' } }
  ])

  return result.map(r => r._id)
}

export const findHistoryForDevicesBetweenTimes = async (deviceIds, fromDate, toDate) => {
  return LocationPing.aggregate([
    {
      $match: {
        device_id: { $in: deviceIds },
        pinged_at: { $gte: fromDate, $lte: toDate }
      }
    },
    { $sort: { device_id: 1, pinged_at: 1 } }
  ])
}
