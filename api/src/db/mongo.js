/**
 * MongoDB connection via Mongoose
 * Single shared connection used across all location related files
 * Connects once on application startup
 */

import mongoose from 'mongoose'
import { env } from '../config/environment.js'

const connectMongo = async () => {
  try {
    await mongoose.connect(env.mongo.uri)
    console.log('MongoDB connected successfully')
  } catch (err) {
    console.error('MongoDB connection failed:', err.message)
    process.exit(1)
  }
}

export default connectMongo