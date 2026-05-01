--
-- PostgreSQL database dump
--

\restrict L1A4AIhB1Uo0op8ayffeAl1U7iNR3o1TkPE5f7nuWhtiykaJqaxjM6IkA6XKTKh

-- Dumped from database version 15.17 (Debian 15.17-1.pgdg13+1)
-- Dumped by pg_dump version 15.17 (Debian 15.17-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: districts; Type: TABLE; Schema: public; Owner: slpvt_user
--

CREATE TABLE public.districts (
    district_id uuid DEFAULT gen_random_uuid() NOT NULL,
    province_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.districts OWNER TO slpvt_user;

--
-- Name: COLUMN districts.province_id; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.districts.province_id IS 'Province this district belongs to';


--
-- Name: divisional_secretariats; Type: TABLE; Schema: public; Owner: slpvt_user
--

CREATE TABLE public.divisional_secretariats (
    ds_division_id uuid DEFAULT gen_random_uuid() NOT NULL,
    district_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.divisional_secretariats OWNER TO slpvt_user;

--
-- Name: COLUMN divisional_secretariats.district_id; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.divisional_secretariats.district_id IS 'District this DS division belongs to';


--
-- Name: drivers; Type: TABLE; Schema: public; Owner: slpvt_user
--

CREATE TABLE public.drivers (
    driver_id uuid DEFAULT gen_random_uuid() NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    permanent_address text NOT NULL,
    driving_license_number character varying(50) NOT NULL,
    license_expiry_date date NOT NULL,
    police_status text DEFAULT 'CLEAR'::text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT drivers_police_status_check CHECK ((police_status = ANY (ARRAY['CLEAR'::text, 'WANTED'::text, 'SUSPENDED_LICENSE'::text])))
);


ALTER TABLE public.drivers OWNER TO slpvt_user;

--
-- Name: COLUMN drivers.permanent_address; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.drivers.permanent_address IS 'Full permanent address of the driver';


--
-- Name: COLUMN drivers.driving_license_number; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.drivers.driving_license_number IS 'Official driving license number issued by DMT';


--
-- Name: COLUMN drivers.license_expiry_date; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.drivers.license_expiry_date IS 'Driving license expiry date';


--
-- Name: COLUMN drivers.police_status; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.drivers.police_status IS 'Current law enforcement status of the driver';


--
-- Name: knex_migrations; Type: TABLE; Schema: public; Owner: slpvt_user
--

CREATE TABLE public.knex_migrations (
    id integer NOT NULL,
    name character varying(255),
    batch integer,
    migration_time timestamp with time zone
);


ALTER TABLE public.knex_migrations OWNER TO slpvt_user;

--
-- Name: knex_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: slpvt_user
--

CREATE SEQUENCE public.knex_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.knex_migrations_id_seq OWNER TO slpvt_user;

--
-- Name: knex_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slpvt_user
--

ALTER SEQUENCE public.knex_migrations_id_seq OWNED BY public.knex_migrations.id;


--
-- Name: knex_migrations_lock; Type: TABLE; Schema: public; Owner: slpvt_user
--

CREATE TABLE public.knex_migrations_lock (
    index integer NOT NULL,
    is_locked integer
);


ALTER TABLE public.knex_migrations_lock OWNER TO slpvt_user;

--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE; Schema: public; Owner: slpvt_user
--

CREATE SEQUENCE public.knex_migrations_lock_index_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.knex_migrations_lock_index_seq OWNER TO slpvt_user;

--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slpvt_user
--

ALTER SEQUENCE public.knex_migrations_lock_index_seq OWNED BY public.knex_migrations_lock.index;


--
-- Name: provinces; Type: TABLE; Schema: public; Owner: slpvt_user
--

CREATE TABLE public.provinces (
    province_id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.provinces OWNER TO slpvt_user;

--
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: slpvt_user
--

CREATE TABLE public.refresh_tokens (
    token_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    token_hash character varying(255) NOT NULL,
    is_used boolean DEFAULT false NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.refresh_tokens OWNER TO slpvt_user;

--
-- Name: COLUMN refresh_tokens.user_id; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.refresh_tokens.user_id IS 'User this token belongs to — cascade delete when user is removed';


--
-- Name: COLUMN refresh_tokens.token_hash; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.refresh_tokens.token_hash IS 'SHA-256 hash of the refresh token — raw token never stored';


--
-- Name: COLUMN refresh_tokens.is_used; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.refresh_tokens.is_used IS 'True if this token has already been used — detects token reuse attacks';


--
-- Name: COLUMN refresh_tokens.expires_at; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.refresh_tokens.expires_at IS 'Expiry timestamp — tokens older than this are invalid regardless of is_used';


--
-- Name: stations; Type: TABLE; Schema: public; Owner: slpvt_user
--

CREATE TABLE public.stations (
    station_id uuid DEFAULT gen_random_uuid() NOT NULL,
    station_type text NOT NULL,
    ds_division_id uuid,
    district_id uuid,
    province_id uuid,
    name character varying(150) NOT NULL,
    contact_number character varying(20),
    latitude numeric(10,7),
    longitude numeric(10,7),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT stations_station_type_check CHECK ((station_type = ANY (ARRAY['Police Post'::text, 'Division Office'::text, 'Range Office'::text, 'Police Headquarters'::text])))
);


ALTER TABLE public.stations OWNER TO slpvt_user;

--
-- Name: COLUMN stations.station_type; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.stations.station_type IS 'Type of station determines its role and jurisdiction scope';


--
-- Name: COLUMN stations.ds_division_id; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.stations.ds_division_id IS 'DS division this station belongs to';


--
-- Name: COLUMN stations.district_id; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.stations.district_id IS 'District this station belongs to';


--
-- Name: COLUMN stations.province_id; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.stations.province_id IS 'Province this district belongs to';


--
-- Name: COLUMN stations.latitude; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.stations.latitude IS 'Station location latitude';


--
-- Name: COLUMN stations.longitude; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.stations.longitude IS 'Station location longitude';


--
-- Name: tracking_devices; Type: TABLE; Schema: public; Owner: slpvt_user
--

CREATE TABLE public.tracking_devices (
    device_id uuid DEFAULT gen_random_uuid() NOT NULL,
    serial_number character varying(100) NOT NULL,
    api_key_hash character varying(255) NOT NULL,
    issued_date date NOT NULL,
    admin_status text DEFAULT 'ACTIVE'::text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT tracking_devices_admin_status_check CHECK ((admin_status = ANY (ARRAY['ACTIVE'::text, 'UNDER_REPAIR'::text, 'DECOMMISSIONED'::text])))
);


ALTER TABLE public.tracking_devices OWNER TO slpvt_user;

--
-- Name: COLUMN tracking_devices.serial_number; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.tracking_devices.serial_number IS 'Physical serial number printed on the device hardware';


--
-- Name: COLUMN tracking_devices.api_key_hash; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.tracking_devices.api_key_hash IS 'SHA-256 hash of the device API key — raw key never stored';


--
-- Name: COLUMN tracking_devices.issued_date; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.tracking_devices.issued_date IS 'Date the device was provisioned and issued';


--
-- Name: COLUMN tracking_devices.admin_status; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.tracking_devices.admin_status IS 'Operational status of the device';


--
-- Name: users; Type: TABLE; Schema: public; Owner: slpvt_user
--

CREATE TABLE public.users (
    user_id uuid DEFAULT gen_random_uuid() NOT NULL,
    badge_number character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    assigned_station_id uuid,
    system_role text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT users_system_role_check CHECK ((system_role = ANY (ARRAY['SUPER_ADMIN'::text, 'PROVINCIAL_COMMANDER'::text, 'PROVINCIAL_OFFICER'::text, 'DISTRICT_COMMANDER'::text, 'DISTRICT_OFFICER'::text, 'STATION_COMMANDER'::text, 'STATION_OFFICER'::text, 'DATA_REGISTRAR'::text, 'DEVICE_CLIENT'::text])))
);


ALTER TABLE public.users OWNER TO slpvt_user;

--
-- Name: COLUMN users.badge_number; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.users.badge_number IS 'Unique police badge number — used as login identifier';


--
-- Name: COLUMN users.password_hash; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.users.password_hash IS 'bcrypt hashed password — plain text never stored';


--
-- Name: COLUMN users.assigned_station_id; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.users.assigned_station_id IS 'Populated for station level roles';


--
-- Name: COLUMN users.system_role; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.users.system_role IS 'Determines access level and jurisdiction scope';


--
-- Name: COLUMN users.is_active; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.users.is_active IS 'Soft delete flag — false means deactivated, record retained for audit';


--
-- Name: vehicle_driver_assignments; Type: TABLE; Schema: public; Owner: slpvt_user
--

CREATE TABLE public.vehicle_driver_assignments (
    assignment_id uuid DEFAULT gen_random_uuid() NOT NULL,
    vehicle_id uuid NOT NULL,
    driver_id uuid NOT NULL,
    assigned_date date NOT NULL,
    returned_date date,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.vehicle_driver_assignments OWNER TO slpvt_user;

--
-- Name: COLUMN vehicle_driver_assignments.vehicle_id; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.vehicle_driver_assignments.vehicle_id IS 'Vehicle being assigned';


--
-- Name: COLUMN vehicle_driver_assignments.driver_id; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.vehicle_driver_assignments.driver_id IS 'Driver being assigned to the vehicle';


--
-- Name: COLUMN vehicle_driver_assignments.assigned_date; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.vehicle_driver_assignments.assigned_date IS 'Date the driver was assigned to the vehicle';


--
-- Name: COLUMN vehicle_driver_assignments.returned_date; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.vehicle_driver_assignments.returned_date IS 'Date the driver returned the vehicle — null means currently active assignment';


--
-- Name: vehicles; Type: TABLE; Schema: public; Owner: slpvt_user
--

CREATE TABLE public.vehicles (
    vehicle_id uuid DEFAULT gen_random_uuid() NOT NULL,
    registration_number character varying(20) NOT NULL,
    chassis_number character varying(50) NOT NULL,
    color character varying(50) NOT NULL,
    make_model character varying(100) NOT NULL,
    device_id uuid,
    police_status text DEFAULT 'CLEAN'::text NOT NULL,
    owner_nic character varying(20) NOT NULL,
    owner_full_name character varying(200) NOT NULL,
    owner_contact character varying(20),
    ds_division_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT vehicles_police_status_check CHECK ((police_status = ANY (ARRAY['CLEAN'::text, 'STOLEN'::text, 'WANTED'::text, 'SUSPENDED'::text])))
);


ALTER TABLE public.vehicles OWNER TO slpvt_user;

--
-- Name: COLUMN vehicles.registration_number; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.vehicles.registration_number IS 'Official DMT registration number e.g. WP CAB-1234';


--
-- Name: COLUMN vehicles.chassis_number; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.vehicles.chassis_number IS 'Vehicle chassis number from manufacturer';


--
-- Name: COLUMN vehicles.make_model; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.vehicles.make_model IS 'e.g. Bajaj RE, TVS King';


--
-- Name: COLUMN vehicles.device_id; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.vehicles.device_id IS 'Tracking device installed in this vehicle — nullable if no device assigned';


--
-- Name: COLUMN vehicles.police_status; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.vehicles.police_status IS 'Current law enforcement status of the vehicle';


--
-- Name: COLUMN vehicles.owner_nic; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.vehicles.owner_nic IS 'Owner National Identity Card number — Sri Lankan NIC format';


--
-- Name: COLUMN vehicles.owner_contact; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.vehicles.owner_contact IS 'Owner contact number in +94XXXXXXXXX format';


--
-- Name: COLUMN vehicles.ds_division_id; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.vehicles.ds_division_id IS 'DS division this station belongs to';


--
-- Name: knex_migrations id; Type: DEFAULT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.knex_migrations ALTER COLUMN id SET DEFAULT nextval('public.knex_migrations_id_seq'::regclass);


--
-- Name: knex_migrations_lock index; Type: DEFAULT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.knex_migrations_lock ALTER COLUMN index SET DEFAULT nextval('public.knex_migrations_lock_index_seq'::regclass);


--
-- Data for Name: districts; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.districts (district_id, province_id, name, created_at, updated_at) FROM stdin;
457a5e74-663c-4c64-b76a-565418cbb3cc	06e0de7f-9923-4b7a-bc27-d560e1e737f0	Colombo	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
1fe55f2c-f13a-4690-8177-ec5c60459213	06e0de7f-9923-4b7a-bc27-d560e1e737f0	Gampaha	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
a96c863e-5e82-43bf-9a2b-57a52fca1b80	06e0de7f-9923-4b7a-bc27-d560e1e737f0	Kalutara	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
f2be4257-e0f7-4b6d-b00f-dd84ffe2ec52	24a77d1b-23ae-4a8d-b3ce-16f2cc581cda	Kandy	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
1d30369c-4686-4776-9dd2-692463438d99	24a77d1b-23ae-4a8d-b3ce-16f2cc581cda	Matale	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
b1657fe1-ecbf-43fd-959a-bbf32f83bc55	24a77d1b-23ae-4a8d-b3ce-16f2cc581cda	Nuwara Eliya	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
d47feffd-7a82-437c-90d4-3d9f25460839	f611edd5-1bf0-4662-bf5f-9990c44c6c19	Galle	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
49f53434-f7fb-46bc-bb0f-a11d22cf4a44	f611edd5-1bf0-4662-bf5f-9990c44c6c19	Matara	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
bd394496-c0b3-41aa-b62f-284d79d2aac5	f611edd5-1bf0-4662-bf5f-9990c44c6c19	Hambantota	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
922c8492-a2c2-483f-b088-c9fd03b3f6b7	527ed517-6502-48a8-8b88-812c73b4995d	Jaffna	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
7e1f3790-0d95-4c8a-bed4-cc88b9c456fd	527ed517-6502-48a8-8b88-812c73b4995d	Kilinochchi	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
87f804f9-313b-4b76-8a0f-a1141a73a772	527ed517-6502-48a8-8b88-812c73b4995d	Mannar	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
b5db25c7-9ec2-42bc-b686-3b9461b09dca	527ed517-6502-48a8-8b88-812c73b4995d	Vavuniya	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
f42d6ead-eb1e-48b2-bddc-c95dd78260b9	527ed517-6502-48a8-8b88-812c73b4995d	Mullaitivu	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
373ada24-757a-4ac9-8f2d-9c5550599cf6	9deac315-bb43-412b-84b3-7cb94e7a611a	Trincomalee	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
17558b5e-6fe1-47a9-ab2e-777196a13f8e	9deac315-bb43-412b-84b3-7cb94e7a611a	Batticaloa	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
7f1135a6-b2f0-4ee9-ad08-fa9dfd5d1384	9deac315-bb43-412b-84b3-7cb94e7a611a	Ampara	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
9a9975a3-bb18-46d9-859f-6a8a47807516	bfd31493-f4d3-447f-a9ec-a7801c21b5dc	Kurunegala	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
b995e1a9-e414-4e4e-ac8c-b977fd119206	bfd31493-f4d3-447f-a9ec-a7801c21b5dc	Puttalam	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
fffbc786-141d-4e0e-8e23-3972a3a495f5	b988a4fc-d71f-44e2-868b-16dbaf1d6bac	Anuradhapura	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
40d8e913-62d6-49c8-b360-b2b0fdf61be7	b988a4fc-d71f-44e2-868b-16dbaf1d6bac	Polonnaruwa	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
d07d8231-fab6-438a-844d-e0e366b18b7f	71a89008-5751-485c-9690-c039c316b0d1	Badulla	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
99eeb492-d055-4dd9-a414-5a233ba2a3ff	71a89008-5751-485c-9690-c039c316b0d1	Monaragala	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
e2d4b5fd-0ba3-463f-a45d-786e16c7b154	d4ca0f40-cc95-4cc9-8c58-ce6fd0c9cce5	Ratnapura	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
84bbdd15-f899-46ed-9e5a-197a980c354d	d4ca0f40-cc95-4cc9-8c58-ce6fd0c9cce5	Kegalle	2026-04-25 14:17:59.032361+00	2026-04-25 14:17:59.032361+00
\.


--
-- Data for Name: divisional_secretariats; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.divisional_secretariats (ds_division_id, district_id, name, created_at, updated_at) FROM stdin;
e56d85a6-8adc-4ef4-a8c7-a73363415b04	457a5e74-663c-4c64-b76a-565418cbb3cc	Colombo	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
6f4505e2-e82a-4476-be62-37e3a72719f5	457a5e74-663c-4c64-b76a-565418cbb3cc	Dehiwala-MountLavinia	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
271f0bf8-6856-4232-8338-3da20373e733	457a5e74-663c-4c64-b76a-565418cbb3cc	Homagama	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
23e935dc-5df8-431d-a5af-929cfc9c719f	457a5e74-663c-4c64-b76a-565418cbb3cc	Kaduwela	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
015da7d7-6d1f-4a6a-9c2e-c349f8a95517	457a5e74-663c-4c64-b76a-565418cbb3cc	Kesbewa	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
9b64dd36-0061-4ca0-bb7f-ee1545eb0fa4	457a5e74-663c-4c64-b76a-565418cbb3cc	SriJayawardanapuraKotte	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
149ffe17-b992-4f01-9172-b326792e23a7	457a5e74-663c-4c64-b76a-565418cbb3cc	Thimbirigasyaya	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
1b108646-fc07-4eda-8c37-8f9a8ae50db3	1fe55f2c-f13a-4690-8177-ec5c60459213	Ja-Ela	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
04deeaf8-d443-40ce-9ee9-06e80159dd09	1fe55f2c-f13a-4690-8177-ec5c60459213	Kelaniya	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
6632cd97-4b95-46ff-adaf-d6d927035f58	1fe55f2c-f13a-4690-8177-ec5c60459213	Negombo	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
c5e35455-05f1-4d1f-8be9-e2896c16a58a	1fe55f2c-f13a-4690-8177-ec5c60459213	Wattala	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
bf848422-face-42a9-b51c-63284c38ba13	a96c863e-5e82-43bf-9a2b-57a52fca1b80	Horana	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
a6facf79-f149-47d0-ad68-bfe9d30b88d8	a96c863e-5e82-43bf-9a2b-57a52fca1b80	Bandaragama	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
ec8a93e7-c100-43c5-94de-1cec705443a4	a96c863e-5e82-43bf-9a2b-57a52fca1b80	Ingiriya	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
5de7741b-b338-4bc9-95fc-8820fedecc6f	a96c863e-5e82-43bf-9a2b-57a52fca1b80	Panadura	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
0095b334-c326-48b5-a41c-9fd5b5dda379	f2be4257-e0f7-4b6d-b00f-dd84ffe2ec52	Medadumbara	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
d0fc0ce1-239d-4a48-b421-3a0edd246c38	f2be4257-e0f7-4b6d-b00f-dd84ffe2ec52	Minipe	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
0ca8420a-c7d1-4089-98cd-c5e9661f3eae	f2be4257-e0f7-4b6d-b00f-dd84ffe2ec52	Thumpane	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
40cff250-f441-46f0-9a98-cc85a71a0e36	f2be4257-e0f7-4b6d-b00f-dd84ffe2ec52	Udunuwara	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
bbebc644-86ee-48ec-b2a4-807f9cf3b380	d47feffd-7a82-437c-90d4-3d9f25460839	Ambalangoda	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
0333f668-c304-4421-9e8f-934a51f3265a	d47feffd-7a82-437c-90d4-3d9f25460839	Baddegama	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
b269596a-d674-4dec-8f66-76941dcf88f6	d47feffd-7a82-437c-90d4-3d9f25460839	Balapitiya	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
6ebadced-812f-4f17-aa5f-447653cf3b26	d47feffd-7a82-437c-90d4-3d9f25460839	Elpitiya	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
7f0b360b-1415-4fc8-9508-43b4580bbe8f	d47feffd-7a82-437c-90d4-3d9f25460839	Hikkaduwa	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
7a5a7332-05a9-49d8-abf3-0d5debb8fa41	49f53434-f7fb-46bc-bb0f-a11d22cf4a44	Devinuwara	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
2e63e462-cd35-4b9d-ab7f-fb7e41fc37d2	49f53434-f7fb-46bc-bb0f-a11d22cf4a44	Dickwella	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
48c99c75-6d98-48dc-ab3d-430018722358	49f53434-f7fb-46bc-bb0f-a11d22cf4a44	Mulatiyana	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
720aac09-5422-4255-84d9-620d7a44a666	49f53434-f7fb-46bc-bb0f-a11d22cf4a44	Pitabeddara	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
58c58573-02dc-4cc9-aa49-27c5ccada8a7	49f53434-f7fb-46bc-bb0f-a11d22cf4a44	Weligama	2026-04-25 14:17:59.035874+00	2026-04-25 14:17:59.035874+00
\.


--
-- Data for Name: drivers; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.drivers (driver_id, first_name, last_name, permanent_address, driving_license_number, license_expiry_date, police_status, created_at, updated_at) FROM stdin;
7e098648-089f-4d53-a670-a5958b669fc0	Chamari	Perera	No. 89, Galle Road, Kalutara	B000000	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
3882ff72-6dcc-40df-a5d5-a45dc6b802f6	Sachith	Weerasinghe	No. 34, Station Road, Panadura	B000001	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
b805fe3e-2151-433c-8781-311a2a749d47	Upul	Pathirana	No. 23, High Level Road, Homagama	B000002	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
44faf91f-439f-4dde-9c58-40df6d3eaf78	Nuwan	Gunaratne	No. 34, Station Road, Panadura	B000003	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
c315d123-0ff1-4faa-a245-4c8276dd09df	Isuru	Mendis	No. 54, Lake Road, Kaduwela	B000004	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
2561cb27-85be-4574-8a86-4d9c042badf8	Chaminda	Bandara	No. 15, Peradeniya Road, Kandy	B000005	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
109b545f-6e6b-4b39-82fa-77c63c9bb341	Nadeesha	Gunasekara	No. 78, Main Street, Negombo	B000006	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
8287ad71-0402-4c94-8cd2-5dd3560b7711	Iresha	Gunaratne	No. 89, Galle Road, Kalutara	B000007	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
4dad2d4e-efff-46ca-93c4-25f9fec260a0	Buddika	Rajapaksa	No. 78, Main Street, Negombo	B000008	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
a62119c9-a596-40d3-ac80-b9c6d36ba898	Janaka	Liyanage	No. 12, Kandy Road, Kelaniya	B000009	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
cd66834c-f062-4497-adae-1abb254e94da	Sachith	Seneviratne	No. 91, Marine Drive, Galle	B000010	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
101e0d1c-983e-4923-960e-e347255da100	Dilini	Seneviratne	No. 12, Kandy Road, Kelaniya	B000011	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
8c0b80e0-24f4-4b99-9843-c07d182bd3c3	Isuru	Abeysekara	No. 72, New Road, Horana	B000012	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
59c9ab34-a85c-4fe6-925a-388d7d1bdf95	Rashmi	Seneviratne	No. 67, Colombo Road, Gampaha	B000013	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
dbaaaf0f-cce8-4096-af5b-3da9f5c88b01	Sachith	Senanayake	No. 91, Marine Drive, Galle	B000014	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
1035989e-7972-415f-9cdd-47d23b76e5a5	Prasad	Jayawardena	No. 56, Highlevel Road, Nugegoda	B000015	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
7fff8483-ccef-43b9-86ac-cce917743119	Suresh	Kumara	No. 72, New Road, Horana	B000016	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
45096544-f036-4309-a990-2d2ebab91b54	Iresha	Bandara	No. 43, Matara Road, Weligama	B000017	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
87454dc5-7755-4221-9e37-c91803090acc	Prasad	Mendis	No. 43, Matara Road, Weligama	B000018	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
b6ba0002-9890-40ca-993b-faf692647b44	Kasun	Wickramasinghe	No. 54, Lake Road, Kaduwela	B000019	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
1c0fd61a-4ecc-44d8-a7b9-db9bd54fe187	Nadun	Perera	No. 56, Highlevel Road, Nugegoda	B000020	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
e937955f-973c-4c42-812e-aa74201ff043	Isuru	Pathirana	No. 56, Highlevel Road, Nugegoda	B000021	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
38185eb7-1336-45ea-a89f-c5328cd1b05a	Upul	Seneviratne	No. 15, Peradeniya Road, Kandy	B000022	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
9a7bba17-7031-40e2-919c-8de5ba129c04	Sachini	Senanayake	No. 23, High Level Road, Homagama	B000023	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
5cc7612c-578c-4cd2-8a8b-b75dd497ff37	Thilak	Rathnayake	No. 91, Marine Drive, Galle	B000024	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
4ddc29c3-f841-4960-9ffb-e2efc4503a67	Sandya	Wijesinghe	No. 45, Galle Road, Colombo 03	B000025	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
59f8b2f4-11a6-4140-961b-4b9a78e7d4e5	Menaka	Senanayake	No. 36, Temple Road, Bandaragama	B000026	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
450ac882-73d0-4e89-941c-e72fb48829b3	Kumari	Seneviratne	No. 12, Kandy Road, Kelaniya	B000027	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
700eab92-d34b-45c1-8404-87bbc2eb2154	Malith	Jayasuriya	No. 36, Temple Road, Bandaragama	B000028	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
73cee5f1-8fa9-42ca-9be9-61d27eea5cf8	Buddika	Gunaratne	No. 89, Galle Road, Kalutara	B000029	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
0752b552-f498-4823-ac06-da20114afcac	Janaka	Weerasinghe	No. 34, Station Road, Panadura	B000030	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
b5a342f4-dfc8-4c21-85a0-8178896d969b	Hirantha	Bandara	No. 36, Temple Road, Bandaragama	B000031	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
9d27620c-9ed3-4013-99ce-3bba0d1adf6e	Dhanushka	Dissanayake	No. 15, Peradeniya Road, Kandy	B000032	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
a2f31f50-d000-45dd-bff7-1f2275e96e1d	Pradeep	Senanayake	No. 15, Peradeniya Road, Kandy	B000033	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
21d7d0f0-3501-476b-b958-a3cb34d5bdd3	Dilini	Wickramasinghe	No. 91, Marine Drive, Galle	B000034	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
f22b556e-4ea0-4e9a-bede-a156b7179cd8	Menaka	Ranasinghe	No. 56, Highlevel Road, Nugegoda	B000035	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
5aa3fc45-7c44-4441-8c08-94856dd1ab29	Sewwandi	Amarasinghe	No. 78, Main Street, Negombo	B000036	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
a237c74b-6565-4c5c-a796-a79cecc0e301	Kamal	Kumara	No. 34, Station Road, Panadura	B000037	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
e283e58d-2772-4d47-b021-b099d6f268f1	Dhanushka	Madushanka	No. 15, Peradeniya Road, Kandy	B000038	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
7dc992ca-7967-46ce-952b-f337f394b747	Sewwandi	Bandara	No. 91, Marine Drive, Galle	B000039	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
acaf9e1a-6b02-44e5-8d1b-12edec181d17	Kasun	Gunaratne	No. 23, High Level Road, Homagama	B000040	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
f3a5bac5-7e8a-47a0-8555-b8d8de5682a3	Ruwan	Jayasuriya	No. 54, Lake Road, Kaduwela	B000041	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
671f70df-8283-4009-96c4-7e082ab8f7fb	Hirantha	Weerasinghe	No. 12, Kandy Road, Kelaniya	B000042	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
53c40e46-167d-43ce-bd96-3f79869a8371	Kumari	Jayasuriya	No. 23, High Level Road, Homagama	B000043	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
79e87f9b-c5d8-43e4-b9c9-80e5b0a901b3	Thilini	Wickramasinghe	No. 72, New Road, Horana	B000044	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
a169df00-33e9-498d-b178-1ff1e6c90418	Nimasha	Abeysekara	No. 34, Station Road, Panadura	B000045	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
97095519-99f1-4be1-a7bb-e795f3c7e4f2	Kamal	Amarasinghe	No. 23, High Level Road, Homagama	B000046	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
46921737-73b7-47b0-a242-d4eec15a6cb6	Nadeesha	Gunaratne	No. 91, Marine Drive, Galle	B000047	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
68dfb904-1c96-414b-9d6a-c3603b5948b1	Isuru	Liyanage	No. 45, Galle Road, Colombo 03	B000048	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
ce51136b-2bdc-4cda-b33c-710e1dbf466f	Thilak	Perera	No. 45, Galle Road, Colombo 03	B000049	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
eda03964-fe88-4315-a9a5-847773db4e32	Gayan	Pathirana	No. 34, Station Road, Panadura	B000050	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
bb7ce614-40f3-4561-ad5a-633a4f19e2d6	Isuru	Gunaratne	No. 36, Temple Road, Bandaragama	B000051	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
ada97d37-d75e-43ca-9edc-0bb83c6e4d8c	Dilshan	Pathirana	No. 56, Highlevel Road, Nugegoda	B000052	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
9573d1d5-f160-43e4-b14b-e352bef57c07	Nadun	Rathnayake	No. 78, Main Street, Negombo	B000053	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
e2f0bfb8-f53b-4dc7-9948-01e8e74b76dc	Sachini	Dissanayake	No. 67, Colombo Road, Gampaha	B000054	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
4a97227d-dff4-4450-a51a-87ad81c659a4	Saman	Gunaratne	No. 15, Peradeniya Road, Kandy	B000055	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
964915a0-0ce2-4869-b255-7e2b2a64f0e1	Isuru	Perera	No. 12, Kandy Road, Kelaniya	B000056	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
3e078737-1335-4ec2-bad5-785ebd350d1f	Nimasha	Liyanage	No. 34, Station Road, Panadura	B000057	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
01c1d82e-51f3-40ce-8aee-9a8439594916	Chamari	Ranasinghe	No. 43, Matara Road, Weligama	B000058	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
319452b6-73b6-4f3f-8ad5-8f2a4e28279d	Dhanushka	Bandara	No. 12, Kandy Road, Kelaniya	B000059	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
3c36ae74-a41b-49a7-a969-08f9070fab4e	Janaka	Fernando	No. 54, Lake Road, Kaduwela	B000060	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
e66e6203-6239-4c1f-9dfa-78aab779f8ea	Tharaka	Silva	No. 34, Station Road, Panadura	B000061	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
6ed71676-d23e-429b-a80f-b030415bd81d	Pradeep	Perera	No. 28, Hospital Road, Matara	B000062	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
418c2038-2101-4b3c-b7e8-79fa0b909e77	Buddika	Herath	No. 89, Galle Road, Kalutara	B000063	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
8076e0ec-b6b5-4de3-a7eb-bc808d4f9a8e	Tharaka	Herath	No. 43, Matara Road, Weligama	B000064	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
56c1f9c5-a3cd-4849-b09b-a8de39f9c4ad	Pavithra	Pathirana	No. 45, Galle Road, Colombo 03	B000065	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
6ed50aae-e0ed-4090-aad2-9275e76c9738	Harsha	Ranasinghe	No. 54, Lake Road, Kaduwela	B000066	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
af95e8af-df77-4891-bf3d-b136b1aa3af1	Dhanushka	Mendis	No. 23, High Level Road, Homagama	B000067	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
b0d24f78-368a-4c17-a210-7f02d1810f62	Mahesh	Silva	No. 72, New Road, Horana	B000068	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
4ad35052-e706-43e8-a41d-f719fa3281ea	Kumari	Bandara	No. 78, Main Street, Negombo	B000069	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
f59ae2fc-1be5-4b47-a26c-9de87d246eca	Iresha	Jayasuriya	No. 45, Galle Road, Colombo 03	B000070	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
002a6ebe-922b-43a6-9824-260382b35375	Buddika	Fernando	No. 45, Galle Road, Colombo 03	B000071	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
d882deb4-55c3-4561-98fd-7a7c7f77512c	Prasad	Wijesinghe	No. 36, Temple Road, Bandaragama	B000072	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
03f4546c-99de-4d6c-a3f0-15af749c8b6a	Chathurika	Weerasinghe	No. 15, Peradeniya Road, Kandy	B000073	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
efdb1dd0-95f3-4d67-b995-3fe03be948bd	Dilshan	Jayawardena	No. 12, Kandy Road, Kelaniya	B000074	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
b8f00fb5-fe7c-4e7e-a270-409062c7ddf8	Thilini	Seneviratne	No. 45, Galle Road, Colombo 03	B000075	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
3c705cf6-f081-46ba-8916-56b529900b6b	Menaka	Herath	No. 78, Main Street, Negombo	B000076	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
8df13196-315e-4c8a-a4c0-096c48170ffb	Sachini	Jayasuriya	No. 23, High Level Road, Homagama	B000077	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
ff767a59-727f-4943-a5ea-a40d18a8bf13	Tharaka	Rajapaksa	No. 91, Marine Drive, Galle	B000078	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
4c33cfac-f759-4e9e-ab96-9412fc2fb9b2	Sewwandi	Gunaratne	No. 89, Galle Road, Kalutara	B000079	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
08cc14d5-5154-4de4-a744-5e96278413c3	Gayan	Liyanage	No. 28, Hospital Road, Matara	B000080	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
8e42d1fb-b1e2-499e-8fc3-dd738e564fa1	Tharaka	Jayawardena	No. 28, Hospital Road, Matara	B000081	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
dded94b0-39ba-4bb9-91c7-0392cbe7653a	Harsha	Herath	No. 28, Hospital Road, Matara	B000082	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
ee7018ef-65ac-444a-8134-fffc526902cb	Sewwandi	Amarasinghe	No. 54, Lake Road, Kaduwela	B000083	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
51bef558-a606-49b9-bec4-d5905854c480	Harsha	Bandara	No. 43, Matara Road, Weligama	B000084	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
dc0f7235-6fa0-4b12-a3a0-29accd74323e	Isuru	Pathirana	No. 15, Peradeniya Road, Kandy	B000085	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
31e37ae5-de3f-4ae0-8369-1ebb9aa268ef	Prasad	Seneviratne	No. 91, Marine Drive, Galle	B000086	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
a786bf5f-5464-48c2-bd5c-e3d44f3b6f4f	Mahesh	Jayawardena	No. 12, Kandy Road, Kelaniya	B000087	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
b6181689-9e85-4883-bf7d-3fb93fb4d098	Shehan	Jayasuriya	No. 15, Peradeniya Road, Kandy	B000088	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
0ef1441b-7ae2-4e43-9a11-e149344104e4	Prasad	Liyanage	No. 12, Kandy Road, Kelaniya	B000089	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
7a1ca14f-dd36-4e6c-9274-41b54f82f374	Gayan	Pathirana	No. 43, Matara Road, Weligama	B000090	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
46c761c3-d68b-446f-b7d5-52abfed7a796	Nadun	Seneviratne	No. 36, Temple Road, Bandaragama	B000091	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
18874dee-1583-4122-8053-974d50d65b61	Buddika	Ranasinghe	No. 67, Colombo Road, Gampaha	B000092	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
6469f15b-d4c6-4219-9f7a-6b1468665e79	Isuru	Liyanage	No. 78, Main Street, Negombo	B000093	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
0e901d4b-9e06-4866-a03a-abbd45626b8a	Buddika	Senanayake	No. 91, Marine Drive, Galle	B000094	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
c90f7c0b-57f2-4d3e-932e-8d7c518310e2	Mahesh	Pathirana	No. 89, Galle Road, Kalutara	B000095	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
6c336d3b-82a8-4e23-a120-12f89a9f405c	Gayan	Jayasuriya	No. 72, New Road, Horana	B000096	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
d3e4d47e-3843-4297-9b21-3f29f5160130	Upul	Ranasinghe	No. 34, Station Road, Panadura	B000097	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
9f8da43f-9e72-4ecd-9839-e6d06e83d458	Chathurika	Senanayake	No. 36, Temple Road, Bandaragama	B000098	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
ff0b3382-6aff-4c98-93c8-0a5fb748637b	Upul	Pathirana	No. 23, High Level Road, Homagama	B000099	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
9409c24a-f7d8-4fb0-9ad7-5fb4ef1c9b64	Prasad	Madushanka	No. 43, Matara Road, Weligama	B000100	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
44cede87-02fb-470a-89e0-6530f825e689	Lasith	Abeysekara	No. 45, Galle Road, Colombo 03	B000101	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
9bc2a72d-a3af-4cc3-ae83-3dd19b651286	Thilak	Seneviratne	No. 28, Hospital Road, Matara	B000102	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
67f4ac31-a382-43b2-b1a4-3bff8c909369	Malith	Senanayake	No. 78, Main Street, Negombo	B000103	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
6b0139d9-5fac-4aa2-8104-af2b2dae34ae	Pradeep	Gunaratne	No. 28, Hospital Road, Matara	B000104	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
d41fe21a-f678-4ae0-af85-9bd07b638960	Suresh	Perera	No. 89, Galle Road, Kalutara	B000105	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
2728a542-39fd-4542-90bb-f0e4004da248	Nadun	Jayawardena	No. 54, Lake Road, Kaduwela	B000106	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
05b2cc75-93ea-45c9-8998-32bea4981e01	Prasad	Mendis	No. 36, Temple Road, Bandaragama	B000107	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
a1e68931-5169-402b-af56-568655186206	Menaka	Madushanka	No. 34, Station Road, Panadura	B000108	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
1805839b-9d84-4e88-b4dd-fdd611c6f273	Chathura	Silva	No. 43, Matara Road, Weligama	B000109	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
e42d0ecf-119f-4166-91d2-ce939d22d563	Dhanushka	Liyanage	No. 91, Marine Drive, Galle	B000110	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
e12480b6-e39a-457e-a9fe-d764530c3c5b	Asanka	Madushanka	No. 34, Station Road, Panadura	B000111	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
d4b8e5ea-dffe-46df-a0d9-dd5180a750c3	Chaminda	Madushanka	No. 36, Temple Road, Bandaragama	B000112	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
9363549e-0a65-40fd-8644-1aefa5d767b5	Mahesh	Rajapaksa	No. 36, Temple Road, Bandaragama	B000113	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
af68e08f-7801-407d-a62f-1d206ceb8579	Sachith	Abeysekara	No. 56, Highlevel Road, Nugegoda	B000114	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
b669caff-5e66-4795-9cdb-7e82db0f74bf	Chaminda	Rathnayake	No. 45, Galle Road, Colombo 03	B000115	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
f2fe2a27-0ffd-4931-ae36-cd8e6dc79a84	Pradeep	Mendis	No. 36, Temple Road, Bandaragama	B000116	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
1d554225-3149-4b0a-99a2-03b0e5aef7f5	Sewwandi	Jayasuriya	No. 89, Galle Road, Kalutara	B000117	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
17cee7aa-561d-4ce5-a75b-976135068927	Buddika	Gunasekara	No. 78, Main Street, Negombo	B000118	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
05358ee1-2d8e-4321-9c5a-41860da7bb8d	Menaka	Gunasekara	No. 56, Highlevel Road, Nugegoda	B000119	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
3336e92f-175c-4c0b-9aa0-7689230e5dee	Saman	Liyanage	No. 72, New Road, Horana	B000120	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
040d2702-9dae-4b9b-9b21-ffd193b53e5e	Chaminda	Mendis	No. 12, Kandy Road, Kelaniya	B000121	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
f04786b6-42b5-4c7a-b527-3b18ba9f0e6b	Nuwan	Abeysekara	No. 28, Hospital Road, Matara	B000122	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
8e72fd1c-57f3-4450-a8f5-6e9a2b95d362	Chamari	Mendis	No. 43, Matara Road, Weligama	B000123	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
9b2b5635-3b3e-49e8-998f-87fb2d7bd3b0	Menaka	Kumara	No. 12, Kandy Road, Kelaniya	B000124	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
d844b787-ef44-4820-80d8-1cf04a5f14fa	Thilini	Wijesinghe	No. 78, Main Street, Negombo	B000125	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
b76cd552-1611-442c-9d40-eb981864c0b0	Sandya	Herath	No. 78, Main Street, Negombo	B000126	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
7c470c8a-c70b-43a8-86e7-d439444eccdb	Thilak	Dissanayake	No. 34, Station Road, Panadura	B000127	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
543ec8c9-92e7-474d-826d-f408ecd5caa6	Dilini	Bandara	No. 67, Colombo Road, Gampaha	B000128	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
505cdc94-bc3a-4967-972e-1f4c98a3d216	Chamari	Fernando	No. 15, Peradeniya Road, Kandy	B000129	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
bb92d68f-c0b7-4b9b-9580-59abfb4882d4	Kasun	Wickramasinghe	No. 23, High Level Road, Homagama	B000130	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
4b16fa4f-3e9b-4153-a423-c00f47b1073e	Sewwandi	Rajapaksa	No. 28, Hospital Road, Matara	B000131	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
d9dac0a1-a3c9-45ff-b8bf-190647976900	Thilak	Jayasuriya	No. 78, Main Street, Negombo	B000132	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
8be52721-9db4-481a-8937-c938132ada91	Chaminda	Dissanayake	No. 67, Colombo Road, Gampaha	B000133	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
3982d8fd-6883-4e73-98c8-3646c6aaf45a	Kamal	Fernando	No. 54, Lake Road, Kaduwela	B000134	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
5918066e-8546-4cc0-b05a-63e0dfd5fb50	Pavithra	Liyanage	No. 91, Marine Drive, Galle	B000135	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
9e1d5252-8bf0-4931-88a1-3633b3b9cf23	Pradeep	Gunasekara	No. 34, Station Road, Panadura	B000136	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
ceb1c66c-85ef-4929-85dd-2e5a019139d1	Menaka	Wickramasinghe	No. 23, High Level Road, Homagama	B000137	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
acc78ec0-e104-4d49-9e4f-289782c77978	Hirantha	Herath	No. 89, Galle Road, Kalutara	B000138	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
ada48545-13d1-407f-a881-f2cd67c6a193	Chathura	Wijesinghe	No. 12, Kandy Road, Kelaniya	B000139	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
527c5198-8e2e-41a1-a868-1afd41656b71	Suresh	Jayasuriya	No. 91, Marine Drive, Galle	B000140	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
05a23f88-77ba-43a3-9756-9a3e6470b8f1	Pradeep	Silva	No. 54, Lake Road, Kaduwela	B000141	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
001f7b77-a6ca-451d-937b-0b3f8383499c	Ruwan	Dissanayake	No. 89, Galle Road, Kalutara	B000142	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
5d1c1cd2-3f97-4dd7-8f1d-d3fe36f39157	Buddika	Wickramasinghe	No. 78, Main Street, Negombo	B000143	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
518e79b8-9d51-41b7-839b-c027e27dce04	Sachini	Wijesinghe	No. 54, Lake Road, Kaduwela	B000144	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
0879ee02-ada0-461b-a1c8-9d392fe1b4c8	Chathura	Seneviratne	No. 23, High Level Road, Homagama	B000145	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
13623b36-ad4f-4269-b062-88e1df9979ee	Lasith	Rajapaksa	No. 28, Hospital Road, Matara	B000146	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
aae22339-e47c-44ff-a476-10709b94be81	Dhanushka	Herath	No. 78, Main Street, Negombo	B000147	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
878943df-aff2-4b1d-a884-1c24b7f58b71	Harsha	Madushanka	No. 43, Matara Road, Weligama	B000148	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
0fe99a72-2d7f-4316-a826-6ebd990fbacf	Nadeesha	Mendis	No. 34, Station Road, Panadura	B000149	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
af8cb819-45b4-4c48-a953-0d5f920a2acd	Ruwan	Ranasinghe	No. 91, Marine Drive, Galle	B000150	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
4d2dd3d2-1e57-442c-95ef-c9937d91b65f	Kumari	Rajapaksa	No. 34, Station Road, Panadura	B000151	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
1b39892e-ba0b-44f6-9314-c3c13a86d28b	Dilshan	Bandara	No. 67, Colombo Road, Gampaha	B000152	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
16580cdc-7412-4d83-b0c0-de2a04a6a088	Saman	Dissanayake	No. 12, Kandy Road, Kelaniya	B000153	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
e12af0e0-f7ad-4abc-be36-aed40ab26b6a	Suresh	Abeysekara	No. 45, Galle Road, Colombo 03	B000154	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
308f4d8f-a5fa-420d-9333-e8b819e9ba7e	Kasun	Abeysekara	No. 67, Colombo Road, Gampaha	B000155	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
a1444e90-2730-4d44-96af-17ae49b83fac	Kasun	Rathnayake	No. 34, Station Road, Panadura	B000156	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
4232d345-9679-433d-9081-0cf76511a9cd	Nimasha	Kumara	No. 78, Main Street, Negombo	B000157	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
fc1724d2-2dcc-4b5c-97e1-75ebf77eca2e	Malith	Dissanayake	No. 91, Marine Drive, Galle	B000158	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
0e9b9a4c-8641-49b3-8565-5c2879389cfe	Dilini	Gunasekara	No. 36, Temple Road, Bandaragama	B000159	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
becb4e4f-e14c-4c4a-bf67-6d50d24d29ec	Ruwan	Abeysekara	No. 15, Peradeniya Road, Kandy	B000160	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
65c30f9e-57e1-48b7-a4a7-7cd439f5e0a8	Dhanushka	Rathnayake	No. 12, Kandy Road, Kelaniya	B000161	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
4378226e-ca7b-452e-ae11-c9fd611e7b66	Nadeesha	Gunaratne	No. 36, Temple Road, Bandaragama	B000162	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
9a333cc1-2dec-4000-9d52-70b9285d821a	Iresha	Weerasinghe	No. 91, Marine Drive, Galle	B000163	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
4b3fd9f5-f609-4941-8876-abaeb365a0e6	Prasad	Gunaratne	No. 78, Main Street, Negombo	B000164	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
66ec16a3-2887-4e9c-b708-e7ce7c4c708d	Thilak	Rathnayake	No. 78, Main Street, Negombo	B000165	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
30522d09-bc69-4bb3-9c7d-133870985bc8	Dilshan	Fernando	No. 72, New Road, Horana	B000166	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
35eebec5-afff-4ac4-b75a-89125506a5de	Roshan	Amarasinghe	No. 43, Matara Road, Weligama	B000167	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
f2d0a295-6cb3-4c16-be65-7c6d7c291741	Sachini	Weerasinghe	No. 78, Main Street, Negombo	B000168	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
c694ea8f-981d-43a5-8644-1ecc7ec9b8ed	Dhanushka	Pathirana	No. 56, Highlevel Road, Nugegoda	B000169	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
f9c7abbd-0dba-4119-ad01-9143c27ade84	Isuru	Jayawardena	No. 54, Lake Road, Kaduwela	B000170	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
bec74f92-3970-4d2f-93cd-1e3ec240b1e5	Gayan	Rajapaksa	No. 43, Matara Road, Weligama	B000171	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
cf20d58f-2937-4b7b-b862-ebf09574942e	Tharaka	Kumara	No. 91, Marine Drive, Galle	B000172	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
fe3f3387-f5b6-4c62-9268-72f57e4abe2d	Chaminda	Silva	No. 43, Matara Road, Weligama	B000173	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
781cdfe3-df71-4884-b8c7-75df5740a4df	Dhanushka	Liyanage	No. 78, Main Street, Negombo	B000174	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
dc654026-f7cf-4893-afe1-503f565d601f	Nadeesha	Gunaratne	No. 36, Temple Road, Bandaragama	B000175	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
d10b0760-ed5d-49b7-b1ff-761daa27ad42	Pradeep	Seneviratne	No. 12, Kandy Road, Kelaniya	B000176	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
af69b856-85d2-4c1d-beec-d0b685d34561	Isuru	Bandara	No. 78, Main Street, Negombo	B000177	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
c95d945a-c454-4c9d-a7ed-432df0afaf31	Nimal	Jayawardena	No. 78, Main Street, Negombo	B000178	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
d5b5e225-b72d-4fe8-9afd-bb38dc948591	Thilini	Gunaratne	No. 45, Galle Road, Colombo 03	B000179	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
98726b6c-5217-4605-a68a-846652fcab0a	Sandya	Weerasinghe	No. 56, Highlevel Road, Nugegoda	B000180	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
6675c0f7-2674-4428-b4c4-cd8f6ac5e57b	Sandya	Senanayake	No. 15, Peradeniya Road, Kandy	B000181	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
5bc48e03-2a59-4854-ba98-b1aedf7107cd	Janaka	Jayawardena	No. 23, High Level Road, Homagama	B000182	2030-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
60d98ac6-70cd-4a4f-9c6e-8d25655d754f	Sachini	Abeysekara	No. 45, Galle Road, Colombo 03	B000183	2031-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
7de4cfac-708a-445f-9c33-c3799d64c005	Gayan	Ranasinghe	No. 45, Galle Road, Colombo 03	B000184	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
bd69eaab-908c-44ab-bb83-cd4b3f4130df	Hirantha	Silva	No. 43, Matara Road, Weligama	B000185	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
61c0f24f-e1b8-4d32-96ae-b8aca81d1322	Pradeep	Ranasinghe	No. 15, Peradeniya Road, Kandy	B000186	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
51d728b9-f3da-490d-b8fc-8f5c0f86fcba	Nimal	Fernando	No. 34, Station Road, Panadura	B000187	2033-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
378f435c-8166-4d90-8b28-037f4538bca7	Hirantha	Abeysekara	No. 89, Galle Road, Kalutara	B000188	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
5feba92b-7750-428a-8856-33abe6b8354a	Mahesh	Jayawardena	No. 91, Marine Drive, Galle	B000189	2034-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
e27f7db3-e909-45e6-b059-54764f912f1c	Saman	Weerasinghe	No. 43, Matara Road, Weligama	B000190	2032-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
bf75c0b8-dd04-4161-9ec2-2dad64966988	Upul	Dissanayake	No. 67, Colombo Road, Gampaha	B000191	2027-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
86895ac3-2731-46ea-8036-8ebe8b80b4ca	Rashmi	Madushanka	No. 36, Temple Road, Bandaragama	B000192	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
0f1ce726-73c3-4dbe-b6d5-4f5ad7949f62	Kasun	Perera	No. 67, Colombo Road, Gampaha	B000193	2028-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
d684ae4e-40c9-4ab8-bc2d-a5a674aa9813	Suresh	Silva	No. 36, Temple Road, Bandaragama	B000194	2029-04-25	CLEAR	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
bf4967bf-5863-4788-9091-f0e29a15d21f	Dilini	Dissanayake	No. 45, Galle Road, Colombo 03	B000195	2033-04-25	WANTED	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
331c35f9-6ed1-405d-9c16-34895732e0da	Chaminda	Senanayake	No. 54, Lake Road, Kaduwela	B000196	2029-04-25	WANTED	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
bb2bbe26-b9fb-432a-a017-4559710e46a2	Sewwandi	Weerasinghe	No. 54, Lake Road, Kaduwela	B000197	2028-04-25	WANTED	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
70784432-0dbb-4d6f-a8bc-c43cb78c991e	Janaka	Pathirana	No. 45, Galle Road, Colombo 03	B000198	2028-04-25	WANTED	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
164a6930-516d-41bc-bcf5-e76e2ebc4c41	Nimal	Ranasinghe	No. 67, Colombo Road, Gampaha	B000199	2033-04-25	WANTED	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
85c89f14-d46e-4c60-bc67-fd5c3335968d	Chathura	Gunasekara	No. 89, Galle Road, Kalutara	B000200	2027-04-25	WANTED	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
192a3041-7c47-4e02-a483-c5cf07da4243	Nimasha	Weerasinghe	No. 12, Kandy Road, Kelaniya	B000201	2033-04-25	WANTED	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
3fc7d71c-0895-485b-9d2f-1918855a1910	Shehan	Gunaratne	No. 67, Colombo Road, Gampaha	B000202	2034-04-25	WANTED	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
0c9160fe-d060-456f-b235-a83ba5bb2d50	Nimal	Pathirana	No. 34, Station Road, Panadura	B000203	2029-04-25	WANTED	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
bfb58d0a-9738-4905-bdaa-a405179dfb0b	Lasith	Gunaratne	No. 12, Kandy Road, Kelaniya	B000204	2030-04-25	WANTED	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
dc444e9d-3b18-4db0-a3e1-3b768dabf8aa	Asanka	Wijesinghe	No. 45, Galle Road, Colombo 03	B000205	2028-04-25	SUSPENDED_LICENSE	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
e8d33fee-f44d-4dea-b109-a181188befd2	Thilak	Liyanage	No. 54, Lake Road, Kaduwela	B000206	2027-04-25	SUSPENDED_LICENSE	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
9c5aba10-841a-4c88-89da-04366e18c2e9	Menaka	Perera	No. 28, Hospital Road, Matara	B000207	2030-04-25	SUSPENDED_LICENSE	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
37bc4a9a-c98e-49fd-8248-cc7e0c3c62ac	Suresh	Seneviratne	No. 28, Hospital Road, Matara	B000208	2028-04-25	SUSPENDED_LICENSE	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
6cd40fb0-d5b3-40d9-96ed-c8a0620d8cce	Hirantha	Jayasuriya	No. 12, Kandy Road, Kelaniya	B000209	2029-04-25	SUSPENDED_LICENSE	2026-04-25 14:17:59.271088+00	2026-04-25 14:17:59.271088+00
\.


--
-- Data for Name: knex_migrations; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.knex_migrations (id, name, batch, migration_time) FROM stdin;
1	20260424152803_001_create_provinces.js	1	2026-04-25 14:17:53.808+00
2	20260424152895_002_create_districts.js	1	2026-04-25 14:17:53.814+00
3	20260424152900_003_create_divisional_secretariats.js	1	2026-04-25 14:17:53.818+00
4	20260424154922_004_create_stations.js	1	2026-04-25 14:17:53.822+00
5	20260424154929_005_create_users.js	1	2026-04-25 14:17:53.826+00
6	20260424154936_006_create_tracking_devices.js	1	2026-04-25 14:17:53.83+00
7	20260424154942_007_create_vehicles.js	1	2026-04-25 14:17:53.835+00
8	20260424154949_008_create_drivers.js	1	2026-04-25 14:17:53.837+00
9	20260424154956_009_create_vehicle_driver_assignments.js	1	2026-04-25 14:17:53.84+00
10	20260424155004_010_create_refresh_tokens.js	1	2026-04-25 14:17:53.842+00
\.


--
-- Data for Name: knex_migrations_lock; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.knex_migrations_lock (index, is_locked) FROM stdin;
1	0
\.


--
-- Data for Name: provinces; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.provinces (province_id, name, created_at, updated_at) FROM stdin;
06e0de7f-9923-4b7a-bc27-d560e1e737f0	Western	2026-04-25 14:17:59.028662+00	2026-04-25 14:17:59.028662+00
24a77d1b-23ae-4a8d-b3ce-16f2cc581cda	Central	2026-04-25 14:17:59.028662+00	2026-04-25 14:17:59.028662+00
f611edd5-1bf0-4662-bf5f-9990c44c6c19	Southern	2026-04-25 14:17:59.028662+00	2026-04-25 14:17:59.028662+00
527ed517-6502-48a8-8b88-812c73b4995d	Northern	2026-04-25 14:17:59.028662+00	2026-04-25 14:17:59.028662+00
9deac315-bb43-412b-84b3-7cb94e7a611a	Eastern	2026-04-25 14:17:59.028662+00	2026-04-25 14:17:59.028662+00
bfd31493-f4d3-447f-a9ec-a7801c21b5dc	North Western	2026-04-25 14:17:59.028662+00	2026-04-25 14:17:59.028662+00
b988a4fc-d71f-44e2-868b-16dbaf1d6bac	North Central	2026-04-25 14:17:59.028662+00	2026-04-25 14:17:59.028662+00
71a89008-5751-485c-9690-c039c316b0d1	Uva	2026-04-25 14:17:59.028662+00	2026-04-25 14:17:59.028662+00
d4ca0f40-cc95-4cc9-8c58-ce6fd0c9cce5	Sabaragamuwa	2026-04-25 14:17:59.028662+00	2026-04-25 14:17:59.028662+00
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.refresh_tokens (token_id, user_id, token_hash, is_used, expires_at, created_at) FROM stdin;
b6d578e6-0c2a-4d72-840c-c6829536a559	99af9c30-72e6-4608-83a1-72004c417677	3a385b1f5379b1604e6f604d8c0ee3cf74a12e77a87036cc0f0bfc7484c43bd0	t	2026-05-02 17:05:38.713+00	2026-04-25 17:05:38.712664+00
\.


--
-- Data for Name: stations; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.stations (station_id, station_type, ds_division_id, district_id, province_id, name, contact_number, latitude, longitude, created_at, updated_at) FROM stdin;
f1eb948e-40f3-48e7-9447-2eecd2ce5339	Police Headquarters	\N	\N	\N	Sri Lanka Police Headquarters	+94112421111	6.9271000	79.8612000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
c83cade7-837c-4c39-bded-401a45722fa0	Range Office	\N	\N	06e0de7f-9923-4b7a-bc27-d560e1e737f0	Western Province Range Office	+94112300001	6.9271000	79.8612000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
f40dde38-7c1a-467f-a155-f3ce28cc7cc3	Range Office	\N	\N	24a77d1b-23ae-4a8d-b3ce-16f2cc581cda	Central Province Range Office	+94812200001	7.2906000	80.6337000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
d234bed9-d75b-4b21-8f9a-c993023128f7	Range Office	\N	\N	f611edd5-1bf0-4662-bf5f-9990c44c6c19	Southern Province Range Office	+94912200001	6.0535000	80.2210000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
da57c993-a79a-434b-92e0-25df95cbc5c3	Division Office	\N	457a5e74-663c-4c64-b76a-565418cbb3cc	\N	Colombo Division Office	+94112421001	6.9344000	79.8428000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
5679ab28-7b68-44cb-ab9e-2ed4bb2649ef	Division Office	\N	1fe55f2c-f13a-4690-8177-ec5c60459213	\N	Gampaha Division Office	+94332222001	7.0873000	80.0144000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
9b8d8f7c-50c5-40e1-83e0-05f885afa0ac	Division Office	\N	a96c863e-5e82-43bf-9a2b-57a52fca1b80	\N	Kalutara Division Office	+94342222001	6.5854000	79.9607000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
4b4a4790-e2d9-4792-b374-15bdbf895fbd	Division Office	\N	f2be4257-e0f7-4b6d-b00f-dd84ffe2ec52	\N	Kandy Division Office	+94812222001	7.2906000	80.6337000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
1345cde8-61a6-4a04-8f98-026048c2c729	Division Office	\N	d47feffd-7a82-437c-90d4-3d9f25460839	\N	Galle Division Office	+94912222001	6.0535000	80.2210000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
8004ffe6-0a58-4747-9f53-167ec2937f5d	Division Office	\N	49f53434-f7fb-46bc-bb0f-a11d22cf4a44	\N	Matara Division Office	+94412222001	5.9549000	80.5550000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
ce294ca8-06f7-4861-b93d-8ab13cacc074	Police Post	e56d85a6-8adc-4ef4-a8c7-a73363415b04	\N	\N	Colombo Police Post	+94112421002	6.9271000	79.8612000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
6cb8473f-d281-4bae-9f98-cdfc72d995b2	Police Post	6f4505e2-e82a-4476-be62-37e3a72719f5	\N	\N	Dehiwala-MountLavinia Police Post	+94112721001	6.8517000	79.8653000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
06167cb1-d992-4d6b-a800-8475c65f57c2	Police Post	271f0bf8-6856-4232-8338-3da20373e733	\N	\N	Homagama Police Post	+94112856001	6.8428000	80.0022000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
ec0be144-687e-415d-ae8d-427fdee8a9d5	Police Post	23e935dc-5df8-431d-a5af-929cfc9c719f	\N	\N	Kaduwela Police Post	+94112537001	6.9286000	79.9892000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
afd7fb17-1eac-47cd-b837-e9e60d14e419	Police Post	015da7d7-6d1f-4a6a-9c2e-c349f8a95517	\N	\N	Kesbewa Police Post	+94112608001	6.7967000	79.9331000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
172a2fa2-67f8-4d03-a999-4418a9ddd7c5	Police Post	9b64dd36-0061-4ca0-bb7f-ee1545eb0fa4	\N	\N	SriJayawardanapuraKotte Police Post	+94112865001	6.9108000	79.8878000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
e02309f9-cf6c-4ee0-a3f2-b0912bd1f043	Police Post	149ffe17-b992-4f01-9172-b326792e23a7	\N	\N	Thimbirigasyaya Police Post	+94112696001	6.8979000	79.8718000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
7b4a4dfb-f0f3-4a74-9d5e-f295f384665e	Police Post	1b108646-fc07-4eda-8c37-8f9a8ae50db3	\N	\N	Ja-Ela Police Post	+94112231001	7.0742000	79.8916000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
38286d7e-9acd-4934-bff7-7db1941a7806	Police Post	04deeaf8-d443-40ce-9ee9-06e80159dd09	\N	\N	Kelaniya Police Post	+94112911001	7.0006000	79.9208000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
f2b4bfb5-6545-4763-ac8b-c308124a71ad	Police Post	6632cd97-4b95-46ff-adaf-d6d927035f58	\N	\N	Negombo Police Post	+94312222001	7.2096000	79.8357000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
3077be69-9ba3-4292-a308-de65d97fd0a4	Police Post	c5e35455-05f1-4d1f-8be9-e2896c16a58a	\N	\N	Wattala Police Post	+94112939001	6.9897000	79.8893000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
08e943a9-12fe-4b00-afdc-25a57e8da339	Police Post	bf848422-face-42a9-b51c-63284c38ba13	\N	\N	Horana Police Post	+94342260001	6.7156000	80.0631000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
430b4937-ddef-4537-8316-2455a45c2fba	Police Post	a6facf79-f149-47d0-ad68-bfe9d30b88d8	\N	\N	Bandaragama Police Post	+94382290001	6.7139000	79.9833000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
d15d5c61-cfdd-4695-9fbf-05f0bd2acac1	Police Post	ec8a93e7-c100-43c5-94de-1cec705443a4	\N	\N	Ingiriya Police Post	+94342290001	6.7367000	80.1356000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
eb81e3d6-7aac-4b77-92e8-0032fd8995f2	Police Post	5de7741b-b338-4bc9-95fc-8820fedecc6f	\N	\N	Panadura Police Post	+94382222001	6.7136000	79.9064000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
c05faa16-b18b-4e60-bb81-e8586e2fcc8f	Police Post	0095b334-c326-48b5-a41c-9fd5b5dda379	\N	\N	Medadumbara Police Post	+94812222002	7.3667000	80.7167000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
58fcef8a-7c55-4065-b1b9-7cf2907b1a30	Police Post	d0fc0ce1-239d-4a48-b421-3a0edd246c38	\N	\N	Minipe Police Post	+94812222003	7.2833000	80.9167000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
4841a438-3c3b-4b85-92c4-8406268d4f85	Police Post	0ca8420a-c7d1-4089-98cd-c5e9661f3eae	\N	\N	Thumpane Police Post	+94812222004	7.3833000	80.5500000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
21a3e4c5-f0c9-4ece-b9ef-27d1d91f362d	Police Post	40cff250-f441-46f0-9a98-cc85a71a0e36	\N	\N	Udunuwara Police Post	+94812222005	7.2167000	80.5833000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
03ec2742-2e2e-4814-91df-a21ebf0c6085	Police Post	bbebc644-86ee-48ec-b2a4-807f9cf3b380	\N	\N	Ambalangoda Police Post	+94912258001	6.2341000	80.0567000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
d6f8f735-1a8a-42c7-9150-459bac9e0951	Police Post	0333f668-c304-4421-9e8f-934a51f3265a	\N	\N	Baddegama Police Post	+94912292001	6.1833000	80.1833000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
58a37297-e197-4455-b5f9-f4a6d0f139af	Police Post	b269596a-d674-4dec-8f66-76941dcf88f6	\N	\N	Balapitiya Police Post	+94912260001	6.2667000	80.0333000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
6b09a969-71d1-4afb-8423-a25eb8399647	Police Post	6ebadced-812f-4f17-aa5f-447653cf3b26	\N	\N	Elpitiya Police Post	+94912293001	6.2833000	80.1667000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
5b12ce94-6be5-49c4-942e-f0badf6b61b9	Police Post	7f0b360b-1415-4fc8-9508-43b4580bbe8f	\N	\N	Hikkaduwa Police Post	+94912277001	6.1395000	80.1054000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
1579bde9-614c-415b-bcf4-9390173fe000	Police Post	7a5a7332-05a9-49d8-abf3-0d5debb8fa41	\N	\N	Devinuwara Police Post	+94412222002	5.9333000	80.5667000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
ebbd44f6-f285-4215-addf-da29f53e8b52	Police Post	2e63e462-cd35-4b9d-ab7f-fb7e41fc37d2	\N	\N	Dickwella Police Post	+94412283001	5.9667000	80.7000000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
2cfb17ed-365f-4cf1-86ab-c0816f2f0087	Police Post	48c99c75-6d98-48dc-ab3d-430018722358	\N	\N	Mulatiyana Police Post	+94412247001	6.1167000	80.5000000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
7c436cb2-549b-484c-adde-81d38b25ed8a	Police Post	720aac09-5422-4255-84d9-620d7a44a666	\N	\N	Pitabeddara Police Post	+94412248001	6.0500000	80.5167000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
f64a0e7c-554c-4733-93b2-1af1e45b8b31	Police Post	58c58573-02dc-4cc9-aa49-27c5ccada8a7	\N	\N	Weligama Police Post	+94412250001	5.9747000	80.4290000	2026-04-25 14:17:59.040145+00	2026-04-25 14:17:59.040145+00
\.


--
-- Data for Name: tracking_devices; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.tracking_devices (device_id, serial_number, api_key_hash, issued_date, admin_status, created_at, updated_at) FROM stdin;
6b49f43b-3479-4f5b-944a-51a1d8c50ea2	TRK-SL-00001	86eaf4a3ccdf44baa6c52ac50a24871e9648a0ea3ec3b0b9cccddc581a892b68	2025-05-10	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
7251d07b-4b5e-43b2-804a-fea5458b3674	TRK-SL-00002	ae07328cfd4789ec76b4fcdcfa07e8355e8d563587dc280056b9b08a20225ae1	2025-10-14	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
8501c237-9c16-45d5-9351-3185397d319c	TRK-SL-00003	e9f0bd15f47f4a0c481ec3177d7184b9c1a46d12c8bee4657c6e3cf05a6f6b29	2025-09-04	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
2fbb2512-20fc-48d8-be0d-8291474a48ee	TRK-SL-00004	d4fd0d2b9908361a82a27474b5d111d2a1aa7e2a70967e6a8101cf6fa68dbbcf	2025-04-29	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
2df01c92-36aa-462b-9db1-35777238282c	TRK-SL-00005	697a8149f5f6d8fe5e48ba604df248125d48aca5e6b6b189e96c62a68a21ffb4	2025-10-05	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
b6f32cb2-978c-49e1-9602-696733fb9351	TRK-SL-00006	1467974edb3593ce6c5a3defb2cb48c21af19505387725c8b134af95ee228970	2026-03-02	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
711051b4-2133-4785-a758-047e0a5805f6	TRK-SL-00007	8a253dc5af01ff64ba2c74d454412d8877014caa264846d3f0917ad5f1e57fd8	2025-05-28	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
382a052e-2f4c-46f9-8b0b-f01451f76cc3	TRK-SL-00008	76fa627146523f761a4264b312f472718579602b90eba79f6ab9238d59c87639	2025-10-01	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
75e286c8-7c08-489f-a7c5-d36dc1311912	TRK-SL-00009	806f1a715197dc7f56b44db50ad301a5f989a90b0772a1134cf78b408651ec0a	2026-02-27	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
eec04469-2dd9-4988-8307-c02cdc9c5767	TRK-SL-00010	bdaece78ed526f0e11500b7c93649fdf39d7c64706cda609a23b7d874300bd75	2025-06-05	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
388d2fae-0808-4126-889a-3d10eddd46a5	TRK-SL-00011	3d3e578f671abca3f4d20a7fc284ee11979fa79734fd0af66a5dccdb74ec9c85	2025-08-09	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
78a1c285-9055-4067-800f-65846eb7a97c	TRK-SL-00012	5356054a944c3fbc0af64a2e066c54805ab67fd9f1f1fba80009c117bf616e84	2026-01-30	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
86123902-be81-4b42-94f7-88f7521ba943	TRK-SL-00013	0c5eac7cf4e6f508187d98bbc5eb7bc63f4443b1c33c91853ad1ba07dc1aa8e5	2026-04-03	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
b1540a21-2b1c-49de-a3ae-a82cd8c08f85	TRK-SL-00014	ee76fe303948bc706a0630c64622c556b8a688e57d37d07fef58497eab0ce3ee	2025-06-29	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
d4edb7cd-475f-43db-b283-12973460fa4f	TRK-SL-00015	7f070132a5bc284cbb5c488ab13240e1fea16e88f3598c38372ec5a3a0a7146f	2026-02-15	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
13dcedaa-bf5a-47e3-b2f9-a6fd5e845370	TRK-SL-00016	fe91f1538fb7bf4bde5ff20a5c7dc68c6aac9e0e2d6b281c54f72b1c759191b7	2026-02-02	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
bea82b24-d165-4e72-a6ec-55a5a7042701	TRK-SL-00017	349d91e9439eb739b8ea6c43a4903f8466e67a266e2d28260dea6954a6532824	2025-12-12	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
7c2e5e66-786d-41d4-897f-631ae16e1125	TRK-SL-00018	3f9ac203268f97ba73155edcce4e9612a9e7b7d4d0b685304c2af9815bc8dc36	2026-02-27	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
c278853c-ba0c-4561-b97d-c5452b6ed98c	TRK-SL-00019	54f432e34f09d9e6dabd2a0137284ce1f9f4a0cb8d0d3cfe356813b3405b9b54	2025-10-10	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
1890e28c-b210-4d73-842c-d70742359fe5	TRK-SL-00020	dc6e93ef328e198e2d4272e979b69aba7d4e368998a5046c2dd7c204f8b2c57d	2026-01-09	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
1a0f2094-a178-4d37-bcee-7c1daa1c5dc8	TRK-SL-00021	8a62ae98642e005fce94a53be962cb54df38c5a38f8565ac09f4fce1a35f7d08	2025-11-06	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
684e0199-afe1-4042-8f7a-196935006e70	TRK-SL-00022	431d2c30d2bcffd1b3f296732c8499a2aa40e72ced35975a6f1b9991d6f495cf	2025-09-25	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
22bb0036-c016-4396-8735-917dbffde252	TRK-SL-00023	8637a7ed3bcf932ec5079f707dee0132497c6a90e2e92f5d15efb2ba21339c57	2025-12-03	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
dcfe9fce-ee63-4967-b987-f3485e52c078	TRK-SL-00024	6cb1dd1cc47b14626cc8ea45a1137419aee89c6ce132254422c93cd7cb624327	2026-02-17	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
4f9ff7b8-b441-4473-8fe4-93850c00ba62	TRK-SL-00025	fbaf185d8b6d3f52421eebfd78fdd710fb7f3015ead80d0f15be179570e5b05e	2025-10-27	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
1c253d9d-efa7-4c21-9cdb-566b7b617359	TRK-SL-00026	02da56d363c032b53dce1650e18d808798808de04a77e6b9ea693ef8000c7364	2025-07-26	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
ca550595-d2b9-4ede-bcfe-2bbcc98c5706	TRK-SL-00027	76a15052f7afe9c77b88ca44328f25b62c64286d3351ae6b6d1ad53c98c0afe7	2026-02-21	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
107075a5-28cb-47be-ac4c-41667a5e5c2f	TRK-SL-00028	8196e4e8feca80bdbf5de08f0bf31f53024e7cf2027423753314a14b407214c3	2026-03-23	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
107e57e4-d26f-4089-938f-002c9755389c	TRK-SL-00029	b7bb783e4a144f12e8163cd6aae4fb4da36b26cea3abed5753606d15b61f71ac	2025-10-13	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
e8dd9881-9b14-449a-95fe-9bfeee0e0994	TRK-SL-00030	ca3efade6eb52b62acd6c75cc8fea5d6398ca06033a4c56dc741c20681dae3bc	2025-08-01	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
1b9bbcac-dd2f-44fc-952c-aa04439cfb4c	TRK-SL-00031	28e8d84d51ea7fea2a74eeddd38bbba150abccc2c35c57e76f29db78331b115b	2025-08-21	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
0bdd83dd-42e7-4ea8-9a8f-829656d905cc	TRK-SL-00032	219096ee12d71dd60f3db2cba1fc0afd4eee35ea7f317d1bd9b01569e80b0e5d	2026-02-03	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
9866d19e-f188-45da-9c91-3a67c63fc095	TRK-SL-00033	3f53673465c23e3dd571ccb8d62c56011ba59452414148fb6acd8b7bfe15ba73	2025-09-23	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
71d40a9a-1fe8-40c2-9dc3-cae5933fb567	TRK-SL-00034	2310a0fb1b6ff29f07f83994b009cbbd8eef03de23c53aa77454b2e0bca865b7	2025-10-27	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
05f195f3-0650-463e-937c-f8107851c519	TRK-SL-00035	ec201965331fe30d1daf574e7394a5c1ba389dc618f87d29ff95897ec846124d	2025-12-31	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
56a09034-dd28-486f-9a47-6d3d3a23cf40	TRK-SL-00036	36e01c8332204640dde1a8e0c39fcfff4ce69b9f46b1e470d555421339cf3f89	2026-01-23	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
8330fe16-20c0-400a-8e53-f1c1e64a0d38	TRK-SL-00037	756542892339132b142a0c9522983d09b7d61744ac75b76f6678f47ab209bad8	2025-11-22	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
67a7e3de-406f-4762-8bfc-feca33d49e8c	TRK-SL-00038	ca6debfd08affd17e002afabe43daf53ffbadf91f28c874169089eaba0e30d6e	2026-01-06	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
9a837038-21dd-4ef8-a0bf-8665fb65a475	TRK-SL-00039	f6fef5ff254eca609eb3f62b2eb5fa469cba060e247e4bcee75c4751db8d4adb	2025-06-25	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
4461e57d-9bec-415d-85db-ccbb924f4442	TRK-SL-00040	df654ecce556eb796661f80f6325e5bb0dfe6c58574d37fc7f1a87242942a58e	2025-11-17	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
30781108-f53c-41b6-9028-153ed36e6194	TRK-SL-00041	fdec9f0bb30d7c4e208f8730a580401e8fc832fcfa98bc36fc8b2f8d2446958c	2025-07-13	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
35a61a6d-b439-4d34-985e-39795ee37a8d	TRK-SL-00042	2dcf7fec5fff7895eaf11d8545102c42a7db5607068a8e8203e29a11d7b43c89	2026-03-09	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
945c8496-cd65-4d7c-ac6e-63fbb7f36d14	TRK-SL-00043	9b1a769bce9a29ead62d8d6fe11fa03ded3b5a8feed0b8968bd8ac44c02e6503	2026-03-25	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
34e9d343-c8f9-4ea5-97f9-299dae73ad22	TRK-SL-00044	f00922966657e51874cb83ca779206946a7c19c52835e9e244390804cd452d38	2025-07-11	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
bfa9d7a2-b802-4d16-9fc0-1a82816e2528	TRK-SL-00045	d42006519761ee110e0534588bb715428bc9b5c9cdd3ea7966aa538cebda65f2	2025-10-03	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
4d90c88d-327d-40b6-917a-988aa04d0757	TRK-SL-00046	1f2ae45cb5cff0f27e4455ef9414e6c532c03cc3ab9aba220fc0eb7d3efe1923	2025-05-03	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
6b8a4b6e-c8c4-4153-9f62-96f489d404f2	TRK-SL-00047	997723e0a09c2119babe134d4c042fa382a31dfef2e3a188e54ae6681db82074	2026-01-17	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
52279684-79bd-43c4-87d1-ac3316026afd	TRK-SL-00048	d0f8e1a61c3adf1b9ce8f7a63ec8ae4b67eeec29bd1ded27d64b93d9ebc9f613	2025-07-25	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
26101e19-03bf-4577-98bf-f1b381993748	TRK-SL-00049	3fc74e96a31f679ecad2f325f491a580ac4e3dbddd69bdbaf8775dec6dcfd251	2025-04-30	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
2e8ad2c3-2b29-4481-b0c2-c68b5594b008	TRK-SL-00050	18a0047aea6b69af44217cfcabb6fa3ecf43bc49be3b6021a2b82c8bbff9238d	2025-11-29	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
4acc59c3-8d10-4805-81ed-2110606bb67a	TRK-SL-00051	11446c8d7e6fb799626662bb3407db5324149941ff3d19355240e13e5738a851	2026-03-13	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
201a8a21-8112-4ae2-bda5-1df3fb192b28	TRK-SL-00052	7b9db35fd8f0d69a50869f4d127c9db2fa33131c3fba47abac706377d7431ae2	2025-09-10	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
3683bd9f-596c-4f2f-b3c7-0cce822c6dc7	TRK-SL-00053	3edfe81f72f7e5e8eefe7ef8f28372ab7448def912cbb520351850e1a42b9175	2025-06-25	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
bc895503-cba5-4934-82eb-bb8d8ce5f553	TRK-SL-00054	05e375774ffb4d1c5a98afb5fbc886907233af8c4858dd9dd2ab96df5815310a	2025-11-20	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
d50f7e85-5577-4ee3-8334-65bdf0d551a0	TRK-SL-00055	ca10534428006b03171d28322dcdf6dbe74e762e57de903d0fdc7d44d412c91f	2025-09-03	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
6d615999-c4d2-4983-ae31-15b2ca23930f	TRK-SL-00056	570ad5570bc81acab06da8f93c5d85e43c108cefdfe5f3a18ce6650979d90ac5	2026-03-21	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
0ebde3d8-7bca-423d-a3b7-6de9a5d60a1f	TRK-SL-00057	c8087824cd2cc6a20d6e1a9f6d3d6ba77e23baac97cd10f7df8666174cafb2f7	2025-09-15	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
e86b07c5-d40b-410d-bfa0-57287b16f0f1	TRK-SL-00058	7d20e7333d3fa921dcee71995cd8b080ab3cf60b16a076abfc2b0d69bc8d35c9	2025-06-26	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
1d5226ea-c399-4014-a0ff-0ffd2e5fb970	TRK-SL-00059	77384af9a056736928fccb924108ae0645c816bb0500f7f445933f667c63666c	2025-06-26	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
9ed9e421-1b0b-471e-9127-344c031bc1b0	TRK-SL-00060	5574e637fce3c8649558fc5889cbe76de935942e306b28513968f47cf34d9ba1	2025-08-24	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
0690b2e8-f766-46f1-a7d7-f2145da5a7da	TRK-SL-00061	d74ab47abf986900215349d83be7b933428c02207ec11c9cb62fc6a6d292e7b4	2026-04-25	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
98ce1c4e-d747-4ee1-94e2-1d7fd57cbe76	TRK-SL-00062	137b246c4937c98e88bec9cdbbf2a0062c8bcd0e5e2cb1ffe570cfba351010e2	2025-06-18	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
f6e3a372-e7b7-49cb-bb88-dd814daa0244	TRK-SL-00063	85e6066d95f56a9b12375995e891d7d2eb1dfb7c866377fb3ceccabc8389496d	2025-06-13	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
82af0431-b5ad-4842-8166-2c691ac34a2f	TRK-SL-00064	72b14d1dfb5cdec46b8fc00895d7c08a92d751c04bed930f4cc12855c4ca040e	2025-07-22	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
d7c44880-8895-4c45-9a2c-f6fdbaaef833	TRK-SL-00065	62c2a864b7ce8edebf7f116ed5cb8b5fb9e286a0f869b0844c7a0e378ea0e265	2025-12-22	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
6c302842-1bf1-446a-a54e-7b5719f15e38	TRK-SL-00066	7c4740f59bea4f5c22b31edd5e8e44639b2a0f2fccda009eb00aa49ce329bd01	2026-01-18	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
b82a6d0f-4228-4afc-b85b-9a4c5a68e558	TRK-SL-00067	78dab70b035e22674facf0c7bfd8f94d7c2e205d3d92755255ecb6b7ef35e8c6	2025-11-14	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
7de19884-44ae-41fb-a971-93f52a239db9	TRK-SL-00068	1d8cdf6d4693a406e22d6429f0ea1678404c776d60b87c251be6365be5c0e582	2025-08-25	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
945339b3-4c55-4918-becc-c46f9f852353	TRK-SL-00069	70e3db7fb1f42fdc54ed1265a2c15128cfaf7df9ce4f6ccccaf59090172fecb3	2025-05-24	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
2e47c63b-f5ea-4e49-a66f-074f33c31dab	TRK-SL-00070	84ff1d25e792392e5ee0b8bdc4a1951e68b506a4bf5586f5088754faedb8a472	2026-02-10	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
2169355c-4859-48c9-b831-49b5b34139b6	TRK-SL-00071	361690b05ac93b2939f6faff30202883cd50b6b5fe5381f3380c950a4fdf67b3	2025-07-14	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
4b42c4ee-2bf1-4cb2-b63b-26d6379e3713	TRK-SL-00072	a69458746fa65c16bf3ed47869897ebbcd3a4f668fdef9e03f4beef05140156d	2025-05-04	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
1a1ea4ab-c9bd-499d-9433-81072375ecbc	TRK-SL-00073	ca005c55b03ec6330f5ce73a6ec1005d5ddc51cd8db02846831329c40a5b2f87	2025-09-09	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
4ab65884-3e9b-4cb4-b05f-587eabd0ccfc	TRK-SL-00074	07318bb268b3b305f6af5f384737645e1992de5e64abf0f5270729a95fe66c99	2026-01-29	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
d2ed692d-f509-40d4-b7d9-dd5b7de5ac5c	TRK-SL-00075	86ba92bcd466ca77addda243c84f79bdd503a0308c20a2a4d4386afb2ee4ce13	2026-01-02	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
2a1ab5b3-0eca-4d70-a93b-e1140c92e1f4	TRK-SL-00076	4e2bf4aaf803810046f7f88d7a7204d44500e2fccdad906fcfc42e08ae7ce403	2025-08-20	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
bc251fd6-683f-43bc-8ed9-b2fdfd3962a1	TRK-SL-00077	833a5fb64736cf5c66e2773452fee0afc5249447bb4e1b019761ab1bc695289c	2025-10-28	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
9c4129cb-ea99-4d10-a24c-ef83ed5559b5	TRK-SL-00078	7bc9fae67ba8b8ac7fd6e48bc9585de99372a6f6023cdbcd75e7d9bdb54ab510	2025-07-06	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
6a1cdb94-e2e9-4205-a719-c9b0dcdccc74	TRK-SL-00079	1e2813b28e9c1a6d60b49967869d064576308d24b381f092b52de43208326988	2026-01-01	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
7ab57fa8-6683-4638-a4f4-2ab469b12d22	TRK-SL-00080	9f7fe03a5ffe15ae14701838f20dd8d6863f92f1d799767d2478bef17e01120b	2025-11-23	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
88fc6653-4d54-4bae-a1c8-b57547404f3e	TRK-SL-00081	eabed60b948a4e7a2769636d1af8358a3f072dd275231748d0e07f29fef2ff61	2025-08-05	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
9fb81ee9-081d-454d-b98b-490718734299	TRK-SL-00082	ecd6eb0769a4d38eb2c5e275bf37a1616ddec2bf29e27d27cf9cb2a4996ddc01	2026-04-01	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
e81e962e-8f44-4df3-ae34-de912e975c59	TRK-SL-00083	81657a94ea4a3dc94ead429746c767a71b6e3ad84e7ee1dad6c8c09aeb1fae81	2025-07-31	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
c942db3d-5546-4c37-bf36-989b64b7f948	TRK-SL-00084	a5e6b9bb1948fb3a98760488ec9f8a655f9e5569c453fff84391e3df1ec7c178	2026-04-14	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
eaf8b340-6806-4024-a6c7-53ab3b114b96	TRK-SL-00085	4604041d49b4894f65f899e665e5c0f69acfbdc285577d56027985b2e83fcf6a	2025-06-11	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
25cfff44-b44e-42a0-88f9-f5c5f100d074	TRK-SL-00086	85340424c1abfdd441b1c9fdb326006f6e378e007e54027a898914ad4100d741	2025-11-07	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
f7489862-db92-4ce1-b4a0-206a04c97b3d	TRK-SL-00087	32d2199110785cec15989f292234a11b66cce2faef02885b06eec09843840617	2025-09-09	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
a6c7d502-a06b-4061-a5a0-9345a84a8be2	TRK-SL-00088	b9739957425ccbd761ed3374b385c846a96bcfab739a798ae3d1e5d0ac6bf181	2025-07-09	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
f8373a22-0790-4088-b67b-91caf7c3aded	TRK-SL-00089	c2adbcfc8caada1029d2ab6d50d004b573b3b498afa94a55d8ce96ebad56ed41	2025-05-27	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
bce92dee-da69-41a5-a4d0-20db1887d5d0	TRK-SL-00090	0e23758d1c5fb531fd6aaa75e4c98f53ffdf662a2515d9c7cf4645e1d3fed6f6	2025-05-22	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
1274549b-2f9e-4f4a-a136-4e997b9f1afa	TRK-SL-00091	9d99564ef35e9afa54f3a72a897491da5835bf16f2903ea1a2ed43364d9bdc4c	2025-07-26	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
fba45771-ec86-4f2c-b51d-a310385cab6d	TRK-SL-00092	05c93d6c4b93ab409245f16455e95779155c945b6fb4c417afdc34189bfa9407	2026-04-18	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
50f6c7a0-e01a-4398-8c20-4794bcf4b94d	TRK-SL-00093	0700fc7c10b1c8ec04c292f485d84f240beb03c6ab1448baa0b64db9af392cc9	2025-11-26	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
74b4654d-c2ef-4a4c-9d1d-51e28113fe47	TRK-SL-00094	c25e0eb9df5f9ba3683701a2fc6e3ce76d2aa0ab0027c94582132dc93eebdb36	2025-08-03	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
f4310759-e670-4cf9-bb16-2c2653ae3f0a	TRK-SL-00095	a28e2e269f5889bc9308d2f2605bbc13ace26ee568d76e7f4489d4b9f3b61bf3	2026-01-01	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
fc08b54c-fa58-47e6-8cab-291ea6741890	TRK-SL-00096	0977846948d11c59be64807ad9501dac2d4d0c8ff483fca0078246d0112aef8f	2025-05-25	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
65ea97da-466a-4d6e-8926-6c5758a41b49	TRK-SL-00097	dfff3600c7069a81b1af24dc86d8351b486b035248da7ee7f6edd34f1d51bbdc	2025-11-19	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
83cbe658-1750-4aa6-baf3-efdc328c8763	TRK-SL-00098	99f637ba2e7c6a7298fb965b4f6607da72a644cd71f617fc696d3f9e38c80752	2025-08-19	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
de9e3465-5108-4ef4-9e7f-821275a93ca6	TRK-SL-00099	d99d58fc016844cb61639004be332473bb78d79cacc3161e905e2449ddb1ee49	2026-02-18	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
0616ca8b-d747-4d88-88e5-4b74c672eb3b	TRK-SL-00100	296dec45c1a208fa1922e474106ab0b8ae7400ef310f88b61d8305ca94d7bae3	2025-08-31	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
8a399552-6bf0-4291-9cb9-d47fbd631758	TRK-SL-00101	fa4c36cbaa86ca71551af6ac657165138a914295d5093d103aa3ae882e80d3c8	2025-05-31	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
cbfa4e98-2c29-4717-a76a-9511b26b3d86	TRK-SL-00102	a2cf7458c58cf355fd8968348a5baa2a7b3b7a7de59bb6c727f8693e10a4fd1f	2025-12-30	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
048ef3c3-fb7d-46f2-a82b-7399ae753d7a	TRK-SL-00103	57c68bf93b346f290c090cc5fffdf11d0585762782c283c63c12e9c5e34d81cb	2025-07-02	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
a04366d9-d282-4bdb-bb0c-c48b163a6fe7	TRK-SL-00104	0ce8e553c50792d49093fd3aef840f239ea127b22f4e9ab37cf907fbe7d62bed	2026-03-22	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
5ccbd3ae-0206-46f6-8386-4bc6ca627bd3	TRK-SL-00105	652e9e0fff8d8e5f5953ea2cf1380b93708cafa1c117affcd929b330ead6d892	2025-07-08	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
e4d95dd3-01ea-4a8b-a70f-cb184fb61677	TRK-SL-00106	149b092b0cc0fb1558240e1788e1c85016c67e858d30d84111613b917c7702d3	2026-03-14	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
6b450036-8b50-49d9-aa92-3f607da252d7	TRK-SL-00107	7da669334733abb73a05e732abca066416aa72f69492426e5e29ba3d91355f96	2025-10-11	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
f437ca2b-d8fb-4d79-8ff5-e96cfe54d4b5	TRK-SL-00108	ffc4c18f3acb908b4a47e934d6b7dc05456c00c6d308262eaed6e2d03562b350	2026-02-23	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
38bf762d-641c-4965-bdee-b6cc5a732e63	TRK-SL-00109	54687414757f3feb6be02afbcdf1e61e33b90aca2e4bb9c4d17bf8444bbc7513	2025-07-25	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
f2a12a79-923d-4f7f-a6f6-284785623a20	TRK-SL-00110	8a3aeb2e7c3432542ce633fc29527bfc888d8e33f9b7e7b906bec89702f80c0e	2025-04-29	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
38490452-342e-417d-a856-3f67cd51a787	TRK-SL-00111	95dcecc1442374732a8b64967656e00afcd47a9a9533ba247f1ffa96b508a72d	2026-04-01	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
209bf768-8269-4f0f-9a23-54d2e2fbd929	TRK-SL-00112	e39a9462e6d6fd7d4642396614701bbc4f80d809ebee28a4746cf493c401db7d	2026-04-14	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
b89aece7-b6be-4a13-bd7e-85bf68ab5a46	TRK-SL-00113	19b8b738c38f2b18194bfef565f16e08f1f9399b7887eb81cabecd0e13cec0d2	2025-09-12	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
adcdc61d-cb25-4536-8ff2-4c9881b8eb22	TRK-SL-00114	9d9ce696aa82f932e78268c3af6a6abe7f085c5dd392360ed6417897499fb4de	2025-05-24	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
a093b4d0-e60d-4941-94e6-e247a9e69cae	TRK-SL-00115	77f6e72fe93fa1f9abaf4a3a537eac07443a673451e6b1210ef46d445d5f00a8	2026-01-20	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
b91d3af3-a3db-4e8e-9979-6ed9b1ffa8f9	TRK-SL-00116	b8e3929e881c9654055e83b2f6a00acc82150e2006df7804f901ee5cba21ba58	2025-12-04	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
7d14d4e2-7cd9-4cc0-b77c-09ffd39d8bc6	TRK-SL-00117	d83f7f66c0ed3a84a6eb61737efec73465a9d6863c12300c76436910022759e3	2026-04-25	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
a68dea6b-164f-4e5c-95cc-e0472e6abe69	TRK-SL-00118	0cfbb5f40d744ec55d3fdff13109d89d5f52240386c87b9dd7558aa3ff9b8b3b	2025-04-29	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
364c3af9-b5e6-4a58-bbba-7c6c486ba079	TRK-SL-00119	57b5e4f207b157bbe96a08e462bffa5a9e233a093359863c7c8cc09af8b34073	2025-09-03	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
55074da7-c463-46f2-821d-fa49b8723d7e	TRK-SL-00120	e1c259dd2832fb6f07e3252520e35d604a7f92c28d041e7648d6f34bfecd690a	2025-05-19	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
987c321f-c77a-45f6-be50-592e1ce44cb1	TRK-SL-00121	8295076d8cb0405c5f6e697ab700a7fc0cba1a4b2b9fd797eeac19aa9c7b437a	2026-04-02	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
07c7ae5b-47b8-44e4-86b0-1817210fa257	TRK-SL-00122	9f5341fa416ab9e8142822e8e2b83bd57ea2b2bb9687e986402db76a4a934bc3	2026-01-10	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
9c6be406-c4da-44d8-96a9-a0d86b6993b8	TRK-SL-00123	14e8e79705bcefe08de0840f9b6de3ced0199738176ff84a8c89d2477615e1a5	2025-08-21	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
5fe6aab6-ca77-4f10-b032-7b198ceb434a	TRK-SL-00124	2dc9d070018565e1aacac565b35b9e2e670341b03b55203589c8ed37b2818e02	2026-01-07	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
00f6db63-23cc-475e-8598-7c2c9a2a583c	TRK-SL-00125	72d75d02f503b8b14a86430efc2c1d21c454c56c4b3b210cebb7f9e628dd0ffd	2025-12-27	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
601af8ec-8348-47bf-a9b0-3a059b0d0131	TRK-SL-00126	0c691e520e5a0f8942f9362b85c5d8c3dd678ffcbb3b981ea7e95692b3327548	2025-09-04	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
16a77e4c-ffab-4eeb-9a81-7a18e7f67128	TRK-SL-00127	ba8174157f2e4ef9e7780303ae91941578b56319c69f0823aef1c34fa2e2e3b1	2025-10-30	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
2317c2db-c61b-4078-bd4d-757efa52224e	TRK-SL-00128	f541f64addfedf286ff54c0fbb408cb6edcaea97e44ecf7587c2f2b441a76868	2025-07-17	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
22f4dfad-7f84-4ff5-a754-2af06b05d779	TRK-SL-00129	c4bcb6976221711d1d320dbb90e5fb95d331bff2cc7e7297dd49864c986bdf8b	2025-10-06	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
775b1e36-88b8-4bd8-804e-5c4132dee7b1	TRK-SL-00130	61aae4db998547ac4b807761240ad91149d5a836dc7209c000f14b2b32d446d0	2026-03-28	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
379978d1-5d6f-43f3-86ea-f63d3f66c999	TRK-SL-00131	54a1f81c4dad935478ce8fe5352fc2b90d24a276f8040680321dfbfb6aa60afa	2025-05-03	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
c0f02faa-29d0-4c76-a771-e260778b77ed	TRK-SL-00132	9688036cd3665d2b26ff61967c18e5b0060d4a9be1879f3d566d6ebab603b12a	2025-06-23	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
1c5f90a5-5daf-4827-950f-d85b717eb88c	TRK-SL-00133	4d928e8c59a9fe48303b8246989c69b7e2667506a342440aba3e05ab6d1c5a7d	2026-01-03	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
4f403b97-0043-4ab9-b968-04da6481a733	TRK-SL-00134	166e34e1ee1f11752efa12ff86961c665a692bd6e02c0ee8e627628595368b36	2026-01-06	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
e4ee9689-d378-45dd-bb4c-7cffcc3cc67f	TRK-SL-00135	d6cc79ef1505ca6bc84a6c192e731ccb7771ab8accf0c4047af16fc543ce12c1	2026-03-23	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
124f840f-acfb-4d70-b2f1-70a0af75cc40	TRK-SL-00136	bb052fcd2e848104e5e96ee5d84882ec2b337b3d014111c21ab673a659c2744c	2025-09-19	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
459faed0-666e-4026-ab3c-f8bc2c2279df	TRK-SL-00137	adbb94f7846b8f2302185ecaefaca2a82aec50320c0ce83c4157e41844989bba	2025-12-31	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
d7918c91-4608-45ad-b850-261cfe1feb10	TRK-SL-00138	81493086e3776c23af229f839ea1ef369dcbf878f3d8382ee55dfa70a85cba7a	2025-09-08	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
8b3056c3-cfa0-478c-b83d-f263403671da	TRK-SL-00139	85ab15ab6c374ae981cd584eff31ad16b38e918c6bbceb0276fdffe86d2265b4	2025-10-19	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
ad392ede-6bcb-43ec-9da8-d36751568757	TRK-SL-00140	59e2aa9a3ec199b9f9ba1e9ce17de546f1b8985050d59c5111b6ce46f6b3c242	2025-10-31	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
bbc0bf47-2e28-4a56-b87b-b30b97ab0061	TRK-SL-00141	2b8fa56b2e35d41a183c5f67359ecc4ca512520a31bcc93f5922ca4207a58999	2025-12-17	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
fcec7786-ebce-4a15-a0db-389dea050acb	TRK-SL-00142	c5c1ad38a5f711289aa79350a68c66b8efff8aa28b4ad490846f7e7555826c05	2025-12-25	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
60b72d6e-edf8-405a-9269-e60f6551ab7c	TRK-SL-00143	8cd789c0163ff12130e43eb69a2adf3f802099c21b8965d194adceec642c77dc	2025-10-23	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
730e4109-6bd1-4ac8-8614-735584acc47a	TRK-SL-00144	c2afc8a7e50dd65d28ab6ec83a1ee57ca3e1f4f845fd882912286714e3376c3b	2025-07-21	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
78f706d5-c2af-46ee-a833-2d32804ec295	TRK-SL-00145	ca7728a69d70e705cbdf2e532da06eabb9517e89e65e13f0e16b3c634a390355	2025-11-05	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
9c5d3897-ee25-4db4-82d4-6168996ba848	TRK-SL-00146	fa1477d4c3122b5be1142393100d4620ee48219746610ab40aed35587c7ca158	2026-01-18	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
43dd707d-bf06-4c6e-a7c0-9c5cad5d75d3	TRK-SL-00147	4e3a67a358478c5bf406fdd215dae1a0e7a27209450e1d87a3ab6ac8d259ffe2	2026-01-22	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
ab35d82c-e731-4724-8264-99cde4dbea22	TRK-SL-00148	5ab7247ad35bfb65b11bc05e24f672372d3d7ff0757287fc61b0447fa066a416	2025-07-23	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
849a1c11-c7da-41ce-9913-8718de7533e0	TRK-SL-00149	d7d88b8ccc15dffcb8633eba83fd676d2e222f0e4d30e689a284871f02c2d330	2026-03-30	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
96f8c6e1-9a32-4ace-8ece-96a22ca4fbbe	TRK-SL-00150	7d592181a4c4ee45ec34eb295099f2547d275fbbc88ddfa3862184035d4e3cb1	2026-03-08	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
ba360ae8-584b-4e2f-b81f-d82676a98383	TRK-SL-00151	a5948d7bb7187e3014926930316f875cbb219ab8820da1f63f5d650b2b08b356	2025-09-29	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
105254bb-fb73-4021-a1d6-7516a0e6ab10	TRK-SL-00152	177ee38f5fa00907b830938b08527d5a7832ab3dab69baf651f337772719e94b	2025-06-02	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
1d39cc0a-321c-4c75-ad9c-1d2b2af54289	TRK-SL-00153	a3324d72e1c0ce825aaf46786c25b728d8d356eadd52c0c76de61e03a3d717af	2026-02-15	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
e2e6ff7e-8458-48f9-a0fa-78796ab0ae1a	TRK-SL-00154	e2bde1637115fdd5acc9a97d685a7a5b4e85459bc20a495d7c9a5df40c89dd50	2025-12-07	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
fcf46590-d1bd-411c-a505-8d1a35d1f7fc	TRK-SL-00155	ddf4ba95abc7bc61ff3d9a87f98e26abf4a6ada8e319d011779a9a76db7b8960	2025-08-08	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
ffd6751c-2b2d-47e9-a486-e01b4499bbc1	TRK-SL-00156	6aa846d1d638223749c8120e6eda045dd229fb2711b936a1d3cf393d92b7231c	2025-05-01	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
6ceaa7e0-f14e-46f9-a658-983545b4be48	TRK-SL-00157	fb1c093a4105f1485b788cf5d2cb5d69170f5a56b85c27fe5e27aaf5170dd691	2026-01-28	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
2ead8325-56f0-49c2-94da-a41d82cdc06e	TRK-SL-00158	24010696cfe6162f044c9fe205cd6b13e19ec4da032f4efd1f85fa48506c2ca8	2025-05-06	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
cbfb1a83-aaff-41c1-a593-6f4f3b5006cc	TRK-SL-00159	ae5a145ab72840e6c909e2714a4f0695d302c89e3e26b977e8dde5818a448c66	2025-10-15	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
9efd8c4b-f17e-48c2-a0b6-5f0d0b866ea4	TRK-SL-00160	1ed217cc7a49e4c6f49e9a514e495f57d06b683849eb36a4d6374112bb493e05	2025-10-17	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
073d1771-17e6-4858-b1b5-1d5a05655a46	TRK-SL-00161	1514af311a1f5120465e6a20e2d93cf9426d0769583daa3d00fce22ce292522e	2025-08-07	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
d28b1a22-4221-47dd-b743-da61eea9f1e4	TRK-SL-00162	fb1973f9a00b6f05267a30c3f916d54dc5e43d00996df55c2bbe9e2c248f9ae2	2025-07-02	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
40d100a5-cd1f-4408-bb53-5489b7410963	TRK-SL-00163	f6c81f062408f1e95e132672ad49b13521bac2c2b746e4c224b222d663d8ef31	2025-05-12	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
a4425442-074b-4e46-bae0-6aa0d37c56e3	TRK-SL-00164	04840ebfc98ce3268ce1257a8c58aba414ee9c82fc26d96fbab35c562921ab3d	2026-04-17	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
467251a1-864f-47f0-9913-702127f7358f	TRK-SL-00165	682a636fb2f4301788633763521b9e105c962879fd9aa7eb711adfd5568d74ae	2025-10-04	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
e2bdc3a8-6024-43e1-89fe-67b5a3a4d372	TRK-SL-00166	4764b273e8f9c25d94c1eed497572233dc075ce956bc15c9357f2f52a3fdfdbb	2026-03-04	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
cc76f1a4-5325-4ea6-961f-cc89d1e26b1a	TRK-SL-00167	0cba9f5f72db8c6bea65d1849cbff26e2e427dba1ed3ce78a4d62e36265f88a4	2025-10-27	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
a7fdf29c-e38f-4f90-96cc-2cc5d791f67f	TRK-SL-00168	bc82160a92e3dbeadb6d8c44d325db7706e9ea97055e59cf5bf9c09a1466d336	2025-10-13	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
fafed4cc-6aa6-450e-a9c1-5247ffa1c146	TRK-SL-00169	b093e86d239c44f21e9cea6b410a1345298d8b03169ad700b57d739bb5ac2205	2025-11-29	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
02c6b3b9-7c09-45e4-a3a0-1f49fd51717b	TRK-SL-00170	4e105f49d24433775118440518894eeae5b7bf4b67a612560db0a0f72fd95957	2026-04-07	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
e5be69f9-ae7c-4c64-8c6a-aa81873cb944	TRK-SL-00171	031e324a84fb307fd8815d90b51e6b53eb0a782595f63e34e71566710b4cbf4f	2026-03-17	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
268f13ce-0c24-47d0-bbe8-5da0927d1e2e	TRK-SL-00172	93ec121e7347274a97b590ee0bfcf2983bef76e4fb79a8160c8852a3c3035669	2025-12-13	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
7301ed3b-abe8-4741-ae78-7806cd654ed8	TRK-SL-00173	b1dbfa11053ec2edcb50f9f8d288b204ba7290264aa5a6b29ca3161c2cf443bc	2025-05-07	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
21953d34-ca52-4e0d-aa51-810bdcb5c86d	TRK-SL-00174	439726fdd06c00826bb92e7c2b8ac662f44f7ca699fbe1d37119bf749eafeb6b	2025-07-07	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
5a58148d-36d7-4850-8a56-eb5af291578a	TRK-SL-00175	05eb6241eb894fd3fb8f85109106dfa7b35ee4f0230917ce3fb7bd2717a950be	2025-05-09	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
82a2288a-9ac4-422f-9186-41224e5e19c5	TRK-SL-00176	c9a85059ff2599196454842c2599106cbc5a0525f16ad641a0fde0ca62d67968	2026-02-11	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
4c04ed64-d280-4327-99e9-bb3f512c5439	TRK-SL-00177	e679d191cf0ada73a35605813b20ac77bd77f19f84af284b237b3dbb196a33b5	2026-01-31	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
93e51b0d-34ab-4210-a056-b45f39bd9d7d	TRK-SL-00178	b24fc59f8c4dd1ae3a793b5f82fc1d5d98d17df2dd49d57ce20b2db992f919e3	2025-05-07	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
824c85f1-c1ea-4682-af16-980773022a06	TRK-SL-00179	aa12562d47ffc23b1c0c1e264be8f7fa3081272ee777d01cc44f548548b25801	2025-07-01	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
b0e9fc3d-d77b-4067-84e9-044d090627b9	TRK-SL-00180	c998c878b4c2f99005c1da44277a66307abceb049b5bb5162df59fc4c176c1df	2025-07-03	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
49a4262e-825c-45ac-8c11-1ea7d784432e	TRK-SL-00181	fa1f1d1b851b97d321f55d3825f393365222c7aee8ddc3e0e4de63c418089643	2025-09-22	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
2fcf5f8a-042f-4fd6-b383-7ac7b65a02ac	TRK-SL-00182	43fec40b6640178cd0afc95c9e2b82bb3801191a2661b6a5022cb678ee812a7c	2025-12-06	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
23d9244d-9df1-47ad-bb24-cf090c748af0	TRK-SL-00183	ac23a285b4d1e8eecc7b0ab7149da5a779f35f156b6854d9e382d68b3400d1e2	2025-09-17	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
0a83acc9-e56f-4165-bfbc-c90729bb3f10	TRK-SL-00184	4322f4ec95adf9ad777867ca920a30bd8a079aa61590adeedbca9a4fef36f244	2026-04-06	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
59dd9c87-06a4-4070-893e-bc363829b6dc	TRK-SL-00185	a7dbd8c746b92f7e10d1db395260e0284b7ba572086b7ff64ccfb6e2bda146d5	2025-05-14	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
8ac4da9b-3181-4845-b1e0-673eb0ceec07	TRK-SL-00186	6710797dc446727fa31e89aa7a45bdda5352b0f08117ff71641df2a14fd4477a	2025-10-28	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
ca261f2a-bfb1-412a-b975-ab001ce34dba	TRK-SL-00187	7c175a0e2ad0c78d56a5bf8a3acf7545972de73dfeecc2fb5c281510e597b8d1	2026-04-08	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
9d39466d-5ac2-4ec6-8920-82052a797151	TRK-SL-00188	fd835c768412cc9c589394631e76cf699757beddeaada1cc68f69f75ffe5d64d	2025-05-16	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
d0c1dbd5-ab0d-4744-b2b0-98d5783ff63c	TRK-SL-00189	16c75bb3d2ec3f380177428f7cc9620dc6737dd7a55da848711b8dee5dee2f3f	2025-07-07	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
d92d1c21-70bb-47ac-9d8a-cd01b14ea12a	TRK-SL-00190	4ae137a588a42c6ece5314e42343ba1f56163f288346692b9072c6ef4019c164	2025-08-21	ACTIVE	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
fad5742a-8457-4e21-84b6-9fe8ad916719	TRK-SL-00191	e9ef692442b1c23ee6cb939686402ea78fe4be6e60ffbf72effa1b1339534690	2026-01-12	UNDER_REPAIR	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
2751b996-a382-49c7-ae52-f841a3fb7415	TRK-SL-00192	af6e9e7e1bc5e8994b907e4f9ee50cf3e4c0efa3ae8ca1269603b5d612f38045	2025-08-15	UNDER_REPAIR	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
2cf92150-550b-4141-ab11-27da2283222c	TRK-SL-00193	257e1507086200d003ce4e1ef01e7a0065c2781aa65b942696d81ff08af20633	2025-09-17	UNDER_REPAIR	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
a59c737d-dff4-410d-9944-ab4feafe0983	TRK-SL-00194	7ae76001a9d90c1f5c07b7754ee00703623fed6d65b0a8fe31a1cebee8725ffc	2025-09-28	UNDER_REPAIR	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
5945e6b6-2303-4b5c-85e6-b630580df502	TRK-SL-00195	7790acb66e07ac8de5a2d427b708899803a599f3f04b11a38b61883ef44d78c4	2025-07-28	UNDER_REPAIR	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
f1c405d1-3d22-437e-8c5c-ed068f54d5bd	TRK-SL-00196	5dbd3c95dc2486d7256dc1c36e43729bcc3bf5dd952fc3ab5a5f37bd76541b3c	2026-01-03	UNDER_REPAIR	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
936184c9-e935-4ba5-b9fc-6aa62c28600a	TRK-SL-00197	11aed2b290919d85e7e3b3f2313a2f8c3e941842952164ad6a94af698ec846f1	2025-06-07	UNDER_REPAIR	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
c014770f-aa47-4ea0-93d6-0daf752d79ce	TRK-SL-00198	da86611418c0b17657f280dffc7bfd952263ed427cfdf5bd5a69a7e4d01e1bab	2025-12-31	UNDER_REPAIR	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
1aec48d3-b547-4cc1-a01a-d92a8dafc338	TRK-SL-00199	afe8870d4e41cfc2754a2986c492b2ae757119a9a30a251ea421b1fac7a76715	2026-01-07	UNDER_REPAIR	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
7c209387-ca21-416e-adda-a2431c25f620	TRK-SL-00200	cde31c0db67ce529c079ae48a6853d77b146db38bb1500dde65fb4accde34c29	2025-06-11	UNDER_REPAIR	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
5421078d-3b6f-4d3a-bd06-4ce96b4899f3	TRK-SL-00201	f8902b53deaaa149e9c4f1091a4e0515b90b299c11ed0944f19ce1e47def1f95	2025-08-11	UNDER_REPAIR	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
fe654711-2875-4baf-aed2-c521bf81e6df	TRK-SL-00202	a25c016bd5a0f702993c304d292f2e817a039e6ba6db8a4d55a0d1beda2580aa	2025-07-10	UNDER_REPAIR	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
187f8bdf-70c6-4f37-9cdf-0e4019e15f3c	TRK-SL-00203	5895087c68c4fcd6fd1a8ae94f3f8c8612faa5df0607d02e84150259cd37a9cd	2025-10-19	UNDER_REPAIR	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
84dd896e-b9f7-461d-ae95-7b7a67263c56	TRK-SL-00204	47cb8cb519b5bc0cf6cd43d62d20366c1255bfae559e5441d97a04e0792ebc3b	2025-04-26	UNDER_REPAIR	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
041818a4-ca98-462d-bdb5-a430a0aeb45d	TRK-SL-00205	d12b08b1f77b5a356314f91939585bf979f35e182c37a3b3f7ed16a7c8fc4a13	2026-04-15	UNDER_REPAIR	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
07d5c509-ad70-47fc-8ef8-994aaa427165	TRK-SL-00206	0d6ef1d222f3bf6c1d34c4b0f6ce4d604279636e0036e22f3be604c084020779	2025-10-22	DECOMMISSIONED	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
9181fa61-6630-471c-bcf5-f72588435490	TRK-SL-00207	42de1487d51020d0fb0db36e76e9d4809b58925f60cba93ce22fccc78c7fb3cc	2026-03-06	DECOMMISSIONED	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
296e296a-5e35-4ddd-bfd9-950fc2f0810a	TRK-SL-00208	426a5cadd4b30f863794836252207a2faf7e77d590d0d7206499896a7d5f4b46	2025-12-19	DECOMMISSIONED	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
2111d0de-171e-4da6-b62f-646825de8111	TRK-SL-00209	2e59a8f73ba43b06c247c1dbac73086ca7172e88b20cfc2d813e1ce75e3c22bd	2026-04-13	DECOMMISSIONED	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
f8d4fb87-45c2-4f41-86d0-681428dfbd0b	TRK-SL-00210	3dd41e2a7ce8d3856399243248cd49a62ed45b7be97355bdea207dd3bc45fa5a	2025-11-14	DECOMMISSIONED	2026-04-25 14:17:59.247032+00	2026-04-25 14:17:59.247032+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.users (user_id, badge_number, password_hash, first_name, last_name, assigned_station_id, system_role, is_active, created_at, updated_at) FROM stdin;
99af9c30-72e6-4608-83a1-72004c417677	SLP-00001	$2b$12$KqFJGxlRbOlJKM7qglTVcO.xW8V/mLvFRdG1DhHdyJGQvxiy5s7Ca	Rohan	Perera	\N	SUPER_ADMIN	t	2026-04-25 14:17:59.240081+00	2026-04-25 14:17:59.240081+00
59e9eecf-9415-4077-afac-68d3e84abafa	SLP-00002	$2b$12$KqFJGxlRbOlJKM7qglTVcO.xW8V/mLvFRdG1DhHdyJGQvxiy5s7Ca	Nimal	Silva	c83cade7-837c-4c39-bded-401a45722fa0	PROVINCIAL_COMMANDER	t	2026-04-25 14:17:59.240081+00	2026-04-25 14:17:59.240081+00
08227633-08a0-4809-90f5-1f2303dabe32	SLP-00003	$2b$12$KqFJGxlRbOlJKM7qglTVcO.xW8V/mLvFRdG1DhHdyJGQvxiy5s7Ca	Kamal	Fernando	c83cade7-837c-4c39-bded-401a45722fa0	PROVINCIAL_OFFICER	t	2026-04-25 14:17:59.240081+00	2026-04-25 14:17:59.240081+00
42583f8a-0881-4f16-a0d2-dca41b2ae155	SLP-00004	$2b$12$KqFJGxlRbOlJKM7qglTVcO.xW8V/mLvFRdG1DhHdyJGQvxiy5s7Ca	Sunil	Rajapaksa	da57c993-a79a-434b-92e0-25df95cbc5c3	DISTRICT_COMMANDER	t	2026-04-25 14:17:59.240081+00	2026-04-25 14:17:59.240081+00
9fc12040-faae-4d19-8d25-2b4138afd370	SLP-00005	$2b$12$KqFJGxlRbOlJKM7qglTVcO.xW8V/mLvFRdG1DhHdyJGQvxiy5s7Ca	Pubudu	Perera	da57c993-a79a-434b-92e0-25df95cbc5c3	DISTRICT_OFFICER	t	2026-04-25 14:17:59.240081+00	2026-04-25 14:17:59.240081+00
b96e0968-8d4c-43ac-b24c-a5dd007a456b	SLP-00006	$2b$12$KqFJGxlRbOlJKM7qglTVcO.xW8V/mLvFRdG1DhHdyJGQvxiy5s7Ca	Priya	Jayawardena	ce294ca8-06f7-4861-b93d-8ab13cacc074	STATION_COMMANDER	t	2026-04-25 14:17:59.240081+00	2026-04-25 14:17:59.240081+00
25dbe8d5-1aa0-4347-a80b-60975851738f	SLP-00007	$2b$12$KqFJGxlRbOlJKM7qglTVcO.xW8V/mLvFRdG1DhHdyJGQvxiy5s7Ca	Dilshan	Wickramasinghe	ce294ca8-06f7-4861-b93d-8ab13cacc074	STATION_OFFICER	t	2026-04-25 14:17:59.240081+00	2026-04-25 14:17:59.240081+00
fb42c703-90b1-4498-af4d-2ac8522298b4	SLP-00008	$2b$12$KqFJGxlRbOlJKM7qglTVcO.xW8V/mLvFRdG1DhHdyJGQvxiy5s7Ca	Chaminda	Bandara	\N	DATA_REGISTRAR	t	2026-04-25 14:17:59.240081+00	2026-04-25 14:17:59.240081+00
\.


--
-- Data for Name: vehicle_driver_assignments; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.vehicle_driver_assignments (assignment_id, vehicle_id, driver_id, assigned_date, returned_date, created_at) FROM stdin;
cd76fca8-bb91-4631-8e94-9847c31e7715	b41a220e-2d2d-411c-a0c3-b92b81aad916	7e098648-089f-4d53-a670-a5958b669fc0	2025-11-23	\N	2026-04-25 14:17:59.277798+00
578abb8c-33a7-440b-bcc1-9e3d07b09fee	8038636f-71ef-40cf-9c5e-fd76b4719164	3882ff72-6dcc-40df-a5d5-a45dc6b802f6	2026-04-22	\N	2026-04-25 14:17:59.277798+00
860cb079-e6ac-4663-987b-19807746ad4d	fbb2dcf7-445d-4eb0-9688-b9afaffd1d87	b805fe3e-2151-433c-8781-311a2a749d47	2026-01-20	\N	2026-04-25 14:17:59.277798+00
b498508a-7c52-4291-a283-cabf8ff569a8	0dcc7e37-72f3-4b58-8a2a-0565438b7183	44faf91f-439f-4dde-9c58-40df6d3eaf78	2026-01-20	\N	2026-04-25 14:17:59.277798+00
f66290c0-c852-4791-9b44-f536987da7ec	745f9ebf-fe53-4508-9578-dcd481f1c33d	c315d123-0ff1-4faa-a245-4c8276dd09df	2026-04-03	\N	2026-04-25 14:17:59.277798+00
11230137-856a-4a1f-89de-77b325e00a3f	cb8d53f3-5a81-4e6c-a9e5-ec416ccf835c	2561cb27-85be-4574-8a86-4d9c042badf8	2026-01-17	\N	2026-04-25 14:17:59.277798+00
77313367-b4c0-4ac2-b386-f9fa99cd1048	f0643f8d-93d7-4bad-8394-71adfab3572a	109b545f-6e6b-4b39-82fa-77c63c9bb341	2025-12-23	\N	2026-04-25 14:17:59.277798+00
79112a5e-f636-4607-924a-74ae7d988ef9	35f0404f-f1c7-4602-aa96-e73a5dc91365	8287ad71-0402-4c94-8cd2-5dd3560b7711	2025-12-27	\N	2026-04-25 14:17:59.277798+00
e2d7b3a1-69db-42f6-951e-f101ef738aa4	391dce01-81ae-4cd2-bb09-3cdf59dba4da	4dad2d4e-efff-46ca-93c4-25f9fec260a0	2025-12-05	\N	2026-04-25 14:17:59.277798+00
fe2b96e6-d00d-4728-8a82-33137d1855f2	33b8a3bd-ce1b-4527-a3a4-cc6f52272f0c	a62119c9-a596-40d3-ac80-b9c6d36ba898	2026-03-13	\N	2026-04-25 14:17:59.277798+00
3a7062d7-aa03-47e4-9bca-a7124ab5fc8f	3c8fcb57-46d0-4261-b4b2-12bf590f1e73	cd66834c-f062-4497-adae-1abb254e94da	2026-02-23	\N	2026-04-25 14:17:59.277798+00
e421b89d-be7d-48e1-ac87-79abd883609e	513ac9fc-43af-4491-86b0-11177bed52f4	101e0d1c-983e-4923-960e-e347255da100	2026-02-28	\N	2026-04-25 14:17:59.277798+00
97c0c3b8-9b49-4c99-8255-83e3dd232149	09d09835-d531-4ae3-aec4-66efab28c2e0	8c0b80e0-24f4-4b99-9843-c07d182bd3c3	2025-12-04	\N	2026-04-25 14:17:59.277798+00
b43e21f3-60dd-43cf-b7ac-4f94d4d01879	65c25d4c-983b-4223-9c81-74cf54ef3751	59c9ab34-a85c-4fe6-925a-388d7d1bdf95	2026-02-23	\N	2026-04-25 14:17:59.277798+00
a2d30d7e-a766-436d-b8cd-90a2e8f34c81	ff8345d0-a744-442f-b428-289948b09d4b	dbaaaf0f-cce8-4096-af5b-3da9f5c88b01	2025-12-27	\N	2026-04-25 14:17:59.277798+00
b2889c25-9137-4cf4-aa5e-1bfd4ed8110c	bf690a97-8196-4cf3-ae2a-38c0ecd1c596	1035989e-7972-415f-9cdd-47d23b76e5a5	2026-03-13	\N	2026-04-25 14:17:59.277798+00
31972586-09c0-4647-9983-844266170338	5b2a29ff-af24-44ef-a3fe-e372942c33eb	7fff8483-ccef-43b9-86ac-cce917743119	2026-03-27	\N	2026-04-25 14:17:59.277798+00
d58bad1b-32d7-4cde-82d0-fb436b9398f4	9e3a1414-4a29-469c-a696-9142b26b541f	45096544-f036-4309-a990-2d2ebab91b54	2026-04-17	\N	2026-04-25 14:17:59.277798+00
dca42e77-54b0-439e-a31f-af83a6098c91	a13bd8ae-aff2-4869-9a20-648400a58869	87454dc5-7755-4221-9e37-c91803090acc	2026-01-24	\N	2026-04-25 14:17:59.277798+00
385722dd-49b1-416a-bd1f-454fd4868d40	7e7a810d-17b6-4e64-82ed-017bd4f50bdb	b6ba0002-9890-40ca-993b-faf692647b44	2026-01-16	\N	2026-04-25 14:17:59.277798+00
bb399373-294b-4044-b691-335451482eac	b2453001-b162-440f-b6d9-f1933f2f53b5	1c0fd61a-4ecc-44d8-a7b9-db9bd54fe187	2025-12-26	\N	2026-04-25 14:17:59.277798+00
d978fa90-d2ae-4fc9-b369-ce2ad92dd238	de4cfb61-47cc-4cc3-93a8-569c59e87ffe	e937955f-973c-4c42-812e-aa74201ff043	2026-03-25	\N	2026-04-25 14:17:59.277798+00
35138fef-2014-4dd7-84b0-7c67870ce3ff	97bf4614-8548-46f6-9a3a-53158f905dad	38185eb7-1336-45ea-a89f-c5328cd1b05a	2026-01-01	\N	2026-04-25 14:17:59.277798+00
2beb6634-e664-4136-8497-abb0c973d743	ff2b6988-7521-47ac-8cca-15fb718fd62e	9a7bba17-7031-40e2-919c-8de5ba129c04	2026-01-13	\N	2026-04-25 14:17:59.277798+00
32387c1a-7889-44fc-a02a-24acb28f3b5e	9ceccd0e-e2a0-46ba-9ff7-bcbbe2f17bf0	5cc7612c-578c-4cd2-8a8b-b75dd497ff37	2026-04-17	\N	2026-04-25 14:17:59.277798+00
ab099224-50ba-4f35-ac68-c21bd469cac6	290bbb43-cd74-4e78-9292-0a0c433f4bf7	4ddc29c3-f841-4960-9ffb-e2efc4503a67	2026-02-12	\N	2026-04-25 14:17:59.277798+00
d48527cd-5355-4a2f-a76d-ba35c336ad58	38c04113-09f4-440c-8a9a-1314925e4985	59f8b2f4-11a6-4140-961b-4b9a78e7d4e5	2026-02-09	\N	2026-04-25 14:17:59.277798+00
72a020e6-d5f7-4194-9910-da53945cc152	a2619a19-c4e6-4b0b-88ea-1310be30214a	450ac882-73d0-4e89-941c-e72fb48829b3	2026-02-27	\N	2026-04-25 14:17:59.277798+00
6ac7aeaf-6d15-4325-be8b-3d4815d78942	9fc93e6b-c4cc-4ab7-8c7e-591561509635	700eab92-d34b-45c1-8404-87bbc2eb2154	2026-02-05	\N	2026-04-25 14:17:59.277798+00
85ba000f-5d7c-40ce-9f34-7b765dcdd109	6f766acf-d0bc-418b-ab9c-c6a66c1c448e	73cee5f1-8fa9-42ca-9be9-61d27eea5cf8	2026-01-10	\N	2026-04-25 14:17:59.277798+00
1d09b79b-1e15-4891-8189-4a6d05315989	cafd79c8-b71f-4b04-a95a-d31b40dbb433	0752b552-f498-4823-ac06-da20114afcac	2026-04-23	\N	2026-04-25 14:17:59.277798+00
e72ee923-b2ec-4594-94c1-4abc64d990f0	d8c6894e-9a45-4fe7-acba-f8d22fde1566	b5a342f4-dfc8-4c21-85a0-8178896d969b	2026-02-08	\N	2026-04-25 14:17:59.277798+00
6f1c7a5e-42d4-4ade-91da-aa98f25b3b1f	e15b27b6-7d2f-453a-b17e-95975d073438	9d27620c-9ed3-4013-99ce-3bba0d1adf6e	2025-11-16	\N	2026-04-25 14:17:59.277798+00
2efac556-a6d3-4b77-85ab-ceb6e637dd07	308b9ac8-edf9-4bd0-b181-bdcc0fa7d4da	a2f31f50-d000-45dd-bff7-1f2275e96e1d	2025-11-07	\N	2026-04-25 14:17:59.277798+00
58a25bf0-350f-4416-9ccc-ecadf149478f	7909c7c8-245c-4943-909b-832335090380	21d7d0f0-3501-476b-b958-a3cb34d5bdd3	2026-04-05	\N	2026-04-25 14:17:59.277798+00
b816dcd5-9cd8-4b81-ac36-3bf6ec4a05ed	11166c06-db5e-46ac-8795-70260bc1894b	f22b556e-4ea0-4e9a-bede-a156b7179cd8	2026-03-15	\N	2026-04-25 14:17:59.277798+00
41281120-a9eb-4306-bfad-2cc697940634	24938a24-e867-4e69-9884-e4b80db0b00b	5aa3fc45-7c44-4441-8c08-94856dd1ab29	2026-01-13	\N	2026-04-25 14:17:59.277798+00
59578dfd-cd9c-48f4-adf9-d32a43c7b2d1	1fa9abcc-c984-4e42-acd9-96fad7d80765	a237c74b-6565-4c5c-a796-a79cecc0e301	2026-01-13	\N	2026-04-25 14:17:59.277798+00
61261a1b-6ed2-4ef1-a616-00e91fbdec62	2d53e2eb-a1da-46f7-9a85-42c8ff9b9f8c	e283e58d-2772-4d47-b021-b099d6f268f1	2026-03-03	\N	2026-04-25 14:17:59.277798+00
74cc1664-72e7-4163-b0cf-772b889e75d8	7b56e4da-98ea-4034-8d66-c771732e7bf5	7dc992ca-7967-46ce-952b-f337f394b747	2025-12-17	\N	2026-04-25 14:17:59.277798+00
bd9836c8-0f21-412c-9f7a-31b0932e5932	ba963b37-99cf-4e39-bf48-ae44a438aac3	acaf9e1a-6b02-44e5-8d1b-12edec181d17	2026-02-23	\N	2026-04-25 14:17:59.277798+00
0d5f6a8a-473c-4352-acfa-3daa3138558f	a8703d46-50fb-400b-b4a8-a3e49d99a0fa	f3a5bac5-7e8a-47a0-8555-b8d8de5682a3	2026-01-07	\N	2026-04-25 14:17:59.277798+00
8f0a6065-0113-4d31-ba99-4104af6f4dfa	e4fd0d83-9ecd-4471-8dbe-39142566c7a9	671f70df-8283-4009-96c4-7e082ab8f7fb	2025-11-22	\N	2026-04-25 14:17:59.277798+00
50798a9e-d68d-4e02-8428-e03026967ca6	2dc3bd4f-6a64-4dd6-8460-827a1fd4b398	53c40e46-167d-43ce-bd96-3f79869a8371	2026-03-05	\N	2026-04-25 14:17:59.277798+00
abbceb66-562a-4f99-bf43-47f35e1dcb64	5675660e-66db-4024-9028-21f04068b78b	79e87f9b-c5d8-43e4-b9c9-80e5b0a901b3	2026-04-20	\N	2026-04-25 14:17:59.277798+00
37cf2b88-c547-4676-80e9-183fc5603ff9	6943be6b-778c-480b-969b-b420f81bf81c	a169df00-33e9-498d-b178-1ff1e6c90418	2025-12-17	\N	2026-04-25 14:17:59.277798+00
297d8188-64b9-4d17-8161-7e15ccd3ec69	3369d671-b054-459c-8aa6-efa77773a0de	97095519-99f1-4be1-a7bb-e795f3c7e4f2	2026-01-04	\N	2026-04-25 14:17:59.277798+00
0734ab0c-308f-40ae-929d-9e991d2c10f0	9c74261d-691d-4289-a3aa-b7d49970c5b2	46921737-73b7-47b0-a242-d4eec15a6cb6	2026-03-21	\N	2026-04-25 14:17:59.277798+00
82e88ef2-4b68-4722-9fee-5234e64adef0	cbf434a4-26e5-4799-a4a7-55024c83846c	68dfb904-1c96-414b-9d6a-c3603b5948b1	2025-11-07	\N	2026-04-25 14:17:59.277798+00
3edc4de7-bb23-4744-b280-db778683602b	0a0fb5a0-686b-4d98-a1ab-9827a2587153	ce51136b-2bdc-4cda-b33c-710e1dbf466f	2025-10-30	\N	2026-04-25 14:17:59.277798+00
9e454759-ba3e-475c-ba03-760a777ba654	7b0ddf7f-c2f0-44ca-9ed2-177d64cf29ee	eda03964-fe88-4315-a9a5-847773db4e32	2026-02-18	\N	2026-04-25 14:17:59.277798+00
e57791b8-96fb-41a0-9afc-f94728c2c28e	01926b9d-3678-4e20-bd08-680c167a4a09	bb7ce614-40f3-4561-ad5a-633a4f19e2d6	2026-01-20	\N	2026-04-25 14:17:59.277798+00
05e51a4d-34c7-48ff-a165-99953d3809a6	d41e0881-53db-4d82-b710-806b1fedf1b1	ada97d37-d75e-43ca-9edc-0bb83c6e4d8c	2026-03-12	\N	2026-04-25 14:17:59.277798+00
21d32618-5c8e-46f0-a4c8-44f6f60d1963	84868518-5daa-4c50-8054-aec66bf9f568	9573d1d5-f160-43e4-b14b-e352bef57c07	2025-11-18	\N	2026-04-25 14:17:59.277798+00
5992d483-7cee-4851-8504-5fefc757785e	b764b21a-d1e2-427e-8559-8aeb5f024358	e2f0bfb8-f53b-4dc7-9948-01e8e74b76dc	2026-03-17	\N	2026-04-25 14:17:59.277798+00
d4fc5cc2-a584-4776-98e2-8cd3fe11e619	f98efac5-6ed9-4cb2-8545-98988561bb2f	4a97227d-dff4-4450-a51a-87ad81c659a4	2025-12-26	\N	2026-04-25 14:17:59.277798+00
31570f1b-313e-4743-8342-083eba1aaeab	8ea8b45a-97bd-4845-b561-abbe2c009edd	964915a0-0ce2-4869-b255-7e2b2a64f0e1	2026-02-19	\N	2026-04-25 14:17:59.277798+00
f7beb766-9adc-416a-b00c-1ba0204b5329	16afbdba-de12-4ba4-af5e-141b8fefe421	3e078737-1335-4ec2-bad5-785ebd350d1f	2026-03-04	\N	2026-04-25 14:17:59.277798+00
8a640f94-596f-4364-9ab6-210eb0781ab1	b7571481-4fdb-445d-a903-3cce535ddd31	01c1d82e-51f3-40ce-8aee-9a8439594916	2025-11-10	\N	2026-04-25 14:17:59.277798+00
7edebf30-c2ad-4c7b-b76a-d406f4d90c36	6feca0b7-ca3f-40c8-85a5-c88ee620f584	319452b6-73b6-4f3f-8ad5-8f2a4e28279d	2026-02-10	\N	2026-04-25 14:17:59.277798+00
cc1c4e52-c0e4-4961-89ce-cc266dfa6b77	2a1dd763-3545-444c-8442-e5272270709c	3c36ae74-a41b-49a7-a969-08f9070fab4e	2026-03-21	\N	2026-04-25 14:17:59.277798+00
6425b0fb-98be-422b-8a33-af5862455993	92a19b30-d559-4856-a984-40f2233e4025	e66e6203-6239-4c1f-9dfa-78aab779f8ea	2025-10-30	\N	2026-04-25 14:17:59.277798+00
5b94d990-7b3f-4510-9fda-34513d82076d	3b33ae6d-4ae4-4d8f-9fc0-bd76fd9dbe9c	6ed71676-d23e-429b-a80f-b030415bd81d	2025-10-28	\N	2026-04-25 14:17:59.277798+00
99081ced-4e3f-416d-bd9a-0d0df2659f22	68ac4b42-c752-4b79-8379-c37f091171e5	418c2038-2101-4b3c-b7e8-79fa0b909e77	2026-03-21	\N	2026-04-25 14:17:59.277798+00
18fd654c-3846-4796-a875-827f8d153d27	2bd40141-190c-4ece-9bce-13da97fd5809	8076e0ec-b6b5-4de3-a7eb-bc808d4f9a8e	2025-12-27	\N	2026-04-25 14:17:59.277798+00
ccd8417d-49c5-479e-880c-c6d5ee682fa5	2a973155-0f1d-4ca7-bd42-c952589d35b7	56c1f9c5-a3cd-4849-b09b-a8de39f9c4ad	2025-11-30	\N	2026-04-25 14:17:59.277798+00
f6714c57-367e-4ef0-b747-bd7b4c3300b6	3598fd72-e6da-40a8-bd59-9528eacb549c	6ed50aae-e0ed-4090-aad2-9275e76c9738	2026-03-03	\N	2026-04-25 14:17:59.277798+00
29355ce4-f03f-4c38-b5d5-34a34b0ddea1	85488766-cf0a-41a6-9642-2d4a13715a34	af95e8af-df77-4891-bf3d-b136b1aa3af1	2025-11-12	\N	2026-04-25 14:17:59.277798+00
df18beab-0a15-4b2c-bc8c-271b130d016b	373725ef-1cc4-4574-a5ef-32e41ad1616a	b0d24f78-368a-4c17-a210-7f02d1810f62	2026-02-02	\N	2026-04-25 14:17:59.277798+00
19f47ba3-841e-45a2-b0de-b287b465bb9c	fe18c6ad-0428-4f8d-aee9-e1ee528e1c3e	4ad35052-e706-43e8-a41d-f719fa3281ea	2025-12-16	\N	2026-04-25 14:17:59.277798+00
aab84b27-5ba8-479a-af1b-5afc67f6c8bc	4181c51f-2d70-4458-af66-91ed58bc2a39	f59ae2fc-1be5-4b47-a26c-9de87d246eca	2026-02-25	\N	2026-04-25 14:17:59.277798+00
a771fa7e-fc6e-4ae2-94f9-70fbc637012c	87c17de8-57c0-4281-baf1-da1ed8cd7f50	002a6ebe-922b-43a6-9824-260382b35375	2026-04-08	\N	2026-04-25 14:17:59.277798+00
8ac932a4-325b-49ea-ac04-60b5d414b50c	90fa890f-923a-4e03-ad38-f42f5b7908eb	d882deb4-55c3-4561-98fd-7a7c7f77512c	2025-11-22	\N	2026-04-25 14:17:59.277798+00
bb4fdc81-7d8e-433e-946a-74c5f4f55014	a055b03b-8c67-4c1b-9634-bada4a4d78ca	03f4546c-99de-4d6c-a3f0-15af749c8b6a	2025-12-13	\N	2026-04-25 14:17:59.277798+00
4c830691-5ff3-4b28-b1c0-cae839614579	39b6f2df-270b-4af6-bce0-90d20f07b08e	efdb1dd0-95f3-4d67-b995-3fe03be948bd	2026-02-05	\N	2026-04-25 14:17:59.277798+00
6b0374c3-17dc-4bb1-8bfa-4429680bff32	6d0747e9-2779-4134-9f85-6b5aea3722c7	b8f00fb5-fe7c-4e7e-a270-409062c7ddf8	2025-11-07	\N	2026-04-25 14:17:59.277798+00
e9620a2a-9652-441e-ac43-c8f82fc729a2	539aa009-cf17-49a6-b0e1-cf89e2bb2777	3c705cf6-f081-46ba-8916-56b529900b6b	2025-11-19	\N	2026-04-25 14:17:59.277798+00
cc04f7a5-e98f-434e-a5c4-0be03bff9c76	f47e491f-3238-494b-81bb-6afefa22fe48	8df13196-315e-4c8a-a4c0-096c48170ffb	2026-02-11	\N	2026-04-25 14:17:59.277798+00
91179cd0-eaaa-4a3f-a514-09254e9e9084	ef0e49ad-ab2a-4065-a25f-36c8ac55d713	ff767a59-727f-4943-a5ea-a40d18a8bf13	2026-02-21	\N	2026-04-25 14:17:59.277798+00
4c86d952-8469-4fb9-8111-abd70158f577	ee86dd1c-15f8-49ca-9f7c-da918b49b532	4c33cfac-f759-4e9e-ab96-9412fc2fb9b2	2026-02-19	\N	2026-04-25 14:17:59.277798+00
679217d3-6a80-4bea-ae8f-54e4435b757a	4522ee51-a809-4760-8d64-4e5feabad265	08cc14d5-5154-4de4-a744-5e96278413c3	2025-11-08	\N	2026-04-25 14:17:59.277798+00
193a1919-d0cb-4398-9214-e96b640c4dd0	4febb2dc-12ae-4e07-8f75-d5ce21585cab	8e42d1fb-b1e2-499e-8fc3-dd738e564fa1	2026-02-11	\N	2026-04-25 14:17:59.277798+00
a6c5207a-40d3-4aba-89a6-9eed190f33e3	59936a9f-7401-4fc6-a09c-eef5ef5be413	dded94b0-39ba-4bb9-91c7-0392cbe7653a	2026-01-20	\N	2026-04-25 14:17:59.277798+00
cdf816ca-b432-478a-82c8-e577b3a71647	eab192fe-373c-47af-a818-fe5d65fb3338	ee7018ef-65ac-444a-8134-fffc526902cb	2025-11-01	\N	2026-04-25 14:17:59.277798+00
bafd8a79-6602-4b78-a3b6-bcfd38e4a19d	39fdb081-1252-4441-94bd-9bc707baf5f3	51bef558-a606-49b9-bec4-d5905854c480	2026-04-19	\N	2026-04-25 14:17:59.277798+00
7f9c38e5-83df-411b-a46f-6071bcf1ed7b	51593e83-46cb-4114-8822-8d81efb6a4f5	dc0f7235-6fa0-4b12-a3a0-29accd74323e	2026-04-22	\N	2026-04-25 14:17:59.277798+00
da1c95e0-1a6f-49fe-b5e3-fea6b27918c1	d228090f-9e65-45a5-845b-c695bca047cb	31e37ae5-de3f-4ae0-8369-1ebb9aa268ef	2026-01-11	\N	2026-04-25 14:17:59.277798+00
c380eabf-4cc1-4e78-9d69-6b04ee286a13	3480dd0d-1ea6-49f3-a19b-2e4cec8b2e48	a786bf5f-5464-48c2-bd5c-e3d44f3b6f4f	2025-11-12	\N	2026-04-25 14:17:59.277798+00
7a9c7619-6e54-422f-9d66-8676a34e52c2	4018eb31-c75e-417d-a8ca-b35dcdcf231d	b6181689-9e85-4883-bf7d-3fb93fb4d098	2026-04-14	\N	2026-04-25 14:17:59.277798+00
6148298d-1e5d-46f3-8fd4-551aca1eb9e7	0b645a70-a189-491d-8f24-7d91e37558dc	0ef1441b-7ae2-4e43-9a11-e149344104e4	2026-03-06	\N	2026-04-25 14:17:59.277798+00
b64e1f7b-d711-420c-80af-838d3a737f59	4f29c76c-1fda-4c0a-a75e-8b5fa3d6cf6f	7a1ca14f-dd36-4e6c-9274-41b54f82f374	2026-01-09	\N	2026-04-25 14:17:59.277798+00
920e48c8-0650-4602-8ca7-aa684f61a0c8	e963ba2f-5a6c-470d-81b5-104be4ee71e8	46c761c3-d68b-446f-b7d5-52abfed7a796	2025-10-29	\N	2026-04-25 14:17:59.277798+00
f60ad945-f45e-4d47-8d0d-c3a279a66dfd	b212fbaf-194a-4569-bc61-3e45880b2c48	18874dee-1583-4122-8053-974d50d65b61	2026-01-05	\N	2026-04-25 14:17:59.277798+00
a973f4c4-4ac4-4b71-b4a5-13ff93b395fd	89946973-0f3d-4d28-85e5-173207a33d7d	6469f15b-d4c6-4219-9f7a-6b1468665e79	2026-02-23	\N	2026-04-25 14:17:59.277798+00
cd829ced-6529-47e8-af32-14a18f5cf83d	cf445dde-3469-485e-89b9-8359b3d14da0	0e901d4b-9e06-4866-a03a-abbd45626b8a	2026-01-04	\N	2026-04-25 14:17:59.277798+00
5ad2a405-0b4b-4ad4-bb14-e8610e598c1a	b8e2717e-6965-4dd8-b78b-6aaa905b39cf	c90f7c0b-57f2-4d3e-932e-8d7c518310e2	2026-01-22	\N	2026-04-25 14:17:59.277798+00
668c671e-67f8-435c-9c1d-a7274bafa056	210c276e-abdf-4594-b1fe-d85aa1b2e644	6c336d3b-82a8-4e23-a120-12f89a9f405c	2025-12-04	\N	2026-04-25 14:17:59.277798+00
54510622-a7f1-45eb-97c1-429c34d83d5e	c793ea19-0a4d-4b18-8736-731be372c596	d3e4d47e-3843-4297-9b21-3f29f5160130	2026-03-18	\N	2026-04-25 14:17:59.277798+00
6377f253-a426-44fe-84ac-1d9476870d41	11888f52-4f8e-4438-80f4-d2eb5d6642cb	9f8da43f-9e72-4ecd-9839-e6d06e83d458	2026-04-23	\N	2026-04-25 14:17:59.277798+00
19ee183f-7c61-4113-b501-ca2b59c55e8d	10acfcad-f332-4621-982d-ef2071ebbac9	ff0b3382-6aff-4c98-93c8-0a5fb748637b	2026-02-27	\N	2026-04-25 14:17:59.277798+00
4ce560ab-738a-416e-877e-7627930b9fc4	5d0065fc-a573-46bb-a5ac-fef40405b279	9409c24a-f7d8-4fb0-9ad7-5fb4ef1c9b64	2025-11-20	\N	2026-04-25 14:17:59.277798+00
70af0a5e-8d7a-4131-963a-bfa6a874be0d	29881302-2108-4ea0-b485-d8c1badf1a50	44cede87-02fb-470a-89e0-6530f825e689	2025-12-26	\N	2026-04-25 14:17:59.277798+00
2e9254b8-60fe-4827-a295-b700dff6c6bf	6c980d07-5aac-4cee-b944-2ccb3b76505f	9bc2a72d-a3af-4cc3-ae83-3dd19b651286	2026-02-08	\N	2026-04-25 14:17:59.277798+00
a3c49283-eeba-4945-8393-dc5be385eba0	fa91b7d7-5f08-4c59-80ef-69473596272f	67f4ac31-a382-43b2-b1a4-3bff8c909369	2025-10-31	\N	2026-04-25 14:17:59.277798+00
7205547c-ad72-42b6-9da9-6e49594c1147	1e902c18-daa8-44e9-9709-c2f4493149b4	6b0139d9-5fac-4aa2-8104-af2b2dae34ae	2026-04-07	\N	2026-04-25 14:17:59.277798+00
6299f2b0-bd5e-4f2a-b64f-9482685f4d0b	1ad6480e-1757-482f-8d14-92cc27cfaba3	d41fe21a-f678-4ae0-af85-9bd07b638960	2026-02-18	\N	2026-04-25 14:17:59.277798+00
8f0ea7c8-0363-49d3-8e86-b7f04548b48c	e925e54a-34ac-4ed9-91e7-115d71e3fe5a	2728a542-39fd-4542-90bb-f0e4004da248	2026-04-24	\N	2026-04-25 14:17:59.277798+00
17cf6e30-1bc8-4389-a59f-c19faf4f32c7	eff0b6ad-6a17-4e8c-9caf-64be5f7b19f2	05b2cc75-93ea-45c9-8998-32bea4981e01	2026-01-16	\N	2026-04-25 14:17:59.277798+00
e21f5c65-c0f7-4419-bd53-dce992de0e66	b2e189cd-f130-4ebc-8f97-da645e04d578	a1e68931-5169-402b-af56-568655186206	2025-12-14	\N	2026-04-25 14:17:59.277798+00
4194d4f3-e5e1-4806-9d01-837f17462578	fbf92e6c-d6f3-4cb7-a194-45c93e61aee2	1805839b-9d84-4e88-b4dd-fdd611c6f273	2026-01-08	\N	2026-04-25 14:17:59.277798+00
87a50b68-0f12-4181-9bc3-fb34b266ea8c	ce1fe30d-fd59-47f9-88d9-937539d0c1d6	e42d0ecf-119f-4166-91d2-ce939d22d563	2026-03-26	\N	2026-04-25 14:17:59.277798+00
541f0e6e-d440-4526-a167-cb745e977461	1a5847a6-3d66-4f26-9647-26363fbb03d6	e12480b6-e39a-457e-a9fe-d764530c3c5b	2026-03-17	\N	2026-04-25 14:17:59.277798+00
6ca15f96-19d1-4c61-86ca-a46bea31c41c	e0c11531-4a07-469f-abde-93eca9340b97	d4b8e5ea-dffe-46df-a0d9-dd5180a750c3	2026-04-07	\N	2026-04-25 14:17:59.277798+00
fff3be7a-0cf2-4123-b7bd-e7031ff06b80	ff804ef8-cb6e-4db7-8325-d5b744fb6717	9363549e-0a65-40fd-8644-1aefa5d767b5	2025-11-07	\N	2026-04-25 14:17:59.277798+00
602e6641-e824-457e-b62c-afe28cd81668	ab34074f-c14a-45c3-b4d4-927ca89cc7bc	af68e08f-7801-407d-a62f-1d206ceb8579	2026-01-28	\N	2026-04-25 14:17:59.277798+00
c2626103-c761-4a6d-b58b-41948eab596c	0941f21d-f19e-4958-9e8f-a95beb1deea1	b669caff-5e66-4795-9cdb-7e82db0f74bf	2026-04-05	\N	2026-04-25 14:17:59.277798+00
08d8f39d-7664-45b0-97ac-a7f2f46f91d9	2e8a144d-a93a-4ea4-b79a-76172b91c49b	f2fe2a27-0ffd-4931-ae36-cd8e6dc79a84	2025-12-08	\N	2026-04-25 14:17:59.277798+00
eec83652-54b3-4b91-94ca-9eedbf2387bb	e2ead87b-2172-4f02-912c-88c73ca1d16c	1d554225-3149-4b0a-99a2-03b0e5aef7f5	2025-12-13	\N	2026-04-25 14:17:59.277798+00
8f9c9fb9-14f0-4777-ace8-7b96bb7b5024	9d581644-fde2-41b4-a3c7-5bafb342068a	17cee7aa-561d-4ce5-a75b-976135068927	2026-03-11	\N	2026-04-25 14:17:59.277798+00
e88d4f95-641e-4386-96da-6b520a3dffb0	4540c730-33b6-4d90-95cf-46b3d53833ba	05358ee1-2d8e-4321-9c5a-41860da7bb8d	2026-02-28	\N	2026-04-25 14:17:59.277798+00
b0f8de68-a02b-4376-83d9-f3c4fce90f66	c9fb0893-9d40-487c-be6e-b00dfef54224	3336e92f-175c-4c0b-9aa0-7689230e5dee	2026-02-12	\N	2026-04-25 14:17:59.277798+00
7ea05311-8d40-4c49-9614-d1c02500b8bc	b2fb30b0-3d9c-4e56-885d-6769b739c388	040d2702-9dae-4b9b-9b21-ffd193b53e5e	2026-01-09	\N	2026-04-25 14:17:59.277798+00
37b46e27-4eac-407c-813c-27fe5e71b1ad	c4ad147a-13b4-41dc-9b50-d75841f1ce21	f04786b6-42b5-4c7a-b527-3b18ba9f0e6b	2026-02-17	\N	2026-04-25 14:17:59.277798+00
fd44abd9-5aee-4832-bc6c-19b8c99ecb13	b1be5f59-73cb-4ad0-9dab-a78224d9f700	8e72fd1c-57f3-4450-a8f5-6e9a2b95d362	2026-02-07	\N	2026-04-25 14:17:59.277798+00
5bdf52d3-63f2-40bc-9498-f02e5bfd115a	8e322815-6f28-4e92-85c4-eb9701a44056	9b2b5635-3b3e-49e8-998f-87fb2d7bd3b0	2025-12-30	\N	2026-04-25 14:17:59.277798+00
e7a0dff2-ff4c-4731-8e6c-a19240473e48	a0a79411-3828-4eba-bd44-5d6a0c5a1f6a	d844b787-ef44-4820-80d8-1cf04a5f14fa	2026-02-21	\N	2026-04-25 14:17:59.277798+00
1bdf061a-bf69-4279-9ac9-89c2ce1d6347	180ab962-eb7c-4e9b-89fa-95a58c3cad0c	b76cd552-1611-442c-9d40-eb981864c0b0	2026-03-27	\N	2026-04-25 14:17:59.277798+00
1dd4fa9c-8521-4894-aca2-9acef9fc1280	4d4f10ba-9b03-4de6-9ee1-fa630180e7f1	7c470c8a-c70b-43a8-86e7-d439444eccdb	2026-04-18	\N	2026-04-25 14:17:59.277798+00
7945c029-b0c5-4b79-8ea9-a3cc9d94ac6d	bb4cde3a-215f-4c25-8810-7ecc3821a3bd	543ec8c9-92e7-474d-826d-f408ecd5caa6	2026-03-03	\N	2026-04-25 14:17:59.277798+00
7a2e1ada-22a0-4769-930b-2f20e5c9fce3	acd66dfb-ba87-40c0-86b8-e4ed190e68fa	505cdc94-bc3a-4967-972e-1f4c98a3d216	2026-02-02	\N	2026-04-25 14:17:59.277798+00
f1299703-44df-4b45-b8b9-ace6cd323019	f1185054-a5ae-4edd-8e67-ab7288a4c339	bb92d68f-c0b7-4b9b-9580-59abfb4882d4	2026-01-18	\N	2026-04-25 14:17:59.277798+00
20264309-a580-4e83-a612-2341941d563d	01264433-b021-458c-b9e3-584b7c5d7db7	4b16fa4f-3e9b-4153-a423-c00f47b1073e	2025-12-14	\N	2026-04-25 14:17:59.277798+00
b0dd686e-425c-46fd-a750-f7508023443e	9b38d36f-4ece-4387-abda-d5514adb3eb5	d9dac0a1-a3c9-45ff-b8bf-190647976900	2026-04-12	\N	2026-04-25 14:17:59.277798+00
7d2f5710-7efc-4317-9f78-a300c31b5b64	18162de4-67a5-4fe6-a181-1c3e8f0411e9	8be52721-9db4-481a-8937-c938132ada91	2025-11-04	\N	2026-04-25 14:17:59.277798+00
cc945f75-1efd-4b1d-86df-3d2574d1a3a2	1a37bb5b-1391-4781-ad94-401d840e9f53	3982d8fd-6883-4e73-98c8-3646c6aaf45a	2026-01-07	\N	2026-04-25 14:17:59.277798+00
8e6fc388-b4aa-49a3-bfb8-a79007d84e11	15af9574-5fd3-4e3a-a6ed-fdfcd07dc01a	5918066e-8546-4cc0-b05a-63e0dfd5fb50	2026-03-23	\N	2026-04-25 14:17:59.277798+00
72e2fdb1-23da-4e8f-a5ad-41bfd4deaeb4	9cd5f982-db68-4dcc-813a-640abba4c7d8	9e1d5252-8bf0-4931-88a1-3633b3b9cf23	2026-01-24	\N	2026-04-25 14:17:59.277798+00
c90bd8ce-b0da-45b3-b371-b3fda1cd3767	2c7bcaad-4e09-4d57-80fe-ed958e4d96e1	ceb1c66c-85ef-4929-85dd-2e5a019139d1	2025-11-06	\N	2026-04-25 14:17:59.277798+00
2e366ea7-86fb-459b-a6cf-42e919d3346d	ada492a5-a573-4f6e-81fd-d7a48b761315	acc78ec0-e104-4d49-9e4f-289782c77978	2025-12-13	\N	2026-04-25 14:17:59.277798+00
f6a0ecaf-8416-4d5f-9b7a-934f40df87cf	86f78bdc-abce-44ae-b26c-50b2c0cbab8f	ada48545-13d1-407f-a881-f2cd67c6a193	2026-04-23	\N	2026-04-25 14:17:59.277798+00
faf97d80-8682-494c-b305-dbc992329da1	0d435a62-f9ce-44ac-943f-f2bbbf8324e5	527c5198-8e2e-41a1-a868-1afd41656b71	2026-03-17	\N	2026-04-25 14:17:59.277798+00
b05e99fb-b534-4a4d-8f21-066fd4e66322	6d222edb-7f60-4450-87d0-b5c6451a8fc6	05a23f88-77ba-43a3-9756-9a3e6470b8f1	2026-04-09	\N	2026-04-25 14:17:59.277798+00
80d8bc38-c2a9-4ee5-aac4-5969678ca93d	b7c610a5-6414-4bfd-b0da-9ba77c1c5e8f	001f7b77-a6ca-451d-937b-0b3f8383499c	2026-01-30	\N	2026-04-25 14:17:59.277798+00
10a10bd8-a2e8-4598-b2c2-44bf0c646026	4e60dcbc-8539-4fe0-bb9e-d49fd2d721c0	5d1c1cd2-3f97-4dd7-8f1d-d3fe36f39157	2026-01-31	\N	2026-04-25 14:17:59.277798+00
877985c0-a319-4d7c-9933-04c0f02df219	5af71d06-2fbd-4d7d-b7f5-33fe41e94bab	518e79b8-9d51-41b7-839b-c027e27dce04	2026-03-16	\N	2026-04-25 14:17:59.277798+00
cb4d49ad-28a8-413b-9ec1-fce604213783	349aa6b4-cb02-40b7-9225-34fa930e0c76	0879ee02-ada0-461b-a1c8-9d392fe1b4c8	2026-01-18	\N	2026-04-25 14:17:59.277798+00
4acccd5e-b536-4add-aaec-66aa55020f0e	0912981e-8141-4cb4-9507-d577643262e9	13623b36-ad4f-4269-b062-88e1df9979ee	2026-03-03	\N	2026-04-25 14:17:59.277798+00
7f2a19c2-4031-45de-8218-cb95681432d8	c6fbb3fe-b9a9-4e4f-b3ed-8188981dfa1a	aae22339-e47c-44ff-a476-10709b94be81	2026-04-03	\N	2026-04-25 14:17:59.277798+00
8b9fa1c4-984b-4905-a857-ad0673b20eb9	35f25971-9aa5-4f26-9c81-f0a273397abe	878943df-aff2-4b1d-a884-1c24b7f58b71	2026-04-17	\N	2026-04-25 14:17:59.277798+00
9229f436-ca86-4775-b2f6-f9a6e963cbe9	03882625-64fb-4a93-b4ed-8ab0db3dde5d	0fe99a72-2d7f-4316-a826-6ebd990fbacf	2026-04-24	\N	2026-04-25 14:17:59.277798+00
8576a179-4098-46ff-ac4a-a0ebed944ac2	251aaf2a-d35c-45be-ba67-2207d92edceb	af8cb819-45b4-4c48-a953-0d5f920a2acd	2026-01-07	\N	2026-04-25 14:17:59.277798+00
527516ef-1577-4be1-a496-cb256a969a43	872dda2a-da96-4346-8b2a-765cb9351983	4d2dd3d2-1e57-442c-95ef-c9937d91b65f	2026-04-17	\N	2026-04-25 14:17:59.277798+00
378e993e-62ef-4b10-8d1d-fbc9c0281034	ae0777aa-fdad-4205-acad-d9a20b3006b3	1b39892e-ba0b-44f6-9314-c3c13a86d28b	2025-12-20	\N	2026-04-25 14:17:59.277798+00
f12f786e-016b-441e-8562-55e8a93945fd	c1e038f0-e5f6-4284-b380-e249c81d00ec	16580cdc-7412-4d83-b0c0-de2a04a6a088	2026-03-04	\N	2026-04-25 14:17:59.277798+00
62571565-0939-48cf-a578-cc1cdc3255b2	110a3ee2-1c8b-4442-8b82-30a199b1bd33	e12af0e0-f7ad-4abc-be36-aed40ab26b6a	2026-03-04	\N	2026-04-25 14:17:59.277798+00
38da25b7-12aa-4c58-852d-bba08cbb3279	8d7919d7-7aef-4155-b796-3f9386e5bbfd	308f4d8f-a5fa-420d-9333-e8b819e9ba7e	2025-11-27	\N	2026-04-25 14:17:59.277798+00
c173b171-ea7c-4cbc-885f-4b1bda76af09	bbdcf058-5cb1-45c0-84c2-0ed269c323c5	a1444e90-2730-4d44-96af-17ae49b83fac	2026-02-10	\N	2026-04-25 14:17:59.277798+00
bc29a15c-0be6-4b1b-b42f-0ed6c6636cf1	60f89b5e-4b1d-470d-8636-6e6674632b1d	4232d345-9679-433d-9081-0cf76511a9cd	2026-02-27	\N	2026-04-25 14:17:59.277798+00
54dc86bd-cd90-4615-b0e8-ce432f46a25c	02fbb244-abf5-45ea-bc44-260dac6497fc	fc1724d2-2dcc-4b5c-97e1-75ebf77eca2e	2026-04-18	\N	2026-04-25 14:17:59.277798+00
5e3e5419-0235-46e7-a772-0e6a404cdeb3	22172885-0c58-41ae-84bb-d5045d17ae77	0e9b9a4c-8641-49b3-8565-5c2879389cfe	2026-03-11	\N	2026-04-25 14:17:59.277798+00
d19be681-d5ea-499d-8d8f-398093839550	d12eedbe-bba5-4d98-b7b4-7d4033d5795c	becb4e4f-e14c-4c4a-bf67-6d50d24d29ec	2026-01-22	\N	2026-04-25 14:17:59.277798+00
0152d8d1-c081-495c-b2e4-e9d905f2e5de	9f45f857-aa4a-463c-a212-e0ff61810dbc	65c30f9e-57e1-48b7-a4a7-7cd439f5e0a8	2026-03-27	\N	2026-04-25 14:17:59.277798+00
8c5cc160-f302-49cd-b160-1908c84ff746	59bcf08a-ecba-479a-89d1-ac15f031d881	4378226e-ca7b-452e-ae11-c9fd611e7b66	2025-12-27	\N	2026-04-25 14:17:59.277798+00
07f096e4-0b37-4aa7-9b6a-7798d740ce93	a9563358-784b-42d0-98e2-f483272cbb16	9a333cc1-2dec-4000-9d52-70b9285d821a	2025-11-21	\N	2026-04-25 14:17:59.277798+00
79359fec-6e50-4140-8eea-c6857a54ec97	1ecc5861-604c-4d89-af6c-6b11ce91d3f8	4b3fd9f5-f609-4941-8876-abaeb365a0e6	2025-12-01	\N	2026-04-25 14:17:59.277798+00
0b22b3f0-184b-478a-bd50-cfd940b8cfad	e46263e9-4999-4936-8570-d45917c984fd	66ec16a3-2887-4e9c-b708-e7ce7c4c708d	2026-03-26	\N	2026-04-25 14:17:59.277798+00
9dfb4fe0-c7e1-4ff6-a0c8-c0a5c84744fe	ca5f74fa-c9bf-4334-8cd6-2f1cfe332a64	30522d09-bc69-4bb3-9c7d-133870985bc8	2026-02-06	\N	2026-04-25 14:17:59.277798+00
0360c9c1-1999-4d60-b4af-25123395312e	9253045d-8471-4db6-bad2-878c06644b16	35eebec5-afff-4ac4-b75a-89125506a5de	2025-11-06	\N	2026-04-25 14:17:59.277798+00
6c964d2b-3105-4588-9a24-2c35cfacb3b9	e231bdbe-711d-4178-99cc-692bf4aeda50	f2d0a295-6cb3-4c16-be65-7c6d7c291741	2026-01-23	\N	2026-04-25 14:17:59.277798+00
cbbdd77a-40e1-4706-b609-5a406aef50e1	6ae02345-a411-4374-8547-740f5fddc2e6	c694ea8f-981d-43a5-8644-1ecc7ec9b8ed	2025-11-30	\N	2026-04-25 14:17:59.277798+00
6cc01006-1855-4023-b072-8dce9a085af4	adb4d80c-2fcf-448e-a717-793ed88e5a5b	f9c7abbd-0dba-4119-ad01-9143c27ade84	2025-12-30	\N	2026-04-25 14:17:59.277798+00
952ba722-5ead-4b7a-b477-61f383c379a5	b5b6f1e5-a207-463e-ac36-0c87d94f925a	bec74f92-3970-4d2f-93cd-1e3ec240b1e5	2025-11-07	\N	2026-04-25 14:17:59.277798+00
aa5a4ee8-31bd-4d20-aa1b-cb52edd7e0ae	4e17ca3a-149e-47c7-a481-cbae932b1746	cf20d58f-2937-4b7b-b862-ebf09574942e	2025-11-26	\N	2026-04-25 14:17:59.277798+00
a3ff6b35-5268-404a-bc78-33c17ab55e14	50d1b075-2f87-4961-814b-f979fc4888d5	fe3f3387-f5b6-4c62-9268-72f57e4abe2d	2026-03-09	\N	2026-04-25 14:17:59.277798+00
6494527f-5b20-43ba-9853-303f68453af1	b1813b9b-ee59-408e-aa27-71ccd95551db	781cdfe3-df71-4884-b8c7-75df5740a4df	2025-12-01	\N	2026-04-25 14:17:59.277798+00
14964e20-d4b1-41bc-98f3-5f6fe39e0ee4	50133679-66b9-498d-b0fe-15925109c166	dc654026-f7cf-4893-afe1-503f565d601f	2026-01-29	\N	2026-04-25 14:17:59.277798+00
dc18142f-fe55-4d98-8c4a-c94006714dfa	4875f1ce-ff31-44a4-905d-f7a98216c497	d10b0760-ed5d-49b7-b1ff-761daa27ad42	2026-01-28	\N	2026-04-25 14:17:59.277798+00
413faa13-cc6c-40bc-b404-d55359fcc309	37f769ae-7017-4f4c-8710-1c07976a4b2b	af69b856-85d2-4c1d-beec-d0b685d34561	2026-03-11	\N	2026-04-25 14:17:59.277798+00
a7713b1f-f652-4b5a-a71f-72173dadad75	16a38bab-936e-451d-90a6-5566d4a6f0d8	c95d945a-c454-4c9d-a7ed-432df0afaf31	2026-02-21	\N	2026-04-25 14:17:59.277798+00
2ba30b00-a3a5-4668-8b07-d0c29befbf16	dbfd1888-ff12-4a12-b935-bb5030bb9a9d	d5b5e225-b72d-4fe8-9afd-bb38dc948591	2026-03-25	\N	2026-04-25 14:17:59.277798+00
30cba787-6746-40c6-b65e-fa5b78ff9602	840b10bb-c418-4ccc-b1ef-62cb1c0bf038	98726b6c-5217-4605-a68a-846652fcab0a	2025-11-10	\N	2026-04-25 14:17:59.277798+00
2271a64c-6fe6-44e1-9d85-949fa43d4f77	1aa6ba11-2dfa-4503-aade-02742dae76f7	6675c0f7-2674-4428-b4c4-cd8f6ac5e57b	2026-03-27	\N	2026-04-25 14:17:59.277798+00
a784b63e-ed90-49f2-90bd-2764f7a0b377	5975f98b-a5df-4acb-824c-8a2cc5ebc6dc	5bc48e03-2a59-4854-ba98-b1aedf7107cd	2026-03-14	\N	2026-04-25 14:17:59.277798+00
520ad8f5-088a-4452-b2e7-0e568e0af569	fc80dda2-0224-4ae7-b2ed-f07bc5956c24	60d98ac6-70cd-4a4f-9c6e-8d25655d754f	2025-10-30	\N	2026-04-25 14:17:59.277798+00
671a51f8-9380-4289-bcf4-312b5a7a29b7	d121f261-a9bd-4d90-902f-d0ab70a5bc9d	7de4cfac-708a-445f-9c33-c3799d64c005	2026-01-10	\N	2026-04-25 14:17:59.277798+00
aa7ee527-22d7-4cdd-a91d-3d0601f4215e	623bbb3d-4687-48b7-bb39-c275d4241421	bd69eaab-908c-44ab-bb83-cd4b3f4130df	2026-02-14	\N	2026-04-25 14:17:59.277798+00
ecb36fcb-48ab-4598-b099-541dba4e984b	b4f97c89-d726-4e90-ba24-8f84eb42a963	61c0f24f-e1b8-4d32-96ae-b8aca81d1322	2026-01-04	\N	2026-04-25 14:17:59.277798+00
cf20600a-5663-48dc-9693-b496c075833f	31d27c76-6a8d-40b9-a5fe-0d97cb526b84	51d728b9-f3da-490d-b8fc-8f5c0f86fcba	2026-03-10	\N	2026-04-25 14:17:59.277798+00
e6fab7f6-8bec-4ba8-9668-349eb9e67f4d	4170002e-9fa7-4063-8189-72b4620e9723	378f435c-8166-4d90-8b28-037f4538bca7	2026-01-15	\N	2026-04-25 14:17:59.277798+00
89c39a1f-6508-4c87-8779-8c50164d78fd	5798e277-3699-4ab5-a815-e897b74fd5ab	5feba92b-7750-428a-8856-33abe6b8354a	2025-12-04	\N	2026-04-25 14:17:59.277798+00
f90df5ff-47a4-4045-8ef7-94ba5fd08ac8	31704e28-e911-447a-b907-b7e427e490f1	e27f7db3-e909-45e6-b059-54764f912f1c	2025-12-14	\N	2026-04-25 14:17:59.277798+00
fa240e88-811b-44cf-9de3-305f46b5120b	ac3c0fc8-d8e1-4188-8ce1-43faf240799a	bf75c0b8-dd04-4161-9ec2-2dad64966988	2026-02-04	\N	2026-04-25 14:17:59.277798+00
494582f0-d37c-498c-be22-c698a3d69497	4a04483a-7b32-40ae-a56e-f47b5c9a39ff	86895ac3-2731-46ea-8036-8ebe8b80b4ca	2026-02-11	\N	2026-04-25 14:17:59.277798+00
790c0166-6d48-429e-bfeb-69b53240e142	8482d1f8-b91e-4829-baa3-5dd3b5d10454	0f1ce726-73c3-4dbe-b6d5-4f5ad7949f62	2026-03-11	\N	2026-04-25 14:17:59.277798+00
db7d6eab-5fe5-4f63-9a37-7fabd7ed74a3	8924862b-4482-41b7-90eb-8cd9e0d7d7c4	d684ae4e-40c9-4ab8-bc2d-a5a674aa9813	2026-01-01	\N	2026-04-25 14:17:59.277798+00
8bfb8554-9d08-4036-b725-db3c5b1e152f	6558a46d-f513-4b30-a6c5-671aa37ec4cc	bf4967bf-5863-4788-9091-f0e29a15d21f	2025-11-23	\N	2026-04-25 14:17:59.277798+00
88d5e0aa-7202-4b45-aa9e-5dae63d88bfc	8a27f782-1d4a-4e03-98b6-422a538e7321	331c35f9-6ed1-405d-9c16-34895732e0da	2025-12-09	\N	2026-04-25 14:17:59.277798+00
70b240e8-8095-4794-a13e-c9a7b8c0bf13	d976794b-07ae-4d49-919a-697eb36f98ea	bb2bbe26-b9fb-432a-a017-4559710e46a2	2025-11-08	\N	2026-04-25 14:17:59.277798+00
06c6945f-735b-4d05-b669-cfb3613a3874	82c286fb-399f-43db-b316-6769313afb8a	70784432-0dbb-4d6f-a8bc-c43cb78c991e	2025-12-09	\N	2026-04-25 14:17:59.277798+00
1e8fd973-d6a3-4498-8d0b-8512aab0b10d	0f49866b-d1df-44c2-85b9-ac49101224ab	164a6930-516d-41bc-bcf5-e76e2ebc4c41	2025-11-06	\N	2026-04-25 14:17:59.277798+00
a4480334-4f42-4815-8aa4-25810f1ec8e7	e5575391-dbed-4c44-9a72-e4eb88f8a952	85c89f14-d46e-4c60-bc67-fd5c3335968d	2025-12-22	\N	2026-04-25 14:17:59.277798+00
2cd0e452-352e-471e-9ef7-4559a9ff0c7a	5abcaa6f-b557-4ef6-936c-e17eff5a5f9d	192a3041-7c47-4e02-a483-c5cf07da4243	2025-12-18	\N	2026-04-25 14:17:59.277798+00
0de0243f-13bd-4f00-a12e-8b1d0203dcdf	53ef75ec-65c2-4cbb-b2b7-5e8f2483ccae	3fc7d71c-0895-485b-9d2f-1918855a1910	2026-02-18	\N	2026-04-25 14:17:59.277798+00
373de5fd-e677-45d5-8adf-db68b770f807	3e1b6de4-7c29-41a5-8581-e6ab46c8f61b	0c9160fe-d060-456f-b235-a83ba5bb2d50	2026-02-25	\N	2026-04-25 14:17:59.277798+00
9c1701d9-66ff-404a-8b61-b33ca13a1245	f372c878-43f7-4d7e-b482-52d2e68d5d8b	bfb58d0a-9738-4905-bdaa-a405179dfb0b	2026-02-16	\N	2026-04-25 14:17:59.277798+00
\.


--
-- Data for Name: vehicles; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.vehicles (vehicle_id, registration_number, chassis_number, color, make_model, device_id, police_status, owner_nic, owner_full_name, owner_contact, ds_division_id, created_at, updated_at) FROM stdin;
b41a220e-2d2d-411c-a0c3-b92b81aad916	WP AAA-4477	CHASSIS00000001	Blue	Bajaj RE	6b49f43b-3479-4f5b-944a-51a1d8c50ea2	CLEAN	136115677V	Isuru Kumara	+94752653787	ec8a93e7-c100-43c5-94de-1cec705443a4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
8038636f-71ef-40cf-9c5e-fd76b4719164	WP AAB-6534	CHASSIS00000002	Green	Bajaj RE	7251d07b-4b5e-43b2-804a-fea5458b3674	CLEAN	19743813909	Hirantha Perera	+94723566662	149ffe17-b992-4f01-9172-b326792e23a7	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
fbb2dcf7-445d-4eb0-9688-b9afaffd1d87	WP AAC-9692	CHASSIS00000003	Red	Bajaj RE	8501c237-9c16-45d5-9351-3185397d319c	CLEAN	882423854V	Janaka Gunasekara	+94763213170	5de7741b-b338-4bc9-95fc-8820fedecc6f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
0dcc7e37-72f3-4b58-8a2a-0565438b7183	WP AAD-4466	CHASSIS00000004	Green	Bajaj RE	2fbb2512-20fc-48d8-be0d-8291474a48ee	CLEAN	19942929204	Roshan Seneviratne	+94784042644	149ffe17-b992-4f01-9172-b326792e23a7	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
745f9ebf-fe53-4508-9578-dcd481f1c33d	WP AAE-2247	CHASSIS00000005	Red	Bajaj RE	2df01c92-36aa-462b-9db1-35777238282c	CLEAN	636616582X	Roshan Silva	+94741722303	9b64dd36-0061-4ca0-bb7f-ee1545eb0fa4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
cb8d53f3-5a81-4e6c-a9e5-ec416ccf835c	WP AAF-4168	CHASSIS00000006	Orange	Bajaj RE	b6f32cb2-978c-49e1-9602-696733fb9351	CLEAN	19828381229	Kamal Seneviratne	+94755736761	1b108646-fc07-4eda-8c37-8f9a8ae50db3	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
f0643f8d-93d7-4bad-8394-71adfab3572a	WP AAG-8187	CHASSIS00000007	Yellow	Bajaj RE	711051b4-2133-4785-a758-047e0a5805f6	CLEAN	846324112X	Rashmi Jayawardena	+94759585899	c5e35455-05f1-4d1f-8be9-e2896c16a58a	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
35f0404f-f1c7-4602-aa96-e73a5dc91365	WP AAH-9345	CHASSIS00000008	Green	Bajaj RE	382a052e-2f4c-46f9-8b0b-f01451f76cc3	CLEAN	19799524787	Chathura Kumara	+94723735307	5de7741b-b338-4bc9-95fc-8820fedecc6f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
391dce01-81ae-4cd2-bb09-3cdf59dba4da	WP AAJ-2573	CHASSIS00000009	Orange	Bajaj RE	75e286c8-7c08-489f-a7c5-d36dc1311912	CLEAN	897864523V	Chamari Dissanayake	+94782728264	e56d85a6-8adc-4ef4-a8c7-a73363415b04	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
33b8a3bd-ce1b-4527-a3a4-cc6f52272f0c	WP AAK-1851	CHASSIS00000010	Silver	Bajaj RE	eec04469-2dd9-4988-8307-c02cdc9c5767	CLEAN	19978061233	Kamal Gunasekara	+94727819245	1b108646-fc07-4eda-8c37-8f9a8ae50db3	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
3c8fcb57-46d0-4261-b4b2-12bf590f1e73	WP AAL-4680	CHASSIS00000011	Silver	Bajaj RE	388d2fae-0808-4126-889a-3d10eddd46a5	CLEAN	995411532X	Hirantha Jayawardena	+94777641636	1b108646-fc07-4eda-8c37-8f9a8ae50db3	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
513ac9fc-43af-4491-86b0-11177bed52f4	WP AAM-3214	CHASSIS00000012	Red	Bajaj RE	78a1c285-9055-4067-800f-65846eb7a97c	CLEAN	19865573491	Janaka Madushanka	+94786230706	e56d85a6-8adc-4ef4-a8c7-a73363415b04	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
09d09835-d531-4ae3-aec4-66efab28c2e0	WP AAN-6182	CHASSIS00000013	Yellow	Bajaj RE	86123902-be81-4b42-94f7-88f7521ba943	CLEAN	476685268V	Ruwan Bandara	+94755745331	1b108646-fc07-4eda-8c37-8f9a8ae50db3	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
65c25d4c-983b-4223-9c81-74cf54ef3751	WP AAP-5614	CHASSIS00000014	Orange	Bajaj RE	b1540a21-2b1c-49de-a3ae-a82cd8c08f85	CLEAN	19771260384	Lasith Kumara	+94711206031	9b64dd36-0061-4ca0-bb7f-ee1545eb0fa4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
ff8345d0-a744-442f-b428-289948b09d4b	WP AAQ-9351	CHASSIS00000015	Yellow	Bajaj RE	d4edb7cd-475f-43db-b283-12973460fa4f	CLEAN	212639373X	Kasun Rajapaksa	+94741177308	6632cd97-4b95-46ff-adaf-d6d927035f58	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
bf690a97-8196-4cf3-ae2a-38c0ecd1c596	WP AAR-2528	CHASSIS00000016	Blue	Bajaj RE	13dcedaa-bf5a-47e3-b2f9-a6fd5e845370	CLEAN	19746445795	Isuru Wickramasinghe	+94766698670	5de7741b-b338-4bc9-95fc-8820fedecc6f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
5b2a29ff-af24-44ef-a3fe-e372942c33eb	WP AAS-1276	CHASSIS00000017	Silver	Bajaj RE	bea82b24-d165-4e72-a6ec-55a5a7042701	CLEAN	177561387X	Prasad Bandara	+94751601246	271f0bf8-6856-4232-8338-3da20373e733	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
9e3a1414-4a29-469c-a696-9142b26b541f	WP AAT-4822	CHASSIS00000018	Blue	Bajaj RE	7c2e5e66-786d-41d4-897f-631ae16e1125	CLEAN	19804060733	Buddika Dissanayake	+94758410069	271f0bf8-6856-4232-8338-3da20373e733	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
a13bd8ae-aff2-4869-9a20-648400a58869	WP AAU-6674	CHASSIS00000019	Silver	Bajaj RE	c278853c-ba0c-4561-b97d-c5452b6ed98c	CLEAN	782009865V	Rashmi Seneviratne	+94772591699	9b64dd36-0061-4ca0-bb7f-ee1545eb0fa4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
7e7a810d-17b6-4e64-82ed-017bd4f50bdb	WP AAV-2908	CHASSIS00000020	Blue	Bajaj RE	1890e28c-b210-4d73-842c-d70742359fe5	CLEAN	19947309279	Pavithra Wijesinghe	+94777568259	ec8a93e7-c100-43c5-94de-1cec705443a4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
b2453001-b162-440f-b6d9-f1933f2f53b5	WP AAW-8903	CHASSIS00000021	Orange	Bajaj RE	1a0f2094-a178-4d37-bcee-7c1daa1c5dc8	CLEAN	534288437V	Hirantha Perera	+94747785808	c5e35455-05f1-4d1f-8be9-e2896c16a58a	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
de4cfb61-47cc-4cc3-93a8-569c59e87ffe	WP AAX-5667	CHASSIS00000022	Silver	Bajaj RE	684e0199-afe1-4042-8f7a-196935006e70	CLEAN	19996236158	Prasad Gunaratne	+94785066334	a6facf79-f149-47d0-ad68-bfe9d30b88d8	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
97bf4614-8548-46f6-9a3a-53158f905dad	WP AAY-5977	CHASSIS00000023	Silver	Bajaj RE	22bb0036-c016-4396-8735-917dbffde252	CLEAN	110878728X	Anusha Rathnayake	+94756174458	6632cd97-4b95-46ff-adaf-d6d927035f58	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
ff2b6988-7521-47ac-8cca-15fb718fd62e	WP AAZ-9030	CHASSIS00000024	Green	Bajaj RE	dcfe9fce-ee63-4967-b987-f3485e52c078	CLEAN	19726681202	Sachini Rajapaksa	+94725552626	bf848422-face-42a9-b51c-63284c38ba13	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
9ceccd0e-e2a0-46ba-9ff7-bcbbe2f17bf0	WP ABA-2622	CHASSIS00000025	Green	Bajaj RE	4f9ff7b8-b441-4473-8fe4-93850c00ba62	CLEAN	274533233X	Sachini Ranasinghe	+94774682362	271f0bf8-6856-4232-8338-3da20373e733	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
290bbb43-cd74-4e78-9292-0a0c433f4bf7	WP ABB-8445	CHASSIS00000026	Yellow	Bajaj RE	1c253d9d-efa7-4c21-9cdb-566b7b617359	CLEAN	19831402171	Asanka Amarasinghe	+94741932572	e56d85a6-8adc-4ef4-a8c7-a73363415b04	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
38c04113-09f4-440c-8a9a-1314925e4985	WP ABC-8269	CHASSIS00000027	White	Bajaj RE	ca550595-d2b9-4ede-bcfe-2bbcc98c5706	CLEAN	662984964X	Janaka Bandara	+94741535515	6f4505e2-e82a-4476-be62-37e3a72719f5	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
a2619a19-c4e6-4b0b-88ea-1310be30214a	WP ABD-8985	CHASSIS00000028	Blue	Bajaj RE	107075a5-28cb-47be-ac4c-41667a5e5c2f	CLEAN	19957897487	Thilak Liyanage	+94753900028	ec8a93e7-c100-43c5-94de-1cec705443a4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
9fc93e6b-c4cc-4ab7-8c7e-591561509635	WP ABE-2563	CHASSIS00000029	Green	Bajaj RE	107e57e4-d26f-4089-938f-002c9755389c	CLEAN	435451186V	Sachith Liyanage	+94742076801	ec8a93e7-c100-43c5-94de-1cec705443a4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
6f766acf-d0bc-418b-ab9c-c6a66c1c448e	WP ABF-8965	CHASSIS00000030	Blue	Bajaj RE	e8dd9881-9b14-449a-95fe-9bfeee0e0994	CLEAN	19838305135	Mahesh Wijesinghe	+94753308093	1b108646-fc07-4eda-8c37-8f9a8ae50db3	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
cafd79c8-b71f-4b04-a95a-d31b40dbb433	WP ABG-6788	CHASSIS00000031	Orange	Bajaj RE	1b9bbcac-dd2f-44fc-952c-aa04439cfb4c	CLEAN	459193578V	Gayan Gunasekara	+94751415861	015da7d7-6d1f-4a6a-9c2e-c349f8a95517	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
d8c6894e-9a45-4fe7-acba-f8d22fde1566	WP ABH-2027	CHASSIS00000032	Green	Bajaj RE	0bdd83dd-42e7-4ea8-9a8f-829656d905cc	CLEAN	19899403635	Dilshan Jayasuriya	+94722192131	a6facf79-f149-47d0-ad68-bfe9d30b88d8	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
e15b27b6-7d2f-453a-b17e-95975d073438	WP ABJ-4114	CHASSIS00000033	Silver	Bajaj RE	9866d19e-f188-45da-9c91-3a67c63fc095	CLEAN	180460223X	Kamal Senanayake	+94776489947	149ffe17-b992-4f01-9172-b326792e23a7	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
308b9ac8-edf9-4bd0-b181-bdcc0fa7d4da	WP ABK-3401	CHASSIS00000034	Green	Bajaj RE	71d40a9a-1fe8-40c2-9dc3-cae5933fb567	CLEAN	19845654766	Ruwan Rajapaksa	+94724407607	1b108646-fc07-4eda-8c37-8f9a8ae50db3	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
7909c7c8-245c-4943-909b-832335090380	WP ABL-7666	CHASSIS00000035	Blue	Bajaj RE	05f195f3-0650-463e-937c-f8107851c519	CLEAN	172988476V	Upul Seneviratne	+94742967049	bf848422-face-42a9-b51c-63284c38ba13	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
11166c06-db5e-46ac-8795-70260bc1894b	WP ABM-1181	CHASSIS00000036	Green	Bajaj RE	56a09034-dd28-486f-9a47-6d3d3a23cf40	CLEAN	19746842158	Dilini Wijesinghe	+94748192719	23e935dc-5df8-431d-a5af-929cfc9c719f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
24938a24-e867-4e69-9884-e4b80db0b00b	WP ABN-3432	CHASSIS00000037	Yellow	Bajaj RE	8330fe16-20c0-400a-8e53-f1c1e64a0d38	CLEAN	357432496X	Sandya Wijesinghe	+94761655203	23e935dc-5df8-431d-a5af-929cfc9c719f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
1fa9abcc-c984-4e42-acd9-96fad7d80765	WP ABP-6715	CHASSIS00000038	Blue	Bajaj RE	67a7e3de-406f-4762-8bfc-feca33d49e8c	CLEAN	19795508363	Harsha Seneviratne	+94779309521	bf848422-face-42a9-b51c-63284c38ba13	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
2d53e2eb-a1da-46f7-9a85-42c8ff9b9f8c	WP ABQ-5840	CHASSIS00000039	Yellow	Bajaj RE	9a837038-21dd-4ef8-a0bf-8665fb65a475	CLEAN	474223076V	Chamari Pathirana	+94764273816	23e935dc-5df8-431d-a5af-929cfc9c719f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
7b56e4da-98ea-4034-8d66-c771732e7bf5	WP ABR-8232	CHASSIS00000040	Silver	Bajaj RE	4461e57d-9bec-415d-85db-ccbb924f4442	CLEAN	19719655028	Roshan Jayasuriya	+94745945608	04deeaf8-d443-40ce-9ee9-06e80159dd09	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
ba963b37-99cf-4e39-bf48-ae44a438aac3	WP ABS-1652	CHASSIS00000041	White	Bajaj RE	30781108-f53c-41b6-9028-153ed36e6194	CLEAN	225519040X	Sandya Gunaratne	+94714972673	6632cd97-4b95-46ff-adaf-d6d927035f58	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
a8703d46-50fb-400b-b4a8-a3e49d99a0fa	WP ABT-4552	CHASSIS00000042	Red	Bajaj RE	35a61a6d-b439-4d34-985e-39795ee37a8d	CLEAN	19723437207	Dilshan Liyanage	+94789229900	c5e35455-05f1-4d1f-8be9-e2896c16a58a	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
e4fd0d83-9ecd-4471-8dbe-39142566c7a9	WP ABU-2154	CHASSIS00000043	White	Bajaj RE	945c8496-cd65-4d7c-ac6e-63fbb7f36d14	CLEAN	307470473V	Shehan Dissanayake	+94751259953	bf848422-face-42a9-b51c-63284c38ba13	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
2dc3bd4f-6a64-4dd6-8460-827a1fd4b398	WP ABV-8918	CHASSIS00000044	Silver	Bajaj RE	34e9d343-c8f9-4ea5-97f9-299dae73ad22	CLEAN	19895707468	Thilak Jayawardena	+94729008045	9b64dd36-0061-4ca0-bb7f-ee1545eb0fa4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
5675660e-66db-4024-9028-21f04068b78b	WP ABW-1031	CHASSIS00000045	Silver	Bajaj RE	bfa9d7a2-b802-4d16-9fc0-1a82816e2528	CLEAN	658527314V	Pradeep Wijesinghe	+94744749591	015da7d7-6d1f-4a6a-9c2e-c349f8a95517	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
6943be6b-778c-480b-969b-b420f81bf81c	WP ABX-7694	CHASSIS00000046	Yellow	Bajaj RE	4d90c88d-327d-40b6-917a-988aa04d0757	CLEAN	19771601982	Janaka Liyanage	+94785141746	149ffe17-b992-4f01-9172-b326792e23a7	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
3369d671-b054-459c-8aa6-efa77773a0de	WP ABY-8251	CHASSIS00000047	Silver	Bajaj RE	6b8a4b6e-c8c4-4153-9f62-96f489d404f2	CLEAN	424622143X	Kasun Wickramasinghe	+94726198905	149ffe17-b992-4f01-9172-b326792e23a7	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
9c74261d-691d-4289-a3aa-b7d49970c5b2	WP ABZ-3154	CHASSIS00000048	Orange	Bajaj RE	52279684-79bd-43c4-87d1-ac3316026afd	CLEAN	19951793563	Rashmi Gunasekara	+94778770951	bf848422-face-42a9-b51c-63284c38ba13	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
cbf434a4-26e5-4799-a4a7-55024c83846c	WP ACA-1934	CHASSIS00000049	White	Bajaj RE	26101e19-03bf-4577-98bf-f1b381993748	CLEAN	292749751X	Chaminda Jayasuriya	+94725081587	6f4505e2-e82a-4476-be62-37e3a72719f5	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
0a0fb5a0-686b-4d98-a1ab-9827a2587153	WP ACB-7459	CHASSIS00000050	White	Bajaj RE	2e8ad2c3-2b29-4481-b0c2-c68b5594b008	CLEAN	19872040964	Nimasha Silva	+94786548699	6632cd97-4b95-46ff-adaf-d6d927035f58	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
7b0ddf7f-c2f0-44ca-9ed2-177d64cf29ee	WP ACC-7659	CHASSIS00000051	Silver	Bajaj RE	4acc59c3-8d10-4805-81ed-2110606bb67a	CLEAN	468015430V	Janaka Liyanage	+94751622573	271f0bf8-6856-4232-8338-3da20373e733	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
01926b9d-3678-4e20-bd08-680c167a4a09	WP ACD-4046	CHASSIS00000052	Blue	Bajaj RE	201a8a21-8112-4ae2-bda5-1df3fb192b28	CLEAN	19859185792	Dilshan Fernando	+94745378571	149ffe17-b992-4f01-9172-b326792e23a7	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
d41e0881-53db-4d82-b710-806b1fedf1b1	WP ACE-4622	CHASSIS00000053	Blue	Bajaj RE	3683bd9f-596c-4f2f-b3c7-0cce822c6dc7	CLEAN	765940849V	Malith Herath	+94779804838	6f4505e2-e82a-4476-be62-37e3a72719f5	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
84868518-5daa-4c50-8054-aec66bf9f568	WP ACF-6774	CHASSIS00000054	Red	Bajaj RE	bc895503-cba5-4934-82eb-bb8d8ce5f553	CLEAN	19753727132	Pradeep Perera	+94718342390	bf848422-face-42a9-b51c-63284c38ba13	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
b764b21a-d1e2-427e-8559-8aeb5f024358	WP ACG-9290	CHASSIS00000055	Orange	Bajaj RE	d50f7e85-5577-4ee3-8334-65bdf0d551a0	CLEAN	185039573X	Chaminda Kumara	+94725567158	6f4505e2-e82a-4476-be62-37e3a72719f5	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
f98efac5-6ed9-4cb2-8545-98988561bb2f	WP ACH-2815	CHASSIS00000056	Green	Bajaj RE	6d615999-c4d2-4983-ae31-15b2ca23930f	CLEAN	19884447146	Mahesh Madushanka	+94769277715	5de7741b-b338-4bc9-95fc-8820fedecc6f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
8ea8b45a-97bd-4845-b561-abbe2c009edd	WP ACJ-7624	CHASSIS00000057	Orange	Bajaj RE	0ebde3d8-7bca-423d-a3b7-6de9a5d60a1f	CLEAN	926709889V	Iresha Liyanage	+94746993102	015da7d7-6d1f-4a6a-9c2e-c349f8a95517	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
16afbdba-de12-4ba4-af5e-141b8fefe421	WP ACK-9925	CHASSIS00000058	Orange	Bajaj RE	e86b07c5-d40b-410d-bfa0-57287b16f0f1	CLEAN	19829720222	Hirantha Herath	+94772269502	a6facf79-f149-47d0-ad68-bfe9d30b88d8	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
b7571481-4fdb-445d-a903-3cce535ddd31	WP ACL-7618	CHASSIS00000059	Yellow	Bajaj RE	1d5226ea-c399-4014-a0ff-0ffd2e5fb970	CLEAN	951149393X	Roshan Madushanka	+94719199744	04deeaf8-d443-40ce-9ee9-06e80159dd09	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
6feca0b7-ca3f-40c8-85a5-c88ee620f584	WP ACM-5759	CHASSIS00000060	Red	Bajaj RE	9ed9e421-1b0b-471e-9127-344c031bc1b0	CLEAN	19958658511	Hirantha Fernando	+94747577954	5de7741b-b338-4bc9-95fc-8820fedecc6f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
2a1dd763-3545-444c-8442-e5272270709c	WP ACN-4239	CHASSIS00000061	Yellow	Bajaj RE	0690b2e8-f766-46f1-a7d7-f2145da5a7da	CLEAN	192270635X	Dilshan Wijesinghe	+94718841895	6f4505e2-e82a-4476-be62-37e3a72719f5	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
92a19b30-d559-4856-a984-40f2233e4025	WP ACP-1320	CHASSIS00000062	Red	Bajaj RE	98ce1c4e-d747-4ee1-94e2-1d7fd57cbe76	CLEAN	19719368174	Nimasha Wijesinghe	+94711625804	c5e35455-05f1-4d1f-8be9-e2896c16a58a	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
3b33ae6d-4ae4-4d8f-9fc0-bd76fd9dbe9c	WP ACQ-9053	CHASSIS00000063	Red	Bajaj RE	f6e3a372-e7b7-49cb-bb88-dd814daa0244	CLEAN	296738199V	Sachith Rathnayake	+94771156385	6632cd97-4b95-46ff-adaf-d6d927035f58	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
68ac4b42-c752-4b79-8379-c37f091171e5	WP ACR-6725	CHASSIS00000064	Silver	Bajaj RE	82af0431-b5ad-4842-8166-2c691ac34a2f	CLEAN	19702319119	Anusha Jayasuriya	+94742800107	149ffe17-b992-4f01-9172-b326792e23a7	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
2bd40141-190c-4ece-9bce-13da97fd5809	WP ACS-6189	CHASSIS00000065	Silver	Bajaj RE	d7c44880-8895-4c45-9a2c-f6fdbaaef833	CLEAN	796547888X	Nadun Seneviratne	+94746107519	a6facf79-f149-47d0-ad68-bfe9d30b88d8	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
2a973155-0f1d-4ca7-bd42-c952589d35b7	WP ACT-7649	CHASSIS00000066	Blue	Bajaj RE	6c302842-1bf1-446a-a54e-7b5719f15e38	CLEAN	19926240262	Gayan Abeysekara	+94756597440	6632cd97-4b95-46ff-adaf-d6d927035f58	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
3598fd72-e6da-40a8-bd59-9528eacb549c	WP ACU-4205	CHASSIS00000067	Red	Bajaj RE	b82a6d0f-4228-4afc-b85b-9a4c5a68e558	CLEAN	760522297X	Nuwan Gunaratne	+94715390261	5de7741b-b338-4bc9-95fc-8820fedecc6f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
85488766-cf0a-41a6-9642-2d4a13715a34	WP ACV-3333	CHASSIS00000068	Orange	Bajaj RE	7de19884-44ae-41fb-a971-93f52a239db9	CLEAN	19728248062	Sachith Abeysekara	+94759266348	1b108646-fc07-4eda-8c37-8f9a8ae50db3	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
373725ef-1cc4-4574-a5ef-32e41ad1616a	WP ACW-2439	CHASSIS00000069	White	Bajaj RE	945339b3-4c55-4918-becc-c46f9f852353	CLEAN	693316459X	Chathurika Perera	+94728786570	ec8a93e7-c100-43c5-94de-1cec705443a4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
fe18c6ad-0428-4f8d-aee9-e1ee528e1c3e	WP ACX-4181	CHASSIS00000070	White	Bajaj RE	2e47c63b-f5ea-4e49-a66f-074f33c31dab	CLEAN	19897880872	Dhanushka Herath	+94781983381	1b108646-fc07-4eda-8c37-8f9a8ae50db3	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
4181c51f-2d70-4458-af66-91ed58bc2a39	WP ACY-3667	CHASSIS00000071	Green	Bajaj RE	2169355c-4859-48c9-b831-49b5b34139b6	CLEAN	429474114V	Pradeep Rathnayake	+94784013685	5de7741b-b338-4bc9-95fc-8820fedecc6f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
87c17de8-57c0-4281-baf1-da1ed8cd7f50	WP ACZ-9757	CHASSIS00000072	Green	Bajaj RE	4b42c4ee-2bf1-4cb2-b63b-26d6379e3713	CLEAN	19806303923	Chathura Senanayake	+94718055261	9b64dd36-0061-4ca0-bb7f-ee1545eb0fa4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
90fa890f-923a-4e03-ad38-f42f5b7908eb	WP ADA-4069	CHASSIS00000073	Silver	Bajaj RE	1a1ea4ab-c9bd-499d-9433-81072375ecbc	CLEAN	589096610X	Dhanushka Weerasinghe	+94713838614	149ffe17-b992-4f01-9172-b326792e23a7	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
a055b03b-8c67-4c1b-9634-bada4a4d78ca	WP ADB-4149	CHASSIS00000074	Yellow	Bajaj RE	4ab65884-3e9b-4cb4-b05f-587eabd0ccfc	CLEAN	19817776840	Janaka Weerasinghe	+94751039584	6632cd97-4b95-46ff-adaf-d6d927035f58	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
39b6f2df-270b-4af6-bce0-90d20f07b08e	WP ADC-5754	CHASSIS00000075	Green	Bajaj RE	d2ed692d-f509-40d4-b7d9-dd5b7de5ac5c	CLEAN	280710627V	Thilak Senanayake	+94759596893	1b108646-fc07-4eda-8c37-8f9a8ae50db3	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
6d0747e9-2779-4134-9f85-6b5aea3722c7	WP ADD-7099	CHASSIS00000076	Red	Bajaj RE	2a1ab5b3-0eca-4d70-a93b-e1140c92e1f4	CLEAN	19872548404	Hirantha Dissanayake	+94775017525	ec8a93e7-c100-43c5-94de-1cec705443a4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
539aa009-cf17-49a6-b0e1-cf89e2bb2777	WP ADE-5407	CHASSIS00000077	Blue	Bajaj RE	bc251fd6-683f-43bc-8ed9-b2fdfd3962a1	CLEAN	259616349V	Shehan Rajapaksa	+94755676353	9b64dd36-0061-4ca0-bb7f-ee1545eb0fa4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
f47e491f-3238-494b-81bb-6afefa22fe48	WP ADF-1520	CHASSIS00000078	Red	Bajaj RE	9c4129cb-ea99-4d10-a24c-ef83ed5559b5	CLEAN	19956531756	Nadeesha Wickramasinghe	+94714031579	6632cd97-4b95-46ff-adaf-d6d927035f58	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
ef0e49ad-ab2a-4065-a25f-36c8ac55d713	WP ADG-8895	CHASSIS00000079	Green	Bajaj RE	6a1cdb94-e2e9-4205-a719-c9b0dcdccc74	CLEAN	320876049X	Janaka Amarasinghe	+94747363117	9b64dd36-0061-4ca0-bb7f-ee1545eb0fa4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
ee86dd1c-15f8-49ca-9f7c-da918b49b532	WP ADH-5758	CHASSIS00000080	Silver	Bajaj RE	7ab57fa8-6683-4638-a4f4-2ab469b12d22	CLEAN	19798863964	Mahesh Herath	+94749141098	a6facf79-f149-47d0-ad68-bfe9d30b88d8	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
4522ee51-a809-4760-8d64-4e5feabad265	WP ADJ-1557	CHASSIS00000081	Green	Bajaj RE	88fc6653-4d54-4bae-a1c8-b57547404f3e	CLEAN	111008503V	Chaminda Ranasinghe	+94764880655	1b108646-fc07-4eda-8c37-8f9a8ae50db3	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
4febb2dc-12ae-4e07-8f75-d5ce21585cab	WP ADK-3715	CHASSIS00000082	White	Bajaj RE	9fb81ee9-081d-454d-b98b-490718734299	CLEAN	19956011401	Nimasha Jayawardena	+94789276745	6632cd97-4b95-46ff-adaf-d6d927035f58	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
59936a9f-7401-4fc6-a09c-eef5ef5be413	WP ADL-2388	CHASSIS00000083	White	Bajaj RE	e81e962e-8f44-4df3-ae34-de912e975c59	CLEAN	786185273X	Nimasha Wickramasinghe	+94747053517	e56d85a6-8adc-4ef4-a8c7-a73363415b04	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
eab192fe-373c-47af-a818-fe5d65fb3338	WP ADM-8083	CHASSIS00000084	White	Bajaj RE	c942db3d-5546-4c37-bf36-989b64b7f948	CLEAN	19794003804	Roshan Gunasekara	+94758115357	1b108646-fc07-4eda-8c37-8f9a8ae50db3	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
39fdb081-1252-4441-94bd-9bc707baf5f3	WP ADN-9334	CHASSIS00000085	Green	Bajaj RE	eaf8b340-6806-4024-a6c7-53ab3b114b96	CLEAN	130139295V	Menaka Mendis	+94729100286	c5e35455-05f1-4d1f-8be9-e2896c16a58a	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
51593e83-46cb-4114-8822-8d81efb6a4f5	WP ADP-7841	CHASSIS00000086	Red	Bajaj RE	25cfff44-b44e-42a0-88f9-f5c5f100d074	CLEAN	19845277033	Saman Herath	+94768937525	ec8a93e7-c100-43c5-94de-1cec705443a4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
d228090f-9e65-45a5-845b-c695bca047cb	WP ADQ-5169	CHASSIS00000087	Green	Bajaj RE	f7489862-db92-4ce1-b4a0-206a04c97b3d	CLEAN	288902149X	Nuwan Bandara	+94755669960	ec8a93e7-c100-43c5-94de-1cec705443a4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
3480dd0d-1ea6-49f3-a19b-2e4cec8b2e48	WP ADR-7816	CHASSIS00000088	Green	Bajaj RE	a6c7d502-a06b-4061-a5a0-9345a84a8be2	CLEAN	19812488825	Chaminda Pathirana	+94764662943	1b108646-fc07-4eda-8c37-8f9a8ae50db3	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
4018eb31-c75e-417d-a8ca-b35dcdcf231d	WP ADS-5067	CHASSIS00000089	Red	Bajaj RE	f8373a22-0790-4088-b67b-91caf7c3aded	CLEAN	876576620X	Dilini Jayawardena	+94753181501	271f0bf8-6856-4232-8338-3da20373e733	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
0b645a70-a189-491d-8f24-7d91e37558dc	WP ADT-2652	CHASSIS00000090	Green	Bajaj RE	bce92dee-da69-41a5-a4d0-20db1887d5d0	CLEAN	19946061201	Dilshan Herath	+94787056242	6f4505e2-e82a-4476-be62-37e3a72719f5	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
4f29c76c-1fda-4c0a-a75e-8b5fa3d6cf6f	WP ADU-7571	CHASSIS00000091	Green	Bajaj RE	1274549b-2f9e-4f4a-a136-4e997b9f1afa	CLEAN	346627496X	Nadun Abeysekara	+94753968398	ec8a93e7-c100-43c5-94de-1cec705443a4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
e963ba2f-5a6c-470d-81b5-104be4ee71e8	WP ADV-7483	CHASSIS00000092	Red	Bajaj RE	fba45771-ec86-4f2c-b51d-a310385cab6d	CLEAN	19996198198	Chamari Amarasinghe	+94715982122	ec8a93e7-c100-43c5-94de-1cec705443a4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
b212fbaf-194a-4569-bc61-3e45880b2c48	WP ADW-3368	CHASSIS00000093	Red	Bajaj RE	50f6c7a0-e01a-4398-8c20-4794bcf4b94d	CLEAN	456489979X	Gayan Jayasuriya	+94718743331	ec8a93e7-c100-43c5-94de-1cec705443a4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
89946973-0f3d-4d28-85e5-173207a33d7d	WP ADX-8584	CHASSIS00000094	Red	Bajaj RE	74b4654d-c2ef-4a4c-9d1d-51e28113fe47	CLEAN	19799810014	Thilini Silva	+94785169004	015da7d7-6d1f-4a6a-9c2e-c349f8a95517	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
cf445dde-3469-485e-89b9-8359b3d14da0	WP ADY-2909	CHASSIS00000095	Yellow	Bajaj RE	f4310759-e670-4cf9-bb16-2c2653ae3f0a	CLEAN	839728968V	Chaminda Senanayake	+94768894793	271f0bf8-6856-4232-8338-3da20373e733	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
b8e2717e-6965-4dd8-b78b-6aaa905b39cf	WP ADZ-2600	CHASSIS00000096	Red	Bajaj RE	fc08b54c-fa58-47e6-8cab-291ea6741890	CLEAN	19719063588	Nimal Wijesinghe	+94768122569	6f4505e2-e82a-4476-be62-37e3a72719f5	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
210c276e-abdf-4594-b1fe-d85aa1b2e644	WP AEA-4078	CHASSIS00000097	Silver	Bajaj RE	65ea97da-466a-4d6e-8926-6c5758a41b49	CLEAN	267126057X	Prasad Rajapaksa	+94743847777	ec8a93e7-c100-43c5-94de-1cec705443a4	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
c793ea19-0a4d-4b18-8736-731be372c596	WP AEB-8312	CHASSIS00000098	Silver	Bajaj RE	83cbe658-1750-4aa6-baf3-efdc328c8763	CLEAN	19739384506	Prasad Bandara	+94769839117	04deeaf8-d443-40ce-9ee9-06e80159dd09	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
11888f52-4f8e-4438-80f4-d2eb5d6642cb	WP AEC-8415	CHASSIS00000099	Blue	Bajaj RE	de9e3465-5108-4ef4-9e7f-821275a93ca6	CLEAN	505228415V	Dhanushka Gunaratne	+94752165263	23e935dc-5df8-431d-a5af-929cfc9c719f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
10acfcad-f332-4621-982d-ef2071ebbac9	WP AED-6984	CHASSIS00000100	Orange	Bajaj RE	0616ca8b-d747-4d88-88e5-4b74c672eb3b	CLEAN	19757281477	Thilini Dissanayake	+94774141559	6632cd97-4b95-46ff-adaf-d6d927035f58	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
5d0065fc-a573-46bb-a5ac-fef40405b279	WP AEE-1892	CHASSIS00000101	Green	Bajaj RE	8a399552-6bf0-4291-9cb9-d47fbd631758	CLEAN	284589489V	Nimasha Weerasinghe	+94723565419	e56d85a6-8adc-4ef4-a8c7-a73363415b04	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
29881302-2108-4ea0-b485-d8c1badf1a50	WP AEF-6717	CHASSIS00000102	Silver	Bajaj RE	cbfa4e98-2c29-4717-a76a-9511b26b3d86	CLEAN	19953636957	Gayan Gunasekara	+94719055357	015da7d7-6d1f-4a6a-9c2e-c349f8a95517	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
6c980d07-5aac-4cee-b944-2ccb3b76505f	WP AEG-5341	CHASSIS00000103	Yellow	Bajaj RE	048ef3c3-fb7d-46f2-a82b-7399ae753d7a	CLEAN	522352999X	Chamari Jayawardena	+94765451445	5de7741b-b338-4bc9-95fc-8820fedecc6f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
fa91b7d7-5f08-4c59-80ef-69473596272f	WP AEH-9819	CHASSIS00000104	White	Bajaj RE	a04366d9-d282-4bdb-bb0c-c48b163a6fe7	CLEAN	19981393741	Chathurika Gunasekara	+94719646394	015da7d7-6d1f-4a6a-9c2e-c349f8a95517	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
1e902c18-daa8-44e9-9709-c2f4493149b4	WP AEJ-1425	CHASSIS00000105	Red	Bajaj RE	5ccbd3ae-0206-46f6-8386-4bc6ca627bd3	CLEAN	599881930V	Chathurika Bandara	+94754414958	1b108646-fc07-4eda-8c37-8f9a8ae50db3	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
1ad6480e-1757-482f-8d14-92cc27cfaba3	WP AEK-6555	CHASSIS00000106	Red	Bajaj RE	e4d95dd3-01ea-4a8b-a70f-cb184fb61677	CLEAN	19834004772	Kamal Fernando	+94725649769	1b108646-fc07-4eda-8c37-8f9a8ae50db3	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
e925e54a-34ac-4ed9-91e7-115d71e3fe5a	WP AEL-9626	CHASSIS00000107	Yellow	Bajaj RE	6b450036-8b50-49d9-aa92-3f607da252d7	CLEAN	601479150V	Pradeep Abeysekara	+94769200876	6632cd97-4b95-46ff-adaf-d6d927035f58	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
eff0b6ad-6a17-4e8c-9caf-64be5f7b19f2	WP AEM-9307	CHASSIS00000108	Silver	Bajaj RE	f437ca2b-d8fb-4d79-8ff5-e96cfe54d4b5	CLEAN	19997761498	Rashmi Gunasekara	+94719231230	bf848422-face-42a9-b51c-63284c38ba13	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
b2e189cd-f130-4ebc-8f97-da645e04d578	WP AEN-1651	CHASSIS00000109	Green	Bajaj RE	38bf762d-641c-4965-bdee-b6cc5a732e63	CLEAN	145330899X	Chathura Seneviratne	+94747027864	bf848422-face-42a9-b51c-63284c38ba13	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
fbf92e6c-d6f3-4cb7-a194-45c93e61aee2	WP AEP-7567	CHASSIS00000110	Blue	Bajaj RE	f2a12a79-923d-4f7f-a6f6-284785623a20	CLEAN	19886146685	Thilini Liyanage	+94774740695	6632cd97-4b95-46ff-adaf-d6d927035f58	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
ce1fe30d-fd59-47f9-88d9-937539d0c1d6	WP AEQ-6522	CHASSIS00000111	Blue	Bajaj RE	38490452-342e-417d-a856-3f67cd51a787	CLEAN	945001731X	Pavithra Rajapaksa	+94718214935	c5e35455-05f1-4d1f-8be9-e2896c16a58a	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
1a5847a6-3d66-4f26-9647-26363fbb03d6	WP AER-2934	CHASSIS00000112	Yellow	Bajaj RE	209bf768-8269-4f0f-9a23-54d2e2fbd929	CLEAN	19889118119	Saman Wijesinghe	+94765634228	e56d85a6-8adc-4ef4-a8c7-a73363415b04	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
e0c11531-4a07-469f-abde-93eca9340b97	WP AES-6394	CHASSIS00000113	Blue	Bajaj RE	b89aece7-b6be-4a13-bd7e-85bf68ab5a46	CLEAN	509951170X	Chaminda Amarasinghe	+94743814096	271f0bf8-6856-4232-8338-3da20373e733	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
ff804ef8-cb6e-4db7-8325-d5b744fb6717	WP AET-4054	CHASSIS00000114	Green	Bajaj RE	adcdc61d-cb25-4536-8ff2-4c9881b8eb22	CLEAN	19726896302	Roshan Senanayake	+94785957697	23e935dc-5df8-431d-a5af-929cfc9c719f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
ab34074f-c14a-45c3-b4d4-927ca89cc7bc	WP AEU-2539	CHASSIS00000115	Silver	Bajaj RE	a093b4d0-e60d-4941-94e6-e247a9e69cae	CLEAN	802925834V	Nuwan Madushanka	+94719508494	6f4505e2-e82a-4476-be62-37e3a72719f5	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
0941f21d-f19e-4958-9e8f-a95beb1deea1	CP AEV-1305	CHASSIS00000116	Red	Bajaj RE	b91d3af3-a3db-4e8e-9979-6ed9b1ffa8f9	CLEAN	19895499638	Iresha Wickramasinghe	+94786803568	0095b334-c326-48b5-a41c-9fd5b5dda379	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
2e8a144d-a93a-4ea4-b79a-76172b91c49b	CP AEW-3992	CHASSIS00000117	White	Bajaj RE	7d14d4e2-7cd9-4cc0-b77c-09ffd39d8bc6	CLEAN	854909701V	Dilshan Jayawardena	+94769789908	0095b334-c326-48b5-a41c-9fd5b5dda379	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
e2ead87b-2172-4f02-912c-88c73ca1d16c	CP AEX-1214	CHASSIS00000118	Orange	Bajaj RE	a68dea6b-164f-4e5c-95cc-e0472e6abe69	CLEAN	19974081540	Chaminda Jayasuriya	+94742575452	0ca8420a-c7d1-4089-98cd-c5e9661f3eae	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
9d581644-fde2-41b4-a3c7-5bafb342068a	CP AEY-5798	CHASSIS00000119	Orange	Bajaj RE	364c3af9-b5e6-4a58-bbba-7c6c486ba079	CLEAN	160985265V	Nuwan Rajapaksa	+94746202219	0095b334-c326-48b5-a41c-9fd5b5dda379	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
4540c730-33b6-4d90-95cf-46b3d53833ba	CP AEZ-4088	CHASSIS00000120	Yellow	Bajaj RE	55074da7-c463-46f2-821d-fa49b8723d7e	CLEAN	19907916778	Harsha Rajapaksa	+94719649962	40cff250-f441-46f0-9a98-cc85a71a0e36	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
c9fb0893-9d40-487c-be6e-b00dfef54224	CP AFA-4390	CHASSIS00000121	Red	Bajaj RE	987c321f-c77a-45f6-be50-592e1ce44cb1	CLEAN	786086566V	Thilini Silva	+94748534098	0ca8420a-c7d1-4089-98cd-c5e9661f3eae	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
b2fb30b0-3d9c-4e56-885d-6769b739c388	CP AFB-2690	CHASSIS00000122	Blue	Bajaj RE	07c7ae5b-47b8-44e4-86b0-1817210fa257	CLEAN	19794148549	Isuru Seneviratne	+94749146776	0ca8420a-c7d1-4089-98cd-c5e9661f3eae	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
c4ad147a-13b4-41dc-9b50-d75841f1ce21	CP AFC-7032	CHASSIS00000123	Green	Bajaj RE	9c6be406-c4da-44d8-96a9-a0d86b6993b8	CLEAN	596796940V	Upul Ranasinghe	+94745790929	0ca8420a-c7d1-4089-98cd-c5e9661f3eae	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
b1be5f59-73cb-4ad0-9dab-a78224d9f700	CP AFD-6340	CHASSIS00000124	Red	Bajaj RE	5fe6aab6-ca77-4f10-b032-7b198ceb434a	CLEAN	19879445917	Nimal Jayawardena	+94764451074	0095b334-c326-48b5-a41c-9fd5b5dda379	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
8e322815-6f28-4e92-85c4-eb9701a44056	CP AFE-4434	CHASSIS00000125	Blue	Bajaj RE	00f6db63-23cc-475e-8598-7c2c9a2a583c	CLEAN	397789882V	Pavithra Kumara	+94779381519	0ca8420a-c7d1-4089-98cd-c5e9661f3eae	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
a0a79411-3828-4eba-bd44-5d6a0c5a1f6a	CP AFF-9764	CHASSIS00000126	Orange	Bajaj RE	601af8ec-8348-47bf-a9b0-3a059b0d0131	CLEAN	19928400527	Ruwan Perera	+94727605512	0095b334-c326-48b5-a41c-9fd5b5dda379	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
180ab962-eb7c-4e9b-89fa-95a58c3cad0c	CP AFG-6549	CHASSIS00000127	Silver	Bajaj RE	16a77e4c-ffab-4eeb-9a81-7a18e7f67128	CLEAN	519366558X	Chamari Herath	+94776972927	40cff250-f441-46f0-9a98-cc85a71a0e36	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
4d4f10ba-9b03-4de6-9ee1-fa630180e7f1	CP AFH-9266	CHASSIS00000128	Blue	Bajaj RE	2317c2db-c61b-4078-bd4d-757efa52224e	CLEAN	19702459078	Dilini Seneviratne	+94785940024	0095b334-c326-48b5-a41c-9fd5b5dda379	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
bb4cde3a-215f-4c25-8810-7ecc3821a3bd	CP AFJ-5538	CHASSIS00000129	White	Bajaj RE	22f4dfad-7f84-4ff5-a754-2af06b05d779	CLEAN	337324817X	Suresh Bandara	+94752096482	40cff250-f441-46f0-9a98-cc85a71a0e36	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
acd66dfb-ba87-40c0-86b8-e4ed190e68fa	CP AFK-9834	CHASSIS00000130	Red	Bajaj RE	775b1e36-88b8-4bd8-804e-5c4132dee7b1	CLEAN	19891446216	Dhanushka Liyanage	+94716683550	40cff250-f441-46f0-9a98-cc85a71a0e36	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
f1185054-a5ae-4edd-8e67-ab7288a4c339	CP AFL-7315	CHASSIS00000131	White	TVS King	379978d1-5d6f-43f3-86ea-f63d3f66c999	CLEAN	963267430V	Nimasha Mendis	+94784196855	0095b334-c326-48b5-a41c-9fd5b5dda379	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
01264433-b021-458c-b9e3-584b7c5d7db7	CP AFM-1889	CHASSIS00000132	Yellow	TVS King	c0f02faa-29d0-4c76-a771-e260778b77ed	CLEAN	19938650660	Roshan Wijesinghe	+94755724461	40cff250-f441-46f0-9a98-cc85a71a0e36	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
9b38d36f-4ece-4387-abda-d5514adb3eb5	CP AFN-8129	CHASSIS00000133	Orange	TVS King	1c5f90a5-5daf-4827-950f-d85b717eb88c	CLEAN	958427323V	Sandya Pathirana	+94763826260	0ca8420a-c7d1-4089-98cd-c5e9661f3eae	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
18162de4-67a5-4fe6-a181-1c3e8f0411e9	CP AFP-3683	CHASSIS00000134	Yellow	TVS King	4f403b97-0043-4ab9-b968-04da6481a733	CLEAN	19964809012	Chathura Gunasekara	+94768672157	40cff250-f441-46f0-9a98-cc85a71a0e36	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
1a37bb5b-1391-4781-ad94-401d840e9f53	CP AFQ-5920	CHASSIS00000135	Red	TVS King	e4ee9689-d378-45dd-bb4c-7cffcc3cc67f	CLEAN	365431227X	Malith Rathnayake	+94749417421	0095b334-c326-48b5-a41c-9fd5b5dda379	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
15af9574-5fd3-4e3a-a6ed-fdfcd07dc01a	CP AFR-2110	CHASSIS00000136	Green	TVS King	124f840f-acfb-4d70-b2f1-70a0af75cc40	CLEAN	19968057177	Janaka Gunaratne	+94726693412	0ca8420a-c7d1-4089-98cd-c5e9661f3eae	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
9cd5f982-db68-4dcc-813a-640abba4c7d8	CP AFS-9310	CHASSIS00000137	Red	TVS King	459faed0-666e-4026-ab3c-f8bc2c2279df	CLEAN	398185903V	Tharaka Gunaratne	+94782478173	40cff250-f441-46f0-9a98-cc85a71a0e36	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
2c7bcaad-4e09-4d57-80fe-ed958e4d96e1	CP AFT-9557	CHASSIS00000138	Blue	TVS King	d7918c91-4608-45ad-b850-261cfe1feb10	CLEAN	19733078608	Pradeep Perera	+94772361372	0ca8420a-c7d1-4089-98cd-c5e9661f3eae	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
ada492a5-a573-4f6e-81fd-d7a48b761315	CP AFU-7487	CHASSIS00000139	White	TVS King	8b3056c3-cfa0-478c-b83d-f263403671da	CLEAN	155006504X	Sachini Rathnayake	+94787960236	40cff250-f441-46f0-9a98-cc85a71a0e36	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
86f78bdc-abce-44ae-b26c-50b2c0cbab8f	CP AFV-6837	CHASSIS00000140	Green	TVS King	ad392ede-6bcb-43ec-9da8-d36751568757	CLEAN	19835641853	Roshan Bandara	+94718145292	0ca8420a-c7d1-4089-98cd-c5e9661f3eae	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
0d435a62-f9ce-44ac-943f-f2bbbf8324e5	CP AFW-7527	CHASSIS00000141	White	TVS King	bbc0bf47-2e28-4a56-b87b-b30b97ab0061	CLEAN	668358547V	Lasith Wijesinghe	+94787169778	0095b334-c326-48b5-a41c-9fd5b5dda379	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
6d222edb-7f60-4450-87d0-b5c6451a8fc6	CP AFX-3497	CHASSIS00000142	Blue	TVS King	fcec7786-ebce-4a15-a0db-389dea050acb	CLEAN	19944631503	Menaka Gunasekara	+94759941179	d0fc0ce1-239d-4a48-b421-3a0edd246c38	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
b7c610a5-6414-4bfd-b0da-9ba77c1c5e8f	CP AFY-5708	CHASSIS00000143	Silver	TVS King	60b72d6e-edf8-405a-9269-e60f6551ab7c	CLEAN	676796216X	Chathurika Fernando	+94752656328	40cff250-f441-46f0-9a98-cc85a71a0e36	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
4e60dcbc-8539-4fe0-bb9e-d49fd2d721c0	CP AFZ-2631	CHASSIS00000144	Orange	TVS King	730e4109-6bd1-4ac8-8614-735584acc47a	CLEAN	19961057175	Hirantha Gunasekara	+94759893395	0095b334-c326-48b5-a41c-9fd5b5dda379	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
5af71d06-2fbd-4d7d-b7f5-33fe41e94bab	CP AGA-8063	CHASSIS00000145	Orange	TVS King	78f706d5-c2af-46ee-a833-2d32804ec295	CLEAN	654823538X	Nuwan Dissanayake	+94741717933	d0fc0ce1-239d-4a48-b421-3a0edd246c38	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
349aa6b4-cb02-40b7-9225-34fa930e0c76	CP AGB-1277	CHASSIS00000146	Yellow	TVS King	9c5d3897-ee25-4db4-82d4-6168996ba848	CLEAN	19785820119	Roshan Wickramasinghe	+94743071267	d0fc0ce1-239d-4a48-b421-3a0edd246c38	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
0912981e-8141-4cb4-9507-d577643262e9	CP AGC-1303	CHASSIS00000147	Red	TVS King	43dd707d-bf06-4c6e-a7c0-9c5cad5d75d3	CLEAN	129475012V	Asanka Amarasinghe	+94751649739	40cff250-f441-46f0-9a98-cc85a71a0e36	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
c6fbb3fe-b9a9-4e4f-b3ed-8188981dfa1a	CP AGD-3246	CHASSIS00000148	White	TVS King	ab35d82c-e731-4724-8264-99cde4dbea22	CLEAN	19776866597	Nimasha Dissanayake	+94754089005	d0fc0ce1-239d-4a48-b421-3a0edd246c38	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
35f25971-9aa5-4f26-9c81-f0a273397abe	CP AGE-7855	CHASSIS00000149	Silver	TVS King	849a1c11-c7da-41ce-9913-8718de7533e0	CLEAN	556577472V	Tharaka Bandara	+94752926036	d0fc0ce1-239d-4a48-b421-3a0edd246c38	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
03882625-64fb-4a93-b4ed-8ab0db3dde5d	CP AGF-9007	CHASSIS00000150	Green	TVS King	96f8c6e1-9a32-4ace-8ece-96a22ca4fbbe	CLEAN	19954760770	Kamal Senanayake	+94752337534	40cff250-f441-46f0-9a98-cc85a71a0e36	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
251aaf2a-d35c-45be-ba67-2207d92edceb	CP AGG-5237	CHASSIS00000151	White	TVS King	ba360ae8-584b-4e2f-b81f-d82676a98383	CLEAN	745318708X	Chathurika Wijesinghe	+94718893974	40cff250-f441-46f0-9a98-cc85a71a0e36	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
872dda2a-da96-4346-8b2a-765cb9351983	CP AGH-1326	CHASSIS00000152	Blue	TVS King	105254bb-fb73-4021-a1d6-7516a0e6ab10	CLEAN	19756908338	Roshan Dissanayake	+94781260460	0095b334-c326-48b5-a41c-9fd5b5dda379	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
ae0777aa-fdad-4205-acad-d9a20b3006b3	CP AGJ-5349	CHASSIS00000153	Yellow	TVS King	1d39cc0a-321c-4c75-ad9c-1d2b2af54289	CLEAN	568878159X	Dhanushka Wijesinghe	+94775721523	0ca8420a-c7d1-4089-98cd-c5e9661f3eae	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
c1e038f0-e5f6-4284-b380-e249c81d00ec	CP AGK-7630	CHASSIS00000154	Blue	TVS King	e2e6ff7e-8458-48f9-a0fa-78796ab0ae1a	CLEAN	19919513603	Asanka Silva	+94714407890	0ca8420a-c7d1-4089-98cd-c5e9661f3eae	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
110a3ee2-1c8b-4442-8b82-30a199b1bd33	CP AGL-3052	CHASSIS00000155	Orange	TVS King	fcf46590-d1bd-411c-a505-8d1a35d1f7fc	CLEAN	556525380V	Lasith Madushanka	+94764556102	d0fc0ce1-239d-4a48-b421-3a0edd246c38	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
8d7919d7-7aef-4155-b796-3f9386e5bbfd	CP AGM-7275	CHASSIS00000156	Yellow	TVS King	ffd6751c-2b2d-47e9-a486-e01b4499bbc1	CLEAN	19929003655	Nimasha Weerasinghe	+94717841406	0ca8420a-c7d1-4089-98cd-c5e9661f3eae	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
bbdcf058-5cb1-45c0-84c2-0ed269c323c5	CP AGN-1442	CHASSIS00000157	Silver	TVS King	6ceaa7e0-f14e-46f9-a658-983545b4be48	CLEAN	728603582V	Dhanushka Senanayake	+94769250060	0095b334-c326-48b5-a41c-9fd5b5dda379	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
60f89b5e-4b1d-470d-8636-6e6674632b1d	CP AGP-6298	CHASSIS00000158	Yellow	TVS King	2ead8325-56f0-49c2-94da-a41d82cdc06e	CLEAN	19967955567	Malith Pathirana	+94787454174	40cff250-f441-46f0-9a98-cc85a71a0e36	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
02fbb244-abf5-45ea-bc44-260dac6497fc	CP AGQ-8689	CHASSIS00000159	Blue	TVS King	cbfb1a83-aaff-41c1-a593-6f4f3b5006cc	CLEAN	479376016V	Chamari Amarasinghe	+94777136390	40cff250-f441-46f0-9a98-cc85a71a0e36	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
22172885-0c58-41ae-84bb-d5045d17ae77	CP AGR-9985	CHASSIS00000160	Blue	TVS King	9efd8c4b-f17e-48c2-a0b6-5f0d0b866ea4	CLEAN	19968914763	Dilshan Liyanage	+94773773853	0095b334-c326-48b5-a41c-9fd5b5dda379	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
d12eedbe-bba5-4d98-b7b4-7d4033d5795c	CP AGS-8537	CHASSIS00000161	Blue	TVS King	073d1771-17e6-4858-b1b5-1d5a05655a46	CLEAN	713481226X	Malith Mendis	+94721640594	40cff250-f441-46f0-9a98-cc85a71a0e36	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
9f45f857-aa4a-463c-a212-e0ff61810dbc	CP AGT-6101	CHASSIS00000162	Silver	TVS King	d28b1a22-4221-47dd-b743-da61eea9f1e4	CLEAN	19788845095	Pradeep Bandara	+94725846163	40cff250-f441-46f0-9a98-cc85a71a0e36	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
59bcf08a-ecba-479a-89d1-ac15f031d881	CP AGU-6841	CHASSIS00000163	Blue	TVS King	40d100a5-cd1f-4408-bb53-5489b7410963	CLEAN	950273913V	Buddika Jayasuriya	+94724645574	40cff250-f441-46f0-9a98-cc85a71a0e36	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
a9563358-784b-42d0-98e2-f483272cbb16	CP AGV-8776	CHASSIS00000164	White	TVS King	a4425442-074b-4e46-bae0-6aa0d37c56e3	CLEAN	19773548291	Sewwandi Madushanka	+94722157985	0ca8420a-c7d1-4089-98cd-c5e9661f3eae	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
1ecc5861-604c-4d89-af6c-6b11ce91d3f8	CP AGW-3730	CHASSIS00000165	Blue	TVS King	467251a1-864f-47f0-9913-702127f7358f	CLEAN	595896893X	Pradeep Wijesinghe	+94729561340	0ca8420a-c7d1-4089-98cd-c5e9661f3eae	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
e46263e9-4999-4936-8570-d45917c984fd	SP AGX-5462	CHASSIS00000166	Silver	TVS King	e2bdc3a8-6024-43e1-89fe-67b5a3a4d372	CLEAN	19798949283	Kamal Madushanka	+94747634296	48c99c75-6d98-48dc-ab3d-430018722358	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
ca5f74fa-c9bf-4334-8cd6-2f1cfe332a64	SP AGY-8848	CHASSIS00000167	Red	TVS King	cc76f1a4-5325-4ea6-961f-cc89d1e26b1a	CLEAN	169478485V	Roshan Ranasinghe	+94745076537	7f0b360b-1415-4fc8-9508-43b4580bbe8f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
9253045d-8471-4db6-bad2-878c06644b16	SP AGZ-1859	CHASSIS00000168	Blue	TVS King	a7fdf29c-e38f-4f90-96cc-2cc5d791f67f	CLEAN	19745941010	Iresha Rajapaksa	+94759590792	2e63e462-cd35-4b9d-ab7f-fb7e41fc37d2	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
e231bdbe-711d-4178-99cc-692bf4aeda50	SP AHA-7071	CHASSIS00000169	Green	TVS King	fafed4cc-6aa6-450e-a9c1-5247ffa1c146	CLEAN	135702594X	Suresh Jayawardena	+94754494867	58c58573-02dc-4cc9-aa49-27c5ccada8a7	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
6ae02345-a411-4374-8547-740f5fddc2e6	SP AHB-3283	CHASSIS00000170	Green	TVS King	02c6b3b9-7c09-45e4-a3a0-1f49fd51717b	CLEAN	19794458242	Upul Dissanayake	+94744327365	0333f668-c304-4421-9e8f-934a51f3265a	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
adb4d80c-2fcf-448e-a717-793ed88e5a5b	SP AHC-3457	CHASSIS00000171	Orange	TVS King	e5be69f9-ae7c-4c64-8c6a-aa81873cb944	CLEAN	400784145V	Nadun Liyanage	+94713855272	58c58573-02dc-4cc9-aa49-27c5ccada8a7	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
b5b6f1e5-a207-463e-ac36-0c87d94f925a	SP AHD-7688	CHASSIS00000172	Yellow	TVS King	268f13ce-0c24-47d0-bbe8-5da0927d1e2e	CLEAN	19937201552	Chathura Ranasinghe	+94757192146	6ebadced-812f-4f17-aa5f-447653cf3b26	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
4e17ca3a-149e-47c7-a481-cbae932b1746	SP AHE-7415	CHASSIS00000173	Yellow	TVS King	7301ed3b-abe8-4741-ae78-7806cd654ed8	CLEAN	780964143V	Sewwandi Perera	+94761177082	0333f668-c304-4421-9e8f-934a51f3265a	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
50d1b075-2f87-4961-814b-f979fc4888d5	SP AHF-6228	CHASSIS00000174	Orange	TVS King	21953d34-ca52-4e0d-aa51-810bdcb5c86d	CLEAN	19833524896	Sachith Gunaratne	+94717857398	48c99c75-6d98-48dc-ab3d-430018722358	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
b1813b9b-ee59-408e-aa27-71ccd95551db	SP AHG-1248	CHASSIS00000175	Blue	TVS King	5a58148d-36d7-4850-8a56-eb5af291578a	CLEAN	948013754V	Kumari Gunaratne	+94769651270	58c58573-02dc-4cc9-aa49-27c5ccada8a7	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
50133679-66b9-498d-b0fe-15925109c166	SP AHH-2624	CHASSIS00000176	Blue	TVS King	82a2288a-9ac4-422f-9186-41224e5e19c5	CLEAN	19798141776	Dilini Seneviratne	+94775495545	58c58573-02dc-4cc9-aa49-27c5ccada8a7	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
4875f1ce-ff31-44a4-905d-f7a98216c497	SP AHJ-5445	CHASSIS00000177	Blue	TVS King	4c04ed64-d280-4327-99e9-bb3f512c5439	CLEAN	199824858V	Kamal Jayawardena	+94713315926	7f0b360b-1415-4fc8-9508-43b4580bbe8f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
37f769ae-7017-4f4c-8710-1c07976a4b2b	SP AHK-6626	CHASSIS00000178	Orange	TVS King	93e51b0d-34ab-4210-a056-b45f39bd9d7d	CLEAN	19814258514	Nadun Abeysekara	+94766759484	6ebadced-812f-4f17-aa5f-447653cf3b26	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
16a38bab-936e-451d-90a6-5566d4a6f0d8	SP AHL-8980	CHASSIS00000179	White	TVS King	824c85f1-c1ea-4682-af16-980773022a06	CLEAN	607498036V	Mahesh Liyanage	+94757148852	58c58573-02dc-4cc9-aa49-27c5ccada8a7	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
dbfd1888-ff12-4a12-b935-bb5030bb9a9d	SP AHM-4987	CHASSIS00000180	Green	TVS King	b0e9fc3d-d77b-4067-84e9-044d090627b9	CLEAN	19955655966	Sachith Rajapaksa	+94774917189	58c58573-02dc-4cc9-aa49-27c5ccada8a7	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
840b10bb-c418-4ccc-b1ef-62cb1c0bf038	SP AHN-7734	CHASSIS00000181	Yellow	Bajaj RE 4S	49a4262e-825c-45ac-8c11-1ea7d784432e	CLEAN	274085147V	Sandya Silva	+94728683396	7a5a7332-05a9-49d8-abf3-0d5debb8fa41	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
1aa6ba11-2dfa-4503-aade-02742dae76f7	SP AHP-1437	CHASSIS00000182	Blue	Bajaj RE 4S	2fcf5f8a-042f-4fd6-b383-7ac7b65a02ac	CLEAN	19942928225	Rashmi Rathnayake	+94746872738	b269596a-d674-4dec-8f66-76941dcf88f6	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
5975f98b-a5df-4acb-824c-8a2cc5ebc6dc	SP AHQ-2199	CHASSIS00000183	Silver	Bajaj RE 4S	23d9244d-9df1-47ad-bb24-cf090c748af0	CLEAN	753964207X	Roshan Bandara	+94782609138	720aac09-5422-4255-84d9-620d7a44a666	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
fc80dda2-0224-4ae7-b2ed-f07bc5956c24	SP AHR-5971	CHASSIS00000184	Red	Bajaj RE 4S	0a83acc9-e56f-4165-bfbc-c90729bb3f10	CLEAN	19856271162	Upul Dissanayake	+94714020920	6ebadced-812f-4f17-aa5f-447653cf3b26	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
d121f261-a9bd-4d90-902f-d0ab70a5bc9d	SP AHS-9363	CHASSIS00000185	White	Bajaj RE 4S	59dd9c87-06a4-4070-893e-bc363829b6dc	CLEAN	993115848X	Tharaka Herath	+94765652078	7a5a7332-05a9-49d8-abf3-0d5debb8fa41	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
623bbb3d-4687-48b7-bb39-c275d4241421	SP AHT-1984	CHASSIS00000186	Yellow	Bajaj RE 4S	8ac4da9b-3181-4845-b1e0-673eb0ceec07	STOLEN	19827666330	Kumari Silva	+94749028212	7f0b360b-1415-4fc8-9508-43b4580bbe8f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
b4f97c89-d726-4e90-ba24-8f84eb42a963	SP AHU-4620	CHASSIS00000187	Orange	Bajaj RE 4S	ca261f2a-bfb1-412a-b975-ab001ce34dba	STOLEN	859327089X	Anusha Gunasekara	+94777950094	48c99c75-6d98-48dc-ab3d-430018722358	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
31d27c76-6a8d-40b9-a5fe-0d97cb526b84	SP AHV-7909	CHASSIS00000188	White	Bajaj RE 4S	9d39466d-5ac2-4ec6-8920-82052a797151	STOLEN	19805631194	Roshan Wickramasinghe	+94782335162	7f0b360b-1415-4fc8-9508-43b4580bbe8f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
4170002e-9fa7-4063-8189-72b4620e9723	SP AHW-4063	CHASSIS00000189	Silver	Bajaj RE 4S	d0c1dbd5-ab0d-4744-b2b0-98d5783ff63c	STOLEN	592513466X	Upul Jayasuriya	+94744964302	bbebc644-86ee-48ec-b2a4-807f9cf3b380	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
5798e277-3699-4ab5-a815-e897b74fd5ab	SP AHX-3937	CHASSIS00000190	Yellow	Bajaj RE 4S	d92d1c21-70bb-47ac-9d8a-cd01b14ea12a	STOLEN	19987493949	Nuwan Dissanayake	+94783374183	48c99c75-6d98-48dc-ab3d-430018722358	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
31704e28-e911-447a-b907-b7e427e490f1	SP AHY-7804	CHASSIS00000191	White	Bajaj RE 4S	fad5742a-8457-4e21-84b6-9fe8ad916719	STOLEN	760980782V	Janaka Senanayake	+94756123893	7f0b360b-1415-4fc8-9508-43b4580bbe8f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
ac3c0fc8-d8e1-4188-8ce1-43faf240799a	SP AHZ-5939	CHASSIS00000192	Red	Bajaj RE 4S	2751b996-a382-49c7-ae52-f841a3fb7415	STOLEN	19745846326	Tharaka Bandara	+94774263969	720aac09-5422-4255-84d9-620d7a44a666	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
4a04483a-7b32-40ae-a56e-f47b5c9a39ff	SP AJA-4273	CHASSIS00000193	Silver	Bajaj RE 4S	2cf92150-550b-4141-ab11-27da2283222c	STOLEN	380124173V	Lasith Jayasuriya	+94758238673	bbebc644-86ee-48ec-b2a4-807f9cf3b380	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
8482d1f8-b91e-4829-baa3-5dd3b5d10454	SP AJB-3745	CHASSIS00000194	Red	Bajaj RE 4S	a59c737d-dff4-410d-9944-ab4feafe0983	WANTED	19997913641	Kamal Jayawardena	+94761995610	2e63e462-cd35-4b9d-ab7f-fb7e41fc37d2	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
8924862b-4482-41b7-90eb-8cd9e0d7d7c4	SP AJC-8044	CHASSIS00000195	Red	Bajaj RE 4S	5945e6b6-2303-4b5c-85e6-b630580df502	WANTED	802211799V	Malith Fernando	+94729602198	7f0b360b-1415-4fc8-9508-43b4580bbe8f	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
6558a46d-f513-4b30-a6c5-671aa37ec4cc	SP AJD-1470	CHASSIS00000196	Orange	Bajaj RE 4S	f1c405d1-3d22-437e-8c5c-ed068f54d5bd	WANTED	19701977598	Sachini Madushanka	+94777313551	48c99c75-6d98-48dc-ab3d-430018722358	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
8a27f782-1d4a-4e03-98b6-422a538e7321	SP AJE-4061	CHASSIS00000197	Blue	Bajaj RE 4S	936184c9-e935-4ba5-b9fc-6aa62c28600a	WANTED	279702128X	Chathurika Gunasekara	+94724169955	2e63e462-cd35-4b9d-ab7f-fb7e41fc37d2	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
d976794b-07ae-4d49-919a-697eb36f98ea	SP AJF-3251	CHASSIS00000198	White	Bajaj RE 4S	c014770f-aa47-4ea0-93d6-0daf752d79ce	WANTED	19747483306	Nadeesha Rathnayake	+94768138329	58c58573-02dc-4cc9-aa49-27c5ccada8a7	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
82c286fb-399f-43db-b316-6769313afb8a	SP AJG-6521	CHASSIS00000199	Red	Bajaj RE 4S	1aec48d3-b547-4cc1-a01a-d92a8dafc338	WANTED	488324875X	Sewwandi Liyanage	+94729275246	0333f668-c304-4421-9e8f-934a51f3265a	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
0f49866b-d1df-44c2-85b9-ac49101224ab	SP AJH-6751	CHASSIS00000200	Red	Bajaj RE 4S	7c209387-ca21-416e-adda-a2431c25f620	WANTED	19841052592	Dilshan Senanayake	+94764183644	bbebc644-86ee-48ec-b2a4-807f9cf3b380	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
e5575391-dbed-4c44-9a72-e4eb88f8a952	SP AJJ-8554	CHASSIS00000201	Red	Piaggio Ape	5421078d-3b6f-4d3a-bd06-4ce96b4899f3	SUSPENDED	484805557X	Thilak Wickramasinghe	+94716934614	b269596a-d674-4dec-8f66-76941dcf88f6	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
5abcaa6f-b557-4ef6-936c-e17eff5a5f9d	SP AJK-1102	CHASSIS00000202	Silver	Piaggio Ape	fe654711-2875-4baf-aed2-c521bf81e6df	SUSPENDED	19828588963	Chathurika Kumara	+94773122703	7a5a7332-05a9-49d8-abf3-0d5debb8fa41	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
53ef75ec-65c2-4cbb-b2b7-5e8f2483ccae	SP AJL-5241	CHASSIS00000203	Red	Piaggio Ape	187f8bdf-70c6-4f37-9cdf-0e4019e15f3c	SUSPENDED	943071010X	Mahesh Liyanage	+94774691136	2e63e462-cd35-4b9d-ab7f-fb7e41fc37d2	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
3e1b6de4-7c29-41a5-8581-e6ab46c8f61b	SP AJM-4137	CHASSIS00000204	Blue	Piaggio Ape	84dd896e-b9f7-461d-ae95-7b7a67263c56	SUSPENDED	19784796720	Malith Jayawardena	+94785890916	0333f668-c304-4421-9e8f-934a51f3265a	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
f372c878-43f7-4d7e-b482-52d2e68d5d8b	SP AJN-2926	CHASSIS00000205	Yellow	Piaggio Ape	041818a4-ca98-462d-bdb5-a430a0aeb45d	SUSPENDED	870110957V	Kamal Amarasinghe	+94748362634	7a5a7332-05a9-49d8-abf3-0d5debb8fa41	2026-04-25 14:17:59.25877+00	2026-04-25 14:17:59.25877+00
\.


--
-- Name: knex_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: slpvt_user
--

SELECT pg_catalog.setval('public.knex_migrations_id_seq', 10, true);


--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE SET; Schema: public; Owner: slpvt_user
--

SELECT pg_catalog.setval('public.knex_migrations_lock_index_seq', 1, true);


--
-- Name: districts districts_name_unique; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_name_unique UNIQUE (name);


--
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (district_id);


--
-- Name: divisional_secretariats divisional_secretariats_name_unique; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.divisional_secretariats
    ADD CONSTRAINT divisional_secretariats_name_unique UNIQUE (name);


--
-- Name: divisional_secretariats divisional_secretariats_pkey; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.divisional_secretariats
    ADD CONSTRAINT divisional_secretariats_pkey PRIMARY KEY (ds_division_id);


--
-- Name: drivers drivers_driving_license_number_unique; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.drivers
    ADD CONSTRAINT drivers_driving_license_number_unique UNIQUE (driving_license_number);


--
-- Name: drivers drivers_pkey; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.drivers
    ADD CONSTRAINT drivers_pkey PRIMARY KEY (driver_id);


--
-- Name: knex_migrations_lock knex_migrations_lock_pkey; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.knex_migrations_lock
    ADD CONSTRAINT knex_migrations_lock_pkey PRIMARY KEY (index);


--
-- Name: knex_migrations knex_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.knex_migrations
    ADD CONSTRAINT knex_migrations_pkey PRIMARY KEY (id);


--
-- Name: provinces provinces_name_unique; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.provinces
    ADD CONSTRAINT provinces_name_unique UNIQUE (name);


--
-- Name: provinces provinces_pkey; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.provinces
    ADD CONSTRAINT provinces_pkey PRIMARY KEY (province_id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (token_id);


--
-- Name: refresh_tokens refresh_tokens_token_hash_unique; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_hash_unique UNIQUE (token_hash);


--
-- Name: stations stations_name_unique; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_name_unique UNIQUE (name);


--
-- Name: stations stations_pkey; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (station_id);


--
-- Name: tracking_devices tracking_devices_api_key_hash_unique; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.tracking_devices
    ADD CONSTRAINT tracking_devices_api_key_hash_unique UNIQUE (api_key_hash);


--
-- Name: tracking_devices tracking_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.tracking_devices
    ADD CONSTRAINT tracking_devices_pkey PRIMARY KEY (device_id);


--
-- Name: tracking_devices tracking_devices_serial_number_unique; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.tracking_devices
    ADD CONSTRAINT tracking_devices_serial_number_unique UNIQUE (serial_number);


--
-- Name: users users_badge_number_unique; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_badge_number_unique UNIQUE (badge_number);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: vehicle_driver_assignments vehicle_driver_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.vehicle_driver_assignments
    ADD CONSTRAINT vehicle_driver_assignments_pkey PRIMARY KEY (assignment_id);


--
-- Name: vehicles vehicles_chassis_number_unique; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_chassis_number_unique UNIQUE (chassis_number);


--
-- Name: vehicles vehicles_pkey; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (vehicle_id);


--
-- Name: vehicles vehicles_registration_number_unique; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_registration_number_unique UNIQUE (registration_number);


--
-- Name: districts districts_province_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_province_id_foreign FOREIGN KEY (province_id) REFERENCES public.provinces(province_id) ON DELETE RESTRICT;


--
-- Name: divisional_secretariats divisional_secretariats_district_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.divisional_secretariats
    ADD CONSTRAINT divisional_secretariats_district_id_foreign FOREIGN KEY (district_id) REFERENCES public.districts(district_id) ON DELETE RESTRICT;


--
-- Name: refresh_tokens refresh_tokens_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: stations stations_district_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_district_id_foreign FOREIGN KEY (district_id) REFERENCES public.districts(district_id) ON DELETE RESTRICT;


--
-- Name: stations stations_ds_division_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_ds_division_id_foreign FOREIGN KEY (ds_division_id) REFERENCES public.divisional_secretariats(ds_division_id) ON DELETE RESTRICT;


--
-- Name: stations stations_province_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_province_id_foreign FOREIGN KEY (province_id) REFERENCES public.provinces(province_id) ON DELETE RESTRICT;


--
-- Name: users users_assigned_station_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_assigned_station_id_foreign FOREIGN KEY (assigned_station_id) REFERENCES public.stations(station_id) ON DELETE RESTRICT;


--
-- Name: vehicle_driver_assignments vehicle_driver_assignments_driver_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.vehicle_driver_assignments
    ADD CONSTRAINT vehicle_driver_assignments_driver_id_foreign FOREIGN KEY (driver_id) REFERENCES public.drivers(driver_id) ON DELETE RESTRICT;


--
-- Name: vehicle_driver_assignments vehicle_driver_assignments_vehicle_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.vehicle_driver_assignments
    ADD CONSTRAINT vehicle_driver_assignments_vehicle_id_foreign FOREIGN KEY (vehicle_id) REFERENCES public.vehicles(vehicle_id) ON DELETE RESTRICT;


--
-- Name: vehicles vehicles_device_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_device_id_foreign FOREIGN KEY (device_id) REFERENCES public.tracking_devices(device_id) ON DELETE SET NULL;


--
-- Name: vehicles vehicles_ds_division_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_ds_division_id_foreign FOREIGN KEY (ds_division_id) REFERENCES public.divisional_secretariats(ds_division_id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict L1A4AIhB1Uo0op8ayffeAl1U7iNR3o1TkPE5f7nuWhtiykaJqaxjM6IkA6XKTKh

