/**
 * Districts table migration
 * Each district belongs to a province
 * Sri Lanka has 25 districts across 9 provinces
 */

export const up = function (knex) {
  return knex.schema.createTable('districts', (table) => {
    table
      .uuid('district_id')
      .primary()
      .defaultTo(knex.raw('gen_random_uuid()'))

    table
      .uuid('province_id')
      .notNullable()
      .references('province_id')
      .inTable('provinces')
      .onDelete('RESTRICT')
      .comment('Province this district belongs to')

    table
      .string('name', 100)
      .notNullable()
      .unique()

    table
      .string('district_slug', 100)
      .notNullable()
      .unique()
      .defaultTo('')
      .comment('URL friendly identifier e.g. colombo')

    table.timestamps(true, true)
  })
}

export const down = function (knex) {
  return knex.schema.dropTableIfExists('districts')
}
