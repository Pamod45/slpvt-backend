/**
 * District routes
 * Read access — all authenticated roles
 */

import { Router } from 'express'
import * as districtController from './district.controller.js'
import { verifyJWT } from '../../middleware/auth.js'
import { requirePermission } from '../../middleware/rbac.js'
import { validateParams, validateQuery } from '../../middleware/validate.js'
import { standardLimiter } from '../../middleware/rateLimiter.js'
import {
  districtParamsSchema,
  districtQuerySchema
} from './district.validator.js'

const router = Router()

// GET /api/v1/districts
router.get(
  '/',
  standardLimiter,
  verifyJWT,
  requirePermission('districts:read'),
  validateQuery(districtQuerySchema),
  districtController.list
)

// GET /api/v1/districts/:districtSlug
router.get(
  '/:districtSlug',
  standardLimiter,
  verifyJWT,
  requirePermission('districts:read'),
  validateParams(districtParamsSchema),
  districtController.getByDistrictSlug
)

// GET /api/v1/districts/:districtSlug/divisional-secretariats
router.get(
  '/:districtSlug/divisional-secretariats',
  standardLimiter,
  verifyJWT,
  requirePermission('districts:read'),
  validateParams(districtParamsSchema),
  districtController.getDivisionalSecretariats
)

export default router
