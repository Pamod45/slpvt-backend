/**
 * Replace full unique constraints on stations.short_code and stations.name
 * with partial unique indexes that exclude soft-deleted rows.
 * This allows a deleted station's short_code or name to be reused.
 */

export const up = async (knex) => {
  await knex.schema.table('stations', (table) => {
    table.dropUnique(['short_code'])
    table.dropUnique(['name'])
  })

  await knex.raw(`
    CREATE UNIQUE INDEX stations_short_code_active_unique
    ON stations (short_code)
    WHERE deleted_at IS NULL
  `)

  await knex.raw(`
    CREATE UNIQUE INDEX stations_name_active_unique
    ON stations (name)
    WHERE deleted_at IS NULL
  `)
}

export const down = async (knex) => {
  await knex.raw(`DROP INDEX IF EXISTS stations_short_code_active_unique`)
  await knex.raw(`DROP INDEX IF EXISTS stations_name_active_unique`)

  await knex.schema.table('stations', (table) => {
    table.unique(['short_code'])
    table.unique(['name'])
  })
}
