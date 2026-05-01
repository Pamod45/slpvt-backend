/**
 * Drivers table migration
 * Represents tuk-tuk drivers pulled from DMT database
 * Drivers are linked to vehicles via vehicle_driver_assignments
 * Police status tracks law enforcement flags on the driver
 */

export const up = function (knex) {
  return knex.schema.createTable('drivers', (table) => {
    table
      .uuid('driver_id')
      .primary()
      .defaultTo(knex.raw('gen_random_uuid()'))

    table
      .string('driver_reference_id', 15)
      .notNullable()
      .unique()
      .comment('Official DMT reference ID for the driver, used for cross-referencing with DMT records')

    table
      .string('first_name', 100)
      .notNullable()

    table
      .string('last_name', 100)
      .notNullable()

    table
      .text('permanent_address')
      .notNullable()
      .comment('Full permanent address of the driver')

    table
      .string('driving_license_number', 50)
      .notNullable()
      .unique()
      .comment('Official driving license number issued by DMT')

    table
      .date('license_expiry_date')
      .notNullable()
      .comment('Driving license expiry date')

    table
      .enu('police_status', [
        'CLEAR',
        'WANTED',
        'SUSPENDED_LICENSE'
      ])
      .notNullable()
      .defaultTo('CLEAR')
      .comment('Current law enforcement status of the driver')

    table.timestamps(true, true)

    table
      .timestamp('deleted_at')
      .nullable()
      .defaultTo(null)
      .comment('Soft delete timestamp — null means active, set to deletion time when deactivated')
  })
}

export const down = function (knex) {
  return knex.schema.dropTableIfExists('drivers')
}