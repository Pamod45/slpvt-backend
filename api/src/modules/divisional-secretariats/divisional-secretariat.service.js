/**
 * Divisional Secretariat service
 * Business logic for divisional secretariat operations
 */

import * as dsRepository from './divisional-secretariat.repository.js'
import { NotFoundError } from '../../utils/errors.js'
import { formatDivisionalSecretariat } from './divisional-secretariat.presenter.js'

export const listDivisionalSecretariats = async (pagination) => {
  const result = await dsRepository.findAll(pagination)
  return {
    count: result.count,
    data: result.data.map(formatDivisionalSecretariat)
  }
}

export const getDivisionalSecretariatBySlug = async (dsSlug) => {
  const ds = await dsRepository.findBySlug(dsSlug)

  if (!ds) {
    throw new NotFoundError('Divisional Secretariat not found')
  }

  return formatDivisionalSecretariat(ds)
}
