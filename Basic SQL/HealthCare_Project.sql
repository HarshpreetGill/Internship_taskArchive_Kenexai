-- TASK 2

--PART A

CREATE DATABASE HealthCarePlus_DB;
GO
USE HealthCarePlus_DB;
GO
 
-- PART B

CREATE TABLE Department
(
    dept_id INT IDENTITY(1,1) PRIMARY KEY,

    dept_name VARCHAR(100) NOT NULL,

    location VARCHAR(100) NOT NULL,

    head_doctor_id INT NULL
);

CREATE TABLE Patient
(
    patient_id INT IDENTITY(1,1) PRIMARY KEY,

    first_name VARCHAR(50) NOT NULL,

    last_name VARCHAR(50) NOT NULL,

    date_of_birth DATE NOT NULL,

    gender VARCHAR(10)
        CHECK (gender IN ('Male','Female','Other')),

    phone VARCHAR(15) NOT NULL,

    email VARCHAR(100) UNIQUE,

    address VARCHAR(255),

    blood_group VARCHAR(5)
        CHECK
        (
            blood_group IN
            ('A+','A-','B+','B-','AB+','AB-','O+','O-')
        ),

    insurance_provider VARCHAR(100),

    registration_date DATE
        DEFAULT GETDATE(),

    is_active BIT
        DEFAULT 1
);

CREATE TABLE Doctor
(
    doctor_id INT IDENTITY(1,1) PRIMARY KEY,

    first_name VARCHAR(50) NOT NULL,

    last_name VARCHAR(50) NOT NULL,

    specialization VARCHAR(100) NOT NULL,

    phone VARCHAR(15) NOT NULL,

    email VARCHAR(100) UNIQUE,

    dept_id INT NOT NULL,

    FOREIGN KEY (dept_id)
    REFERENCES Department(dept_id)
);

CREATE TABLE Appointment
(
    appt_id INT IDENTITY(1,1) PRIMARY KEY,

    patient_id INT NOT NULL,

    doctor_id INT NOT NULL,

    appointment_date DATE NOT NULL,

    appointment_time TIME NOT NULL,

    status VARCHAR(20)
        DEFAULT 'Scheduled'

        CHECK
        (
            status IN
            (
                'Scheduled',
                'Completed',
                'Cancelled'
            )
        ),

    FOREIGN KEY (patient_id)
    REFERENCES Patient(patient_id),

    FOREIGN KEY (doctor_id)
    REFERENCES Doctor(doctor_id)
);

CREATE TABLE Medical_Record
(
    record_id INT IDENTITY(1,1) PRIMARY KEY,

    patient_id INT NOT NULL,

    diagnosis VARCHAR(255) NOT NULL,

    treatment VARCHAR(255),

    record_date DATE
        DEFAULT GETDATE(),

    FOREIGN KEY (patient_id)
    REFERENCES Patient(patient_id)
);

CREATE TABLE Prescription
(
    prescription_id INT IDENTITY(1,1) PRIMARY KEY,

    record_id INT NOT NULL,

    medication VARCHAR(100) NOT NULL,

    dosage VARCHAR(100) NOT NULL,

    FOREIGN KEY (record_id)
    REFERENCES Medical_Record(record_id)
);

CREATE TABLE Billing
(
    bill_id INT IDENTITY(1,1) PRIMARY KEY,

    patient_id INT NOT NULL,

    amount DECIMAL(10,2)
        CHECK (amount >= 0),

    payment_status VARCHAR(20)
        DEFAULT 'Pending'

        CHECK
        (
            payment_status IN
            (
                'Pending',
                'Paid',
                'Cancelled'
            )
        ),

    bill_date DATE
        DEFAULT GETDATE(),

    FOREIGN KEY (patient_id)
    REFERENCES Patient(patient_id)
);

-- add head_doctor foreign key

ALTER TABLE Department
ADD CONSTRAINT FK_Department_HeadDoctor
FOREIGN KEY (head_doctor_id)
REFERENCES Doctor(doctor_id);

--verify 
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

--TASK 4

--insert departments
INSERT INTO Department
(dept_name, location, head_doctor_id)
VALUES
('Cardiology','Ahmedabad',NULL),
('Neurology','Mumbai',NULL),
('Pediatrics','Delhi',NULL),
('Orthopedics','Pune',NULL),
('Emergency','Bangalore',NULL);

--insert doctors

INSERT INTO Doctor
(
first_name,
last_name,
specialization,
phone,
email,
dept_id
)
VALUES
('Amit','Sharma','Cardiologist','+91-9876543210','amit.sharma@email.com',1),
('Neha','Patel','Cardiologist','+91-9876543211','neha.patel@email.com',1),

('Raj','Verma','Neurologist','+91-9876543212','raj.verma@email.com',2),
('Priya','Singh','Neurologist','+91-9876543213','priya.singh@email.com',2),

('Anjali','Gupta','Pediatrician','+91-9876543214','anjali.gupta@email.com',3),
('Karan','Mehta','Pediatrician','+91-9876543215','karan.mehta@email.com',3),

('Vikas','Joshi','Orthopedic Surgeon','+91-9876543216','vikas.joshi@email.com',4),
('Ritu','Nair','Orthopedic Surgeon','+91-9876543217','ritu.nair@email.com',4),

('Suresh','Iyer','Emergency Specialist','+91-9876543218','suresh.iyer@email.com',5),
('Pooja','Reddy','Emergency Specialist','+91-9876543219','pooja.reddy@email.com',5);

-- assign department heads

UPDATE Department
SET head_doctor_id =
CASE dept_id
WHEN 1 THEN 1
WHEN 2 THEN 3
WHEN 3 THEN 5
WHEN 4 THEN 7
WHEN 5 THEN 9
END;

-- insert 20 patients

INSERT INTO Patient
(
first_name,last_name,date_of_birth,gender,
phone,email,address,blood_group,
insurance_provider
)
VALUES
('Rahul','Shah','1990-05-10','Male','+91-9000000001','rahul.shah@email.com','Ahmedabad','A+','Star Health'),
('Sneha','Patel','1988-08-20','Female','+91-9000000002','sneha.patel@email.com','Mumbai','B+','ICICI Lombard'),
('Arjun','Mehta','1995-03-15','Male','+91-9000000003','arjun.mehta@email.com','Delhi','O+','HDFC Ergo'),
('Kavya','Rao','1992-11-22','Female','+91-9000000004','kavya.rao@email.com','Pune','AB+','Star Health'),
('Rohan','Verma','1985-07-05','Male','+91-9000000005','rohan.verma@email.com','Bangalore','A-','Bajaj Allianz'),
('Priya','Nair','1998-09-14','Female','+91-9000000006','priya.nair@email.com','Chennai','O-','Niva Bupa'),
('Aditya','Gupta','1991-02-18','Male','+91-9000000007','aditya.gupta@email.com','Jaipur','B-','Care Health'),
('Pallavi','Joshi','1994-12-01','Female','+91-9000000008','pallavi.joshi@email.com','Surat','AB-','ICICI Lombard'),
('Nitin','Singh','1987-06-12','Male','+91-9000000009','nitin.singh@email.com','Lucknow','A+','Star Health'),
('Meera','Kapoor','1993-01-30','Female','+91-9000000010','meera.kapoor@email.com','Indore','B+','HDFC Ergo'),

('Aakash','Sharma','1997-04-11','Male','+91-9000000011','aakash.sharma@email.com','Ahmedabad','O+','Care Health'),
('Ritika','Das','1996-10-09','Female','+91-9000000012','ritika.das@email.com','Kolkata','AB+','Star Health'),
('Vivek','Reddy','1989-08-03','Male','+91-9000000013','vivek.reddy@email.com','Hyderabad','A-','Niva Bupa'),
('Ananya','Iyer','1991-05-17','Female','+91-9000000014','ananya.iyer@email.com','Chennai','O-','ICICI Lombard'),
('Deepak','Malhotra','1984-09-21','Male','+91-9000000015','deepak.m@email.com','Delhi','B+','Bajaj Allianz'),
('Pooja','Kulkarni','1999-02-13','Female','+91-9000000016','pooja.k@email.com','Pune','A+','Star Health'),
('Sanjay','Tiwari','1986-03-28','Male','+91-9000000017','sanjay.t@email.com','Kanpur','O+','Care Health'),
('Neelam','Bansal','1990-07-19','Female','+91-9000000018','neelam.b@email.com','Jaipur','AB-','HDFC Ergo'),
('Harsh','Chopra','1995-12-07','Male','+91-9000000019','harsh.c@email.com','Mumbai','A+','Niva Bupa'),
('Divya','Menon','1993-06-25','Female','+91-9000000020','divya.m@email.com','Kochi','B-','Star Health');

SELECT COUNT(*) AS Departments FROM Department;
SELECT COUNT(*) AS Doctors FROM Doctor;
SELECT COUNT(*) AS Patients FROM Patient;

--insert 30 appointments

INSERT INTO Appointment
(patient_id, doctor_id, appointment_date, appointment_time, status)
VALUES
(1,1,'2025-01-10','09:00','Completed'),
(2,2,'2025-01-12','10:00','Completed'),
(3,3,'2025-01-15','11:00','Completed'),
(4,4,'2025-01-18','14:00','Completed'),
(5,5,'2025-01-20','15:00','Completed'),
(6,6,'2025-01-22','09:30','Completed'),
(7,7,'2025-01-25','10:30','Completed'),
(8,8,'2025-01-28','11:30','Completed'),
(9,9,'2025-02-01','12:00','Completed'),
(10,10,'2025-02-03','13:00','Completed'),

(11,1,'2025-02-05','09:00','Completed'),
(12,2,'2025-02-08','10:00','Completed'),
(13,3,'2025-02-10','11:00','Completed'),
(14,4,'2025-02-12','14:00','Completed'),
(15,5,'2025-02-15','15:00','Completed'),

(16,6,'2026-07-10','09:00','Scheduled'),
(17,7,'2026-07-12','10:00','Scheduled'),
(18,8,'2026-07-15','11:00','Scheduled'),
(19,9,'2026-07-18','14:00','Scheduled'),
(20,10,'2026-07-20','15:00','Scheduled'),

(1,3,'2026-07-22','09:00','Scheduled'),
(2,4,'2026-07-25','10:00','Scheduled'),
(3,5,'2026-07-28','11:00','Scheduled'),
(4,6,'2026-08-01','12:00','Scheduled'),
(5,7,'2026-08-03','13:00','Scheduled'),

(6,8,'2025-03-10','09:00','Cancelled'),
(7,9,'2025-03-12','10:00','Cancelled'),
(8,10,'2025-03-15','11:00','Cancelled'),
(9,1,'2025-03-18','14:00','Cancelled'),
(10,2,'2025-03-20','15:00','Cancelled');

--insert 15 medical records
INSERT INTO Medical_Record
(patient_id, diagnosis, treatment, record_date)
VALUES
(1,'Hypertension','Blood pressure medication','2025-01-10'),
(2,'Heart Arrhythmia','Cardiac monitoring','2025-01-12'),
(3,'Migraine','Pain management therapy','2025-01-15'),
(4,'Epilepsy','Medication prescribed','2025-01-18'),
(5,'Asthma','Inhaler treatment','2025-01-20'),
(6,'Viral Fever','Rest and medication','2025-01-22'),
(7,'Fractured Arm','Casting procedure','2025-01-25'),
(8,'Knee Pain','Physiotherapy','2025-01-28'),
(9,'Food Poisoning','IV fluids','2025-02-01'),
(10,'Chest Infection','Antibiotics','2025-02-03'),
(11,'Diabetes','Diet and medication','2025-02-05'),
(12,'Anxiety','Counseling','2025-02-08'),
(13,'Back Pain','Physical therapy','2025-02-10'),
(14,'Allergy','Antihistamines','2025-02-12'),
(15,'High Cholesterol','Lifestyle changes','2025-02-15');

-- insert 25 prescriptions
INSERT INTO Prescription
(record_id, medication, dosage)
VALUES
(1,'Amlodipine','5mg daily'),
(1,'Losartan','50mg daily'),

(2,'Metoprolol','25mg daily'),
(2,'Aspirin','75mg daily'),

(3,'Sumatriptan','50mg as needed'),

(4,'Levetiracetam','500mg twice daily'),
(4,'Vitamin B Complex','1 tablet daily'),

(5,'Salbutamol Inhaler','2 puffs daily'),

(6,'Paracetamol','500mg three times daily'),

(7,'Calcium Supplement','1 tablet daily'),
(7,'Pain Reliever','As required'),

(8,'Ibuprofen','400mg twice daily'),

(9,'ORS','After every loose stool'),
(9,'Antibiotic','Twice daily'),

(10,'Azithromycin','500mg daily'),

(11,'Metformin','500mg twice daily'),
(11,'Vitamin D','Weekly'),

(12,'Escitalopram','10mg daily'),

(13,'Muscle Relaxant','Twice daily'),
(13,'Pain Gel','Apply locally'),

(14,'Cetirizine','10mg daily'),

(15,'Atorvastatin','20mg daily'),

(5,'Montelukast','10mg nightly'),
(10,'Cough Syrup','10ml twice daily'),
(3,'Naproxen','250mg daily');

-- insert 20 billing records
INSERT INTO Billing
(patient_id, amount, payment_status, bill_date)
VALUES
(1,2500,'Paid','2025-01-10'),
(2,12000,'Paid','2025-01-12'),
(3,1800,'Paid','2025-01-15'),
(4,15000,'Paid','2025-01-18'),
(5,2200,'Paid','2025-01-20'),

(6,1200,'Pending','2025-01-22'),
(7,18000,'Paid','2025-01-25'),
(8,3500,'Paid','2025-01-28'),
(9,5000,'Pending','2025-02-01'),
(10,4200,'Paid','2025-02-03'),

(11,2500,'Paid','2025-02-05'),
(12,3000,'Cancelled','2025-02-08'),
(13,4500,'Paid','2025-02-10'),
(14,2000,'Pending','2025-02-12'),
(15,8000,'Paid','2025-02-15'),

(16,1500,'Pending','2025-03-01'),
(17,25000,'Paid','2025-03-05'),
(18,900,'Paid','2025-03-08'),
(19,50000,'Pending','2025-03-12'),
(20,7000,'Paid','2025-03-15');

SELECT COUNT(*) AS Departments FROM Department;
SELECT COUNT(*) AS Doctors FROM Doctor;
SELECT COUNT(*) AS Patients FROM Patient;
SELECT COUNT(*) AS Appointments FROM Appointment;
SELECT COUNT(*) AS MedicalRecords FROM Medical_Record;
SELECT COUNT(*) AS Prescriptions FROM Prescription;
SELECT COUNT(*) AS BillingRecords FROM Billing;

-- TASK 5

-- 1. Display all patients' names and contact information
SELECT
    first_name,
    last_name,
    phone,
    email,
    address
FROM Patient;

--2. List all Doctors in Cardiology department
SELECT
    d.first_name,
    d.last_name,
    d.specialization
FROM Doctor d
INNER JOIN Department dp
ON d.dept_id = dp.dept_id
WHERE dp.dept_name = 'Cardiology';

--3. Show appointments scheduled for today
SELECT *
FROM Appointment
WHERE appointment_date = CAST(GETDATE() AS DATE);

--4. Find all patients with 'O+' Blood group
SELECT
    patient_id,
    first_name,
    last_name,
    blood_group
FROM Patient
WHERE blood_group = 'O+';

--5. Display billing records with amount > ₹10,000 ordered by amount DESC
SELECT *
FROM Billing
WHERE amount > 10000
ORDER BY amount DESC;

--6. List top 5 most expensive bills
SELECT TOP 5 *
FROM Billing
ORDER BY amount DESC;

--7. Count total number of patients registered in 2024
SELECT COUNT(*) AS total_patients_2024
FROM Patient
WHERE YEAR(registration_date) = 2024;

--8. Show unique specializations of doctors
SELECT DISTINCT specialization
FROM Doctor;

--9. Find patients whose names start with 'A'
SELECT
    patient_id,
    first_name,
    last_name
FROM Patient
WHERE first_name LIKE 'A%';

--10. Display appointments between '2024-01-01' and '2024-12-31'
SELECT *
FROM Appointment
WHERE appointment_date
BETWEEN '2024-01-01'
AND '2024-12-31';


-- TASK 5

--1. CONCAT
SELECT
    patient_id,
    CONCAT(first_name, ' ', last_name) AS full_name
FROM Patient;

--2. UPPER
SELECT
    UPPER(CONCAT(first_name, ' ', last_name)) AS doctor_name
FROM Doctor;

--3. SUBSTRING
SELECT
    first_name,
    SUBSTRING(first_name, 1, 3) AS first_three_characters
FROM Patient;

--4. LENGTH
SELECT
    patient_id,
    CONCAT(first_name, ' ', last_name) AS full_name
FROM Patient
WHERE LEN(CONCAT(first_name, ' ', last_name)) > 15;

--5. TRIM
SELECT
    email,
    LTRIM(RTRIM(email)) AS cleaned_email
FROM Patient;

--6. REPLACE
SELECT
    REPLACE(
        CONCAT('Dr. ', first_name, ' ', last_name),
        'Dr.',
        'Doctor'
    ) AS doctor_name
FROM Doctor;

--7. CONCAT_WS
SELECT
    patient_id,
    CONCAT_WS(', ',
              address,
              blood_group,
              insurance_provider) AS formatted_details
FROM Patient;

--8. Create Email Format
SELECT
    first_name,
    last_name,
    LOWER(
        CONCAT(
            first_name,
            '.',
            last_name,
            '@healthcareplus.com'
        )
    ) AS generated_email
FROM Doctor;


-- TASK 7

--1. Age Calculation
SELECT
    patient_id,
    first_name,
    last_name,
    date_of_birth,
    DATEDIFF(YEAR, date_of_birth, GETDATE())
    - CASE
        WHEN DATEADD(YEAR,
                     DATEDIFF(YEAR, date_of_birth, GETDATE()),
                     date_of_birth) > GETDATE()
        THEN 1
        ELSE 0
      END AS age
FROM Patient;

-- 2. Show Appointment Schedule today
SELECT *
FROM Appointment
WHERE appointment_date = CAST(GETDATE() AS DATE);

--3. Date format
SELECT
    appt_id,
    FORMAT(appointment_date, 'dd-MM-yyyy') + ' ' +
    FORMAT(CAST(appointment_time AS DATETIME), 'hh:mm tt')
    AS formatted_appointment
FROM Appointment;

--4. Find patients registered more than 365 days ago
SELECT *
FROM Patient
WHERE DATEDIFF(DAY, registration_date, GETDATE()) > 365;

--5. Find appointments scheduled within next 7 days
SELECT *
FROM Appointment
WHERE appointment_date
BETWEEN CAST(GETDATE() AS DATE)
AND DATEADD(DAY, 7, CAST(GETDATE() AS DATE));

--6. List all appointments grouped by month
SELECT
    YEAR(appointment_date) AS appointment_year,
    MONTH(appointment_date) AS appointment_month,
    COUNT(*) AS total_appointments
FROM Appointment
GROUP BY
    YEAR(appointment_date),
    MONTH(appointment_date)
ORDER BY
    appointment_year,
    appointment_month;

--7. Show which day of the week each appointment falls on
SELECT
    appt_id,
    appointment_date,
    DATENAME(WEEKDAY, appointment_date) AS day_name
FROM Appointment;

--8. Find patients born in the 1990s
SELECT *
FROM Patient
WHERE YEAR(date_of_birth)
BETWEEN 1990 AND 1999;

--9. Calculate days since last appointment for each patient
SELECT
    patient_id,
    MAX(appointment_date) AS last_appointment_date,
    DATEDIFF(
        DAY,
        MAX(appointment_date),
        GETDATE()
    ) AS days_since_last_appointment
FROM Appointment
GROUP BY patient_id;

--10. Show billing records from current month
SELECT *
FROM Billing
WHERE MONTH(bill_date) = MONTH(GETDATE())
AND YEAR(bill_date) = YEAR(GETDATE());


--TASK 8

--1. SUM
SELECT
    SUM(amount) AS total_revenue
FROM Billing;

--2. AVERAGE
SELECT
    patient_id,
    AVG(amount) AS average_bill_amount
FROM Billing
GROUP BY patient_id;

--3. COUNT
SELECT
    doctor_id,
    COUNT(*) AS total_appointments
FROM Appointment
GROUP BY doctor_id;

--4. MAX/MIN
SELECT
    MAX(amount) AS highest_bill,
    MIN(amount) AS lowest_bill
FROM Billing;

--5. ROUND
SELECT
    bill_id,
    amount,
    ROUND(amount, -2) AS rounded_amount
FROM Billing;

--6. CEILING/FLOOR
SELECT
    bill_id,
    amount,
    CEILING(amount) AS rounded_up,
    FLOOR(amount) AS rounded_down
FROM Billing;

--7. GROUP BY
SELECT
    d.dept_name,
    SUM(b.amount) AS total_billing
FROM Department d
INNER JOIN Doctor doc
    ON d.dept_id = doc.dept_id
INNER JOIN Appointment a
    ON doc.doctor_id = a.doctor_id
INNER JOIN Billing b
    ON a.patient_id = b.patient_id
GROUP BY d.dept_name;

--8. HAVING
SELECT
    d.dept_name,
    COUNT(doc.doctor_id) AS total_doctors
FROM Department d
INNER JOIN Doctor doc
    ON d.dept_id = doc.dept_id
GROUP BY d.dept_name
HAVING COUNT(doc.doctor_id) > 2;

--9. Calculate total prescriptions per medical record
SELECT
    record_id,
    COUNT(*) AS total_prescriptions
FROM Prescription
GROUP BY record_id;

--10. Find department with highest total billing
SELECT TOP 1
    d.dept_name,
    SUM(b.amount) AS total_billing
FROM Department d
INNER JOIN Doctor doc
    ON d.dept_id = doc.dept_id
INNER JOIN Appointment a
    ON doc.doctor_id = a.doctor_id
INNER JOIN Billing b
    ON a.patient_id = b.patient_id
GROUP BY d.dept_name
ORDER BY total_billing DESC;

--TASK 9

--1. INNER JOIN
SELECT
    a.appt_id,
    p.first_name + ' ' + p.last_name AS patient_name,
    d.first_name + ' ' + d.last_name AS doctor_name,
    a.appointment_date,
    a.appointment_time,
    a.status
FROM Appointment a
INNER JOIN Patient p
    ON a.patient_id = p.patient_id
INNER JOIN Doctor d
    ON a.doctor_id = d.doctor_id;

--2. LEFT JOIN
SELECT
    p.patient_id,
    p.first_name + ' ' + p.last_name AS patient_name,
    a.appt_id,
    a.appointment_date,
    a.status
FROM Patient p
LEFT JOIN Appointment a
    ON p.patient_id = a.patient_id;

--3. RIGHT JOIN
SELECT
    d.doctor_id,
    d.first_name + ' ' + d.last_name AS doctor_name,
    a.appt_id,
    a.appointment_date,
    a.status
FROM Appointment a
RIGHT JOIN Doctor d
    ON a.doctor_id = d.doctor_id;

--4. MULTIPLE JOINS

SELECT
    p.first_name + ' ' + p.last_name AS patient_name,
    d.first_name + ' ' + d.last_name AS doctor_name,
    mr.diagnosis,
    mr.treatment
FROM Appointment a
INNER JOIN Patient p
    ON a.patient_id = p.patient_id
INNER JOIN Doctor d
    ON a.doctor_id = d.doctor_id
INNER JOIN Medical_Record mr
    ON p.patient_id = mr.patient_id
WHERE a.status = 'Completed';

--5. JOIN PATIENTS, APPOINTMENTS AND BILLING
SELECT
    p.patient_id,
    p.first_name + ' ' + p.last_name AS patient_name,
    COUNT(a.appt_id) AS total_appointments,
    SUM(b.amount) AS total_billing
FROM Patient p
LEFT JOIN Appointment a
    ON p.patient_id = a.patient_id
LEFT JOIN Billing b
    ON p.patient_id = b.patient_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name;

--6. DISPLAY DOCTOR NAME, DEPTARTMENT NAME AND SPECIALISATION
SELECT
    d.first_name + ' ' + d.last_name AS doctor_name,
    dp.dept_name,
    d.specialization
FROM Doctor d
INNER JOIN Department dp
    ON d.dept_id = dp.dept_id;

--7. LIST ALL PRESCRIPTIONS WITH PATIENT NAME AND MEDICATION DETAILS
SELECT
    p.first_name + ' ' + p.last_name AS patient_name,
    pr.medication,
    pr.dosage
FROM Prescription pr
INNER JOIN Medical_Record mr
    ON pr.record_id = mr.record_id
INNER JOIN Patient p
    ON mr.patient_id = p.patient_id;

--8. SHOW APPOINTMENT DETAILS AND DEPARTMENT INFORMATION
SELECT
    a.appt_id,
    a.appointment_date,
    a.status,
    dp.dept_name,
    dp.location
FROM Appointment a
INNER JOIN Doctor d
    ON a.doctor_id = d.doctor_id
INNER JOIN Department dp
    ON d.dept_id = dp.dept_id;

--9. FIND PATIENTS WHO HAVE VISITED MULTIPLE DEPARTMENTS
SELECT
    p.patient_id,
    p.first_name + ' ' + p.last_name AS patient_name,
    COUNT(DISTINCT dp.dept_id) AS departments_visited
FROM Patient p
INNER JOIN Appointment a
    ON p.patient_id = a.patient_id
INNER JOIN Doctor d
    ON a.doctor_id = d.doctor_id
INNER JOIN Department dp
    ON d.dept_id = dp.dept_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name
HAVING COUNT(DISTINCT dp.dept_id) > 1;

--10. COMPREHENSIVE REPORT
SELECT
    p.first_name + ' ' + p.last_name AS patient_name,
    a.appointment_date,
    d.first_name + ' ' + d.last_name AS doctor_name,
    mr.diagnosis,
    b.amount AS bill_amount
FROM Patient p
INNER JOIN Appointment a
    ON p.patient_id = a.patient_id
INNER JOIN Doctor d
    ON a.doctor_id = d.doctor_id
LEFT JOIN Medical_Record mr
    ON p.patient_id = mr.patient_id
LEFT JOIN Billing b
    ON p.patient_id = b.patient_id
ORDER BY a.appointment_date;


--TASK 10

--1. Find patients who have appointments with doctors from 'Cardiology' department
SELECT *
FROM Patient
WHERE patient_id IN
(
    SELECT a.patient_id
    FROM Appointment a
    INNER JOIN Doctor d
        ON a.doctor_id = d.doctor_id
    INNER JOIN Department dp
        ON d.dept_id = dp.dept_id
    WHERE dp.dept_name = 'Cardiology'
);

--2. List doctors who have more appointments than the average
SELECT
    doctor_id,
    COUNT(*) AS total_appointments
FROM Appointment
GROUP BY doctor_id
HAVING COUNT(*) >
(
    SELECT AVG(appointment_count)
    FROM
    (
        SELECT COUNT(*) AS appointment_count
        FROM Appointment
        GROUP BY doctor_id
    ) AS DoctorCounts
);

--3. Find the department with the most patients
SELECT TOP 1
    dp.dept_name,
    COUNT(DISTINCT a.patient_id) AS patient_count
FROM Department dp
INNER JOIN Doctor d
    ON dp.dept_id = d.dept_id
INNER JOIN Appointment a
    ON d.doctor_id = a.doctor_id
GROUP BY dp.dept_name
ORDER BY patient_count DESC;

--4. Show patients whose total billing is above averag
SELECT
    patient_id,
    SUM(amount) AS total_billing
FROM Billing
GROUP BY patient_id
HAVING SUM(amount) >
(
    SELECT AVG(total_bill)
    FROM
    (
        SELECT SUM(amount) AS total_bill
        FROM Billing
        GROUP BY patient_id
    ) AS BillingTotals
);

--5. List appointments scheduled on the same day as Rahul's appointment
SELECT *
FROM Appointment
WHERE appointment_date =
(
    SELECT TOP 1 a.appointment_date
    FROM Appointment a
    INNER JOIN Patient p
        ON a.patient_id = p.patient_id
    WHERE p.first_name = 'Rahul'
);

--6. Find doctors who have never had an appointment cancelled
SELECT *
FROM Doctor
WHERE doctor_id NOT IN
(
    SELECT DISTINCT doctor_id
    FROM Appointment
    WHERE status = 'Cancelled'
);

--7. Show patients who have been prescribed a specific medication
SELECT *
FROM Patient
WHERE patient_id IN
(
    SELECT mr.patient_id
    FROM Medical_Record mr
    INNER JOIN Prescription p
        ON mr.record_id = p.record_id
    WHERE p.medication = 'Aspirin'
);

--8. Find the most expensive medical procedure (highest billing amount)
SELECT *
FROM Billing
WHERE amount =
(
    SELECT MAX(amount)
    FROM Billing
);

--9. List departments where all doctors have at least one appointment

SELECT dept_name
FROM Department dp
WHERE NOT EXISTS
(
    SELECT *
    FROM Doctor d
    WHERE d.dept_id = dp.dept_id
    AND NOT EXISTS
    (
        SELECT *
        FROM Appointment a
        WHERE a.doctor_id = d.doctor_id
    )
);

--10. Find patients who visited the hospital more than 3 times
SELECT *
FROM Patient
WHERE patient_id IN
(
    SELECT patient_id
    FROM Appointment
    GROUP BY patient_id
    HAVING COUNT(*) > 3
);

--TASK 11

--1. Categorize Patients by Age
SELECT
    patient_id,
    first_name,
    last_name,
    DATEDIFF(YEAR, date_of_birth, GETDATE()) AS age,
    CASE
        WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) < 18
            THEN 'Child'
        WHEN DATEDIFF(YEAR, date_of_birth, GETDATE()) BETWEEN 18 AND 60
            THEN 'Adult'
        ELSE 'Senior'
    END AS age_category
FROM Patient;

--2. Classify billing amounts
SELECT
    bill_id,
    amount,
    CASE
        WHEN amount < 5000
            THEN 'Small'
        WHEN amount BETWEEN 5000 AND 20000
            THEN 'Medium'
        ELSE 'Large'
    END AS billing_category
FROM Billing;

--3. Mark appointments as recent or old
SELECT
    appt_id,
    appointment_date,
    CASE
        WHEN DATEDIFF(DAY, appointment_date, GETDATE()) <= 30
            THEN 'Recent'
        ELSE 'Old'
    END AS appointment_status
FROM Appointment;

--4. Assign priority to Appointments
SELECT
    a.appt_id,
    d.specialization,
    dp.dept_name,
    CASE
        WHEN dp.dept_name = 'Emergency'
            THEN 'Emergency'
        WHEN dp.dept_name IN ('Cardiology','Neurology')
            THEN 'Urgent'
        ELSE 'Regular'
    END AS priority_level
FROM Appointment a
INNER JOIN Doctor d
    ON a.doctor_id = d.doctor_id
INNER JOIN Department dp
    ON d.dept_id = dp.dept_id;

--5. Payment status description
SELECT
    bill_id,
    payment_status,
    CASE
        WHEN payment_status = 'Paid'
            THEN 'Settled'
        WHEN payment_status = 'Pending'
            THEN 'Due'
        ELSE 'Installment'
    END AS payment_description
FROM Billing;

--6. Categorise doctors by experience 
SELECT
    doctor_id,
    first_name,
    last_name,
    CASE
        WHEN DATEDIFF(YEAR, '2015-01-01', GETDATE()) < 5
            THEN 'Junior'
        WHEN DATEDIFF(YEAR, '2015-01-01', GETDATE()) BETWEEN 5 AND 15
            THEN 'Mid-Level'
        ELSE 'Senior'
    END AS experience_level
FROM Doctor;

--7. Label patients as High risk
SELECT
    patient_id,
    COUNT(*) AS total_visits,
    CASE
        WHEN COUNT(*) > 5
            THEN 'High Risk'
        ELSE 'Normal'
    END AS risk_category
FROM Appointment
GROUP BY patient_id;

--8. Create appointment time slots
SELECT
    appt_id,
    appointment_time,
    CASE
        WHEN DATEPART(HOUR, appointment_time) BETWEEN 6 AND 11
            THEN 'Morning'
        WHEN DATEPART(HOUR, appointment_time) BETWEEN 12 AND 17
            THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_slot
FROM Appointment;

--9. Assign Discount category based on loyalty 
SELECT
    patient_id,
    registration_date,
    CASE
        WHEN DATEDIFF(YEAR, registration_date, GETDATE()) >= 5
            THEN 'Gold'
        WHEN DATEDIFF(YEAR, registration_date, GETDATE()) >= 2
            THEN 'Silver'
        ELSE 'Bronze'
    END AS loyalty_category
FROM Patient;

--10. Flag records requiring follow-up
SELECT
    record_id,
    diagnosis,
    CASE
        WHEN diagnosis LIKE '%Diabetes%'
            THEN 'Requires Follow-Up'
        WHEN diagnosis LIKE '%Hypertension%'
            THEN 'Requires Follow-Up'
        WHEN diagnosis LIKE '%Heart%'
            THEN 'Requires Follow-Up'
        ELSE 'Routine'
    END AS followup_status
FROM Medical_Record;

--TASK 12

--1. DEPARTMENT PERFORMANCE DASHBOARD

SELECT
    dp.dept_name,
    COUNT(DISTINCT a.patient_id) AS total_patients,
    COUNT(a.appt_id) AS total_appointments,
    SUM(b.amount) AS total_revenue,
    AVG(b.amount) AS avg_bill_amount
FROM Department dp
JOIN Doctor d
    ON dp.dept_id = d.dept_id
JOIN Appointment a
    ON d.doctor_id = a.doctor_id
LEFT JOIN Billing b
    ON a.patient_id = b.patient_id
GROUP BY dp.dept_name;

--2. DOCTOR UTILIZATION REPORT

SELECT
    d.first_name + ' ' + d.last_name AS doctor_name,
    d.specialization,
    COUNT(a.appt_id) AS total_appointments,

    ROUND(
        100.0 *
        SUM(CASE WHEN a.status='Completed' THEN 1 ELSE 0 END)
        / COUNT(a.appt_id),
        2
    ) AS completion_rate,

    AVG(b.amount) AS avg_revenue_per_appointment

FROM Doctor d
LEFT JOIN Appointment a
    ON d.doctor_id = a.doctor_id
LEFT JOIN Billing b
    ON a.patient_id = b.patient_id

GROUP BY
    d.first_name,
    d.last_name,
    d.specialization;

--3. PATIENT HEALTH SUMMARY

SELECT
    p.first_name + ' ' + p.last_name AS patient_name,

    COUNT(a.appt_id) AS total_visits,

    MAX(a.appointment_date) AS last_visit_date,

    SUM(b.amount) AS total_amount_spent,

    MAX(mr.diagnosis) AS recent_diagnosis

FROM Patient p

LEFT JOIN Appointment a
    ON p.patient_id = a.patient_id

LEFT JOIN Billing b
    ON p.patient_id = b.patient_id

LEFT JOIN Medical_Record mr
    ON p.patient_id = mr.patient_id

GROUP BY
    p.first_name,
    p.last_name;

--4. MONTHLY REVENUE TREND
SELECT
    YEAR(bill_date) AS bill_year,
    MONTH(bill_date) AS bill_month,
    SUM(amount) AS monthly_revenue
FROM Billing
WHERE YEAR(bill_date)=YEAR(GETDATE())
GROUP BY
    YEAR(bill_date),
    MONTH(bill_date)
ORDER BY
    bill_month;

--5. PRESCRIPTION ANALYSIS
SELECT
    medication,
    COUNT(*) AS prescription_count
FROM Prescription
GROUP BY medication
ORDER BY prescription_count DESC;

--6. APPOINTMENT CANCELLATION ANALYSIS
SELECT
    d.first_name + ' ' + d.last_name AS doctor_name,

    COUNT(a.appt_id) AS total_appointments,

    SUM(
        CASE
            WHEN a.status='Cancelled'
            THEN 1
            ELSE 0
        END
    ) AS cancelled_appointments,

    ROUND(
        100.0 *
        SUM(CASE WHEN a.status='Cancelled' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS cancellation_rate

FROM Doctor d
JOIN Appointment a
    ON d.doctor_id = a.doctor_id

GROUP BY
    d.first_name,
    d.last_name;

--7.PATIENT SEGMENTATION
SELECT
    p.patient_id,

    COUNT(a.appt_id) AS visits,

    SUM(b.amount) AS spending,

    CASE
        WHEN COUNT(a.appt_id) >= 3
             AND SUM(b.amount) > 10000
        THEN 'Premium'

        WHEN COUNT(a.appt_id) >= 2
        THEN 'Regular'

        ELSE 'Occasional'
    END AS segment

FROM Patient p

LEFT JOIN Appointment a
    ON p.patient_id = a.patient_id

LEFT JOIN Billing b
    ON p.patient_id = b.patient_id

GROUP BY p.patient_id;

--8. DEPARTMENT EFFICIENCY
SELECT
    dp.dept_name,

    COUNT(a.appt_id) AS total_appointments,

    SUM(b.amount) AS department_revenue,

    AVG(b.amount) AS revenue_per_patient

FROM Department dp

JOIN Doctor d
    ON dp.dept_id=d.dept_id

JOIN Appointment a
    ON d.doctor_id=a.doctor_id

LEFT JOIN Billing b
    ON a.patient_id=b.patient_id

GROUP BY dp.dept_name;

--9. OUTSTANDING PAYMENTS REPORT
SELECT
    p.first_name,
    p.last_name,
    p.phone,
    b.amount,
    b.bill_date

FROM Billing b

JOIN Patient p
    ON b.patient_id=p.patient_id

WHERE b.payment_status='Pending'

ORDER BY b.amount DESC;

--10. COMPREHENSIVE HEALTH REPORT
SELECT
    p.first_name,
    p.last_name,
    p.gender,
    p.blood_group,

    mr.diagnosis,
    mr.treatment,

    pr.medication,

    b.amount,
    b.payment_status

FROM Patient p

LEFT JOIN Medical_Record mr
    ON p.patient_id=mr.patient_id

LEFT JOIN Prescription pr
    ON mr.record_id=pr.record_id

LEFT JOIN Billing b
    ON p.patient_id=b.patient_id;


