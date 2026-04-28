/**
 * User routes
 */

import { Router } from 'express'
import * as userController from './user.controller.js'
import { verifyJWT } from '../../middleware/auth.js'
import { requirePermission } from '../../middleware/rbac.js'
import { validateBody, validateParams, validateQuery } from '../../middleware/validate.js'
import { standardLimiter } from '../../middleware/rateLimiter.js'
import {
  userParamsSchema,
  userQuerySchema,
  createUserSchema,
  updateUserSchema,
  updatePasswordSchema
} from './user.validator.js'

const router = Router()

// All routes require authentication
router.use(verifyJWT)

// ─────────────────────────────────────────────
// ADMIN & PROFILE ENDPOINTS
// ─────────────────────────────────────────────

router.get(
  '/',
  standardLimiter,
  requirePermission('users:read'),
  validateQuery(userQuerySchema),
  userController.list
)

router.get(
  '/:badgeNumber',
  standardLimiter,
  requirePermission('users:read'),
  validateParams(userParamsSchema),
  userController.getByBadge
)

router.post(
  '/',
  standardLimiter,
  requirePermission('users:create'),
  validateBody(createUserSchema),
  userController.create
)

router.patch(
  '/:badgeNumber',
  standardLimiter,
  requirePermission('users:update'),
  validateParams(userParamsSchema),
  validateBody(updateUserSchema),
  userController.updateByBadge
)

router.put(
  '/:badgeNumber/password',
  standardLimiter,
  validateParams(userParamsSchema),
  validateBody(updatePasswordSchema),
  userController.updatePassword
)

router.delete(
  '/:badgeNumber',
  standardLimiter,
  requirePermission('users:delete'),
  validateParams(userParamsSchema),
  userController.softDelete
)

export default router
