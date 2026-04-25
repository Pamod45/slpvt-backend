/**
 * Ping Simulator
 * Generates 7 days of realistic location history for 205 tuk-tuks
 * Ping interval: 2 minutes
 * Behaviour profiles: regular, wide-range, suspicious, stolen
 * Colombo DS divisions have highest vehicle density
 * Command: node scripts/pingSimulator.js
 */

import { MongoClient } from 'mongodb'
import knex from 'knex'
import knexConfig from '../knexfile.js'
import 'dotenv/config'

const db = knex(knexConfig.development)

// ─────────────────────────────────────────────
// ANCHOR POINTS — real locations per district
// ─────────────────────────────────────────────

const anchors = {
  Colombo: [
    { name: 'Colombo Fort',    lat: 6.9344,  lng: 79.8428 },
    { name: 'Pettah',          lat: 6.9355,  lng: 79.8502 },
    { name: 'Maradana',        lat: 6.9219,  lng: 79.8659 },
    { name: 'Borella',         lat: 6.9147,  lng: 79.8773 },
    { name: 'Nugegoda',        lat: 6.8731,  lng: 79.8878 },
    { name: 'Maharagama',      lat: 6.8478,  lng: 79.9269 },
    { name: 'Dehiwala',        lat: 6.8517,  lng: 79.8653 },
    { name: 'Mount Lavinia',   lat: 6.8378,  lng: 79.8671 },
    { name: 'Kollupitiya',     lat: 6.9108,  lng: 79.8494 },
    { name: 'Bambalapitiya',   lat: 6.8939,  lng: 79.8561 },
    { name: 'Wellawatte',      lat: 6.8756,  lng: 79.8594 },
    { name: 'Kirulapone',      lat: 6.8853,  lng: 79.8794 },
    { name: 'Rajagiriya',      lat: 6.9108,  lng: 79.8878 },
    { name: 'Kotte',           lat: 6.8935,  lng: 79.9003 },
    { name: 'Battaramulla',    lat: 6.9003,  lng: 79.9186 }
  ],
  Gampaha: [
    { name: 'Negombo',         lat: 7.2096,  lng: 79.8357 },
    { name: 'Ja-Ela',          lat: 7.0742,  lng: 79.8916 },
    { name: 'Wattala',         lat: 6.9897,  lng: 79.8893 },
    { name: 'Kelaniya',        lat: 7.0006,  lng: 79.9208 },
    { name: 'Gampaha Town',    lat: 7.0873,  lng: 80.0144 }
  ],
  Kalutara: [
    { name: 'Panadura',        lat: 6.7136,  lng: 79.9064 },
    { name: 'Horana',          lat: 6.7156,  lng: 80.0631 },
    { name: 'Kalutara Town',   lat: 6.5854,  lng: 79.9607 },
    { name: 'Bandaragama',     lat: 6.7139,  lng: 79.9833 }
  ],
  Kandy: [
    { name: 'Kandy City',      lat: 7.2906,  lng: 80.6337 },
    { name: 'Peradeniya',      lat: 7.2657,  lng: 80.5982 },
    { name: 'Katugastota',     lat: 7.3167,  lng: 80.6333 },
    { name: 'Kundasale',       lat: 7.2833,  lng: 80.6833 }
  ],
  Galle: [
    { name: 'Galle Fort',      lat: 6.0269,  lng: 80.2168 },
    { name: 'Ambalangoda',     lat: 6.2341,  lng: 80.0567 },
    { name: 'Hikkaduwa',       lat: 6.1395,  lng: 80.1054 },
    { name: 'Elpitiya',        lat: 6.2833,  lng: 80.1667 }
  ],
  Matara: [
    { name: 'Matara City',     lat: 5.9549,  lng: 80.5550 },
    { name: 'Weligama',        lat: 5.9747,  lng: 80.4290 },
    { name: 'Dickwella',       lat: 5.9667,  lng: 80.7000 },
    { name: 'Devinuwara',      lat: 5.9333,  lng: 80.5667 }
  ]
}

// suspicious late night anchor — outside normal area
const suspiciousAnchors = [
  { name: 'Kandy Night',       lat: 7.2950,  lng: 80.6400 },
  { name: 'Gampaha Night',     lat: 7.0900,  lng: 80.0200 },
  { name: 'Negombo Night',     lat: 7.2100,  lng: 79.8400 },
  { name: 'Horana Night',      lat: 6.7200,  lng: 80.0700 }
]

// ─────────────────────────────────────────────
// MOVEMENT DELTAS — per time pattern
// ─────────────────────────────────────────────

const getMovementDelta = (hour) => {
  if (hour >= 0  && hour < 5)  return 0.0001  // night — stationary
  if (hour >= 5  && hour < 7)  return 0.0008  // early morning — slow
  if (hour >= 7  && hour < 9)  return 0.0035  // morning rush — busy
  if (hour >= 9  && hour < 12) return 0.0020  // mid morning — moderate
  if (hour >= 12 && hour < 14) return 0.0008  // lunch — slow
  if (hour >= 14 && hour < 17) return 0.0020  // afternoon — moderate
  if (hour >= 17 && hour < 19) return 0.0035  // evening rush — busy
  if (hour >= 19 && hour < 21) return 0.0015  // evening — slow
  return 0.0001                                // late night — stationary
}

// ─────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────

const getRandom = (arr) => arr[Math.floor(Math.random() * arr.length)]

const clamp = (val, min, max) => Math.min(Math.max(val, min), max)

const moveToward = (current, target, speed) => {
  const latDiff = target.lat - current.lat
  const lngDiff = target.lng - current.lng
  const distance = Math.sqrt(latDiff * latDiff + lngDiff * lngDiff)

  if (distance < speed) {
    return { lat: target.lat, lng: target.lng, reached: true }
  }

  return {
    lat: current.lat + (latDiff / distance) * speed + (Math.random() - 0.5) * speed * 0.3,
    lng: current.lng + (lngDiff / distance) * speed + (Math.random() - 0.5) * speed * 0.3,
    reached: false
  }
}

const getDistrictForVehicle = (vehicle, districts) => {
  return districts[Math.floor(Math.random() * districts.length)]
}

const getAnchorsForDistrict = (districtName) => {
  return anchors[districtName] || anchors['Colombo']
}

const assignBehaviourProfile = (policeStatus, index) => {
  if (policeStatus === 'STOLEN')  return 'stolen'
  if (policeStatus === 'WANTED')  return 'suspicious'
  if (index % 10 === 0)           return 'wide-range'
  return 'regular'
}

// ─────────────────────────────────────────────
// GENERATE PINGS FOR ONE VEHICLE
// ─────────────────────────────────────────────

const generatePingsForVehicle = (vehicle, districtName, profile) => {
  const vehicleAnchors = getAnchorsForDistrict(districtName)
  const homeAnchor = getRandom(vehicleAnchors)
  const routeAnchors = vehicleAnchors
    .sort(() => Math.random() - 0.5)
    .slice(0, profile === 'wide-range' ? 6 : 3)

  const pings = []
  const INTERVAL_MINUTES = 2
  const DAYS = 7
  const PINGS_PER_DAY = (24 * 60) / INTERVAL_MINUTES
  const TOTAL_PINGS = PINGS_PER_DAY * DAYS

  const now = new Date()
  const startTime = new Date(now)
  startTime.setDate(startTime.getDate() - DAYS)
  startTime.setHours(0, 0, 0, 0)

  let currentPos = { lat: homeAnchor.lat, lng: homeAnchor.lng }
  let currentTarget = getRandom(routeAnchors)
  let battery = 90 + Math.floor(Math.random() * 10)
  let stationaryCount = 0
  let stolenBehaviourActivated = false

  for (let pingIndex = 0; pingIndex < TOTAL_PINGS; pingIndex++) {
    const pingTime = new Date(startTime.getTime() + pingIndex * INTERVAL_MINUTES * 60 * 1000)
    const hour = pingTime.getHours()
    const dayIndex = Math.floor(pingIndex / PINGS_PER_DAY)

    // stolen vehicles — normal for first 3 days then move to suspicious area
    if (profile === 'stolen' && dayIndex >= 3 && !stolenBehaviourActivated) {
      currentTarget = getRandom(suspiciousAnchors)
      stolenBehaviourActivated = true
    }

    const delta = getMovementDelta(hour)

    // suspicious vehicles move late at night
    const isSuspiciousHour = (hour >= 22 || hour < 4)
    const effectiveDelta = (profile === 'suspicious' && isSuspiciousHour)
      ? 0.0030
      : delta

    // stationary periods — tuk-tuk waiting for passengers
    if (effectiveDelta < 0.0005) {
      stationaryCount++
    } else {
      stationaryCount = 0
    }

    let newPos
    if (stationaryCount > 3) {
      // parked — tiny random wobble only
      newPos = {
        lat: currentPos.lat + (Math.random() - 0.5) * 0.0001,
        lng: currentPos.lng + (Math.random() - 0.5) * 0.0001
      }
    } else {
      const result = moveToward(currentPos, currentTarget, effectiveDelta)
      newPos = result

      if (result.reached) {
        // pick next anchor
        if (profile === 'stolen' && stolenBehaviourActivated) {
          currentTarget = getRandom(suspiciousAnchors)
        } else if (profile === 'suspicious' && isSuspiciousHour) {
          currentTarget = getRandom(suspiciousAnchors)
        } else if (hour >= 0 && hour < 5) {
          currentTarget = homeAnchor
        } else {
          currentTarget = getRandom(routeAnchors)
        }
      }
    }

    // battery simulation
    if (hour >= 6 && hour < 22) {
      battery = clamp(battery - 0.05, 10, 100)
    } else {
      battery = clamp(battery + 0.5, 10, 100)
    }

    currentPos = newPos

    pings.push({
      device_id:     vehicle.device_id,
      location: {
        type:        'Point',
        coordinates: [
          Math.round(currentPos.lng * 10000) / 10000,
          Math.round(currentPos.lat * 10000) / 10000
        ]
      },
      battery_level: Math.round(battery),
      pinged_at:     pingTime
    })
  }

  return pings
}

// ─────────────────────────────────────────────
// DISTRICT ASSIGNMENT PER PROVINCE
// ─────────────────────────────────────────────

const getDistrictForProvince = (provinceName, index) => {
  if (provinceName === 'Western') {
    if (index < 70) return 'Colombo'
    if (index < 100) return 'Gampaha'
    return 'Kalutara'
  }
  if (provinceName === 'Central') return 'Kandy'
  if (provinceName === 'Southern') {
    if (index < 20) return 'Galle'
    return 'Matara'
  }
  return 'Colombo'
}

// ─────────────────────────────────────────────
// MAIN
// ─────────────────────────────────────────────

const run = async () => {
  const mongoClient = new MongoClient(process.env.MONGO_URI)

  try {
    await mongoClient.connect()
    console.log('MongoDB connected')

    const mongoDb = mongoClient.db()
    const collection = mongoDb.collection('location_pings')

    await collection.drop().catch(() => {
      console.log('No existing location_pings collection — creating fresh')
    })

    await collection.createIndex({ location: '2dsphere' })
    await collection.createIndex({ device_id: 1, pinged_at: -1 })
    await collection.createIndex(
      { pinged_at: 1 },
      { expireAfterSeconds: 60 * 60 * 24 * 90 }
    )
    console.log('Indexes created')

    const vehicles = await db('vehicles')
      .join('provinces', 'vehicles.registered_province_id', 'provinces.province_id')
      .whereNotNull('vehicles.device_id')
      .select(
        'vehicles.vehicle_id',
        'vehicles.device_id',
        'vehicles.police_status',
        'vehicles.registration_number',
        'provinces.name as province_name'
      )
      .orderBy('vehicles.registration_number')

    console.log(`Found ${vehicles.length} vehicles with devices`)
    console.log(`Generating 7 days of pings at 2 minute intervals`)
    console.log(`Expected documents: ~${vehicles.length * 5040}`)
    console.log('')

    let totalInserted = 0
    const startTime = Date.now()

    for (let i = 0; i < vehicles.length; i++) {
      const vehicle = vehicles[i]
      const districtName = getDistrictForProvince(vehicle.province_name, i)
      const profile = assignBehaviourProfile(vehicle.police_status, i)

      const pings = generatePingsForVehicle(vehicle, districtName, profile)

      await collection.insertMany(pings, { ordered: false })
      totalInserted += pings.length

      if ((i + 1) % 10 === 0 || i === vehicles.length - 1) {
        const elapsed = ((Date.now() - startTime) / 1000).toFixed(1)
        console.log(`  ${i + 1}/${vehicles.length} vehicles done — ${totalInserted} pings — ${elapsed}s elapsed`)
      }
    }

    const elapsed = ((Date.now() - startTime) / 1000).toFixed(1)
    console.log('')
    console.log(`Simulation complete`)
    console.log(`Total pings inserted: ${totalInserted}`)
    console.log(`Time taken: ${elapsed} seconds`)

  } catch (err) {
    console.error('Error:', err.message)
    console.error(err.stack)
  } finally {
    await mongoClient.close()
    await db.destroy()
    console.log('Connections closed')
  }
}

run()