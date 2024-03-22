SELECT * FROM patientsemergencyroomvisitreport.`hospital er`;
-- CONCAT PATIENT FIRST INITIAL AND LAST NAME
SELECT CONCAT(patient_first_inital, ' ',patient_last_name) as patient_name
FROM patientsemergencyroomvisitreport.`hospital er`
;

-- ADD THE PATIENT_NAME COLUMN TO TABLE
ALTER TABLE patientsemergencyroomvisitreport.`hospital er`
ADD COLUMN patient_name VARCHAR(255);

-- UPDATE THE patient_name COLUMN WITH CONCATENATED VALUES
UPDATE patientsemergencyroomvisitreport.`hospital er`
SET patient_name = CONCAT(patient_first_inital, ' ',patient_last_name);

-- CALCULATE THE TOTAL NUMBER OF PATIENTS
SELECT COUNT(*) AS Total_Patients
FROM patientsemergencyroomvisitreport.`hospital er`;

-- CALCULATE THE PERCENTAGE OF ADMINISTRATIVE PATIENTS
SELECT
(SUM(CASE WHEN patient_admin_flag ='true' THEN 1 ELSE 0 END)/ COUNT(*)) *100 AS Administrative_Percentage
FROM patientsemergencyroomvisitreport.`hospital er`;

-- CALCULATE THE PERCENTAGE OF NON-ADMINISTRATIVE PATIENTS
SELECT
(SUM(CASE WHEN patient_admin_flag ='false' THEN 1 ELSE 0 END)/ COUNT(*)) *100 AS Non_Administrative_Percentage
FROM patientsemergencyroomvisitreport.`hospital er`;

-- TO DROP UNNECESSARY TABLE
ALTER TABLE patientsemergencyroomvisitreport.`hospital er`
DROP COLUMN Administrative_percentage,
DROP COLUMN non_administrative_percentage;

-- TO CALCULATE THE COUNT AND PERCENTAGE OF FEMALE AND MALE PATIENTS IN TABLE
SELECT
SUM(CASE WHEN patient_gender = 'F' THEN 1 ELSE 0 END) AS female_count,
SUM(CASE WHEN patient_gender = 'M' THEN 1 ELSE 0 END) AS male_count,
COUNT(*) AS total_count,
(SUM(CASE WHEN patient_gender = 'F' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS female_percentage,
(SUM(CASE WHEN patient_gender = 'M' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS male_percentage
FROM 
patientsemergencyroomvisitreport.`hospital er`;

-- CALCULATE THE PERCENTAGE OF PATIENTS NOT REFERRED TO ANY DEPARTMENT
SELECT
(COUNT(CASE WHEN department_referral = 'none' THEN 1 END) / COUNT(*)) * 100 AS percentage_notreferred
FROM
patientsemergencyroomvisitreport.`hospital er`;


-- CALCULATE THE AVERAGE SATISFACTION SCORE OF PATIENT 
SELECT AVG(patient_sat_score) AS average_satisfaction_score
FROM patientsemergencyroomvisitreport.`hospital er`
WHERE patient_sat_score IS NOT NULL
AND patient_sat_score <> '';


-- CALCULATE THE AVERAGE WAIT TIME IN ER
SELECT AVG(patient_waittime) AS average_wait_time
FROM patientsemergencyroomvisitreport.`hospital er`;

-- SEPARATE THE DATE FORMAT AS AM/PM AND UPDATE TABLE WITH NEW COLUMN TIME
SELECT DATE_FORMAT(date, '%p') AS am_pm
FROM patientsemergencyroomvisitreport.`hospital er`;

ALTER TABLE patientsemergencyroomvisitreport.`hospital er`
ADD COLUMN time VARCHAR(255);

UPDATE patientsemergencyroomvisitreport.`hospital er`
SET time = DATE_FORMAT(date, '%p');


-- Separate patient as Adult, Teenager, Middle childhood, Earlychildhood, Infancy according to age
SELECT
patient_age,
CASE
WHEN patient_age >= 18 THEN 'Adult'
WHEN patient_age >= 13 AND patient_age < 18 THEN 'Teenager'
WHEN patient_age >= 6 AND patient_age < 13 THEN 'Middle Childhood'
WHEN patient_age >= 2 AND patient_age < 6 THEN 'Early Childhood'
WHEN patient_age <2 THEN 'Infancy'
ELSE 'Unknown'
END AS age_category
FROM patientsemergencyroomvisitreport.`hospital er`;

-- UPDATE TABLE  ADDING AGE_CATEGORY COLUMN
ALTER TABLE patientsemergencyroomvisitreport.`hospital er`
ADD COLUMN age_category VARCHAR(255);

UPDATE patientsemergencyroomvisitreport.`hospital er`
SET age_category = 
CASE
WHEN patient_age >= 18 THEN 'Adult'
WHEN patient_age >= 13 AND patient_age < 18 THEN 'Teenager'
WHEN patient_age >= 6 AND patient_age < 13 THEN 'Middle Childhood'
WHEN patient_age >= 2 AND patient_age < 6 THEN 'Early Childhood'
WHEN patient_age <2 THEN 'Infancy'
ELSE 'Unknown'
END;

-- CALCULATE THE TOTAL NUMBER OF PATIENTS FOR 2019 AND 2020 TO FIND WHICH YEAR HAS MORE  ER VISIT
SELECT
YEAR(date) AS year,
COUNT(*) AS num_patients
FROM
patientsemergencyroomvisitreport.`hospital er`
WHERE
YEAR(date) IN (2019, 2020)
GROUP BY
YEAR(date);

-- SEPARATE WEEKDAY OR WEEKEND
SELECT
date,
CASE
WHEN DAYOFWEEK(date) IN (2,3,4,5,6) THEN 'Weekday'
WHEN DAYOFWEEK(date) IN (1,7) THEN 'Weekend'
END AS day_type
FROM
patientsemergencyroomvisitreport.`hospital er`;

-- CALCULATE WHETHER THERE ARE MORE PATIENTS ON WEEKDAYS OR WEEKENDS
SELECT
day_type,
COUNT(*) AS patient_count
FROM
(SELECT
CASE
WHEN DAYOFWEEK(date) IN (2,3,4,5,6) THEN 'Weekday'
WHEN DAYOFWEEK(date) IN (1,7) THEN 'Weekend'
END AS day_type
FROM 
patientsemergencyroomvisitreport.`hospital er`
) AS classified_dates
GROUP BY
day_type;

-- Calculate total patients by department_referrals
SELECT
CASE
WHEN department_referral = 'General Practice' THEN 'General Practice'
WHEN department_referral = 'Orthopedics' THEN 'Orthopedics'
WHEN department_referral = 'Physiotherapy' THEN 'Physiotherapy'
WHEN department_referral = 'Cardiology' THEN 'Cardiology'
ELSE 'None'
END AS department,
COUNT(*) AS total_patients
FROM
patientsemergencyroomvisitreport.`hospital er`
GROUP BY
department;






