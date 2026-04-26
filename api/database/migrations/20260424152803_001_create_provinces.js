/**
 * Provinces table migration
 * Creates the top level administrative boundary table
 * Sri Lanka has 9 provinces - pre seeded after migrations
 */

export const up = function (knex) {
  return knex.schema.createTable('provinces', (table) => {
    table
      .uuid('province_id')
      .primary()
      .defaultTo(knex.raw('gen_random_uuid()'))

    table
      .string('name', 100)
      .notNullable()
      .unique()

    table
      .string('province_slug', 100)
      .notNullable()
      .unique()
      .defaultTo('')
      .comment('URL friendly identifier e.g. north-western')

    table.timestamps(true, true)
  })
}

export const down = function (knex) {
  return knex.schema.dropTableIfExists('provinces')
}

