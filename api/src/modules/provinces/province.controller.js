/**
 * Province controller
 * Handles HTTP request and response for province endpoints
 * Delegates all business logic to province service
 */

import * as provinceService from './province.service.js'
import { paginated, single } from '../../utils/response.js'
import { PAGINATION } from '../../config/constants.js'

// ─────────────────────────────────────────────
// GET /api/v1/provinces
// ─────────────────────────────────────────────

export const list = async (req, res, next) => {
  try {
    const pagination = {
      offset:  parseInt(req.query.offset)  || PAGINATION.DEFAULT_OFFSET,
      limit:   Math.min(parseInt(req.query.limit) || PAGINATION.DEFAULT_LIMIT, PAGINATION.MAX_LIMIT),
      sort_by: req.query.sort_by || 'name',
      order:   req.query.order   || 'asc'
    }

    const result = await provinceService.listProvinces(pagination)

    res
      .status(200)
      .set('X-Total-Count', result.count)
      .json(paginated(req, result.data, result.count, pagination))
  } catch (err) {
    next(err)
  }
}

// ─────────────────────────────────────────────
// GET /api/v1/provinces/:provinceSlug
// ─────────────────────────────────────────────

export const getByProvinceSlug = async (req, res, next) => {
  try {
    const province = await provinceService.getProvinceBySlug(req.params['provinceSlug'])

    res.status(200).json(single(province))
  } catch (err) {
    next(err)
  }
}

// ─────────────────────────────────────────────
// GET /api/v1/provinces/:provinceSlug/districts
// ─────────────────────────────────────────────

export const getDistricts = async (req, res, next) => {
  try {
    // const result = await provinceService.getProvinceDistricts(req.params['provinceSlug'])

    const pagination = {
      offset:  parseInt(req.query.offset)  || PAGINATION.DEFAULT_OFFSET,
      limit:   Math.min(parseInt(req.query.limit) || PAGINATION.DEFAULT_LIMIT, PAGINATION.MAX_LIMIT),
      sort_by: req.query.sort_by || 'name',
      order:   req.query.order   || 'asc'
    }

    const result = await provinceService.getProvinceDistricts(
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