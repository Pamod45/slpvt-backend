/**
 * User controller
 * Exposes hierarchy actions for admins & commanders, and "Me" actions
 */

import * as userService from './user.service.js'
import { paginated, single, created, success } from '../../utils/response.js'
import { PAGINATION } from '../../config/constants.js'

export const list = async (req, res, next) => {
  try {
    const pagination = {
      offset:  parseInt(req.query.offset)  || PAGINATION.DEFAULT_OFFSET,
      limit:   Math.min(parseInt(req.query.limit) || PAGINATION.DEFAULT_LIMIT, PAGINATION.MAX_LIMIT),
      sort_by: req.query.sortBy || 'created_at',
      order:   req.query.order  || 'desc'
    }

    const filters = {
      system_role:   req.query.systemRole,
      first_name:    req.query.firstName,
      last_name:     req.query.lastName,
      district_slug: req.query.districtSlug,
      province_slug: req.query.provinceSlug
    }

    const result = await userService.listUsers(pagination, filters, req.user)

    res.status(200).set('X-Total-Count', result.count).json(paginated(req, result.data, result.count, pagination))
  } catch (err) { next(err) }
}

export const getByBadge = async (req, res, next) => {
  try {
    const user = await userService.getUserByBadge(req.params['badgeNumber'], req.user.badge_number)
    res.status(200).json(single(user))
  } catch (err) { next(err) }
}

export const create = async (req, res, next) => {
  try {
    const user = await userService.createUser(req.body, req.user)
    res.status(201).json(created(user))
  } catch (err) { next(err) }
}

export const updateByBadge = async (req, res, next) => {
  try {
    const user = await userService.updateUser(req.params['badgeNumber'], req.body, req.user)
    res.status(200).json(success('User updated successfully', user))
  } catch (err) { next(err) }
}

export const updatePassword = async (req, res, next) => {
  try {
    await userService.updatePassword(req.params['badgeNumber'], req.body.old_password, req.body.new_password, req.user.badge_number)
    res.status(200).json(success('Password updated successfully'))
  } catch (err) { next(err) }
}

export const listByStation = async (req, res, next) => {
  try {
    const pagination = {
      offset:  parseInt(req.query.offset)  || PAGINATION.DEFAULT_OFFSET,
      limit:   Math.min(parseInt(req.query.limit) || PAGINATION.DEFAULT_LIMIT, PAGINATION.MAX_LIMIT),
      sort_by: req.query.sortBy || 'created_at',
      order:   req.query.order  || 'desc'
    }

    const result = await userService.listUsersByStation(
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

export const softDelete = async (req, res, next) => {
  try {
    const user = await userService.deleteUser(req.params['badgeNumber'], req.user.role)
    res.status(200).json(success('User soft deleted successfully', user))
  } catch (err) { next(err) }
}
