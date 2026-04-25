/**
 * Auth service
 * Business logic for authentication
 * Login, refresh token rotation, logout
 * Builds JWT payload with boundary scope from station data
 */

import bcrypt from 'bcrypt'
import jwt from 'jsonwebtoken'
import { env } from '../../config/environment.js'
import { JWT } from '../../config/constants.js'
import {
  findUserByBadgeNumber,
  findUserWithStation,
  createRefreshToken,
  findRefreshToken,
  findUserById,
  markTokenAsUsed,
  deleteRefreshToken,
  deleteAllUserTokens
} from './auth.repository.js'
import {
  UnauthorizedError,
  ForbiddenError
} from '../../utils/errors.js'
import logger from '../../utils/logger.js'

// ─────────────────────────────────────────────
// BUILD JWT PAYLOAD
// joins user to station to get boundary IDs
// embeds scope in token so middleware never
// needs a DB call to determine scope
// ─────────────────────────────────────────────

const buildTokenPayload = async (userId) => {
  const user = await findUserWithStation(userId)

  if (!user) {
    throw new UnauthorizedError('User not found')
  }

  return {
    sub:                 user.user_id,
    role:                user.system_role,
    assigned_station_id: user.assigned_station_id || null,
    ds_division_id:      user.ds_division_id      || null,
    district_id:         user.district_id         || null,
    province_id:         user.province_id         || null
  }
}

// ─────────────────────────────────────────────
// GENERATE TOKENS
// ─────────────────────────────────────────────

const generateAccessToken = (payload) => {
  return jwt.sign(payload, env.jwt.secret, {
    expiresIn: JWT.ACCESS_TOKEN_EXPIRY
  })
}

const getRefreshTokenExpiry = () => {
  const expiry = new Date()
  expiry.setDate(expiry.getDate() + 7)
  return expiry
}

// ─────────────────────────────────────────────
// LOGIN
// ─────────────────────────────────────────────

export const login = async (badgeNumber, password) => {
  // find user by badge number
  const user = await findUserByBadgeNumber(badgeNumber)

  if (!user) {
    // use generic message — do not reveal whether badge number exists
    throw new UnauthorizedError('Invalid badge number or password')
  }

  // verify password against bcrypt hash
  const passwordValid = await bcrypt.compare(password, user.password_hash)

  if (!passwordValid) {
    throw new UnauthorizedError('Invalid badge number or password')
  }

  if (!user.is_active) {
    throw new ForbiddenError('This account has been deactivated')
  }

  logger.info('User login successful', {
    user_id:      user.user_id,
    badge_number: user.badge_number,
    role:         user.system_role
  })

  // build payload with boundary scope from station
  const payload = await buildTokenPayload(user.user_id)

  // generate access token
  const accessToken = generateAccessToken(payload)

  // generate and store refresh token
  const expiresAt    = getRefreshTokenExpiry()
  const refreshToken = await createRefreshToken(user.user_id, expiresAt)

  return {
    access_token:  accessToken,
    refresh_token: refreshToken,
    expires_in:    900,
    token_type:    'Bearer',
    role:          user.system_role,
    user: {
      user_id:      user.user_id,
      badge_number: user.badge_number,
      first_name:   user.first_name,
      last_name:    user.last_name,
      role:         user.system_role
    }
  }
}

// ─────────────────────────────────────────────
// REFRESH
// refresh token rotation with reuse detection
// ─────────────────────────────────────────────

export const refresh = async (rawRefreshToken) => {
  const tokenRecord = await findRefreshToken(rawRefreshToken)

  if (!tokenRecord) {
    throw new UnauthorizedError('Invalid refresh token')
  }

  // reuse detection — token already used means possible theft
  if (tokenRecord.is_used) {
    logger.warn('Refresh token reuse detected — invalidating all user tokens', {
      user_id:  tokenRecord.user_id,
      token_id: tokenRecord.token_id
    })
    // invalidate all tokens for this user immediately
    await deleteAllUserTokens(tokenRecord.user_id)
    throw new UnauthorizedError('Refresh token has already been used. Please log in again.')
  }

  // check token has not expired
  if (new Date() > new Date(tokenRecord.expires_at)) {
    await deleteRefreshToken(tokenRecord.token_id)
    throw new UnauthorizedError('Refresh token has expired. Please log in again.')
  }

  // mark old token as used — rotation
  await markTokenAsUsed(tokenRecord.token_id)

  // verify user still exists and is active
  const user = await findUserById(tokenRecord.user_id)

  if (!user || !user.is_active) {
    throw new UnauthorizedError('User account is no longer active')
  }

  // build fresh payload — picks up any role or scope changes
  const payload = await buildTokenPayload(user.user_id)

  // issue new access token
  const accessToken = generateAccessToken(payload)

  // issue new refresh token — rotation complete
  const expiresAt       = getRefreshTokenExpiry()
  const newRefreshToken = await createRefreshToken(user.user_id, expiresAt)

  logger.info('Token refreshed successfully', {
    user_id: user.user_id
  })

  return {
    access_token:  accessToken,
    refresh_token: newRefreshToken,
    expires_in:    900,
    token_type:    'Bearer'
  }
}

// ─────────────────────────────────────────────
// LOGOUT
// ─────────────────────────────────────────────

export const logout = async (rawRefreshToken) => {
  const tokenRecord = await findRefreshToken(rawRefreshToken)

  if (!tokenRecord) {
    // token not found — already logged out or invalid
    // return success anyway — idempotent logout
    return
  }

  await deleteRefreshToken(tokenRecord.token_id)

  logger.info('User logged out', {
    user_id: tokenRecord.user_id
  })
}