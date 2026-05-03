import db from '../../db/postgres.js'

export const findByVehicle = async (vehicleId, pagination) => {
  const { active_only, offset, limit, sort_by, order } = pagination

  const query = db('vehicle_driver_assignments as vda')
    .join('drivers as d', 'vda.driver_id', 'd.driver_id')
    .where({ 'vda.vehicle_id': vehicleId })

  if (active_only) query.whereNull('vda.returned_date')

  const total = await query.clone().count('vda.assignment_id as count').first()

  const data = await query
    .select(
      'vda.assigned_date',
      'vda.returned_date',
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

export const findByDriver = async (driverId, pagination) => {
  const { active_only, offset, limit, sort_by, order } = pagination

  const query = db('vehicle_driver_assignments as vda')
    .join('vehicles as v', 'vda.vehicle_id', 'v.vehicle_id')
    .where({ 'vda.driver_id': driverId })
    .whereNull('v.deleted_at')

  if (active_only) query.whereNull('vda.returned_date')

  const total = await query.clone().count('vda.assignment_id as count').first()

  const data = await query
    .select(
      'vda.assigned_date',
      'vda.returned_date',
      'v.registration_number',
      'v.make_model',
      'v.color',
      'v.police_status as vehicle_police_status'
    )
    .orderBy(`vda.${sort_by}`, order)
    .limit(limit)
    .offset(offset)

  return { count: parseInt(total.count), data }
}

export const findByVehicleAndLicense = async (vehicleId, licenseNumber) => {
  return db('vehicle_driver_assignments as vda')
    .join('drivers as d', 'vda.driver_id', 'd.driver_id')
    .where({ 'vda.vehicle_id': vehicleId })
    .where('d.driving_license_number', licenseNumber)
    .select('vda.assignment_id', 'vda.assigned_date', 'vda.returned_date')
    .first()
}

export const findActive = async (vehicleId) => {
  return db('vehicle_driver_assignments')
    .where({ vehicle_id: vehicleId })
    .whereNull('returned_date')
    .first()
}

export const create = async (assignmentData) => {
  const [newAssignment] = await db('vehicle_driver_assignments')
    .insert(assignmentData)
    .returning(['assignment_id', 'vehicle_id', 'driver_id', 'assigned_date', 'returned_date'])
  return newAssignment
}

export const update = async (assignmentId, assignmentData) => {
  const [updated] = await db('vehicle_driver_assignments')
    .where({ assignment_id: assignmentId })
    .update(assignmentData)
    .returning(['assignment_id', 'vehicle_id', 'driver_id', 'assigned_date', 'returned_date'])
  return updated
}
