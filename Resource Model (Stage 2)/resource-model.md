# Resource Model — Sri Lanka Police Vehicle Tracking System

## 1. Conventions

This API follows the WSO2 REST API Design Guidelines and the Richardson Maturity Model (Level 2).

### 1.1 Base URI

```
https://{host}/api/v1
```

### 1.2 Naming Rules

| Rule | Example |
|------|---------|
| Collections use plural nouns | `/vehicles`, `/drivers`, `/stations` |
| Atomic resources use singular path param | `/vehicles/:vehicle-id` |
| Multi-word resources use dashes, never underscores | `/station-types`, `/mark-stolen` |
| Controller / processing function resources use verbs | `/login`, `/mark-stolen`, `/ping` |
| All characters lowercase | `/api/v1/station-types` |

### 1.3 Versioning

Version is embedded in the base path as `v{major}`. Minor and patch versions are internal and do not change the URI. When a breaking change is released, the version increments to `v2` and `v1` is supported for a minimum of one major version back.

```
/api/v1/...   ← current
/api/v2/...   ← future breaking change
```

If a client calls a deprecated version, the server responds:

```
HTTP/1.1 301 Moved Permanently
Location: https://{host}/api/v2/{resource}
```

### 1.4 Authentication

Two separate authentication schemes are used depending on the client type.

| Client Type | Scheme | Header |
|-------------|--------|--------|
| Police officers / admin users | JWT Bearer | `Authorization: Bearer <access_token>` |
| Tracking devices | API Key | `X-Device-Key: <api_key>` |

Devices do not use JWT. They are issued a static API key at the time of provisioning, stored as a hash in the database. Only the `/api/v1/locations/ping` endpoint accepts the `X-Device-Key` header.

### 1.5 Standard Request Headers

| Header | Usage |
|--------|-------|
| `Authorization` | Bearer JWT or device API key (see above) |
| `Content-Type` | `application/json` on all POST and PUT requests |
| `Accept` | `application/json` — server returns 406 if unsupported type requested |
| `If-None-Match` | Conditional GET — client sends previously received ETag value |
| `If-Modified-Since` | Conditional GET — client sends previously received Last-Modified value |
| `If-Match` | Conditional PUT — optimistic concurrency, prevents lost updates |
| `If-Unmodified-Since` | Conditional PUT — alternative concurrency check |

### 1.6 Standard Response Headers

| Header | Usage |
|--------|-------|
| `Content-Type` | `application/json` |
| `ETag` | Fingerprint of the resource (e.g. hash of the record). Returned on GET responses for atomic resources |
| `Last-Modified` | Timestamp of the last modification. Returned on GET responses for atomic resources |
| `Location` | URI of newly created resource. Returned on successful POST (201 Created) |
| `Content-Location` | URI of the resource in the response body |
| `WWW-Authenticate` | Returned with 401 responses to indicate required auth scheme |
| `X-Total-Count` | Total number of records matching a query (used with paginated responses) |
| `X-Request-ID` | Echo of the request correlation ID for traceability |

### 1.7 Pagination

All collection GET endpoints support pagination via query string.

```
GET /api/v1/vehicles?offset=0&limit=20
```

Paginated response envelope:

```json
{
  "count": 214,
  "offset": 0,
  "limit": 20,
  "next": "/api/v1/vehicles?offset=20&limit=20",
  "previous": null,
  "data": [ ... ]
}
```

### 1.8 Filtering and Sorting

Filtering is done via query string parameters on collection endpoints. Sorting is specified with `sort_by` and `order` parameters.

```
GET /api/v1/vehicles?police_status=STOLEN&sort_by=registration_number&order=asc
```

| Param | Type | Description |
|-------|------|-------------|
| `sort_by` | string | Field name to sort by |
| `order` | `asc` \| `desc` | Sort direction. Default: `asc` |
| `offset` | integer | Start position. Default: `0` |
| `limit` | integer | Max records to return. Default: `20`, Max: `100` |

### 1.9 Conditional GET (Client-Side Caching)

Atomic resource GET responses include `ETag` and `Last-Modified` headers. Clients can use these on subsequent requests to avoid re-fetching unchanged resources.

```
GET /api/v1/vehicles/abc-123
If-None-Match: "d4f2a91bc3e77"
If-Modified-Since: Mon, 14 Apr 2025 08:30:00 GMT
```

If the resource has not changed, the server responds with `304 Not Modified` and an empty body.

### 1.10 Conditional PUT (Concurrency Control)

To prevent lost updates when multiple clients edit the same resource, PUT requests on atomic resources must include the `If-Match` header with the current ETag.

```
PUT /api/v1/vehicles/abc-123
If-Match: "d4f2a91bc3e77"
Content-Type: application/json
```

If the resource has been modified by another client since the ETag was issued, the server responds with `412 Precondition Failed`.

### 1.11 Error Response Format

All `4xx` responses return a structured error body per WSO2 error reporting guidelines.

```json
{
  "code": 400,
  "message": "Validation failed",
  "description": "One or more fields in the request are invalid",
  "errors": [
    {
      "code": 4001,
      "message": "registration_number is required"
    },
    {
      "code": 4002,
      "message": "owner_nic must be a valid Sri Lankan NIC format"
    }
  ]
}
```

### 1.12 HTTP Status Codes Used

| Code | Meaning | When used |
|------|---------|-----------|
| `200 OK` | Success | GET, PUT succeeded |
| `201 Created` | Resource created | POST succeeded — includes `Location` header |
| `204 No Content` | Success, no body | DELETE succeeded |
| `304 Not Modified` | Unchanged | Conditional GET, resource not changed since cached version |
| `400 Bad Request` | Invalid input | Validation errors, malformed body |
| `401 Unauthorized` | Auth required | Missing or invalid token / API key |
| `403 Forbidden` | Insufficient role | Valid token but role lacks permission |
| `404 Not Found` | Does not exist | Resource not found at URI |
| `406 Not Acceptable` | Unsupported media type | Client `Accept` header not supported |
| `409 Conflict` | Duplicate | Registration number, badge number, serial number already exists |
| `412 Precondition Failed` | Concurrency conflict | `If-Match` or `If-Unmodified-Since` check failed |
| `415 Unsupported Media Type` | Wrong content type | Request body not `application/json` |
| `422 Unprocessable Entity` | Business rule violation | Device already assigned to another vehicle |
| `500 Internal Server Error` | Server fault | Unhandled server-side error |

### 1.13 Role Hierarchy

| Role | Scope | Code |
|------|-------|------|
| Tracking Device | Device-level ping only | `DEVICE_CLIENT` |
| Police Officer | Station jurisdiction | `STATION_OFFICER` |
| Station Commander | Station-level + user management | `STATION_COMMANDER` |
| District Commander | District-level + user management | `DISTRICT_COMMANDER` |
| Provincial Officer | Device management (insert/edit) | `PROVINCIAL_OFFICER` |
| Provincial Commander | Provincial-level + user management | `PROVINCIAL_COMMANDER` |
| Headquarters Commander | Country-level, all access | `SUPER_ADMIN` |
| DMT Data Registrar | Vehicle and driver data entry | `DATA_REGISTRAR` |

---

## 2. Resource Groups

---

### 2.1 Auth

Processing function resources (named as verbs per WSO2 5.1). No resource ID in path.

---

#### `POST /api/v1/auth/login`

Authenticates a user and returns a JWT access token and refresh token.

**Access:** All roles (public endpoint — no auth required)

**Request Headers:**
```
Content-Type: application/json
```

**Request Body:**
```json
{
  "badge_number": "SLP-00123",
  "password": "secret"
}
```

**Response `200 OK`:**
```json
{
  "access_token": "eyJ...",
  "refresh_token": "dGhp...",
  "expires_in": 900,
  "token_type": "Bearer",
  "role": "STATION_OFFICER"
}
```

**Error Responses:** `400`, `401`

---

#### `POST /api/v1/auth/refresh`

Issues a new access token using a valid refresh token.

**Access:** All authenticated roles

**Request Body:**
```json
{
  "refresh_token": "dGhp..."
}
```

**Response `200 OK`:**
```json
{
  "access_token": "eyJ...",
  "expires_in": 900
}
```

**Error Responses:** `400`, `401`

---

#### `POST /api/v1/auth/logout`

Invalidates the current refresh token.

**Access:** All authenticated roles

**Request Headers:**
```
Authorization: Bearer <access_token>
```

**Response `204 No Content`**

**Error Responses:** `401`

---

### 2.2 Provinces

Administrative boundary resource. Pre-seeded with all 9 Sri Lanka provinces. Read access is open to all authenticated roles. Write access is restricted to `SUPER_ADMIN`.

---

#### `GET /api/v1/provinces`

Returns all provinces.

**Access:** All authenticated roles

**Request Headers:**
```
Authorization: Bearer <access_token>
Accept: application/json
```

**Query Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `offset` | integer | Pagination offset. Default: `0` |
| `limit` | integer | Page size. Default: `20` |
| `sort_by` | string | `name`. Default: `name` |
| `order` | string | `asc` \| `desc`. Default: `asc` |

**Response `200 OK`:**
```json
{
  "count": 9,
  "offset": 0,
  "limit": 20,
  "next": null,
  "previous": null,
  "data": [
    {
      "province_id": "uuid",
      "name": "Western Province",
      "boundary_polygon": "POLYGON(...)"
    }
  ]
}
```

**Response Headers:**
```
Content-Type: application/json
X-Total-Count: 9
```

---

#### `POST /api/v1/provinces`

Creates a new province.

**Access:** `SUPER_ADMIN`

**Request Headers:**
```
Authorization: Bearer <access_token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "Northern Province",
  "boundary_polygon": "POLYGON(...)"
}
```

**Response `201 Created`:**
```
Location: /api/v1/provinces/{province-id}
Content-Location: /api/v1/provinces/{province-id}
ETag: "a3f7c12d9e"
Last-Modified: Tue, 15 Apr 2025 10:00:00 GMT
```

```json
{
  "province_id": "uuid",
  "name": "Northern Province",
  "boundary_polygon": "POLYGON(...)"
}
```

**Error Responses:** `400`, `401`, `403`, `409`

---

#### `GET /api/v1/provinces/:province-id`

Returns a single province by ID.

**Access:** All authenticated roles

**Request Headers:**
```
Authorization: Bearer <access_token>
Accept: application/json
If-None-Match: "a3f7c12d9e"
If-Modified-Since: Tue, 15 Apr 2025 10:00:00 GMT
```

**Response `200 OK`:**
```
ETag: "a3f7c12d9e"
Last-Modified: Tue, 15 Apr 2025 10:00:00 GMT
```

**Response `304 Not Modified`** (if ETag matches — empty body)

**Error Responses:** `401`, `404`

---

#### `PUT /api/v1/provinces/:province-id`

Fully replaces a province record.

**Access:** `SUPER_ADMIN`

**Request Headers:**
```
Authorization: Bearer <access_token>
Content-Type: application/json
If-Match: "a3f7c12d9e"
```

**Response `200 OK`** or **`412 Precondition Failed`** (if ETag mismatch)

**Error Responses:** `400`, `401`, `403`, `404`, `412`

---

#### `GET /api/v1/provinces/:province-id/districts`

Returns all districts belonging to a province.

**Access:** All authenticated roles

**Request Headers:**
```
Authorization: Bearer <access_token>
Accept: application/json
```

**Response `200 OK`:** Array of district objects.

---

#### `GET /api/v1/provinces/:province-id/stations`

Returns all stations within a province.

**Access:** `PROVINCIAL_COMMANDER`, `SUPER_ADMIN`

**Query Parameters:** `offset`, `limit`, `sort_by`, `order`

**Response `200 OK`:** Paginated array of station objects.

---

### 2.3 Districts

Pre-seeded with all 25 Sri Lanka districts. Each district belongs to a province.

---

#### `GET /api/v1/districts`

Returns all districts. Role-scoped: officers below provincial level only see their assigned district.

**Access:** All authenticated roles

**Query Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `province_id` | uuid | Filter by province |
| `sort_by` | string | `name`. Default: `name` |
| `order` | string | `asc` \| `desc` |
| `offset` | integer | Default: `0` |
| `limit` | integer | Default: `25` |

**Response `200 OK`:** Paginated array of district objects.

**Response Headers:**
```
Content-Type: application/json
X-Total-Count: 25
```

---

#### `POST /api/v1/districts`

Creates a new district.

**Access:** `SUPER_ADMIN`

**Response `201 Created`** with `Location` header.

---

#### `GET /api/v1/districts/:district-id`

Returns a single district.

**Access:** All authenticated roles

**Request Headers (conditional GET):**
```
If-None-Match: "b8e21f..."
```

**Response `200 OK`** or **`304 Not Modified`**

---

#### `PUT /api/v1/districts/:district-id`

Fully replaces a district record.

**Access:** `SUPER_ADMIN`

**Request Headers:**
```
If-Match: "b8e21f..."
```

**Response `200 OK`** or **`412 Precondition Failed`**

---

#### `GET /api/v1/districts/:district-id/stations`

Returns all stations in a district.

**Access:** `DISTRICT_COMMANDER`, `PROVINCIAL_COMMANDER`, `SUPER_ADMIN`

**Query Parameters:** `offset`, `limit`, `sort_by`, `order`

---

### 2.4 Station Types

Simple lookup table. `Main Station`, `Police Post`, `Range Office`.

---

#### `GET /api/v1/station-types`

Returns all station types.

**Access:** All authenticated roles

**Response `200 OK`:**
```json
{
  "count": 3,
  "data": [
    { "station_type_id": "uuid", "type_name": "Main Station" },
    { "station_type_id": "uuid", "type_name": "Police Post" },
    { "station_type_id": "uuid", "type_name": "Range Office" }
  ]
}
```

---

#### `POST /api/v1/station-types`

Creates a new station type.

**Access:** `SUPER_ADMIN`

**Response `201 Created`**

---

#### `GET /api/v1/station-types/:type-id`

Returns a single station type.

**Access:** All authenticated roles

---

#### `PUT /api/v1/station-types/:type-id`

Updates a station type.

**Access:** `SUPER_ADMIN`

---

### 2.5 Stations

Each station belongs to a district and has a type.

---

#### `GET /api/v1/stations`

Returns stations. Role-scoped: station-level officers only see their own station, district-level sees their district, etc.

**Access:** All authenticated roles

**Query Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `district_id` | uuid | Filter by district |
| `province_id` | uuid | Filter by province |
| `station_type_id` | uuid | Filter by type |
| `sort_by` | string | `name`, `district_id`. Default: `name` |
| `order` | string | `asc` \| `desc` |
| `offset` | integer | Default: `0` |
| `limit` | integer | Default: `20` |

**Response `200 OK`:** Paginated array of station objects.

---

#### `POST /api/v1/stations`

Creates a new station.

**Access:** `SUPER_ADMIN`

**Request Body:**
```json
{
  "district_id": "uuid",
  "station_type_id": "uuid",
  "name": "Colombo Fort Police Station",
  "contact_number": "+94112345678",
  "latitude": 6.9344,
  "longitude": 79.8428,
  "boundary_polygon": "POLYGON(...)"
}
```

**Response `201 Created`** with `Location` header.

---

#### `GET /api/v1/stations/:station-id`

Returns a single station.

**Access:** All authenticated roles

**Request Headers (conditional GET):**
```
If-None-Match: "c91d3a..."
```

**Response `200 OK`** or **`304 Not Modified`**

---

#### `PUT /api/v1/stations/:station-id`

Fully replaces a station record.

**Access:** `SUPER_ADMIN`

**Request Headers:**
```
If-Match: "c91d3a..."
```

---

#### `GET /api/v1/stations/:station-id/users`

Returns all users assigned to a station.

**Access:** `STATION_COMMANDER`, `DISTRICT_COMMANDER`, `PROVINCIAL_COMMANDER`, `SUPER_ADMIN`

**Query Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `role` | string | Filter by system role |
| `is_active` | boolean | Filter by active status |
| `sort_by` | string | `last_name`, `badge_number`. Default: `last_name` |
| `order` | string | `asc` \| `desc` |
| `offset` | integer | Default: `0` |
| `limit` | integer | Default: `20` |

---

### 2.6 Users

Represents police officers and admin accounts. User management is role-scoped — a commander can only manage users within their own jurisdiction.

---

#### `GET /api/v1/users`

Returns users. Automatically scoped by the requesting user's role and assigned boundaries.

**Access:** `STATION_COMMANDER` and above

**Query Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `station_id` | uuid | Filter by assigned station |
| `district_id` | uuid | Filter by assigned district |
| `province_id` | uuid | Filter by assigned province |
| `role` | string | Filter by system role |
| `is_active` | boolean | Filter active/inactive accounts |
| `sort_by` | string | `last_name`, `badge_number`. Default: `last_name` |
| `order` | string | `asc` \| `desc` |
| `offset` | integer | Default: `0` |
| `limit` | integer | Default: `20` |

**Response `200 OK`:** Paginated array of user objects. Password hash is never returned.

---

#### `POST /api/v1/users`

Creates a new user account.

**Access:** `STATION_COMMANDER` (station scope), `DISTRICT_COMMANDER` (district scope), `PROVINCIAL_COMMANDER` (district scope), `SUPER_ADMIN` (all)

**Request Body:**
```json
{
  "badge_number": "SLP-04521",
  "password": "initialPassword123",
  "first_name": "Nimal",
  "last_name": "Perera",
  "system_role": "STATION_OFFICER",
  "assigned_station_id": "uuid",
  "assigned_district_id": "uuid",
  "assigned_province_id": "uuid"
}
```

**Response `201 Created`** with `Location` header.

**Error Responses:** `400`, `401`, `403`, `409` (duplicate badge number)

---

#### `GET /api/v1/users/:user-id`

Returns a single user.

**Access:** `STATION_COMMANDER` and above (scoped)

**Request Headers (conditional GET):**
```
If-None-Match: "e7f1b2..."
```

**Response `200 OK`** or **`304 Not Modified`**

---

#### `PUT /api/v1/users/:user-id`

Fully replaces a user record. Used to update assignments, role, or status.

**Access:** `STATION_COMMANDER` and above (scoped to jurisdiction)

**Request Headers:**
```
If-Match: "e7f1b2..."
```

**Response `200 OK`** or **`412 Precondition Failed`**

---

#### `DELETE /api/v1/users/:user-id`

Deactivates a user account (soft delete — sets `is_active = false`). Records are retained for audit purposes.

**Access:** `STATION_COMMANDER` and above (scoped)

**Response `204 No Content`**

**Error Responses:** `401`, `403`, `404`

---

### 2.7 Devices

Tracking devices issued to tuk-tuks. Device provisioning is managed by `PROVINCIAL_OFFICER` and `SUPER_ADMIN`.

---

#### `GET /api/v1/devices`

Returns all tracking devices.

**Access:** `PROVINCIAL_OFFICER`, `PROVINCIAL_COMMANDER`, `SUPER_ADMIN`

**Query Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `admin_status` | string | `ACTIVE`, `UNDER_REPAIR`, `DECOMMISSIONED` |
| `province_id` | uuid | Filter devices by province (via their assigned vehicle) |
| `sort_by` | string | `serial_number`, `issued_date`. Default: `issued_date` |
| `order` | string | `asc` \| `desc` |
| `offset` | integer | Default: `0` |
| `limit` | integer | Default: `20` |

**Response `200 OK`:** Paginated array of device objects. `api_key_hash` is never returned.

---

#### `POST /api/v1/devices`

Registers a new tracking device.

**Access:** `PROVINCIAL_OFFICER`, `SUPER_ADMIN`

**Request Body:**
```json
{
  "serial_number": "TRK-SL-000201",
  "issued_date": "2025-01-10",
  "admin_status": "ACTIVE"
}
```

**Response `201 Created`:**
```json
{
  "device_id": "uuid",
  "serial_number": "TRK-SL-000201",
  "api_key": "raw-key-shown-once-only",
  "issued_date": "2025-01-10",
  "admin_status": "ACTIVE"
}
```

> The raw `api_key` is returned only once on creation. After this, only the hash is stored.

**Error Responses:** `400`, `401`, `403`, `409`

---

#### `GET /api/v1/devices/:device-id`

Returns a single device.

**Access:** `PROVINCIAL_OFFICER`, `PROVINCIAL_COMMANDER`, `SUPER_ADMIN`

**Request Headers (conditional GET):**
```
If-None-Match: "f3c8d1..."
```

**Response `200 OK`** or **`304 Not Modified`**

---

#### `PUT /api/v1/devices/:device-id`

Updates a device record. Used to change `admin_status` (e.g. mark as `UNDER_REPAIR`).

**Access:** `PROVINCIAL_OFFICER`, `SUPER_ADMIN`

**Request Headers:**
```
If-Match: "f3c8d1..."
```

**Response `200 OK`** or **`412 Precondition Failed`**

---

### 2.8 Vehicles

Core operational resource. Pulled from the DMT database via the `DATA_REGISTRAR` role.

---

#### `GET /api/v1/vehicles`

Returns vehicles. Role-scoped automatically by the requesting user's assigned boundaries.

**Access:** `STATION_OFFICER` and above

**Query Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `owner_nic` | string | Filter by owner NIC number |
| `police_status` | string | `CLEAN`, `STOLEN`, `WANTED`, `SUSPENDED` |
| `device_status` | string | `ONLINE`, `OFFLINE` (derived from last ping age) |
| `registration_number` | string | Filter by registration number |
| `province_id` | uuid | Filter by registered province |
| `district_id` | uuid | Filter by district (via station boundary) |
| `station_id` | uuid | Filter by station jurisdiction |
| `sort_by` | string | `registration_number`, `owner_name`, `police_status`. Default: `registration_number` |
| `order` | string | `asc` \| `desc` |
| `offset` | integer | Default: `0` |
| `limit` | integer | Default: `20` |

**Response `200 OK`:** Paginated array of vehicle objects.

**Response Headers:**
```
Content-Type: application/json
X-Total-Count: 214
```

---

#### `POST /api/v1/vehicles`

Registers a new vehicle (DMT sync or manual entry).

**Access:** `SUPER_ADMIN`, `DATA_REGISTRAR`

**Request Body:**
```json
{
  "registration_number": "WP CAB-1234",
  "chassis_number": "MH1JF185XEK000001",
  "color": "Yellow",
  "make_model": "Bajaj RE",
  "device_id": "uuid",
  "owner_nic": "199012345678",
  "owner_name": "Kamal Silva",
  "owner_contact": "+94771234567",
  "registered_province_id": "uuid"
}
```

**Response `201 Created`** with `Location` header.

**Error Responses:** `400`, `401`, `403`, `409` (duplicate registration/chassis)

---

#### `GET /api/v1/vehicles/:vehicle-id`

Returns a single vehicle with full details.

**Access:** `STATION_OFFICER` and above

**Request Headers (conditional GET):**
```
Authorization: Bearer <access_token>
Accept: application/json
If-None-Match: "a1b2c3..."
If-Modified-Since: Mon, 14 Apr 2025 08:30:00 GMT
```

**Response `200 OK`:**
```
ETag: "a1b2c3..."
Last-Modified: Mon, 14 Apr 2025 08:30:00 GMT
Content-Type: application/json
```

**Response `304 Not Modified`** (if ETag or timestamp matches — empty body)

---

#### `PUT /api/v1/vehicles/:vehicle-id`

Fully replaces a vehicle record.

**Access:** `SUPER_ADMIN`, `DATA_REGISTRAR`

**Request Headers:**
```
Authorization: Bearer <access_token>
Content-Type: application/json
If-Match: "a1b2c3..."
```

**Response `200 OK`** or **`412 Precondition Failed`**

---

#### `POST /api/v1/vehicles/:vehicle-id/mark-stolen`

Processing function resource — marks a vehicle's police status as `STOLEN`. Named as a verb per WSO2 4.5 and 5.1.

**Access:** `STATION_OFFICER` and above

**Request Body:**
```json
{
  "reason": "Reported stolen by owner at Colombo Fort Station",
  "reported_by_user_id": "uuid"
}
```

**Response `200 OK`:**
```json
{
  "vehicle_id": "uuid",
  "police_status": "STOLEN",
  "updated_at": "2025-04-15T10:30:00Z"
}
```

**Error Responses:** `400`, `401`, `403`, `404`

---

#### `POST /api/v1/vehicles/:vehicle-id/clear-status`

Processing function resource — resets police status back to `CLEAN`.

**Access:** `STATION_OFFICER` and above

**Request Body:**
```json
{
  "reason": "Vehicle recovered and verified at Maradana Station"
}
```

**Response `200 OK`**

---

#### `GET /api/v1/vehicles/:vehicle-id/location`

Returns the most recent location ping for a vehicle (live view).

**Access:** `STATION_OFFICER` and above

**Request Headers:**
```
Authorization: Bearer <access_token>
Accept: application/json
```

**Response `200 OK`:**
```json
{
  "vehicle_id": "uuid",
  "registration_number": "WP CAB-1234",
  "device_id": "uuid",
  "latitude": 6.9271,
  "longitude": 79.8612,
  "battery_level": 82,
  "pinged_at": "2025-04-15T10:29:55Z",
  "device_status": "ONLINE"
}
```

**Error Responses:** `401`, `403`, `404`

---

#### `GET /api/v1/vehicles/:vehicle-id/history`

Returns the location history for a vehicle within a specified time window.

**Access:** `STATION_OFFICER` and above

**Query Parameters:**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `from` | ISO 8601 datetime | Yes | Start of time window. e.g. `2025-04-08T00:00:00Z` |
| `to` | ISO 8601 datetime | Yes | End of time window. e.g. `2025-04-15T23:59:59Z` |
| `sort_by` | string | No | `pinged_at`. Default: `pinged_at` |
| `order` | string | No | `asc` \| `desc`. Default: `asc` |
| `offset` | integer | No | Default: `0` |
| `limit` | integer | No | Default: `100`, Max: `500` |

**Request Headers:**
```
Authorization: Bearer <access_token>
Accept: application/json
```

**Response `200 OK`:**
```json
{
  "vehicle_id": "uuid",
  "registration_number": "WP CAB-1234",
  "from": "2025-04-08T00:00:00Z",
  "to": "2025-04-15T23:59:59Z",
  "count": 4032,
  "offset": 0,
  "limit": 100,
  "next": "/api/v1/vehicles/uuid/history?from=...&to=...&offset=100&limit=100",
  "previous": null,
  "data": [
    {
      "ping_id": "uuid",
      "latitude": 6.9271,
      "longitude": 79.8612,
      "battery_level": 85,
      "pinged_at": "2025-04-08T00:05:12Z"
    }
  ]
}
```

**Error Responses:** `400` (missing/invalid time window), `401`, `403`, `404`

---

### 2.9 Drivers

Driver records pulled from DMT. Linked to vehicles via the assignment junction.

---

#### `GET /api/v1/drivers`

Returns all drivers.

**Access:** `STATION_OFFICER` and above

**Query Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `police_status` | string | `CLEAR`, `WANTED`, `SUSPENDED_LICENSE` |
| `license_number` | string | Filter by driving licence number |
| `sort_by` | string | `last_name`, `license_number`. Default: `last_name` |
| `order` | string | `asc` \| `desc` |
| `offset` | integer | Default: `0` |
| `limit` | integer | Default: `20` |

**Response `200 OK`:** Paginated array of driver objects.

---

#### `POST /api/v1/drivers`

Registers a new driver.

**Access:** `SUPER_ADMIN`, `DATA_REGISTRAR`

**Request Body:**
```json
{
  "first_name": "Ruwan",
  "last_name": "Fernando",
  "permanent_address": "45/2, Galle Road, Colombo 3",
  "driving_license_number": "B1234567",
  "police_status": "CLEAR"
}
```

**Response `201 Created`** with `Location` header.

**Error Responses:** `400`, `401`, `403`, `409` (duplicate licence number)

---

#### `GET /api/v1/drivers/:driver-id`

Returns a single driver.

**Access:** `STATION_OFFICER` and above

**Request Headers (conditional GET):**
```
If-None-Match: "9d3a7c..."
```

**Response `200 OK`** or **`304 Not Modified`**

---

#### `PUT /api/v1/drivers/:driver-id`

Fully replaces a driver record.

**Access:** `SUPER_ADMIN`, `DATA_REGISTRAR`

**Request Headers:**
```
If-Match: "9d3a7c..."
```

**Response `200 OK`** or **`412 Precondition Failed`**

---

#### `GET /api/v1/drivers/:driver-id/assignments`

Returns all vehicle assignments for a driver across time.

**Access:** `STATION_OFFICER` and above

**Query Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `active_only` | boolean | If `true`, returns only assignments with no `returned_date` |
| `sort_by` | string | `assigned_date`. Default: `assigned_date` |
| `order` | string | `asc` \| `desc`. Default: `desc` |
| `offset` | integer | Default: `0` |
| `limit` | integer | Default: `20` |

---

### 2.10 Vehicle–Driver Assignments

Scoped collection under vehicles. Follows WSO2 4.6 scoped collection pattern — the full global set of assignments is not a first-class resource; only assignments scoped to a specific vehicle are exposed.

---

#### `GET /api/v1/vehicles/:vehicle-id/assignments`

Returns all driver assignments for a vehicle.

**Access:** `STATION_OFFICER` and above

**Query Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `active_only` | boolean | If `true`, returns only the current active assignment (no `returned_date`) |
| `sort_by` | string | `assigned_date`. Default: `assigned_date` |
| `order` | string | `asc` \| `desc`. Default: `desc` |
| `offset` | integer | Default: `0` |
| `limit` | integer | Default: `20` |

**Response `200 OK`:**
```json
{
  "vehicle_id": "uuid",
  "count": 5,
  "data": [
    {
      "assignment_id": "uuid",
      "driver_id": "uuid",
      "driver_name": "Ruwan Fernando",
      "assigned_date": "2025-01-10",
      "returned_date": null
    }
  ]
}
```

---

#### `POST /api/v1/vehicles/:vehicle-id/assignments`

Creates a new driver assignment for a vehicle.

**Access:** `SUPER_ADMIN`, `DATA_REGISTRAR`

**Request Body:**
```json
{
  "driver_id": "uuid",
  "assigned_date": "2025-04-15"
}
```

**Response `201 Created`** with `Location` header.

**Error Responses:** `400`, `401`, `403`, `409` (vehicle already has an active assignment)

---

#### `PUT /api/v1/vehicles/:vehicle-id/assignments/:assignment-id`

Updates an assignment. Primarily used to set the `returned_date` when a driver returns a vehicle.

**Access:** `SUPER_ADMIN`, `DATA_REGISTRAR`

**Request Headers:**
```
If-Match: "cc19f7..."
```

**Request Body:**
```json
{
  "driver_id": "uuid",
  "assigned_date": "2025-04-15",
  "returned_date": "2025-04-20"
}
```

**Response `200 OK`** or **`412 Precondition Failed`**

---

### 2.11 Locations

Two distinct sub-resources: the high-frequency device write path and the officer query path.

---

#### `POST /api/v1/locations/ping`

Processing function resource — receives a GPS location ping from a tracking device. Authenticated with the device API key, not a JWT.

**Access:** `DEVICE_CLIENT` only

**Request Headers:**
```
X-Device-Key: <raw_api_key>
Content-Type: application/json
```

**Request Body:**
```json
{
  "latitude": 6.9271,
  "longitude": 79.8612,
  "battery_level": 78,
  "timestamp": "2025-04-15T10:29:55Z"
}
```

**Response `201 Created`:**
```json
{
  "ping_id": "uuid",
  "device_id": "uuid",
  "received_at": "2025-04-15T10:29:55Z"
}
```

**Error Responses:** `400`, `401` (invalid or missing API key), `422` (device decommissioned)

---

#### `GET /api/v1/locations`

Area movement query — returns location pings for all vehicles within a specified boundary and time window. Used for investigative area movement analysis.

**Access:** `STATION_OFFICER` and above

**Query Parameters:**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `from` | ISO 8601 datetime | Yes | Start of time window |
| `to` | ISO 8601 datetime | Yes | End of time window |
| `province_id` | uuid | No | Scope to province |
| `district_id` | uuid | No | Scope to district |
| `station_id` | uuid | No | Scope to station jurisdiction |
| `sort_by` | string | No | `pinged_at`. Default: `pinged_at` |
| `order` | string | No | `asc` \| `desc`. Default: `asc` |
| `offset` | integer | No | Default: `0` |
| `limit` | integer | No | Default: `100`, Max: `500` |

**Request Headers:**
```
Authorization: Bearer <access_token>
Accept: application/json
```

**Response `200 OK`:**
```json
{
  "from": "2025-04-08T00:00:00Z",
  "to": "2025-04-15T23:59:59Z",
  "scope": {
    "district_id": "uuid",
    "district_name": "Colombo"
  },
  "count": 18420,
  "offset": 0,
  "limit": 100,
  "next": "/api/v1/locations?from=...&to=...&district_id=...&offset=100&limit=100",
  "previous": null,
  "data": [
    {
      "ping_id": "uuid",
      "device_id": "uuid",
      "vehicle_id": "uuid",
      "registration_number": "WP CAB-1234",
      "latitude": 6.9271,
      "longitude": 79.8612,
      "battery_level": 80,
      "pinged_at": "2025-04-08T00:05:12Z"
    }
  ]
}
```

**Error Responses:** `400` (missing time window), `401`, `403`

---

## 3. Endpoint Summary

| Method | URI | Roles | Description |
|--------|-----|-------|-------------|
| POST | `/api/v1/auth/login` | Public | Authenticate and receive JWT |
| POST | `/api/v1/auth/refresh` | All | Refresh access token |
| POST | `/api/v1/auth/logout` | All | Invalidate refresh token |
| GET | `/api/v1/provinces` | All | List all provinces |
| POST | `/api/v1/provinces` | SUPER_ADMIN | Create province |
| GET | `/api/v1/provinces/:id` | All | Get single province |
| PUT | `/api/v1/provinces/:id` | SUPER_ADMIN | Update province |
| GET | `/api/v1/provinces/:id/districts` | All | Get districts of a province |
| GET | `/api/v1/provinces/:id/stations` | PROVINCIAL_COMMANDER+ | Get stations in a province |
| GET | `/api/v1/districts` | All | List all districts |
| POST | `/api/v1/districts` | SUPER_ADMIN | Create district |
| GET | `/api/v1/districts/:id` | All | Get single district |
| PUT | `/api/v1/districts/:id` | SUPER_ADMIN | Update district |
| GET | `/api/v1/districts/:id/stations` | DISTRICT_COMMANDER+ | Get stations in a district |
| GET | `/api/v1/station-types` | All | List station types |
| POST | `/api/v1/station-types` | SUPER_ADMIN | Create station type |
| GET | `/api/v1/station-types/:id` | All | Get single station type |
| PUT | `/api/v1/station-types/:id` | SUPER_ADMIN | Update station type |
| GET | `/api/v1/stations` | All | List stations (role-scoped) |
| POST | `/api/v1/stations` | SUPER_ADMIN | Create station |
| GET | `/api/v1/stations/:id` | All | Get single station |
| PUT | `/api/v1/stations/:id` | SUPER_ADMIN | Update station |
| GET | `/api/v1/stations/:id/users` | STATION_COMMANDER+ | List users at a station |
| GET | `/api/v1/users` | STATION_COMMANDER+ | List users (role-scoped) |
| POST | `/api/v1/users` | STATION_COMMANDER+ | Create user |
| GET | `/api/v1/users/:id` | STATION_COMMANDER+ | Get single user |
| PUT | `/api/v1/users/:id` | STATION_COMMANDER+ | Update user |
| DELETE | `/api/v1/users/:id` | STATION_COMMANDER+ | Deactivate user |
| GET | `/api/v1/devices` | PROVINCIAL_OFFICER+ | List devices |
| POST | `/api/v1/devices` | PROVINCIAL_OFFICER, SUPER_ADMIN | Create device |
| GET | `/api/v1/devices/:id` | PROVINCIAL_OFFICER+ | Get single device |
| PUT | `/api/v1/devices/:id` | PROVINCIAL_OFFICER, SUPER_ADMIN | Update device |
| GET | `/api/v1/vehicles` | STATION_OFFICER+ | List vehicles (role-scoped) |
| POST | `/api/v1/vehicles` | SUPER_ADMIN, DATA_REGISTRAR | Create vehicle |
| GET | `/api/v1/vehicles/:id` | STATION_OFFICER+ | Get single vehicle |
| PUT | `/api/v1/vehicles/:id` | SUPER_ADMIN, DATA_REGISTRAR | Update vehicle |
| POST | `/api/v1/vehicles/:id/mark-stolen` | STATION_OFFICER+ | Flag vehicle as stolen |
| POST | `/api/v1/vehicles/:id/clear-status` | STATION_OFFICER+ | Reset police status |
| GET | `/api/v1/vehicles/:id/location` | STATION_OFFICER+ | Get live location |
| GET | `/api/v1/vehicles/:id/history` | STATION_OFFICER+ | Get movement history |
| GET | `/api/v1/vehicles/:id/assignments` | STATION_OFFICER+ | List driver assignments |
| POST | `/api/v1/vehicles/:id/assignments` | SUPER_ADMIN, DATA_REGISTRAR | Create assignment |
| PUT | `/api/v1/vehicles/:id/assignments/:id` | SUPER_ADMIN, DATA_REGISTRAR | Update assignment |
| GET | `/api/v1/drivers` | STATION_OFFICER+ | List drivers |
| POST | `/api/v1/drivers` | SUPER_ADMIN, DATA_REGISTRAR | Create driver |
| GET | `/api/v1/drivers/:id` | STATION_OFFICER+ | Get single driver |
| PUT | `/api/v1/drivers/:id` | SUPER_ADMIN, DATA_REGISTRAR | Update driver |
| GET | `/api/v1/drivers/:id/assignments` | STATION_OFFICER+ | Get vehicle history of a driver |
| POST | `/api/v1/locations/ping` | DEVICE_CLIENT | Submit GPS ping |
| GET | `/api/v1/locations` | STATION_OFFICER+ | Area movement query |
