/**
 * Auth routes
 * Public endpoints — no JWT required
 * Rate limited to prevent brute force attacks
 */

import { Router } from 'express'
import * as authController from './auth.controller.js'
import { validateBody } from '../../middleware/validate.js'
import { authLimiter } from '../../middleware/rateLimiter.js'
import { loginSchema, refreshSchema, logoutSchema } from './auth.validator.js'

const router = Router()

// POST /api/v1/auth/login
router.post(
  '/login',
  authLimiter,
  validateBody(loginSchema),
  authController.login
)

// POST /api/v1/auth/refresh
router.post(
  '/refresh',
  authLimiter,
  validateBody(refreshSchema),
  authController.refresh
)

// POST /api/v1/auth/logout
router.post(
  '/logout',
  authLimiter,
  validateBody(logoutSchema),
  authController.logout
)

export default router