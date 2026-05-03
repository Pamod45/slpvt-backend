/**
 * Province service
 * Business logic for province operations
 * All authenticated roles can read provinces
 * Only SUPER_ADMIN can create or update
 */

import * as provinceRepository from './province.repository.js'
import { NotFoundError, ConflictError } from '../../utils/errors.js'
import { formatProvince } from './province.presenter.js'

export const listProvinces = async (pagination) => {
  const result = await provinceRepository.findAll(pagination)
  return {
    count: result.count,
    data: result.data.map(formatProvince)
  }
}

export const getProvinceById = async (provinceId) => {
  const province = await provinceRepository.findById(provinceId)

  if (!province) {
    throw new NotFoundError('Province not found')
  }

  return formatProvince(province)
}

export const getProvinceBySlug = async (provinceSlug) => {
  const province = await provinceRepository.findBySlug(provinceSlug)

  if (!province) {
    throw new NotFoundError('Province not found')
  }

  return formatProvince(province)
}

