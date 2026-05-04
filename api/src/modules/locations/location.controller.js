import * as locationService from './location.service.js'
import { success, single, paginated } from '../../utils/response.js'

export const ping = async (req, res, next) => {
  try {
    await locationService.recordPing(req.device, req.body)

    res.status(201).json(success('Ping recorded'))
  } catch (err) {
    next(err)
  }
}

export const liveLocation = async (req, res, next) => {
  try {
    const location = await locationService.getLiveLocation(req.params.registrationNumber)

    res.status(200).json(single(location))
  } catch (err) {
    next(err)
  }
}

export const locationHistory = async (req, res, next) => {
  try {
    const offset = parseInt(req.query.offset) || 0
    const limit  = Math.min(parseInt(req.query.limit) || 20, 500)

    const { count, data } = await locationService.getLocationHistory(
      req.params.registrationNumber,
      {
        from:   req.query.from,
        to:     req.query.to,
        lat:    req.query.lat    !== undefined ? parseFloat(req.query.lat)    : undefined,
        lng:    req.query.lng    !== undefined ? parseFloat(req.query.lng)    : undefined,
        radius: req.query.radius !== undefined ? parseInt(req.query.radius)   : undefined,
        offset,
        limit
      }
    )

    res.status(200).json(paginated(req, data, count, { offset, limit }))
  } catch (err) {
    next(err)
  }
}

export const liveLocations = async (req, res, next) => {
  try {
    const query = {
      province_slug:    req.query.provinceSlug,
      district_slug:    req.query.districtSlug,
      ds_division_slug: req.query.dsDivisionSlug
    }

    const data = await locationService.getLiveLocations(query, req.user)

    const offset = parseInt(req.query.offset) || 0
    const limit  = Math.min(parseInt(req.query.limit) || 20, 100)
    const paginatedData = data.slice(offset, offset + limit)

    res.status(200).json(paginated(req, paginatedData, data.length, { offset, limit }))
  } catch (err) {
    next(err)
  }
}
