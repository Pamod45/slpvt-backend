import * as driverService from './driver.service.js'
import { paginated, single, created, success } from '../../utils/response.js'
import { PAGINATION } from '../../config/constants.js'

export const list = async (req, res, next) => {
  try {
    const filters = {
      reference_id:    req.query.referenceId?.trim()   || undefined,
      first_name:      req.query.firstName?.trim()     || undefined,
      last_name:       req.query.lastName?.trim()      || undefined,
      police_status:   req.query.policeStatus          || undefined,
      license_expired: req.query.licenseExpired
    }

    const pagination = {
      offset:  parseInt(req.query.offset) || PAGINATION.DEFAULT_OFFSET,
      limit:   Math.min(parseInt(req.query.limit) || PAGINATION.DEFAULT_LIMIT, PAGINATION.MAX_LIMIT),
      sort_by: req.query.sortBy || 'last_name',
      order:   req.query.order  || 'asc'
    }

    const result = await driverService.listDrivers(filters, pagination)

    res.status(200).set('X-Total-Count', result.count).json(paginated(req, result.data, result.count, pagination))
  } catch (err) { next(err) }
}

export const getById = async (req, res, next) => {
  try {
    const driver = await driverService.getDriver(req.params['licenseNumber'])
    res.status(200).json(single(driver))
  } catch (err) { next(err) }
}

export const register = async (req, res, next) => {
  try {
    const driver = await driverService.registerDriver(req.body)
    res.status(201).json(created(driver))
  } catch (err) { next(err) }
}

export const updateStatus = async (req, res, next) => {
  try {
    const driver = await driverService.updateDriverStatus(req.params['licenseNumber'], req.body)
    res.status(200).json(success('Driver status updated successfully', driver))
  } catch (err) { next(err) }
}

