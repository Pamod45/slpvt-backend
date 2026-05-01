/**
 * Divisional Secretariat boundary seeder
 * Reads GADM level 2 GeoJSON file and inserts DS boundaries into MongoDB
 * Links each boundary to the correct ds_division_id from PostgreSQL
 * NAME_2 in GADM maps to name in divisional_secretariats table
 * Command: node scripts/seedDSBoundaries.js
 */

import { readFileSync } from 'fs'
import { MongoClient } from 'mongodb'
import knex from 'knex'
import knexConfig from '../knexfile.js'
import 'dotenv/config'

const env = process.env.NODE_ENV || 'development'
const db = knex(knexConfig[env])

const roundCoordinates = (geometry) => {
  const round = (coords) => {
    if (typeof coords[0] === 'number') {
      return coords.map(c => Math.round(c * 10000) / 10000)
    }
    return coords.map(round)
  }
  return {
    ...geometry,
    coordinates: round(geometry.coordinates)
  }
}

const run = async () => {
  const mongoClient = new MongoClient(process.env.MONGO_URI)

  try {
    await mongoClient.connect()
    console.log('MongoDB connected')

    const mongoDb = mongoClient.db()
    const collection = mongoDb.collection('divisional_secretariats')

    await collection.drop().catch(() => {
      console.log('No existing divisional_secretariats collection — creating fresh')
    })

    const rawFile = readFileSync('./data/ds_spatial_data.json', 'utf8')
    const geojson = JSON.parse(rawFile)

    const divisions = await db('divisional_secretariats')
      .select('ds_division_id', 'name')

    const dsMap = {}
    divisions.forEach(ds => {
      dsMap[ds.name] = ds.ds_division_id
    })

    const documents = []
    let matched = 0
    let unmatched = []

    for (const feature of geojson.features) {
      const gadmName = feature.properties.NAME_2
      const dsId = dsMap[gadmName]

      if (!dsId) {
        unmatched.push(gadmName)
        continue
      }

      const geometry = roundCoordinates(feature.geometry)

      documents.push({
        ds_division_id: dsId,
        name: gadmName,
        boundary: geometry
      })

      matched++
    }

    if (documents.length > 0) {
      await collection.insertMany(documents, { ordered: false })
    }

    await collection.createIndex({ boundary: '2dsphere' })
    await collection.createIndex({ ds_division_id: 1 })
    console.log('Indexes created')

    console.log(`Inserted: ${matched} DS divisions`)

    if (unmatched.length > 0) {
      console.log('Unmatched GADM NAME_2 values — check spelling:')
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