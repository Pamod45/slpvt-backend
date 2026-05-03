import * as driverRepository from './driver.repository.js'
import { NotFoundError, ConflictError } from '../../utils/errors.js'

const format = ({ driver_id, driver_reference_id, created_at, updated_at, deleted_at, ...rest }) => rest

export const listDrivers = async (filters, pagination) => {
  return driverRepository.findAll(filters, pagination)
}

export const getDriver = async (licenseNumber) => {
  const driver = await driverRepository.findByLicenseNumber(licenseNumber)
  if (!driver) throw new NotFoundError('Driver not found')
  return format(driver)
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

export const updateDriverStatus = async (licenseNumber, data) => {
  const driver = await driverRepository.findByLicenseNumber(licenseNumber)
  if (!driver) throw new NotFoundError('Driver not found')
  return format(await driverRepository.update(driver.driver_id, data))
}

