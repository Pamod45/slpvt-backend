/**
 * Divisional Secretariat controller
 * Handles HTTP request and response for divisional secretariat endpoints
 */

import * as dsService from './divisional-secretariat.service.js'
import { paginated, single } from '../../utils/response.js'
import { PAGINATION } from '../../config/constants.js'

// ─────────────────────────────────────────────
// GET /api/v1/divisional-secretariats
// ─────────────────────────────────────────────

export const list = async (req, res, next) => {
  try {
    const pagination = {
      name:    req.query.name?.trim() || undefined,
      offset:  parseInt(req.query.offset)  || PAGINATION.DEFAULT_OFFSET,
      limit:   Math.min(parseInt(req.query.limit) || PAGINATION.DEFAULT_LIMIT, PAGINATION.MAX_LIMIT),
      sort_by: req.query.sortBy || 'name',
      order:   req.query.order  || 'asc'
    }

    const result = await dsService.listDivisionalSecretariats(pagination)

    res
      .status(200)
      .set('X-Total-Count', result.count)
      .json(paginated(req, result.data, result.count, pagination))
  } catch (err) {
    next(err)
  }
}

// ─────────────────────────────────────────────
// GET /api/v1/districts/:districtSlug/divisional-secretariats
// ─────────────────────────────────────────────

export const getDivisionalSecretariatsByDistrict = async (req, res, next) => {
  try {
    const pagination = {
      offset:  parseInt(req.query.offset)  || PAGINATION.DEFAULT_OFFSET,
      limit:   Math.min(parseInt(req.query.limit) || PAGINATION.DEFAULT_LIMIT, PAGINATION.MAX_LIMIT),
      sort_by: req.query.sortBy || 'name',
      order:   req.query.order  || 'asc'
    }

    const result = await dsService.listDivisionalSecretariatsByDistrict(
      req.params['districtSlug'],
      pagination
    )

    res
      .status(200)
      .set('X-Total-Count', result.count)
      .json(paginated(req, result.data, result.count, pagination))
  } catch (err) {
    next(err)
  }
}

// ─────────────────────────────────────────────
// GET /api/v1/divisional-secretariats/:dsSlug
// ─────────────────────────────────────────────

export const getByDsSlug = async (req, res, next) => {
  try {
    const ds = await dsService.getDivisionalSecretariatBySlug(req.params['dsSlug'])

    res.status(200).json(single(ds))
  } catch (err) {
    next(err)
  }
}
