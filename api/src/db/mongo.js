/**
 * MongoDB connection
 * Used by the application at runtime
 * Separate from the seeder script which creates its own connection
 */

import mongoose from 'mongoose'

const connectMongo = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI)
    console.log('MongoDB connected successfully')
  } catch (err) {
    console.error('MongoDB connection failed:', err.message)
    process.exit(1)
  }
}

export default connectMongo