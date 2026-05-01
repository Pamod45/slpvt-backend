import { randomBytes, createHash } from 'crypto'
import * as deviceRepository from './device.repository.js'
import { NotFoundError, ConflictError } from '../../utils/errors.js'
import { DEVICE_KEY } from '../../config/constants.js'

const generateApiKey = () => {
  const rawKey = randomBytes(DEVICE_KEY.BYTE_LENGTH).toString('hex')
  const hash   = createHash(DEVICE_KEY.HASH_ALGO).update(rawKey).digest('hex')
  return { rawKey, hash }
}

export const listDevices = async (pagination) => {
  return deviceRepository.findAll(pagination)
}

export const getDevice = async (serialNumber) => {
  const device = await deviceRepository.findBySerialNumber(serialNumber)
  if (!device) throw new NotFoundError('Device not found')
  return device
}

export const provisionDevice = async (data) => {
  const existing = await deviceRepository.findBySerialNumber(data.serial_number)
  if (existing) throw new ConflictError('A device with this serial number already exists')

  const { rawKey, hash } = generateApiKey()

  const device = await deviceRepository.create({ ...data, api_key_hash: hash })

  return { ...device, api_key: rawKey }
}

export const updateDevice = async (serialNumber, data) => {
  const device = await deviceRepository.findBySerialNumber(serialNumber)
  if (!device) throw new NotFoundError('Device not found')
  return deviceRepository.update(device.device_id, data)
}
