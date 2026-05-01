/**
 * Location routes
 * POST — device auth via X-Device-Key header
 * GET  — officer auth via JWT Bearer token
 */

import { Router } from 'express'
import * as locationController from './location.controller.js'
import { verifyDeviceKey } from '../../middleware/auth.js'
import { validateBody } from '../../middleware/validate.js'
import { pingLimiter } from '../../middleware/rateLimiter.js'
import { pingSchema } from './location.validator.js'

const router = Router()

// POST /api/v1/locations
router.post(
  '/',
  pingLimiter,
  verifyDeviceKey,
  validateBody(pingSchema),
  locationController.ping
)

export default router
