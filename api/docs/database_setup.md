# Database Setup Guide — SLPVT Backend

## Prerequisites

Before running any database commands make sure the following are installed and running:

- Node.js 18+
- Docker Desktop
- All dependencies installed via `npm install` (run from the `api/` directory)
- `.env` file configured (copy from `.env.example` and fill in values)

---

## 1. Start the databases

```bash
docker compose up -d
```

Verify both containers are running:

```bash
docker ps
```

You should see:

```
slpvt_postgres   — PostgreSQL 15 on port 5432
slpvt_mongo      — MongoDB 7 on port 27017
```

---

## 2. Database Migrations

Migrations create the table structure in PostgreSQL. They run in order based on the timestamp prefix in the filename. Knex tracks which migrations have already run so they never execute twice.

### Run all pending migrations

```bash
npx knex migrate:latest
```

### Check migration status

```bash
npx knex migrate:status
```

### Roll back the last batch

```bash
npx knex migrate:rollback
```

### Migration files — run order

```
001_create_provinces.js
002_create_districts.js
003_create_divisional_secretariats.js
004_create_stations.js
005_create_users.js
006_create_tracking_devices.js
007_create_vehicles.js
008_create_drivers.js
009_create_vehicle_driver_assignments.js
010_create_refresh_tokens.js
```

> The order matters due to foreign key dependencies. Provinces must exist before districts, districts before stations, and so on. Knex handles this automatically via the timestamp prefix ordering. Station type is stored as an enum column within the `stations` table — there is no separate station types table.

---

## 3. Seed Data — PostgreSQL

Seeds populate the tables with initial data. Run them in order — each seed depends on data from the previous ones.

### Run all seeds in order

```bash
npx knex seed:run
```

### Run a specific seed file

```bash
npx knex seed:run --specific=01_provinces.js
```

### Seed files — run order

| File | Description | Rows |
|------|-------------|------|
| `01_provinces.js` | All 9 Sri Lanka provinces | 9 |
| `02_districts.js` | All 25 districts mapped to provinces | 25 |
| `03_divisional_secretariats.js` | 29 DS divisions across 6 districts | 29 |
| `04_stations.js` | 39 stations across all hierarchy levels | 39 |
| `05_users.js` | One test user per system role | 8 |
| `06_tracking_devices.js` | 210 GPS devices with hashed API keys | 210 |
| `07_vehicles.js` | 205 tuk-tuks across Western, Central, Southern provinces | 205 |
| `08_drivers.js` | 210 drivers with Sri Lankan details | 210 |
| `09_vehicle_driver_assignments.js` | 205 active driver-vehicle assignments | 205 |

> Raw device API keys are saved to `api/data/device_keys.json` after running `06_tracking_devices.js`. This file is excluded from Git and is for local development use only. Never commit raw API keys.

---

## 4. Seed Data — MongoDB Boundaries

These scripts insert GeoJSON boundary polygons into MongoDB. They must run after the PostgreSQL seeds since they look up UUIDs from the PostgreSQL tables.

### District boundaries

Place the GADM level 1 GeoJSON file at:

```
data/district_spatial_data.json
```

Run the seeder:

```bash
node scripts/seedDistrictBoundaries.js
```

Expected output:

```
MongoDB connected
Indexes created
Inserted: 25 districts
Connections closed
```

### DS Division boundaries

Place the GADM level 2 GeoJSON file at:

```
data/ds_spatial_data.json
```

Run the seeder:

```bash
node scripts/seedDSBoundaries.js
```

Expected output:

```
MongoDB connected
Indexes created
Inserted: 29 DS divisions
Connections closed
```

> Any names in the GADM file that do not match your PostgreSQL records will be logged as unmatched. Check spelling if you see unexpected unmatched entries.

---

## 5. Location Ping Simulation

This script generates 7 days of realistic location history for all 205 vehicles. It must run after all PostgreSQL and MongoDB seeds are complete.

```bash
node scripts/pingSimulator.js
```

Expected output:

```
MongoDB connected
Indexes created
Found 205 vehicles with devices
Generating 7 days of pings at 2 minute intervals
Expected documents: ~1,033,200

  10/205 vehicles done — 50,400 pings — 0.8s elapsed
  20/205 vehicles done — 100,800 pings — 1.6s elapsed
  ...
  205/205 vehicles done — 1,033,200 pings — 7.2s elapsed

Simulation complete
Total pings inserted: 1,033,200
Time taken: 7.2 seconds
Connections closed
```

> Re-run this script before your demo to ensure the most recent ping timestamps are fresh. The script drops and recreates the collection each time it runs.

---

## 6. Test User Credentials

All test users share the same password:

```
Password: Test@1234
```

| Badge Number | Role | Scope |
|-------------|------|-------|
| SLP-00001 | SUPER_ADMIN | Country level — full access |
| SLP-00002 | PROVINCIAL_COMMANDER | Western Province |
| SLP-00003 | PROVINCIAL_OFFICER | Western Province |
| SLP-00004 | DISTRICT_COMMANDER | Colombo District |
| SLP-00005 | DISTRICT_OFFICER | Colombo District |
| SLP-00006 | STATION_COMMANDER | Colombo Police Post |
| SLP-00007 | STATION_OFFICER | Colombo Police Post |
| SLP-00008 | DATA_REGISTRAR | No boundary scope |

---

## 7. Verify data counts

### PostgreSQL

```bash
docker exec -it slpvt_postgres psql -U slpvt_user -d slpvt_dev -c "
SELECT 'provinces' as table_name, COUNT(*) FROM provinces
UNION ALL SELECT 'districts', COUNT(*) FROM districts
UNION ALL SELECT 'divisional_secretariats', COUNT(*) FROM divisional_secretariats
UNION ALL SELECT 'stations', COUNT(*) FROM stations
UNION ALL SELECT 'users', COUNT(*) FROM users
UNION ALL SELECT 'tracking_devices', COUNT(*) FROM tracking_devices
UNION ALL SELECT 'vehicles', COUNT(*) FROM vehicles
UNION ALL SELECT 'drivers', COUNT(*) FROM drivers
UNION ALL SELECT 'vehicle_driver_assignments', COUNT(*) FROM vehicle_driver_assignments
ORDER BY table_name;"
```

Expected counts:

```
divisional_secretariats   |  29
districts                 |  25
drivers                   | 210
provinces                 |   9
stations                  |  39
tracking_devices          | 210
users                     |   8
vehicle_driver_assignments| 205
vehicles                  | 205
```

### MongoDB

```bash
# district boundaries
docker exec -it slpvt_mongo mongosh slpvt_tracking --eval "db.districts.countDocuments()"

# DS division boundaries
docker exec -it slpvt_mongo mongosh slpvt_tracking --eval "db.divisional_secretariats.countDocuments()"

# location pings
docker exec -it slpvt_mongo mongosh slpvt_tracking --eval "db.location_pings.countDocuments()"
```

Expected counts:

```
districts                |  25
divisional_secretariats  |  29
location_pings           | ~1,033,200
```

---

## 8. Backup and restore

### PostgreSQL backup

```bash
docker exec -it slpvt_postgres pg_dump -U slpvt_user slpvt_dev > slpvt_backup.sql
```

### PostgreSQL restore

```bash
docker exec -i slpvt_postgres psql -U slpvt_user slpvt_dev < slpvt_backup.sql
```

### MongoDB backup

```bash
docker exec -it slpvt_mongo mongodump --db slpvt_tracking --out /tmp/mongo_backup
docker cp slpvt_mongo:/tmp/mongo_backup ./mongo_backup
```

### MongoDB restore

```bash
docker cp ./mongo_backup slpvt_mongo:/tmp/mongo_backup
docker exec -it slpvt_mongo mongorestore --db slpvt_tracking /tmp/mongo_backup/slpvt_tracking
```

---

## 9. Reset everything — fresh start

If you need to wipe all data and start from scratch:

```bash
# stop and remove containers and volumes
docker compose down -v

# start fresh containers
docker compose up -d

# run all migrations
npx knex migrate:latest

# run all PostgreSQL seeds
npx knex seed:run

# seed MongoDB boundaries
node scripts/seedDistrictBoundaries.js
node scripts/seedDSBoundaries.js

# run ping simulator
node scripts/pingSimulator.js
```

---

## 10. Stop the databases

```bash
# stop containers, preserve data
docker compose stop

# start again next session
docker compose start
```
