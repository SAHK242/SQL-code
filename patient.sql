-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- PATIENTS table
CREATE TABLE patients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender int4 NOT null check (gender in(1,2,3)),
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    address TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_by uuid not null,
    updated_by uuid not null
);

-- MEDICAL HISTORIES table (diagnosis, treatment, surgery, prescription)
CREATE TABLE medical_histories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    reason text not null,
    diagnosis text not null,
    has_treatment boolean not null default false,
    has_surgery boolean not null default false,
    has_prescription boolean not null default false,
    doctor_notes text,
    medical_end_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_by uuid not null,
    updated_by uuid not null
);

create table medical_treatment(
	id uuid primary key default gen_random_uuid(),
	medical_history_id uuid not null references medical_histories(id) on delete cascade,
	start_date TIMESTAMPTZ,
	end_date TIMESTAMPTZ,
	name text not null,
	result text not null,
	description text not null,
	fee float not null,
	main_doctor_id uuid not null,
	support_doctor_ids text,
	support_nurse_ids text,
	created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_by uuid not null,
    updated_by uuid not null
);

create table medical_surgery(
	id uuid primary key default gen_random_uuid(),
	medical_history_id uuid not null references medical_histories(id) on delete cascade,
	start_date TIMESTAMPTZ,
	end_date TIMESTAMPTZ,
	name text not null,
	result text not null,
	description text not null,
	fee float not null,
	main_doctor_id uuid not null,
	support_doctor_ids text,
	support_nurse_ids text,
	created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_by uuid not null,
    updated_by uuid not null
);

create table medication(
	id uuid primary key default gen_random_uuid(),
	name text not null, 
	effects text not null,
	expired_date TIMESTAMPTZ not null,
	quantity int8 not null,
	price float,
	created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    created_by uuid not null,
    updated_by uuid not null
);

create table medical_prescription(
	id uuid primary key default gen_random_uuid(),
	medical_history_id uuid not null references medical_histories(id) on delete cascade,
	prescription_date TIMESTAMPTZ default now(),
	fee float not null,
	created_at TIMESTAMPTZ DEFAULT now(),
    created_by uuid not null
);

create table prescription_medication(
	id uuid primary key default gen_random_uuid(),
	prescription_id uuid not null references medical_prescription(id),
	medication_id uuid not null references medication(id),
	quantity int8 not null
);
