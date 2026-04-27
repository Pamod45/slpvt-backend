import * as driverRepository from './driver.repository.js'
import { NotFoundError, ConflictError } from '../../utils/errors.js'

export const listDrivers = async (filters, pagination) => {
  return driverRepository.findAll(filters, pagination)
}

export const getDriver = async (driverId) => {
  const driver = await driverRepository.findById(driverId)
  if (!driver) throw new NotFoundError('Driver not found')
  return driver
}

export const registerDriver = async (data) => {
  const [byRef, byLicense] = await Promise.all([
    driverRepository.findByReferenceId(data.driver_reference_id),
    driverRepository.findByLicenseNumber(data.driving_license_number)
  ])

  if (byRef)     throw new ConflictError('A driver with this DMT reference ID already exists')
  if (byLicense) throw new ConflictError('A driver with this license number already exists')

  return driverRepository.create(data)
}

export const updateDriverStatus = async (driverId, data) => {
  const driver = await driverRepository.findById(driverId)
  if (!driver) throw new NotFoundError('Driver not found')
  return driverRepository.update(driverId, data)
}

export const getDriverAssignments = async (driverId, pagination) => {
  const driver = await driverRepository.findById(driverId)
  if (!driver) throw new NotFoundError('Driver not found')
  return driverRepository.findAssignmentsByDriver(driverId, pagination)
}
