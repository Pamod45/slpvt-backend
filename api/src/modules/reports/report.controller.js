import * as reportService from './report.service.js'
import { paginated } from '../../utils/response.js'

export const getBoundaryCrossings = async (req, res, next) => {
  try {
    const crossings = await reportService.calculateBoundaryCrossings(req.query, req.user)
    
    const offset = parseInt(req.query.offset) || 0
    const limit  = Math.min(parseInt(req.query.limit) || 20, 100)
    const paginatedData = crossings.slice(offset, offset + limit)

    res.status(200).json(paginated(req, paginatedData, crossings.length, { offset, limit }))
  } catch (err) {
    next(err)
  }
}
