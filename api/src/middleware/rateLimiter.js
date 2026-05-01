/**
 * Rate limiting middleware
 * Different limits per endpoint type
 * Prevents abuse and protects high volume endpoints
 * Applied at route level not globally
 */

import rateLimit, { ipKeyGenerator } from 'express-rate-limit'
import { error } from '../utils/response.js'

// ─────────────────────────────────────────────
// RATE LIMIT RESPONSE HANDLER
// returns consistent error format per WSO2 guidelines
// ─────────────────────────────────────────────

const rateLimitHandler = (req, res) => {
  res.status(429).json(
    error(
      429,
      'Too many requests',
      'You have exceeded the rate limit. Please try again later.'
    )
  )
}

// ─────────────────────────────────────────────
// AUTH LIMITER
// ─────────────────────────────────────────────
export const authLimiter = rateLimit({
  windowMs:          15 * 60 * 1000,
  max:               10,
  standardHeaders:   true,
  legacyHeaders:     false,
  handler:           rateLimitHandler,
  keyGenerator:      (req, res) => ipKeyGenerator(req, res) || req.ip
})

// ─────────────────────────────────────────────
// STANDARD API LIMITER
// ─────────────────────────────────────────────
export const standardLimiter = rateLimit({
  windowMs:          60 * 1000,
  max:               100,
  standardHeaders:   true,
  legacyHeaders:     false,
  handler:           rateLimitHandler,
  keyGenerator: (req) => req.user?.user_id || ipKeyGenerator(req)
})

// ─────────────────────────────────────────────
// LOCATION QUERY LIMITER
// ─────────────────────────────────────────────
export const locationLimiter = rateLimit({
  windowMs:          60 * 1000,
  max:               30,
  standardHeaders:   true,
  legacyHeaders:     false,
  handler:           rateLimitHandler,
  keyGenerator: (req) => req.user?.user_id || ipKeyGenerator(req)
})

// ─────────────────────────────────────────────
// DEVICE PING LIMITER
// ─────────────────────────────────────────────
export const pingLimiter = rateLimit({
  windowMs:          60 * 1000,
  max:               200,
  standardHeaders:   true,
  legacyHeaders:     false,
  handler:           rateLimitHandler,
  keyGenerator: (req) => req.headers['x-device-key'] || ipKeyGenerator(req)
})