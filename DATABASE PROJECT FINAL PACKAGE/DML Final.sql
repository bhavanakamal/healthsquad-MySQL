-- Query to add new healthcare facility
SELECT * FROM HEALTHCARE_FACILITY;

INSERT INTO  HEALTHCARE_FACILITY VALUES (2000135, 'Sumona Health Center', 95500,'Somona','CA');

-- Query to delete out of service healthcare facilities using their facility id

DELETE FROM  HEALTHCARE_FACILITY WHERE facility_id= 2000135;


-- Query to add new incoming doctors/physicians to the healthcare facility database 

SELECT * FROM PHYSICIAN;

INSERT INTO PHYSICIAN VALUES(1001022, 'Ken','Sams','ENT','2015-05-13', 15,2000115);


-- Query to add new patient 

SELECT * FROM PATIENT;

INSERT INTO PATIENT VALUES (3000121, 'Seema', 'Roy','Female', '95051', 'San Francisco', 'CA',2000106,'999-000-9911', '000-111-1100','1995-09-08');

-- Query to update last name of patient based on their patient id (in case of marriage)



UPDATE  PATIENT SET patient_Last_name = 'Zhang'
WHERE  patient_id = 3000115;

-- Query to check how many healthcare facility are available per city

SELECT facility_city, COUNT(facility_id) AS count_of_healthcare_facility FROM HEALTHCARE_FACILITY
GROUP BY facility_city;


-- Healthcare facility can run this query to get details of their patient, by entering their facility id

SELECT HF.facility_id,
CONCAT(P.patient_First_name,' ', P.patient_Last_name) AS Patient_Name, P.DOB,P.gender,P.phone_number AS Patient_phone_number,
P.patient_zip , P.patient_city,P.patient_state
FROM HEALTHCARE_FACILITY HF
INNER JOIN  PATIENT P  ON HF.facility_zip = P.patient_zip
WHERE HF.facility_id = 2000109;

-- Patients can query this to find out details of healthcare facility in their zipcode by entering zipcode -- UI 1

SELECT * FROM HEALTHCARE_FACILITY
WHERE facility_zip = 95127;

SELECT facility_name, facility_zip FROM HEALTHCARE_FACILITY
WHERE facility_zip = 95127;


-- Query to find out Physicians assigned to patient 



SELECT  CONCAT(PA.patient_First_name,' ', PA.patient_Last_name) AS Patient_Name, 
CONCAT('Dr. ', P.physician_First_name ,' ', P.physician_Last_name) AS Assigned_Doctor
FROM mydb.APPOINTMENT A
INNER JOIN mydb.PHYSICIAN P ON P.physician_id = A.PHYSICIAN_physician_id
INNER JOIN mydb.PATIENT PA ON PA.patient_id = A.PATIENT_patient_id
GROUP BY patient_name;

-- Query to find out number of appointments assigned to each doctor to in descending order to check their work load and availability



SELECT P.physician_id
     , CONCAT('Dr. ', P.physician_First_name ,' ', P.physician_Last_name) AS Doctor_Name
     , COUNT(A.PHYSICIAN_physician_id) AS appoinment_count
  FROM PHYSICIAN P
LEFT OUTER
  JOIN APPOINTMENT A
    ON A.PHYSICIAN_physician_id = P.physician_id
GROUP BY 1
ORDER BY 3 DESC;    



-- Doctors can query to look up for their patient's scheduled appointment date and type, by entering their physician id 
-- UI 2

SELECT  CONCAT(PA.patient_First_name,' ', PA.patient_Last_name) AS Patient_Name, 
CONCAT('Dr. ', P.physician_First_name ,' ', P.physician_Last_name) AS Assigned_Doctor, A.appointment_date,A.appointment_type,
(PA.phone_number) AS Patient_phone_number
FROM mydb.APPOINTMENT A
INNER JOIN mydb.PHYSICIAN P ON P.physician_id = A.PHYSICIAN_physician_id
INNER JOIN mydb.PATIENT PA ON PA.patient_id = A.PATIENT_patient_id
WHERE physician_id = 1001001;

-- Doctors can order or create a new test for given patient
-- UI  3

SELECT * FROM mydb.TEST_ORDER;

INSERT INTO TEST_ORDER VALUES (4000122, 1001011,3000109, 'MRI and PET');

-- Doctors can update after visit summary column of their patients after their visit, based on patient id and appointment id

UPDATE  APPOINTMENT SET  visit_summary = 'Iron supplement medication prescribed'
WHERE appointment_id = 8000118;

-- Doctors can query this to find out the diagonis and screening test result of their patients, by entering their patient id
-- UI 4

SELECT CONCAT(PA.patient_First_name,' ', PA.patient_Last_name) AS Patient_Name, 
CONCAT('Dr. ', P.physician_First_name ,' ', P.physician_Last_name) AS Assigned_Doctor, DR.DIAGNOSIS_diagnosis_id, DR.screening_test
FROM DIAGNOSIS_RECORD DR
INNER JOIN PHYSICIAN P ON P.physician_id = DR.PHYSICIAN_physician_id
INNER JOIN PATIENT PA ON PA.patient_id = DR.PATIENT_patient_id
WHERE patient_id = 3000100;     


-- Patient can enter his patient id and look up for all his past and future visit information in order of date along with visit summary
-- (data populated only for patient id 3001000)

                  

SELECT PA.patient_id,CONCAT(PA.patient_First_name,' ', PA.patient_Last_name) AS Patient_Name,
CONCAT("Dr. ", P.physician_First_name, ' ', P.physician_Last_name) AS Physician_Name,
A.appointment_date,A.appointment_type, A.visit_summary
FROM APPOINTMENT A
INNER JOIN PATIENT PA ON PA.patient_id = A.PATIENT_patient_id
INNER JOIN PHYSICIAN P ON P.physician_id = A.PHYSICIAN_physician_id
WHERE patient_id = 3000100
ORDER BY 3;

-- Board members may want to surface information based on speciality of doctor, view is used 
-- creating view as a virtual data just to surface only the data user needs to see

CREATE VIEW INTERNAL_MED_DOCTOR_V AS
SELECT physician_id, physician_First_name, physician_Last_name
FROM PHYSICIAN
WHERE speciality= 'Internal Medicine';
