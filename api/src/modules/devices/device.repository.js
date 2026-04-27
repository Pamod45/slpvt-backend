import db from '../../db/postgres.js'

const SAFE_COLUMNS = [
  'device_id',
  'serial_number',
  'issued_date',
  'admin_status',
  'created_at',
  'updated_at'
]

export const findAll = async (pagination) => {
  const { admin_status, serial_number, offset, limit, sort_by, order } = pagination

  const query = db('tracking_devices')

  if (admin_status)  query.where({ admin_status })
  if (serial_number) query.where('serial_number', 'ilike', `%${serial_number}%`)

  const total = await query.clone().count('device_id as count').first()

  const data = await query
    .select(SAFE_COLUMNS)
    .orderBy(sort_by, order)
    .limit(limit)
    .offset(offset)

  return {
    count: parseInt(total.count),
    data
  }
}

export const findById = async (deviceId) => {
  return db('tracking_devices')
    .where({ device_id: deviceId })
    .select(SAFE_COLUMNS)
    .first()
}

export const findBySerialNumber = async (serialNumber) => {
  return db('tracking_devices')
    .where({ serial_number: serialNumber })
    .select(SAFE_COLUMNS)
    .first()
}

export const create = async (deviceData) => {
  const [newDevice] = await db('tracking_devices')
    .insert(deviceData)
    .returning(SAFE_COLUMNS)

  return newDevice
}

export const update = async (deviceId, deviceData) => {
  const [updatedDevice] = await db('tracking_devices')
    .where({ device_id: deviceId })
    .update({ ...deviceData, updated_at: db.fn.now() })
    .returning(SAFE_COLUMNS)

  return updatedDevice
}
