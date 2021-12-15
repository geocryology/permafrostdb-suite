--
-- PostgreSQL database dump
--

-- Dumped from database version 10.12 (Ubuntu 10.12-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.12 (Ubuntu 10.12-0ubuntu0.18.04.1)

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

-- DROP DATABASE observations;
--
-- Name: observations; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE observations WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8';


ALTER DATABASE observations OWNER TO postgres;

\connect observations

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

CREATE ROLE observations_admin;
--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: device_sensor_profiles; Type: TABLE; Schema: public; Owner: observations_admin
--

CREATE TABLE public.device_sensor_profiles (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    device_type character varying NOT NULL,
    manufacturer character varying NOT NULL,
    manufacturer_device_name character varying NOT NULL,
    sensor_label character varying NOT NULL,
    sensor_type_of_measurement character varying NOT NULL,
    sensor_unit_of_measurement character varying,
    sensor_accuracy numeric,
    sensor_precision numeric,
    sensor_height_in_metres numeric
);


ALTER TABLE public.device_sensor_profiles OWNER TO observations_admin;

--
-- Name: devices; Type: TABLE; Schema: public; Owner: observations_admin
--

CREATE TABLE public.devices (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    serial_number character varying,
    access_code character varying,
    device_type character varying,
    manufacturer character varying,
    manufacturer_device_name character varying,
    acquired_on timestamp with time zone,
    notes text
);


ALTER TABLE public.devices OWNER TO observations_admin;

--
-- Name: devices_locations; Type: TABLE; Schema: public; Owner: observations_admin
--

CREATE TABLE public.devices_locations (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    device_id uuid NOT NULL,
    location_id uuid NOT NULL,
    notes text
);


ALTER TABLE public.devices_locations OWNER TO observations_admin;

--
-- Name: dois; Type: TABLE; Schema: public; Owner: observations_admin
--

CREATE TABLE public.dois (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    doi character varying NOT NULL,
    notes text
);


ALTER TABLE public.dois OWNER TO observations_admin;

--
-- Name: imports; Type: TABLE; Schema: public; Owner: observations_admin
--

CREATE TABLE public.imports (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    import_time timestamp with time zone NOT NULL,
    filename character varying,
    import_parameters text
);


ALTER TABLE public.imports OWNER TO observations_admin;

--
-- Name: locations; Type: TABLE; Schema: public; Owner: observations_admin
--

CREATE TABLE public.locations (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying,
    coordinates public.geometry NOT NULL,
    elevation_in_metres numeric NOT NULL,
    comment text,
    record_observations boolean DEFAULT true NOT NULL,
    accuracy_in_metres numeric
);


ALTER TABLE public.locations OWNER TO observations_admin;

--
-- Name: logs; Type: TABLE; Schema: public; Owner: observations_admin
--

CREATE TABLE public.logs (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    log text
);


ALTER TABLE public.logs OWNER TO observations_admin;

--
-- Name: observations; Type: TABLE; Schema: public; Owner: observations_admin
--

CREATE TABLE public.observations (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    device_id uuid NOT NULL,
    sensor_id uuid NOT NULL,
    import_id uuid,
    import_key text,
    observation_type character varying,
    unit_of_measure character varying,
    accuracy numeric,
    "precision" numeric,
    numeric_value numeric,
    text_value text,
    logged_time timestamp with time zone,
    corrected_utc_time timestamp with time zone NOT NULL,
    location public.geometry(Geometry,4326) NOT NULL,
    height_min_metres numeric,
    height_max_metres numeric,
    elevation_in_metres numeric NOT NULL
);


ALTER TABLE public.observations OWNER TO observations_admin;

--
-- Name: observations_dois; Type: TABLE; Schema: public; Owner: observations_admin
--

CREATE TABLE public.observations_dois (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    observation_id uuid NOT NULL,
    doi_id uuid NOT NULL
);


ALTER TABLE public.observations_dois OWNER TO observations_admin;

--
-- Name: observations_sets; Type: TABLE; Schema: public; Owner: observations_admin
--

CREATE TABLE public.observations_sets (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    observation_id uuid NOT NULL,
    set_id uuid NOT NULL
);


ALTER TABLE public.observations_sets OWNER TO observations_admin;

--
-- Name: sensors; Type: TABLE; Schema: public; Owner: observations_admin
--

CREATE TABLE public.sensors (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    device_id uuid NOT NULL,
    label character varying NOT NULL,
    type_of_measurement character varying NOT NULL,
    unit_of_measurement character varying,
    accuracy numeric,
    "precision" numeric,
    height_in_metres numeric,
    serial_number character varying
);


ALTER TABLE public.sensors OWNER TO observations_admin;

--
-- Name: sets; Type: TABLE; Schema: public; Owner: observations_admin
--

CREATE TABLE public.sets (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    set character varying NOT NULL,
    notes text
);


ALTER TABLE public.sets OWNER TO observations_admin;

--
-- Name: devices_locations device_location_pk; Type: CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.devices_locations
    ADD CONSTRAINT device_location_pk PRIMARY KEY (id);


--
-- Name: device_sensor_profiles device_sensor_profiles_pk; Type: CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.device_sensor_profiles
    ADD CONSTRAINT device_sensor_profiles_pk PRIMARY KEY (id);


--
-- Name: devices devices_pk; Type: CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pk PRIMARY KEY (id);


--
-- Name: dois dois_pk; Type: CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.dois
    ADD CONSTRAINT dois_pk PRIMARY KEY (id);


--
-- Name: imports imports_pk; Type: CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.imports
    ADD CONSTRAINT imports_pk PRIMARY KEY (id);


--
-- Name: locations locations_pk; Type: CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pk PRIMARY KEY (id);


--
-- Name: logs logs_pk; Type: CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pk PRIMARY KEY (id);


--
-- Name: observations observations_pk; Type: CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.observations
    ADD CONSTRAINT observations_pk PRIMARY KEY (id);


--
-- Name: sensors sensors_pk; Type: CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.sensors
    ADD CONSTRAINT sensors_pk PRIMARY KEY (id);


--
-- Name: sets sets_pk; Type: CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.sets
    ADD CONSTRAINT sets_pk PRIMARY KEY (id);


--
-- Name: devices unique_serial_number; Type: CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT unique_serial_number UNIQUE (serial_number);


--
-- Name: locations_coordinates; Type: INDEX; Schema: public; Owner: observations_admin
--

CREATE INDEX locations_coordinates ON public.locations USING btree (coordinates);


--
-- Name: locations_name; Type: INDEX; Schema: public; Owner: observations_admin
--

CREATE INDEX locations_name ON public.locations USING btree (name);


--
-- Name: observations_corrected_utc_time; Type: INDEX; Schema: public; Owner: observations_admin
--

CREATE INDEX observations_corrected_utc_time ON public.observations USING btree (corrected_utc_time);


--
-- Name: observations_import_key; Type: INDEX; Schema: public; Owner: observations_admin
--

CREATE INDEX observations_import_key ON public.observations USING btree (import_key);


--
-- Name: observations_location; Type: INDEX; Schema: public; Owner: observations_admin
--

CREATE INDEX observations_location ON public.observations USING btree (location);


--
-- Name: observations_sensor_id; Type: INDEX; Schema: public; Owner: observations_admin
--

CREATE INDEX observations_sensor_id ON public.observations USING btree (sensor_id);


--
-- Name: observations_unit_of_measure; Type: INDEX; Schema: public; Owner: observations_admin
--

CREATE INDEX observations_unit_of_measure ON public.observations USING btree (unit_of_measure);


--
-- Name: devices_locations device_location_fk_device; Type: FK CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.devices_locations
    ADD CONSTRAINT device_location_fk_device FOREIGN KEY (device_id) REFERENCES public.devices(id) MATCH FULL;


--
-- Name: devices_locations device_location_fk_location; Type: FK CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.devices_locations
    ADD CONSTRAINT device_location_fk_location FOREIGN KEY (location_id) REFERENCES public.locations(id) MATCH FULL;


--
-- Name: sensors fk_device_id; Type: FK CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.sensors
    ADD CONSTRAINT fk_device_id FOREIGN KEY (device_id) REFERENCES public.devices(id) MATCH FULL;


--
-- Name: observations_dois observation_doi_doi_fk; Type: FK CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.observations_dois
    ADD CONSTRAINT observation_doi_doi_fk FOREIGN KEY (doi_id) REFERENCES public.dois(id) MATCH FULL;


--
-- Name: observations_dois observation_doi_observation_fk; Type: FK CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.observations_dois
    ADD CONSTRAINT observation_doi_observation_fk FOREIGN KEY (observation_id) REFERENCES public.observations(id) MATCH FULL;


--
-- Name: observations observations_device_fk; Type: FK CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.observations
    ADD CONSTRAINT observations_device_fk FOREIGN KEY (device_id) REFERENCES public.devices(id) MATCH FULL;


--
-- Name: observations observations_import_fk; Type: FK CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.observations
    ADD CONSTRAINT observations_import_fk FOREIGN KEY (import_id) REFERENCES public.imports(id) MATCH FULL;


--
-- Name: observations observations_sensor_fk; Type: FK CONSTRAINT; Schema: public; Owner: observations_admin
--

ALTER TABLE ONLY public.observations
    ADD CONSTRAINT observations_sensor_fk FOREIGN KEY (sensor_id) REFERENCES public.sensors(id) MATCH FULL;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: TABLE device_sensor_profiles; Type: ACL; Schema: public; Owner: observations_admin
--

-- Removed for security





--
-- PostgreSQL database dump complete
--