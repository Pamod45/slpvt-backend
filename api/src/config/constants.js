/**
 * Application constants
 * Roles, permissions, status enums, pagination defaults
 * Single source of truth for all fixed values used across the application
 */

// ─────────────────────────────────────────────
// SYSTEM ROLES
// ─────────────────────────────────────────────

export const ROLES = {
  SUPER_ADMIN:          'SUPER_ADMIN',
  PROVINCIAL_COMMANDER: 'PROVINCIAL_COMMANDER',
  PROVINCIAL_OFFICER:   'PROVINCIAL_OFFICER',
  DISTRICT_COMMANDER:   'DISTRICT_COMMANDER',
  DISTRICT_OFFICER:     'DISTRICT_OFFICER',
  STATION_COMMANDER:    'STATION_COMMANDER',
  STATION_OFFICER:      'STATION_OFFICER',
  DATA_REGISTRAR:       'DATA_REGISTRAR',
  DEVICE_CLIENT:        'DEVICE_CLIENT'
}

// ─────────────────────────────────────────────
// ROLE PERMISSIONS
// Commander = operational access + user management
// Officer   = operational access only
// ─────────────────────────────────────────────

export const ROLE_PERMISSIONS = {

  SUPER_ADMIN: ['*'],

  PROVINCIAL_COMMANDER: [
    'provinces:read',
    'districts:read',
    'divisional_secretariats:read',
    'stations:read',
    'vehicles:read',
    'vehicles:flag-stolen',
    'vehicles:clear-status',
    'vehicles:location:read',
    'vehicles:history:read',
    'drivers:read',
    'drivers:update-status',
    'locations:area-read',
    'devices:read',
    'devices:create',
    'devices:update',
    'users:read',
    'users:create',
    'users:update',
    'users:delete'
  ],

  PROVINCIAL_OFFICER: [
    'provinces:read',
    'districts:read',
    'divisional_secretariats:read',
    'stations:read',
    'vehicles:read',
    'vehicles:flag-stolen',
    'vehicles:clear-status',
    'vehicles:location:read',
    'vehicles:history:read',
    'drivers:read',
    'drivers:update-status',
    'locations:area-read',
    'devices:read',
    'devices:create',
    'devices:update'
  ],

  DISTRICT_COMMANDER: [
    'provinces:read',
    'districts:read',
    'divisional_secretariats:read',
    'stations:read',
    'vehicles:read',
    'vehicles:flag-stolen',
    'vehicles:clear-status',
    'vehicles:location:read',
    'vehicles:history:read',
    'drivers:read',
    'drivers:update-status',
    'locations:area-read',
    'users:read',
    'users:update',
    'users:delete'
  ],

  DISTRICT_OFFICER: [
    'provinces:read',
    'districts:read',
    'divisional_secretariats:read',
    'stations:read',
    'vehicles:read',
    'vehicles:flag-stolen',
    'vehicles:clear-status',
    'vehicles:location:read',
    'vehicles:history:read',
    'drivers:read',
    'drivers:update-status',
    'locations:area-read'
  ],

  STATION_COMMANDER: [
    'provinces:read',
    'districts:read',
    'divisional_secretariats:read',
    'stations:read',
    'vehicles:read',
    'vehicles:flag-stolen',
    'vehicles:clear-status',
    'vehicles:location:read',
    'vehicles:history:read',
    'drivers:read',
    'drivers:update-status',
    'locations:area-read',
    'users:read',
    'users:update',
    'users:delete'
  ],

  STATION_OFFICER: [
    'provinces:read',
    'districts:read',
    'divisional_secretariats:read',
    'stations:read',
    'vehicles:read',
    'vehicles:flag-stolen',
    'vehicles:clear-status',
    'vehicles:location:read',
    'vehicles:history:read',
    'drivers:read',
    'drivers:update-status',
    'locations:area-read'
  ],

  DATA_REGISTRAR: [
    'vehicles:create',
    'vehicles:update',
    'drivers:create',
    'drivers:update',
    'assignments:create',
    'assignments:update'
  ],

  DEVICE_CLIENT: [
    'locations:ping'
  ]
}

// ─────────────────────────────────────────────
// ROLE CREATION CEILING
// defines which roles each role is allowed to create
// ─────────────────────────────────────────────

export const ROLE_CREATION_CEILING = {
  SUPER_ADMIN: [
    'SUPER_ADMIN',
    'PROVINCIAL_COMMANDER',
    'PROVINCIAL_OFFICER',
    'DISTRICT_COMMANDER',
    'DISTRICT_OFFICER',
    'STATION_COMMANDER',
    'STATION_OFFICER',
    'DATA_REGISTRAR'
  ],
  PROVINCIAL_COMMANDER: [
    'PROVINCIAL_OFFICER',
    'DISTRICT_COMMANDER',
    'DISTRICT_OFFICER',
    'STATION_COMMANDER',
    'STATION_OFFICER'
  ],
  DISTRICT_COMMANDER: [
    'DISTRICT_OFFICER',
    'STATION_COMMANDER',
    'STATION_OFFICER'
  ],
  STATION_COMMANDER: [
    'STATION_OFFICER'
  ]
}

// ─────────────────────────────────────────────
// SCOPE TYPES
// maps directly to station hierarchy
// ─────────────────────────────────────────────

export const SCOPE_TYPES = {
  COUNTRY:    'country',    // Police Headquarters
  PROVINCE:   'province',   // Range Office
  DISTRICT:   'district',   // Division Office
  DIVISIONAL: 'divisional', // Police Post
  NONE:       'none'        // DATA_REGISTRAR, DEVICE_CLIENT
}

// ─────────────────────────────────────────────
// SCOPE TO STATION TYPE MAPPING
// ─────────────────────────────────────────────

export const SCOPE_TO_STATION_TYPE = {
  country:    'Police Headquarters',
  province:   'Range Office',
  district:   'Division Office',
  divisional: 'Police Post'
}

// ─────────────────────────────────────────────
// ROLE TO SCOPE MAPPING
// automatically determines scope from role
// ─────────────────────────────────────────────

export const ROLE_SCOPE = {
  SUPER_ADMIN:          'country',
  PROVINCIAL_COMMANDER: 'province',
  PROVINCIAL_OFFICER:   'province',
  DISTRICT_COMMANDER:   'district',
  DISTRICT_OFFICER:     'district',
  STATION_COMMANDER:    'divisional',
  STATION_OFFICER:      'divisional',
  DATA_REGISTRAR:       'none',
  DEVICE_CLIENT:        'none'
}

// ─────────────────────────────────────────────
// STATION TYPES
// ─────────────────────────────────────────────

export const STATION_TYPES = {
  POLICE_HEADQUARTERS: 'Police Headquarters',
  RANGE_OFFICE:        'Range Office',
  DIVISION_OFFICE:     'Division Office',
  POLICE_POST:         'Police Post'
}

// ─────────────────────────────────────────────
// VEHICLE STATUSES
// ─────────────────────────────────────────────

export const VEHICLE_POLICE_STATUS = {
  CLEAN:     'CLEAN',
  STOLEN:    'STOLEN',
  WANTED:    'WANTED',
  SUSPENDED: 'SUSPENDED'
}

// ─────────────────────────────────────────────
// DRIVER STATUSES
// ─────────────────────────────────────────────

export const DRIVER_POLICE_STATUS = {
  CLEAR:             'CLEAR',
  WANTED:            'WANTED',
  SUSPENDED_LICENSE: 'SUSPENDED_LICENSE'
}

// ─────────────────────────────────────────────
// DEVICE STATUSES
// ─────────────────────────────────────────────

export const DEVICE_ADMIN_STATUS = {
  ACTIVE:         'ACTIVE',
  UNDER_REPAIR:   'UNDER_REPAIR',
  DECOMMISSIONED: 'DECOMMISSIONED'
}

// ─────────────────────────────────────────────
// PAGINATION
// ─────────────────────────────────────────────

export const PAGINATION = {
  DEFAULT_LIMIT:       20,
  MAX_LIMIT:           100,
  MAX_LIMIT_LOCATIONS: 500,
  DEFAULT_OFFSET:      0
}

// ─────────────────────────────────────────────
// TIME WINDOW LIMITS
// prevents unbounded location queries
// officers must query in chunks of max 30 days
// ─────────────────────────────────────────────

export const TIME_WINDOW = {
  MAX_DAYS_LOCATIONS: 30,
  MAX_DAYS_HISTORY:   30
}

// ─────────────────────────────────────────────
// JWT CONFIG
// ─────────────────────────────────────────────

export const JWT = {
  ACCESS_TOKEN_EXPIRY:  '15m',
  REFRESH_TOKEN_EXPIRY: '7d'
}

// ─────────────────────────────────────────────
// BCRYPT
// ─────────────────────────────────────────────

export const BCRYPT_ROUNDS = 12

// ─────────────────────────────────────────────
// DEVICE API KEY
// ─────────────────────────────────────────────

export const DEVICE_KEY = {
  BYTE_LENGTH: 32,
  HASH_ALGO:   'sha256'
}