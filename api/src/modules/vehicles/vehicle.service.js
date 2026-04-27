import * as vehicleRepository from './vehicle.repository.js'
import { findById as findDeviceById } from '../devices/device.repository.js'
import { findById as findDriverById } from '../drivers/driver.repository.js'
import { NotFoundError, ConflictError, ForbiddenError, ValidationError } from '../../utils/errors.js'

const DEVICE_MANAGERS = ['PROVINCIAL_OFFICER', 'PROVINCIAL_COMMANDER', 'SUPER_ADMIN']

export const listVehicles = async (filters, pagination) => {
  return vehicleRepository.findAll(filters, pagination)
}

export const getVehicle = async (vehicleId) => {
  const vehicle = await vehicleRepository.findById(vehicleId)
  if (!vehicle) throw new NotFoundError('Vehicle not found')
  return vehicle
}

export const registerVehicle = async (data) => {
  const [byRef, byReg, byChassis] = await Promise.all([
    vehicleRepository.findByReferenceId(data.vehicle_reference_id),
    vehicleRepository.findByRegistrationNumber(data.registration_number),
    vehicleRepository.findByChassisNumber(data.chassis_number)
  ])

  if (byRef)     throw new ConflictError('A vehicle with this DMT reference ID already exists')
  if (byReg)     throw new ConflictError('A vehicle with this registration number already exists')
  if (byChassis) throw new ConflictError('A vehicle with this chassis number already exists')

  return vehicleRepository.create(data)
}

export const updateVehicle = async (vehicleId, data, user) => {
  const vehicle = await vehicleRepository.findById(vehicleId)
  if (!vehicle) throw new NotFoundError('Vehicle not found')

  if (data.device_id !== undefined) {
    if (!DEVICE_MANAGERS.includes(user.role)) {
      throw new ForbiddenError('Only Provincial Officers and above can assign devices to vehicles')
    }

    if (data.device_id !== null) {
      const device = await findDeviceById(data.device_id)
      if (!device) throw new NotFoundError('Device not found')
      if (device.admin_status !== 'ACTIVE') {
        throw new ValidationError('Only ACTIVE devices can be assigned to vehicles')
      }

      const existing = await vehicleRepository.findByDeviceId(data.device_id)
      if (existing && existing.vehicle_id !== vehicleId) {
        throw new ConflictError('This device is already assigned to another vehicle')
      }
    }
  }

  return vehicleRepository.update(vehicleId, data)
}

export const getVehicleAssignments = async (vehicleId, pagination) => {
  const vehicle = await vehicleRepository.findById(vehicleId)
  if (!vehicle) throw new NotFoundError('Vehicle not found')
  return vehicleRepository.findAssignmentsByVehicle(vehicleId, pagination)
}

export const createAssignment = async (vehicleId, data) => {
  const [vehicle, driver] = await Promise.all([
    vehicleRepository.findById(vehicleId),
    findDriverById(data.driver_id)
  ])

  if (!vehicle) throw new NotFoundError('Vehicle not found')
  if (!driver)  throw new NotFoundError('Driver not found')

  const active = await vehicleRepository.findActiveAssignment(vehicleId)
  if (active) throw new ConflictError('This vehicle already has an active driver assignment')

  return vehicleRepository.createAssignment({ vehicle_id: vehicleId, ...data })
}

export const closeAssignment = async (vehicleId, assignmentId, data) => {
  const assignment = await vehicleRepository.findAssignmentById(assignmentId)

  if (!assignment || assignment.vehicle_id !== vehicleId) {
    throw new NotFoundError('Assignment not found')
  }
  if (assignment.returned_date) {
    throw new ConflictError('This assignment is already closed')
  }
  if (new Date(data.returned_date) < new Date(assignment.assigned_date)) {
    throw new ValidationError('returned_date cannot be before assigned_date')
  }

  return vehicleRepository.updateAssignment(assignmentId, { returned_date: data.returned_date })
}
