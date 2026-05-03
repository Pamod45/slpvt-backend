import db from '../../db/postgres.js'

const VEHICLE_COLUMNS = [
  'v.vehicle_id',
  'v.vehicle_reference_id',
  'v.registration_number',
  'v.chassis_number',
  'v.color',
  'v.make_model',
  'v.police_status',
  'v.owner_full_name',
  'v.owner_contact',
  'td.serial_number  as device_serial_number',
  'td.issued_date    as device_issued_date',
  'td.admin_status   as device_admin_status',
  'ds.name           as ds_division_name',
  'ds.ds_division_slug',
  'd.name            as district_name',
  'd.district_slug',
  'p.name            as province_name',
  'p.province_slug'
]

const BASE_QUERY = () =>
  db('vehicles as v')
    .whereNull('v.deleted_at')
    .leftJoin('tracking_devices as td',        'v.device_id',     'td.device_id')
    .leftJoin('divisional_secretariats as ds', 'v.ds_division_id','ds.ds_division_id')
    .leftJoin('districts as d',                'ds.district_id',  'd.district_id')
    .leftJoin('provinces as p',                'd.province_id',   'p.province_id')

export const findAll = async (filters, pagination) => {
  const {
    registration_number, owner_nic, owner_name, police_status,
    make_model, has_device, ds_division_id, district_id, province_id
  } = filters
  const { offset, limit, sort_by, order } = pagination

  const query = BASE_QUERY()

  if (registration_number) query.where('v.registration_number', 'ilike', `%${registration_number}%`)
  if (owner_nic)           query.where('v.owner_nic',           'ilike', `%${owner_nic}%`)
  if (owner_name)          query.where('v.owner_full_name',     'ilike', `%${owner_name}%`)
  if (police_status)       query.where('v.police_status', police_status)
  if (make_model)          query.where('v.make_model',          'ilike', `%${make_model}%`)
  if (has_device === true)  query.whereNotNull('v.device_id')
  if (has_device === false) query.whereNull('v.device_id')
  if (ds_division_id)      query.where('v.ds_division_id', ds_division_id)
  if (district_id)         query.where('d.district_id',    district_id)
  if (province_id)         query.where('p.province_id',    province_id)

  const total = await query.clone().count('v.vehicle_id as count').first()

  const data = await query
    .select(VEHICLE_COLUMNS)
    .orderBy(`v.${sort_by}`, order)
    .limit(limit)
    .offset(offset)

  return { count: parseInt(total.count), data }
}

export const findByRegistrationNumber = async (registrationNumber) => {
  return BASE_QUERY()
    .where({ 'v.registration_number': registrationNumber })
    .select(VEHICLE_COLUMNS)
    .first()
}

export const findDeviceIdByRegistrationNumber = async (registrationNumber) => {
  return db('vehicles as v')
    .where({ 'v.registration_number': registrationNumber })
    .whereNull('v.deleted_at')
    .select('v.vehicle_id', 'v.device_id')
    .first()
}

export const findByDeviceIds = async (deviceIds) => {
  return db('vehicles as v')
    .whereIn('v.device_id', deviceIds)
    .whereNull('v.deleted_at')
    .select('v.device_id', 'v.registration_number', 'v.police_status')
}

export const findByReferenceId = async (referenceId) => {
  return db('vehicles').where({ vehicle_reference_id: referenceId }).whereNull('deleted_at').first()
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
      'owner_full_name', 'owner_contact', 'ds_division_id', 'device_id'
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
      'owner_full_name', 'owner_contact', 'ds_division_id', 'device_id'
    ])
  return updated
}


