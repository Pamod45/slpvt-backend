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
    { name: 'Colombo',                  district_id: d['Colombo'], ds_division_slug: 'colombo' },
    { name: 'Dehiwala-MountLavinia',    district_id: d['Colombo'], ds_division_slug: 'dehiwala-mountlavinia' },
    { name: 'Homagama',                 district_id: d['Colombo'], ds_division_slug: 'homagama' },
    { name: 'Kaduwela',                 district_id: d['Colombo'], ds_division_slug: 'kaduwela' },
    { name: 'Kesbewa',                  district_id: d['Colombo'], ds_division_slug: 'kesbewa' },
    { name: 'SriJayawardanapuraKotte',  district_id: d['Colombo'], ds_division_slug: 'st-jayawardanapura-kotte' },
    { name: 'Thimbirigasyaya',          district_id: d['Colombo'], ds_division_slug: 'thimbirigasyaya' },

    // Gampaha District — 4 DS divisions
    { name: 'Ja-Ela',                   district_id: d['Gampaha'], ds_division_slug: 'ja-ela' },
    { name: 'Kelaniya',                 district_id: d['Gampaha'], ds_division_slug: 'kelaniya' },
    { name: 'Negombo',                  district_id: d['Gampaha'], ds_division_slug: 'negombo' },
    { name: 'Wattala',                  district_id: d['Gampaha'], ds_division_slug: 'wattala' },

    // Kalutara District — 4 DS divisions
    { name: 'Horana',                   district_id: d['Kalutara'], ds_division_slug: 'horana' },
    { name: 'Bandaragama',              district_id: d['Kalutara'], ds_division_slug: 'bandaragama' },
    { name: 'Ingiriya',                 district_id: d['Kalutara'], ds_division_slug: 'ingiriya' },
    { name: 'Panadura',                 district_id: d['Kalutara'], ds_division_slug: 'panadura' },

    // Kandy District — 4 DS divisions
    { name: 'Medadumbara',              district_id: d['Kandy'], ds_division_slug: 'medadumbara' },
    { name: 'Minipe',                   district_id: d['Kandy'], ds_division_slug: 'minipe' },
    { name: 'Thumpane',                 district_id: d['Kandy'], ds_division_slug: 'thumpane' },
    { name: 'Udunuwara',                district_id: d['Kandy'], ds_division_slug: 'udunuwara' },

    // Galle District — 5 DS divisions
    { name: 'Ambalangoda',              district_id: d['Galle'], ds_division_slug: 'ambalangoda' },
    { name: 'Baddegama',                district_id: d['Galle'], ds_division_slug: 'baddegama' },
    { name: 'Balapitiya',               district_id: d['Galle'], ds_division_slug: 'balapitiya' },
    { name: 'Elpitiya',                 district_id: d['Galle'], ds_division_slug: 'elpitiya' },
    { name: 'Hikkaduwa',                district_id: d['Galle'], ds_division_slug: 'hikkaduwa' },

    // Matara District — 5 DS divisions
    { name: 'Devinuwara',               district_id: d['Matara'], ds_division_slug: 'devinuwara' },
    { name: 'Dickwella',                district_id: d['Matara'], ds_division_slug: 'dickwella' },
    { name: 'Mulatiyana',               district_id: d['Matara'], ds_division_slug: 'mulatiyana' },
    { name: 'Pitabeddara',              district_id: d['Matara'], ds_division_slug: 'pitabeddara' },
    { name: 'Weligama',                 district_id: d['Matara'], ds_division_slug: 'weligama' },
  ])
}