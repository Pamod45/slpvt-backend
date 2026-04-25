--
-- PostgreSQL database dump
--

\restrict QiUR7prAH6oAJVINhUvQ0MO7Ku0UePcIQppu0gfSpVOcvcKT1jATILp66Q9lAmN

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
-- Name: station_types; Type: TABLE; Schema: public; Owner: slpvt_user
--

CREATE TABLE public.station_types (
    station_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    type_name character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.station_types OWNER TO slpvt_user;

--
-- Name: COLUMN station_types.type_name; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.station_types.type_name IS 'Main Station, Police Post, Range Office';


--
-- Name: stations; Type: TABLE; Schema: public; Owner: slpvt_user
--

CREATE TABLE public.stations (
    station_id uuid DEFAULT gen_random_uuid() NOT NULL,
    ds_division_id uuid,
    district_id uuid,
    province_id uuid,
    station_type_id uuid NOT NULL,
    name character varying(150) NOT NULL,
    contact_number character varying(20),
    latitude numeric(10,7),
    longitude numeric(10,7),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.stations OWNER TO slpvt_user;

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
-- Name: COLUMN stations.station_type_id; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.stations.station_type_id IS 'Type of police station';


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
    assigned_district_id uuid,
    assigned_province_id uuid,
    system_role text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT users_system_role_check CHECK ((system_role = ANY (ARRAY['SUPER_ADMIN'::text, 'PROVINCIAL_COMMANDER'::text, 'PROVINCIAL_OFFICER'::text, 'DISTRICT_COMMANDER'::text, 'STATION_COMMANDER'::text, 'STATION_OFFICER'::text, 'DATA_REGISTRAR'::text, 'DEVICE_CLIENT'::text])))
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
-- Name: COLUMN users.assigned_district_id; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.users.assigned_district_id IS 'Populated for district level and above roles';


--
-- Name: COLUMN users.assigned_province_id; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.users.assigned_province_id IS 'Populated for provincial level and above roles';


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
    registered_province_id uuid NOT NULL,
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
-- Name: COLUMN vehicles.registered_province_id; Type: COMMENT; Schema: public; Owner: slpvt_user
--

COMMENT ON COLUMN public.vehicles.registered_province_id IS 'Province where vehicle is registered at DMT — always required';


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
bb17281d-bf1c-4177-836f-4d3ad4ae672f	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	Colombo	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
50f797be-832e-4aa6-9e1f-1a0ad0d340b7	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	Gampaha	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
b0b7f9f8-ddc9-49ac-b7f3-edc923a785ba	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	Kalutara	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
6cfc9dbf-25af-41b9-bc4b-32139801282e	f799c375-84e9-40e0-82af-42de97f32e21	Kandy	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
4425f7fc-d261-432e-b7ed-f684c95c162c	f799c375-84e9-40e0-82af-42de97f32e21	Matale	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
1ccaee72-6bd7-4d01-ade4-d442b5b62374	f799c375-84e9-40e0-82af-42de97f32e21	Nuwara Eliya	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
61a91c99-5ecd-411f-aefd-f25becb96502	ec8566fb-2a50-4696-b766-a5f3b18bcc77	Galle	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
000b98e4-e847-44da-a0ab-87c96618200a	ec8566fb-2a50-4696-b766-a5f3b18bcc77	Matara	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
5f98025c-3a66-411d-b934-91f7a7c427a7	ec8566fb-2a50-4696-b766-a5f3b18bcc77	Hambantota	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
375559ec-9dc9-443d-bfff-598e5a3cd0fa	8c98746f-4268-446e-a3ac-bf0ef36dd19d	Jaffna	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
fc7ec171-380a-4b73-86fd-7d5923490292	8c98746f-4268-446e-a3ac-bf0ef36dd19d	Kilinochchi	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
a4dda4ca-4f5a-4b3f-8bbc-3f088d0554d0	8c98746f-4268-446e-a3ac-bf0ef36dd19d	Mannar	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
d9d6f7ce-1573-4dda-a9ea-5e676cb5512b	8c98746f-4268-446e-a3ac-bf0ef36dd19d	Vavuniya	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
dc66cd41-93d4-49ef-931a-3f3ab8c091f0	8c98746f-4268-446e-a3ac-bf0ef36dd19d	Mullaitivu	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
9f41e0fa-7d3d-4263-a596-fc473fef1814	03f1f49b-3db3-46c8-a509-d4a89353daf4	Trincomalee	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
bf84fdc0-0843-4a3d-8b69-1058c5d22638	03f1f49b-3db3-46c8-a509-d4a89353daf4	Batticaloa	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
38edb9d1-4e8e-4778-8ca7-c9ccbd2da6eb	03f1f49b-3db3-46c8-a509-d4a89353daf4	Ampara	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
845d87df-27d9-4e8c-ae89-94f9b7a5ca50	a48a6e1f-c9e2-4866-9ad3-c69c10aec75f	Kurunegala	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
3ebe54df-6643-448f-b582-e48e5481be63	a48a6e1f-c9e2-4866-9ad3-c69c10aec75f	Puttalam	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
0abdd65d-2e1d-4a3a-b569-f7ac3b3b13d1	9e830b9f-c38f-419c-bae1-18350793f377	Anuradhapura	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
af6509b8-c927-4a1c-ad9b-4df2b0e3f432	9e830b9f-c38f-419c-bae1-18350793f377	Polonnaruwa	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
6b2b87d9-240b-4a3d-b665-168cc3d26fd3	941968ca-f266-4b0b-a29c-9ac9cff6818b	Badulla	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
d3056d9a-c252-4c97-9f34-ad727db37fa6	941968ca-f266-4b0b-a29c-9ac9cff6818b	Monaragala	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
011b79b9-6a36-481f-b3f1-a80631383a95	ae78787a-3943-4ada-9f41-9c7bc2cb4f5e	Ratnapura	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
5967ec0d-8f2d-4e7a-975b-3f23b2d0e189	ae78787a-3943-4ada-9f41-9c7bc2cb4f5e	Kegalle	2026-04-25 06:03:43.190372+00	2026-04-25 06:03:43.190372+00
\.


--
-- Data for Name: divisional_secretariats; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.divisional_secretariats (ds_division_id, district_id, name, created_at, updated_at) FROM stdin;
f2da06fe-aa8f-4d0a-86e8-6046ccb63aed	bb17281d-bf1c-4177-836f-4d3ad4ae672f	Colombo	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
4afb1503-2040-406d-876c-28f2a96f6976	bb17281d-bf1c-4177-836f-4d3ad4ae672f	Dehiwala-MountLavinia	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
a9073863-2872-46ea-ae68-9361d29b19b2	bb17281d-bf1c-4177-836f-4d3ad4ae672f	Homagama	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
9dfd6f0b-8fb6-4276-a268-2d2cb9651c19	bb17281d-bf1c-4177-836f-4d3ad4ae672f	Kaduwela	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
c04e380e-7099-48e0-b262-82fef866f4e5	bb17281d-bf1c-4177-836f-4d3ad4ae672f	Kesbewa	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
abebfca6-ecef-431b-8b19-921f7837c346	bb17281d-bf1c-4177-836f-4d3ad4ae672f	SriJayawardanapuraKotte	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
814b9697-a59e-4c42-89fb-cf59a9c09aaf	bb17281d-bf1c-4177-836f-4d3ad4ae672f	Thimbirigasyaya	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
2436dd06-0962-4b9d-9d44-05d0d7aad1da	50f797be-832e-4aa6-9e1f-1a0ad0d340b7	Ja-Ela	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
884024df-4e78-4053-b0c6-2836eb6356d1	50f797be-832e-4aa6-9e1f-1a0ad0d340b7	Kelaniya	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
b3370fc1-5c41-46e1-8a31-1a7a57fb888b	50f797be-832e-4aa6-9e1f-1a0ad0d340b7	Negombo	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
a1c6d3e9-a7d3-4fcd-bba1-3563bebe2a76	50f797be-832e-4aa6-9e1f-1a0ad0d340b7	Wattala	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
1b10e701-c3f1-4093-996f-2670e33ed20d	b0b7f9f8-ddc9-49ac-b7f3-edc923a785ba	Horana	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
cb7490f0-6ce3-4507-a513-f9c9911f9971	b0b7f9f8-ddc9-49ac-b7f3-edc923a785ba	Bandaragama	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
c12db83e-cc73-4a12-b87a-e3e84550681b	b0b7f9f8-ddc9-49ac-b7f3-edc923a785ba	Ingiriya	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
a7de5f8e-58e8-4525-9fcd-be9d85d3b6ef	b0b7f9f8-ddc9-49ac-b7f3-edc923a785ba	Panadura	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
71099a80-65f6-497b-b9fc-b9f1d75887bc	6cfc9dbf-25af-41b9-bc4b-32139801282e	Medadumbara	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
7324e94b-6f22-4790-81b5-29c8ec7e1444	6cfc9dbf-25af-41b9-bc4b-32139801282e	Minipe	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
853902e3-9fec-4b51-a7a7-06369b556cb3	6cfc9dbf-25af-41b9-bc4b-32139801282e	Thumpane	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
50a84cca-ca20-4191-a045-ab9498525783	6cfc9dbf-25af-41b9-bc4b-32139801282e	Udunuwara	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
7017d7a5-6291-4744-8471-4afc8b7d43a7	61a91c99-5ecd-411f-aefd-f25becb96502	Ambalangoda	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
5c54f61f-704a-485a-9005-5a10eaa86756	61a91c99-5ecd-411f-aefd-f25becb96502	Baddegama	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
6eb2b751-88ef-4816-9c73-ebc984a0c948	61a91c99-5ecd-411f-aefd-f25becb96502	Balapitiya	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
ba2ce2b5-f00d-49ae-b588-dcc711798e4b	61a91c99-5ecd-411f-aefd-f25becb96502	Elpitiya	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
cec8a52f-471a-436c-bd24-8d3b62876e5d	61a91c99-5ecd-411f-aefd-f25becb96502	Hikkaduwa	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
6de72e8c-e5bf-4671-98a6-b305e0cdb53d	000b98e4-e847-44da-a0ab-87c96618200a	Devinuwara	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
0ffe1162-63b9-4cca-b3da-4a17fd694853	000b98e4-e847-44da-a0ab-87c96618200a	Dickwella	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
a73cbea7-3576-4bf2-b615-cdb55515680c	000b98e4-e847-44da-a0ab-87c96618200a	Mulatiyana	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
53b5edc3-0b78-48b9-9c72-56f9274521f9	000b98e4-e847-44da-a0ab-87c96618200a	Pitabeddara	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
9c9191ac-f3a5-4bc3-8988-bbf4d384647c	000b98e4-e847-44da-a0ab-87c96618200a	Weligama	2026-04-25 07:15:15.266546+00	2026-04-25 07:15:15.266546+00
\.


--
-- Data for Name: drivers; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.drivers (driver_id, first_name, last_name, permanent_address, driving_license_number, license_expiry_date, police_status, created_at, updated_at) FROM stdin;
67df9b2c-2af1-43ac-9419-40567e84bb50	Chathurika	Perera	No. 12, Kandy Road, Kelaniya	B000000	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
fc9b9ed5-08f6-40dc-baa9-ce36527029b0	Upul	Fernando	No. 15, Peradeniya Road, Kandy	B000001	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
98444881-f9ae-4b75-87ea-4ff4ec0e8b7c	Menaka	Abeysekara	No. 15, Peradeniya Road, Kandy	B000002	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
b46284fb-a0d2-4987-bdc2-59e8bf552d75	Gayan	Gunaratne	No. 12, Kandy Road, Kelaniya	B000003	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
5db7e5cc-0be3-4eee-bb87-6414385ff31d	Kumari	Amarasinghe	No. 15, Peradeniya Road, Kandy	B000004	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
c8f1e1ec-305f-4af4-9810-0cb4f9c094aa	Saman	Senanayake	No. 72, New Road, Horana	B000005	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
44e1926c-8522-4631-a646-c70051ba055a	Sachith	Kumara	No. 12, Kandy Road, Kelaniya	B000006	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
7454b4a8-56c1-48de-836b-308acfa85ca8	Buddika	Dissanayake	No. 56, Highlevel Road, Nugegoda	B000007	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
586ef4ca-7d3c-4a39-9051-e603c5a02ffe	Tharaka	Gunaratne	No. 34, Station Road, Panadura	B000008	2028-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
743d401b-a3d5-458a-ae4d-2bd427c208cc	Nadun	Pathirana	No. 89, Galle Road, Kalutara	B000009	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
709b6a0e-93d7-4c60-860c-670ee67b6aa0	Chaminda	Dissanayake	No. 67, Colombo Road, Gampaha	B000010	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
516bcc62-c615-45d1-9d43-7f4f401becea	Kamal	Wijesinghe	No. 89, Galle Road, Kalutara	B000011	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
ada3a38b-c6d9-4bf7-8298-92ec43121ddd	Dilshan	Wijesinghe	No. 15, Peradeniya Road, Kandy	B000012	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
8a9cb177-0668-45ad-90ee-7660633ed8ea	Chathurika	Liyanage	No. 12, Kandy Road, Kelaniya	B000013	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
8e835206-2790-4322-a8a9-4a607597fe3b	Nuwan	Kumara	No. 23, High Level Road, Homagama	B000014	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
efd865f6-a180-4cc8-a703-3286b8f56f63	Janaka	Rathnayake	No. 45, Galle Road, Colombo 03	B000015	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
722b45a7-97e6-4dda-8562-4187cede31f6	Sewwandi	Gunaratne	No. 91, Marine Drive, Galle	B000016	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
9debce79-fd6e-4991-8c78-7abb8b0cd0a1	Kumari	Pathirana	No. 54, Lake Road, Kaduwela	B000017	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
1de234dd-f963-42c9-92d8-a2fd1f73d93a	Chaminda	Wijesinghe	No. 12, Kandy Road, Kelaniya	B000018	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
29b1a6fa-3828-4374-8f7d-10f4095da077	Chathura	Herath	No. 23, High Level Road, Homagama	B000019	2028-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
f6af833e-d848-4d59-87c1-2dc6f8031ba8	Prasad	Abeysekara	No. 28, Hospital Road, Matara	B000020	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
0a792d02-231c-4405-a9ed-24bd14f991ac	Ruwan	Liyanage	No. 56, Highlevel Road, Nugegoda	B000021	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
a0e7ba8a-b55c-4f2f-9dd3-801ce5fc6fc6	Kumari	Fernando	No. 43, Matara Road, Weligama	B000022	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
15977c46-131e-400b-a3d2-14533b7cb716	Nimasha	Abeysekara	No. 45, Galle Road, Colombo 03	B000023	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
db0d0ddc-4d23-49b7-91c0-eb6fe3368e7e	Chamari	Silva	No. 56, Highlevel Road, Nugegoda	B000024	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
671e5319-9d1e-4218-9046-cf13c48f863d	Harsha	Liyanage	No. 78, Main Street, Negombo	B000025	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
34c7ac49-bbaa-4d75-a370-cc63cee3bc67	Sachith	Rathnayake	No. 15, Peradeniya Road, Kandy	B000026	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
9961ad98-607d-4aae-8b59-ac764206399a	Nuwan	Bandara	No. 28, Hospital Road, Matara	B000027	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
f61caeac-89a2-4fef-ac3f-80c61ec7c37e	Gayan	Seneviratne	No. 15, Peradeniya Road, Kandy	B000028	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
e703e73f-8dd0-48e0-aaf5-55f9c0b150d0	Sachith	Abeysekara	No. 43, Matara Road, Weligama	B000029	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
834d53c0-bc88-45a1-ad3e-8fa113bded22	Chaminda	Jayasuriya	No. 12, Kandy Road, Kelaniya	B000030	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
0a744c51-0f4d-4e07-bf97-ad52a89c60ec	Thilini	Bandara	No. 23, High Level Road, Homagama	B000031	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
65116e9f-d922-4cdd-a285-c292f4620ce7	Thilak	Rajapaksa	No. 36, Temple Road, Bandaragama	B000032	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
68543b9b-5e86-4dc2-9c10-bfadb2845ed7	Hirantha	Bandara	No. 91, Marine Drive, Galle	B000033	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
23d32bcc-e3e2-46a1-b483-eb8f5c7cea43	Saman	Wickramasinghe	No. 91, Marine Drive, Galle	B000034	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
9f0bf463-beda-4024-bf39-82df67a63244	Nimasha	Amarasinghe	No. 67, Colombo Road, Gampaha	B000035	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
3c44c57e-6ca3-4370-be36-3b61b8731b39	Pavithra	Rajapaksa	No. 28, Hospital Road, Matara	B000036	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
f6b602ef-87fa-438b-a54a-6b8967934448	Kumari	Rathnayake	No. 12, Kandy Road, Kelaniya	B000037	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
88fd183e-673d-46fb-a44f-c0c3e593eebf	Nadun	Perera	No. 89, Galle Road, Kalutara	B000038	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
45cde211-8bcc-40bc-b09a-5f69863b96b1	Thilini	Dissanayake	No. 12, Kandy Road, Kelaniya	B000039	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
c897f2d6-15f3-43ab-a068-0fc50d40a5fb	Sachini	Jayasuriya	No. 67, Colombo Road, Gampaha	B000040	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
767dbd62-de05-4999-9f1f-4cfbad93a33c	Anusha	Jayawardena	No. 36, Temple Road, Bandaragama	B000041	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
26dd898c-09e3-4f21-ae52-d02557ac5bb9	Prasad	Fernando	No. 15, Peradeniya Road, Kandy	B000042	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
6e395d22-a947-40de-bcde-0ed103b6c69d	Chathura	Herath	No. 36, Temple Road, Bandaragama	B000043	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
a9d19ca1-8478-4c33-9d6c-4700452cf066	Janaka	Wijesinghe	No. 23, High Level Road, Homagama	B000044	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
5162909e-abb0-4b61-ba7d-5b667eb61c56	Saman	Ranasinghe	No. 54, Lake Road, Kaduwela	B000045	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
c353bb5b-c2b1-44f2-acf2-a790817ff99d	Roshan	Madushanka	No. 15, Peradeniya Road, Kandy	B000046	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
0f60b0cb-f583-4566-aced-e49dd8026224	Mahesh	Wijesinghe	No. 45, Galle Road, Colombo 03	B000047	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
fb5f74ca-59ca-45bd-af5f-390d3bbed4a7	Malith	Pathirana	No. 89, Galle Road, Kalutara	B000048	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
a4012551-4572-4655-901c-f341476294a8	Asanka	Seneviratne	No. 54, Lake Road, Kaduwela	B000049	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
7a1018bd-87c0-4db5-a0e2-a75b35500197	Buddika	Jayasuriya	No. 12, Kandy Road, Kelaniya	B000050	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
70fa894e-b75f-4fab-95c6-ff0bbda4324c	Dhanushka	Abeysekara	No. 91, Marine Drive, Galle	B000051	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
74aaa83d-0983-4d84-ba40-6e1d19bf4350	Dhanushka	Kumara	No. 78, Main Street, Negombo	B000052	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
22cc77c9-598d-4c94-8b0c-820a81fa7543	Kamal	Senanayake	No. 34, Station Road, Panadura	B000053	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
545b7640-42ab-42b1-ab77-fa3d1858364f	Menaka	Seneviratne	No. 56, Highlevel Road, Nugegoda	B000054	2028-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
a352c85c-ac86-4bef-9708-88ea0671461e	Suresh	Gunasekara	No. 78, Main Street, Negombo	B000055	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
e9551e21-3770-41c9-825f-d4a26450bc8e	Nuwan	Jayasuriya	No. 89, Galle Road, Kalutara	B000056	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
06a181f0-80b7-44c7-890d-702b2f9570bb	Asanka	Rajapaksa	No. 89, Galle Road, Kalutara	B000057	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
f14204c2-3178-403b-a4bf-86900c034490	Pradeep	Jayawardena	No. 28, Hospital Road, Matara	B000058	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
9162fc0a-9afd-47d2-b3c8-e8437f89ce45	Sachith	Pathirana	No. 89, Galle Road, Kalutara	B000059	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
05232122-7867-4cba-bc5f-0136501cc898	Pavithra	Jayawardena	No. 23, High Level Road, Homagama	B000060	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
5c707f13-c55e-4240-8489-3b13347d06d5	Kasun	Wijesinghe	No. 56, Highlevel Road, Nugegoda	B000061	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
f09acdcb-622b-40d2-a1ca-a14c8f5c6e04	Chaminda	Pathirana	No. 23, High Level Road, Homagama	B000062	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
7b28e0f3-45aa-4436-b187-d707d6143970	Dilini	Dissanayake	No. 43, Matara Road, Weligama	B000063	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
2fcb052c-35a1-4bc5-99e0-53e3a4498eab	Nimal	Bandara	No. 89, Galle Road, Kalutara	B000064	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
d6b7f6d9-a19f-4952-96d6-3b23dee8e147	Dilshan	Abeysekara	No. 34, Station Road, Panadura	B000065	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
86bd4df3-a312-46e7-969e-6a0d3296a5d2	Chamari	Madushanka	No. 28, Hospital Road, Matara	B000066	2028-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
690eeec9-8132-48e6-b24e-dd46ebf7b9a0	Anusha	Jayasuriya	No. 89, Galle Road, Kalutara	B000067	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
f7ed0c50-da31-4838-adef-b7f70deff845	Rashmi	Gunaratne	No. 36, Temple Road, Bandaragama	B000068	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
bd51d1a0-9f0b-4224-9d1e-d7180df06c0a	Chathura	Madushanka	No. 15, Peradeniya Road, Kandy	B000069	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
585ebd1d-4139-4cd1-a1f7-03e67df3291d	Buddika	Dissanayake	No. 54, Lake Road, Kaduwela	B000070	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
d31a4eca-4a3f-4efe-9505-069d94e14734	Pavithra	Rathnayake	No. 67, Colombo Road, Gampaha	B000071	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
472afa80-bf5d-43d1-8e44-df247c9fbcdf	Hirantha	Wickramasinghe	No. 91, Marine Drive, Galle	B000072	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
54bde0ab-2ef5-408e-8ec1-df75a3026def	Sachini	Wickramasinghe	No. 72, New Road, Horana	B000073	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
7eeabd19-01a7-4cdf-8565-04888ce2e5d0	Ruwan	Bandara	No. 78, Main Street, Negombo	B000074	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
b9cdca48-90c2-4610-adb4-beff3118b783	Iresha	Abeysekara	No. 78, Main Street, Negombo	B000075	2028-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
adc6f832-49b1-4edf-8310-eb7d52862e6b	Kumari	Kumara	No. 54, Lake Road, Kaduwela	B000076	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
259878fd-7edb-440f-a200-e9f0269882cc	Nimasha	Amarasinghe	No. 56, Highlevel Road, Nugegoda	B000077	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
615a1be5-cc13-4101-98b2-ffb79c3c57e0	Upul	Kumara	No. 23, High Level Road, Homagama	B000078	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
368eb570-61e4-48c0-b280-227d91f6a6ef	Dilshan	Dissanayake	No. 67, Colombo Road, Gampaha	B000079	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
87a87589-2e10-4902-be40-f1b9a4e0da92	Menaka	Weerasinghe	No. 91, Marine Drive, Galle	B000080	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
4e922900-bd31-4c0b-9555-81ea1d95a01f	Sachith	Rajapaksa	No. 78, Main Street, Negombo	B000081	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
3913130c-47c9-44f0-a700-467e044310f2	Harsha	Gunaratne	No. 12, Kandy Road, Kelaniya	B000082	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
6a3e5fbe-1a1a-4d29-bec6-88bfe8688ab9	Chaminda	Gunasekara	No. 78, Main Street, Negombo	B000083	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
ed9fa910-127c-4e36-ab6e-def5ba510770	Kamal	Pathirana	No. 12, Kandy Road, Kelaniya	B000084	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
c6fe6f13-fcd9-4939-aba0-1f3f2ebb0efa	Nimal	Mendis	No. 43, Matara Road, Weligama	B000085	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
c23a9a19-96f1-4b99-8f4f-85d0f94bf90f	Dilini	Weerasinghe	No. 15, Peradeniya Road, Kandy	B000086	2028-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
3c61d9a4-7206-4909-9315-637f8800c988	Chamari	Pathirana	No. 56, Highlevel Road, Nugegoda	B000087	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
0902b4f3-104f-4c14-849c-6dfd566be8e6	Isuru	Wickramasinghe	No. 28, Hospital Road, Matara	B000088	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
92254446-182e-46ed-91df-016842aeb4e4	Kamal	Fernando	No. 36, Temple Road, Bandaragama	B000089	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
87cb577e-7747-451b-b59d-d48274661436	Upul	Gunasekara	No. 54, Lake Road, Kaduwela	B000090	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
2b3079c6-3122-42fb-91a4-0f7300b4b54a	Iresha	Senanayake	No. 23, High Level Road, Homagama	B000091	2028-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
a6725abd-5f83-4b41-8c7c-05e3fc98576c	Janaka	Kumara	No. 54, Lake Road, Kaduwela	B000092	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
97ed7ac6-3016-4206-b0d0-56f5067c44a4	Asanka	Bandara	No. 56, Highlevel Road, Nugegoda	B000093	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
4182c70e-d8e5-46a7-8cf4-59b422c9d34c	Iresha	Senanayake	No. 12, Kandy Road, Kelaniya	B000094	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
89f1a8dd-71fd-445e-9743-6f9116d4361f	Dilshan	Weerasinghe	No. 43, Matara Road, Weligama	B000095	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
457f2077-d167-4ba0-a6bc-1654f3bffbd9	Upul	Madushanka	No. 15, Peradeniya Road, Kandy	B000096	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
559bf72a-fa17-4598-bef5-b0a58acc3f2e	Lasith	Jayawardena	No. 78, Main Street, Negombo	B000097	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
44dd4b42-73e2-438f-86bd-37686713a121	Isuru	Wickramasinghe	No. 36, Temple Road, Bandaragama	B000098	2028-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
84bdb167-0aa2-4a59-abab-4c7b1df90a91	Thilini	Jayasuriya	No. 12, Kandy Road, Kelaniya	B000099	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
fd7b3beb-abee-486a-895a-3eb7b743c2ca	Saman	Ranasinghe	No. 45, Galle Road, Colombo 03	B000100	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
08fb557f-81dd-464c-b3d1-3d35cdb9708b	Thilak	Fernando	No. 67, Colombo Road, Gampaha	B000101	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
0567ad01-5aa5-4cf2-94eb-5ce887e0e7db	Sewwandi	Abeysekara	No. 78, Main Street, Negombo	B000102	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
c5257495-45bb-41be-a1aa-3884da33aee8	Shehan	Gunasekara	No. 34, Station Road, Panadura	B000103	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
b4a734e8-1e1d-43d1-a512-11a48a447237	Chaminda	Gunasekara	No. 67, Colombo Road, Gampaha	B000104	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
7d8612c0-45c6-40c1-aa3c-8c009b93a9b2	Suresh	Mendis	No. 15, Peradeniya Road, Kandy	B000105	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
d9675405-e54b-4df4-a2a4-ac5cfbb7db88	Thilak	Wickramasinghe	No. 54, Lake Road, Kaduwela	B000106	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
a228301b-b743-4b7a-87cc-c19a8c52ec53	Sachini	Amarasinghe	No. 23, High Level Road, Homagama	B000107	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
083be483-a5e7-446b-a947-85a8a73d5412	Nuwan	Rathnayake	No. 34, Station Road, Panadura	B000108	2028-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
3295c497-f086-46fc-98e8-281d62001e7e	Kasun	Fernando	No. 67, Colombo Road, Gampaha	B000109	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
e478de9f-d079-4007-850d-2a9dae18d5ea	Gayan	Rajapaksa	No. 56, Highlevel Road, Nugegoda	B000110	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
b597ac11-ebc1-4bac-a427-8ff2275052a5	Chathurika	Abeysekara	No. 36, Temple Road, Bandaragama	B000111	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
296e5dfa-f8f7-44ff-b7f8-4158fd094a4c	Pradeep	Perera	No. 56, Highlevel Road, Nugegoda	B000112	2028-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
7696edaf-25f4-4073-a0fc-8c6048b00ec3	Nadun	Mendis	No. 23, High Level Road, Homagama	B000113	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
4d8a9767-9527-4543-affa-56a15ff0236e	Sachith	Abeysekara	No. 23, High Level Road, Homagama	B000114	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
328acb14-e379-493d-9dfa-9e169ba31b38	Ruwan	Silva	No. 56, Highlevel Road, Nugegoda	B000115	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
242200a5-7833-42a3-b8a9-8c0d30338be0	Chathura	Wijesinghe	No. 34, Station Road, Panadura	B000116	2028-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
026f58ed-7208-4852-b9e0-c0fc7d5bf702	Nadun	Jayawardena	No. 43, Matara Road, Weligama	B000117	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
e4b2c238-4202-47c3-80cd-93ad4cbed1fe	Menaka	Gunasekara	No. 56, Highlevel Road, Nugegoda	B000118	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
f949f7e0-9348-4e3d-a20e-935a773e6809	Pavithra	Jayasuriya	No. 36, Temple Road, Bandaragama	B000119	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
91ae1b5c-5f4a-4ac6-aa5e-7a45e7964242	Kasun	Gunaratne	No. 43, Matara Road, Weligama	B000120	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
97079aad-3758-445f-8ee6-65f2be6ac01a	Sandya	Dissanayake	No. 54, Lake Road, Kaduwela	B000121	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
ae102836-312d-497f-ad30-439d6b79b527	Asanka	Gunasekara	No. 78, Main Street, Negombo	B000122	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
ba47f41d-4734-4f90-bd5a-1227035da32e	Sachini	Weerasinghe	No. 45, Galle Road, Colombo 03	B000123	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
4eff0136-a954-4a60-9cf7-c17471a0734c	Ruwan	Fernando	No. 43, Matara Road, Weligama	B000124	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
2d39feea-7563-43aa-b785-6cd4dbc62eee	Prasad	Weerasinghe	No. 72, New Road, Horana	B000125	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
10873f98-0301-42cb-8ff8-6c545787d952	Kasun	Mendis	No. 12, Kandy Road, Kelaniya	B000126	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
5a4243a8-dd94-4a02-ac84-9abe6f082511	Suresh	Silva	No. 45, Galle Road, Colombo 03	B000127	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
12f04e58-13da-4188-aead-31c5dbb18dce	Lasith	Senanayake	No. 36, Temple Road, Bandaragama	B000128	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
08d6a161-6c97-4a32-9744-a1c0a6615700	Chamari	Fernando	No. 67, Colombo Road, Gampaha	B000129	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
e85c5377-f7b3-4d3b-94de-667f6a540ec1	Sachith	Wickramasinghe	No. 45, Galle Road, Colombo 03	B000130	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
808a24b4-bc27-49df-b298-aa2f8d9c6d74	Pradeep	Bandara	No. 54, Lake Road, Kaduwela	B000131	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
605ecde7-4b07-432d-9c41-c26ed826dee8	Chathura	Bandara	No. 12, Kandy Road, Kelaniya	B000132	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
cb61b6cd-968a-4bee-b97c-e6de392bc84b	Menaka	Gunaratne	No. 34, Station Road, Panadura	B000133	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
cca7b10c-2277-438a-b355-83781d1f3388	Chathura	Wijesinghe	No. 56, Highlevel Road, Nugegoda	B000134	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
e2df70ab-1f9a-4784-88b4-437304f57600	Pradeep	Bandara	No. 28, Hospital Road, Matara	B000135	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
08e5f9df-d083-430c-bdd1-ba9842fa5381	Shehan	Gunasekara	No. 78, Main Street, Negombo	B000136	2028-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
ab8bb463-b4bc-4917-9228-01b76f7787ca	Nadeesha	Seneviratne	No. 67, Colombo Road, Gampaha	B000137	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
b922ab95-4d65-4475-879f-f3562b1b6617	Nimal	Wickramasinghe	No. 36, Temple Road, Bandaragama	B000138	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
c9ea36f2-baab-491e-8bef-54147970a423	Anusha	Herath	No. 45, Galle Road, Colombo 03	B000139	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
b289b57c-734d-431c-b1c9-493bb7cbe00f	Suresh	Senanayake	No. 91, Marine Drive, Galle	B000140	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
16e2602f-f68e-4c37-9bb4-b21c29d5c36b	Saman	Amarasinghe	No. 12, Kandy Road, Kelaniya	B000141	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
5d673fcc-8053-4a13-aeb8-d781211d2e6c	Roshan	Gunaratne	No. 91, Marine Drive, Galle	B000142	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
4aebea4e-8519-46d7-9644-7fd9afbafc39	Thilini	Rathnayake	No. 45, Galle Road, Colombo 03	B000143	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
27c54acf-3771-401e-8a60-9ebd805bebd2	Sewwandi	Gunasekara	No. 34, Station Road, Panadura	B000144	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
6c2e980e-cec4-491c-9244-69c383e2ed4c	Saman	Ranasinghe	No. 91, Marine Drive, Galle	B000145	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
b6c822ae-b631-486e-9ec8-68f0a10453b2	Chaminda	Mendis	No. 45, Galle Road, Colombo 03	B000146	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
c5122ca6-6f65-405e-a71b-284a92318af2	Anusha	Pathirana	No. 43, Matara Road, Weligama	B000147	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
576af9b2-0caf-48c9-8efa-ae314e78171f	Thilak	Amarasinghe	No. 78, Main Street, Negombo	B000148	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
cf3e6ae4-c2f5-475e-9030-c0d80fcdb736	Janaka	Ranasinghe	No. 43, Matara Road, Weligama	B000149	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
daa1a9d6-10c6-42c2-8f42-eba834b9ba4c	Pradeep	Seneviratne	No. 23, High Level Road, Homagama	B000150	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
7e3e85b8-be14-4689-a334-f70d4f005477	Dhanushka	Bandara	No. 28, Hospital Road, Matara	B000151	2028-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
55550666-455b-42d4-826d-7d0676a56ee3	Harsha	Wickramasinghe	No. 89, Galle Road, Kalutara	B000152	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
1e97a347-2022-4ac5-930f-3957884a8481	Upul	Rajapaksa	No. 15, Peradeniya Road, Kandy	B000153	2028-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
39446891-f172-42ab-bdee-1813a6178144	Thilini	Silva	No. 34, Station Road, Panadura	B000154	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
00f0c138-4c88-4206-92dc-cdef3a47bbd0	Anusha	Dissanayake	No. 67, Colombo Road, Gampaha	B000155	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
81456c7c-dcb2-4fa6-9c43-3c6f2453d108	Thilak	Jayawardena	No. 72, New Road, Horana	B000156	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
8656177f-7a61-467f-bd9e-52e434de764e	Nadeesha	Pathirana	No. 54, Lake Road, Kaduwela	B000157	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
41563e9b-7249-4f6d-98c1-50e4cc696f35	Kasun	Herath	No. 23, High Level Road, Homagama	B000158	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
bfb8ca4c-f9d3-4e26-85ee-c691487ad56d	Saman	Silva	No. 72, New Road, Horana	B000159	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
0a75b266-541d-4a0b-a607-ad988b3ad99f	Kamal	Ranasinghe	No. 34, Station Road, Panadura	B000160	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
7ed831c8-0487-4286-84a7-c7ed952b7d52	Dilshan	Herath	No. 43, Matara Road, Weligama	B000161	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
f88a23a4-0fbf-4e1d-acf8-2505f0d7be4b	Nuwan	Weerasinghe	No. 15, Peradeniya Road, Kandy	B000162	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
c2769059-2179-4cb5-b059-24b8c8d7a12d	Chamari	Madushanka	No. 45, Galle Road, Colombo 03	B000163	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
38b35552-9113-4560-a736-90b4d2288ab4	Upul	Weerasinghe	No. 36, Temple Road, Bandaragama	B000164	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
78e378ed-1d35-49e8-8ea1-75b0fe82e9c6	Chamari	Seneviratne	No. 28, Hospital Road, Matara	B000165	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
61dff57a-e2b0-4d36-a13d-91047a1d44b9	Tharaka	Senanayake	No. 43, Matara Road, Weligama	B000166	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
6eb93b8c-2ff3-461b-bce7-a557cb1a7f28	Thilak	Perera	No. 89, Galle Road, Kalutara	B000167	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
5414046b-ab65-443b-a828-f04693f0f358	Upul	Pathirana	No. 12, Kandy Road, Kelaniya	B000168	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
901553ac-61ce-4416-bc8d-6cd593e0e927	Mahesh	Gunasekara	No. 34, Station Road, Panadura	B000169	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
81dffc79-a502-4bda-8c5d-469c83526d43	Hirantha	Silva	No. 56, Highlevel Road, Nugegoda	B000170	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
5113d27d-6b0d-43ac-93b6-2950e4bba1ac	Gayan	Pathirana	No. 78, Main Street, Negombo	B000171	2028-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
47700f72-6ff1-406c-8955-ca2a42752751	Kumari	Seneviratne	No. 36, Temple Road, Bandaragama	B000172	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
ac25dc9b-f3be-4f20-96f7-1e43208b4e6a	Tharaka	Dissanayake	No. 43, Matara Road, Weligama	B000173	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
aa8b823d-4366-495a-8e59-dcb0e3443f88	Tharaka	Gunasekara	No. 15, Peradeniya Road, Kandy	B000174	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
7efa8400-c306-4949-a945-daa2584b58fc	Iresha	Dissanayake	No. 36, Temple Road, Bandaragama	B000175	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
0cc6e9f7-057b-42f7-89c6-4845f67818c1	Prasad	Liyanage	No. 54, Lake Road, Kaduwela	B000176	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
94b299a7-3555-444a-8a9d-1f7352c5bde6	Ruwan	Seneviratne	No. 36, Temple Road, Bandaragama	B000177	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
c6471d14-229c-4846-9405-8d51453ea935	Dhanushka	Mendis	No. 36, Temple Road, Bandaragama	B000178	2032-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
657be8f1-006e-4d8b-8b6e-6c9efc777971	Nimasha	Rajapaksa	No. 36, Temple Road, Bandaragama	B000179	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
df75858f-c338-44b1-8ca2-25f2724d9fae	Dhanushka	Seneviratne	No. 72, New Road, Horana	B000180	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
e5ea94cc-51dc-495d-b903-57b5a1e98b0e	Nimal	Rathnayake	No. 12, Kandy Road, Kelaniya	B000181	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
506f02d4-6afb-4316-be18-d22267563f2d	Sachini	Wickramasinghe	No. 15, Peradeniya Road, Kandy	B000182	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
1134b1f8-0f61-4645-b04c-84148ebf2a86	Chaminda	Wijesinghe	No. 67, Colombo Road, Gampaha	B000183	2034-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
0220bee2-03b4-4d95-9922-1ab1ee11b4b7	Janaka	Liyanage	No. 89, Galle Road, Kalutara	B000184	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
63af9512-6602-4e0c-850e-6e00974f319d	Janaka	Pathirana	No. 91, Marine Drive, Galle	B000185	2031-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
48245acd-2400-4234-8c81-f7d3d3c43ed8	Dilini	Madushanka	No. 56, Highlevel Road, Nugegoda	B000186	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
05552314-6fc9-45f8-9c44-14d8d2f2dfa6	Kasun	Abeysekara	No. 89, Galle Road, Kalutara	B000187	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
72969b68-e395-462e-9a70-4dcfb9a2d4f5	Nimasha	Amarasinghe	No. 28, Hospital Road, Matara	B000188	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
c56ddc01-81d8-4389-a27f-407345316449	Nuwan	Weerasinghe	No. 43, Matara Road, Weligama	B000189	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
62ddc133-8857-4755-8129-5bd238e099a9	Lasith	Ranasinghe	No. 28, Hospital Road, Matara	B000190	2030-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
573f0309-9c7e-4509-a7c7-6e1b8cdd7901	Harsha	Bandara	No. 43, Matara Road, Weligama	B000191	2027-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
c8609a88-d771-4dd7-845a-afdc6a375cc2	Malith	Mendis	No. 15, Peradeniya Road, Kandy	B000192	2033-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
d03916d2-b6f7-4eea-b755-6867190210f9	Chathura	Silva	No. 72, New Road, Horana	B000193	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
4b42ad53-5337-496a-bf74-e6f2201abe02	Asanka	Rathnayake	No. 56, Highlevel Road, Nugegoda	B000194	2029-04-25	CLEAR	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
1cf13327-0802-4dc0-acca-6291b27dec00	Nadun	Dissanayake	No. 78, Main Street, Negombo	B000195	2033-04-25	WANTED	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
da2557b0-e786-43f8-8598-ceee8c9b3cfd	Kamal	Fernando	No. 89, Galle Road, Kalutara	B000196	2028-04-25	WANTED	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
00ef021e-6065-4a23-8497-4fb6aeeefe92	Roshan	Gunaratne	No. 45, Galle Road, Colombo 03	B000197	2029-04-25	WANTED	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
ec32bbe3-f1f0-440e-9447-8bd7fce9083d	Kasun	Pathirana	No. 43, Matara Road, Weligama	B000198	2031-04-25	WANTED	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
b590ca34-dfb4-4d3b-b636-a3169df826c2	Hirantha	Rathnayake	No. 34, Station Road, Panadura	B000199	2029-04-25	WANTED	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
b4871bf5-4a63-4bf2-84c4-5f5c2baac56b	Buddika	Herath	No. 23, High Level Road, Homagama	B000200	2029-04-25	WANTED	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
b1e8d6a4-b69f-4c8d-92b6-84a4ae13326e	Pradeep	Wijesinghe	No. 56, Highlevel Road, Nugegoda	B000201	2031-04-25	WANTED	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
c89184b0-c12e-4da1-b9e9-7bca50cb71e9	Dilshan	Weerasinghe	No. 36, Temple Road, Bandaragama	B000202	2032-04-25	WANTED	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
1c5acd68-c691-4202-bcc0-3a79abb9665b	Sachith	Senanayake	No. 91, Marine Drive, Galle	B000203	2029-04-25	WANTED	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
daf69daa-02ad-451c-8b49-086bdba5e9fb	Kumari	Seneviratne	No. 23, High Level Road, Homagama	B000204	2028-04-25	WANTED	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
4faba871-eb62-48af-b58e-b2d5face6d5b	Menaka	Silva	No. 91, Marine Drive, Galle	B000205	2033-04-25	SUSPENDED_LICENSE	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
5d2538fe-f6dd-4c0e-b493-6c12732e7dfc	Malith	Wickramasinghe	No. 45, Galle Road, Colombo 03	B000206	2033-04-25	SUSPENDED_LICENSE	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
bb604674-74e0-4fa7-b9e6-eecd58cce0ae	Suresh	Dissanayake	No. 36, Temple Road, Bandaragama	B000207	2032-04-25	SUSPENDED_LICENSE	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
c6d5547f-d6c1-4428-b310-c63a5825ea8b	Pavithra	Fernando	No. 34, Station Road, Panadura	B000208	2033-04-25	SUSPENDED_LICENSE	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
9552c5ed-4b5c-4750-9881-094d81d963c0	Harsha	Pathirana	No. 15, Peradeniya Road, Kandy	B000209	2031-04-25	SUSPENDED_LICENSE	2026-04-25 08:46:53.053648+00	2026-04-25 08:46:53.053648+00
\.


--
-- Data for Name: knex_migrations; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.knex_migrations (id, name, batch, migration_time) FROM stdin;
3	20260424152803_001_create_provinces.js	1	2026-04-25 05:37:37.395+00
4	20260424152895_002_create_districts.js	1	2026-04-25 05:37:37.402+00
5	20260424152900_003_create_divisional_secretariats.js	1	2026-04-25 05:37:37.406+00
6	20260424154914_004_create_station_types.js	1	2026-04-25 05:37:37.41+00
7	20260424154922_005_create_stations.js	1	2026-04-25 05:37:37.414+00
8	20260424154929_006_create_users.js	1	2026-04-25 05:37:37.419+00
9	20260424154936_007_create_tracking_devices.js	1	2026-04-25 05:37:37.422+00
13	20260424155004_011_create_refresh_tokens.js	1	2026-04-25 05:37:37.435+00
16	20260424154942_008_create_vehicles.js	2	2026-04-25 08:42:51.23+00
17	20260424154949_009_create_drivers.js	2	2026-04-25 08:42:51.236+00
18	20260424154956_010_create_vehicle_driver_assignments.js	2	2026-04-25 08:42:51.239+00
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
4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	Western	2026-04-25 05:51:13.251321+00	2026-04-25 05:51:13.251321+00
f799c375-84e9-40e0-82af-42de97f32e21	Central	2026-04-25 05:51:13.251321+00	2026-04-25 05:51:13.251321+00
ec8566fb-2a50-4696-b766-a5f3b18bcc77	Southern	2026-04-25 05:51:13.251321+00	2026-04-25 05:51:13.251321+00
8c98746f-4268-446e-a3ac-bf0ef36dd19d	Northern	2026-04-25 05:51:13.251321+00	2026-04-25 05:51:13.251321+00
03f1f49b-3db3-46c8-a509-d4a89353daf4	Eastern	2026-04-25 05:51:13.251321+00	2026-04-25 05:51:13.251321+00
a48a6e1f-c9e2-4866-9ad3-c69c10aec75f	North Western	2026-04-25 05:51:13.251321+00	2026-04-25 05:51:13.251321+00
9e830b9f-c38f-419c-bae1-18350793f377	North Central	2026-04-25 05:51:13.251321+00	2026-04-25 05:51:13.251321+00
941968ca-f266-4b0b-a29c-9ac9cff6818b	Uva	2026-04-25 05:51:13.251321+00	2026-04-25 05:51:13.251321+00
ae78787a-3943-4ada-9f41-9c7bc2cb4f5e	Sabaragamuwa	2026-04-25 05:51:13.251321+00	2026-04-25 05:51:13.251321+00
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.refresh_tokens (token_id, user_id, token_hash, is_used, expires_at, created_at) FROM stdin;
\.


--
-- Data for Name: station_types; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.station_types (station_type_id, type_name, created_at, updated_at) FROM stdin;
36af1adc-8536-4a75-ad89-3dff25d53c13	Police Headquarters	2026-04-25 07:34:08.468568+00	2026-04-25 07:34:08.468568+00
6c7b1531-33ad-4c8e-94a7-efaec1441151	Range Office	2026-04-25 07:34:08.468568+00	2026-04-25 07:34:08.468568+00
4bc37aa5-1361-4b6c-8508-b3772fb3fd80	Main Station	2026-04-25 07:34:08.468568+00	2026-04-25 07:34:08.468568+00
1fcd2589-8558-431b-9b5c-18a870ba80d0	Police Post	2026-04-25 07:34:08.468568+00	2026-04-25 07:34:08.468568+00
\.


--
-- Data for Name: stations; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.stations (station_id, ds_division_id, district_id, province_id, station_type_id, name, contact_number, latitude, longitude, created_at, updated_at) FROM stdin;
568575fb-6fba-44aa-a487-68cd4c9ce40f	\N	\N	\N	36af1adc-8536-4a75-ad89-3dff25d53c13	Sri Lanka Police Headquarters	+94112421111	6.9271000	79.8612000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
7594f820-1cf8-4b5c-b984-0a8333459dcd	\N	\N	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	6c7b1531-33ad-4c8e-94a7-efaec1441151	Western Province Range Office	+94112300001	6.9271000	79.8612000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
07d077b9-8ea9-4628-850f-63ca41c53d86	\N	\N	f799c375-84e9-40e0-82af-42de97f32e21	6c7b1531-33ad-4c8e-94a7-efaec1441151	Central Province Range Office	+94812200001	7.2906000	80.6337000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
04028899-5581-461e-8c36-2b7b75aed638	\N	\N	ec8566fb-2a50-4696-b766-a5f3b18bcc77	6c7b1531-33ad-4c8e-94a7-efaec1441151	Southern Province Range Office	+94912200001	6.0535000	80.2210000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
12bf6ab2-b0c0-4e58-a5af-e2a4a7c0b058	\N	bb17281d-bf1c-4177-836f-4d3ad4ae672f	\N	4bc37aa5-1361-4b6c-8508-b3772fb3fd80	Colombo District Main Station	+94112421001	6.9344000	79.8428000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
d618e608-9c86-43dd-8ed0-88551e0edbf1	\N	50f797be-832e-4aa6-9e1f-1a0ad0d340b7	\N	4bc37aa5-1361-4b6c-8508-b3772fb3fd80	Gampaha District Main Station	+94332222001	7.0873000	80.0144000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
b9e8d96c-4546-4528-b2f1-7d256eb45c15	\N	b0b7f9f8-ddc9-49ac-b7f3-edc923a785ba	\N	4bc37aa5-1361-4b6c-8508-b3772fb3fd80	Kalutara District Main Station	+94342222001	6.5854000	79.9607000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
e0b92864-384f-4daf-952d-d0082153cdaf	\N	6cfc9dbf-25af-41b9-bc4b-32139801282e	\N	4bc37aa5-1361-4b6c-8508-b3772fb3fd80	Kandy District Main Station	+94812222001	7.2906000	80.6337000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
9c649842-0191-430e-b90f-c281aced0fec	\N	61a91c99-5ecd-411f-aefd-f25becb96502	\N	4bc37aa5-1361-4b6c-8508-b3772fb3fd80	Galle District Main Station	+94912222001	6.0535000	80.2210000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
ba4e9fb6-3171-4d7f-8980-a2634d467e20	\N	000b98e4-e847-44da-a0ab-87c96618200a	\N	4bc37aa5-1361-4b6c-8508-b3772fb3fd80	Matara District Main Station	+94412222001	5.9549000	80.5550000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
926ffeac-51b5-45af-a752-594b07060db8	f2da06fe-aa8f-4d0a-86e8-6046ccb63aed	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Colombo Police Post	+94112421002	6.9271000	79.8612000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
8332587a-eab5-42da-9b79-b15c295e0eda	4afb1503-2040-406d-876c-28f2a96f6976	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Dehiwala-MountLavinia Police Post	+94112721001	6.8517000	79.8653000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
82a1d207-c544-40ec-85b6-bce80c86b851	a9073863-2872-46ea-ae68-9361d29b19b2	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Homagama Police Post	+94112856001	6.8428000	80.0022000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
808a3f51-e2e5-4117-b617-50b8d1f974aa	9dfd6f0b-8fb6-4276-a268-2d2cb9651c19	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Kaduwela Police Post	+94112537001	6.9286000	79.9892000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
853ba4a1-43d8-4650-b9a1-7dced4fd1944	c04e380e-7099-48e0-b262-82fef866f4e5	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Kesbewa Police Post	+94112608001	6.7967000	79.9331000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
16f4c469-8449-4364-ab93-3abb2037c138	abebfca6-ecef-431b-8b19-921f7837c346	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	SriJayawardanapuraKotte Police Post	+94112865001	6.9108000	79.8878000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
84e1516b-e0b0-42f4-bca2-ca7c3e3af59a	814b9697-a59e-4c42-89fb-cf59a9c09aaf	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Thimbirigasyaya Police Post	+94112696001	6.8979000	79.8718000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
fa46bf4b-26a2-4bec-84f7-488956578c9a	2436dd06-0962-4b9d-9d44-05d0d7aad1da	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Ja-Ela Police Post	+94112231001	7.0742000	79.8916000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
f8a51777-61c0-4e56-91ef-6086977f02e9	884024df-4e78-4053-b0c6-2836eb6356d1	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Kelaniya Police Post	+94112911001	7.0006000	79.9208000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
68c5646a-f975-428b-a7ea-4a34e50ed7b9	b3370fc1-5c41-46e1-8a31-1a7a57fb888b	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Negombo Police Post	+94312222001	7.2096000	79.8357000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
a9dd0c38-6ad5-48a2-a69c-d6d55464dfe5	a1c6d3e9-a7d3-4fcd-bba1-3563bebe2a76	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Wattala Police Post	+94112939001	6.9897000	79.8893000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
69392709-ed58-48b1-b05d-83313eedf480	1b10e701-c3f1-4093-996f-2670e33ed20d	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Horana Police Post	+94342260001	6.7156000	80.0631000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
21bce9a4-1fde-4a92-ac58-3bf23bd0c5b7	cb7490f0-6ce3-4507-a513-f9c9911f9971	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Bandaragama Police Post	+94382290001	6.7139000	79.9833000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
dc3f1d52-b8ba-42a8-a1ef-0677068552a9	c12db83e-cc73-4a12-b87a-e3e84550681b	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Ingiriya Police Post	+94342290001	6.7367000	80.1356000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
9bae8cea-c8b6-4e3e-bf16-6490838bb5e3	a7de5f8e-58e8-4525-9fcd-be9d85d3b6ef	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Panadura Police Post	+94382222001	6.7136000	79.9064000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
061f41ee-a969-4921-b434-e9e0b66afbaa	71099a80-65f6-497b-b9fc-b9f1d75887bc	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Medadumbara Police Post	+94812222002	7.3667000	80.7167000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
8cf11cea-52e2-4e32-80a7-6490a34fd453	7324e94b-6f22-4790-81b5-29c8ec7e1444	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Minipe Police Post	+94812222003	7.2833000	80.9167000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
7c279f67-bb25-41e8-b466-aa1f28238136	853902e3-9fec-4b51-a7a7-06369b556cb3	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Thumpane Police Post	+94812222004	7.3833000	80.5500000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
5e8ad560-e543-4f4f-b68a-dee421996836	50a84cca-ca20-4191-a045-ab9498525783	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Udunuwara Police Post	+94812222005	7.2167000	80.5833000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
507a3233-8268-41b6-85d0-005e94c124ff	7017d7a5-6291-4744-8471-4afc8b7d43a7	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Ambalangoda Police Post	+94912258001	6.2341000	80.0567000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
d17cdb2f-c508-40ee-9b0d-9afe82c203fd	5c54f61f-704a-485a-9005-5a10eaa86756	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Baddegama Police Post	+94912292001	6.1833000	80.1833000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
ab8e81ab-ccbc-4671-a6e5-67d3a57faa6d	6eb2b751-88ef-4816-9c73-ebc984a0c948	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Balapitiya Police Post	+94912260001	6.2667000	80.0333000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
00fdaee4-b46c-4124-863a-6718a32ddb87	ba2ce2b5-f00d-49ae-b588-dcc711798e4b	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Elpitiya Police Post	+94912293001	6.2833000	80.1667000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
48ebc457-f4fb-4d54-9360-a1f3c47056bb	cec8a52f-471a-436c-bd24-8d3b62876e5d	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Hikkaduwa Police Post	+94912277001	6.1395000	80.1054000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
e87a595e-ec16-41d3-95b5-f8354dca2df7	6de72e8c-e5bf-4671-98a6-b305e0cdb53d	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Devinuwara Police Post	+94412222002	5.9333000	80.5667000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
54a475ea-7826-46d0-818f-4df740e7d090	0ffe1162-63b9-4cca-b3da-4a17fd694853	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Dickwella Police Post	+94412283001	5.9667000	80.7000000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
ffe4ba65-a805-4efa-a07b-41fc23f44aa0	a73cbea7-3576-4bf2-b615-cdb55515680c	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Mulatiyana Police Post	+94412247001	6.1167000	80.5000000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
dc38a812-822d-4b59-b8b8-dec0fa528907	53b5edc3-0b78-48b9-9c72-56f9274521f9	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Pitabeddara Police Post	+94412248001	6.0500000	80.5167000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
ff61be6f-c3b6-47aa-a783-e455efd8bb06	9c9191ac-f3a5-4bc3-8988-bbf4d384647c	\N	\N	1fcd2589-8558-431b-9b5c-18a870ba80d0	Weligama Police Post	+94412250001	5.9747000	80.4290000	2026-04-25 07:41:44.655208+00	2026-04-25 07:41:44.655208+00
\.


--
-- Data for Name: tracking_devices; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.tracking_devices (device_id, serial_number, api_key_hash, issued_date, admin_status, created_at, updated_at) FROM stdin;
11f042a3-7b8f-489a-b1f8-1a44474418ba	TRK-SL-00001	25d4d97d951652919659063264b934093c8d304d8d4c5cbef5ce4edae3baf1b3	2025-11-06	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
20a2a621-2f96-457a-b479-714da4ba7382	TRK-SL-00002	468a925f1b8dcb0e7431a624ecdaaf21074699fbde1d35bd70c18a0255ae8537	2026-04-05	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
21bb86b5-e2c3-4c17-8762-274b01613db1	TRK-SL-00003	212c4f65b73b3a6433e67f0ae4246486810208e119cc1cdff360ae9a960c86fb	2025-05-07	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
60f2153c-b0fb-443e-9b42-428982f40470	TRK-SL-00004	7effdce9d62912b8041da4e68dc977c7e599435f745385d4288f7f92a14bd770	2025-07-12	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
95b09c4d-0897-45cd-877b-4bf766e3c91f	TRK-SL-00005	a933a39817cd363939789653d0c855b5972dce806242312d75ec41aa40b0f4e9	2025-04-29	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
cd7644c5-b92d-41bc-9605-40418d6cda45	TRK-SL-00006	781b3a1ee4acacb0632817d0ccc0a5a6398242c202d007ff7e2709332e1247f1	2026-01-07	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
f8a88484-483c-4996-b479-e29d46cbedc3	TRK-SL-00007	d08508aabb6fdbd430f7705dc46221e25a026d8c8822009426c8086aff44c1d0	2025-09-03	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
ff3d4a2e-aa6f-4673-b520-ac65aed6a0b3	TRK-SL-00008	c0520e73a709c26374e9310509b48ee8defb27c9e1fcdbb8899232a24555ea9e	2025-11-13	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
a0d1ee46-8387-48a0-9fc7-e38b55b9c0fb	TRK-SL-00009	bf1653f90f1e7fdff217328529206d47a24730d522907a43c05d06c67ad6295a	2025-10-23	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
c19d08d8-6669-410a-ae49-fa11c5f79dc1	TRK-SL-00010	7cb4915309c78db04b2957caf11ef15a5550f4d140579c61004440fcd8fc18dd	2026-04-02	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
9d9cbfaa-11b4-4b9b-8f7d-e1275c629ce6	TRK-SL-00011	22b9b9d60a615e9d77740c47e91c5cfca4220e648bcef757be2351627e861063	2025-11-19	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
e3241eda-587d-48ef-afd8-84a3c57e437a	TRK-SL-00012	b318856c6880742ac87a82ca45f16f340f12ed024be589c5e17b9c1f92714463	2025-05-13	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
c6469a31-2481-48c4-b456-5b5f5bedbefb	TRK-SL-00013	eb25310804a9abb9d390830d38385b5173c945bbae27b65ceb787559135a25b9	2025-08-15	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
e1fdb938-b4e9-48da-92e8-ac2f99a9d647	TRK-SL-00014	f4551bf6bff4a5dd2b421e1f018b886d760a9fc7642b286cf644985edfd3b1db	2026-04-12	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
7b92f00d-042b-4e90-8b22-febedf61e87c	TRK-SL-00015	01f814b5779c093f8b5da012960e6dde715a2a41fa483de21c91aafd72180321	2025-09-14	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
83c7f439-6c23-43cb-a360-393705800682	TRK-SL-00016	678271facf129e156dd53fd55ca1c43bbf30282ed7275047a9d09ad2d47664e1	2025-11-18	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
e1e5b0f6-0c62-4482-af2f-fb800423a97c	TRK-SL-00017	a73ed21f78bc21935d31273907835fa7d90363b709d53bad3eb0a7af3c900ae0	2026-01-06	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
ab402c19-2ad0-4054-8e15-686b4de10919	TRK-SL-00018	7baa1930b464a18897f0f3bf1776f68cf90924ca33ffd4b8b805485dbf38a9a4	2026-04-22	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
79491ddd-4614-407d-bb0d-6e26146f9150	TRK-SL-00019	dd29e06ad53d96356a9e8b66ca456af5f11c1f9a7b50b2416325159d0a64d90d	2025-09-07	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
c55f30fd-c14b-422a-9e50-958019a2f1d2	TRK-SL-00020	9fab531fe2f38b09cd38d1f790db9e29e6a36cb39ec566ee172d4fcab27653f9	2025-06-25	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
abcc96d4-991f-413d-b6e2-322ad076a122	TRK-SL-00021	ee0db121966882d86f04a85689b8720ec5bb09e91067d3dd65814a5ab1054986	2025-10-15	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
80dae15b-68bc-4a85-a7f2-3125657c75f9	TRK-SL-00022	e756b8984480160f019e29569aedd0a5263c9f39bf3173dc4f539ef309030b06	2025-05-22	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
56fb0f5d-463e-485e-862e-93807a500afe	TRK-SL-00023	258df476f69738f7d661a60ea9b9ba3e9546ab6fa42c3e4d5ab115f425dc470f	2025-11-06	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
de87e434-706b-46c7-8ec8-f01865b39f4c	TRK-SL-00024	bf11f9dfeaf3e9589b8edeb40025505ddcfca7d4feb3c99d9d2511727bfc0bed	2025-11-28	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
b29a21bd-5769-4a37-a1ee-539c5f413572	TRK-SL-00025	7f349bc3a5f44e7b932d9057ae6cc1c8c7b40f9cdae7a0eadb7eb1295190679f	2026-01-14	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
cb334d82-0f45-4eb9-a1c7-467f1663fc36	TRK-SL-00026	fb5d511a71352d8865ae6c3901c50a6ca7cc26ab34d937169b887af5133db2d0	2026-03-09	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
26190851-0559-4dd2-aba5-7e6e53b4d623	TRK-SL-00027	4d403289098c60a18bf166d99fc6a65970fb672f1a4580060ed6bece241b1983	2025-08-05	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
ba8417e5-4312-47a0-bf5c-de0014a46196	TRK-SL-00028	d3f74c2d938b456a928a987efe4474c647c7fe646f6cfe7bd2e75629d20150dc	2026-02-07	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
8e4127a5-c9ad-431d-ba6a-5f9af1f058ec	TRK-SL-00029	1603702463cd7d626121aed2c4a59dc8eb3ab5eeb3a96b6544e085c974c658f8	2026-03-26	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
36337ea7-d1c3-41e3-8268-1908a41963cc	TRK-SL-00030	68519d347add4fdfcacf04e40a4c1e58c6391bfb84358c0c8c5d8715fd5b61b1	2025-11-03	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
0d75b21d-6d1b-4501-b11e-d81cb1accd6a	TRK-SL-00031	b70bb41822dfb042cd7fa44f2c0a385eca1e0efbed01f17a053514b981bc037c	2026-03-27	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
04175929-414b-46cd-b3a6-41b3cff34165	TRK-SL-00032	f82be26e4b3ea713385d6d7ff7e71230cafb1ab8c45d837f0ab79db6238e92fa	2026-04-03	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
e6e38404-b3c1-42b9-8258-52018ac73fb3	TRK-SL-00033	a3ebcc661861f05ee88d7662768e70cf2e7abd7850d6c668316822c19de545a6	2025-12-26	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
d7ed0fd2-6e1c-491c-b2fe-0346976e6a0a	TRK-SL-00034	72352ac9f56c5557c4319b47bd59c9a95d6e6f31e670aaec1fd87dce3697202d	2025-12-03	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
15446498-1336-4d85-acba-c3b659e60aed	TRK-SL-00035	3c31c1da89724d0c8a8551d896af90369d86482ba73ed2109dbb9283849778c4	2025-05-09	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
035fa665-ed8d-4ad4-ba80-4c99b5730296	TRK-SL-00036	3cceeacc049e844baf4c448b96abfe8ad7e65050892e6ad4617ec9aef421ac87	2025-07-13	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
545c2aeb-24c2-4e7d-acad-2359af8b5848	TRK-SL-00037	eb26eb7f0271a7b4b04cb6f683c0ece73a96f1a74f2e0fd1ffc2f49cddc71093	2025-10-04	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
4351bc93-1925-426b-ace1-9522dca82ca7	TRK-SL-00038	d41ccd5048000780fcaae70dea1a0b87600315dec5987b488e74f7edeba6721b	2025-06-08	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
910d1532-1def-4d5b-a8b1-018be1fce00d	TRK-SL-00039	5644658a42a0c07f4c850514e7ad581e881b6ece65e4c33041a5964c8f1f8ca7	2026-01-18	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
2cc5beb0-74da-4a38-8a52-404b7ecc1f54	TRK-SL-00040	6c3ea17f6032da112d668d5dafc9f1aa135d34f59b0505c7f8ac150eac6d6b45	2025-10-30	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
56a19934-f8a1-42fe-9d3f-693746c65293	TRK-SL-00041	d225c33be97b774a74e39870a80af7abe0b58fc8bbab65320760b8d12415c2b7	2026-02-02	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
610aefd4-4853-4731-86b7-66dd435147ab	TRK-SL-00042	a67ed14355ba7a496252906461803f9f667f6df39f4141db7dd9d2c4c1ab68b8	2025-10-02	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
ccdf220a-5072-4e4a-9320-a7c84489ca5e	TRK-SL-00043	f134d3863d9eee866be80283fad6dcc1c34e98d42f63c24411e542b0fffd92e1	2025-11-01	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
22497b2b-45a9-4a8e-b93e-e04def7c49d5	TRK-SL-00044	7e461d998aed1838cc57a19a12ae081daf864bacdc2e372a256ca16e3b09b0d6	2026-01-28	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
116b95ab-2e4a-46dc-8545-5d0c994c54e7	TRK-SL-00045	3352ae226e03a43503edf8309465e0932521beaaf20045b5392dbd1491239559	2025-12-02	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
1f839300-76d6-4a6d-be86-c9c8e4502d0a	TRK-SL-00046	dd157d35aa54b43cc1fec93184d9a743d8c9c03240ab03a40e1fff9754196f4e	2025-07-24	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
3e782069-6057-4a4f-b368-d3f5f86516c3	TRK-SL-00047	19508122307d52e11a0612b67cf20c083c101a43f439f09a2dbf95f5330b1e7a	2026-01-03	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
cc5fdd1d-f448-4e68-b044-23f1b3dc8daa	TRK-SL-00048	594f16f2e1185c53cb366a7d6c28ddcc8abeceb57916d1dd3a385add286e1105	2025-05-15	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
acec54f1-e49e-42e6-935b-b26d28b098aa	TRK-SL-00049	ec211f740a73aa5060e8bd8b6c3a0085e5e764d5fe0da712d77e8e38cd3b705c	2025-05-24	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
fd830456-cb36-4beb-8161-88ff43e7f92c	TRK-SL-00050	b5eeb447df5b395bdcc8aba1c50f88c9d152b27f0b0a27176da199c7c2b47f33	2025-09-21	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
96a9f321-f1b1-47d6-9c6c-2d33907463c4	TRK-SL-00051	8e3da56754096e66c8c92fff72b7d6bae4d6a2714690898cb696393bb33b0768	2026-02-15	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
2c70372c-3784-401b-bc3c-af284221d946	TRK-SL-00052	5b0a77885a41c640213afc77882ecd67b6115bc9cdab3a8dd755c2f4ab6be792	2025-12-29	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
59007c53-e041-47bd-843c-5c6bce7e6c42	TRK-SL-00053	d2fb956c4ddbebb71540632a1e231bd0c885d72fa307a3cc3dbbc5da8c8f96c5	2026-02-14	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
6b1a0963-4744-41af-9cab-142d5c1d6087	TRK-SL-00054	e3fc36d2040b7a83fcfd7f9f8cd9bdb78d0c1ce25ebf29ea69079f6527b27882	2025-09-15	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
ec990a4f-b222-4265-bcbf-d74d7e4e26b6	TRK-SL-00055	1306cf3b0ff1dcfc6b479f069c8ea75e10fc54826122ef975ebc56dfbb9c47c4	2026-02-16	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
21de8142-93e0-466e-b8d4-01c2d3af0f4a	TRK-SL-00056	65d3b3736537a3a30e4c7d965c2d724d445d2818a36a59b87a565e3bbb93d057	2026-02-05	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
fe9cca41-c237-4f8e-b580-3f74d12c48b3	TRK-SL-00057	5dfdc21601e9a41695d2c49a48d63970a2ed47c04bef76065e4e01ef64295b7c	2025-08-06	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
1ebfd472-6748-4e1f-9b10-dce2dc962a64	TRK-SL-00058	3d3e435cb0700e9e379fc7a26fd050ea71c114976486448830db368ab2cea896	2025-10-11	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
c0d8c348-3d88-4f8d-8a7e-82c15aff67ab	TRK-SL-00059	113323cf2539f9f2aca7e3eda01626f90e9e2cf59e63e666ced86ddc977321c7	2026-02-18	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
caa25511-0e22-44d5-986b-8771e30ad343	TRK-SL-00060	ad3fa5834e15819962370dc84e98ab7d4aec1971bec6f65e5e9cb71fe30ea321	2025-05-29	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
38a6c8d4-4a4c-4874-b20a-840f533f9996	TRK-SL-00061	6d30c97637a440e27c3cafa83d177a1333018bb01912f6020ab0d9e6e44a1a85	2025-08-01	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
27ee3a4e-f087-4690-ba62-3a3f9acecac7	TRK-SL-00062	2298fbbc168ff216c45f13451cffa8305d86c6e10fcd0853bb1e6a7f8c62b1e4	2026-02-03	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
c5a77c8f-6600-4257-a309-da84a5a75261	TRK-SL-00063	8e4af3af1347f8329aa99cd239f2c88f3814ffe7362542da20721d74013831f6	2025-12-13	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
de1b41cc-09ae-4a7e-819a-3ea7c4121aa5	TRK-SL-00064	995ed1ac59a3c419a624af4f700586ce12d173cbda32de97f8ea02bbd0c4261f	2025-12-03	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
c24a2ac8-aeba-40a0-a434-7beff37d7309	TRK-SL-00065	703c03a1c71a756a5887070a675a59b8d1e5a396a1c2df545083a5f9452a838c	2025-06-06	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
bd521e0b-6590-4674-a486-df629edd70ef	TRK-SL-00066	8ff78b0302a08b1cd2f56308cb1cec9ec6abd879b4a3ac93b286d117afc9ef1a	2025-07-14	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
818d38cf-3576-4c31-b9a8-820e42ae117f	TRK-SL-00067	e9651da57624f930aafc5a01e78e5a8d15d5be92b89e129145a01da425f7d3a9	2026-02-26	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
01b3e725-c391-443f-b0cf-377b53403124	TRK-SL-00068	378453ad2e7d4d05b6e601712fabd740746c80d0c5f35b288dfdce1c9af82d62	2026-03-06	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
79c2c40a-8f0b-4de5-a3bf-dc3f917e40fd	TRK-SL-00069	ebf8124d98cd3615f5fa1bc656e6ecf4346a04985f6a24fd8877f77f35ac13de	2025-12-09	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
610118f4-dce8-409e-9b84-37c5a125fd5b	TRK-SL-00070	0be24ab054df8ad3cd0983a9ed03aec56a4f3cc404ec41634dd543f397a031a8	2025-10-26	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
da529d7c-f732-4a60-9328-70ebf8db1a32	TRK-SL-00071	3a5824c49d5ec04868bcfa9125a6efa1f2a0bb68b75aabf7350d188687c97001	2025-10-02	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
28dedf3e-72ac-42f9-9295-f4c13a8dbcc6	TRK-SL-00072	641fac1cd6f199c5a3f271896528adb3300dcc4ccf17b6e38d0d92040dff3538	2025-11-19	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
d8910789-098c-4720-8729-6ba4778b1dbb	TRK-SL-00073	2a3332186475f1a69fcd34313f7a2c4f43a31afc6b7544a3c9d264205a01874b	2025-11-15	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
69f2d820-7093-40a7-a9c2-067d398fead1	TRK-SL-00074	5aa0631c9ce420d902e3a01b78beb443523223af31f7983a0ff09b3730a26fdb	2026-04-19	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
977bd81b-c1aa-46ad-bdb1-0e5a19291104	TRK-SL-00075	adf516a8a7ea5dedd07f00b252c2c2452f587645823a4cf3886cf8032588f054	2025-12-02	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
f3432648-ee15-4cd1-88dc-d603ff924dc6	TRK-SL-00076	d10e03a783b3fc349b8cd4b14e40b9e34e90a2cff4fa596decb25d8113bf9cd9	2025-10-20	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
60a957c2-13c0-4688-9933-0e423ef0cb19	TRK-SL-00077	84fd63a18a945c2514a425288c0f849fcb81ace313386935f1716e145ab54ad9	2025-08-15	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
9410a4e5-e2e9-4441-ad76-ee568d21ccc7	TRK-SL-00078	5cbf6d1e9e51b8fa69215e62cab8128bd7017e2735cb6994e4802b4fddd92589	2025-06-11	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
5a77f2eb-fcab-42f9-8c68-cb7aa8ead458	TRK-SL-00079	22085386161bf4551a9e137acd79723e5a5b7ddaa59182c5f1f7da1047079d1b	2025-09-12	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
7e99dbbc-e163-4810-b89e-5f35c7073252	TRK-SL-00080	ae929f13c553183d2dbcb4da458a0d290d2b09509f960f50ec045ad7ed1e1d3a	2025-10-03	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
242dae6e-1bea-41cf-80fb-39006708e9f1	TRK-SL-00081	e0d9c11f7bbbf6af749dfba2b8a9b505faa100c79225c45828027e39b4bf368f	2026-01-09	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
2af9a107-70c8-49ff-ad43-cc9756618eb1	TRK-SL-00082	7d85bdd082cc1ddbc5655285304d697b35c79eaf487b566d824b7ace9e37e8d3	2025-07-10	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
d2b13ff4-2eed-488a-b1d5-26e4c2c55713	TRK-SL-00083	6e920e7fb8e4a9cdd7b44ee302e4bab90d41459d30cbbabbc5ce60c28838f87c	2026-01-20	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
0a9f48f5-6368-4024-87f2-31bfefa98773	TRK-SL-00084	802754c8a80e9bcf803f580997fdef07d8035cd3c9ea81036f8df81e1385ce9e	2025-05-05	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
3889a5a7-2edf-4c30-a8fd-1adb10dbea34	TRK-SL-00085	6a660f907c3e68bf04ff7a11b1da22eb9853d48e164a56c104dc8d4430daba42	2026-03-23	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
de9b4097-d816-4e4c-82df-fd7ed62ae0c5	TRK-SL-00086	bb009b86a7219de4a94edcf281cc193310ea552b5ebbeb0110cabe7c8f2f4a47	2025-10-11	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
d5143086-e98c-4e6d-851a-927a9e44bc7e	TRK-SL-00087	99df0bbc8d0ecc7881fc05fc33d957a56caec2b3cda7248a5910bc2714ae4a7c	2025-08-21	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
5b2fef93-9ba1-4a60-a25f-dd9effe6a000	TRK-SL-00088	3f0ecefbebfd17c17756fb091c7aa11c94311ab3374acc74c10a0937eec904b9	2025-12-03	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
c1e94af5-9696-43dd-b7b6-924158fa6c4d	TRK-SL-00089	9678d2d48e753e01f87be74aef01729ffb6c9257d50c5a02b23dc71b02612794	2025-09-05	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
d6c14301-a67a-4804-aff9-d898272f9154	TRK-SL-00090	5ffdf090a52b7ed2dbe800e8bffc93ba51856a3fa982f03538b39c3d8008a2c5	2026-03-02	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
789c4623-46c1-4504-94b2-f1dde0f48306	TRK-SL-00091	ac97de6f7742775cae77932dd4de1c142da91b557e55c155c54c780004e41300	2025-08-02	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
fcfae0ae-8363-473b-b8fd-5a85393a8af6	TRK-SL-00092	bd7b2d03ec62393256fb526e4ea1fb4663d3d35976a06f52d19d916dc17c344b	2025-08-22	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
d3a3892b-7670-4e24-a32f-27c8332a4243	TRK-SL-00093	5f7d78ddedb5ada3f796900432385f0565918f772dd9039a747ff8d0123b349d	2026-01-17	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
97ef07d3-881e-4b17-8cfb-8c730e38ab68	TRK-SL-00094	d159cea1c9ae67be7bfd5a8c71baa095f596e61e430fb07f1573e7fda9f08ef9	2025-10-24	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
2e555318-b63d-44b2-84f9-a72191a1042e	TRK-SL-00095	37eacec64dc649b3c2d052457510a96719431ff842cd255f9444e8e06a117099	2026-04-18	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
c36906a2-1f85-416c-9990-192b85b5f8c8	TRK-SL-00096	181a69945fc9e1a897b8b1a1076a1600e9b137d809e65e7a14360de393bf1876	2025-05-20	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
0935c6e8-5831-41d2-8e0d-9eab30c2d08d	TRK-SL-00097	1573a1d73740b0efa006f4233e9fd5ed8e83d14a79b8e5dff746f81d3f91a941	2025-08-23	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
a359fed1-6146-4ec8-b84a-daeda93536df	TRK-SL-00098	343dd76d06bcebe44244ecd9e779d9969db5ef4809a2142954480069b34bac43	2026-02-14	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
c8d0cf43-f0df-49f9-bcbc-2ebe117b1533	TRK-SL-00099	2a6b4197379df28c095e130aa148526bdf7e14e7ad37172bec6f38d5a24d79bb	2025-09-17	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
23ac3055-b384-41c5-8d26-0e4313821a23	TRK-SL-00100	d31c78e4a280e1b820859dbe3ca47ae0f55148f8e9bc23e42abf5caa2989de4f	2025-09-16	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
fe640f68-4e75-4b6e-bcf9-03528bdc0ef4	TRK-SL-00101	5ca3ccf4fd689be671cca5b2517458e4147f1cc9e074a71ccbf4b83858a1f3d0	2025-09-04	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
bd161d57-ac4b-4e28-8190-98290843e1a2	TRK-SL-00102	88b16a6f139859ddb4af4a87b2447019099b415ed388c25205ae77bbff9b8aed	2025-05-22	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
d332ad49-c8e4-48e5-a1b9-9fb28c78327d	TRK-SL-00103	3541bc7275395873e93461578528dcea8ad85428836bdf3efce7d6bc179aff2f	2025-12-31	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
e678b9cf-d267-49e8-91b8-4d36455f9895	TRK-SL-00104	74f81a3c88636245eab4b8fab7e20aada94d7ef32af9a59e8bbb27a639018262	2026-04-22	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
efbb51ac-f60f-48be-bef9-0ef09e1cf36d	TRK-SL-00105	73353ffab84fc8863f4a15c49b3d92911a01fd9854e654a95578ea35cd771e18	2025-09-27	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
886e9c0b-ef8b-4dde-b2de-f1d0d96f2e2b	TRK-SL-00106	71c9c8db56523d82f785cfe9816609298248b0671f9a3f1cd6219c044c72be15	2026-02-06	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
aa751928-af9f-4ee4-b51a-1cd061e9b744	TRK-SL-00107	28d812baca283e4f9a5480599ef670121eda0f577813b1f53a78c1aecdf89106	2025-12-11	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
4e9f32ad-148f-456e-b6b5-3e9be728e1c1	TRK-SL-00108	553e524500658f0b046dc0fe2c502c2b4451ab7b0508e79cbf5b0dd0ebc26d23	2026-03-27	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
dfa1c955-58e4-4669-ad30-ee77621d03e8	TRK-SL-00109	59a2ae4deae73e7a64aef6f82b43bfcbc117adec3128efa4c03d0395b26e07bc	2026-01-15	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
e2fd93a7-2713-4cb0-ab85-563f437c5787	TRK-SL-00110	9586b2e6124690a5a8d87322792e29cb7e9e1751f40665941ee3f3d35be2de7a	2025-10-18	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
7853da2b-21d7-4e49-af9e-25f2219422d4	TRK-SL-00111	429755562f21f3917a9f8d26e7a7856b8344195b74f27ce95ed5b749ed66886c	2025-10-19	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
25133fbc-a896-44a7-a645-477118d602c1	TRK-SL-00112	147fcc6cee4ddd3369987810daba8010d6d2f91d0174322d00386559f79c0cb8	2026-04-04	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
eadaddfd-d567-484f-a9ed-d80a1ee5b312	TRK-SL-00113	2e971cbd30a14f6546d623152b6c37d96f11ca39ce2ddcabd7315b6d73fd6210	2025-05-12	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
93b394bc-bbab-4b3b-ac4c-8f9d66901704	TRK-SL-00114	007b1a9bead49a79f1f423813f267687d2693c2bd63cb28a4b40c4e6a433a8ff	2026-01-04	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
26366306-2fe4-482d-ada4-206630795dca	TRK-SL-00115	f4182ed6062751a4d4348797082e080d28a778d96e3075538560f9e6bacb488c	2025-09-16	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
536f0ce0-defe-4584-b9f0-c7b13535cc72	TRK-SL-00116	8f96dca313fe4fffb2a6175b9e27706f3a6039e53386b530a553b4bf2782a4e7	2025-05-01	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
d9c62518-4c03-455d-9738-43f149991b8b	TRK-SL-00117	fd57cd25c326ca1082989e9a797d9868ef990545409c1e3165a016490ffe0da4	2025-12-18	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
2990e87b-8411-46f0-8668-326e55e981d8	TRK-SL-00118	b7af83bedaa9d7600f1a931fcef322e4c3779ddb6e78ec62d862530c1d054655	2025-05-24	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
84e1116c-bff2-4f88-9b2c-43c50bd26ad4	TRK-SL-00119	a3bc4649fa80c33ece205f6a17552c452b816d093013c4fd6dcae62cd18350fa	2025-05-19	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
1ddc385d-5510-4ba3-bb9c-4c1a2193bbdc	TRK-SL-00120	a32c808523247b7bd38f523c4fbc37e5c460a0d7ca18e402de3f751a50e8d1e0	2025-10-15	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
d4b52cbc-9dce-4bd5-b6f8-c65a49905f0a	TRK-SL-00121	85897c62066a999cb02b0d1b6df102b4f59d65c5d4ea5ec19551977f168e7f92	2025-06-18	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
f96e3763-2062-460f-b949-3e3496123e07	TRK-SL-00122	1f350043a942c3c885b2a12c7330c49bbcb4233b34534a4cabf014dc5819a852	2025-06-29	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
29572832-e83d-43c2-ad0e-b5e5118c0cad	TRK-SL-00123	c28eda9d7284f2271f02cc3ce65f1d94cec44d4667a33efe559878e1cf33f2cd	2025-06-01	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
7295535d-eeff-44db-b9b3-637f4de3d384	TRK-SL-00124	69f61aa3fe9ee38ae9ddf273e7c16efb64bdd6b1f73204a64762218825059312	2025-05-27	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
1283c95a-cf06-47d7-a46f-865d5cdf6047	TRK-SL-00125	caf56e00c3e3cc9b842c3d9c756d0ab6b81d707c90f4e5e4673ebc78e82b72e5	2026-02-08	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
1230be6e-4711-4718-8f45-183330faf394	TRK-SL-00126	65d869748f98229dded08d1a0eaa088019ebac74acea073b46cc4da9cc1fc482	2025-10-26	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
51abe37c-40fc-4761-9830-ba46501cc6aa	TRK-SL-00127	77c0f093dc47738560e1640c14aab1d29947484654b720cecb4683867a763e48	2025-10-30	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
8b2d8f86-3753-4919-ac3e-50df82cb2bd4	TRK-SL-00128	807103632046e663265c81cf480aa966bd0a2674dc5eebbd3a79830bea294bd3	2025-06-11	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
a5d48693-0456-4f22-881f-a6fdd0106133	TRK-SL-00129	de6bcfdda2424e942b5535926122aac34948ed3b9adeaf3565afdb089acfaf60	2026-02-03	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
29d1e5de-0e34-438f-a1cb-ee642c0e1d69	TRK-SL-00130	8b8bf42b8a738532612b019975094cc3638be1782ca729d5ab3a2aa9121a86f7	2025-05-09	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
a461261d-ae0d-4e13-8a83-70e71852a970	TRK-SL-00131	ec8b01f2ddb37571df0c3fb278b2ceda4a48f2915c2d12a9f20528627feea2ad	2026-02-18	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
f6eab525-83d4-4429-b8fd-33abf64b3b68	TRK-SL-00132	c15ff78790c71fdd1f8ed47c8fc3215133a439d402204145d82e2e135aafe6f3	2026-02-28	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
ee9d9c65-6ffb-4160-8284-1839a4c0393f	TRK-SL-00133	6d645812d89ae3fc091da0baabc54aa5ef59c07b2c83922eb319a1cd0af66560	2025-09-19	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
e3b8088e-8bc6-4272-9bbd-4a59bec3a783	TRK-SL-00134	6161e69b12d1a8777241be5476fb6f1572a9d850aae396a33d9d90fed0d7f30c	2025-12-25	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
f5657bba-f5d3-43e2-9d87-3f2ff2cf4952	TRK-SL-00135	b6ff5b4cdaa7bbdca17339f6ae75d12f5b2b7c58d779dbcbe63dafefa475553f	2025-12-24	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
a2fa64ac-1780-404c-9128-e03f2445d69a	TRK-SL-00136	12398781cc5fc8b9efff4ec57637293a16afe52260e4c6d921e1bc59d8d15f0d	2026-02-23	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
8f8f5410-7aa5-4778-a81d-b581f25a6057	TRK-SL-00137	2377465205f11585642af0719bf0ddb6ab35fba4e5268a0435d1bc99d7be57c2	2025-08-03	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
10193f12-4b79-414c-804a-0ff4a6363f12	TRK-SL-00138	96a5a0080be15f1ea1c01a0913334435090256c4684a2c342749bd666e9c2f2c	2025-05-27	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
ad6db971-ca6e-4bda-9b80-a9377df6d0e2	TRK-SL-00139	fc83ebd4058dafccd53d6ec41005701ae7c676600ca998a7785122e1908c0a26	2025-06-13	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
63d72cc4-5b4f-40c4-9303-983cb00f87cf	TRK-SL-00140	764736591638f40a8050793514f30a6859739201c35a0b74fb65587c1f8c79ba	2025-12-20	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
188b2371-3b90-4877-89b7-a39972bcfbef	TRK-SL-00141	0e96a1c3f5bce7714c86e4da356bdff593001ee10888f6a1c705f96484a5efe6	2026-02-11	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
a433ce1e-544f-4f5a-8fc9-cceb4ba90f57	TRK-SL-00142	bc6c48546f24c84d6726c8d2c3f4b7e9793d5d3d4d4a9243f924f393f34d6c47	2025-09-16	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
ca32b681-be4d-4bc0-a222-53fb5aaab0a1	TRK-SL-00143	afb10f9a666b750705d8d89c2864e3966fbd9e4192e2ce834dd79765e50b70be	2026-02-25	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
e948a2e5-608d-4aa8-a1b8-6c8ee35f6603	TRK-SL-00144	eef66ea0f7cb71f482c307584dcb191ef47bd4b9a6d3a02dfab756bd2234c73a	2025-08-14	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
a95936d0-1af9-4b66-b439-4868f3a2d51e	TRK-SL-00145	85f069b180bce018f93350e3ed19a6b7f45fbc19cc6b92c6b9cdf100957e4df7	2026-01-05	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
5ba3a5a9-71dc-4bd2-a523-0d31d3e71c6e	TRK-SL-00146	28a3d969d51f604938950ed4bcb3dd2cb79ed1fbb50cfbd77fa15942d5e9e242	2025-08-28	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
1620c5eb-97d6-4e01-ba8c-ec41958269f9	TRK-SL-00147	6b71ace6d7af64a507da39bde925c2938a1f75abfdb96596338972070073a180	2026-03-07	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
2925aa8d-0982-49a0-8928-ac94ccca0949	TRK-SL-00148	e680448eb64333af1b209efbe96d76a0e2d0d63daa384385f183cb01b4236b56	2026-02-18	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
82535d38-b657-41fe-b894-b22af55dee24	TRK-SL-00149	b2a431420b3ffb7cb2e5e83519cfaca521bfc378c81dce61770b60afb168431c	2026-03-07	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
9c238062-a527-45a5-8df2-b2167cf5bc7a	TRK-SL-00150	694a200882bbd465f017e1e910e911457b78871298cca7547c99e06c512bc8a7	2026-03-23	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
a89b3d3e-9ea1-4cec-aab5-9de7d43de390	TRK-SL-00151	01cfa0d9d4360dc4089daf4a39eabba353a2ec3fb7fb718ed3a1d0a1131b3f0d	2025-05-07	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
b3400ec8-0ea2-473a-a281-a618ffe8849b	TRK-SL-00152	91097e75b750b115d7c61bf9bc26a8b49fefbaaddf76fd5db47c5cfd9c2aaa31	2025-09-25	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
2d4c5123-a912-49ad-a9a1-0b0d5c9b4831	TRK-SL-00153	176f2745c45789ec0ccd4c8fdbb5301e3a5b63a1ac3a9607931052a827ebf6b8	2025-07-03	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
fae27ede-ceb9-4cee-b4aa-17b23b56623a	TRK-SL-00154	e1fd48c3e6cab936012ff5cf563802a96b435280f6559fb9024da5573928e2de	2026-03-06	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
18717aad-2c45-471e-9d32-a90d359809d8	TRK-SL-00155	6561af1f67ef7a2a9116c5cacd5999ff183458f025c9f773c570f650fb597158	2025-08-14	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
f052b81d-d705-434f-9d50-78104c8622d3	TRK-SL-00156	2e141d582a30af17b8b9246cd4a5cf0077430b25c6cb3eb8d73b9074d5c6da0d	2025-07-08	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
a6755b7c-6a83-468a-9c45-a9e19ab0ca54	TRK-SL-00157	eb901aeac1877d0f8a304f9be57121c60dc3270f1ddd593600764c6077172a67	2025-09-05	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
db112d9c-ed83-4de0-8027-d7a8cb5cd1bc	TRK-SL-00158	845244e28fc51e78c0865605f0f8b7cf8c3fa9eb8b5fff771ced59cbbf89c55d	2025-08-16	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
982a88ea-5cdc-4e84-b476-1c9146a1cba1	TRK-SL-00159	2b7c5069ee6c1ceff9702956f2479ed56d89b95ba7d42cceb06a9eda97f5d44d	2025-04-30	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
3db00920-626c-420d-8bf5-cfb24e5bb61c	TRK-SL-00160	385fa738b4bcc3b67e03aac76ee863cbd7bf4330191127cfa4e6c3597ff1ac68	2026-04-08	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
a48f9b6e-7d94-4f3f-872f-d5f27d99fd52	TRK-SL-00161	9174c041f8414f41e34e1d46824281f0745d7b877103a74f630dd97d69afad84	2026-03-01	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
f0f2154b-c194-43cb-9c56-727683b23509	TRK-SL-00162	4658a901314426b9ea01a1cc657c7f7fbaf128aab050f9598d8d97d2b446a2a5	2025-11-28	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
58b78b3e-d7ee-44f7-a774-c4cb33941a95	TRK-SL-00163	ffed52f7041d7fc7ed39ef6eb2b25c349ef4ef2af8898c41a23d344f19fe52d5	2025-07-05	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
ab2bdf81-0e9b-4ca0-99e4-b1e64507db60	TRK-SL-00164	93f9fd3114832badb47d560e377b66e5f9abc884d75ecc7efb102b64c27efa4f	2026-01-15	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
8706dec4-7afd-4651-a12c-5b21985197bb	TRK-SL-00165	9d19a26f27fe3331153f0593954aee98bfe8306588bc744f9e980a0de9509543	2025-07-18	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
f569076c-8b7b-4190-8118-2cc43abe5f2a	TRK-SL-00166	8ef8885ed7c9d7e115516fa773bc49b9ddcfa70213c1becc4721479583b07995	2025-12-13	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
0b78bab5-5201-4b66-9a68-ab3ef633843b	TRK-SL-00167	036f3967358a84e5bdafe1e475d61f41f6b3226022ea22a87a9fad91b9ba237c	2026-01-21	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
b88ab023-96bb-4ac1-8d93-08b751ce592f	TRK-SL-00168	fcb09e3cb19d3012453e86e14bc0dab68f9c0e38b24dbda7405b9d90dca2ff92	2026-01-05	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
9bae228b-0cc7-413e-82f2-0a90cb05b164	TRK-SL-00169	f8d415e102c6c16bac685a99802435a11ac47f414caf58348a3a5f32f37a579f	2025-12-10	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
c4330e64-aa7f-4d13-bdcd-9775c120d9b0	TRK-SL-00170	645e8d9508841bf09bb617beb6615bfcaab50d36f394bd9b163d1087f5dc7113	2025-07-16	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
84a7bdd1-3047-462d-b860-89a6f259885f	TRK-SL-00171	795afcbcf65ded421865d06b177336411860797146c6e099c89fb91b7012e201	2026-01-20	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
025b258b-47ee-46bb-9163-aca3eed50160	TRK-SL-00172	3816c1124d7309f367b1c79a6cb88618545394716bbbb8d497838d702eaa6add	2025-12-13	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
277a6632-1dd7-44df-bb84-b4016795f145	TRK-SL-00173	6358b223217ee4c525562fdaa1483140c3c50dd38072ecca6dc0fa68b3e9a38f	2025-09-05	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
9066eb94-d3ff-412a-bc2c-8f821e696cb6	TRK-SL-00174	69ddcd9e57fdadf6f96d45fdd600c943e0ec4dd10959f7a7d43a6a020a1f9bcf	2025-07-17	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
7b10e422-2dc8-4ff5-a46b-17e9dee3ab21	TRK-SL-00175	2b7f78499fcedb66142e0f621c773d80856d8ff05546f3c3151a6c57a17348dc	2026-04-05	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
100af612-e02d-47cb-900d-ba94831f7d20	TRK-SL-00176	60a4e566c3e0dd009ffbfbf2efef6ccb74d7b07e879c6c3236c6a195de0fa30e	2025-10-12	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
f556f730-e494-44ef-bda6-e1d4ebb580fb	TRK-SL-00177	bebba5aa53c2ff0124813e56700dbbf6227dca2b35713536d7600d4d6bc5825d	2025-09-11	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
6483c3ea-afa4-4d0b-8686-7f11bbafce30	TRK-SL-00178	6a579f6f97438abf117a333902ea26cf6117f27380eb0cadd876bc8c1e384f3b	2026-03-03	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
092325eb-0a76-441a-9e4f-25848a9f5a8a	TRK-SL-00179	3f86b47dd798f050ad2eb0732b64ce23ad1ee484baad69a82053f7a36ae9caaa	2026-03-11	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
f7019fc3-d156-4821-bd97-ed396d09cf38	TRK-SL-00180	406fc0de49cbb3e55003ec2fb999412967bacbc566cd8a3f87e408191204c71c	2025-12-25	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
79729dae-c482-41b2-b54d-6d4c14555fb7	TRK-SL-00181	8e9b67a1eaf1216688cc1f8dff53fc5021bd46ae67225744cb23018dff98fecf	2025-12-13	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
c071febf-0b25-4b8a-a126-8212ce0f9f99	TRK-SL-00182	e51b185b3d24ef409575fdffe39bff2e105639487e7471a5b1683a002d4da857	2026-02-02	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
8ad7a164-1688-4a4e-a4a0-ef183ae17e46	TRK-SL-00183	05a872df2292208729757f31219e1b616a8567278d7c3c98bbe9721dd790d348	2025-07-31	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
ce883bd4-b01d-4ac5-be0b-f2356823c102	TRK-SL-00184	e6b9137d87f2255d738291cd0d8f40912ce9d6c866d0c929d5352c4beaf8ca8a	2026-03-21	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
e073632d-aac8-4cb8-8d1e-7716a516081e	TRK-SL-00185	b1ee4fbe04c7dbae8369f6b4905fa77943c90a941a0df30c06fd30cd050757c4	2025-11-03	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
30fdb417-2a57-40e6-ac8a-61a9d1160640	TRK-SL-00186	12dc90c2816de9bc967ab8a51e02f2095881af98e27f8207b6a08f894658c0d5	2025-05-16	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
142476b4-3208-4de8-a591-ef3e1f8e4e6b	TRK-SL-00187	6efefe239a9cd478f9c8adc7fcaa19a645353d77e739c9cfc3568253204a4fd2	2025-10-12	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
74869bfe-64f8-48e1-9ae3-d923ab85d8c7	TRK-SL-00188	f9601bcb2c5817c45fab2f1100a93d7516e5591fcb348f11f263e694625eadee	2026-01-28	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
35a6757d-f3ce-4eb2-9d45-22c4ebd7061b	TRK-SL-00189	f4249af1c9016ddb870374343ebf7b2e51bc066bf8a99809280012b34dd49486	2025-09-02	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
6aa2e93c-6b18-4a22-91c5-627f22e0b9ed	TRK-SL-00190	056065f47d28f23934d642a47e48724dc54a7512490302e9b21674d962c7e619	2025-07-04	ACTIVE	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
9d6d04b4-b9a5-4e56-a466-f41336013575	TRK-SL-00191	f405c846fd693ab727c6a4bd245dd525a08a45a567300db6f7b112180795e1dd	2026-04-15	UNDER_REPAIR	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
f6c17e3d-11d5-4464-9f4f-fe34060738cc	TRK-SL-00192	e80332d595b961a4ee05a6d01cbf82378e3d36205320a605c7c8c916d9d86f7e	2025-06-04	UNDER_REPAIR	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
72a2a688-0618-4b1b-a92d-e59ff30cb21a	TRK-SL-00193	2295b7ea24a53328ddf01a3d49961fd7fa589cc3183566d839bf9058e40f305f	2025-10-03	UNDER_REPAIR	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
ff1e394a-bfc1-4624-bb34-f5fb67131644	TRK-SL-00194	9d96fc9314276e3116869668fe3b8da2af384f56c6c6339dee06fa0f63108fef	2026-03-11	UNDER_REPAIR	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
565405f9-b651-442d-bb2f-877f576dca5f	TRK-SL-00195	260d2e4b43bfc3707d5f5079824ed9cce5ad67f6b493209d4e5afc8470b9f7c8	2025-12-21	UNDER_REPAIR	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
1f31e6ae-de9e-419b-8212-56a9e0907a87	TRK-SL-00196	8df214b68de6c6e6e278b4cd01fb457e6a748ffeb032e19f14a3e33cff2160cd	2025-10-29	UNDER_REPAIR	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
6aa2475b-1c29-489e-8e1a-6e40c0d86135	TRK-SL-00197	8d207d921f362c0207be1782819957b355cca0807c2a52c94e899fd28497d141	2025-05-15	UNDER_REPAIR	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
8666d470-5182-403f-89fd-e8c7f5a4541d	TRK-SL-00198	a480352cf64590d6c3b48623b241c4a2bb3ca711777865fffeefd7c78f1bb036	2025-10-06	UNDER_REPAIR	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
9be3c524-a332-4aa8-8b66-205ccfff36a1	TRK-SL-00199	75d10d229d2dcb8876e847358aeeac1ff615c875e0d9cf43b2b54c4e4ffee7d2	2026-02-09	UNDER_REPAIR	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
8cf5707e-6a8c-4560-a872-4a0dc44d5c82	TRK-SL-00200	bfeb4322714849af597af8f1c3f07572fe573db960ed2d4054b2a07a93f11091	2025-09-27	UNDER_REPAIR	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
bd2101cc-01e3-4bbb-b8df-571dafb3e017	TRK-SL-00201	4ea4d18ff598f4d2c00fa2e9387c643e7abdffad847b67c78110b12b5ce2411b	2026-03-04	UNDER_REPAIR	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
47e3a420-cb71-43c4-83ba-326aad5f0330	TRK-SL-00202	9854bfbff0b91ab4d4c645017d9f421dfec59a56fec9da3ab481e519978ca811	2025-05-05	UNDER_REPAIR	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
4f3ba802-9390-4466-a2e1-5b3a59a18a85	TRK-SL-00203	f73f2ea3ccc5d7df19bc9bfa6de8921ee5f48c1e059cf139665518b91384ffd5	2026-03-05	UNDER_REPAIR	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
5640cc2f-e591-434a-be5f-298a4df41da5	TRK-SL-00204	acaabe20978d0a1b14e3cfa6186987ab5a623eeab2a28f1359ec5789219bd9ff	2025-05-21	UNDER_REPAIR	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
6d9f4685-aacb-43f5-8d2b-1781e9166da7	TRK-SL-00205	c3e2fa9effe9a9a5c3a53498fb4f450d27451e2c3d842c85a437845026833611	2026-02-16	UNDER_REPAIR	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
63d24ca1-9b0e-4911-9865-fdf9b40044ac	TRK-SL-00206	bb1b786cfc93d4507535115fd3f36fb9c9781181fccfe30106572b21bf83bba3	2025-12-19	DECOMMISSIONED	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
061e0f1d-b8d2-4423-b98e-50e6f4bec098	TRK-SL-00207	4b850b16224743e281619119fd0e37430ce6b8e1cd62b77d4de88c30eb7c812f	2025-12-07	DECOMMISSIONED	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
140a538c-1975-4544-998c-085f00348777	TRK-SL-00208	799c21be5296be688cfd10a2fca2c628da2d74d1c8070e5490b9dfe39543769d	2026-04-14	DECOMMISSIONED	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
3f3497f6-77c6-4909-b2e5-0ffda63464e6	TRK-SL-00209	d084db9a6c0acf9dec458a1049651f8515c6386f4a86076d85692af58b1f3648	2025-05-22	DECOMMISSIONED	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
95f0a466-2a40-4e2b-8f32-3c7abedf5fd5	TRK-SL-00210	272ac2d3c68f3edc5442aa733e92d9e89d8a8a78c9805412f2f7c6256a4b0e0a	2025-08-05	DECOMMISSIONED	2026-04-25 07:58:34.875416+00	2026-04-25 07:58:34.875416+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.users (user_id, badge_number, password_hash, first_name, last_name, assigned_station_id, assigned_district_id, assigned_province_id, system_role, is_active, created_at, updated_at) FROM stdin;
2ba5c651-5ac9-4d02-baaf-4392bc6bdf86	SLP-00001	$2b$12$Y/FFRDrCL5Qx4aG4wg508O6eegTURbXfkJeIy99tLq1qOhd1bL2l2	Rohan	Perera	\N	\N	\N	SUPER_ADMIN	t	2026-04-25 07:51:03.081282+00	2026-04-25 07:51:03.081282+00
95565810-4c64-41f9-aa55-22a4098658b4	SLP-00002	$2b$12$Y/FFRDrCL5Qx4aG4wg508O6eegTURbXfkJeIy99tLq1qOhd1bL2l2	Nimal	Silva	\N	\N	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	PROVINCIAL_COMMANDER	t	2026-04-25 07:51:03.081282+00	2026-04-25 07:51:03.081282+00
0b7ef1de-f302-4ea7-ab23-b0eaddee88ce	SLP-00003	$2b$12$Y/FFRDrCL5Qx4aG4wg508O6eegTURbXfkJeIy99tLq1qOhd1bL2l2	Kamal	Fernando	\N	\N	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	PROVINCIAL_OFFICER	t	2026-04-25 07:51:03.081282+00	2026-04-25 07:51:03.081282+00
07c743d2-55da-4ee3-b764-7e8068254c1d	SLP-00004	$2b$12$Y/FFRDrCL5Qx4aG4wg508O6eegTURbXfkJeIy99tLq1qOhd1bL2l2	Sunil	Rajapaksa	\N	bb17281d-bf1c-4177-836f-4d3ad4ae672f	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	DISTRICT_COMMANDER	t	2026-04-25 07:51:03.081282+00	2026-04-25 07:51:03.081282+00
bb38f04e-069d-4f7b-84f0-35e286ecc59a	SLP-00005	$2b$12$Y/FFRDrCL5Qx4aG4wg508O6eegTURbXfkJeIy99tLq1qOhd1bL2l2	Priya	Jayawardena	926ffeac-51b5-45af-a752-594b07060db8	bb17281d-bf1c-4177-836f-4d3ad4ae672f	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	STATION_COMMANDER	t	2026-04-25 07:51:03.081282+00	2026-04-25 07:51:03.081282+00
fccca5de-5841-4e78-aa85-8ffd9684592f	SLP-00006	$2b$12$Y/FFRDrCL5Qx4aG4wg508O6eegTURbXfkJeIy99tLq1qOhd1bL2l2	Dilshan	Wickramasinghe	926ffeac-51b5-45af-a752-594b07060db8	bb17281d-bf1c-4177-836f-4d3ad4ae672f	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	STATION_OFFICER	t	2026-04-25 07:51:03.081282+00	2026-04-25 07:51:03.081282+00
9a47901f-f957-43b5-af45-814b946a385f	SLP-00007	$2b$12$Y/FFRDrCL5Qx4aG4wg508O6eegTURbXfkJeIy99tLq1qOhd1bL2l2	Chaminda	Bandara	\N	\N	\N	DATA_REGISTRAR	t	2026-04-25 07:51:03.081282+00	2026-04-25 07:51:03.081282+00
\.


--
-- Data for Name: vehicle_driver_assignments; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.vehicle_driver_assignments (assignment_id, vehicle_id, driver_id, assigned_date, returned_date, created_at) FROM stdin;
c2dc64aa-d47a-408f-b7b0-0ab065289d38	39a979c1-d773-49be-916b-d7781c5ab4cd	67df9b2c-2af1-43ac-9419-40567e84bb50	2026-02-12	\N	2026-04-25 08:51:39.137482+00
f8849ab7-5f26-4de6-8366-6db6d5823f5c	e2da2c69-bd58-4534-ac19-24e0dd53a90a	fc9b9ed5-08f6-40dc-baa9-ce36527029b0	2026-03-08	\N	2026-04-25 08:51:39.137482+00
4bc2c3c6-87f2-447e-b551-c80aa85c5259	b12170ed-2efb-46d1-9aaa-5e30ffd78019	98444881-f9ae-4b75-87ea-4ff4ec0e8b7c	2026-04-09	\N	2026-04-25 08:51:39.137482+00
5b30f561-4e92-48e2-a6eb-254fac2073d1	4a400233-a0f2-47d3-9ce0-22f66e50c1c4	b46284fb-a0d2-4987-bdc2-59e8bf552d75	2026-02-01	\N	2026-04-25 08:51:39.137482+00
e81c464f-bacd-4559-b862-f0a632e16742	e1bd303e-659a-403d-bc6f-5d540f2980bc	5db7e5cc-0be3-4eee-bb87-6414385ff31d	2025-11-07	\N	2026-04-25 08:51:39.137482+00
0d31ab83-b30f-430f-a21f-d5ab39ee1fb4	9c3a9923-69c3-479d-9ea0-aa198b280f69	c8f1e1ec-305f-4af4-9810-0cb4f9c094aa	2026-01-21	\N	2026-04-25 08:51:39.137482+00
982fac67-dcc3-49d5-a86d-29daa996ef51	07f3948d-6bd1-4c6b-975e-9ca424aa4653	44e1926c-8522-4631-a646-c70051ba055a	2026-03-03	\N	2026-04-25 08:51:39.137482+00
b7297a33-05f0-4f1f-a279-409d08326b6f	7624aa36-6251-4fab-8459-b6023c4ba4ca	7454b4a8-56c1-48de-836b-308acfa85ca8	2026-04-09	\N	2026-04-25 08:51:39.137482+00
b5097a2b-05b8-42af-8312-fbcfba03f90f	fd69bec4-f365-4019-96dc-12ba874523d8	586ef4ca-7d3c-4a39-9051-e603c5a02ffe	2026-03-01	\N	2026-04-25 08:51:39.137482+00
6cf4f3c4-302d-439c-8b58-aca2e3f5d0a7	35013b54-8205-4b8b-af7f-e52d2bfdc6a1	743d401b-a3d5-458a-ae4d-2bd427c208cc	2025-12-16	\N	2026-04-25 08:51:39.137482+00
a3cf6f9d-3ef1-4409-8a43-a4d76e62adb0	3fd9ab45-89a8-4b7a-b1eb-ebddb4a09165	709b6a0e-93d7-4c60-860c-670ee67b6aa0	2025-12-13	\N	2026-04-25 08:51:39.137482+00
4f61506e-723b-47dd-ac27-ced836df2d26	707e4c83-4ddd-4c66-b010-4d3473d925c3	516bcc62-c615-45d1-9d43-7f4f401becea	2026-03-27	\N	2026-04-25 08:51:39.137482+00
5d14b228-ae9c-4304-bac5-700bcef0a8d1	5ac667cd-42a3-490f-ae2b-0b8b741a96d5	ada3a38b-c6d9-4bf7-8298-92ec43121ddd	2026-03-30	\N	2026-04-25 08:51:39.137482+00
464de0ed-48da-4e48-b1b0-7ff82df0010c	0eb7080f-a0c5-4a67-9098-fb056064f152	8a9cb177-0668-45ad-90ee-7660633ed8ea	2026-04-08	\N	2026-04-25 08:51:39.137482+00
50561f5f-8b3e-444c-9ade-41ea23bec9e0	03622b6e-cd01-402b-887c-a8bb170c8d10	8e835206-2790-4322-a8a9-4a607597fe3b	2026-01-17	\N	2026-04-25 08:51:39.137482+00
8d1e4209-2668-4b52-ab25-4b9c0d733b30	4b23e0b3-9ad1-40ea-bdfd-bbc7daaae7cf	efd865f6-a180-4cc8-a703-3286b8f56f63	2025-12-25	\N	2026-04-25 08:51:39.137482+00
2d729845-5c89-4034-8653-f5f00ae4f1e9	43df43ab-58fd-48c4-b59d-dddd860ed509	722b45a7-97e6-4dda-8562-4187cede31f6	2026-04-22	\N	2026-04-25 08:51:39.137482+00
50ed212e-1587-44ce-b25f-3c342f8df914	c0184e70-b1ca-4539-b18c-cedcc644060b	9debce79-fd6e-4991-8c78-7abb8b0cd0a1	2026-02-11	\N	2026-04-25 08:51:39.137482+00
dad014ff-f4db-43c2-b394-6072ea047e93	8763ecca-696f-4084-904d-51d34a6d824c	1de234dd-f963-42c9-92d8-a2fd1f73d93a	2025-12-11	\N	2026-04-25 08:51:39.137482+00
0b59e691-2876-432c-99f5-acb40fc5c710	bae058d8-4304-43cc-a0a9-259d3dfeff18	29b1a6fa-3828-4374-8f7d-10f4095da077	2026-01-22	\N	2026-04-25 08:51:39.137482+00
f0f974fc-c12c-44fd-b86f-c0be34ea3300	f7af97f8-ac24-4388-a760-c33fe2728ccb	f6af833e-d848-4d59-87c1-2dc6f8031ba8	2026-01-25	\N	2026-04-25 08:51:39.137482+00
1efc8c22-80f3-4892-b6e7-bff03e0273d6	f3a44392-8213-40bf-8a50-79024820ba49	0a792d02-231c-4405-a9ed-24bd14f991ac	2026-03-13	\N	2026-04-25 08:51:39.137482+00
cfcfc425-4bc5-4500-a482-d54af371a70c	fe886c5e-6437-4863-89ea-ca4f88c66e47	a0e7ba8a-b55c-4f2f-9dd3-801ce5fc6fc6	2026-03-13	\N	2026-04-25 08:51:39.137482+00
dc5ad1ff-01af-404f-a907-7f2afa4fdb1a	8749ce8e-b817-4bc1-8872-fa1ac635f956	15977c46-131e-400b-a3d2-14533b7cb716	2026-03-27	\N	2026-04-25 08:51:39.137482+00
1183325c-7601-4536-a432-fcf12302489a	d4b06f9c-3d4b-4675-a0fa-4a3e987a0297	db0d0ddc-4d23-49b7-91c0-eb6fe3368e7e	2026-01-05	\N	2026-04-25 08:51:39.137482+00
9f80f327-dc0c-4abd-8a83-db5ca96326cf	94a90d7b-fb5d-410d-8c04-697e2a601a41	671e5319-9d1e-4218-9046-cf13c48f863d	2025-12-15	\N	2026-04-25 08:51:39.137482+00
7fcde169-98fc-4de8-baaa-90fea15a3eff	1d7a1ac2-e335-4ea2-a8dc-64c2ca0b9937	34c7ac49-bbaa-4d75-a370-cc63cee3bc67	2026-01-25	\N	2026-04-25 08:51:39.137482+00
53b57ded-136c-411f-8f74-873f7d3b1926	202ce419-9ea6-497c-9641-1c4bab04c2ff	9961ad98-607d-4aae-8b59-ac764206399a	2026-04-12	\N	2026-04-25 08:51:39.137482+00
2504a1a0-aa4f-4994-b0f2-e1fdab41e726	e0f22208-15d7-4509-af92-10c14956da5d	f61caeac-89a2-4fef-ac3f-80c61ec7c37e	2026-03-20	\N	2026-04-25 08:51:39.137482+00
1e0595b1-2e44-4372-8b06-fd18f7c3c8ca	56f81ee7-a659-4bc0-b31b-6b89eef2b0b3	e703e73f-8dd0-48e0-aaf5-55f9c0b150d0	2026-01-03	\N	2026-04-25 08:51:39.137482+00
1626fc57-b4cd-4e41-bae4-73cbf3d65d21	74d8a5a1-fa0b-4850-81c3-1e364a4d583d	834d53c0-bc88-45a1-ad3e-8fa113bded22	2026-03-24	\N	2026-04-25 08:51:39.137482+00
005ac1f4-868a-40f9-abce-d77a95adc7d1	7fd03655-0a2f-40a9-912c-b1237a8559fb	0a744c51-0f4d-4e07-bf97-ad52a89c60ec	2026-01-21	\N	2026-04-25 08:51:39.137482+00
7a5b97a6-618f-4a04-83cf-9bfb850b8c73	b265e517-bb2c-4603-8e2e-7baee400e4cd	65116e9f-d922-4cdd-a285-c292f4620ce7	2026-04-02	\N	2026-04-25 08:51:39.137482+00
00e0eb4b-cacf-486f-9e35-d88900cf8134	8d6ecea5-3ae3-44d7-94f5-5070e9012bb4	68543b9b-5e86-4dc2-9c10-bfadb2845ed7	2026-03-14	\N	2026-04-25 08:51:39.137482+00
5f9ebdc8-5b40-4882-bb1d-fb42be17f193	5e1f5274-2678-4633-ac90-9790e0af1783	23d32bcc-e3e2-46a1-b483-eb8f5c7cea43	2025-11-28	\N	2026-04-25 08:51:39.137482+00
fb693e3b-b743-4eec-8ee9-9589aac7c0a6	3b2cfec9-7ba3-4c82-8d78-eeb77bd8f7b9	9f0bf463-beda-4024-bf39-82df67a63244	2025-12-07	\N	2026-04-25 08:51:39.137482+00
dfac2997-7824-4478-b88a-539ded11d5c8	af5ee0d7-bab5-48ec-acd8-a7fab7e4fa09	3c44c57e-6ca3-4370-be36-3b61b8731b39	2026-02-23	\N	2026-04-25 08:51:39.137482+00
95ab1acb-bf76-4a19-adce-921fa98d66a0	5f6d3c5a-0b29-4b63-a8b2-e3697705ea51	f6b602ef-87fa-438b-a54a-6b8967934448	2026-03-06	\N	2026-04-25 08:51:39.137482+00
10d8b788-f96d-4e3b-9571-b4d7f7877741	8991bf62-1500-4ed4-ae4e-168063875d9b	88fd183e-673d-46fb-a44f-c0c3e593eebf	2026-02-16	\N	2026-04-25 08:51:39.137482+00
2295b8a4-e8e0-457b-b16f-f7d53b95f8a9	dbf6353a-a356-4d64-85b1-549de5f47290	45cde211-8bcc-40bc-b09a-5f69863b96b1	2025-12-27	\N	2026-04-25 08:51:39.137482+00
8c6ac6ea-917b-4692-8346-f862f72ddf43	adc8da36-87ce-4b29-8135-7964aed717f8	c897f2d6-15f3-43ab-a068-0fc50d40a5fb	2026-02-16	\N	2026-04-25 08:51:39.137482+00
0c00ce40-8c97-4f77-86dc-a79ecfbd5acb	989e1ec1-d3e9-490a-a101-e3f26c7b199d	767dbd62-de05-4999-9f1f-4cfbad93a33c	2025-11-14	\N	2026-04-25 08:51:39.137482+00
5764ccf8-8b10-460e-9ad9-b9965c95ba22	ca537153-34b4-4a4e-9019-5b9d8c2f2406	26dd898c-09e3-4f21-ae52-d02557ac5bb9	2026-04-23	\N	2026-04-25 08:51:39.137482+00
d693faab-8f55-4230-b5fe-32290a2830f0	912898da-a2bb-4658-905a-bed77a25d63a	6e395d22-a947-40de-bcde-0ed103b6c69d	2026-04-21	\N	2026-04-25 08:51:39.137482+00
76aea6eb-42d8-4e6c-aa2d-94e531d2c6db	01ae372e-058c-41cb-aadf-22b334653324	a9d19ca1-8478-4c33-9d6c-4700452cf066	2026-01-05	\N	2026-04-25 08:51:39.137482+00
334782a0-2fdc-4903-bf59-c95e0da232db	a5fcedd7-d86f-4d0d-a792-795af7a09bdb	5162909e-abb0-4b61-ba7d-5b667eb61c56	2026-03-27	\N	2026-04-25 08:51:39.137482+00
01ddf051-826c-4220-8d80-0ac155f0c4f3	e033bc07-091b-4cf2-95fe-cf55dc1d6698	c353bb5b-c2b1-44f2-acf2-a790817ff99d	2026-02-22	\N	2026-04-25 08:51:39.137482+00
5ba602c6-74f7-47c4-91ca-d8c35ac50cfc	05f18f62-6394-4000-83cd-a64d7c826978	0f60b0cb-f583-4566-aced-e49dd8026224	2025-12-20	\N	2026-04-25 08:51:39.137482+00
b8b76265-865b-4ad8-8d17-1d45145956c2	9c33b7a7-7c68-4706-a7f3-c1edcc7d0b40	fb5f74ca-59ca-45bd-af5f-390d3bbed4a7	2026-01-25	\N	2026-04-25 08:51:39.137482+00
b51cb999-62e2-4791-b02a-9f0c375c6034	ce1b09d8-2990-45eb-a03a-200d4eff2ddd	a4012551-4572-4655-901c-f341476294a8	2025-12-07	\N	2026-04-25 08:51:39.137482+00
a75622fe-f3b5-4d67-bfcb-e770fefbd6ad	75466d0e-1255-40cd-9242-9e365e60de4e	7a1018bd-87c0-4db5-a0e2-a75b35500197	2026-04-05	\N	2026-04-25 08:51:39.137482+00
26ee1874-eee0-4af8-9c85-176babde2e14	e15c0287-f490-4108-a5d7-81622c175bc1	70fa894e-b75f-4fab-95c6-ff0bbda4324c	2026-03-04	\N	2026-04-25 08:51:39.137482+00
512120b1-f1c2-4496-acc9-ab43e20d3e03	e762b4dc-0d94-4539-aa6c-00867ca4b122	74aaa83d-0983-4d84-ba40-6e1d19bf4350	2026-01-16	\N	2026-04-25 08:51:39.137482+00
e6699013-f5f9-4b82-a87e-392e353b1c50	e488131f-b503-4107-bb2b-374ab3b1823c	22cc77c9-598d-4c94-8b0c-820a81fa7543	2026-03-23	\N	2026-04-25 08:51:39.137482+00
f62c0ca1-986a-4317-a7c0-b71e24ed4ee1	5dc9afaa-85e5-4166-afb6-247b8ef8650b	545b7640-42ab-42b1-ab77-fa3d1858364f	2026-03-11	\N	2026-04-25 08:51:39.137482+00
b57d7c4b-b41d-4251-8d6d-faae44b5ae19	6c37ff95-4b25-45c3-baf5-f7710f1c67cc	a352c85c-ac86-4bef-9708-88ea0671461e	2025-11-20	\N	2026-04-25 08:51:39.137482+00
ac8c4fa0-9cde-4314-b687-69a75d2ee654	fc8c2672-e860-41c1-8ab6-80d722280afa	e9551e21-3770-41c9-825f-d4a26450bc8e	2025-11-10	\N	2026-04-25 08:51:39.137482+00
a8ab96a7-db9a-4715-ab52-cdd4db60a477	4d0b8854-6501-461d-9cef-f84683c8299d	06a181f0-80b7-44c7-890d-702b2f9570bb	2026-03-16	\N	2026-04-25 08:51:39.137482+00
9917a693-35df-421c-b67d-a907734ee3d0	284f7e92-b0d9-4939-891c-c8288d31963a	f14204c2-3178-403b-a4bf-86900c034490	2025-11-05	\N	2026-04-25 08:51:39.137482+00
f85de8f5-fabf-40e2-b86b-8fc92779da15	c8f5d487-f9df-492d-8adc-1ca93969f3c3	9162fc0a-9afd-47d2-b3c8-e8437f89ce45	2026-01-30	\N	2026-04-25 08:51:39.137482+00
4f5d0e26-6b00-4fbf-9f8f-ace8c1f4189a	2cf9d019-660d-4e6e-8785-4019c809e993	05232122-7867-4cba-bc5f-0136501cc898	2026-01-09	\N	2026-04-25 08:51:39.137482+00
889a565d-f2f2-4a95-871c-f9b8276e0d71	4c01ff7e-e1c8-4fd8-b6f9-348cae9c81da	5c707f13-c55e-4240-8489-3b13347d06d5	2026-04-05	\N	2026-04-25 08:51:39.137482+00
02ba4ca4-067f-4839-a4bf-0af5f78bbee5	42b87382-2f06-4aca-afef-a3c4c240beda	f09acdcb-622b-40d2-a1ca-a14c8f5c6e04	2025-12-26	\N	2026-04-25 08:51:39.137482+00
4cbd6887-7a06-49b8-b0ae-395e4d63b290	802cac38-69f9-4a05-b372-50c67db47948	7b28e0f3-45aa-4436-b187-d707d6143970	2025-11-12	\N	2026-04-25 08:51:39.137482+00
d285c835-8164-460f-a9a8-b119dc8198af	dc22eeb2-987f-4e82-9410-1c613cc1702f	2fcb052c-35a1-4bc5-99e0-53e3a4498eab	2026-04-02	\N	2026-04-25 08:51:39.137482+00
68c68c11-d97a-478c-a6b5-352563abda28	a5d604c2-9381-4e75-8f62-26c77fc1de20	d6b7f6d9-a19f-4952-96d6-3b23dee8e147	2026-01-27	\N	2026-04-25 08:51:39.137482+00
2e21ef18-03cf-4660-b7e3-21dc4e197033	f051f7b0-9bef-43d6-9d5a-bfe39d527740	86bd4df3-a312-46e7-969e-6a0d3296a5d2	2026-03-04	\N	2026-04-25 08:51:39.137482+00
02f242fd-15aa-4659-9d8e-65bf52ac3511	5915610b-d402-45cc-b027-b757dbbd85c3	690eeec9-8132-48e6-b24e-dd46ebf7b9a0	2026-01-29	\N	2026-04-25 08:51:39.137482+00
a7063f3b-bd8a-491e-8a36-222aefed8538	d770fdd0-a34c-4429-8a44-6e68a224c470	f7ed0c50-da31-4838-adef-b7f70deff845	2026-04-05	\N	2026-04-25 08:51:39.137482+00
8e3fed60-641d-431c-9440-31fb329f2a30	c469c9ea-401d-4c81-8a48-e9e6c41daa32	bd51d1a0-9f0b-4224-9d1e-d7180df06c0a	2026-04-23	\N	2026-04-25 08:51:39.137482+00
fdd96627-4730-40d8-8e58-6a8fcd0c6fa2	ea67f291-0f4f-4593-88af-91e40c9b685b	585ebd1d-4139-4cd1-a1f7-03e67df3291d	2025-12-27	\N	2026-04-25 08:51:39.137482+00
79ccf431-e91c-4e32-89ea-4f43413d9f6b	2db395bc-f073-4d99-842e-d75de8e638ce	d31a4eca-4a3f-4efe-9505-069d94e14734	2026-02-24	\N	2026-04-25 08:51:39.137482+00
31453e97-60f8-459e-b742-df5ab2aaa98f	10995f57-84b2-4ceb-94da-b089bb26b0e7	472afa80-bf5d-43d1-8e44-df247c9fbcdf	2026-02-22	\N	2026-04-25 08:51:39.137482+00
e0907f8b-94e3-4f34-aea5-1f7b803fa6c0	a3234437-aec2-4402-94e2-3aaa12150d12	54bde0ab-2ef5-408e-8ec1-df75a3026def	2026-03-29	\N	2026-04-25 08:51:39.137482+00
b7107922-5113-4557-b87f-002cbb2a6149	629513a7-5641-40e8-97d4-53c677284e6f	7eeabd19-01a7-4cdf-8565-04888ce2e5d0	2026-03-26	\N	2026-04-25 08:51:39.137482+00
a3055d08-0889-4352-b586-5f2290390c18	428f69fd-c59c-419e-a8fc-5b3ffe009468	b9cdca48-90c2-4610-adb4-beff3118b783	2025-12-19	\N	2026-04-25 08:51:39.137482+00
0ca72757-d33f-4bf5-a123-d5652e80daf3	298be5b5-e3a5-49cc-9174-e14c27f4abf0	adc6f832-49b1-4edf-8310-eb7d52862e6b	2026-01-15	\N	2026-04-25 08:51:39.137482+00
6ac2e703-6d73-4f8d-b619-6bf5eee01014	0fa24134-8246-4519-86e6-9f4426bdbdde	259878fd-7edb-440f-a200-e9f0269882cc	2026-02-19	\N	2026-04-25 08:51:39.137482+00
2db092b5-39d7-4dde-861a-12ef50e09be0	512f2360-92c4-4a6e-afc8-dc31d3e7e57a	615a1be5-cc13-4101-98b2-ffb79c3c57e0	2026-02-04	\N	2026-04-25 08:51:39.137482+00
01b2864d-ea9b-41d5-bd97-7ad77186db51	a41de643-69fc-4409-a670-df95fce8f30a	368eb570-61e4-48c0-b280-227d91f6a6ef	2026-03-21	\N	2026-04-25 08:51:39.137482+00
af5bab0f-eabd-4b9f-8454-343adfacc636	b96d0c39-4d97-495f-a886-ba42c5d6e1c8	87a87589-2e10-4902-be40-f1b9a4e0da92	2026-02-12	\N	2026-04-25 08:51:39.137482+00
4f384531-e568-44ec-bfa6-f0cee1fd2c3a	7312e895-7ede-4702-977c-e403ab01fee8	4e922900-bd31-4c0b-9555-81ea1d95a01f	2026-01-10	\N	2026-04-25 08:51:39.137482+00
fc8b3c09-307b-4b6b-ae32-cf42e5c9467f	2c2d0741-480c-488b-8c6a-f8b0a454332c	3913130c-47c9-44f0-a700-467e044310f2	2026-04-18	\N	2026-04-25 08:51:39.137482+00
7dbca615-c21b-4d60-ade2-bb350c4eddad	7604a356-9edc-4c85-8805-471f78b9e456	6a3e5fbe-1a1a-4d29-bec6-88bfe8688ab9	2026-04-20	\N	2026-04-25 08:51:39.137482+00
8e2fea83-3b34-4f47-b85f-43be078109c9	0dcde964-d2c8-4699-8b58-eb8d8adbefb8	ed9fa910-127c-4e36-ab6e-def5ba510770	2025-11-07	\N	2026-04-25 08:51:39.137482+00
5c66331c-4a3a-4e02-9db3-b25dfbd9c21e	2b42e1be-3776-4663-8a4c-a77ed7da825b	c6fe6f13-fcd9-4939-aba0-1f3f2ebb0efa	2026-01-08	\N	2026-04-25 08:51:39.137482+00
a5c3474f-0a3b-4f4f-ae58-1f4e2c5cf16a	324f551f-280c-4ff3-85a1-cd6e7fc5a88b	c23a9a19-96f1-4b99-8f4f-85d0f94bf90f	2025-12-08	\N	2026-04-25 08:51:39.137482+00
e96c4a7d-3be0-4731-bbd7-93aa765ca713	19cd9b15-3b8d-49dd-8ada-6c2547a81126	3c61d9a4-7206-4909-9315-637f8800c988	2026-03-21	\N	2026-04-25 08:51:39.137482+00
1f29a619-dd2a-4ad9-b53a-46f9cb8b1748	b678f4f1-c0e1-43c7-bddf-85cdd12d783c	0902b4f3-104f-4c14-849c-6dfd566be8e6	2026-01-07	\N	2026-04-25 08:51:39.137482+00
e935ea17-510e-45da-81ce-2174b2cf0b58	692a4a75-876a-4d8f-b38f-e673689c77a1	92254446-182e-46ed-91df-016842aeb4e4	2026-02-04	\N	2026-04-25 08:51:39.137482+00
96f9e112-cfda-4665-b050-d33407cbb387	63b1b5bb-33e0-4705-825e-529a2a2ecf7b	87cb577e-7747-451b-b59d-d48274661436	2025-11-07	\N	2026-04-25 08:51:39.137482+00
9cafa192-d322-49a7-91e2-079f8eaf6bc1	24f0b10d-445d-4d6e-888f-dcdb1df879dd	2b3079c6-3122-42fb-91a4-0f7300b4b54a	2025-12-03	\N	2026-04-25 08:51:39.137482+00
2fec6271-e92f-4f25-8803-24e406706dbb	c1b4404f-f86d-4576-b1c1-84c33c781c11	a6725abd-5f83-4b41-8c7c-05e3fc98576c	2026-01-13	\N	2026-04-25 08:51:39.137482+00
a65801de-9b59-4244-b93f-e4f8e777cb85	54c989e5-fb77-4d7c-bd2b-8bdb929e3fd3	97ed7ac6-3016-4206-b0d0-56f5067c44a4	2026-04-23	\N	2026-04-25 08:51:39.137482+00
c55e9c42-a1a0-4a10-8ce9-5d3084c06a22	745a0cd2-2ca4-44a9-9fd5-8bd6e215dd21	4182c70e-d8e5-46a7-8cf4-59b422c9d34c	2025-11-17	\N	2026-04-25 08:51:39.137482+00
287e3d82-bae5-4824-acf3-a2f3a2a4ea64	eaeaa9a3-fb41-44a5-bf43-2e80e3cee82d	89f1a8dd-71fd-445e-9743-6f9116d4361f	2025-12-30	\N	2026-04-25 08:51:39.137482+00
12f0f22b-b946-410c-b72f-ec576260f1b3	ca54cb3a-6cc6-4570-894b-c8eadb541d1d	457f2077-d167-4ba0-a6bc-1654f3bffbd9	2026-03-13	\N	2026-04-25 08:51:39.137482+00
dab0f6c0-e049-45d3-95fb-7effe88c7b01	4addc032-8424-475e-84b9-4fbe5bca80c1	559bf72a-fa17-4598-bef5-b0a58acc3f2e	2026-04-18	\N	2026-04-25 08:51:39.137482+00
467b0b5b-cc56-48da-a5cf-009ca035c146	9809289b-e054-46c8-b588-b4d98813f228	44dd4b42-73e2-438f-86bd-37686713a121	2025-12-26	\N	2026-04-25 08:51:39.137482+00
222a30b1-15bc-4b50-9fde-46d4c8300283	f202229b-639c-4c6a-98d4-44da962a1a74	84bdb167-0aa2-4a59-abab-4c7b1df90a91	2025-12-19	\N	2026-04-25 08:51:39.137482+00
09135324-0365-4147-ab2b-e88dd5096014	5f370399-ec26-48bd-b8a3-26e2e16a4653	fd7b3beb-abee-486a-895a-3eb7b743c2ca	2026-01-13	\N	2026-04-25 08:51:39.137482+00
9e2fca1f-8ce6-47f3-a044-3033679c4d81	fce3ab52-0706-4818-af4f-f5ac030b7d05	08fb557f-81dd-464c-b3d1-3d35cdb9708b	2026-03-25	\N	2026-04-25 08:51:39.137482+00
30dfdc40-0a4a-4c7d-916e-0e851ef4a09e	bc4190f0-beda-40af-9308-69382ea91e61	0567ad01-5aa5-4cf2-94eb-5ce887e0e7db	2025-12-15	\N	2026-04-25 08:51:39.137482+00
21f908d9-7414-42b6-b6c5-28ee9b74083e	55775dbf-71e8-49fa-8af1-5c801ffc81c9	c5257495-45bb-41be-a1aa-3884da33aee8	2025-11-30	\N	2026-04-25 08:51:39.137482+00
1d3f4783-602d-4b77-8fd1-8943a138ac4e	47d3af92-d6b1-434b-8a09-cea86304ce8c	b4a734e8-1e1d-43d1-a512-11a48a447237	2026-03-30	\N	2026-04-25 08:51:39.137482+00
540414bc-4de1-43dd-ab82-67d0033a6ae8	34e687b6-0f5d-4dcd-b96b-f39d31f5adff	7d8612c0-45c6-40c1-aa3c-8c009b93a9b2	2026-01-14	\N	2026-04-25 08:51:39.137482+00
f0148540-138e-4ceb-a899-2e77df689dd6	10b97ee6-8814-4fa0-b672-98c182984467	d9675405-e54b-4df4-a2a4-ac5cfbb7db88	2026-02-14	\N	2026-04-25 08:51:39.137482+00
dc038df5-9f38-43cc-8dd7-5fd9d4fddfcf	80f938c6-87e6-458d-abdc-e42be53fca72	a228301b-b743-4b7a-87cc-c19a8c52ec53	2025-12-16	\N	2026-04-25 08:51:39.137482+00
81c8b2b5-6c5c-4ca4-9206-0b211357225c	9421289a-d37f-437d-8bb8-99575db8ffee	083be483-a5e7-446b-a947-85a8a73d5412	2026-01-18	\N	2026-04-25 08:51:39.137482+00
bc59340c-1d10-41e5-81f9-c487e6888e9a	cf56c873-9517-40be-9a3a-6d23c2c706c5	3295c497-f086-46fc-98e8-281d62001e7e	2026-04-17	\N	2026-04-25 08:51:39.137482+00
3fc2348e-8d9d-46fe-b5b7-4c76fb8fd356	6631119b-fc96-4e46-885e-1c4cef7612f3	e478de9f-d079-4007-850d-2a9dae18d5ea	2026-01-31	\N	2026-04-25 08:51:39.137482+00
615e4ff8-89be-4274-94f7-14cfbd2af560	c02ee98a-0d31-4703-970f-dda2c4df7058	b597ac11-ebc1-4bac-a427-8ff2275052a5	2025-12-19	\N	2026-04-25 08:51:39.137482+00
2df724ab-d18a-4558-a5bc-fb7274be349b	a2979ddf-f82c-498b-844e-973d61ccdece	296e5dfa-f8f7-44ff-b7f8-4158fd094a4c	2026-02-20	\N	2026-04-25 08:51:39.137482+00
b43640ff-c9ab-407d-a1bb-cc14ecc14052	9fe37e47-1e14-476d-a69e-33414b14302a	7696edaf-25f4-4073-a0fc-8c6048b00ec3	2026-03-09	\N	2026-04-25 08:51:39.137482+00
dc65a661-bd69-46fc-803e-d64ff14e0bed	b6a8688b-c3b5-4617-a268-95937d7fc5a5	4d8a9767-9527-4543-affa-56a15ff0236e	2026-04-01	\N	2026-04-25 08:51:39.137482+00
c33c76ef-6d43-4816-a30f-bb9b25209854	0970a16f-88f6-4d3c-a81d-0e1cd82dad54	328acb14-e379-493d-9dfa-9e169ba31b38	2026-01-30	\N	2026-04-25 08:51:39.137482+00
20b4f18d-d7f0-48dd-a259-48aa664aee6e	310d37e1-27b3-4370-92a5-4153c3a44d57	242200a5-7833-42a3-b8a9-8c0d30338be0	2026-03-06	\N	2026-04-25 08:51:39.137482+00
0d14680c-0294-4985-a4d4-0fa6877a1a99	129fa5e8-9f14-4107-b9ac-c7497ac7f528	026f58ed-7208-4852-b9e0-c0fc7d5bf702	2025-11-13	\N	2026-04-25 08:51:39.137482+00
937e279b-d163-4de1-a4fd-6662e3a05acd	ee6c1813-3561-45e7-a7fc-5a57c853d72c	e4b2c238-4202-47c3-80cd-93ad4cbed1fe	2026-01-29	\N	2026-04-25 08:51:39.137482+00
3a64d7fd-e917-4a5f-9e6f-be6386702d2a	b3512e30-b16d-4344-8070-93fc9e41d771	f949f7e0-9348-4e3d-a20e-935a773e6809	2026-03-06	\N	2026-04-25 08:51:39.137482+00
a0fe5eaa-a1ca-4989-a33a-9d27ce169a26	ebb93ff5-d112-4fbc-9364-49737991f054	91ae1b5c-5f4a-4ac6-aa5e-7a45e7964242	2025-11-14	\N	2026-04-25 08:51:39.137482+00
9637a2a3-515d-45f9-afad-c593556a4620	f5f86250-7093-4024-9916-d38794a81d79	97079aad-3758-445f-8ee6-65f2be6ac01a	2026-03-13	\N	2026-04-25 08:51:39.137482+00
b09e8a8e-5f89-4b9c-9951-07019a7056bf	5c7aac3a-1cdb-4b39-90c0-849c41909815	ae102836-312d-497f-ad30-439d6b79b527	2026-03-24	\N	2026-04-25 08:51:39.137482+00
c9b0c8d8-23b5-42d7-b377-13ec57789a27	404c75ec-0964-4e28-953a-0abe85b029b6	ba47f41d-4734-4f90-bd5a-1227035da32e	2026-02-28	\N	2026-04-25 08:51:39.137482+00
fdc2ae6b-3f73-405d-9ca2-ba4f83da3484	75324daa-55ac-4cdf-8966-69dc2e3c9a7e	4eff0136-a954-4a60-9cf7-c17471a0734c	2026-01-10	\N	2026-04-25 08:51:39.137482+00
fcd280eb-351b-4e40-9e5f-9324e0bd79f3	c169a45f-6256-469a-8861-3d228a5ee68a	2d39feea-7563-43aa-b785-6cd4dbc62eee	2026-03-24	\N	2026-04-25 08:51:39.137482+00
a2d2ef5f-1e3f-4dcb-887c-426eb795cd58	75051b0f-eb2b-4030-9e6a-32843fa692ea	10873f98-0301-42cb-8ff8-6c545787d952	2026-04-02	\N	2026-04-25 08:51:39.137482+00
69f7a6b1-a75f-4e02-a9ea-5aae9cfd2b2d	24f5e3c5-7385-4bd3-8ed1-948be7c5ea5f	5a4243a8-dd94-4a02-ac84-9abe6f082511	2026-03-28	\N	2026-04-25 08:51:39.137482+00
5eff48b7-3154-4114-a115-021314c71c1b	328a1d8b-caf3-46ba-a469-adc7cf7c7400	12f04e58-13da-4188-aead-31c5dbb18dce	2025-12-29	\N	2026-04-25 08:51:39.137482+00
62a0145d-ffe7-4399-89e2-00f4ca15e985	2b218493-3b6e-476f-83cd-fd408cb4418a	08d6a161-6c97-4a32-9744-a1c0a6615700	2026-02-22	\N	2026-04-25 08:51:39.137482+00
7857f786-085e-4187-b905-f45d14907a44	9f9e2703-f29e-4617-9e74-924b713e65e4	e85c5377-f7b3-4d3b-94de-667f6a540ec1	2025-12-25	\N	2026-04-25 08:51:39.137482+00
3b7b7e07-d9c7-48a2-8e93-d2fb574e1579	edab61ec-41cf-4d08-8e0a-44bc1c1162bf	808a24b4-bc27-49df-b298-aa2f8d9c6d74	2026-01-17	\N	2026-04-25 08:51:39.137482+00
f0c7f24e-5781-4d40-9df0-e2022c7221d7	823e7d68-ed90-47ba-854e-9a9e4ee04ff8	605ecde7-4b07-432d-9c41-c26ed826dee8	2026-03-11	\N	2026-04-25 08:51:39.137482+00
8b7bc17b-644c-49aa-8bc3-3ca13004258d	d4bde635-9155-4ba5-9126-29929b53ca2c	cb61b6cd-968a-4bee-b97c-e6de392bc84b	2026-01-05	\N	2026-04-25 08:51:39.137482+00
8063aaac-5a49-48b0-a261-63526671bdd3	1128d72e-1362-4cef-874a-eb9d5ec4c490	cca7b10c-2277-438a-b355-83781d1f3388	2026-04-19	\N	2026-04-25 08:51:39.137482+00
6c396e02-e2af-4078-b2ae-2477f8252591	0bd0996e-85d6-43ee-b1c2-3a9a2aa58b4e	e2df70ab-1f9a-4784-88b4-437304f57600	2026-01-19	\N	2026-04-25 08:51:39.137482+00
59cd2f0b-32a1-46fd-90ab-ff5625fe6fce	f6cd2743-e78f-47bd-97a6-f511da8f2903	08e5f9df-d083-430c-bdd1-ba9842fa5381	2026-01-30	\N	2026-04-25 08:51:39.137482+00
6e207a93-221f-43f3-a290-eda91ac9aead	53ad3e18-fbd8-4e5d-a680-bca58c75d2f4	ab8bb463-b4bc-4917-9228-01b76f7787ca	2026-02-22	\N	2026-04-25 08:51:39.137482+00
ef80cb46-3970-4291-ae6f-13d66aeb0078	9ed88513-ab24-49e1-90c3-030959b546ac	b922ab95-4d65-4475-879f-f3562b1b6617	2025-11-26	\N	2026-04-25 08:51:39.137482+00
cdb81f66-344f-4de2-95bf-f6f649628c16	1534d62e-28e5-41aa-b629-44739968819c	c9ea36f2-baab-491e-8bef-54147970a423	2026-04-18	\N	2026-04-25 08:51:39.137482+00
b8a177f9-bdf3-4602-b53f-ecd1ec9d49bb	f76decfd-4c9c-4dd9-847d-1b87855e9bc3	b289b57c-734d-431c-b1c9-493bb7cbe00f	2025-12-18	\N	2026-04-25 08:51:39.137482+00
6d5e577f-a549-46d3-858c-ac5a5afdd0cb	2f08a554-3dd0-45ae-9850-0c7dbbc4b6e3	16e2602f-f68e-4c37-9bb4-b21c29d5c36b	2026-04-14	\N	2026-04-25 08:51:39.137482+00
d2e96a54-e621-47d1-b689-efa8fcae4b23	4553beee-d98d-4d0c-91fc-3cb126734d09	5d673fcc-8053-4a13-aeb8-d781211d2e6c	2025-12-19	\N	2026-04-25 08:51:39.137482+00
a6fb66a2-c624-4cc0-af8e-62829cdf4d07	35759c17-bbfb-496f-9802-83ecce1a066e	4aebea4e-8519-46d7-9644-7fd9afbafc39	2026-01-11	\N	2026-04-25 08:51:39.137482+00
c0a28c10-5f3b-4021-994a-ec1201cd4d61	2c5e010d-eb0d-409d-9c2b-4e51a2f867db	27c54acf-3771-401e-8a60-9ebd805bebd2	2025-11-14	\N	2026-04-25 08:51:39.137482+00
080d96eb-6b60-45a2-88a4-6a89e039ddd0	f7be1845-1e0c-474d-802c-437108d31791	6c2e980e-cec4-491c-9244-69c383e2ed4c	2026-02-16	\N	2026-04-25 08:51:39.137482+00
bc5d9021-de6f-408c-81bc-81f1621115aa	10fcfa9a-8a24-4a26-a24d-2f2dd2cebd84	b6c822ae-b631-486e-9ec8-68f0a10453b2	2025-10-28	\N	2026-04-25 08:51:39.137482+00
2ff31b6d-2a63-464a-9bb0-7a1703f23599	20c2b244-4402-4249-a97f-681d857af1a6	c5122ca6-6f65-405e-a71b-284a92318af2	2025-12-22	\N	2026-04-25 08:51:39.137482+00
87ad5099-3f98-4b4e-ac6d-8325f48f88c2	438c114c-357f-4525-9b45-89b0d085ebf7	576af9b2-0caf-48c9-8efa-ae314e78171f	2026-03-24	\N	2026-04-25 08:51:39.137482+00
ef4ed356-ec39-4222-a5be-2a9c116a86f3	b083e06d-c8ba-4037-9d32-8ad3f4e26b95	cf3e6ae4-c2f5-475e-9030-c0d80fcdb736	2025-11-01	\N	2026-04-25 08:51:39.137482+00
8cbfa1ac-ce10-4d54-8e46-2060a53f7f45	8ca85d1b-ec94-4aff-af73-9e0e5d772dc4	daa1a9d6-10c6-42c2-8f42-eba834b9ba4c	2025-12-29	\N	2026-04-25 08:51:39.137482+00
38e50b37-09eb-4d2c-ae42-72e80d837daf	8476e7f0-5495-4645-a4ba-6a1ec132be29	7e3e85b8-be14-4689-a334-f70d4f005477	2026-02-18	\N	2026-04-25 08:51:39.137482+00
fbab6630-62e0-42bd-b5e4-086f5a3eba52	2124e824-ab87-4958-8d13-5252311f878b	55550666-455b-42d4-826d-7d0676a56ee3	2026-04-14	\N	2026-04-25 08:51:39.137482+00
d23e298a-5f7f-48d0-b1b5-09b4525e7d44	31e4af9c-2ddc-443e-ba41-fe7de162bc4b	1e97a347-2022-4ac5-930f-3957884a8481	2025-11-18	\N	2026-04-25 08:51:39.137482+00
c2a42f61-027f-492b-bdfe-c7fc8910eb3b	29e36097-7941-4c56-b4b0-f7b00d0a6127	39446891-f172-42ab-bdee-1813a6178144	2026-03-10	\N	2026-04-25 08:51:39.137482+00
1bb5a4be-b415-4c2c-9285-b19068ba129e	8b715852-af9b-4714-ac51-4ef97c170d64	00f0c138-4c88-4206-92dc-cdef3a47bbd0	2026-03-02	\N	2026-04-25 08:51:39.137482+00
129d0ece-1e1e-419d-a970-ff14ace65131	bffd3eee-460e-4b38-bf15-722054069c47	81456c7c-dcb2-4fa6-9c43-3c6f2453d108	2025-11-04	\N	2026-04-25 08:51:39.137482+00
79acd908-9b16-469f-a9b2-a8103749a86a	a44d5266-451b-458e-88ee-d08b732599c3	8656177f-7a61-467f-bd9e-52e434de764e	2026-03-12	\N	2026-04-25 08:51:39.137482+00
b8f3436d-f864-48f7-b6f4-e18aa9ca82b7	29d0064b-48d5-46f0-a375-edff09aeb5b3	41563e9b-7249-4f6d-98c1-50e4cc696f35	2026-01-03	\N	2026-04-25 08:51:39.137482+00
6528e895-7bac-47c4-827b-7ec154338e2e	b9f95bd8-71d4-4d59-bd79-1fee0eccac7e	bfb8ca4c-f9d3-4e26-85ee-c691487ad56d	2026-01-14	\N	2026-04-25 08:51:39.137482+00
9663556c-a22f-4846-a9fc-2d07a7acbb28	22485013-8f84-457d-869e-b812516e59b4	0a75b266-541d-4a0b-a607-ad988b3ad99f	2026-01-05	\N	2026-04-25 08:51:39.137482+00
54c5cfde-41bd-4d42-a8a9-386ab2b16f61	6d7563ca-45ec-4286-841e-a5e80aa67051	7ed831c8-0487-4286-84a7-c7ed952b7d52	2025-12-04	\N	2026-04-25 08:51:39.137482+00
4ec3ea53-52e7-49f6-9b04-8c219e1d38d9	12c9b87d-2553-415c-8747-8bbd6dec9353	f88a23a4-0fbf-4e1d-acf8-2505f0d7be4b	2026-02-17	\N	2026-04-25 08:51:39.137482+00
63267783-99c8-4b75-8f7c-3bdceb80c1bc	c706336e-c0a0-416f-a9d8-629137d7aeec	c2769059-2179-4cb5-b059-24b8c8d7a12d	2025-12-14	\N	2026-04-25 08:51:39.137482+00
93c0efc5-e1b6-466e-a7cc-75b6f5d6551e	c5a4dd26-af3c-4e7e-af5d-cdddc5eb1191	38b35552-9113-4560-a736-90b4d2288ab4	2025-12-02	\N	2026-04-25 08:51:39.137482+00
c3d96164-5961-41b5-acd7-52e3af489348	9b618c42-beb1-49cd-9882-94ac22fa4b86	78e378ed-1d35-49e8-8ea1-75b0fe82e9c6	2025-12-29	\N	2026-04-25 08:51:39.137482+00
a3ef7fce-4abe-4a1f-84ba-64bb5f3f1716	aac0e1e8-0df8-45ca-8b38-08a77604ffdc	61dff57a-e2b0-4d36-a13d-91047a1d44b9	2026-03-29	\N	2026-04-25 08:51:39.137482+00
2cd67b72-62ff-4502-b006-4804403bd70e	7cf11abd-6e61-4939-b6d2-d391a8f01d8e	6eb93b8c-2ff3-461b-bce7-a557cb1a7f28	2026-04-24	\N	2026-04-25 08:51:39.137482+00
dad0bec6-9acc-4e21-8e76-1ad8cf13bbd9	91e1f494-b347-4573-8c0f-eb7e1340ee42	5414046b-ab65-443b-a828-f04693f0f358	2026-03-04	\N	2026-04-25 08:51:39.137482+00
1d31e99a-0a00-4615-9261-e65aaff176b7	d8d44e07-6de3-4ef0-8ba0-84928ac95395	901553ac-61ce-4416-bc8d-6cd593e0e927	2025-12-08	\N	2026-04-25 08:51:39.137482+00
0329427a-9dc1-47b8-b4b1-3da64eac1db6	18ac23f8-a4ab-4979-b69d-2181cd23ffec	81dffc79-a502-4bda-8c5d-469c83526d43	2026-02-04	\N	2026-04-25 08:51:39.137482+00
bd136b3d-64c2-4d7c-94c3-05e840af68a7	c2de6415-772f-44be-a71a-7183e1602950	5113d27d-6b0d-43ac-93b6-2950e4bba1ac	2025-11-21	\N	2026-04-25 08:51:39.137482+00
715c60ec-ffad-4f5b-af0a-d3ecf4fc9a10	846ebd88-cbc1-4a9c-8d2e-d2e212131568	47700f72-6ff1-406c-8955-ca2a42752751	2026-01-28	\N	2026-04-25 08:51:39.137482+00
621c100a-3f5e-4ef9-b077-3f0a565d7ca8	7e6f2e95-a575-4dbd-b0fa-09c4c456def9	ac25dc9b-f3be-4f20-96f7-1e43208b4e6a	2026-01-09	\N	2026-04-25 08:51:39.137482+00
0acbf4b5-2cee-4dde-9f66-b8085c22168e	db51322e-99a5-4aeb-b12f-8f4bfab67a4e	aa8b823d-4366-495a-8e59-dcb0e3443f88	2026-03-23	\N	2026-04-25 08:51:39.137482+00
fdf41401-e098-4583-af90-73eeac5fdac0	7b532441-2bca-42c3-a5d8-a189a343a54f	7efa8400-c306-4949-a945-daa2584b58fc	2026-01-25	\N	2026-04-25 08:51:39.137482+00
4d9bcdb4-dce9-451b-b7ae-144c22f13518	c8e8c60a-9bec-4738-ad64-d4de1fbf24b1	0cc6e9f7-057b-42f7-89c6-4845f67818c1	2026-04-08	\N	2026-04-25 08:51:39.137482+00
2da0e4f2-f346-43fb-b485-4864ad1ccdf7	537da42e-088e-4011-a038-28050ce714d8	94b299a7-3555-444a-8a9d-1f7352c5bde6	2025-12-21	\N	2026-04-25 08:51:39.137482+00
6d6107cd-c4ae-4822-91fb-d7d0dde76949	a4b3f9af-130f-4389-8b48-71d982674053	c6471d14-229c-4846-9405-8d51453ea935	2025-11-21	\N	2026-04-25 08:51:39.137482+00
fe4d24a4-4ba9-40bc-9452-25dd02dff9e7	6ee6ebdb-c750-4691-97e1-29fd22f930a0	657be8f1-006e-4d8b-8b6e-6c9efc777971	2026-04-14	\N	2026-04-25 08:51:39.137482+00
617c7e07-16a2-4bfe-8d85-8d8853d2fcb6	00bb68e0-db1a-4af3-88b4-4cc9cd9c7681	df75858f-c338-44b1-8ca2-25f2724d9fae	2025-12-23	\N	2026-04-25 08:51:39.137482+00
425efc7d-dcb4-47bc-a667-f562425a6cf6	efefdfb2-d268-4d8a-9442-95d9f311e546	e5ea94cc-51dc-495d-b903-57b5a1e98b0e	2026-02-06	\N	2026-04-25 08:51:39.137482+00
f92152bb-d59e-4c23-8830-1e895de62e6f	e98086f7-9246-4e31-847f-ccce14a6f918	506f02d4-6afb-4316-be18-d22267563f2d	2025-12-12	\N	2026-04-25 08:51:39.137482+00
eb5a52a0-88a9-4556-a367-d142cd4a240e	ca6f7156-33a7-4536-ade3-e8c9e126373c	1134b1f8-0f61-4645-b04c-84148ebf2a86	2026-04-07	\N	2026-04-25 08:51:39.137482+00
44908f05-f854-4621-bd42-c8e328704fc9	9426453c-fb55-4108-85e5-c9bb5c41a49e	0220bee2-03b4-4d95-9922-1ab1ee11b4b7	2026-01-19	\N	2026-04-25 08:51:39.137482+00
2b18fa1e-7099-47dc-9e02-19d21c0be649	cb17ccf3-b970-4b45-8dc7-e8e7753de242	63af9512-6602-4e0c-850e-6e00974f319d	2026-02-22	\N	2026-04-25 08:51:39.137482+00
2d057623-5249-4a2d-a046-b0ea97a7209a	e4bd72d3-04de-4892-9fee-d3c6c1474bc2	48245acd-2400-4234-8c81-f7d3d3c43ed8	2026-04-17	\N	2026-04-25 08:51:39.137482+00
abd7e6d2-7982-4165-8c8d-473155a1d492	08fa90d3-0b8a-4a15-a774-aa8d0016f6b7	05552314-6fc9-45f8-9c44-14d8d2f2dfa6	2026-04-24	\N	2026-04-25 08:51:39.137482+00
6a7cf01c-426a-4807-ba92-05bd542e29d7	0907c3fd-8481-4752-8f69-4612e955c346	72969b68-e395-462e-9a70-4dcfb9a2d4f5	2025-12-24	\N	2026-04-25 08:51:39.137482+00
965cfeca-909a-4aa1-a270-e4e76e8706a3	2a09700e-f49b-453d-9b81-78a751460ac4	c56ddc01-81d8-4389-a27f-407345316449	2026-04-12	\N	2026-04-25 08:51:39.137482+00
e7b59a07-6e94-4407-9fe0-ffe88cf604f8	ae6a7a54-5b10-4023-8ace-d64b7c0f5d19	62ddc133-8857-4755-8129-5bd238e099a9	2026-03-27	\N	2026-04-25 08:51:39.137482+00
0db7e6c2-9fa6-47a2-9bb9-e880aa89843b	a21e9b1b-8ce5-4b26-8b2a-f1f323fd336c	573f0309-9c7e-4509-a7c7-6e1b8cdd7901	2026-02-15	\N	2026-04-25 08:51:39.137482+00
e3e995f9-e59f-40b8-b488-a7a0f2b625f4	9f98f931-8572-4cc4-8adf-ae25621c0642	c8609a88-d771-4dd7-845a-afdc6a375cc2	2025-10-28	\N	2026-04-25 08:51:39.137482+00
496e4385-9ee5-495e-8132-0f93233e203b	17922d5d-5909-4157-821d-1773ab8b15d4	d03916d2-b6f7-4eea-b755-6867190210f9	2026-04-13	\N	2026-04-25 08:51:39.137482+00
ebcd5b20-552a-4db9-a08e-4e09d4274b70	c72e1660-c7a2-4b2e-a7ea-675d41bdaa8e	4b42ad53-5337-496a-bf74-e6f2201abe02	2026-01-06	\N	2026-04-25 08:51:39.137482+00
ed4cd6ad-f850-4a71-b762-63a974c8377f	9f5924f2-8353-448a-af08-601eb93a5eec	1cf13327-0802-4dc0-acca-6291b27dec00	2026-01-09	\N	2026-04-25 08:51:39.137482+00
7e0070bd-652d-41c6-8d0c-92d37f67e568	a1f1902a-c6c9-4c76-b236-da4e530c7359	da2557b0-e786-43f8-8598-ceee8c9b3cfd	2026-01-24	\N	2026-04-25 08:51:39.137482+00
61bdf2b9-0cfe-4785-aed0-f884835ac5fa	a61d308d-bb78-4e95-8659-a706bb6bce1c	00ef021e-6065-4a23-8497-4fb6aeeefe92	2026-03-28	\N	2026-04-25 08:51:39.137482+00
6efd2779-5fa7-4f78-a1e5-ffd739c33fa5	1767314e-c7d8-4db9-91a5-0a1aa580966e	ec32bbe3-f1f0-440e-9447-8bd7fce9083d	2025-12-11	\N	2026-04-25 08:51:39.137482+00
afc115ff-1b00-43e4-9efa-ce63c1255399	09df9889-f1d9-49fc-90fe-e7ca734ef1a5	b590ca34-dfb4-4d3b-b636-a3169df826c2	2026-02-11	\N	2026-04-25 08:51:39.137482+00
3dc5e27b-ae36-4b2f-b41b-d37b5cc8a506	6441ebad-5c6b-44ab-ace8-b8727ce01cc4	b4871bf5-4a63-4bf2-84c4-5f5c2baac56b	2026-03-19	\N	2026-04-25 08:51:39.137482+00
6c147e61-5eb7-4bd9-b86b-8fd925d48ac8	767ca500-a35f-4281-8349-ea8c0e4e633c	b1e8d6a4-b69f-4c8d-92b6-84a4ae13326e	2026-04-12	\N	2026-04-25 08:51:39.137482+00
5b3e01ac-8490-4bdd-bcae-472d4145d4d2	af5c8838-c77e-47e1-855a-ae6c7146ef5f	c89184b0-c12e-4da1-b9e9-7bca50cb71e9	2026-01-09	\N	2026-04-25 08:51:39.137482+00
0b91eef3-4cc4-4c46-8c16-5dc8e520496f	7b6a53ec-2225-4c41-9901-d0bf26a82b2c	1c5acd68-c691-4202-bcc0-3a79abb9665b	2026-03-22	\N	2026-04-25 08:51:39.137482+00
505ad44f-9dce-4680-b4bb-bc3837676bea	6104e1e9-7d11-4acb-a13a-fb266c8f4f87	daf69daa-02ad-451c-8b49-086bdba5e9fb	2026-04-18	\N	2026-04-25 08:51:39.137482+00
\.


--
-- Data for Name: vehicles; Type: TABLE DATA; Schema: public; Owner: slpvt_user
--

COPY public.vehicles (vehicle_id, registration_number, chassis_number, color, make_model, device_id, police_status, owner_nic, owner_full_name, owner_contact, registered_province_id, created_at, updated_at) FROM stdin;
39a979c1-d773-49be-916b-d7781c5ab4cd	WP AAA-2362	CHASSIS00000001	Blue	Bajaj RE	11f042a3-7b8f-489a-b1f8-1a44474418ba	CLEAN	321516033X	Shehan Silva	+94783572759	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
e2da2c69-bd58-4534-ac19-24e0dd53a90a	WP AAB-8901	CHASSIS00000002	Blue	Bajaj RE	20a2a621-2f96-457a-b479-714da4ba7382	CLEAN	19713319973	Lasith Rathnayake	+94717759435	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
b12170ed-2efb-46d1-9aaa-5e30ffd78019	WP AAC-1875	CHASSIS00000003	Green	Bajaj RE	21bb86b5-e2c3-4c17-8762-274b01613db1	CLEAN	546845494V	Gayan Seneviratne	+94759494206	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
4a400233-a0f2-47d3-9ce0-22f66e50c1c4	WP AAD-4464	CHASSIS00000004	Yellow	Bajaj RE	60f2153c-b0fb-443e-9b42-428982f40470	CLEAN	19917875063	Nuwan Mendis	+94773256845	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
e1bd303e-659a-403d-bc6f-5d540f2980bc	WP AAE-3839	CHASSIS00000005	Blue	Bajaj RE	95b09c4d-0897-45cd-877b-4bf766e3c91f	CLEAN	164611696X	Mahesh Amarasinghe	+94759372286	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
9c3a9923-69c3-479d-9ea0-aa198b280f69	WP AAF-4148	CHASSIS00000006	Yellow	Bajaj RE	cd7644c5-b92d-41bc-9605-40418d6cda45	CLEAN	19759246388	Dhanushka Bandara	+94729900780	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
07f3948d-6bd1-4c6b-975e-9ca424aa4653	WP AAG-3337	CHASSIS00000007	Green	Bajaj RE	f8a88484-483c-4996-b479-e29d46cbedc3	CLEAN	167564123X	Gayan Silva	+94713802179	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
7624aa36-6251-4fab-8459-b6023c4ba4ca	WP AAH-9010	CHASSIS00000008	Blue	Bajaj RE	ff3d4a2e-aa6f-4673-b520-ac65aed6a0b3	CLEAN	19814434887	Kumari Senanayake	+94718274632	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
fd69bec4-f365-4019-96dc-12ba874523d8	WP AAJ-3370	CHASSIS00000009	Orange	Bajaj RE	a0d1ee46-8387-48a0-9fc7-e38b55b9c0fb	CLEAN	606548460V	Gayan Kumara	+94779769464	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
35013b54-8205-4b8b-af7f-e52d2bfdc6a1	WP AAK-6859	CHASSIS00000010	Blue	Bajaj RE	c19d08d8-6669-410a-ae49-fa11c5f79dc1	CLEAN	19704723967	Rashmi Amarasinghe	+94783780377	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
3fd9ab45-89a8-4b7a-b1eb-ebddb4a09165	WP AAL-6283	CHASSIS00000011	Silver	Bajaj RE	9d9cbfaa-11b4-4b9b-8f7d-e1275c629ce6	CLEAN	296591589V	Chamari Amarasinghe	+94767984411	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
707e4c83-4ddd-4c66-b010-4d3473d925c3	WP AAM-5600	CHASSIS00000012	Blue	Bajaj RE	e3241eda-587d-48ef-afd8-84a3c57e437a	CLEAN	19865422450	Thilini Jayawardena	+94743680590	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
5ac667cd-42a3-490f-ae2b-0b8b741a96d5	WP AAN-1499	CHASSIS00000013	Blue	Bajaj RE	c6469a31-2481-48c4-b456-5b5f5bedbefb	CLEAN	580864358V	Kumari Fernando	+94746829628	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
0eb7080f-a0c5-4a67-9098-fb056064f152	WP AAP-1915	CHASSIS00000014	White	Bajaj RE	e1fdb938-b4e9-48da-92e8-ac2f99a9d647	CLEAN	19962444840	Kasun Wijesinghe	+94779495059	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
03622b6e-cd01-402b-887c-a8bb170c8d10	WP AAQ-5542	CHASSIS00000015	Silver	Bajaj RE	7b92f00d-042b-4e90-8b22-febedf61e87c	CLEAN	490414987V	Chaminda Gunaratne	+94772197951	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
4b23e0b3-9ad1-40ea-bdfd-bbc7daaae7cf	WP AAR-4656	CHASSIS00000016	Silver	Bajaj RE	83c7f439-6c23-43cb-a360-393705800682	CLEAN	19974177389	Nadun Silva	+94773464363	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
43df43ab-58fd-48c4-b59d-dddd860ed509	WP AAS-7929	CHASSIS00000017	Green	Bajaj RE	e1e5b0f6-0c62-4482-af2f-fb800423a97c	CLEAN	878778086X	Nadun Dissanayake	+94781976126	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
c0184e70-b1ca-4539-b18c-cedcc644060b	WP AAT-7468	CHASSIS00000018	Green	Bajaj RE	ab402c19-2ad0-4054-8e15-686b4de10919	CLEAN	19921979080	Menaka Madushanka	+94715883444	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
8763ecca-696f-4084-904d-51d34a6d824c	WP AAU-2934	CHASSIS00000019	Blue	Bajaj RE	79491ddd-4614-407d-bb0d-6e26146f9150	CLEAN	423921762X	Chaminda Gunaratne	+94752493332	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
bae058d8-4304-43cc-a0a9-259d3dfeff18	WP AAV-6033	CHASSIS00000020	Blue	Bajaj RE	c55f30fd-c14b-422a-9e50-958019a2f1d2	CLEAN	19866536739	Anusha Herath	+94775878712	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
f7af97f8-ac24-4388-a760-c33fe2728ccb	WP AAW-1378	CHASSIS00000021	Red	Bajaj RE	abcc96d4-991f-413d-b6e2-322ad076a122	CLEAN	786308385X	Dilini Herath	+94755958089	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
f3a44392-8213-40bf-8a50-79024820ba49	WP AAX-3504	CHASSIS00000022	Green	Bajaj RE	80dae15b-68bc-4a85-a7f2-3125657c75f9	CLEAN	19776142953	Menaka Wickramasinghe	+94752498060	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
fe886c5e-6437-4863-89ea-ca4f88c66e47	WP AAY-1016	CHASSIS00000023	Orange	Bajaj RE	56fb0f5d-463e-485e-862e-93807a500afe	CLEAN	904064556X	Sewwandi Liyanage	+94763881751	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
8749ce8e-b817-4bc1-8872-fa1ac635f956	WP AAZ-6523	CHASSIS00000024	Red	Bajaj RE	de87e434-706b-46c7-8ec8-f01865b39f4c	CLEAN	19797050623	Nadun Ranasinghe	+94777391149	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
d4b06f9c-3d4b-4675-a0fa-4a3e987a0297	WP ABA-9184	CHASSIS00000025	Yellow	Bajaj RE	b29a21bd-5769-4a37-a1ee-539c5f413572	CLEAN	472151159V	Menaka Rathnayake	+94744939056	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
94a90d7b-fb5d-410d-8c04-697e2a601a41	WP ABB-2172	CHASSIS00000026	Yellow	Bajaj RE	cb334d82-0f45-4eb9-a1c7-467f1663fc36	CLEAN	19967884774	Nuwan Rathnayake	+94744858715	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
1d7a1ac2-e335-4ea2-a8dc-64c2ca0b9937	WP ABC-2357	CHASSIS00000027	Red	Bajaj RE	26190851-0559-4dd2-aba5-7e6e53b4d623	CLEAN	632011521V	Kumari Wickramasinghe	+94761337835	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
202ce419-9ea6-497c-9641-1c4bab04c2ff	WP ABD-2811	CHASSIS00000028	Orange	Bajaj RE	ba8417e5-4312-47a0-bf5c-de0014a46196	CLEAN	19779056931	Upul Amarasinghe	+94726957625	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
e0f22208-15d7-4509-af92-10c14956da5d	WP ABE-9751	CHASSIS00000029	Green	Bajaj RE	8e4127a5-c9ad-431d-ba6a-5f9af1f058ec	CLEAN	996240308V	Iresha Amarasinghe	+94775825685	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
56f81ee7-a659-4bc0-b31b-6b89eef2b0b3	WP ABF-7321	CHASSIS00000030	Silver	Bajaj RE	36337ea7-d1c3-41e3-8268-1908a41963cc	CLEAN	19799392462	Nadun Silva	+94752206143	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
74d8a5a1-fa0b-4850-81c3-1e364a4d583d	WP ABG-4246	CHASSIS00000031	Red	Bajaj RE	0d75b21d-6d1b-4501-b11e-d81cb1accd6a	CLEAN	628348574V	Dilshan Bandara	+94754652500	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
7fd03655-0a2f-40a9-912c-b1237a8559fb	WP ABH-7686	CHASSIS00000032	Red	Bajaj RE	04175929-414b-46cd-b3a6-41b3cff34165	CLEAN	19981685106	Upul Wickramasinghe	+94758872948	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
b265e517-bb2c-4603-8e2e-7baee400e4cd	WP ABJ-9427	CHASSIS00000033	Green	Bajaj RE	e6e38404-b3c1-42b9-8258-52018ac73fb3	CLEAN	705624204V	Dilini Jayasuriya	+94742954369	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
8d6ecea5-3ae3-44d7-94f5-5070e9012bb4	WP ABK-2095	CHASSIS00000034	Yellow	Bajaj RE	d7ed0fd2-6e1c-491c-b2fe-0346976e6a0a	CLEAN	19727059923	Nadun Fernando	+94725683796	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
5e1f5274-2678-4633-ac90-9790e0af1783	WP ABL-9853	CHASSIS00000035	Yellow	Bajaj RE	15446498-1336-4d85-acba-c3b659e60aed	CLEAN	758833333X	Dhanushka Herath	+94768524513	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
3b2cfec9-7ba3-4c82-8d78-eeb77bd8f7b9	WP ABM-3343	CHASSIS00000036	Orange	Bajaj RE	035fa665-ed8d-4ad4-ba80-4c99b5730296	CLEAN	19985023148	Chaminda Fernando	+94744617300	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
af5ee0d7-bab5-48ec-acd8-a7fab7e4fa09	WP ABN-2822	CHASSIS00000037	Blue	Bajaj RE	545c2aeb-24c2-4e7d-acad-2359af8b5848	CLEAN	815114913V	Buddika Pathirana	+94772273837	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
5f6d3c5a-0b29-4b63-a8b2-e3697705ea51	WP ABP-4709	CHASSIS00000038	White	Bajaj RE	4351bc93-1925-426b-ace1-9522dca82ca7	CLEAN	19966074798	Nimasha Abeysekara	+94765688011	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
8991bf62-1500-4ed4-ae4e-168063875d9b	WP ABQ-8616	CHASSIS00000039	Blue	Bajaj RE	910d1532-1def-4d5b-a8b1-018be1fce00d	CLEAN	427399366V	Chaminda Wickramasinghe	+94772371856	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
dbf6353a-a356-4d64-85b1-549de5f47290	WP ABR-7915	CHASSIS00000040	Blue	Bajaj RE	2cc5beb0-74da-4a38-8a52-404b7ecc1f54	CLEAN	19816225084	Shehan Bandara	+94769909549	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
adc8da36-87ce-4b29-8135-7964aed717f8	WP ABS-1038	CHASSIS00000041	White	Bajaj RE	56a19934-f8a1-42fe-9d3f-693746c65293	CLEAN	551214946V	Nadun Wickramasinghe	+94726055812	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
989e1ec1-d3e9-490a-a101-e3f26c7b199d	WP ABT-8900	CHASSIS00000042	Red	Bajaj RE	610aefd4-4853-4731-86b7-66dd435147ab	CLEAN	19909172609	Chathurika Abeysekara	+94727162372	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
ca537153-34b4-4a4e-9019-5b9d8c2f2406	WP ABU-3877	CHASSIS00000043	Yellow	Bajaj RE	ccdf220a-5072-4e4a-9320-a7c84489ca5e	CLEAN	726239553X	Buddika Silva	+94767952430	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
912898da-a2bb-4658-905a-bed77a25d63a	WP ABV-2627	CHASSIS00000044	Yellow	Bajaj RE	22497b2b-45a9-4a8e-b93e-e04def7c49d5	CLEAN	19795279701	Thilini Wickramasinghe	+94778870928	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
01ae372e-058c-41cb-aadf-22b334653324	WP ABW-8469	CHASSIS00000045	Yellow	Bajaj RE	116b95ab-2e4a-46dc-8545-5d0c994c54e7	CLEAN	822466465X	Menaka Gunasekara	+94773880591	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
a5fcedd7-d86f-4d0d-a792-795af7a09bdb	WP ABX-2822	CHASSIS00000046	Green	Bajaj RE	1f839300-76d6-4a6d-be86-c9c8e4502d0a	CLEAN	19804898022	Chathurika Bandara	+94782213996	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
e033bc07-091b-4cf2-95fe-cf55dc1d6698	WP ABY-6537	CHASSIS00000047	Green	Bajaj RE	3e782069-6057-4a4f-b368-d3f5f86516c3	CLEAN	637069432V	Sachini Fernando	+94751623564	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
05f18f62-6394-4000-83cd-a64d7c826978	WP ABZ-7495	CHASSIS00000048	Blue	Bajaj RE	cc5fdd1d-f448-4e68-b044-23f1b3dc8daa	CLEAN	19804949921	Sachini Seneviratne	+94788791705	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
9c33b7a7-7c68-4706-a7f3-c1edcc7d0b40	WP ACA-8996	CHASSIS00000049	Silver	Bajaj RE	acec54f1-e49e-42e6-935b-b26d28b098aa	CLEAN	754070561V	Harsha Perera	+94713795360	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
ce1b09d8-2990-45eb-a03a-200d4eff2ddd	WP ACB-7344	CHASSIS00000050	Silver	Bajaj RE	fd830456-cb36-4beb-8161-88ff43e7f92c	CLEAN	19942833610	Nadun Jayawardena	+94715029208	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
75466d0e-1255-40cd-9242-9e365e60de4e	WP ACC-9910	CHASSIS00000051	White	Bajaj RE	96a9f321-f1b1-47d6-9c6c-2d33907463c4	CLEAN	125254470V	Iresha Silva	+94725557350	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
e15c0287-f490-4108-a5d7-81622c175bc1	WP ACD-3665	CHASSIS00000052	Green	Bajaj RE	2c70372c-3784-401b-bc3c-af284221d946	CLEAN	19985499615	Suresh Wijesinghe	+94716314873	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
e762b4dc-0d94-4539-aa6c-00867ca4b122	WP ACE-1656	CHASSIS00000053	Green	Bajaj RE	59007c53-e041-47bd-843c-5c6bce7e6c42	CLEAN	737702704X	Pavithra Mendis	+94742160380	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
e488131f-b503-4107-bb2b-374ab3b1823c	WP ACF-2235	CHASSIS00000054	Orange	Bajaj RE	6b1a0963-4744-41af-9cab-142d5c1d6087	CLEAN	19805278196	Janaka Liyanage	+94775664746	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
5dc9afaa-85e5-4166-afb6-247b8ef8650b	WP ACG-9073	CHASSIS00000055	Green	Bajaj RE	ec990a4f-b222-4265-bcbf-d74d7e4e26b6	CLEAN	881533676X	Gayan Dissanayake	+94772176496	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
6c37ff95-4b25-45c3-baf5-f7710f1c67cc	WP ACH-5486	CHASSIS00000056	Red	Bajaj RE	21de8142-93e0-466e-b8d4-01c2d3af0f4a	CLEAN	19993956927	Sandya Kumara	+94762298945	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
fc8c2672-e860-41c1-8ab6-80d722280afa	WP ACJ-9832	CHASSIS00000057	Silver	Bajaj RE	fe9cca41-c237-4f8e-b580-3f74d12c48b3	CLEAN	257873060X	Pavithra Herath	+94722766687	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
4d0b8854-6501-461d-9cef-f84683c8299d	WP ACK-1003	CHASSIS00000058	Yellow	Bajaj RE	1ebfd472-6748-4e1f-9b10-dce2dc962a64	CLEAN	19722579459	Chathurika Amarasinghe	+94774725824	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
284f7e92-b0d9-4939-891c-c8288d31963a	WP ACL-3976	CHASSIS00000059	Red	Bajaj RE	c0d8c348-3d88-4f8d-8a7e-82c15aff67ab	CLEAN	283272831V	Dilshan Seneviratne	+94749258860	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
c8f5d487-f9df-492d-8adc-1ca93969f3c3	WP ACM-7341	CHASSIS00000060	Blue	Bajaj RE	caa25511-0e22-44d5-986b-8771e30ad343	CLEAN	19903602142	Sachini Madushanka	+94757573835	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
2cf9d019-660d-4e6e-8785-4019c809e993	WP ACN-3600	CHASSIS00000061	Red	Bajaj RE	38a6c8d4-4a4c-4874-b20a-840f533f9996	CLEAN	570183319V	Gayan Wickramasinghe	+94774326273	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
4c01ff7e-e1c8-4fd8-b6f9-348cae9c81da	WP ACP-9774	CHASSIS00000062	Yellow	Bajaj RE	27ee3a4e-f087-4690-ba62-3a3f9acecac7	CLEAN	19763051260	Menaka Jayasuriya	+94754345090	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
42b87382-2f06-4aca-afef-a3c4c240beda	WP ACQ-3503	CHASSIS00000063	Green	Bajaj RE	c5a77c8f-6600-4257-a309-da84a5a75261	CLEAN	453176449X	Malith Silva	+94724579112	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
802cac38-69f9-4a05-b372-50c67db47948	WP ACR-7885	CHASSIS00000064	Red	Bajaj RE	de1b41cc-09ae-4a7e-819a-3ea7c4121aa5	CLEAN	19915425335	Roshan Abeysekara	+94717276798	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
dc22eeb2-987f-4e82-9410-1c613cc1702f	WP ACS-5180	CHASSIS00000065	Blue	Bajaj RE	c24a2ac8-aeba-40a0-a434-7beff37d7309	CLEAN	469831697X	Harsha Perera	+94781774464	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
a5d604c2-9381-4e75-8f62-26c77fc1de20	WP ACT-6951	CHASSIS00000066	Orange	Bajaj RE	bd521e0b-6590-4674-a486-df629edd70ef	CLEAN	19714956103	Isuru Jayasuriya	+94761448291	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
f051f7b0-9bef-43d6-9d5a-bfe39d527740	WP ACU-7234	CHASSIS00000067	Red	Bajaj RE	818d38cf-3576-4c31-b9a8-820e42ae117f	CLEAN	381084004X	Pavithra Perera	+94713600444	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
5915610b-d402-45cc-b027-b757dbbd85c3	WP ACV-4217	CHASSIS00000068	Blue	Bajaj RE	01b3e725-c391-443f-b0cf-377b53403124	CLEAN	19854346776	Pradeep Fernando	+94786632408	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
d770fdd0-a34c-4429-8a44-6e68a224c470	WP ACW-7599	CHASSIS00000069	Yellow	Bajaj RE	79c2c40a-8f0b-4de5-a3bf-dc3f917e40fd	CLEAN	827751402X	Saman Senanayake	+94769630619	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
c469c9ea-401d-4c81-8a48-e9e6c41daa32	WP ACX-5437	CHASSIS00000070	Silver	Bajaj RE	610118f4-dce8-409e-9b84-37c5a125fd5b	CLEAN	19866934188	Gayan Kumara	+94714012401	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
ea67f291-0f4f-4593-88af-91e40c9b685b	WP ACY-6189	CHASSIS00000071	Red	Bajaj RE	da529d7c-f732-4a60-9328-70ebf8db1a32	CLEAN	482755796X	Asanka Amarasinghe	+94711474064	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
2db395bc-f073-4d99-842e-d75de8e638ce	WP ACZ-4306	CHASSIS00000072	Silver	Bajaj RE	28dedf3e-72ac-42f9-9295-f4c13a8dbcc6	CLEAN	19789229310	Saman Ranasinghe	+94712277247	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
10995f57-84b2-4ceb-94da-b089bb26b0e7	WP ADA-7953	CHASSIS00000073	Silver	Bajaj RE	d8910789-098c-4720-8729-6ba4778b1dbb	CLEAN	732069463X	Ruwan Perera	+94769590597	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
a3234437-aec2-4402-94e2-3aaa12150d12	WP ADB-1440	CHASSIS00000074	Red	Bajaj RE	69f2d820-7093-40a7-a9c2-067d398fead1	CLEAN	19929593606	Lasith Fernando	+94775472709	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
629513a7-5641-40e8-97d4-53c677284e6f	WP ADC-5045	CHASSIS00000075	Yellow	Bajaj RE	977bd81b-c1aa-46ad-bdb1-0e5a19291104	CLEAN	485473162V	Sewwandi Jayawardena	+94766107702	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
428f69fd-c59c-419e-a8fc-5b3ffe009468	WP ADD-2059	CHASSIS00000076	Green	Bajaj RE	f3432648-ee15-4cd1-88dc-d603ff924dc6	CLEAN	19855407833	Kumari Madushanka	+94743293181	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
298be5b5-e3a5-49cc-9174-e14c27f4abf0	WP ADE-6215	CHASSIS00000077	Blue	Bajaj RE	60a957c2-13c0-4688-9933-0e423ef0cb19	CLEAN	608982731V	Kamal Gunasekara	+94749396004	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
0fa24134-8246-4519-86e6-9f4426bdbdde	WP ADF-6109	CHASSIS00000078	Orange	Bajaj RE	9410a4e5-e2e9-4441-ad76-ee568d21ccc7	CLEAN	19801848105	Upul Rajapaksa	+94755064047	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
512f2360-92c4-4a6e-afc8-dc31d3e7e57a	WP ADG-7753	CHASSIS00000079	Blue	Bajaj RE	5a77f2eb-fcab-42f9-8c68-cb7aa8ead458	CLEAN	952368970X	Nadeesha Herath	+94747231281	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
a41de643-69fc-4409-a670-df95fce8f30a	WP ADH-5167	CHASSIS00000080	Green	Bajaj RE	7e99dbbc-e163-4810-b89e-5f35c7073252	CLEAN	19825966383	Nuwan Ranasinghe	+94781459149	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
b96d0c39-4d97-495f-a886-ba42c5d6e1c8	WP ADJ-9763	CHASSIS00000081	Yellow	Bajaj RE	242dae6e-1bea-41cf-80fb-39006708e9f1	CLEAN	406883208X	Kumari Pathirana	+94755546412	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
7312e895-7ede-4702-977c-e403ab01fee8	WP ADK-5768	CHASSIS00000082	Blue	Bajaj RE	2af9a107-70c8-49ff-ad43-cc9756618eb1	CLEAN	19735844209	Roshan Jayawardena	+94715253626	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
2c2d0741-480c-488b-8c6a-f8b0a454332c	WP ADL-8161	CHASSIS00000083	Green	Bajaj RE	d2b13ff4-2eed-488a-b1d5-26e4c2c55713	CLEAN	990460460X	Buddika Pathirana	+94716815216	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
7604a356-9edc-4c85-8805-471f78b9e456	WP ADM-8732	CHASSIS00000084	Silver	Bajaj RE	0a9f48f5-6368-4024-87f2-31bfefa98773	CLEAN	19759668545	Asanka Mendis	+94727179485	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
0dcde964-d2c8-4699-8b58-eb8d8adbefb8	WP ADN-5556	CHASSIS00000085	Orange	Bajaj RE	3889a5a7-2edf-4c30-a8fd-1adb10dbea34	CLEAN	499035176X	Dhanushka Gunaratne	+94746476077	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
2b42e1be-3776-4663-8a4c-a77ed7da825b	WP ADP-5424	CHASSIS00000086	Silver	Bajaj RE	de9b4097-d816-4e4c-82df-fd7ed62ae0c5	CLEAN	19799002085	Sewwandi Herath	+94752749083	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
324f551f-280c-4ff3-85a1-cd6e7fc5a88b	WP ADQ-4445	CHASSIS00000087	Yellow	Bajaj RE	d5143086-e98c-4e6d-851a-927a9e44bc7e	CLEAN	815379940X	Thilak Amarasinghe	+94742363915	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
19cd9b15-3b8d-49dd-8ada-6c2547a81126	WP ADR-4946	CHASSIS00000088	Blue	Bajaj RE	5b2fef93-9ba1-4a60-a25f-dd9effe6a000	CLEAN	19723069502	Thilak Weerasinghe	+94744958323	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
b678f4f1-c0e1-43c7-bddf-85cdd12d783c	WP ADS-9750	CHASSIS00000089	Orange	Bajaj RE	c1e94af5-9696-43dd-b7b6-924158fa6c4d	CLEAN	323265414V	Shehan Madushanka	+94781984187	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
692a4a75-876a-4d8f-b38f-e673689c77a1	WP ADT-5723	CHASSIS00000090	Yellow	Bajaj RE	d6c14301-a67a-4804-aff9-d898272f9154	CLEAN	19825296583	Prasad Liyanage	+94767505094	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
63b1b5bb-33e0-4705-825e-529a2a2ecf7b	WP ADU-6659	CHASSIS00000091	White	Bajaj RE	789c4623-46c1-4504-94b2-f1dde0f48306	CLEAN	884580291V	Saman Jayawardena	+94712198701	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
24f0b10d-445d-4d6e-888f-dcdb1df879dd	WP ADV-2310	CHASSIS00000092	White	Bajaj RE	fcfae0ae-8363-473b-b8fd-5a85393a8af6	CLEAN	19987514432	Mahesh Bandara	+94722437318	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
c1b4404f-f86d-4576-b1c1-84c33c781c11	WP ADW-5728	CHASSIS00000093	Green	Bajaj RE	d3a3892b-7670-4e24-a32f-27c8332a4243	CLEAN	693961796V	Rashmi Liyanage	+94789948076	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
54c989e5-fb77-4d7c-bd2b-8bdb929e3fd3	WP ADX-6125	CHASSIS00000094	Red	Bajaj RE	97ef07d3-881e-4b17-8cfb-8c730e38ab68	CLEAN	19847900394	Anusha Pathirana	+94752780422	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
745a0cd2-2ca4-44a9-9fd5-8bd6e215dd21	WP ADY-2900	CHASSIS00000095	Blue	Bajaj RE	2e555318-b63d-44b2-84f9-a72191a1042e	CLEAN	129850629X	Buddika Jayawardena	+94782280415	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
eaeaa9a3-fb41-44a5-bf43-2e80e3cee82d	WP ADZ-4354	CHASSIS00000096	Yellow	Bajaj RE	c36906a2-1f85-416c-9990-192b85b5f8c8	CLEAN	19907888800	Chathura Madushanka	+94712553299	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
ca54cb3a-6cc6-4570-894b-c8eadb541d1d	WP AEA-4295	CHASSIS00000097	Silver	Bajaj RE	0935c6e8-5831-41d2-8e0d-9eab30c2d08d	CLEAN	837157881V	Upul Jayawardena	+94785030133	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
4addc032-8424-475e-84b9-4fbe5bca80c1	WP AEB-9901	CHASSIS00000098	Silver	Bajaj RE	a359fed1-6146-4ec8-b84a-daeda93536df	CLEAN	19829396864	Buddika Wijesinghe	+94763175322	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
9809289b-e054-46c8-b588-b4d98813f228	WP AEC-1911	CHASSIS00000099	Silver	Bajaj RE	c8d0cf43-f0df-49f9-bcbc-2ebe117b1533	CLEAN	905430187V	Roshan Bandara	+94757503078	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
f202229b-639c-4c6a-98d4-44da962a1a74	WP AED-6158	CHASSIS00000100	Orange	Bajaj RE	23ac3055-b384-41c5-8d26-0e4313821a23	CLEAN	19946568079	Ruwan Fernando	+94717162793	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
5f370399-ec26-48bd-b8a3-26e2e16a4653	WP AEE-4621	CHASSIS00000101	Red	Bajaj RE	fe640f68-4e75-4b6e-bcf9-03528bdc0ef4	CLEAN	198649138V	Janaka Mendis	+94741961270	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
fce3ab52-0706-4818-af4f-f5ac030b7d05	WP AEF-1614	CHASSIS00000102	White	Bajaj RE	bd161d57-ac4b-4e28-8190-98290843e1a2	CLEAN	19718442038	Hirantha Wickramasinghe	+94785945004	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
bc4190f0-beda-40af-9308-69382ea91e61	WP AEG-9400	CHASSIS00000103	Silver	Bajaj RE	d332ad49-c8e4-48e5-a1b9-9fb28c78327d	CLEAN	227186547V	Dhanushka Jayasuriya	+94787302292	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
55775dbf-71e8-49fa-8af1-5c801ffc81c9	WP AEH-9612	CHASSIS00000104	Green	Bajaj RE	e678b9cf-d267-49e8-91b8-4d36455f9895	CLEAN	19898756486	Gayan Weerasinghe	+94788696704	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
47d3af92-d6b1-434b-8a09-cea86304ce8c	WP AEJ-1706	CHASSIS00000105	Yellow	Bajaj RE	efbb51ac-f60f-48be-bef9-0ef09e1cf36d	CLEAN	811736263V	Suresh Silva	+94726837638	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
34e687b6-0f5d-4dcd-b96b-f39d31f5adff	WP AEK-8416	CHASSIS00000106	Green	Bajaj RE	886e9c0b-ef8b-4dde-b2de-f1d0d96f2e2b	CLEAN	19871579386	Kasun Weerasinghe	+94749548945	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
10b97ee6-8814-4fa0-b672-98c182984467	WP AEL-2117	CHASSIS00000107	Orange	Bajaj RE	aa751928-af9f-4ee4-b51a-1cd061e9b744	CLEAN	751443374V	Dilshan Fernando	+94723707563	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
80f938c6-87e6-458d-abdc-e42be53fca72	WP AEM-8285	CHASSIS00000108	White	Bajaj RE	4e9f32ad-148f-456e-b6b5-3e9be728e1c1	CLEAN	19781224760	Sandya Perera	+94715521367	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
9421289a-d37f-437d-8bb8-99575db8ffee	WP AEN-7418	CHASSIS00000109	Silver	Bajaj RE	dfa1c955-58e4-4669-ad30-ee77621d03e8	CLEAN	562731188V	Nimal Perera	+94721965239	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
cf56c873-9517-40be-9a3a-6d23c2c706c5	WP AEP-6048	CHASSIS00000110	Orange	Bajaj RE	e2fd93a7-2713-4cb0-ab85-563f437c5787	CLEAN	19926481476	Chathura Seneviratne	+94743788814	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
6631119b-fc96-4e46-885e-1c4cef7612f3	WP AEQ-5875	CHASSIS00000111	White	Bajaj RE	7853da2b-21d7-4e49-af9e-25f2219422d4	CLEAN	178742341X	Isuru Senanayake	+94773151813	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
c02ee98a-0d31-4703-970f-dda2c4df7058	WP AER-1393	CHASSIS00000112	Orange	Bajaj RE	25133fbc-a896-44a7-a645-477118d602c1	CLEAN	19716015650	Prasad Gunasekara	+94749802176	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
a2979ddf-f82c-498b-844e-973d61ccdece	WP AES-2711	CHASSIS00000113	Red	Bajaj RE	eadaddfd-d567-484f-a9ed-d80a1ee5b312	CLEAN	897681953V	Iresha Gunaratne	+94788612570	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
9fe37e47-1e14-476d-a69e-33414b14302a	WP AET-1573	CHASSIS00000114	Red	Bajaj RE	93b394bc-bbab-4b3b-ac4c-8f9d66901704	CLEAN	19889985945	Iresha Abeysekara	+94761533278	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
b6a8688b-c3b5-4617-a268-95937d7fc5a5	WP AEU-9247	CHASSIS00000115	Yellow	Bajaj RE	26366306-2fe4-482d-ada4-206630795dca	CLEAN	752256885V	Pavithra Rathnayake	+94711390518	4d9c7738-60cc-4202-9277-2ed9b7dc7aa7	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
0970a16f-88f6-4d3c-a81d-0e1cd82dad54	CP AEV-4432	CHASSIS00000116	Silver	Bajaj RE	536f0ce0-defe-4584-b9f0-c7b13535cc72	CLEAN	19749356380	Sewwandi Dissanayake	+94763516029	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
310d37e1-27b3-4370-92a5-4153c3a44d57	CP AEW-6153	CHASSIS00000117	Red	Bajaj RE	d9c62518-4c03-455d-9738-43f149991b8b	CLEAN	649872816V	Saman Perera	+94714593659	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
129fa5e8-9f14-4107-b9ac-c7497ac7f528	CP AEX-7060	CHASSIS00000118	Red	Bajaj RE	2990e87b-8411-46f0-8668-326e55e981d8	CLEAN	19843540436	Buddika Jayasuriya	+94728468171	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
ee6c1813-3561-45e7-a7fc-5a57c853d72c	CP AEY-8913	CHASSIS00000119	Orange	Bajaj RE	84e1116c-bff2-4f88-9b2c-43c50bd26ad4	CLEAN	485175319V	Malith Wijesinghe	+94767911619	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
b3512e30-b16d-4344-8070-93fc9e41d771	CP AEZ-7954	CHASSIS00000120	White	Bajaj RE	1ddc385d-5510-4ba3-bb9c-4c1a2193bbdc	CLEAN	19705926871	Janaka Bandara	+94785459076	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
ebb93ff5-d112-4fbc-9364-49737991f054	CP AFA-6170	CHASSIS00000121	Silver	Bajaj RE	d4b52cbc-9dce-4bd5-b6f8-c65a49905f0a	CLEAN	191124981X	Malith Wijesinghe	+94769844735	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
f5f86250-7093-4024-9916-d38794a81d79	CP AFB-2888	CHASSIS00000122	Yellow	Bajaj RE	f96e3763-2062-460f-b949-3e3496123e07	CLEAN	19714259598	Pradeep Wickramasinghe	+94717051563	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
5c7aac3a-1cdb-4b39-90c0-849c41909815	CP AFC-4617	CHASSIS00000123	Yellow	Bajaj RE	29572832-e83d-43c2-ad0e-b5e5118c0cad	CLEAN	262925433X	Kamal Bandara	+94771355183	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
404c75ec-0964-4e28-953a-0abe85b029b6	CP AFD-5328	CHASSIS00000124	Orange	Bajaj RE	7295535d-eeff-44db-b9b3-637f4de3d384	CLEAN	19967478282	Sandya Gunaratne	+94773010943	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
75324daa-55ac-4cdf-8966-69dc2e3c9a7e	CP AFE-5167	CHASSIS00000125	Orange	Bajaj RE	1283c95a-cf06-47d7-a46f-865d5cdf6047	CLEAN	988548012X	Nuwan Madushanka	+94751873975	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
c169a45f-6256-469a-8861-3d228a5ee68a	CP AFF-9820	CHASSIS00000126	White	Bajaj RE	1230be6e-4711-4718-8f45-183330faf394	CLEAN	19826919732	Sachith Ranasinghe	+94769279260	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
75051b0f-eb2b-4030-9e6a-32843fa692ea	CP AFG-2400	CHASSIS00000127	Orange	Bajaj RE	51abe37c-40fc-4761-9830-ba46501cc6aa	CLEAN	952106938V	Kasun Bandara	+94741768539	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
24f5e3c5-7385-4bd3-8ed1-948be7c5ea5f	CP AFH-9134	CHASSIS00000128	Silver	Bajaj RE	8b2d8f86-3753-4919-ac3e-50df82cb2bd4	CLEAN	19752442820	Dilini Pathirana	+94743708355	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
328a1d8b-caf3-46ba-a469-adc7cf7c7400	CP AFJ-9703	CHASSIS00000129	Orange	Bajaj RE	a5d48693-0456-4f22-881f-a6fdd0106133	CLEAN	471677121V	Asanka Dissanayake	+94782623541	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
2b218493-3b6e-476f-83cd-fd408cb4418a	CP AFK-8217	CHASSIS00000130	Silver	Bajaj RE	29d1e5de-0e34-438f-a1cb-ee642c0e1d69	CLEAN	19772895924	Nuwan Dissanayake	+94775389268	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
9f9e2703-f29e-4617-9e74-924b713e65e4	CP AFL-8029	CHASSIS00000131	Green	TVS King	a461261d-ae0d-4e13-8a83-70e71852a970	CLEAN	819684547X	Sewwandi Amarasinghe	+94745133166	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
edab61ec-41cf-4d08-8e0a-44bc1c1162bf	CP AFM-4990	CHASSIS00000132	Yellow	TVS King	f6eab525-83d4-4429-b8fd-33abf64b3b68	CLEAN	19816586072	Nimal Amarasinghe	+94783247660	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
823e7d68-ed90-47ba-854e-9a9e4ee04ff8	CP AFN-6059	CHASSIS00000133	White	TVS King	ee9d9c65-6ffb-4160-8284-1839a4c0393f	CLEAN	914122046X	Malith Rajapaksa	+94779967445	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
d4bde635-9155-4ba5-9126-29929b53ca2c	CP AFP-1774	CHASSIS00000134	Blue	TVS King	e3b8088e-8bc6-4272-9bbd-4a59bec3a783	CLEAN	19956149390	Shehan Amarasinghe	+94782735745	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
1128d72e-1362-4cef-874a-eb9d5ec4c490	CP AFQ-9648	CHASSIS00000135	Orange	TVS King	f5657bba-f5d3-43e2-9d87-3f2ff2cf4952	CLEAN	724858321V	Asanka Abeysekara	+94767739422	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
0bd0996e-85d6-43ee-b1c2-3a9a2aa58b4e	CP AFR-6998	CHASSIS00000136	Red	TVS King	a2fa64ac-1780-404c-9128-e03f2445d69a	CLEAN	19864786498	Iresha Jayawardena	+94782674203	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
f6cd2743-e78f-47bd-97a6-f511da8f2903	CP AFS-5811	CHASSIS00000137	Blue	TVS King	8f8f5410-7aa5-4778-a81d-b581f25a6057	CLEAN	208614517V	Sachini Pathirana	+94761644519	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
53ad3e18-fbd8-4e5d-a680-bca58c75d2f4	CP AFT-2485	CHASSIS00000138	White	TVS King	10193f12-4b79-414c-804a-0ff4a6363f12	CLEAN	19816328987	Kamal Wijesinghe	+94721216194	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
9ed88513-ab24-49e1-90c3-030959b546ac	CP AFU-1475	CHASSIS00000139	Orange	TVS King	ad6db971-ca6e-4bda-9b80-a9377df6d0e2	CLEAN	701445881V	Menaka Liyanage	+94717499280	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
1534d62e-28e5-41aa-b629-44739968819c	CP AFV-2852	CHASSIS00000140	Orange	TVS King	63d72cc4-5b4f-40c4-9303-983cb00f87cf	CLEAN	19864514940	Sewwandi Pathirana	+94723210120	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
f76decfd-4c9c-4dd9-847d-1b87855e9bc3	CP AFW-1777	CHASSIS00000141	Blue	TVS King	188b2371-3b90-4877-89b7-a39972bcfbef	CLEAN	185962595V	Nadun Jayawardena	+94751551404	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
2f08a554-3dd0-45ae-9850-0c7dbbc4b6e3	CP AFX-9593	CHASSIS00000142	White	TVS King	a433ce1e-544f-4f5a-8fc9-cceb4ba90f57	CLEAN	19913188869	Chamari Herath	+94716754357	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
4553beee-d98d-4d0c-91fc-3cb126734d09	CP AFY-5606	CHASSIS00000143	Red	TVS King	ca32b681-be4d-4bc0-a222-53fb5aaab0a1	CLEAN	261829410X	Nuwan Rajapaksa	+94723410432	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
35759c17-bbfb-496f-9802-83ecce1a066e	CP AFZ-8156	CHASSIS00000144	White	TVS King	e948a2e5-608d-4aa8-a1b8-6c8ee35f6603	CLEAN	19852013398	Isuru Abeysekara	+94774813672	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
2c5e010d-eb0d-409d-9c2b-4e51a2f867db	CP AGA-4127	CHASSIS00000145	Yellow	TVS King	a95936d0-1af9-4b66-b439-4868f3a2d51e	CLEAN	849848207X	Ruwan Silva	+94783357898	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
f7be1845-1e0c-474d-802c-437108d31791	CP AGB-7814	CHASSIS00000146	White	TVS King	5ba3a5a9-71dc-4bd2-a523-0d31d3e71c6e	CLEAN	19863396472	Gayan Kumara	+94785460277	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
10fcfa9a-8a24-4a26-a24d-2f2dd2cebd84	CP AGC-1863	CHASSIS00000147	Red	TVS King	1620c5eb-97d6-4e01-ba8c-ec41958269f9	CLEAN	894500088V	Thilini Perera	+94787544601	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
20c2b244-4402-4249-a97f-681d857af1a6	CP AGD-9327	CHASSIS00000148	Orange	TVS King	2925aa8d-0982-49a0-8928-ac94ccca0949	CLEAN	19887491591	Shehan Weerasinghe	+94755384303	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
438c114c-357f-4525-9b45-89b0d085ebf7	CP AGE-1354	CHASSIS00000149	White	TVS King	82535d38-b657-41fe-b894-b22af55dee24	CLEAN	908673887V	Roshan Kumara	+94776991155	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
b083e06d-c8ba-4037-9d32-8ad3f4e26b95	CP AGF-2235	CHASSIS00000150	Yellow	TVS King	9c238062-a527-45a5-8df2-b2167cf5bc7a	CLEAN	19772972682	Dilini Kumara	+94784483014	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
8ca85d1b-ec94-4aff-af73-9e0e5d772dc4	CP AGG-4154	CHASSIS00000151	Red	TVS King	a89b3d3e-9ea1-4cec-aab5-9de7d43de390	CLEAN	527067891X	Chathura Liyanage	+94761661152	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
8476e7f0-5495-4645-a4ba-6a1ec132be29	CP AGH-9715	CHASSIS00000152	Silver	TVS King	b3400ec8-0ea2-473a-a281-a618ffe8849b	CLEAN	19857570190	Saman Liyanage	+94749883681	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
2124e824-ab87-4958-8d13-5252311f878b	CP AGJ-2528	CHASSIS00000153	Red	TVS King	2d4c5123-a912-49ad-a9a1-0b0d5c9b4831	CLEAN	956271145V	Buddika Perera	+94727960397	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
31e4af9c-2ddc-443e-ba41-fe7de162bc4b	CP AGK-5050	CHASSIS00000154	Green	TVS King	fae27ede-ceb9-4cee-b4aa-17b23b56623a	CLEAN	19769082587	Saman Rathnayake	+94729683403	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
29e36097-7941-4c56-b4b0-f7b00d0a6127	CP AGL-2543	CHASSIS00000155	Red	TVS King	18717aad-2c45-471e-9d32-a90d359809d8	CLEAN	747886769X	Rashmi Kumara	+94779713802	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
8b715852-af9b-4714-ac51-4ef97c170d64	CP AGM-7913	CHASSIS00000156	Blue	TVS King	f052b81d-d705-434f-9d50-78104c8622d3	CLEAN	19758958134	Nuwan Jayasuriya	+94727324839	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
bffd3eee-460e-4b38-bf15-722054069c47	CP AGN-4479	CHASSIS00000157	Red	TVS King	a6755b7c-6a83-468a-9c45-a9e19ab0ca54	CLEAN	901743256V	Menaka Wijesinghe	+94713010638	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
a44d5266-451b-458e-88ee-d08b732599c3	CP AGP-4581	CHASSIS00000158	White	TVS King	db112d9c-ed83-4de0-8027-d7a8cb5cd1bc	CLEAN	19967951747	Menaka Gunasekara	+94764097450	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
29d0064b-48d5-46f0-a375-edff09aeb5b3	CP AGQ-6509	CHASSIS00000159	Orange	TVS King	982a88ea-5cdc-4e84-b476-1c9146a1cba1	CLEAN	414729305V	Shehan Perera	+94718954938	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
b9f95bd8-71d4-4d59-bd79-1fee0eccac7e	CP AGR-5269	CHASSIS00000160	Orange	TVS King	3db00920-626c-420d-8bf5-cfb24e5bb61c	CLEAN	19981227531	Mahesh Ranasinghe	+94751415220	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
22485013-8f84-457d-869e-b812516e59b4	CP AGS-6507	CHASSIS00000161	Silver	TVS King	a48f9b6e-7d94-4f3f-872f-d5f27d99fd52	CLEAN	662532965X	Buddika Rajapaksa	+94766162602	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
6d7563ca-45ec-4286-841e-a5e80aa67051	CP AGT-7543	CHASSIS00000162	Orange	TVS King	f0f2154b-c194-43cb-9c56-727683b23509	CLEAN	19914785014	Shehan Abeysekara	+94718553409	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
12c9b87d-2553-415c-8747-8bbd6dec9353	CP AGU-9308	CHASSIS00000163	White	TVS King	58b78b3e-d7ee-44f7-a774-c4cb33941a95	CLEAN	568417020V	Sewwandi Rajapaksa	+94785153417	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
c706336e-c0a0-416f-a9d8-629137d7aeec	CP AGV-2370	CHASSIS00000164	White	TVS King	ab2bdf81-0e9b-4ca0-99e4-b1e64507db60	CLEAN	19807763511	Chaminda Kumara	+94762437679	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
c5a4dd26-af3c-4e7e-af5d-cdddc5eb1191	CP AGW-1756	CHASSIS00000165	Red	TVS King	8706dec4-7afd-4651-a12c-5b21985197bb	CLEAN	437477033V	Nadun Weerasinghe	+94754142039	f799c375-84e9-40e0-82af-42de97f32e21	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
9b618c42-beb1-49cd-9882-94ac22fa4b86	SP AGX-9622	CHASSIS00000166	Blue	TVS King	f569076c-8b7b-4190-8118-2cc43abe5f2a	CLEAN	19754480485	Sachini Perera	+94768756720	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
aac0e1e8-0df8-45ca-8b38-08a77604ffdc	SP AGY-7103	CHASSIS00000167	Blue	TVS King	0b78bab5-5201-4b66-9a68-ab3ef633843b	CLEAN	342566917V	Pavithra Ranasinghe	+94759335850	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
7cf11abd-6e61-4939-b6d2-d391a8f01d8e	SP AGZ-5998	CHASSIS00000168	Green	TVS King	b88ab023-96bb-4ac1-8d93-08b751ce592f	CLEAN	19895905050	Thilini Wijesinghe	+94779165205	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
91e1f494-b347-4573-8c0f-eb7e1340ee42	SP AHA-3273	CHASSIS00000169	Yellow	TVS King	9bae228b-0cc7-413e-82f2-0a90cb05b164	CLEAN	342356495X	Nuwan Silva	+94742349742	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
d8d44e07-6de3-4ef0-8ba0-84928ac95395	SP AHB-4549	CHASSIS00000170	Blue	TVS King	c4330e64-aa7f-4d13-bdcd-9775c120d9b0	CLEAN	19897704591	Hirantha Wickramasinghe	+94754857204	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
18ac23f8-a4ab-4979-b69d-2181cd23ffec	SP AHC-5061	CHASSIS00000171	Silver	TVS King	84a7bdd1-3047-462d-b860-89a6f259885f	CLEAN	339244262V	Kumari Weerasinghe	+94744831615	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
c2de6415-772f-44be-a71a-7183e1602950	SP AHD-4502	CHASSIS00000172	Blue	TVS King	025b258b-47ee-46bb-9163-aca3eed50160	CLEAN	19969715356	Buddika Mendis	+94756361511	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
846ebd88-cbc1-4a9c-8d2e-d2e212131568	SP AHE-5513	CHASSIS00000173	Red	TVS King	277a6632-1dd7-44df-bb84-b4016795f145	CLEAN	796474739V	Thilini Kumara	+94744220062	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
7e6f2e95-a575-4dbd-b0fa-09c4c456def9	SP AHF-5665	CHASSIS00000174	Orange	TVS King	9066eb94-d3ff-412a-bc2c-8f821e696cb6	CLEAN	19825410684	Chathurika Pathirana	+94748242340	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
db51322e-99a5-4aeb-b12f-8f4bfab67a4e	SP AHG-2425	CHASSIS00000175	Green	TVS King	7b10e422-2dc8-4ff5-a46b-17e9dee3ab21	CLEAN	697997162X	Janaka Bandara	+94782953414	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
7b532441-2bca-42c3-a5d8-a189a343a54f	SP AHH-1273	CHASSIS00000176	Yellow	TVS King	100af612-e02d-47cb-900d-ba94831f7d20	CLEAN	19941366088	Lasith Jayasuriya	+94754429089	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
c8e8c60a-9bec-4738-ad64-d4de1fbf24b1	SP AHJ-7416	CHASSIS00000177	Silver	TVS King	f556f730-e494-44ef-bda6-e1d4ebb580fb	CLEAN	929513184V	Roshan Fernando	+94776675582	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
537da42e-088e-4011-a038-28050ce714d8	SP AHK-3582	CHASSIS00000178	Green	TVS King	6483c3ea-afa4-4d0b-8686-7f11bbafce30	CLEAN	19946422052	Mahesh Rajapaksa	+94764760443	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
a4b3f9af-130f-4389-8b48-71d982674053	SP AHL-1018	CHASSIS00000179	Orange	TVS King	092325eb-0a76-441a-9e4f-25848a9f5a8a	CLEAN	512918577X	Chathurika Jayasuriya	+94758721317	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
6ee6ebdb-c750-4691-97e1-29fd22f930a0	SP AHM-5994	CHASSIS00000180	Yellow	TVS King	f7019fc3-d156-4821-bd97-ed396d09cf38	CLEAN	19713006426	Dhanushka Wickramasinghe	+94755872110	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
00bb68e0-db1a-4af3-88b4-4cc9cd9c7681	SP AHN-8635	CHASSIS00000181	Orange	Bajaj RE 4S	79729dae-c482-41b2-b54d-6d4c14555fb7	CLEAN	949177855V	Menaka Rathnayake	+94769478966	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
efefdfb2-d268-4d8a-9442-95d9f311e546	SP AHP-8629	CHASSIS00000182	Yellow	Bajaj RE 4S	c071febf-0b25-4b8a-a126-8212ce0f9f99	CLEAN	19734187372	Chathura Wickramasinghe	+94729976657	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
e98086f7-9246-4e31-847f-ccce14a6f918	SP AHQ-2199	CHASSIS00000183	Green	Bajaj RE 4S	8ad7a164-1688-4a4e-a4a0-ef183ae17e46	CLEAN	499269407X	Gayan Madushanka	+94759751115	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
ca6f7156-33a7-4536-ade3-e8c9e126373c	SP AHR-6943	CHASSIS00000184	Green	Bajaj RE 4S	ce883bd4-b01d-4ac5-be0b-f2356823c102	CLEAN	19988141196	Pradeep Dissanayake	+94745562850	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
9426453c-fb55-4108-85e5-c9bb5c41a49e	SP AHS-9384	CHASSIS00000185	Silver	Bajaj RE 4S	e073632d-aac8-4cb8-8d1e-7716a516081e	CLEAN	193797674X	Rashmi Herath	+94768308382	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
cb17ccf3-b970-4b45-8dc7-e8e7753de242	SP AHT-7536	CHASSIS00000186	Blue	Bajaj RE 4S	30fdb417-2a57-40e6-ac8a-61a9d1160640	STOLEN	19816110465	Dilshan Wickramasinghe	+94712717280	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
e4bd72d3-04de-4892-9fee-d3c6c1474bc2	SP AHU-2155	CHASSIS00000187	Red	Bajaj RE 4S	142476b4-3208-4de8-a591-ef3e1f8e4e6b	STOLEN	875551265X	Dilshan Ranasinghe	+94753363955	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
08fa90d3-0b8a-4a15-a774-aa8d0016f6b7	SP AHV-3309	CHASSIS00000188	Blue	Bajaj RE 4S	74869bfe-64f8-48e1-9ae3-d923ab85d8c7	STOLEN	19785501256	Sewwandi Ranasinghe	+94713442571	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
0907c3fd-8481-4752-8f69-4612e955c346	SP AHW-4781	CHASSIS00000189	White	Bajaj RE 4S	35a6757d-f3ce-4eb2-9d45-22c4ebd7061b	STOLEN	128738704V	Nimasha Liyanage	+94789561839	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
2a09700e-f49b-453d-9b81-78a751460ac4	SP AHX-4216	CHASSIS00000190	Orange	Bajaj RE 4S	6aa2e93c-6b18-4a22-91c5-627f22e0b9ed	STOLEN	19863302147	Lasith Madushanka	+94772569653	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
ae6a7a54-5b10-4023-8ace-d64b7c0f5d19	SP AHY-2072	CHASSIS00000191	Red	Bajaj RE 4S	9d6d04b4-b9a5-4e56-a466-f41336013575	STOLEN	906311956X	Kamal Liyanage	+94729981844	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
a21e9b1b-8ce5-4b26-8b2a-f1f323fd336c	SP AHZ-9159	CHASSIS00000192	Green	Bajaj RE 4S	f6c17e3d-11d5-4464-9f4f-fe34060738cc	STOLEN	19723430673	Saman Amarasinghe	+94749918363	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
9f98f931-8572-4cc4-8adf-ae25621c0642	SP AJA-1650	CHASSIS00000193	Blue	Bajaj RE 4S	72a2a688-0618-4b1b-a92d-e59ff30cb21a	STOLEN	910489331V	Tharaka Madushanka	+94746312159	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
17922d5d-5909-4157-821d-1773ab8b15d4	SP AJB-8588	CHASSIS00000194	Orange	Bajaj RE 4S	ff1e394a-bfc1-4624-bb34-f5fb67131644	WANTED	19961577946	Sachith Wijesinghe	+94757927901	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
c72e1660-c7a2-4b2e-a7ea-675d41bdaa8e	SP AJC-9703	CHASSIS00000195	Red	Bajaj RE 4S	565405f9-b651-442d-bb2f-877f576dca5f	WANTED	589527175X	Chamari Perera	+94747360152	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
9f5924f2-8353-448a-af08-601eb93a5eec	SP AJD-8485	CHASSIS00000196	Yellow	Bajaj RE 4S	1f31e6ae-de9e-419b-8212-56a9e0907a87	WANTED	19831497233	Malith Madushanka	+94789587144	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
a1f1902a-c6c9-4c76-b236-da4e530c7359	SP AJE-7678	CHASSIS00000197	Red	Bajaj RE 4S	6aa2475b-1c29-489e-8e1a-6e40c0d86135	WANTED	887400902V	Sandya Silva	+94767192918	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
a61d308d-bb78-4e95-8659-a706bb6bce1c	SP AJF-6629	CHASSIS00000198	White	Bajaj RE 4S	8666d470-5182-403f-89fd-e8c7f5a4541d	WANTED	19812617542	Sachini Wijesinghe	+94762470173	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
1767314e-c7d8-4db9-91a5-0a1aa580966e	SP AJG-2144	CHASSIS00000199	Orange	Bajaj RE 4S	9be3c524-a332-4aa8-8b66-205ccfff36a1	WANTED	970389290V	Nimasha Jayawardena	+94773627208	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
09df9889-f1d9-49fc-90fe-e7ca734ef1a5	SP AJH-2572	CHASSIS00000200	Blue	Bajaj RE 4S	8cf5707e-6a8c-4560-a872-4a0dc44d5c82	WANTED	19853344171	Chaminda Jayasuriya	+94722596884	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
6441ebad-5c6b-44ab-ace8-b8727ce01cc4	SP AJJ-8583	CHASSIS00000201	Yellow	Piaggio Ape	bd2101cc-01e3-4bbb-b8df-571dafb3e017	SUSPENDED	840749284V	Asanka Gunasekara	+94722393530	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
767ca500-a35f-4281-8349-ea8c0e4e633c	SP AJK-4543	CHASSIS00000202	Silver	Piaggio Ape	47e3a420-cb71-43c4-83ba-326aad5f0330	SUSPENDED	19706308772	Kumari Rathnayake	+94744003535	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
af5c8838-c77e-47e1-855a-ae6c7146ef5f	SP AJL-3616	CHASSIS00000203	White	Piaggio Ape	4f3ba802-9390-4466-a2e1-5b3a59a18a85	SUSPENDED	769813364V	Pavithra Silva	+94761805472	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
7b6a53ec-2225-4c41-9901-d0bf26a82b2c	SP AJM-4689	CHASSIS00000204	Orange	Piaggio Ape	5640cc2f-e591-434a-be5f-298a4df41da5	SUSPENDED	19935272829	Sachith Senanayake	+94763893045	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
6104e1e9-7d11-4acb-a13a-fb266c8f4f87	SP AJN-9125	CHASSIS00000205	Orange	Piaggio Ape	6d9f4685-aacb-43f5-8d2b-1781e9166da7	SUSPENDED	104006818X	Nimasha Kumara	+94723850527	ec8566fb-2a50-4696-b766-a5f3b18bcc77	2026-04-25 08:43:48.43037+00	2026-04-25 08:43:48.43037+00
\.


--
-- Name: knex_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: slpvt_user
--

SELECT pg_catalog.setval('public.knex_migrations_id_seq', 18, true);


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
-- Name: station_types station_types_pkey; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.station_types
    ADD CONSTRAINT station_types_pkey PRIMARY KEY (station_type_id);


--
-- Name: station_types station_types_type_name_unique; Type: CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.station_types
    ADD CONSTRAINT station_types_type_name_unique UNIQUE (type_name);


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
-- Name: stations stations_station_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_station_type_id_foreign FOREIGN KEY (station_type_id) REFERENCES public.station_types(station_type_id) ON DELETE RESTRICT;


--
-- Name: users users_assigned_district_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_assigned_district_id_foreign FOREIGN KEY (assigned_district_id) REFERENCES public.districts(district_id) ON DELETE RESTRICT;


--
-- Name: users users_assigned_province_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_assigned_province_id_foreign FOREIGN KEY (assigned_province_id) REFERENCES public.provinces(province_id) ON DELETE RESTRICT;


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
-- Name: vehicles vehicles_registered_province_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: slpvt_user
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_registered_province_id_foreign FOREIGN KEY (registered_province_id) REFERENCES public.provinces(province_id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict QiUR7prAH6oAJVINhUvQ0MO7Ku0UePcIQppu0gfSpVOcvcKT1jATILp66Q9lAmN

