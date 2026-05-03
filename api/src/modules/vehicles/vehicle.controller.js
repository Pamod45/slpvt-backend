import * as vehicleService from './vehicle.service.js'
import { paginated, single, created, success } from '../../utils/response.js'
import { PAGINATION } from '../../config/constants.js'

export const list = async (req, res, next) => {
  try {
    const filters = {
      owner_nic:           req.query.ownerNic?.trim()           || undefined,
      owner_name:          req.query.ownerName?.trim()          || undefined,
      police_status:       req.query.policeStatus               || undefined,
      make_model:          req.query.makeModel?.trim()          || undefined,
      has_device:          req.query.hasDevice,
      ds_division_slug:    req.query.dsDivisionSlug?.trim()      || undefined,
      district_slug:       req.query.districtSlug?.trim()        || undefined,
      province_slug:       req.query.provinceSlug?.trim()        || undefined
    }

    const pagination = {
      offset:  parseInt(req.query.offset) || PAGINATION.DEFAULT_OFFSET,
      limit:   Math.min(parseInt(req.query.limit) || PAGINATION.DEFAULT_LIMIT, PAGINATION.MAX_LIMIT),
      sort_by: req.query.sortBy || 'created_at',
      order:   req.query.order  || 'desc'
    }

    const result = await vehicleService.listVehicles(filters, pagination)

    res.status(200).set('X-Total-Count', result.count).json(paginated(req, result.data, result.count, pagination))
  } catch (err) { next(err) }
}

export const getByRegistrationNumber = async (req, res, next) => {
  try {
    const vehicle = await vehicleService.getVehicle(req.params['registrationNumber'])
    res.status(200).json(single(vehicle))
  } catch (err) { next(err) }
}

export const register = async (req, res, next) => {
  try {
    const vehicle = await vehicleService.registerVehicle(req.body)
    res.status(201).json(created(vehicle))
  } catch (err) { next(err) }
}

export const update = async (req, res, next) => {
  try {
    const vehicle = await vehicleService.updateVehicle(req.params['registrationNumber'], req.body, req.user)
    res.status(200).json(success('Vehicle updated successfully', vehicle))
  } catch (err) { next(err) }
}

