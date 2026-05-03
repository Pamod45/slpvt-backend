/**
 * District service
 * Business logic for district operations
 */

import * as districtRepository from './district.repository.js'
import * as provinceRepository from '../provinces/province.repository.js'
import { NotFoundError } from '../../utils/errors.js'
import { formatDistrict } from './district.presenter.js'

export const listDistricts = async (pagination) => {
  const result = await districtRepository.findAll(pagination)
  return {
    count: result.count,
    data: result.data.map(formatDistrict)
  }
}

export const getDistrictBySlug = async (districtSlug) => {
  const district = await districtRepository.findBySlug(districtSlug)

  if (!district) {
    throw new NotFoundError('District not found')
  }

  return formatDistrict(district)
}

export const listDistrictsByProvince = async (provinceSlug, pagination) => {
  const province = await provinceRepository.findBySlug(provinceSlug)

  if (!province) throw new NotFoundError('Province not found')

  const result = await districtRepository.findAllByProvinceId(province.province_id, pagination)

  return { count: result.count, data: result.data.map(formatDistrict) }
}

