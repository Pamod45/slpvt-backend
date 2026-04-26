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

// Enable strict routing so /resources and /resources/ are treated differently
app.set('strict routing', true)

connectMongo()

app.use(helmet())
app.use(cors())
app.use(morgan('dev'))
app.use(express.json())

// redirect trailing slashes to non-trailing slashes (except root /)
app.use((req, res, next) => {
  if (req.path.endsWith('/') && req.path.length > 1) {
    const query = req.url.slice(req.path.length)
    const newUrl = req.path.slice(0, -1) + query
    return res.redirect(301, newUrl)
  }
  next()
})

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