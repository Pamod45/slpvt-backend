/**
 * Refresh tokens table migration
 * Stores refresh tokens issued to authenticated users
 * Access tokens are stateless JWT — not stored here
 * Refresh tokens are stored so they can be revoked on logout
 * Cascade delete — if user is deleted all their tokens are removed
 */

export const up = function (knex) {
  return knex.schema.createTable('refresh_tokens', (table) => {
    table
      .uuid('token_id')
      .primary()
      .defaultTo(knex.raw('gen_random_uuid()'))

    table
      .uuid('user_id')
      .notNullable()
      .references('user_id')
      .inTable('users')
      .onDelete('CASCADE')
      .comment('User this token belongs to — cascade delete when user is removed')

    table
      .string('token_hash', 255)
      .notNullable()
      .unique()
      .comment('SHA-256 hash of the refresh token — raw token never stored')

    table
      .boolean('is_used')
      .notNullable()
      .defaultTo(false)
      .comment('True if this token has already been used — detects token reuse attacks')

    table
      .timestamp('expires_at')
      .notNullable()
      .comment('Expiry timestamp — tokens older than this are invalid regardless of is_used')

    table
      .timestamp('created_at')
      .notNullable()
      .defaultTo(knex.fn.now())
  })
}

export const down = function (knex) {
  return knex.schema.dropTableIfExists('refresh_tokens')
}