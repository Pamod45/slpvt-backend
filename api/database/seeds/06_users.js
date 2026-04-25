/**
 * Users seed
 * One user per system role for testing
 * All passwords are 'Test@1234' — bcrypt hashed
 * Badge numbers follow SLP-XXXXX format
 * IMPORTANT: Change all passwords before any real deployment
 * 
  SUPER_ADMIN             →  no station/district/province (HQ level)
  PROVINCIAL_COMMANDER    →  assigned to Western Province
  PROVINCIAL_OFFICER      →  assigned to Western Province
  DISTRICT_COMMANDER      →  assigned to Colombo District
  STATION_COMMANDER       →  assigned to Colombo Police Post station
  STATION_OFFICER         →  assigned to Colombo Police Post station
  DATA_REGISTRAR          →  no station/district/province (DMT level)
 */

import bcrypt from 'bcrypt'

export const seed = async function (knex) {
  await knex('users').del()

  const passwordHash = await bcrypt.hash('Test@1234', 12)

  const provinces = await knex('provinces').select('province_id', 'name')
  const p = {}
  provinces.forEach(prov => {
    p[prov.name] = prov.province_id
  })

  const districts = await knex('districts').select('district_id', 'name')
  const d = {}
  districts.forEach(dist => {
    d[dist.name] = dist.district_id
  })

  const stations = await knex('stations').select('station_id', 'name')
  const s = {}
  stations.forEach(st => {
    s[st.name] = st.station_id
  })

  await knex('users').insert([
    {
      badge_number:        'SLP-00001',
      password_hash:       passwordHash,
      first_name:          'Rohan',
      last_name:           'Perera',
      system_role:         'SUPER_ADMIN',
      assigned_station_id: null,
      assigned_district_id: null,
      assigned_province_id: null,
      is_active:           true
    },
    {
      badge_number:        'SLP-00002',
      password_hash:       passwordHash,
      first_name:          'Nimal',
      last_name:           'Silva',
      system_role:         'PROVINCIAL_COMMANDER',
      assigned_station_id: null,
      assigned_district_id: null,
      assigned_province_id: p['Western'],
      is_active:           true
    },
    {
      badge_number:        'SLP-00003',
      password_hash:       passwordHash,
      first_name:          'Kamal',
      last_name:           'Fernando',
      system_role:         'PROVINCIAL_OFFICER',
      assigned_station_id: null,
      assigned_district_id: null,
      assigned_province_id: p['Western'],
      is_active:           true
    },
    {
      badge_number:        'SLP-00004',
      password_hash:       passwordHash,
      first_name:          'Sunil',
      last_name:           'Rajapaksa',
      system_role:         'DISTRICT_COMMANDER',
      assigned_station_id: null,
      assigned_district_id: d['Colombo'],
      assigned_province_id: p['Western'],
      is_active:           true
    },
    {
      badge_number:        'SLP-00005',
      password_hash:       passwordHash,
      first_name:          'Priya',
      last_name:           'Jayawardena',
      system_role:         'STATION_COMMANDER',
      assigned_station_id: s['Colombo Police Post'],
      assigned_district_id: d['Colombo'],
      assigned_province_id: p['Western'],
      is_active:           true
    },
    {
      badge_number:        'SLP-00006',
      password_hash:       passwordHash,
      first_name:          'Dilshan',
      last_name:           'Wickramasinghe',
      system_role:         'STATION_OFFICER',
      assigned_station_id: s['Colombo Police Post'],
      assigned_district_id: d['Colombo'],
      assigned_province_id: p['Western'],
      is_active:           true
    },
    {
      badge_number:        'SLP-00007',
      password_hash:       passwordHash,
      first_name:          'Chaminda',
      last_name:           'Bandara',
      system_role:         'DATA_REGISTRAR',
      assigned_station_id: null,
      assigned_district_id: null,
      assigned_province_id: null,
      is_active:           true
    }
  ])

  console.log('7 users seeded — all passwords: Test@1234')
}