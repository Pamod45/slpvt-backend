/**
 * Stations table migration
 * Each station belongs to a district and has a type
 * Stations have a jurisdiction boundary polygon
 */

export const up = function (knex) {
  return knex.schema.createTable('stations', (table) => {
    table
      .uuid('station_id')
      .primary()
      .defaultTo(knex.raw('gen_random_uuid()'))

    table
      .enum('station_type', ['Police Post', "Division Office", 'Range Office', "Police Headquarters"])
      .notNullable()
      .comment('Type of station determines its role and jurisdiction scope')

    table
      .uuid('ds_division_id')
      .nullable()
      .references('ds_division_id')
      .inTable('divisional_secretariats')
      .onDelete('RESTRICT')
      .comment('DS division this station belongs to')

    table
      .uuid('district_id')
      .nullable()
      .references('district_id')
      .inTable('districts')
      .onDelete('RESTRICT')
      .comment('District this station belongs to')

    table
      .uuid('province_id')
      .nullable()
      .references('province_id')
      .inTable('provinces')
      .onDelete('RESTRICT')
      .comment('Province this district belongs to')

    table
      .string('name', 150)
      .notNullable()
      .unique()

    table
      .string('contact_number', 20)
      .nullable()

    table
      .string('short_code', 10)
      .notNullable()
      .unique()
      .comment('Short code for the station e.g. COL-001, KAN-001')

    table
      .decimal('latitude', 10, 7)
      .nullable()
      .comment('Station location latitude')

    table
      .decimal('longitude', 10, 7)
      .nullable()
      .comment('Station location longitude')

    table.timestamps(true, true)
  })
}

export const down = function (knex) {
  return knex.schema.dropTableIfExists('stations')
}