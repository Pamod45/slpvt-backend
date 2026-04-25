/**
 * Tracking devices table migration
 * Represents GPS tracking units installed in tuk-tuks
 * Each device is issued an API key at provisioning time
 * API key is hashed and stored — raw key returned only once at creation
 */

export const up = function (knex) {
  return knex.schema.createTable('tracking_devices', (table) => {
    table
      .uuid('device_id')
      .primary()
      .defaultTo(knex.raw('gen_random_uuid()'))

    table
      .string('serial_number', 100)
      .notNullable()
      .unique()
      .comment('Physical serial number printed on the device hardware')

    table
      .string('api_key_hash', 255)
      .notNullable()
      .unique()
      .comment('SHA-256 hash of the device API key — raw key never stored')

    table
      .date('issued_date')
      .notNullable()
      .comment('Date the device was provisioned and issued')

    table
      .enu('admin_status', [
        'ACTIVE',
        'UNDER_REPAIR',
        'DECOMMISSIONED'
      ])
      .notNullable()
      .defaultTo('ACTIVE')
      .comment('Operational status of the device')

    table.timestamps(true, true)
  })
}

export const down = function (knex) {
  return knex.schema.dropTableIfExists('tracking_devices')
}