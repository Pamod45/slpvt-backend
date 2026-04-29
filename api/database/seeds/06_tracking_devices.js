/**
 * Tracking devices seed
 * Generates 200 GPS tracking devices
 * Each device gets a unique API key hashed with SHA-256
 * Raw API keys written to data/device_keys.json for simulator use
 * IMPORTANT: device_keys.json is for development only — never commit to git
 */

import { randomBytes, createHash } from 'crypto'
import { writeFileSync, mkdirSync } from 'fs'

export const seed = async function (knex) {
  await knex.raw('TRUNCATE TABLE tracking_devices CASCADE')

  const devices = []
  const deviceKeys = []

  for (let i = 1; i <= 210; i++) {
    const rawKey = randomBytes(32).toString('hex')
    const apiKeyHash = createHash('sha256').update(rawKey).digest('hex')
    const serialNumber = `TRK-SL-${String(i).padStart(5, '0')}`

    const issuedDate = new Date()
    issuedDate.setDate(issuedDate.getDate() - Math.floor(Math.random() * 365))

    let adminStatus
    if (i <= 190) {
      adminStatus = 'ACTIVE'
    } else if (i <= 205) {
      adminStatus = 'UNDER_REPAIR'
    } else {
      adminStatus = 'DECOMMISSIONED'
    }

    devices.push({
      serial_number: serialNumber,
      api_key_hash:  apiKeyHash,
      issued_date:   issuedDate.toISOString().split('T')[0],
      admin_status:  adminStatus
    })

    deviceKeys.push({
      serial_number: serialNumber,
      raw_api_key:   rawKey,
      admin_status:  adminStatus
    })
  }

  await knex('tracking_devices').insert(devices)

  mkdirSync('./data', { recursive: true })
  writeFileSync(
    './data/device_keys.json',
    JSON.stringify(deviceKeys, null, 2)
  )

  console.log('210 tracking devices seeded')
  console.log('Raw API keys saved to data/device_keys.json')
  console.log('Add data/device_keys.json to .gitignore — never commit raw keys')
}