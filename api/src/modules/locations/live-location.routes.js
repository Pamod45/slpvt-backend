/**
 * Live location routes
 * Officer-facing — JWT auth required
 * Returns current vehicle presence within a jurisdiction boundary
 */

import { Router } from 'express'
import { liveLocations } from './location.controller.js'
import { verifyJWT } from '../../middleware/auth.js'
import { requirePermission } from '../../middleware/rbac.js'
import { validateQuery } from '../../middleware/validate.js'
import { locationLimiter } from '../../middleware/rateLimiter.js'
import { liveLocationsQuerySchema } from './location.validator.js'

const router = Router()

// GET /api/v1/live-locations?province_slug=western
// GET /api/v1/live-locations?district_slug=colombo
// GET /api/v1/live-locations?ds_division_slug=colombo
router.get(
  '/',
  locationLimiter,
  verifyJWT,
  requirePermission('vehicles:location:read'),
  validateQuery(liveLocationsQuerySchema),
  liveLocations
)

export default router
