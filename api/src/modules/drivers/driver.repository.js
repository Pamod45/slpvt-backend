import db from '../../db/postgres.js'

const PUBLIC_COLUMNS = [
  'first_name',
  'last_name',
  'permanent_address',
  'driving_license_number',
  'license_expiry_date',
  'police_status'
]

export const findAll = async (filters, pagination) => {
  const { license_number, reference_id, first_name, last_name, police_status, license_expired } = filters
  const { offset, limit, sort_by, order } = pagination

  const query = db('drivers').whereNull('deleted_at')

  if (license_number)           query.where('driving_license_number',  'ilike', `%${license_number}%`)
  if (reference_id)             query.where('driver_reference_id',     'ilike', `%${reference_id}%`)
  if (first_name)               query.where('first_name',              'ilike', `%${first_name}%`)
  if (last_name)                query.where('last_name',               'ilike', `%${last_name}%`)
  if (police_status)            query.where({ police_status })
  if (license_expired === true)  query.where('license_expiry_date', '<',  db.fn.now())
  if (license_expired === false) query.where('license_expiry_date', '>=', db.fn.now())

  const total = await query.clone().count('driver_id as count').first()

  const data = await query
    .select(PUBLIC_COLUMNS)
    .orderBy(sort_by, order)
    .limit(limit)
    .offset(offset)

  return { count: parseInt(total.count), data }
}

export const findById = async (driverId) => {
  return db('drivers')
    .where({ driver_id: driverId })
    .whereNull('deleted_at')
    .select(
      'driver_id',
      'driver_reference_id',
      'first_name',
      'last_name',
      'permanent_address',
      'driving_license_number',
      'license_expiry_date',
      'police_status',
      'created_at',
      'updated_at'
    )
    .first()
}

export const findByReferenceId = async (referenceId) => {
  return db('drivers').where({ driver_reference_id: referenceId }).whereNull('deleted_at').first()
}

export const findByLicenseNumber = async (licenseNumber) => {
  return db('drivers').where({ driving_license_number: licenseNumber }).whereNull('deleted_at').first()
}

export const create = async (driverData) => {
  const [newDriver] = await db('drivers')
    .insert(driverData)
    .returning([
      'driver_id', 'driver_reference_id', 'first_name', 'last_name',
      'permanent_address', 'driving_license_number', 'license_expiry_date',
      'police_status', 'created_at', 'updated_at'
    ])
  return newDriver
}

export const update = async (driverId, driverData) => {
  const [updated] = await db('drivers')
    .where({ driver_id: driverId })
    .update({ ...driverData, updated_at: db.fn.now() })
    .returning([
      'driver_id', 'driver_reference_id', 'first_name', 'last_name',
      'permanent_address', 'driving_license_number', 'license_expiry_date',
      'police_status', 'created_at', 'updated_at'
    ])
  return updated
}

