/**
 * Role Based Access Control middleware
 * Two separate concerns:
 *   1. requirePermission — does this role have permission to perform this action?
 *   2. applyScope       — what data boundary does this user operate within?
 * Both run on every protected route after verifyJWT
 */

import {
  ROLE_PERMISSIONS,
  ROLE_SCOPE,
  ROLE_CREATION_CEILING,
  SCOPE_TYPES
} from '../config/constants.js'
import { ForbiddenError } from '../utils/errors.js'
import logger from '../utils/logger.js'

// ─────────────────────────────────────────────
// PERMISSION CHECK
// ─────────────────────────────────────────────

export const requirePermission = (permission) => {
  return (req, res, next) => {
    try {
      const { role } = req.user

      if (!role) {
        throw new ForbiddenError('No role assigned to this user')
      }

      const allowed = ROLE_PERMISSIONS[role]

      if (!allowed) {
        throw new ForbiddenError(`Role ${role} has no permissions defined`)
      }

      if (allowed.includes('*')) {
        logger.debug('Permission granted via wildcard', { role, permission })
        return next()
      }

      if (!allowed.includes(permission)) {
        logger.debug('Permission denied', { role, permission })
        throw new ForbiddenError(
          `Role ${role} does not have permission to perform: ${permission}`
        )
      }

      logger.debug('Permission granted', { role, permission })
      next()
    } catch (err) {
      next(err)
    }
  }
}

// ─────────────────────────────────────────────
// SCOPE FILTER
// ─────────────────────────────────────────────

export const applyScope = (req, res, next) => {
  try {
    const {
      role,
      assigned_station_id,
      ds_division_id,
      district_id,
      province_id
    } = req.user

    const scopeType = ROLE_SCOPE[role]

    switch (scopeType) {
      case SCOPE_TYPES.COUNTRY:
        req.scope = {
          type: SCOPE_TYPES.COUNTRY
        }
        break

      case SCOPE_TYPES.PROVINCE:
        req.scope = {
          type:        SCOPE_TYPES.PROVINCE,
          province_id: province_id
        }
        break

      case SCOPE_TYPES.DISTRICT:
        req.scope = {
          type:        SCOPE_TYPES.DISTRICT,
          district_id: district_id
        }
        break

      case SCOPE_TYPES.DIVISIONAL:
        req.scope = {
          type:                SCOPE_TYPES.DIVISIONAL,
          assigned_station_id: assigned_station_id,
          ds_division_id:      ds_division_id
        }
        break

      case SCOPE_TYPES.NONE:
        req.scope = {
          type: SCOPE_TYPES.NONE
        }
        break

      default:
        throw new ForbiddenError(`Unknown scope type for role: ${role}`)
    }

    logger.debug('Scope applied', {
      role,
      scope: req.scope
    })

    next()
  } catch (err) {
    next(err)
  }
}

// ─────────────────────────────────────────────
// ROLE CREATION GUARD
// used in user creation service layer not as middleware
// ─────────────────────────────────────────────

export const canCreateRole = (requestingRole, targetRole) => {
  const ceiling = ROLE_CREATION_CEILING[requestingRole]

  if (!ceiling) return false

  return ceiling.includes(targetRole)
}