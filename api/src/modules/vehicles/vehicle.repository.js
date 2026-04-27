import db from '../../db/postgres.js'

export const findAll = async (filters, pagination) => {
  const {
    registration_number, owner_nic, owner_name, police_status,
    make_model, has_device, ds_division_id, district_id, province_id
  } = filters
  const { offset, limit, sort_by, order } = pagination

  const needsDs       = !!district_id || !!province_id
  const needsDistrict = !!province_id

  const query = db('vehicles as v').whereNull('v.deleted_at')

  if (needsDs)       query.leftJoin('divisional_secretariats as ds', 'v.ds_division_id', 'ds.ds_division_id')
  if (needsDistrict) query.leftJoin('districts as d', 'ds.district_id', 'd.district_id')

  if (registration_number) query.where('v.registration_number', 'ilike', `%${registration_number}%`)
  if (owner_nic)           query.where('v.owner_nic', 'ilike', `%${owner_nic}%`)
  if (owner_name)          query.where('v.owner_full_name', 'ilike', `%${owner_name}%`)
  if (police_status)       query.where('v.police_status', police_status)
  if (make_model)          query.where('v.make_model', 'ilike', `%${make_model}%`)
  if (has_device === true)  query.whereNotNull('v.device_id')
  if (has_device === false) query.whereNull('v.device_id')
  if (ds_division_id)      query.where('v.ds_division_id', ds_division_id)
  if (district_id)         query.where('ds.district_id', district_id)
  if (province_id)         query.where('d.province_id', province_id)

  const total = await query.clone().count('v.vehicle_id as count').first()

  const data = await query
    .select(
      'v.vehicle_id',
      'v.vehicle_reference_id',
      'v.registration_number',
      'v.chassis_number',
      'v.color',
      'v.make_model',
      'v.device_id',
      'v.police_status',
      'v.owner_nic',
      'v.owner_full_name',
      'v.owner_contact',
      'v.ds_division_id',
      'v.created_at',
      'v.updated_at'
    )
    .orderBy(`v.${sort_by}`, order)
    .limit(limit)
    .offset(offset)

  return { count: parseInt(total.count), data }
}

export const findById = async (vehicleId) => {
  return db('vehicles as v')
    .leftJoin('tracking_devices as td', 'v.device_id', 'td.device_id')
    .where({ 'v.vehicle_id': vehicleId })
    .whereNull('v.deleted_at')
    .select(
      'v.vehicle_id',
      'v.vehicle_reference_id',
      'v.registration_number',
      'v.chassis_number',
      'v.color',
      'v.make_model',
      'v.police_status',
      'v.owner_nic',
      'v.owner_full_name',
      'v.owner_contact',
      'v.ds_division_id',
      'v.device_id',
      'v.created_at',
      'v.updated_at',
      'td.serial_number as device_serial_number',
      'td.admin_status as device_admin_status'
    )
    .first()
}

export const findByReferenceId = async (referenceId) => {
  return db('vehicles').where({ vehicle_reference_id: referenceId }).whereNull('deleted_at').first()
}

export const findByRegistrationNumber = async (registrationNumber) => {
  return db('vehicles').where({ registration_number: registrationNumber }).whereNull('deleted_at').first()
}

export const findByChassisNumber = async (chassisNumber) => {
  return db('vehicles').where({ chassis_number: chassisNumber }).whereNull('deleted_at').first()
}

export const findByDeviceId = async (deviceId) => {
  return db('vehicles').where({ device_id: deviceId }).whereNull('deleted_at').first()
}

export const create = async (vehicleData) => {
  const [newVehicle] = await db('vehicles')
    .insert(vehicleData)
    .returning([
      'vehicle_id', 'vehicle_reference_id', 'registration_number',
      'chassis_number', 'color', 'make_model', 'police_status',
      'owner_nic', 'owner_full_name', 'owner_contact', 'ds_division_id',
      'device_id', 'created_at', 'updated_at'
    ])
  return newVehicle
}

export const update = async (vehicleId, vehicleData) => {
  const [updated] = await db('vehicles')
    .where({ vehicle_id: vehicleId })
    .update({ ...vehicleData, updated_at: db.fn.now() })
    .returning([
      'vehicle_id', 'vehicle_reference_id', 'registration_number',
      'chassis_number', 'color', 'make_model', 'police_status',
      'owner_nic', 'owner_full_name', 'owner_contact', 'ds_division_id',
      'device_id', 'created_at', 'updated_at'
    ])
  return updated
}

// ─────────────────────────────────────────────
// ASSIGNMENTS
// ─────────────────────────────────────────────

export const findAssignmentsByVehicle = async (vehicleId, pagination) => {
  const { active_only, offset, limit, sort_by, order } = pagination

  const query = db('vehicle_driver_assignments as vda')
    .join('drivers as d', 'vda.driver_id', 'd.driver_id')
    .where({ 'vda.vehicle_id': vehicleId })

  if (active_only) query.whereNull('vda.returned_date')

  const total = await query.clone().count('vda.assignment_id as count').first()

  const data = await query
    .select(
      'vda.assignment_id',
      'vda.assigned_date',
      'vda.returned_date',
      'vda.created_at',
      'd.driver_id',
      'd.first_name',
      'd.last_name',
      'd.driving_license_number',
      'd.police_status as driver_police_status'
    )
    .orderBy(`vda.${sort_by}`, order)
    .limit(limit)
    .offset(offset)

  return { count: parseInt(total.count), data }
}

export const findActiveAssignment = async (vehicleId) => {
  return db('vehicle_driver_assignments')
    .where({ vehicle_id: vehicleId })
    .whereNull('returned_date')
    .first()
}

export const findAssignmentById = async (assignmentId) => {
  return db('vehicle_driver_assignments').where({ assignment_id: assignmentId }).first()
}

export const createAssignment = async (assignmentData) => {
  const [newAssignment] = await db('vehicle_driver_assignments')
    .insert(assignmentData)
    .returning(['assignment_id', 'vehicle_id', 'driver_id', 'assigned_date', 'returned_date', 'created_at'])
  return newAssignment
}

export const updateAssignment = async (assignmentId, assignmentData) => {
  const [updated] = await db('vehicle_driver_assignments')
    .where({ assignment_id: assignmentId })
    .update(assignmentData)
    .returning(['assignment_id', 'vehicle_id', 'driver_id', 'assigned_date', 'returned_date', 'created_at'])
  return updated
}
