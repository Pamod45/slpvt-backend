import { Router } from 'express'
import * as deviceController from './device.controller.js'
import { verifyJWT } from '../../middleware/auth.js'
import { requirePermission } from '../../middleware/rbac.js'
import { validateBody, validateParams, validateQuery } from '../../middleware/validate.js'
import { standardLimiter } from '../../middleware/rateLimiter.js'
import {
  deviceParamsSchema,
  deviceQuerySchema,
  createDeviceSchema,
  updateDeviceSchema
} from './device.validator.js'

const router = Router()

router.use(verifyJWT)

router.get(
  '/',
  standardLimiter,
  requirePermission('devices:read'),
  validateQuery(deviceQuerySchema),
  deviceController.list
)

router.get(
  '/:deviceId',
  standardLimiter,
  requirePermission('devices:read'),
  validateParams(deviceParamsSchema),
  deviceController.getById
)

router.post(
  '/',
  standardLimiter,
  requirePermission('devices:create'),
  validateBody(createDeviceSchema),
  deviceController.provision
)

router.patch(
  '/:deviceId',
  standardLimiter,
  requirePermission('devices:update'),
  validateParams(deviceParamsSchema),
  validateBody(updateDeviceSchema),
  deviceController.update
)

export default router
