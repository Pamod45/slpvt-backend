import express from 'express'
import helmet from 'helmet'
import cors from 'cors'
import morgan from 'morgan'
import swaggerUi from 'swagger-ui-express'
import { readFileSync } from 'fs'
import { parse } from 'yaml'
import { fileURLToPath } from 'url'
import path from 'path'
import { httpLogger } from './utils/logger.js'
import 'dotenv/config'

import connectMongo from './db/mongo.js'
import './db/postgres.js'
import errorHandler from './middleware/errorHandler.js'
import router from './routes/index.js'

const __dirname = path.dirname(fileURLToPath(import.meta.url))
const swaggerSpec = parse(readFileSync(path.join(__dirname, '../../artifacts/APISpecificationOPENAPI.yaml'), 'utf8'))

const app = express()

app.set('strict routing', true)

connectMongo()

// contentSecurityPolicy disabled so Swagger UI scripts and styles load correctly
app.use(helmet({ contentSecurityPolicy: false }))
app.use(cors())
app.use(morgan('dev', { stream: { write: httpLogger } }))
app.use(express.json())

// redirect trailing slashes to non-trailing slashes (except root /) *
app.use((req, res, next) => {
  if (req.path.endsWith('/') && req.path.length > 1 && !req.path.startsWith('/slpvt/v1/docs')) {
    const query = req.url.slice(req.path.length)
    const newUrl = req.path.slice(0, -1) + query
    return res.redirect(301, newUrl)
  }
  next()
})

app.use('/slpvt/v1', router)

app.use('/slpvt/v1/docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec))

app.use((req, res) => {
  res.status(404).json({
    code:        404,
    message:     'Route not found',
    description: `${req.method} ${req.originalUrl} does not exist`
  })
})

app.use(errorHandler)

export default app