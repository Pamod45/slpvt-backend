/**
 * User service
 * Business logic for user management and profile updating
 */

import bcrypt from 'bcrypt'
import * as userRepository from './user.repository.js'
import { findByShortCode as findStationByShortCode, findByShortCode as findStationForScope } from '../stations/station.repository.js'
import { NotFoundError, ConflictError, ForbiddenError, ValidationError } from '../../utils/errors.js'
import { ROLE_CREATION_CEILING, ROLE_SCOPE, SCOPE_TO_STATION_TYPE } from '../../config/constants.js'

const checkRoleStationMatch = (role, stationType) => {
  const scope = ROLE_SCOPE[role]
  if (!scope) return

  if (scope === 'none') {
    if (stationType) throw new ValidationError(`Role ${role} cannot be assigned to a station`)
    return
  }

  if (!stationType) return // unassigned is permitted

  const expected = SCOPE_TO_STATION_TYPE[scope]
  if (stationType !== expected) {
    throw new ValidationError(`Role ${role} requires a ${expected} but the provided station is a ${stationType}`)
  }
}

const checkCeiling = (executorRole, targetRole) => {
  if (executorRole === 'SUPER_ADMIN') return true
  const allowedRoles = ROLE_CREATION_CEILING[executorRole] || []
  if (!allowedRoles.includes(targetRole)) {
    throw new ForbiddenError(`Your role (${executorRole}) cannot create or modify users with role: ${targetRole}`)
  }
}

export const listUsers = async (pagination, filters, user) => {
  const finalFilters = { ...filters }

  if (['PROVINCIAL_COMMANDER', 'PROVINCIAL_OFFICER'].includes(user.role)) {
    if (!user.province_id) {
      throw new ForbiddenError('You are not assigned to a province')
    }
    finalFilters.province_id = user.province_id
  } else if (['DISTRICT_COMMANDER', 'DISTRICT_OFFICER'].includes(user.role)) {
    if (!user.district_id) {
      throw new ForbiddenError('You are not assigned to a district')
    }
    finalFilters.district_id = user.district_id
  } else if (['STATION_COMMANDER', 'STATION_OFFICER'].includes(user.role)) {

    if (!user.assigned_station_id) {
      throw new ForbiddenError('You are not assigned to a station')
    }
    finalFilters.station_id = user.assigned_station_id
  }

  return userRepository.findAll(pagination, finalFilters)
}

export const getUserByBadge = async (badgeNumber, executorBadge) => {
  const user = await userRepository.findByBadgeNumber(badgeNumber)

  if (!user) {
    throw new NotFoundError('User not found')
  }

  return {
    badge_number:       user.badge_number,
    first_name:         user.first_name,
    last_name:          user.last_name,
    system_role:        user.system_role,
    station_short_code: user.station_short_code
  }
}

export const createUser = async (data, executorRole) => {
  checkCeiling(executorRole, data.system_role)
  
  const existing = await userRepository.findByBadgeNumber(data.badge_number)
  if (existing) {
    throw new ConflictError('A user with this badge number already exists')
  }

  const salt = await bcrypt.genSalt(10)
  const hashed = await bcrypt.hash(data.password, salt)

  const insertData = { ...data, password_hash: hashed }

  if (insertData.system_role === 'DATA_REGISTRAR') {
    if (!insertData.first_name) insertData.first_name = 'Service'
    if (!insertData.last_name)  insertData.last_name  = 'Account'
  }

  const station = data.station_short_code ? await findStationByShortCode(data.station_short_code) : null
  if (data.station_short_code && !station) throw new NotFoundError('Station not found')
  checkRoleStationMatch(data.system_role, station?.station_type ?? null)
  insertData.assigned_station_id = station?.station_id ?? null
  delete insertData.password
  delete insertData.station_short_code

  const createdUser = await userRepository.create(insertData)
  
  return await getUserByBadge(createdUser.badge_number, executorRole)
}

export const updateUser = async (badgeNumber, data, executor) => {
  const targetUser = await userRepository.findByBadgeNumber(badgeNumber)

  if (!targetUser) throw new NotFoundError('User not found')

  const isSelf = executor.badge_number === targetUser.badge_number

  if (isSelf) {
    if (data.system_role || data.assigned_station_id || data.deleted_at !== undefined || data.station_short_code !== undefined) {
      throw new ForbiddenError('You can only update your first name and last name')
    }
  } else {

    checkCeiling(executor.role, targetUser.system_role)
  
    if (data.system_role) {
      checkCeiling(executor.role, data.system_role)
    }
  }

  let effectiveStationType = targetUser.station_type ?? null

  if (data.station_short_code !== undefined) {
    const station = data.station_short_code ? await findStationByShortCode(data.station_short_code) : null
    if (data.station_short_code && !station) throw new NotFoundError('Station not found')
    data.assigned_station_id = station?.station_id ?? null
    effectiveStationType = station?.station_type ?? null
    delete data.station_short_code
  }

  if (!isSelf) {
    const effectiveRole = data.system_role ?? targetUser.system_role
    checkRoleStationMatch(effectiveRole, effectiveStationType)
  }

  await userRepository.update(badgeNumber, data)

  return await getUserByBadge(badgeNumber, executor.badge_number)
}

export const updatePassword = async (badgeNumber, oldPassword, newPassword, executorBadge) => {
  if (badgeNumber !== executorBadge) {
    throw new ForbiddenError('You can only change your own password')
  }

  const user = await userRepository.findByBadgeNumber(badgeNumber)
  if (!user) throw new NotFoundError('User not found')

  const valid = await bcrypt.compare(oldPassword, user.password_hash)
  if (!valid) throw new ForbiddenError('Old password does not match')

  const salt = await bcrypt.genSalt(10)
  const hashed = await bcrypt.hash(newPassword, salt)

  await userRepository.update(user.badge_number, { password_hash: hashed })
  
  return { success: true }
}

export const listUsersByStation = async (shortCode, pagination, user) => {
  const station = await findStationForScope(shortCode)

  if (!station) throw new NotFoundError('Station not found')

  if (user.role !== 'SUPER_ADMIN') {
    if (user.role === 'PROVINCIAL_COMMANDER') {
      if (station.resolved_province_id !== user.province_id) {
        throw new ForbiddenError('This station is outside your province')
      }
    } else if (user.role === 'DISTRICT_COMMANDER') {
      if (station.resolved_district_id !== user.district_id) {
        throw new ForbiddenError('This station is outside your district')
      }
    } else if (user.role === 'STATION_COMMANDER') {
      if (station.station_id !== user.assigned_station_id) {
        throw new ForbiddenError('You can only view users at your assigned station')
      }
    }
  }

  return userRepository.findAllByStation(station.station_id, pagination)
}

export const deleteUser = async (badgeNumber, executorRole) => {
  const targetUser = await userRepository.findByBadgeNumber(badgeNumber)
  if (!targetUser) throw new NotFoundError('User not found')

  checkCeiling(executorRole, targetUser.system_role)

  await userRepository.markDeletedAt(badgeNumber)
  return { success: true }
}
