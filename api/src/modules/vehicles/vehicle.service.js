import * as vehicleRepository from './vehicle.repository.js'
import { findById as findDeviceById } from '../devices/device.repository.js'
import { findBySlug as findDsDivisionBySlug } from '../divisional-secretariats/divisional-secretariat.repository.js'
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
  const { ds_division_slug, ...vehicleData } = data

  const [byRef, byReg, byChassis, dsDivision] = await Promise.all([
    vehicleRepository.findByReferenceId(data.vehicle_reference_id),
    vehicleRepository.findByRegistrationNumber(data.registration_number),
    vehicleRepository.findByChassisNumber(data.chassis_number),
    findDsDivisionBySlug(ds_division_slug)
  ])

  if (byRef)       throw new ConflictError('A vehicle with this DMT reference ID already exists')
  if (byReg)       throw new ConflictError('A vehicle with this registration number already exists')
  if (byChassis)   throw new ConflictError('A vehicle with this chassis number already exists')
  if (!dsDivision) throw new NotFoundError('Divisional secretariat not found')

  return vehicleRepository.create({ ...vehicleData, ds_division_id: dsDivision.ds_division_id })
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

