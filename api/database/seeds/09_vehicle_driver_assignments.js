/**
 * Vehicle driver assignments seed
 * 205 active assignments — one driver per vehicle
 * 5 drivers remain unassigned (realistic — between jobs)
 * assigned_date set within last 6 months
 * returned_date is null — all assignments currently active
 */

export const seed = async function (knex) {
  await knex.raw('TRUNCATE TABLE vehicle_driver_assignments CASCADE')

  const vehicles = await knex('vehicles')
    .select('vehicle_id')
    .orderBy('created_at')

  const drivers = await knex('drivers')
    .select('driver_id')
    .orderBy('created_at')

  const assignments = []

  for (let i = 0; i < vehicles.length; i++) {
    const assignedDate = new Date()
    assignedDate.setDate(
      assignedDate.getDate() - Math.floor(Math.random() * 180)
    )

    assignments.push({
      vehicle_id:    vehicles[i].vehicle_id,
      driver_id:     drivers[i].driver_id,
      assigned_date: assignedDate.toISOString().split('T')[0],
      returned_date: null
    })
  }

  await knex('vehicle_driver_assignments').insert(assignments)

  console.log(`${assignments.length} vehicle driver assignments seeded`)
  console.log(`${drivers.length - vehicles.length} drivers unassigned`)
}