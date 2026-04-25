/**
 * Environment variable validation
 * Runs at application startup
 * If any required variable is missing the app refuses to start
 * Prevents mysterious runtime errors from missing configuration
 */

const required = [
  'NODE_ENV',
  'PORT',
  'PG_HOST',
  'PG_PORT',
  'PG_DB',
  'PG_USER',
  'PG_PASSWORD',
  'MONGO_URI',
  'JWT_SECRET',
  'JWT_EXPIRES_IN',
  'JWT_REFRESH_EXPIRES_IN'
]

export const validateEnvironment = () => {
  const missing = required.filter(key => !process.env[key])

  if (missing.length > 0) {
    console.error('Missing required environment variables:')
    missing.forEach(key => console.error(`  - ${key}`))
    process.exit(1)
  }

  console.log('Environment variables validated successfully')
}

export const env = {
  NODE_ENV:    process.env.NODE_ENV || 'development',
  PORT:        parseInt(process.env.PORT) || 3000,
  isDev:       process.env.NODE_ENV === 'development',
  isProd:      process.env.NODE_ENV === 'production',

  pg: {
    host:     process.env.PG_HOST,
    port:     parseInt(process.env.PG_PORT) || 5432,
    database: process.env.PG_DB,
    user:     process.env.PG_USER,
    password: process.env.PG_PASSWORD
  },

  mongo: {
    uri: process.env.MONGO_URI
  },

  jwt: {
    secret:         process.env.JWT_SECRET,
    expiresIn:      process.env.JWT_EXPIRES_IN      || '15m',
    refreshExpires: process.env.JWT_REFRESH_EXPIRES_IN || '7d'
  }
}