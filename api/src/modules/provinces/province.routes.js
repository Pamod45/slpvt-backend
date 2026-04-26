/**
 * Province routes
 * Read access — all authenticated roles
 * Write access — SUPER_ADMIN only
 */

import { Router } from 'express'
import * as provinceController from './province.controller.js'
import { verifyJWT } from '../../middleware/auth.js'
import { requirePermission } from '../../middleware/rbac.js'
import { ROLES } from '../../config/constants.js'
import { validateBody, validateParams, validateQuery } from '../../middleware/validate.js'
import { standardLimiter } from '../../middleware/rateLimiter.js'
import {
  provinceParamsSchema,
  provinceQuerySchema
} from './province.validator.js'

const router = Router()

// GET /api/v1/provinces
router.get(
  '/',
  standardLimiter,
  verifyJWT,
  requirePermission('provinces:read'),
  validateQuery(provinceQuerySchema),
  provinceController.list
)

// GET /api/v1/provinces/:provinceSlug
router.get(
  '/:provinceSlug',
  standardLimiter,
  verifyJWT,
  requirePermission('provinces:read'),
  validateParams(provinceParamsSchema),
  provinceController.getByProvinceSlug
)

// GET /api/v1/provinces/:provinceSlug/districts
router.get(
  '/:provinceSlug/districts',
  standardLimiter,
  verifyJWT,
  requirePermission('provinces:read'),
  validateParams(provinceParamsSchema),
  provinceController.getDistricts
)


export default router