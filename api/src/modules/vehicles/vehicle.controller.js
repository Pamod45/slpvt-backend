import * as vehicleService from './vehicle.service.js'
import { paginated, single, created, success } from '../../utils/response.js'
import { PAGINATION } from '../../config/constants.js'

export const list = async (req, res, next) => {
  try {
    const filters = {
      registration_number: req.query.registration_number?.trim() || undefined,
      owner_nic:           req.query.owner_nic?.trim()           || undefined,
      owner_name:          req.query.owner_name?.trim()          || undefined,
      police_status:       req.query.police_status               || undefined,
      make_model:          req.query.make_model?.trim()          || undefined,
      has_device:          req.query.has_device,
      ds_division_id:      req.query.ds_division_id              || undefined,
      district_id:         req.query.district_id                 || undefined,
      province_id:         req.query.province_id                 || undefined
    }

    const pagination = {
      offset:  parseInt(req.query.offset) || PAGINATION.DEFAULT_OFFSET,
      limit:   Math.min(parseInt(req.query.limit) || PAGINATION.DEFAULT_LIMIT, PAGINATION.MAX_LIMIT),
      sort_by: req.query.sort_by || 'created_at',
      order:   req.query.order   || 'desc'
    }

    const result = await vehicleService.listVehicles(filters, pagination)

    res.status(200).set('X-Total-Count', result.count).json(paginated(req, result.data, result.count, pagination))
  } catch (err) { next(err) }
}

export const getById = async (req, res, next) => {
  try {
    const vehicle = await vehicleService.getVehicle(req.params['vehicleId'])
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
    const vehicle = await vehicleService.updateVehicle(req.params['vehicleId'], req.body, req.user)
    res.status(200).json(success('Vehicle updated successfully', vehicle))
  } catch (err) { next(err) }
}

export const listAssignments = async (req, res, next) => {
  try {
    const pagination = {
      active_only: req.query.active_only,
      offset:      parseInt(req.query.offset) || PAGINATION.DEFAULT_OFFSET,
      limit:       Math.min(parseInt(req.query.limit) || PAGINATION.DEFAULT_LIMIT, PAGINATION.MAX_LIMIT),
      sort_by:     req.query.sort_by || 'assigned_date',
      order:       req.query.order   || 'desc'
    }

    const result = await vehicleService.getVehicleAssignments(req.params['vehicleId'], pagination)

    res.status(200).set('X-Total-Count', result.count).json(paginated(req, result.data, result.count, pagination))
  } catch (err) { next(err) }
}

export const createAssignment = async (req, res, next) => {
  try {
    const assignment = await vehicleService.createAssignment(req.params['vehicleId'], req.body)
    res.status(201).json(created(assignment))
  } catch (err) { next(err) }
}

export const closeAssignment = async (req, res, next) => {
  try {
    const assignment = await vehicleService.closeAssignment(
      req.params['vehicleId'],
      req.params['assignmentId'],
      req.body
    )
    res.status(200).json(success('Assignment closed successfully', assignment))
  } catch (err) { next(err) }
}
