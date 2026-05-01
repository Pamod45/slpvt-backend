import { Router } from 'express'
import * as vehicleController from './vehicle.controller.js'
import { liveLocation, locationHistory } from '../locations/location.controller.js'
import { verifyJWT } from '../../middleware/auth.js'
import { requirePermission } from '../../middleware/rbac.js'
import { validateBody, validateParams, validateQuery } from '../../middleware/validate.js'
import { standardLimiter, locationLimiter } from '../../middleware/rateLimiter.js'
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
import { locationHistoryQuerySchema } from '../locations/location.validator.js'

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
  '/:registrationNumber',
  standardLimiter,
  requirePermission('vehicles:read'),
  validateParams(vehicleParamsSchema),
  vehicleController.getByRegistrationNumber
)

router.post(
  '/',
  standardLimiter,
  requirePermission('vehicles:create'),
  validateBody(createVehicleSchema),
  vehicleController.register
)

router.patch(
  '/:registrationNumber',
  standardLimiter,
  requirePermission('vehicles:flag-stolen'),
  validateParams(vehicleParamsSchema),
  validateBody(updateVehicleSchema),
  vehicleController.update
)

router.get(
  '/:registrationNumber/live-location',
  locationLimiter,
  requirePermission('vehicles:location:read'),
  validateParams(vehicleParamsSchema),
  liveLocation
)

router.get(
  '/:registrationNumber/location-history',
  locationLimiter,
  requirePermission('vehicles:history:read'),
  validateParams(vehicleParamsSchema),
  validateQuery(locationHistoryQuerySchema),
  locationHistory
)

router.get(
  '/:registrationNumber/assignments',
  standardLimiter,
  requirePermission('vehicles:read'),
  validateParams(vehicleParamsSchema),
  validateQuery(assignmentQuerySchema),
  vehicleController.listAssignments
)

router.post(
  '/:registrationNumber/assignments',
  standardLimiter,
  requirePermission('assignments:create'),
  validateParams(vehicleParamsSchema),
  validateBody(createAssignmentSchema),
  vehicleController.createAssignment
)

router.patch(
  '/:registrationNumber/assignments/:licenseNumber',
  standardLimiter,
  requirePermission('assignments:update'),
  validateParams(assignmentParamsSchema),
  validateBody(closeAssignmentSchema),
  vehicleController.closeAssignment
)

export default router
