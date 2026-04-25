/**
 * Vehicles seed
 * 210 tuk-tuks distributed across Western, Central and Southern provinces
 * Linked to tracking devices seeded in 07_tracking_devices
 * Owner details generated with Sri Lankan names
 * Registration numbers follow official Sri Lanka DMT format
 */

export const seed = async function (knex) {
  await knex('vehicles').del()

  const provinces = await knex('provinces')
    .select('province_id', 'name')
    .whereIn('name', ['Western', 'Central', 'Southern'])

  const p = {}
  provinces.forEach(prov => {
    p[prov.name] = prov.province_id
  })

const devices = await knex('tracking_devices')
  .select('device_id', 'serial_number', 'admin_status')
  .whereIn('admin_status', ['ACTIVE', 'UNDER_REPAIR'])
  .orderBy('serial_number')

  const sriLankanFirstNames = [
    'Nuwan', 'Kamal', 'Roshan', 'Chaminda', 'Pradeep',
    'Dilshan', 'Suresh', 'Asanka', 'Mahesh', 'Thilak',
    'Ruwan', 'Janaka', 'Prasad', 'Lasith', 'Harsha',
    'Nimal', 'Saman', 'Upul', 'Chathura', 'Dhanushka',
    'Kasun', 'Tharaka', 'Buddika', 'Sachith', 'Gayan',
    'Nadun', 'Isuru', 'Malith', 'Shehan', 'Hirantha',
    'Kumari', 'Dilini', 'Sachini', 'Thilini', 'Nadeesha',
    'Chathurika', 'Sandya', 'Nimasha', 'Anusha', 'Rashmi',
    'Chamari', 'Iresha', 'Menaka', 'Pavithra', 'Sewwandi'
  ]

  const sriLankanLastNames = [
    'Perera', 'Silva', 'Fernando', 'Jayawardena', 'Wickramasinghe',
    'Rajapaksa', 'Bandara', 'Gunasekara', 'Dissanayake', 'Rathnayake',
    'Herath', 'Senanayake', 'Jayasuriya', 'Amarasinghe', 'Pathirana',
    'Kumara', 'Wijesinghe', 'Madushanka', 'Liyanage', 'Gunaratne',
    'Seneviratne', 'Weerasinghe', 'Abeysekara', 'Ranasinghe', 'Mendis'
  ]

  const makeModels = [
    { make: 'Bajaj RE',    count: 130 },
    { make: 'TVS King',    count: 50  },
    { make: 'Bajaj RE 4S', count: 20  },
    { make: 'Piaggio Ape', count: 10  }
  ]

  const colors = [
    'Yellow', 'Blue', 'Green', 'Red',
    'White', 'Silver', 'Orange'
  ]

  const makeModelList = []
  makeModels.forEach(m => {
    for (let i = 0; i < m.count; i++) {
      makeModelList.push(m.make)
    }
  })

  const getRandom = (arr) => arr[Math.floor(Math.random() * arr.length)]

  const generateNIC = (index) => {
    if (index % 2 === 0) {
      const digits = String(Math.floor(Math.random() * 900000000) + 100000000)
      return digits + (Math.random() > 0.5 ? 'V' : 'X')
    }
    const year = String(Math.floor(Math.random() * 30) + 1970)
    const digits = String(Math.floor(Math.random() * 9000000) + 1000000)
    return year + digits
  }

  const generateContact = () => {
    const prefixes = ['071', '072', '077', '078', '076', '075', '074']
    const prefix = getRandom(prefixes)
    const number = String(Math.floor(Math.random() * 9000000) + 1000000)
    return `+94${prefix.slice(1)}${number}`
  }

  const provinceDistribution = [
    ...Array(115).fill('Western'),
    ...Array(50).fill('Central'),
    ...Array(40).fill('Southern')
  ]

  const policeStatuses = [
    ...Array(185).fill('CLEAN'),
    ...Array(8).fill('STOLEN'),
    ...Array(7).fill('WANTED'),
    ...Array(5).fill('SUSPENDED')
  ]

  const provinceCodes = {
    Western:  'WP',
    Central:  'CP',
    Southern: 'SP'
  }

  const letterCombinations = []
  const letters = 'ABCDEFGHJKLMNPQRSTUVWXYZ'
  for (let i = 0; i < letters.length; i++) {
    for (let j = 0; j < letters.length; j++) {
      for (let k = 0; k < letters.length; k++) {
        letterCombinations.push(`${letters[i]}${letters[j]}${letters[k]}`)
        if (letterCombinations.length >= 210) break
      }
      if (letterCombinations.length >= 210) break
    }
    if (letterCombinations.length >= 210) break
  }

  const vehicles = []

  for (let i = 0; i < 205; i++) {
    const provinceName = provinceDistribution[i]
    const provinceCode = provinceCodes[provinceName]
    const letters = letterCombinations[i]
    const number = String(Math.floor(Math.random() * 9000) + 1000)
    const registrationNumber = `${provinceCode} ${letters}-${number}`

    const chassisNumber = `CHASSIS${String(i + 1).padStart(8, '0')}`

    let deviceId = null
    if (i < 205) {
      deviceId = devices[i].device_id
    }

    const firstName = getRandom(sriLankanFirstNames)
    const lastName = getRandom(sriLankanLastNames)

    vehicles.push({
      registration_number:    registrationNumber,
      chassis_number:         chassisNumber,
      color:                  getRandom(colors),
      make_model:             makeModelList[i],
      device_id:              deviceId,
      police_status:          policeStatuses[i],
      owner_nic:              generateNIC(i),
      owner_full_name:        `${firstName} ${lastName}`,
      owner_contact:          generateContact(),
      registered_province_id: p[provinceName]
    })
  }

  await knex('vehicles').insert(vehicles)

  console.log('205 vehicles seeded')
  console.log('Western Province: 115 vehicles')
  console.log('Central Province: 50 vehicles')
  console.log('Southern Province: 40 vehicles')
}