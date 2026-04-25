/**
 * District boundary seeder
 * Reads GADM GeoJSON file and inserts district boundaries into MongoDB
 * Links each boundary to the correct district_id from PostgreSQL
 * Run once after provinces and districts are seeded in PostgreSQL
 * Command: node scripts/seedDistrictBoundaries.js
 */

import { readFileSync } from 'fs'
import { MongoClient } from 'mongodb'
import knex from 'knex'
import knexConfig from '../knexfile.js'
import 'dotenv/config'

const db = knex(knexConfig.development)

const run = async () => {
  const mongoClient = new MongoClient(process.env.MONGO_URI)

  try {
    await mongoClient.connect()
    console.log('MongoDB connected')

    const mongoDb = mongoClient.db()
    const collection = mongoDb.collection('districts')

    await collection.drop().catch(() => {
      console.log('No existing districts collection — creating fresh')
    })

    await collection.createIndex({ boundary: '2dsphere' })
    await collection.createIndex({ district_id: 1 })

    const rawFile = readFileSync('./data/district_spatial_data.json', 'utf8')
    const geojson = JSON.parse(rawFile)

    const districts = await db('districts').select('district_id', 'name')

    const districtMap = {}
    districts.forEach(d => {
      districtMap[d.name] = d.district_id
    })

    const documents = []
    let matched = 0
    let unmatched = []

    for (const feature of geojson.features) {
      const gadmName = feature.properties.NAME_1

      const districtId = districtMap[gadmName]

      if (!districtId) {
        unmatched.push(gadmName)
        continue
      }

      documents.push({
        district_id: districtId,
        name: gadmName,
        boundary: feature.geometry
      })

      matched++
    }

    if (documents.length > 0) {
      await collection.insertMany(documents)
    }

    console.log(`Inserted: ${matched} districts`)

    if (unmatched.length > 0) {
      console.log(`Unmatched GADM names — check spelling:`)
      unmatched.forEach(name => console.log(`  - ${name}`))
    }

  } catch (err) {
    console.error('Error:', err.message)
  } finally {
    await mongoClient.close()
    await db.destroy()
    console.log('Connections closed')
  }
}

run()