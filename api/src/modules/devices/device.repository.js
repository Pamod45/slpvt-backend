import db from '../../db/postgres.js'

const SAFE_COLUMNS = [
  'device_id',
  'serial_number',
  'issued_date',
  'admin_status'
]

export const findAll = async (pagination) => {
  const { admin_status, offset, limit, sort_by, order } = pagination

  const query = db('tracking_devices')

  if (admin_status) query.where({ admin_status })

  const total = await query.clone().count('device_id as count').first()

  const data = await query
    .select(['serial_number', 'issued_date', 'admin_status'])
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
