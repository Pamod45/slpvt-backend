/**
 * Divisional Secretariats seed
 * 29 DS divisions across 6 districts
 * Remaining districts have no DS divisions at this stage
 * Run after 02_districts seed
 */

export const seed = async function (knex) {
  await knex('divisional_secretariats').del()

  const districts = await knex('districts').select('district_id', 'name')

  const d = {}
  districts.forEach(district => {
    d[district.name] = district.district_id
  })

  await knex('divisional_secretariats').insert([
    // Colombo District — 7 DS divisions
    { name: 'Colombo',                  district_id: d['Colombo'] },
    { name: 'Dehiwala-MountLavinia',    district_id: d['Colombo'] },
    { name: 'Homagama',                 district_id: d['Colombo'] },
    { name: 'Kaduwela',                 district_id: d['Colombo'] },
    { name: 'Kesbewa',                  district_id: d['Colombo'] },
    { name: 'SriJayawardanapuraKotte',  district_id: d['Colombo'] },
    { name: 'Thimbirigasyaya',          district_id: d['Colombo'] },

    // Gampaha District — 4 DS divisions
    { name: 'Ja-Ela',                   district_id: d['Gampaha'] },
    { name: 'Kelaniya',                 district_id: d['Gampaha'] },
    { name: 'Negombo',                  district_id: d['Gampaha'] },
    { name: 'Wattala',                  district_id: d['Gampaha'] },

    // Kalutara District — 4 DS divisions
    { name: 'Horana',                   district_id: d['Kalutara'] },
    { name: 'Bandaragama',              district_id: d['Kalutara'] },
    { name: 'Ingiriya',                 district_id: d['Kalutara'] },
    { name: 'Panadura',                 district_id: d['Kalutara'] },

    // Kandy District — 4 DS divisions
    { name: 'Medadumbara',              district_id: d['Kandy'] },
    { name: 'Minipe',                   district_id: d['Kandy'] },
    { name: 'Thumpane',                 district_id: d['Kandy'] },
    { name: 'Udunuwara',                district_id: d['Kandy'] },

    // Galle District — 5 DS divisions
    { name: 'Ambalangoda',              district_id: d['Galle'] },
    { name: 'Baddegama',                district_id: d['Galle'] },
    { name: 'Balapitiya',               district_id: d['Galle'] },
    { name: 'Elpitiya',                 district_id: d['Galle'] },
    { name: 'Hikkaduwa',                district_id: d['Galle'] },

    // Matara District — 5 DS divisions
    { name: 'Devinuwara',               district_id: d['Matara'] },
    { name: 'Dickwella',                district_id: d['Matara'] },
    { name: 'Mulatiyana',               district_id: d['Matara'] },
    { name: 'Pitabeddara',              district_id: d['Matara'] },
    { name: 'Weligama',                 district_id: d['Matara'] },
  ])
}