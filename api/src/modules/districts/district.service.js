/**
 * District service
 * Business logic for district operations
 */

import * as districtRepository from './district.repository.js'
import { NotFoundError } from '../../utils/errors.js'
import { formatDistrict } from './district.presenter.js'
import { formatDivisionalSecretariat } from '../divisional-secretariats/divisional-secretariat.presenter.js'

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

export const getDistrictDivisionalSecretariats = async (districtSlug, pagination) => {
  const district = await districtRepository.findBySlug(districtSlug)

  if (!district) {
    throw new NotFoundError('District not found')
  }

  const result = await districtRepository.findDivisionalSecretariatsByDistrict(district.district_id, pagination)

  return {
    district_id:   district.district_id,
    district_name: district.name,
    district_slug: district.district_slug,
    count:         result.count,
    data:          result.data.map(formatDivisionalSecretariat)
  }
}
