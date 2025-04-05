CREATE EXTENSION IF NOT EXISTS pgcrypto;

create table patient (
    id uuid DEFAULT gen_random_uuid() NOT NULL primary key,
    phone_number varchar(255),
    address text,
    date_of_birth date,
    gender int,
    first_name varchar(255),
    last_name varchar(255),
    current_patient_type int
);

create table invoice (
    id uuid DEFAULT gen_random_uuid() NOT NULL primary key,
    invoice_date date,
    due_date date,
    total_amount float
);

create table inpatient (
    id uuid DEFAULT gen_random_uuid() primary key,
    patient_id uuid references patient(id) on delete cascade,
    register_date date
);

create table inpatient_detail (
  id uuid DEFAULT gen_random_uuid() NOT NULL primary key,
  inpatient_id uuid references inpatient(id) on delete cascade,
  admission_date date,
  diagnosis text,
  sickroom varchar(255),
  discharge_date date,
  invoice_id uuid references invoice(id),
  nurse_id uuid not null,
  doctor_id uuid not null
);

create table outpatient (
  id uuid DEFAULT gen_random_uuid() NOT NULL primary key,
  patient_id uuid references patient(id) on delete cascade,
  register_date date
);

create table outpatient_detail (
  id uuid DEFAULT gen_random_uuid() NOT NULL primary key,
  outpatient_id uuid references outpatient(id) on delete cascade,
  invoice_id uuid references invoice(id),
  doctor_id uuid not null
);

create table treat_detail (
  id uuid DEFAULT gen_random_uuid() NOT NULL primary key,
  start_date date,
  end_date date,
  result text,
  fee float,
  inpatient_detail_id uuid references inpatient_detail(id)  
);

create table examine_detail (
  id uuid DEFAULT gen_random_uuid() NOT NULL primary key,
  examine_date date,
  diagnosis text,
  fee float,
  next_appointment_date date,
  outpatient_detail_id uuid references outpatient_detail(id)
);

create table medication (
    id uuid DEFAULT gen_random_uuid() NOT NULL primary key,
    name varchar(255) not null,
    price float not null,
    expired_date date,
    quantity int,
    effects text
);

create table treat_medication (
    id uuid DEFAULT gen_random_uuid() NOT NULL primary key,
    treat_detail_id uuid references treat_detail(id) on delete cascade,
    medication_id uuid references medication(id) on delete cascade,
    num_of_med int,
    prescribe_date date not null default now()
);

create table examine_medication (
    id uuid DEFAULT gen_random_uuid() NOT NULL primary key,
    examine_detail_id uuid references examine_detail(id) on delete cascade,
    medication_id uuid references medication(id) on delete cascade,
    num_of_med int,
      prescribe_date date not null default now()
);
