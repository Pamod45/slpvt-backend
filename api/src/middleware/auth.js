/**
 * Authentication middleware
 * Two separate auth schemes:
 *   1. JWT Bearer token — for all human users (officers, admins, DMT)
 *   2. API Key — for tracking devices only (X-Device-Key header)
 * Attaches req.user or req.device after successful verification
 */

import jwt from 'jsonwebtoken'
import { createHash } from 'crypto'
import db from '../db/postgres.js'
import { env } from '../config/environment.js'
import { UnauthorizedError } from '../utils/errors.js'
import logger from '../utils/logger.js'

// ─────────────────────────────────────────────
// JWT AUTH — for human users
// ─────────────────────────────────────────────

export const verifyJWT = (req, res, next) => {
  try {
    const authHeader = req.headers['authorization']

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new UnauthorizedError('Authorization header missing or malformed')
    }

    const token = authHeader.split(' ')[1]

    if (!token) {
      throw new UnauthorizedError('Bearer token missing')
    }

    const decoded = jwt.verify(token, env.jwt.secret)


    req.user = {
      user_id:             decoded.sub,
      badge_number:        decoded.badge_number,
      role:                decoded.role,
      assigned_station_id: decoded.assigned_station_id || null,
      ds_division_id:      decoded.ds_division_id      || null,
      district_id:         decoded.district_id         || null,
      province_id:         decoded.province_id         || null
    }

    logger.debug('JWT verified', {
      user_id: req.user.user_id,
      role:    req.user.role,
      path:    req.originalUrl
    })

    next()
  } catch (err) {
    next(err)
  }
}

// ─────────────────────────────────────────────
// API KEY AUTH — for tracking devices only
// ─────────────────────────────────────────────

export const verifyDeviceKey = async (req, res, next) => {
  try {
    const rawKey = req.headers['x-device-key']

    if (!rawKey) {
      throw new UnauthorizedError('X-Device-Key header is missing')
    }

    // hash the raw key and look it up in the database
    const hashedKey = createHash('sha256')
      .update(rawKey)
      .digest('hex')

    const device = await db('tracking_devices')
      .where({ api_key_hash: hashedKey })
      .first()

    if (!device) {
      throw new UnauthorizedError('Invalid device API key')
    }

    if (device.admin_status === 'DECOMMISSIONED') {
      throw new UnauthorizedError('Device has been decommissioned')
    }

    if (device.admin_status === 'UNDER_REPAIR') {
      throw new UnauthorizedError('Device is currently under repair')
    }

    req.device = {
      device_id:     device.device_id,
      serial_number: device.serial_number,
      admin_status:  device.admin_status
    }

    logger.debug('Device API key verified', {
      device_id:     req.device.device_id,
      serial_number: req.device.serial_number
    })

    next()
  } catch (err) {
    next(err)
  }
}