export const seed = async function (knex) {
  await knex('provinces').del()

  await knex('provinces').insert([
    { name: 'Western' },
    { name: 'Central' },
    { name: 'Southern' },
    { name: 'Northern' },
    { name: 'Eastern' },
    { name: 'North Western' },
    { name: 'North Central' },
    { name: 'Uva' },
    { name: 'Sabaragamuwa' }
  ])
}
