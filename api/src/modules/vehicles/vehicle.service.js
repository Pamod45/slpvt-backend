import * as vehicleRepository from './vehicle.repository.js'
import { findById as findDeviceById } from '../devices/device.repository.js'
import { findByLicenseNumber as findDriverByLicense } from '../drivers/driver.repository.js'
import { NotFoundError, ConflictError, ForbiddenError, ValidationError } from '../../utils/errors.js'

const DEVICE_MANAGERS = ['PROVINCIAL_OFFICER', 'PROVINCIAL_COMMANDER', 'SUPER_ADMIN']

const buildLocation = (row) => {
  const loc = {}
  if (row.province_name)    loc.province               = { name: row.province_name,    province_slug:    row.province_slug }
  if (row.district_name)    loc.district               = { name: row.district_name,    district_slug:    row.district_slug }
  if (row.ds_division_name) loc.divisional_secretariat = { name: row.ds_division_name, ds_division_slug: row.ds_division_slug }
  return loc
}

const format = (row) => ({
  vehicle_reference_id: row.vehicle_reference_id,
  registration_number:  row.registration_number,
  chassis_number:       row.chassis_number,
  color:                row.color,
  make_model:           row.make_model,
  police_status:        row.police_status,
  owner: {
    name:   row.owner_full_name,
    mobile: row.owner_contact ?? null
  },
  device: row.device_serial_number ? {
    serial_number: row.device_serial_number,
    issued_date:   row.device_issued_date,
    admin_status:  row.device_admin_status
  } : null,
  location: buildLocation(row)
})

export const listVehicles = async (filters, pagination) => {
  const result = await vehicleRepository.findAll(filters, pagination)
  return { count: result.count, data: result.data.map(format) }
}

export const getVehicle = async (registrationNumber) => {
  const vehicle = await vehicleRepository.findByRegistrationNumber(registrationNumber)
  if (!vehicle) throw new NotFoundError('Vehicle not found')
  return format(vehicle)
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

export const updateVehicle = async (registrationNumber, data, user) => {
  const vehicle = await vehicleRepository.findByRegistrationNumber(registrationNumber)
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
      if (existing && existing.vehicle_id !== vehicle.vehicle_id) {
        throw new ConflictError('This device is already assigned to another vehicle')
      }
    }
  }

  return vehicleRepository.update(vehicle.vehicle_id, data)
}

export const getVehicleAssignments = async (registrationNumber, pagination) => {
  const vehicle = await vehicleRepository.findByRegistrationNumber(registrationNumber)
  if (!vehicle) throw new NotFoundError('Vehicle not found')
  return vehicleRepository.findAssignmentsByVehicle(vehicle.vehicle_id, pagination)
}

export const createAssignment = async (registrationNumber, data) => {
  const [vehicle, driver] = await Promise.all([
    vehicleRepository.findByRegistrationNumber(registrationNumber),
    findDriverByLicense(data.license_number)
  ])

  if (!vehicle) throw new NotFoundError('Vehicle not found')
  if (!driver)  throw new NotFoundError('Driver not found')

  const active = await vehicleRepository.findActiveAssignment(vehicle.vehicle_id)
  if (active) throw new ConflictError('This vehicle already has an active driver assignment')

  return vehicleRepository.createAssignment({
    vehicle_id:    vehicle.vehicle_id,
    driver_id:     driver.driver_id,
    assigned_date: data.assigned_date
  })
}

export const closeAssignment = async (registrationNumber, licenseNumber, data) => {
  const vehicle = await vehicleRepository.findByRegistrationNumber(registrationNumber)
  if (!vehicle) throw new NotFoundError('Vehicle not found')

  const assignment = await vehicleRepository.findAssignmentByVehicleAndLicense(vehicle.vehicle_id, licenseNumber)
  if (!assignment) throw new NotFoundError('No active assignment found for this vehicle and driver')
  if (assignment.returned_date) throw new ConflictError('This assignment is already closed')
  if (new Date(data.returned_date) < new Date(assignment.assigned_date)) {
    throw new ValidationError('returned_date cannot be before assigned_date')
  }

  return vehicleRepository.updateAssignment(assignment.assignment_id, { returned_date: data.returned_date })
}
