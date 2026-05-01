/**
 * Central router
 * Mounts all module routers at their base paths
 * All routes are prefixed with /api/v1
 * Modules are imported here as they are built
 */

import { Router } from 'express'

const router = Router()

router.get('/health', (req, res) => {
  res.status(200).json({
    status:      'ok',
    timestamp:   new Date().toISOString(),
    environment: process.env.NODE_ENV,
    version:     'v1'
  })
})


import authRoutes       from '../modules/auth/auth.routes.js'
import provinceRoutes   from '../modules/provinces/province.routes.js'
import districtRoutes   from '../modules/districts/district.routes.js'
import dsRoutes         from '../modules/divisional-secretariats/divisional-secretariat.routes.js'
import stationRoutes    from '../modules/stations/station.routes.js'
import userRoutes       from '../modules/users/user.routes.js'
import deviceRoutes     from '../modules/devices/device.routes.js'
import vehicleRoutes    from '../modules/vehicles/vehicle.routes.js'
import driverRoutes     from '../modules/drivers/driver.routes.js'
import locationRoutes     from '../modules/locations/location.routes.js'
import liveLocationRoutes from '../modules/locations/live-location.routes.js'
import reportRoutes       from '../modules/reports/report.routes.js'

router.use('/auth',           authRoutes)
router.use('/provinces',      provinceRoutes)
router.use('/districts',      districtRoutes)
router.use('/divisional-secretariats', dsRoutes)
router.use('/stations',       stationRoutes)
router.use('/users',          userRoutes)
router.use('/devices',        deviceRoutes)
router.use('/vehicles',       vehicleRoutes)
router.use('/drivers',        driverRoutes)
router.use('/locations',      locationRoutes)
router.use('/live-locations', liveLocationRoutes)
router.use('/reports',        reportRoutes)

export default router
