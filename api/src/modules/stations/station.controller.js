/**
 * Station controller
 * Handles HTTP requests and responses for station endpoints
 */

import * as stationService from './station.service.js'
import { paginated, single, created, success } from '../../utils/response.js'
import { PAGINATION } from '../../config/constants.js'

export const list = async (req, res, next) => {
  try {
    const pagination = {
      name:         req.query.name?.trim() || undefined,
      station_type: req.query.stationType?.trim() || undefined,
      offset:       parseInt(req.query.offset)  || PAGINATION.DEFAULT_OFFSET,
      limit:        Math.min(parseInt(req.query.limit) || PAGINATION.DEFAULT_LIMIT, PAGINATION.MAX_LIMIT),
      sort_by:      req.query.sortBy || 'name',
      order:        req.query.order  || 'asc'
    }

    const result = await stationService.listStations(pagination)

    res
      .status(200)
      .set('X-Total-Count', result.count)
      .json(paginated(req, result.data, result.count, pagination))
  } catch (err) {
    next(err)
  }
}

export const getByShortCode = async (req, res, next) => {
  try {
    const station = await stationService.getStationByShortCode(req.params['shortCode'])

    res.status(200).json(single(station))
  } catch (err) {
    next(err)
  }
}

export const create = async (req, res, next) => {
  try {
    const station = await stationService.createStation(req.body)

    res.status(201).json(created(station))
  } catch (err) {
    next(err)
  }
}

export const update = async (req, res, next) => {
  try {
    const station = await stationService.updateStation(req.params['shortCode'], req.body)

    res.status(200).json(success('Station updated successfully', station))
  } catch (err) {
    next(err)
  }
}
export const getUsers = async (req, res, next) => {
  try {
    const pagination = {
      offset:  parseInt(req.query.offset)  || PAGINATION.DEFAULT_OFFSET,
      limit:   Math.min(parseInt(req.query.limit) || PAGINATION.DEFAULT_LIMIT, PAGINATION.MAX_LIMIT),
      sort_by: req.query.sortBy || 'created_at',
      order:   req.query.order  || 'desc'
    }

    const result = await stationService.getStationUsers(
      req.params['shortCode'],
      pagination,
      req.user
    )

    res
      .status(200)
      .set('X-Total-Count', result.count)
      .json(paginated(req, result.data, result.count, pagination))
  } catch (err) {
    next(err)
  }
}
export const remove = async (req, res, next) => {
  try {
    await stationService.deleteStation(req.params['shortCode'])

    res.status(200).json(success('Station deleted successfully'))
  } catch (err) {
    next(err)
  }
}
