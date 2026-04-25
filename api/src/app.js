import express from 'express'
import helmet from 'helmet'
import cors from 'cors'
import morgan from 'morgan'
import 'dotenv/config'

import connectMongo from './db/mongo.js'
import './db/postgres.js'
import errorHandler from './middleware/errorHandler.js'
import router from './routes/index.js'

const app = express()

connectMongo()

app.use(helmet())
app.use(cors())
app.use(morgan('dev'))
app.use(express.json())

// mount all routes under /api/v1
app.use('/api/v1', router)

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    code:        404,
    message:     'Route not found',
    description: `${req.method} ${req.originalUrl} does not exist`
  })
})

// global error handler — must be last
app.use(errorHandler)

export default app