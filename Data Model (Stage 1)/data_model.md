# Database Data Model

## Entities and Attributes

### Tracking_Device
- **device_id** (Primary Key)
- serial_number
- api_key_hash
- issued_date
- admin_status

### Location_Ping
- **ping_id** (Primary Key)
- *device_id* (Foreign Key)
- latitude
- longitude
- battery_level
- pinged_at

### Province
- **province_id** (Primary Key)
- name
- boundary_polygon

### District
- **district_id** (Primary Key)
- *province_id* (Foreign Key)
- name
- boundary_polygon

### Vehicle
- **vehicle_id** (Primary Key)
- registration_number
- chassis_number
- color
- make_model
- *device_id* (Foreign Key)
- police_status
- owner_nic
- owner_first_name
- owner_last_name
- owner_contact
- *registered_province_id* (Foreign Key)

### Driver
- **driver_id** (Primary Key)
- first_name
- last_name
- permanent_address
- driving_license_number
- police_status

### Vehicle_Driver_Assignment
- **assignment_id** (Primary Key)
- *vehicle_id* (Foreign Key)
- *driver_id* (Foreign Key)
- assigned_date
- returned_date

### Station_Type
- **station_type_id** (Primary Key)
- type_name

### Station
- **station_id** (Primary Key)
- *district_id* (Foreign Key)
- *station_type_id* (Foreign Key)
- name
- contact_number
- latitude
- longitude
- boundary_polygon

### User
- **user_id** (Primary Key)
- badge_number
- password_hash
- first_name
- last_name
- *assigned_station_id* (Foreign Key)
- *assigned_province_id* (Foreign Key)
- *assigned_district_id* (Foreign Key)
- system_role
- is_active

---

## Relationships

**Note:** The model uses crow's foot notation to indicate cardinality (One-to-One, One-to-Many).

### Hardware & Tracking
* **Tracking_Device (1) to Vehicle (1):** A tracking device is installed in a vehicle.
* **Tracking_Device (1) to Location_Ping (Many):** A tracking device generates location pings.

### Geography & Infrastructure
* **Province (1) to District (Many):** A province contains districts.
* **Province (1) to Vehicle (Many):** Vehicles are registered in a province.
* **District (1) to Station (Many):** A district contains stations.
* **Station_Type (1) to Station (Many):** A station type classifies stations.

### Fleet Management
* **Vehicle (1) to Vehicle_Driver_Assignment (Many):** A vehicle has vehicle-driver assignments.
* **Driver (1) to Vehicle_Driver_Assignment (Many):** A driver has vehicle-driver assignments.

### Access Control (Scoping)
* **Province (1) to User (Many):** Users can be scoped to a specific province.
* **District (1) to User (Many):** Users can be scoped to a specific district.
* **Station (1) to User (Many):** Users can be scoped to a specific station.
