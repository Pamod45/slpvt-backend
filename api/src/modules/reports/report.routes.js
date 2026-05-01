import { Router } from 'express'
import * as reportController from './report.controller.js'
import { verifyJWT } from '../../middleware/auth.js'
import { requirePermission, requireRole, applyScope } from '../../middleware/rbac.js'
import { validateQuery } from '../../middleware/validate.js'
import { boundaryCrossingSchema } from './report.validator.js'

const router = Router()

router.get(
  '/boundary-crossings',
  verifyJWT,
  requireRole('SUPER_ADMIN', 'PROVINCIAL_COMMANDER', 'DISTRICT_COMMANDER', 'STATION_COMMANDER'),
  requirePermission('vehicles:location:read'),
  applyScope,
  validateQuery(boundaryCrossingSchema),
  reportController.getBoundaryCrossings
)

export default router
