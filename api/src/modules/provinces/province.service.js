/**
 * Province service
 * Business logic for province operations
 * All authenticated roles can read provinces
 * Only SUPER_ADMIN can create or update
 */

import * as provinceRepository from './province.repository.js'
import { NotFoundError, ConflictError } from '../../utils/errors.js'

export const listProvinces = async (pagination) => {
  return provinceRepository.findAll(pagination)
}

export const getProvinceById = async (provinceId) => {
  const province = await provinceRepository.findById(provinceId)

  if (!province) {
    throw new NotFoundError('Province not found')
  }

  return province
}

export const getProvinceBySlug = async (provinceSlug) => {
  const province = await provinceRepository.findBySlug(provinceSlug)

  if (!province) {
    throw new NotFoundError('Province not found')
  }

  return province
}

export const getProvinceDistricts = async (provinceSlug, pagination) => {
  const province = await provinceRepository.findBySlug(provinceSlug)

  if (!province) {
    throw new NotFoundError('Province not found')
  }

  const districts = await provinceRepository.findDistrictsByProvince(province.province_id, pagination)

  return {
    province_id:   province.province_id,
    province_name: province.name,
    province_slug: province.province_slug,
    count:         districts.count,
    data:          districts.data
  }
}
