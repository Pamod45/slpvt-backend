import * as assignmentRepository from './assignment.repository.js'
import * as vehicleRepository from '../vehicles/vehicle.repository.js'
import { findByLicenseNumber as findDriverByLicense } from '../drivers/driver.repository.js'
import { NotFoundError, ConflictError, ValidationError } from '../../utils/errors.js'

export const getVehicleAssignments = async (registrationNumber, pagination) => {
  const vehicle = await vehicleRepository.findByRegistrationNumber(registrationNumber)
  if (!vehicle) throw new NotFoundError('Vehicle not found')
  return assignmentRepository.findByVehicle(vehicle.vehicle_id, pagination)
}

export const getDriverAssignments = async (licenseNumber, pagination) => {
  const driver = await findDriverByLicense(licenseNumber)
  if (!driver) throw new NotFoundError('Driver not found')
  return assignmentRepository.findByDriver(driver.driver_id, pagination)
}

export const createAssignment = async (registrationNumber, data) => {
  const [vehicle, driver] = await Promise.all([
    vehicleRepository.findByRegistrationNumber(registrationNumber),
    findDriverByLicense(data.license_number)
  ])

  if (!vehicle) throw new NotFoundError('Vehicle not found')
  if (!driver)  throw new NotFoundError('Driver not found')

  const active = await assignmentRepository.findActive(vehicle.vehicle_id)
  if (active) throw new ConflictError('This vehicle already has an active driver assignment')

  return assignmentRepository.create({
    vehicle_id:    vehicle.vehicle_id,
    driver_id:     driver.driver_id,
    assigned_date: data.assigned_date
  })
}

export const closeAssignment = async (registrationNumber, licenseNumber, data) => {
  const vehicle = await vehicleRepository.findByRegistrationNumber(registrationNumber)
  if (!vehicle) throw new NotFoundError('Vehicle not found')

  const assignment = await assignmentRepository.findByVehicleAndLicense(vehicle.vehicle_id, licenseNumber)
  if (!assignment) throw new NotFoundError('No active assignment found for this vehicle and driver')
  if (assignment.returned_date) throw new ConflictError('This assignment is already closed')
  if (new Date(data.returned_date) < new Date(assignment.assigned_date)) {
    throw new ValidationError('returned_date cannot be before assigned_date')
  }

  return assignmentRepository.update(assignment.assignment_id, { returned_date: data.returned_date })
}
