import 'dotenv/config'
import { validateEnvironment } from './config/environment.js'

validateEnvironment()

import app from './app.js'

const PORT = process.env.PORT || 3000

app.listen(PORT, () => {
  console.log(`SLPVT API running on port ${PORT}`)
  console.log(`Environment: ${process.env.NODE_ENV}`)
})