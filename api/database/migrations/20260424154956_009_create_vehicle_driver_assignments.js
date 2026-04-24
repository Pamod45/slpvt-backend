/**
 * Vehicle driver assignments table migration
 * Junction table linking vehicles to drivers over time
 * One vehicle can have many drivers over time
 * One driver can drive many vehicles over time
 * Active assignment is the row where returned_date is null
 */

export const up = function (knex) {
  return knex.schema.createTable('vehicle_driver_assignments', (table) => {
    table
      .uuid('assignment_id')
      .primary()
      .defaultTo(knex.raw('gen_random_uuid()'))

    table
      .uuid('vehicle_id')
      .notNullable()
      .references('vehicle_id')
      .inTable('vehicles')
      .onDelete('RESTRICT')
      .comment('Vehicle being assigned')

    table
      .uuid('driver_id')
      .notNullable()
      .references('driver_id')
      .inTable('drivers')
      .onDelete('RESTRICT')
      .comment('Driver being assigned to the vehicle')

    table
      .date('assigned_date')
      .notNullable()
      .comment('Date the driver was assigned to the vehicle')

    table
      .date('returned_date')
      .nullable()
      .comment('Date the driver returned the vehicle — null means currently active assignment')

    table
      .timestamp('created_at')
      .notNullable()
      .defaultTo(knex.fn.now())
  })
}

export const down = function (knex) {
  return knex.schema.dropTableIfExists('vehicle_driver_assignments')
}