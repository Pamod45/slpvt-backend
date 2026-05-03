import * as assignmentService from './assignment.service.js'
import { paginated, created, success } from '../../utils/response.js'
import { PAGINATION } from '../../config/constants.js'

export const listVehicleAssignments = async (req, res, next) => {
  try {
    const pagination = {
      active_only: req.query.activeOnly,
      offset:      parseInt(req.query.offset) || PAGINATION.DEFAULT_OFFSET,
      limit:       Math.min(parseInt(req.query.limit) || PAGINATION.DEFAULT_LIMIT, PAGINATION.MAX_LIMIT),
      sort_by:     req.query.sortBy || 'assigned_date',
      order:       req.query.order  || 'desc'
    }

    const result = await assignmentService.getVehicleAssignments(req.params['registrationNumber'], pagination)

    res.status(200).set('X-Total-Count', result.count).json(paginated(req, result.data, result.count, pagination))
  } catch (err) { next(err) }
}

export const listDriverAssignments = async (req, res, next) => {
  try {
    const pagination = {
      active_only: req.query.activeOnly,
      offset:      parseInt(req.query.offset) || PAGINATION.DEFAULT_OFFSET,
      limit:       Math.min(parseInt(req.query.limit) || PAGINATION.DEFAULT_LIMIT, PAGINATION.MAX_LIMIT),
      sort_by:     req.query.sortBy || 'assigned_date',
      order:       req.query.order  || 'desc'
    }

    const result = await assignmentService.getDriverAssignments(req.params['licenseNumber'], pagination)

    res.status(200).set('X-Total-Count', result.count).json(paginated(req, result.data, result.count, pagination))
  } catch (err) { next(err) }
}

export const createVehicleAssignment = async (req, res, next) => {
  try {
    const assignment = await assignmentService.createAssignment(req.params['registrationNumber'], req.body)
    res.status(201).json(created(assignment))
  } catch (err) { next(err) }
}

export const closeVehicleAssignment = async (req, res, next) => {
  try {
    const assignment = await assignmentService.closeAssignment(
      req.params['registrationNumber'],
      req.params['licenseNumber'],
      req.body
    )
    res.status(200).json(success('Assignment closed successfully', assignment))
  } catch (err) { next(err) }
}
