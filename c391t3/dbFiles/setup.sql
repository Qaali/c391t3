/*
 *  File name:  setup.sql
 *  Function:   to create the initial database schema for the CMPUT 391 project,
 *              Winter Term, 2012
 *  Author:     Prof. Li-Yan Yuan
 */
DROP TABLE persons;
DROP TABLE family_doctor;
DROP TABLE pacs_images;
DROP TABLE radiology_record;
DROP TABLE users;


CREATE TABLE users (
   user_name varchar(24),
   password  varchar(24),
   class     char(1),
   date_registered date,
   CHECK (class in ('a','p','d','r')),
   PRIMARY KEY(user_name)
);

CREATE TABLE persons (
   user_name  varchar(24),
   first_name varchar(24),
   last_name  varchar(24),
   address    varchar(128),
   email      varchar(128),
   phone      char(10),
   PRIMARY KEY(user_name),
   UNIQUE (email),
   FOREIGN KEY (user_name) REFERENCES users
);


CREATE TABLE family_doctor (
   doctor_name  varchar(24),
   patient_name varchar(24),
   FOREIGN KEY(doctor_name) REFERENCES users,
   FOREIGN KEY(patient_name) REFERENCES users,
   PRIMARY KEY(doctor_name,patient_name)
);


CREATE TABLE radiology_record (
   record_id   int,
   patient_name varchar(24),
   doctor_name varchar(24),
   radiologist_name varchar(24),
   test_type   varchar(24),
   prescribing_date date,
   test_date    date,
   diagnosis    varchar(128),
   description   varchar(1024),
   PRIMARY KEY(record_id),
   FOREIGN KEY(patient_name) REFERENCES users,
   FOREIGN KEY(doctor_name) REFERENCES users,
   FOREIGN KEY(radiologist_name) REFERENCES users
);

CREATE TABLE pacs_images (
   record_id   int,
   image_id    int,
   thumbnail   blob,
   regular_size blob,
   full_size    blob,
   PRIMARY KEY(record_id,image_id),
   FOREIGN KEY(record_id) REFERENCES radiology_record
);

/* Commands added by team */
/* Create sequence for record creation */
DROP SEQUENCE record_seq;
CREATE SEQUENCE record_seq;

/* Create index for search */
DROP INDEX pat_index;
CREATE INDEX pat_index ON radiology_record(patient_name) 
	INDEXTYPE IS ctxsys.context 
	PARAMETERS ('SYNC (ON COMMIT)');

DROP INDEX diag_index;
CREATE INDEX diag_index ON radiology_record(diagnosis) 
	INDEXTYPE IS ctxsys.context 
	PARAMETERS ('SYNC (ON COMMIT)');

DROP INDEX desc_index;
CREATE INDEX desc_index ON radiology_record(description) 
	INDEXTYPE IS ctxsys.context 
	PARAMETERS ('SYNC (ON COMMIT)');

/* Create views for OLAP */
DROP VIEW rec_date;
CREATE VIEW rec_date AS 
	SELECT record_id, to_char(test_date, 'WW-YYYY') AS week, to_char(test_date, 'MON-YYYY') AS month, 
	to_char(test_date, 'YYYY') AS year FROM radiology_record;

DROP VIEW rec_week;
CREATE VIEW rec_week AS 
	SELECT COUNT(r.record_id) AS recnum, r.patient_name, r.test_type, d.week 
	FROM radiology_record r, rec_date d 
	WHERE r.record_id = d.record_id 
	GROUP BY r.patient_name, r.test_type, d.week;

DROP VIEW rec_month;
CREATE VIEW rec_month AS 
	SELECT COUNT(r.record_id) AS recnum, r.patient_name, r.test_type, d.month 
	FROM radiology_record r, rec_date d 
	WHERE r.record_id = d.record_id 
	GROUP BY r.patient_name, r.test_type, d.month;
