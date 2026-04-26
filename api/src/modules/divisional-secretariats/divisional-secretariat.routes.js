/**
 * Divisional Secretariat routes
 * Read access — all authenticated roles
 */

import { Router } from 'express'
import * as dsController from './divisional-secretariat.controller.js'
import { verifyJWT } from '../../middleware/auth.js'
import { requirePermission } from '../../middleware/rbac.js'
import { validateParams, validateQuery } from '../../middleware/validate.js'
import { standardLimiter } from '../../middleware/rateLimiter.js'
import {
  dsParamsSchema,
  dsQuerySchema
} from './divisional-secretariat.validator.js'

const router = Router()

// GET /api/v1/divisional-secretariats
router.get(
  '/',
  standardLimiter,
  verifyJWT,
  requirePermission('divisional_secretariats:read'),
  validateQuery(dsQuerySchema),
  dsController.list
)

// GET /api/v1/divisional-secretariats/:dsSlug
router.get(
  '/:dsSlug',
  standardLimiter,
  verifyJWT,
  requirePermission('divisional_secretariats:read'),
  validateParams(dsParamsSchema),
  dsController.getByDsSlug
)

export default router
