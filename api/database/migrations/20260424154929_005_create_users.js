/**
 * Users table migration
 * Represents all system users including police officers and admin accounts
 * Role determines access level and jurisdiction scope
 * Soft delete via is_active flag - records never physically deleted
 */

export const up = function (knex) {
  return knex.schema.createTable('users', (table) => {
    table
      .uuid('user_id')
      .primary()
      .defaultTo(knex.raw('gen_random_uuid()'))

    table
      .string('badge_number', 50)
      .notNullable()
      .unique()
      .comment('Unique police badge number — used as login identifier')

    table
      .string('password_hash', 255)
      .notNullable()
      .comment('bcrypt hashed password — plain text never stored')

    table
      .string('first_name', 100)
      .notNullable()

    table
      .string('last_name', 100)
      .notNullable()

    table
      .uuid('assigned_station_id')
      .nullable()
      .references('station_id')
      .inTable('stations')
      .onDelete('RESTRICT')
      .comment('Populated for station level roles')

    table
      .enu('system_role', [
        'SUPER_ADMIN',
        'PROVINCIAL_COMMANDER',
        'PROVINCIAL_OFFICER',
        'DISTRICT_COMMANDER',
        'DISTRICT_OFFICER',
        'STATION_COMMANDER',
        'STATION_OFFICER',
        'DATA_REGISTRAR',
        'DEVICE_CLIENT'
      ])
      .notNullable()
      .comment('Determines access level and jurisdiction scope')

    table
      .timestamp('deleted_at')
      .nullable()
      .defaultTo(null)
      .comment('Soft delete timestamp — null means active, set to deletion time when deactivated')

    table.timestamps(true, true)
  })
}

export const down = function (knex) {
  return knex.schema.dropTableIfExists('users')
}