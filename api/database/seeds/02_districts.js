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
    { name: 'Colombo',       province_id: p['Western'] },
    { name: 'Gampaha',       province_id: p['Western'] },
    { name: 'Kalutara',      province_id: p['Western'] },

    { name: 'Kandy',         province_id: p['Central'] },
    { name: 'Matale',        province_id: p['Central'] },
    { name: 'Nuwara Eliya',  province_id: p['Central'] },

    { name: 'Galle',         province_id: p['Southern'] },
    { name: 'Matara',        province_id: p['Southern'] },
    { name: 'Hambantota',    province_id: p['Southern'] },

    { name: 'Jaffna',        province_id: p['Northern'] },
    { name: 'Kilinochchi',   province_id: p['Northern'] },
    { name: 'Mannar',        province_id: p['Northern'] },
    { name: 'Vavuniya',      province_id: p['Northern'] },
    { name: 'Mullaitivu',    province_id: p['Northern'] },

    { name: 'Trincomalee',   province_id: p['Eastern'] },
    { name: 'Batticaloa',    province_id: p['Eastern'] },
    { name: 'Ampara',        province_id: p['Eastern'] },

    { name: 'Kurunegala',    province_id: p['North Western'] },
    { name: 'Puttalam',      province_id: p['North Western'] },

    { name: 'Anuradhapura',  province_id: p['North Central'] },
    { name: 'Polonnaruwa',   province_id: p['North Central'] },

    { name: 'Badulla',       province_id: p['Uva'] },
    { name: 'Monaragala',    province_id: p['Uva'] },

    { name: 'Ratnapura',     province_id: p['Sabaragamuwa'] },
    { name: 'Kegalle',       province_id: p['Sabaragamuwa'] }
  ])
}