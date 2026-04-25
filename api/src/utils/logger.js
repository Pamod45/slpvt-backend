/**
 * Winston logger setup
 * Two transports — console for development, file for production
 * All modules import this logger instead of using console.log directly
 * Log levels: error, warn, info, http, debug
 */

import winston from 'winston'
import { env } from '../config/environment.js'

const { combine, timestamp, colorize, printf, json } = winston.format

// custom format for development console output
const devFormat = printf(({ level, message, timestamp, ...meta }) => {
  const metaStr = Object.keys(meta).length
    ? `\n${JSON.stringify(meta, null, 2)}`
    : ''
  return `${timestamp} [${level}] ${message}${metaStr}`
})

const logger = winston.createLogger({
  level: env.isDev ? 'debug' : 'info',

  transports: [

    // console transport — always on
    new winston.transports.Console({
      format: env.isDev
        ? combine(
            colorize(),
            timestamp({ format: 'HH:mm:ss' }),
            devFormat
          )
        : combine(
            timestamp(),
            json()
          )
    }),

    // file transport — production only
    ...(!env.isDev ? [
      new winston.transports.File({
        filename: 'logs/error.log',
        level:    'error',
        format:   combine(timestamp(), json())
      }),
      new winston.transports.File({
        filename: 'logs/combined.log',
        format:   combine(timestamp(), json())
      })
    ] : [])
  ]
})

// HTTP request logger for Morgan
export const httpLogger = (message) => {
  logger.http(message.trim())
}

export default logger