/**
 * Auth controller
 * Handles HTTP request and response for auth endpoints
 * No business logic here — delegates everything to auth service
 */

import * as authService from './auth.service.js'
import logger from '../../utils/logger.js'

// ─────────────────────────────────────────────
// POST /api/v1/auth/login
// ─────────────────────────────────────────────

export const login = async (req, res, next) => {
  try {
    const { badge_number, password } = req.body

    const result = await authService.login(badge_number, password)

    res.status(200).json(result)
  } catch (err) {
    next(err)
  }
}

// ─────────────────────────────────────────────
// POST /api/v1/auth/refresh
// ─────────────────────────────────────────────

export const refresh = async (req, res, next) => {
  try {
    const { refresh_token } = req.body

    const result = await authService.refresh(refresh_token)

    res.status(200).json(result)
  } catch (err) {
    next(err)
  }
}

// ─────────────────────────────────────────────
// POST /api/v1/auth/logout
// ─────────────────────────────────────────────

export const logout = async (req, res, next) => {
  try {
    const { refresh_token } = req.body

    await authService.logout(refresh_token)

    res.status(204).send()
  } catch (err) {
    next(err)
  }
}