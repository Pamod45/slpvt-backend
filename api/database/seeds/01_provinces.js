export const seed = async function (knex) {
  await knex.raw('TRUNCATE TABLE provinces CASCADE')

  await knex('provinces').insert([
  { name: 'Western',       province_slug: 'western'       },
  { name: 'Central',       province_slug: 'central'       },
  { name: 'Southern',      province_slug: 'southern'      },
  { name: 'Northern',      province_slug: 'northern'      },
  { name: 'Eastern',       province_slug: 'eastern'       },
  { name: 'North Western', province_slug: 'north-western' },
  { name: 'North Central', province_slug: 'north-central' },
  { name: 'Uva',           province_slug: 'uva'           },
  { name: 'Sabaragamuwa',  province_slug: 'sabaragamuwa'  }
])
}
