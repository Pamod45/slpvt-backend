/**
 * Rate limiting middleware
 * Different limits per endpoint type
 * Prevents abuse and protects high volume endpoints
 * Applied at route level not globally
 */

import rateLimit from 'express-rate-limit'
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
// strict — prevents brute force login attempts
// 10 attempts per 15 minutes per IP
// ─────────────────────────────────────────────

export const authLimiter = rateLimit({
  windowMs:          15 * 60 * 1000,
  max:               10,
  standardHeaders:   true,
  legacyHeaders:     false,
  handler:           rateLimitHandler,
  keyGenerator:      (req) => req.ip
})

// ─────────────────────────────────────────────
// STANDARD API LIMITER
// general endpoints — vehicles, drivers, stations etc
// 100 requests per minute per user
// ─────────────────────────────────────────────

export const standardLimiter = rateLimit({
  windowMs:          60 * 1000,
  max:               100,
  standardHeaders:   true,
  legacyHeaders:     false,
  handler:           rateLimitHandler,
  keyGenerator:      (req) => req.user?.user_id || req.ip
})

// ─────────────────────────────────────────────
// LOCATION QUERY LIMITER
// heavy queries — area movement, history
// stricter limit to protect MongoDB
// 30 requests per minute per user
// ─────────────────────────────────────────────

export const locationLimiter = rateLimit({
  windowMs:          60 * 1000,
  max:               30,
  standardHeaders:   true,
  legacyHeaders:     false,
  handler:           rateLimitHandler,
  keyGenerator:      (req) => req.user?.user_id || req.ip
})

// ─────────────────────────────────────────────
// DEVICE PING LIMITER
// high volume — devices ping frequently
// 200 requests per minute per device
// keyed by device_id not IP
// ─────────────────────────────────────────────

export const pingLimiter = rateLimit({
  windowMs:          60 * 1000,
  max:               200,
  standardHeaders:   true,
  legacyHeaders:     false,
  handler:           rateLimitHandler,
  keyGenerator:      (req) => req.device?.device_id || req.ip
})