/**
 * Station routes
 * Read access — all authenticated roles
 * Write access — SUPER_ADMIN only
 */

import { Router } from 'express'
import * as stationController from './station.controller.js'
import { verifyJWT } from '../../middleware/auth.js'
import { requirePermission } from '../../middleware/rbac.js'
import { validateBody, validateParams, validateQuery } from '../../middleware/validate.js'
import { standardLimiter } from '../../middleware/rateLimiter.js'
import {
  stationShortCodeParamsSchema,
  stationQuerySchema,
  stationUsersQuerySchema,
  createStationSchema,
  updateStationSchema
} from './station.validator.js'

const router = Router()

// GET /api/v1/stations
router.get(
  '/',
  standardLimiter,
  verifyJWT,
  requirePermission('stations:read'),
  validateQuery(stationQuerySchema),
  stationController.list
)

// GET /api/v1/stations/:shortCode
router.get(
  '/:shortCode',
  standardLimiter,
  verifyJWT,
  requirePermission('stations:read'),
  validateParams(stationShortCodeParamsSchema),
  stationController.getByShortCode
)

// POST /api/v1/stations
router.post(
  '/',
  standardLimiter,
  verifyJWT,
  requirePermission('stations:write'),
  validateBody(createStationSchema),
  stationController.create
)

// PUT /api/v1/stations/:shortCode
router.put(
  '/:shortCode',
  standardLimiter,
  verifyJWT,
  requirePermission('stations:write'),
  validateParams(stationShortCodeParamsSchema),
  validateBody(updateStationSchema),
  stationController.update
)

// GET /api/v1/stations/:shortCode/users
router.get(
  '/:shortCode/users',
  standardLimiter,
  verifyJWT,
  requirePermission('users:read'),
  validateParams(stationShortCodeParamsSchema),
  validateQuery(stationUsersQuerySchema),
  stationController.getUsers
)


// DELETE /api/v1/stations/:shortCode
router.delete(
  '/:shortCode',
  standardLimiter,
  verifyJWT,
  requirePermission('stations:delete'),
  validateParams(stationShortCodeParamsSchema),
  stationController.remove
)

export default router
