/**
 * Auth repository
 * All database queries related to authentication
 * Handles user lookup, refresh token storage and validation
 */

import { createHash, randomBytes } from 'crypto'
import db from '../../db/postgres.js'

// ─────────────────────────────────────────────
// USER QUERIES
// ─────────────────────────────────────────────

export const findUserByBadgeNumber = async (badgeNumber) => {
  return db('users')
    .where({ badge_number: badgeNumber })
    .whereNull('deleted_at')
    .first()
}

export const findUserById = async (userId) => {
  return db('users')
    .where({ user_id: userId })
    .whereNull('deleted_at')
    .first()
}

// ─────────────────────────────────────────────
// STATION BOUNDARY QUERY
// joins user to their station to get boundary IDs
// used at login to embed scope in JWT payload
// ─────────────────────────────────────────────

export const findUserWithStation = async (userId) => {
  return db('users as u')
    .leftJoin('stations as st', 'u.assigned_station_id', 'st.station_id')
    .where({ 'u.user_id': userId })
    .whereNull('u.deleted_at')
    .select(
      'u.user_id',
      'u.badge_number',
      'u.first_name',
      'u.last_name',
      'u.system_role',
      'u.assigned_station_id',
      'st.ds_division_id  as ds_division_id',
      'st.district_id     as district_id',
      'st.province_id     as province_id',
      'st.station_type'
    )
    .first()
}

// ─────────────────────────────────────────────
// REFRESH TOKEN QUERIES
// ─────────────────────────────────────────────

export const createRefreshToken = async (userId, expiresAt) => {
  const rawToken  = randomBytes(64).toString('hex')
  const tokenHash = createHash('sha256').update(rawToken).digest('hex')

  await db('refresh_tokens').insert({
    user_id:    userId,
    token_hash: tokenHash,
    is_used:    false,
    expires_at: expiresAt
  })

  return rawToken
}

export const findRefreshToken = async (rawToken) => {
  const tokenHash = createHash('sha256').update(rawToken).digest('hex')

  return db('refresh_tokens')
    .where({ token_hash: tokenHash })
    .first()
}

export const markTokenAsUsed = async (tokenId) => {
  return db('refresh_tokens')
    .where({ token_id: tokenId })
    .update({ is_used: true })
}

export const deleteRefreshToken = async (tokenId) => {
  return db('refresh_tokens')
    .where({ token_id: tokenId })
    .delete()
}

export const deleteAllUserTokens = async (userId) => {
  return db('refresh_tokens')
    .where({ user_id: userId })
    .delete()
}