/*
 Lazizbek Fayzullayev V-1

 https://drawsql.app/teams/myteam-754/diagrams/hospital
 */

create table patients
(
    id                bigserial primary key,
    first_name        varchar(50),
    last_name         varchar(50),
    passport_id       varchar(50) unique,
    health_complaints varchar
);


create table roles
(
    id        bigserial primary key,
    role_name varchar(255)
);



create table doctors
(
    id          bigserial primary key,
    first_name  varchar(50),
    last_name   varchar(50),
    passport_id varchar(50) unique,
    role_id     int references roles (id)
);


create table appointment
(
    patient_id int references patients (id),
    doctor_id  int references doctors (id),
    time       timestamp
);

insert into roles(role_name)
values ('Physician'),
       ('Cardiologist'),
       ('Endocrinologist'),
       ('Ophthalmologist'),
       ('Gynecologists'),
       ('Pediatrician'),
       ('Neurologist');



insert into doctors (first_name, last_name, passport_id, role_id)
VALUES ('John', 'Wick', '1234567', 1),
       ('Kendra', 'Erickson', '1434567', 2),
       ('Brittany', 'Berg', '6543213', 3),
       ('Novalee ', 'Shepherd', '1234234', 4),
       ('Miranda ', 'Spencer', '1124454', 5),
       ('Cassidy ', 'Hubbard', '2514546', 2),
       ('Kyleigh ', 'Reid', '7656456', 1),
       ('Ellie ', 'Flowers', '0798987', 5),
       ('Payton ', 'BrooksBrooks', '2354373', 6),
       ('Mckenna', 'King', '2353375', 7),
       ('Ainsley', 'Novalee ', '2874373', 7);


select *
from doctors;


insert into patients(first_name, last_name, passport_id, health_complaints)
values ('Kamila ', 'Shepherd', '13427469', 'Meningococcal Disease.'),
       ('Kamila ', 'McConnell', '44927129', 'Meningococcal Disease.'),
       ('Rosa  ', 'Armstrong', '27348826', 'Measles.'),
       ('Kimber  ', 'Schroeder', '31841291', 'Novel Coronavirus (COVID-19)'),
       ('Emmy  ', 'Rodriguez', '47827129', 'Influenza (Flu)'),
       ('Myra  ', 'Zamora', '10952656', 'Novel Coronavirus (COVID-19)'),
       ('Kaia  ', 'Frost', '75070984', 'Hepatitis C.'),
       ('Winnie  ', 'Ayala', '83977353', 'Hepatitis C.'),
       ('Haylee   ', 'Rollins', '43758908', 'Hepatitis A.');

select *
from patients;

--------------------------------------TASK 1-------------------------------------------------------

create or replace function fn_search_patients_records_by_name(name varchar)
    returns table
            (
                p_id        patients.id%type,
                f_name      patients.first_name%type,
                l_name      patients.last_name%type,
                passport_id patients.passport_id%type,
                complaints  patients.health_complaints%type
            )
    language plpgsql
as
$$
begin
return query
select patients.id, patients.first_name, patients.last_name, patients.passport_id, patients.health_complaints
from patients
where patients.first_name ilike '%' || name || '%';
end ;
$$;


select *
from fn_search_patients_records_by_name('a');


--------------------------------------TASK 2-------------------------------------------------------


create or replace procedure pr_scheduling_appointment(p_id int, d_id int, date timestamp)
    language plpgsql
as
$$
begin
insert into appointment(patient_id, doctor_id, time) values (p_id, d_id, date);
end;
$$;


call pr_scheduling_appointment(10, 9, '1-15-2024');
call pr_scheduling_appointment(6, 7, '12-15-2024 8:30');
call pr_scheduling_appointment(7, 8, '12-16-2024 9:00');
call pr_scheduling_appointment(8, 10, '12-16-2024 9:30');
call pr_scheduling_appointment(9, 11, '12-15-2024 10:00');
call pr_scheduling_appointment(11, 12, '1-16-2024 10:30');
call pr_scheduling_appointment(12, 13, '12-17-2024 11:00');
call pr_scheduling_appointment(13, 14, '1-15-2024 11:30');



select *
from appointment;

--------------------------------------TASK 3-------------------------------------------------------


create view view_today_appointments as
select *
from appointment
where extract(day from appointment.time) = '15';

select *
from view_today_appointments;


--------------------------------------TASK 4-------------------------------------------------------


create materialized view view_appointments_last_month as
select concat(p.first_name, ' ', p.last_name)  as patient_full_name,
       count(patient_id)                                as appointment_count,
       extract(month from a.time) as month,
       extract(year from a.time)  as year
from appointment a
    inner join patients p on a.patient_id = p.id
where a.time >= (current_date - interval '1 month')
group by p.first_name,
    p.last_name,
    extract(month from a.time),
    extract(year from a.time);

refresh materialized view view_appointments_last_month;

select *
from view_appointments_last_month
order by year;










