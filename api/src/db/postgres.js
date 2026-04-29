/**
 * PostgreSQL connection via Knex
 * Single shared instance used across all repository files
 * Connection pool managed by Knex automatically
 */

import knex from 'knex'
import { env } from '../config/environment.js'

const db = knex({
  client: 'pg',
  connection: {
    host:     env.pg.host,
    port:     env.pg.port,
    database: env.pg.database,
    user:     env.pg.user,
    password: env.pg.password,
    ssl:      env.pg.host !== 'localhost' ? { rejectUnauthorized: false } : false
  },
  pool: {
    min: 2,
    max: 10
  },
  acquireConnectionTimeout: 10000
})

// test connection on startup
db.raw('SELECT 1')
  .then(() => console.log('PostgreSQL connected successfully'))
  .catch(err => {
    console.error('PostgreSQL connection failed:', err.message)
    process.exit(1)
  })

export default db