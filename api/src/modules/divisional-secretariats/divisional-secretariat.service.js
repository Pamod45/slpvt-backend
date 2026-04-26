/**
 * Divisional Secretariat service
 * Business logic for divisional secretariat operations
 */

import * as dsRepository from './divisional-secretariat.repository.js'
import { NotFoundError } from '../../utils/errors.js'

export const listDivisionalSecretariats = async (pagination) => {
  return dsRepository.findAll(pagination)
}

export const getDivisionalSecretariatBySlug = async (dsSlug) => {
  const ds = await dsRepository.findBySlug(dsSlug)

  if (!ds) {
    throw new NotFoundError('Divisional Secretariat not found')
  }

  return ds
}
