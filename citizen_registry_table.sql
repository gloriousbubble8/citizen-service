/*
====================================================
 Citizen Registry Production Database Schema
 PostgreSQL
====================================================
*/


-- ===================================================
-- EXTENSIONS
-- ===================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE EXTENSION IF NOT EXISTS pg_stat_statements;



-- ===================================================
-- CLEAN EXISTING OBJECTS
-- ===================================================


DROP TABLE IF EXISTS audit_event CASCADE;

DROP TABLE IF EXISTS government_transaction CASCADE;

DROP TABLE IF EXISTS healthcare_record CASCADE;

DROP TABLE IF EXISTS voting_record CASCADE;

DROP TABLE IF EXISTS immigration_history CASCADE;

DROP TABLE IF EXISTS military_service CASCADE;

DROP TABLE IF EXISTS family_relationship CASCADE;

DROP TABLE IF EXISTS emergency_contact CASCADE;

DROP TABLE IF EXISTS education_history CASCADE;

DROP TABLE IF EXISTS employment_history CASCADE;

DROP TABLE IF EXISTS employer CASCADE;

DROP TABLE IF EXISTS vehicle_registration CASCADE;

DROP TABLE IF EXISTS driving_license CASCADE;

DROP TABLE IF EXISTS citizen_identification CASCADE;

DROP TABLE IF EXISTS address_history CASCADE;

DROP TABLE IF EXISTS citizen_address CASCADE;

DROP TABLE IF EXISTS citizen CASCADE;



DROP TABLE IF EXISTS transaction_type_master CASCADE;

DROP TABLE IF EXISTS military_branch_master CASCADE;

DROP TABLE IF EXISTS employment_type_master CASCADE;

DROP TABLE IF EXISTS document_type_master CASCADE;

DROP TABLE IF EXISTS citizen_status_master CASCADE;

DROP TABLE IF EXISTS gender_master CASCADE;

DROP TABLE IF EXISTS city_master CASCADE;

DROP TABLE IF EXISTS state_master CASCADE;

DROP TABLE IF EXISTS country_master CASCADE;



-- ===================================================
-- MASTER TABLES
-- ===================================================


CREATE TABLE country_master
(

    country_id SERIAL PRIMARY KEY,

    country_code VARCHAR(10)
        UNIQUE NOT NULL,

    country_name VARCHAR(100)
        NOT NULL

);



CREATE TABLE state_master
(

    state_id SERIAL PRIMARY KEY,

    state_code VARCHAR(10)
        UNIQUE NOT NULL,

    state_name VARCHAR(100)
        NOT NULL,


    country_id INTEGER
        REFERENCES country_master(country_id)

);



CREATE TABLE city_master
(

    city_id SERIAL PRIMARY KEY,


    city_name VARCHAR(100)
        NOT NULL,


    state_id INTEGER
        REFERENCES state_master(state_id)

);



CREATE TABLE gender_master
(

    gender_id SERIAL PRIMARY KEY,


    gender_code VARCHAR(20)
        UNIQUE NOT NULL

);



CREATE TABLE citizen_status_master
(

    status_id SERIAL PRIMARY KEY,


    status_code VARCHAR(30)
        UNIQUE NOT NULL

);



CREATE TABLE document_type_master
(

    document_type_id SERIAL PRIMARY KEY,


    document_code VARCHAR(50)
        UNIQUE NOT NULL

);



CREATE TABLE transaction_type_master
(

    transaction_type_id SERIAL PRIMARY KEY,


    transaction_code VARCHAR(50)
        UNIQUE NOT NULL

);



CREATE TABLE employment_type_master
(

    employment_type_id SERIAL PRIMARY KEY,


    employment_code VARCHAR(50)
        UNIQUE NOT NULL

);



CREATE TABLE military_branch_master
(

    branch_id SERIAL PRIMARY KEY,


    branch_code VARCHAR(50)
        UNIQUE NOT NULL

);




-- ===================================================
-- CORE CITIZEN TABLE
-- ===================================================


CREATE TABLE citizen
(

    citizen_id UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),


    ssn VARCHAR(20)
        UNIQUE NOT NULL,


    first_name VARCHAR(100)
        NOT NULL,


    middle_name VARCHAR(100),


    last_name VARCHAR(100)
        NOT NULL,


    date_of_birth DATE
        NOT NULL,


    gender_id INTEGER
        REFERENCES gender_master(gender_id),


    status_id INTEGER
        REFERENCES citizen_status_master(status_id),


    email VARCHAR(200),


    phone_number VARCHAR(30),


    birth_city_id INTEGER
        REFERENCES city_master(city_id),


    created_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP,


    updated_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP,


    is_deleted BOOLEAN
        DEFAULT FALSE

);




CREATE TABLE citizen_address
(

    address_id UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),


    citizen_id UUID
        REFERENCES citizen(citizen_id),


    address_type VARCHAR(30),


    street VARCHAR(200),


    city VARCHAR(100),


    state VARCHAR(100),


    zip_code VARCHAR(20),


    latitude NUMERIC(10,7),


    longitude NUMERIC(10,7),


    is_current BOOLEAN DEFAULT TRUE,


    created_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP

);



CREATE TABLE address_history
(

    history_id BIGSERIAL PRIMARY KEY,


    citizen_id UUID
        REFERENCES citizen(citizen_id),


    old_address TEXT,


    new_address TEXT,


    changed_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP

);



-- ===================================================
-- IDENTITY TABLES
-- ===================================================


CREATE TABLE citizen_identification
(

    identification_id UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),


    citizen_id UUID
        REFERENCES citizen(citizen_id),


    document_type_id INTEGER
        REFERENCES document_type_master(document_type_id),


    document_number VARCHAR(100)
        UNIQUE,


    issue_date DATE,


    expiry_date DATE,


    issuing_authority VARCHAR(200)

);



CREATE TABLE driving_license
(

    license_id UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),


    citizen_id UUID UNIQUE
        REFERENCES citizen(citizen_id),


    license_number VARCHAR(50)
        UNIQUE,


    license_class VARCHAR(20),


    issue_date DATE,


    expiry_date DATE,


    status VARCHAR(30)

);



CREATE TABLE vehicle_registration
(

    vehicle_id UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),


    citizen_id UUID
        REFERENCES citizen(citizen_id),


    vin_number VARCHAR(100)
        UNIQUE,


    manufacturer VARCHAR(100),


    model VARCHAR(100),


    manufacture_year INTEGER,


    registration_date DATE,


    expiry_date DATE

);


-- ===================================================
-- PROFESSIONAL TABLES
-- ===================================================


CREATE TABLE employer
(

    employer_id UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),


    employer_name VARCHAR(200)
        NOT NULL,


    industry VARCHAR(100),


    company_size INTEGER,


    headquarters_city VARCHAR(100),


    created_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP

);



CREATE TABLE employment_history
(

    employment_id UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),


    citizen_id UUID
        REFERENCES citizen(citizen_id),


    employer_id UUID
        REFERENCES employer(employer_id),


    employment_type_id INTEGER
        REFERENCES employment_type_master(employment_type_id),


    job_title VARCHAR(150),


    annual_salary NUMERIC(12,2),


    start_date DATE,


    end_date DATE,


    currently_employed BOOLEAN DEFAULT FALSE,


    created_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP

);



CREATE TABLE education_history
(

    education_id UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),


    citizen_id UUID
        REFERENCES citizen(citizen_id),


    institution_name VARCHAR(200),


    degree VARCHAR(100),


    field_of_study VARCHAR(100),


    graduation_year INTEGER,


    grade NUMERIC(5,2)

);



-- ===================================================
-- PERSONAL RELATIONSHIP TABLES
-- ===================================================


CREATE TABLE family_relationship
(

    relationship_id UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),


    citizen_id UUID
        REFERENCES citizen(citizen_id),


    related_citizen_id UUID
        REFERENCES citizen(citizen_id),


    relationship_type VARCHAR(50),


    created_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP

);



CREATE TABLE emergency_contact
(

    contact_id UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),


    citizen_id UUID
        REFERENCES citizen(citizen_id),


    contact_name VARCHAR(200),


    relationship VARCHAR(50),


    phone_number VARCHAR(30),


    email VARCHAR(200),


    created_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP

);



-- ===================================================
-- GOVERNMENT DOMAIN TABLES
-- ===================================================


CREATE TABLE military_service
(

    service_id UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),


    citizen_id UUID
        REFERENCES citizen(citizen_id),


    branch_id INTEGER
        REFERENCES military_branch_master(branch_id),


    military_rank VARCHAR(100),


    service_start_date DATE,


    service_end_date DATE,


    deployment_country VARCHAR(100),


    discharge_type VARCHAR(100),


    created_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP

);



CREATE TABLE immigration_history
(

    immigration_id UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),


    citizen_id UUID
        REFERENCES citizen(citizen_id),


    previous_country_id INTEGER
        REFERENCES country_master(country_id),


    visa_type VARCHAR(100),


    arrival_date DATE,


    naturalization_date DATE,


    immigration_status VARCHAR(50),


    created_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP

);



CREATE TABLE voting_record
(

    voting_id BIGSERIAL PRIMARY KEY,


    citizen_id UUID
        REFERENCES citizen(citizen_id),


    election_year INTEGER,


    election_type VARCHAR(100),


    polling_location VARCHAR(200),


    voted_at TIMESTAMP,


    created_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP

);



-- ===================================================
-- HEALTHCARE TABLE
-- ===================================================


CREATE TABLE healthcare_record
(

    healthcare_id UUID PRIMARY KEY
        DEFAULT uuid_generate_v4(),


    citizen_id UUID
        REFERENCES citizen(citizen_id),


    blood_group VARCHAR(10),


    insurance_provider VARCHAR(200),


    insurance_policy_number VARCHAR(100),


    medical_attributes JSONB,


    last_visit_date DATE,


    created_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP

);

-- ===================================================
-- HIGH VOLUME GOVERNMENT TRANSACTION TABLE
-- ===================================================


CREATE TABLE government_transaction
(

    transaction_id BIGSERIAL PRIMARY KEY,


    citizen_id UUID
        REFERENCES citizen(citizen_id),


    transaction_type_id INTEGER
        REFERENCES transaction_type_master(transaction_type_id),


    transaction_status VARCHAR(50),


    transaction_amount NUMERIC(12,2),


    transaction_date TIMESTAMP
        NOT NULL,


    payload JSONB,


    created_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP

);



-- ===================================================
-- AUDIT EVENT TABLE
-- WRITE HEAVY TABLE
-- ===================================================


CREATE TABLE audit_event
(

    event_id BIGSERIAL PRIMARY KEY,


    entity_name VARCHAR(100),


    entity_id VARCHAR(100),


    operation VARCHAR(30),


    old_data JSONB,


    new_data JSONB,


    created_at TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP

);



-- ===================================================
-- INDEXES
-- ===================================================



-- Citizen search indexes

CREATE INDEX idx_citizen_last_name
ON citizen(last_name);



CREATE INDEX idx_citizen_email
ON citizen(email);



CREATE INDEX idx_citizen_birth_date
ON citizen(date_of_birth);



CREATE INDEX idx_citizen_status
ON citizen(status_id);



CREATE INDEX idx_citizen_active
ON citizen(citizen_id)
WHERE is_deleted = FALSE;




-- Address indexes

CREATE INDEX idx_address_citizen
ON citizen_address(citizen_id);



CREATE INDEX idx_address_location
ON citizen_address(state,city,zip_code);



CREATE INDEX idx_current_address
ON citizen_address(citizen_id,is_current);




-- Identification indexes


CREATE INDEX idx_document_citizen
ON citizen_identification(citizen_id);



CREATE INDEX idx_document_number
ON citizen_identification(document_number);




-- Employment indexes


CREATE INDEX idx_employment_citizen
ON employment_history(citizen_id);



CREATE INDEX idx_employment_dates
ON employment_history(start_date,end_date);



CREATE INDEX idx_employer_name
ON employer(employer_name);




-- Education indexes


CREATE INDEX idx_education_citizen
ON education_history(citizen_id);



CREATE INDEX idx_degree
ON education_history(degree);




-- Family relationship indexes


CREATE INDEX idx_family_citizen
ON family_relationship(citizen_id);



CREATE INDEX idx_family_related
ON family_relationship(related_citizen_id);




-- Military indexes


CREATE INDEX idx_military_citizen
ON military_service(citizen_id);



CREATE INDEX idx_military_branch
ON military_service(branch_id);




-- Immigration indexes


CREATE INDEX idx_immigration_citizen
ON immigration_history(citizen_id);



CREATE INDEX idx_immigration_date
ON immigration_history(arrival_date);




-- Voting indexes


CREATE INDEX idx_voting_citizen
ON voting_record(citizen_id);



CREATE INDEX idx_voting_year
ON voting_record(election_year);




-- Healthcare indexes


CREATE INDEX idx_health_citizen
ON healthcare_record(citizen_id);



-- JSONB GIN index

CREATE INDEX idx_health_attributes
ON healthcare_record
USING GIN (medical_attributes);




-- ===================================================
-- GOVERNMENT TRANSACTION INDEXES
-- ===================================================


CREATE INDEX idx_transaction_citizen
ON government_transaction(citizen_id);



CREATE INDEX idx_transaction_date
ON government_transaction(transaction_date);



CREATE INDEX idx_transaction_type
ON government_transaction(transaction_type_id);



CREATE INDEX idx_transaction_status
ON government_transaction(transaction_status);



-- Important composite index

CREATE INDEX idx_transaction_citizen_date
ON government_transaction
(
    citizen_id,
    transaction_date
);



-- JSONB search

CREATE INDEX idx_transaction_payload
ON government_transaction
USING GIN(payload);




-- ===================================================
-- AUDIT INDEXES
-- ===================================================


CREATE INDEX idx_audit_entity
ON audit_event(entity_name,entity_id);



CREATE INDEX idx_audit_created
ON audit_event(created_at);



-- ===================================================
-- INITIAL MASTER DATA
-- ===================================================


INSERT INTO country_master
(
country_code,
country_name
)
VALUES
(
'USA',
'United States'
);



INSERT INTO gender_master
(
gender_code
)
VALUES
('MALE'),
('FEMALE'),
('OTHER');



INSERT INTO citizen_status_master
(
status_code
)
VALUES
('ACTIVE'),
('INACTIVE'),
('DECEASED'),
('SUSPENDED');



INSERT INTO document_type_master
(
document_code
)
VALUES
('SSN'),
('PASSPORT'),
('BIRTH_CERTIFICATE'),
('DRIVER_LICENSE');



INSERT INTO transaction_type_master
(
transaction_code
)
VALUES
('PASSPORT_RENEWAL'),
('LICENSE_RENEWAL'),
('ADDRESS_CHANGE'),
('CITIZEN_UPDATE');



INSERT INTO employment_type_master
(
employment_code
)
VALUES
('FULL_TIME'),
('PART_TIME'),
('CONTRACT'),
('SELF_EMPLOYED');



INSERT INTO military_branch_master
(
branch_code
)
VALUES
('ARMY'),
('NAVY'),
('AIR_FORCE'),
('MARINES');



-- 1  country_master
-- 2  state_master
-- 3  city_master
-- 4  gender_master
-- 5  citizen_status_master
-- 6  document_type_master
-- 7  transaction_type_master
-- 8  employment_type_master
-- 9  military_branch_master

-- 10 citizen
-- 11 citizen_address
-- 12 address_history
-- 13 citizen_identification
-- 14 driving_license
-- 15 vehicle_registration

-- 16 employer
-- 17 employment_history
-- 18 education_history

-- 19 family_relationship
-- 20 emergency_contact

-- 21 military_service
-- 22 immigration_history
-- 23 voting_record

-- 24 healthcare_record

-- 25 government_transaction
-- 26 audit_event


