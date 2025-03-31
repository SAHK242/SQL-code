CREATE EXTENSION IF NOT EXISTS pgcrypto;

create table auth (
                      id uuid DEFAULT gen_random_uuid() NOT NULL primary key,
                      email varchar(255) not null unique,
                      username varchar(255) not null unique,
                      password varchar(255) not null, -- password of super admin will not be hashed
                      state int not null, -- 1: active, 2: inactive, 3: locked - when create new account, default is locked and send email to user to activate, 4 - super admin- locked, 5 - super admin - active
                      created_date timestamp not null default now(),
                      last_modified_date timestamp not null default now(),
                      created_by uuid,
                      last_modified_by uuid
);

CREATE OR REPLACE FUNCTION create_super_admin(p_email VARCHAR(255))
RETURNS VOID AS $$
DECLARE
default_password VARCHAR(255) := '12345678@X';
    extracted_username VARCHAR(255);
BEGIN
    -- Extract the username (before '@' in email)
    extracted_username := split_part(p_email, '@', 1);

    -- Insert the super admin account
INSERT INTO auth (email, username, password, state, created_by, last_modified_by)
VALUES (p_email, extracted_username, default_password, 4, NULL, NULL)
    ON CONFLICT (email) DO NOTHING; -- Avoid duplicate super admins
END;
$$ LANGUAGE plpgsql;


create table department (
                            id uuid DEFAULT gen_random_uuid() NOT NULL primary key,
                            name varchar(255) not null unique
);

CREATE table employee (
                          id uuid DEFAULT gen_random_uuid() NOT NULL primary key,
                          employee_id uuid REFERENCES auth(id) ON DELETE CASCADE,
                          first_name varchar(255) not null default '',
                          last_name varchar(255) not null default '',
                          gender int, -- 1: male, 2: female, 3: other,
                          date_of_birth date,
                          code varchar(255),
                          address text,
                          start_date date,
                          end_date date,
                          phone_number varchar(255),
                          degree_name varchar(255),
                          degree_year int,
                          department_id uuid REFERENCES department(id) not null,
                          employee_type int -- 1: nurse, 2: doctor
);

create table nurse (
                      id uuid DEFAULT gen_random_uuid() NOT NULL primary key,
                       nurse_id uuid REFERENCES employee(id) ON DELETE CASCADE
);

create table doctor (
                          id uuid DEFAULT gen_random_uuid() NOT NULL primary key,   
                        doctor_id uuid REFERENCES employee(id) ON DELETE CASCADE
);

select create_super_admin('test@gmail.com');
