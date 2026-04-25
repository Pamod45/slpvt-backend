/**
 * PostgreSQL connection via Knex
 * Shared instance used across all repository files
 */

import knex from 'knex'
import knexConfig from '../../knexfile.js'

const db = knex(knexConfig[process.env.NODE_ENV || 'development'])

export default db