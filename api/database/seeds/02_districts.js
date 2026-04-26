/**
 * Districts seed
 * All 25 districts of Sri Lanka mapped to their provinces
 */

export const seed = async function (knex) {
  await knex('districts').del()

  const provinces = await knex('provinces')
    .select('province_id', 'name')

  const p = {}
  provinces.forEach(province => {
    p[province.name] = province.province_id
  })

  await knex('districts').insert([
    { name: 'Colombo',       province_id: p['Western'], district_slug: 'colombo' },
    { name: 'Gampaha',       province_id: p['Western'], district_slug: 'gampaha' },
    { name: 'Kalutara',      province_id: p['Western'], district_slug: 'kalutara' },

    { name: 'Kandy',         province_id: p['Central'], district_slug: 'kandy' },
    { name: 'Matale',        province_id: p['Central'], district_slug: 'matale' },
    { name: 'Nuwara Eliya',  province_id: p['Central'], district_slug: 'nuwara-eliya' },

    { name: 'Galle',         province_id: p['Southern'], district_slug: 'galle' },
    { name: 'Matara',        province_id: p['Southern'], district_slug: 'matara' },
    { name: 'Hambantota',    province_id: p['Southern'], district_slug: 'hambantota' },

    { name: 'Jaffna',        province_id: p['Northern'], district_slug: 'jaffna' },
    { name: 'Kilinochchi',   province_id: p['Northern'], district_slug: 'kilinochchi' },
    { name: 'Mannar',        province_id: p['Northern'], district_slug: 'mannar' },
    { name: 'Vavuniya',      province_id: p['Northern'], district_slug: 'vavuniya' },
    { name: 'Mullaitivu',    province_id: p['Northern'], district_slug: 'mullaitivu' },

    { name: 'Trincomalee',   province_id: p['Eastern'], district_slug: 'trincomalee' },
    { name: 'Batticaloa',    province_id: p['Eastern'], district_slug: 'batticaloa' },
    { name: 'Ampara',        province_id: p['Eastern'], district_slug: 'ampara' },

    { name: 'Kurunegala',    province_id: p['North Western'], district_slug: 'kurunegala' },
    { name: 'Puttalam',      province_id: p['North Western'], district_slug: 'puttalam' },

    { name: 'Anuradhapura',  province_id: p['North Central'], district_slug: 'anuradhapura' },
    { name: 'Polonnaruwa',   province_id: p['North Central'], district_slug: 'polonnaruwa' },

    { name: 'Badulla',       province_id: p['Uva'], district_slug: 'badulla' },
    { name: 'Monaragala',    province_id: p['Uva'], district_slug: 'monaragala' },

    { name: 'Ratnapura',     province_id: p['Sabaragamuwa'], district_slug: 'ratnapura' },
    { name: 'Kegalle',       province_id: p['Sabaragamuwa'], district_slug: 'kegalle' }
  ])
}