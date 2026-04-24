/**
 * Station types table migration
 * Lookup table for classifying police stations
 * Three types: Main Station, Police Post, Range Office
 */

export const up = function (knex) {
  return knex.schema.createTable('station_types', (table) => {
    table
      .uuid('station_type_id')
      .primary()
      .defaultTo(knex.raw('gen_random_uuid()'))

    table
      .string('type_name', 100)
      .notNullable()
      .unique()
      .comment('Main Station, Police Post, Range Office')

    table.timestamps(true, true)
  })
}

export const down = function (knex) {
  return knex.schema.dropTableIfExists('station_types')
}