# SLPVT Backend

Sri Lanka Police Vehicle Tracking System - backend REST API for managing police vehicle registration, GPS tracking, driver assignments, station hierarchy, and role-based reporting.

## Student Information

| Field                    | Value             |
|--------------------------|-------------------|
| **Student Index Number** | COBSCCOMP242P-003 |
| **Coventry Index Number**| 16114221          |
| **Student Name**         | T.H.P.P. Perera   |


## Project Status

In Development

---

## Live Deployment

| Resource | URL |
|----------|-----|
| **API Base URL** | http://52.66.55.28/slpvt/v1 |
| **API Documentation (Swagger)** | https://app.swaggerhub.com/apis/nibm-01e/slpvt-api-specification/1.0.1#/ |

> The Swagger specification is published under a trial SwaggerHub account and will expire **31 May 2026**.

---

## Project Overview

This repository contains the backend service for the Sri Lanka Police Vehicle Tracking (SLPVT) system. The system allows police officers at multiple administrative levels (province, district, station) to register and track tuk-tuk vehicles, manage driver assignments, and monitor GPS location history - all enforced by a hierarchical role-based access control model.

**Key capabilities:**
- Administrative boundary management (provinces → districts → DS divisions → stations)
- Vehicle and driver registration linked to DMT records
- Vehicle–driver assignment lifecycle management
- Real-time GPS location ingestion from tracking devices via API key authentication
- Location history queries with geospatial filtering
- JWT-based authentication with role-scoped data access
- Reporting across jurisdictional boundaries

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Runtime | Node.js 18+ |
| Framework | Express.js 5 |
| Relational DB | PostgreSQL 15 (via Knex.js) |
| Document DB | MongoDB 7 (via Mongoose) |
| Authentication | JWT (access + refresh tokens) + API key (devices) |
| Validation | Joi |
| Geospatial | Turf.js |
| Containerisation | Docker & Docker Compose |
| Testing | Jest + Supertest |
| Logging | Winston + Morgan |
| Linting | ESLint (Airbnb base) |

---

## API Modules

All routes are prefixed with `/slpvt/v1`.

| Module | Prefix | Description |
|--------|--------|-------------|
| Auth | `/auth` | Login, token refresh, logout |
| Provinces | `/provinces` | Read-only province list |
| Districts | `/districts` | Read-only district list, filterable by province |
| Divisional Secretariats | `/divisional-secretariats` | DS division list, filterable by district |
| Stations | `/stations` | Full CRUD for police stations (4-level hierarchy) |
| Users | `/users` | User management with role-ceiling enforcement |
| Tracking Devices | `/devices` | GPS device provisioning and status management |
| Vehicles | `/vehicles` | Vehicle registration and police status updates |
| Drivers | `/drivers` | Driver registration and licence/status management |
| Assignments | `/assignments` | Vehicle–driver assignment lifecycle |
| Locations | `/locations` | Device GPS pings (write) and location history (read) |
| Reports | `/reports` | Jurisdiction-scoped reporting |

---

## Authentication & Authorisation

**JWT (human users):**
- `POST /auth/login` with `badge_number` and `password`
- Returns a short-lived access token (15 min) and a refresh token (7 days)
- Refresh tokens are stored hashed in PostgreSQL and revoked on logout

**API key (tracking devices):**
- `X-Device-Key` header — SHA-256 hashed on the server, never stored in plain text
- Used exclusively by GPS tracking devices to submit location pings

**Role hierarchy (9 roles):**

| Role | Jurisdiction Scope |
|------|--------------------|
| SUPER_ADMIN | Country-wide |
| PROVINCIAL_COMMANDER | Assigned province |
| PROVINCIAL_OFFICER | Assigned province |
| DISTRICT_COMMANDER | Assigned district |
| DISTRICT_OFFICER | Assigned district |
| STATION_COMMANDER | Assigned station |
| STATION_OFFICER | Assigned station |
| DATA_REGISTRAR | DMT data entry only (no boundary scope) |
| DEVICE_CLIENT | Location ping submission only |

Each role can only access and create data within its own jurisdictional scope, enforced in the service and repository layers.

---

## Data Model Summary

**PostgreSQL tables (10):**

| Table | Key Columns |
|-------|-------------|
| `provinces` | `province_id` (PK), `name`, `province_slug` |
| `districts` | `district_id` (PK), `province_id` (FK), `name`, `district_slug` |
| `divisional_secretariats` | `ds_division_id` (PK), `district_id` (FK), `name`, `ds_division_slug` |
| `stations` | `station_id` (PK), `station_type` (enum), `province_id` / `district_id` / `ds_division_id` (FKs), `name`, `short_code`, `contact_number`, `latitude`, `longitude`, `deleted_at` |
| `users` | `user_id` (PK), `badge_number`, `password_hash`, `first_name`, `last_name`, `system_role` (enum), `assigned_station_id` (FK), `deleted_at` |
| `tracking_devices` | `device_id` (PK), `serial_number`, `api_key_hash`, `issued_date`, `admin_status` (enum) |
| `vehicles` | `vehicle_id` (PK), `vehicle_reference_id`, `registration_number`, `chassis_number`, `make_model`, `color`, `owner_nic`, `owner_full_name`, `owner_contact`, `ds_division_id` (FK), `device_id` (FK), `police_status` (enum), `deleted_at` |
| `drivers` | `driver_id` (PK), `driver_reference_id`, `first_name`, `last_name`, `driving_license_number`, `license_expiry_date`, `permanent_address`, `police_status` (enum), `deleted_at` |
| `vehicle_driver_assignments` | `assignment_id` (PK), `vehicle_id` (FK), `driver_id` (FK), `assigned_date`, `returned_date` |
| `refresh_tokens` | `token_id` (PK), `user_id` (FK), `token_hash`, `is_used`, `expires_at` |

**MongoDB collections (3):**

| Collection | Contents |
|------------|----------|
| `districts` | GeoJSON boundary polygons (25) |
| `divisional_secretariats` | GeoJSON boundary polygons (29) |
| `location_pings` | GPS ping history (~1 M documents) |

---

## Quick Start — Local Development

### Prerequisites

- Node.js 18+
- Docker Desktop
- `.env` file configured (copy `.env.example` and fill values)

### 1. Install dependencies

```bash
cd api
npm install
```

### 2. Start databases

```bash
docker compose up -d
```

### 3. Run migrations and seeds

```bash
npx knex migrate:latest
npx knex seed:run
```

### 4. Seed MongoDB boundaries and simulate location history

```bash
node scripts/seedDistrictBoundaries.js
node scripts/seedDSBoundaries.js
node scripts/pingSimulator.js
```

### 5. Start the API server

```bash
npm run dev
```

The API will be available at `http://localhost:3000/slpvt/v1`.

See the full database setup guide for detailed instructions, expected row counts, and reset procedures: [Database Setup Guide](./api/docs/database_setup.md)

---

## Documentation Links

### API & Database

- [API Specification (OpenAPI)](./artifacts/APISpecificationOPENAPI.yaml)
- [Database Setup Guide](./api/docs/database_setup.md)

### General Project Artifacts

- [Work Plan](./General/Work%20Plan.png)
- [Data Model Diagram](./General/data_model.png)
- [System Architecture](./General/System%20Architecture.png)
- [Deployment Architecture](./General/Deployment%20Architecture.png)
- [CI/CD Pipeline](./General/CICD%20Pipeline.png)

---

## Project Stages

| Stage | Description | Status |
|-------|-------------|--------|
| Stage 1 | Data Model and System Planning | Complete |
| Stage 2 | Resource and API Design | Complete |
| Stage 3 | Database Setup and Seeding | Complete |
| Stage 4 | Backend Module Implementation | Complete |
| Stage 5 | Deployment | Complete |

---

## License

This project is licensed under the terms defined in [LICENSE](./LICENSE).
