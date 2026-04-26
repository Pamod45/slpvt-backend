/**
 * Vehicles table migration
 * Represents registered tuk-tuks pulled from DMT database
 * Each vehicle can have one tracking device installed
 * Police status tracks law enforcement flags on the vehicle
 * Geographic registration fields enable jurisdiction-based filtering
 */

export const up = function (knex) {
  return knex.schema.createTable('vehicles', (table) => {
    table
      .uuid('vehicle_id')
      .primary()
      .defaultTo(knex.raw('gen_random_uuid()'))

    table
      .string('vehicle_reference_id', 15)
      .notNullable()
      .unique()
      .comment('Official DMT reference ID for the vehicle, used for cross-referencing with DMT records')

    table
      .string('registration_number', 20)
      .notNullable()
      .unique()
      .comment('Official DMT registration number e.g. WP CAB-1234')

    table
      .string('chassis_number', 50)
      .notNullable()
      .unique()
      .comment('Vehicle chassis number from manufacturer')

    table
      .string('color', 50)
      .notNullable()

    table
      .string('make_model', 100)
      .notNullable()
      .comment('e.g. Bajaj RE, TVS King')

    table
      .uuid('device_id')
      .nullable()
      .references('device_id')
      .inTable('tracking_devices')
      .onDelete('SET NULL')
      .comment('Tracking device installed in this vehicle — nullable if no device assigned')

    table
      .enu('police_status', [
        'CLEAN',
        'STOLEN',
        'WANTED',
        'SUSPENDED'
      ])
      .notNullable()
      .defaultTo('CLEAN')
      .comment('Current law enforcement status of the vehicle')

    table
      .string('owner_nic', 20)
      .notNullable()
      .comment('Owner National Identity Card number — Sri Lankan NIC format')

    table
      .string('owner_full_name', 200)
      .notNullable()

    table
      .string('owner_contact', 20)
      .nullable()
      .comment('Owner contact number in +94XXXXXXXXX format')

    table
      .uuid('ds_division_id')
      .notNullable()
      .references('ds_division_id')
      .inTable('divisional_secretariats')
      .onDelete('RESTRICT')
      .comment('DS division this station belongs to')

    table.timestamps(true, true)
  })
}

export const down = function (knex) {
  return knex.schema.dropTableIfExists('vehicles')
}