import * as deviceService from './device.service.js'
import { paginated, single, created, success } from '../../utils/response.js'
import { PAGINATION } from '../../config/constants.js'

export const list = async (req, res, next) => {
  try {
    const pagination = {
      admin_status:  req.query.admin_status  || undefined,
      serial_number: req.query.serial_number?.trim() || undefined,
      offset:        parseInt(req.query.offset) || PAGINATION.DEFAULT_OFFSET,
      limit:         Math.min(parseInt(req.query.limit) || PAGINATION.DEFAULT_LIMIT, PAGINATION.MAX_LIMIT),
      sort_by:       req.query.sort_by || 'created_at',
      order:         req.query.order   || 'desc'
    }

    const result = await deviceService.listDevices(pagination)

    res.status(200).set('X-Total-Count', result.count).json(paginated(req, result.data, result.count, pagination))
  } catch (err) { next(err) }
}

export const getBySerialNumber = async (req, res, next) => {
  try {
    const device = await deviceService.getDevice(req.params['serialNumber'])
    res.status(200).json(single(device))
  } catch (err) { next(err) }
}

export const provision = async (req, res, next) => {
  try {
    const device = await deviceService.provisionDevice(req.body)
    res.status(201).json(created(device))
  } catch (err) { next(err) }
}

export const update = async (req, res, next) => {
  try {
    const device = await deviceService.updateDevice(req.params['serialNumber'], req.body)
    res.status(200).json(success('Device updated successfully', device))
  } catch (err) { next(err) }
}
