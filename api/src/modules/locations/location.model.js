import mongoose from 'mongoose'

const locationPingSchema = new mongoose.Schema(
  {
    device_id: {
      type:     String,
      required: true
    },

    location: {
      type: {
        type:     String,
        enum:     ['Point'],
        required: true
      },
      coordinates: {
        type:     [Number],
        required: true
      }
    },

    battery_level: {
      type:     Number,
      required: true,
      min:      0,
      max:      100
    },

    pinged_at: {
      type:     Date,
      required: true
    }
  },
  {
    collection: 'location_pings',
    timestamps: false
  }
)

// Geospatial index — required for $near and $geoWithin queries
locationPingSchema.index({ location: '2dsphere' })

// Device + time composite — live location and history lookups, unique to prevent duplicate pings
locationPingSchema.index({ device_id: 1, pinged_at: -1 }, { unique: true })

// TTL — auto-expire documents older than 90 days
locationPingSchema.index({ pinged_at: 1 }, { expireAfterSeconds: 60 * 60 * 24 * 90 })

export const LocationPing = mongoose.model('LocationPing', locationPingSchema)

// ─────────────────────────────────────────────
// BOUNDARY MODELS
// Read-only — seeded by seedDistrictBoundaries.js and seedDSBoundaries.js
// ─────────────────────────────────────────────

const boundaryFields = {
  boundary: {
    type:        { type: String, enum: ['Polygon', 'MultiPolygon'] },
    coordinates: mongoose.Schema.Types.Mixed
  }
}

const districtBoundarySchema = new mongoose.Schema(
  { district_id: String, name: String, ...boundaryFields },
  { collection: 'districts' }
)
districtBoundarySchema.index({ district_id: 1 })
districtBoundarySchema.index({ boundary: '2dsphere' })

export const DistrictBoundary = mongoose.model('DistrictBoundary', districtBoundarySchema)

const dsBoundarySchema = new mongoose.Schema(
  { ds_division_id: String, name: String, ...boundaryFields },
  { collection: 'divisional_secretariats' }
)
dsBoundarySchema.index({ ds_division_id: 1 })
dsBoundarySchema.index({ boundary: '2dsphere' })

export const DSBoundary = mongoose.model('DSBoundary', dsBoundarySchema)
