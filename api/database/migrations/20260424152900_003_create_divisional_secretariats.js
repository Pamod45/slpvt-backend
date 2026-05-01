export const up = function (knex) {
  return knex.schema.createTable('divisional_secretariats', (table) => {
    table
      .uuid('ds_division_id')
      .primary()
      .defaultTo(knex.raw('gen_random_uuid()'))

    table
      .uuid('district_id')
      .notNullable()
      .references('district_id')
      .inTable('districts')
      .onDelete('RESTRICT')
      .comment('District this DS division belongs to')

    table
      .string('name', 100)
      .notNullable()
      .unique()

    table
      .string('ds_division_slug', 100)
      .notNullable()
      .unique()
      .defaultTo('')
      .comment('URL friendly identifier`')

    table.timestamps(true, true)
  })
}

export const down = function (knex) {
  return knex.schema.dropTableIfExists('divisional_secretariats')
}