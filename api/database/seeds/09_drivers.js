/**
 * Drivers seed
 * 210 tuk-tuk drivers with realistic Sri Lankan details
 * Each driver will be assigned to one vehicle in the next seed
 * Driving license numbers follow Sri Lankan format
 */

export const seed = async function (knex) {
  await knex('drivers').del()

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

  const addresses = [
    'No. 45, Galle Road, Colombo 03',
    'No. 12, Kandy Road, Kelaniya',
    'No. 78, Main Street, Negombo',
    'No. 23, High Level Road, Homagama',
    'No. 56, Highlevel Road, Nugegoda',
    'No. 34, Station Road, Panadura',
    'No. 89, Galle Road, Kalutara',
    'No. 15, Peradeniya Road, Kandy',
    'No. 67, Colombo Road, Gampaha',
    'No. 91, Marine Drive, Galle',
    'No. 43, Matara Road, Weligama',
    'No. 28, Hospital Road, Matara',
    'No. 72, New Road, Horana',
    'No. 36, Temple Road, Bandaragama',
    'No. 54, Lake Road, Kaduwela'
  ]

  const policeStatuses = [
    ...Array(195).fill('CLEAR'),
    ...Array(10).fill('WANTED'),
    ...Array(5).fill('SUSPENDED_LICENSE')
  ]

  const getRandom = (arr) => arr[Math.floor(Math.random() * arr.length)]

  const generateLicenseNumber = (index) => {
    const number = String(index + 1000000).slice(1)
    return `B${number}`
  }

  const generateLicenseExpiry = () => {
    const today = new Date()
    const yearsToAdd = Math.floor(Math.random() * 8) + 1
    const expiry = new Date(today)
    expiry.setFullYear(expiry.getFullYear() + yearsToAdd)
    return expiry.toISOString().split('T')[0]
  }

  const drivers = []

  for (let i = 0; i < 210; i++) {
    const firstName = getRandom(sriLankanFirstNames)
    const lastName = getRandom(sriLankanLastNames)

    drivers.push({
      first_name:             firstName,
      last_name:              lastName,
      permanent_address:      getRandom(addresses),
      driving_license_number: generateLicenseNumber(i),
      license_expiry_date:    generateLicenseExpiry(),
      police_status:          policeStatuses[i]
    })
  }

  await knex('drivers').insert(drivers)

  console.log('210 drivers seeded')
  console.log('CLEAR: 195')
  console.log('WANTED: 10')
  console.log('SUSPENDED_LICENSE: 5')
}
