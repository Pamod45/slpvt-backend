import { Router } from 'express'
import * as driverController from './driver.controller.js'
import { verifyJWT } from '../../middleware/auth.js'
import { requirePermission } from '../../middleware/rbac.js'
import { validateBody, validateParams, validateQuery } from '../../middleware/validate.js'
import { standardLimiter } from '../../middleware/rateLimiter.js'
import {
  driverParamsSchema,
  driverQuerySchema,
  driverAssignmentQuerySchema,
  createDriverSchema,
  updateDriverSchema
} from './driver.validator.js'

const router = Router()

router.use(verifyJWT)

router.get(
  '/',
  standardLimiter,
  requirePermission('drivers:read'),
  validateQuery(driverQuerySchema),
  driverController.list
)

router.get(
  '/:licenseNumber',
  standardLimiter,
  requirePermission('drivers:read'),
  validateParams(driverParamsSchema),
  driverController.getById
)

router.post(
  '/',
  standardLimiter,
  requirePermission('drivers:create'),
  validateBody(createDriverSchema),
  driverController.register
)

router.patch(
  '/:licenseNumber',
  standardLimiter,
  requirePermission('drivers:update-status'),
  validateParams(driverParamsSchema),
  validateBody(updateDriverSchema),
  driverController.updateStatus
)

router.get(
  '/:licenseNumber/assignments',
  standardLimiter,
  requirePermission('drivers:read'),
  validateParams(driverParamsSchema),
  validateQuery(driverAssignmentQuerySchema),
  driverController.listAssignments
)

export default router
