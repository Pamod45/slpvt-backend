import 'dotenv/config'
import { validateEnvironment } from './config/environment.js'

validateEnvironment()

import app from './app.js'
import db from './db/postgres.js'
import mongoose from 'mongoose'

const PORT = process.env.PORT || 3000

const server = app.listen(PORT, () => {
  console.log(`SLPVT API running on port ${PORT}`)
  console.log(`Environment: ${process.env.NODE_ENV}`)
})

const shutdown = async (signal) => {
  console.log(`${signal} received — shutting down gracefully`)
  server.close(async () => {
    await db.destroy()
    await mongoose.connection.close()
    console.log('Connections closed — process exiting')
    process.exit(0)
  })
}

process.on('SIGTERM', () => shutdown('SIGTERM'))
process.on('SIGINT',  () => shutdown('SIGINT'))