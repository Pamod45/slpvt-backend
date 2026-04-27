import { Router } from 'express'
import * as vehicleController from './vehicle.controller.js'
import { verifyJWT } from '../../middleware/auth.js'
import { requirePermission } from '../../middleware/rbac.js'
import { validateBody, validateParams, validateQuery } from '../../middleware/validate.js'
import { standardLimiter } from '../../middleware/rateLimiter.js'
import {
  vehicleParamsSchema,
  assignmentParamsSchema,
  vehicleQuerySchema,
  assignmentQuerySchema,
  createVehicleSchema,
  updateVehicleSchema,
  createAssignmentSchema,
  closeAssignmentSchema
} from './vehicle.validator.js'

const router = Router()

router.use(verifyJWT)

router.get(
  '/',
  standardLimiter,
  requirePermission('vehicles:read'),
  validateQuery(vehicleQuerySchema),
  vehicleController.list
)

router.get(
  '/:vehicleId',
  standardLimiter,
  requirePermission('vehicles:read'),
  validateParams(vehicleParamsSchema),
  vehicleController.getById
)

router.post(
  '/',
  standardLimiter,
  requirePermission('vehicles:create'),
  validateBody(createVehicleSchema),
  vehicleController.register
)

router.patch(
  '/:vehicleId',
  standardLimiter,
  requirePermission('vehicles:flag-stolen'),
  validateParams(vehicleParamsSchema),
  validateBody(updateVehicleSchema),
  vehicleController.update
)

router.get(
  '/:vehicleId/assignments',
  standardLimiter,
  requirePermission('vehicles:read'),
  validateParams(vehicleParamsSchema),
  validateQuery(assignmentQuerySchema),
  vehicleController.listAssignments
)

router.post(
  '/:vehicleId/assignments',
  standardLimiter,
  requirePermission('assignments:create'),
  validateParams(vehicleParamsSchema),
  validateBody(createAssignmentSchema),
  vehicleController.createAssignment
)

router.patch(
  '/:vehicleId/assignments/:assignmentId',
  standardLimiter,
  requirePermission('assignments:update'),
  validateParams(assignmentParamsSchema),
  validateBody(closeAssignmentSchema),
  vehicleController.closeAssignment
)

export default router
