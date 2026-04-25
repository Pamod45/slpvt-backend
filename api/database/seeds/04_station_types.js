/**
 * Station types seed
 * Four types representing the Sri Lanka Police hierarchy levels
 * Police Headquarters → Range Office → Main Station → Police Post
 */

export const seed = async function (knex) {
  await knex('station_types').del()

  await knex('station_types').insert([
    { type_name: 'Police Headquarters' },
    { type_name: 'Range Office' },
    { type_name: 'Main Station' },
    { type_name: 'Police Post' }
  ])
}