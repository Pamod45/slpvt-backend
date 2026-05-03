/**
 * District controller
 * Handles HTTP request and response for district endpoints
 */

import * as districtService from './district.service.js'
import { paginated, single } from '../../utils/response.js'
import { PAGINATION } from '../../config/constants.js'

// ─────────────────────────────────────────────
// GET /api/v1/districts
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

    const result = await districtService.listDistricts(pagination)

    res
      .status(200)
      .set('X-Total-Count', result.count)
      .json(paginated(req, result.data, result.count, pagination))
  } catch (err) {
    next(err)
  }
}

// ─────────────────────────────────────────────
// GET /api/v1/districts/:districtSlug
// ─────────────────────────────────────────────

export const getByDistrictSlug = async (req, res, next) => {
  try {
    const district = await districtService.getDistrictBySlug(req.params['districtSlug'])

    res.status(200).json(single(district))
  } catch (err) {
    next(err)
  }
}

// ─────────────────────────────────────────────
// GET /api/v1/provinces/:provinceSlug/districts
// ─────────────────────────────────────────────

export const getDistrictsByProvince = async (req, res, next) => {
  try {
    const pagination = {
      offset:  parseInt(req.query.offset)  || PAGINATION.DEFAULT_OFFSET,
      limit:   Math.min(parseInt(req.query.limit) || PAGINATION.DEFAULT_LIMIT, PAGINATION.MAX_LIMIT),
      sort_by: req.query.sortBy || 'name',
      order:   req.query.order  || 'asc'
    }

    const result = await districtService.listDistrictsByProvince(
      req.params['provinceSlug'],
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

