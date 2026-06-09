CREATE TABLE Department
(
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);


INSERT INTO Department
VALUES
(1,'Computer Science'),
(2,'Mechanical'),
(3,'Civil'),
(4,'Electrical');


CREATE TABLE Student
(
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    city VARCHAR(50),
    department_id INT,

    FOREIGN KEY (department_id)
    REFERENCES Department(department_id)
);

--drop if any existing tables

DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Department;

--start fresh

--create tables Use a small University Database with 4 tables:
/*
Department
Student
Course
Enrollment
*/

CREATE TABLE Department
(
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Department';

INSERT INTO Department
VALUES
(1,'Computer Science'),
(2,'Mechanical'),
(3,'Civil'),
(4,'Electrical');

CREATE TABLE Student
(
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    city VARCHAR(50),
    department_id INT,

    FOREIGN KEY (department_id)
    REFERENCES Department(department_id)
);

INSERT INTO Student
VALUES
(101,'John','Doe','Delhi',1),
(102,'Jane','Smith','Mumbai',2),
(103,'Bob','Johnson','Delhi',1),
(104,'Alice','Williams','Pune',3),
(105,'Tom','Brown','Mumbai',2);

CREATE TABLE Course
(
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    credits INT
);

INSERT INTO Course
VALUES
(1,'SQL',3),
(2,'Python',4),
(3,'Java',4),
(4,'Power BI',2);

CREATE TABLE Enrollment
(
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    marks INT,

    FOREIGN KEY(student_id)
    REFERENCES Student(student_id),

    FOREIGN KEY(course_id)
    REFERENCES Course(course_id)
);

INSERT INTO Enrollment
VALUES
(1,101,1,85),
(2,101,2,90),
(3,102,3,75),
(4,103,1,80),
(5,104,4,88),
(6,105,2,92);

-- basic DQL
select * from Student;

--FILTERING
SELECT first_name, city
FROM Student;

SELECT *
FROM Student
WHERE city='Delhi';

SELECT *
FROM Enrollment
WHERE marks > 80;

--update 
UPDATE Student
SET city = 'Ahmedabad'
WHERE student_id = 101;

--bulk update using WHERE
UPDATE Student
SET city='Surat'
WHERE city='Mumbai';

-- bulk update using CASE

-- before that add column in the table 

ALTER TABLE Student
ADD marks INT;

UPDATE Student
SET marks =
CASE student_id
    WHEN 101 THEN 85
    WHEN 102 THEN 92
    WHEN 103 THEN 76
    WHEN 104 THEN 88
    WHEN 105 THEN 65
END;

select * from Student;

UPDATE Student
SET marks =
CASE
    WHEN marks < 60 THEN marks + 15
    WHEN marks < 80 THEN marks + 10
    ELSE marks + 5
END;

select * from Student;

-- bulk update using SuBQUERRY

UPDATE Student
SET marks = marks + 2
WHERE department_id IN
(
    SELECT department_id
    FROM Department
    WHERE department_name = 'Computer Science'
);

SELECT * FROM Student;

-- bulk update using JOIN

ALTER TABLE Department
ADD bonus_marks INT;

UPDATE Department
SET bonus_marks =
CASE department_id
    WHEN 1 THEN 5
    WHEN 2 THEN 3
    WHEN 3 THEN 2
    WHEN 4 THEN 1
END;

UPDATE s
SET s.marks = s.marks + d.bonus_marks
FROM Student s
INNER JOIN Department d
ON s.department_id = d.department_id;

select * from Department;
select * from Student;

--DELETE
/*
DELETE FROM Student
WHERE student_id = 105;


--PROBLEM WITH ABOVE IS:

You have a relationship like this:

Student
--------
student_id (PK)

Enrollment
--------
enrollment_id
student_id (FK)
course_id
marks

Now if you delete:

DELETE FROM Student
WHERE student_id = 105;

what happens to this row?

enrollment_id	student_id	course_id => (2,105,2)

It would point to a student that no longer exists.

SQL Server prevents this and throws the error.
*/

-- SO YOU CAN DELTE USING JOIN LOGIC 

/*
DELETE FROM Enrollment
WHERE student_id = 105;

DELETE FROM Student
WHERE student_id = 105;
*/

-- OR YOU CAN CASCADE DELETE -> When a parent row is deleted, automatically delete all children

/*
CREATE TABLE Enrollment
(
    enrollment_id INT PRIMARY KEY,

    student_id INT,

    FOREIGN KEY (student_id)
    REFERENCES Student(student_id)
    ON DELETE CASCADE
);
*/

DELETE FROM Enrollment
WHERE student_id = 105;

DELETE FROM Student
WHERE student_id = 105;

select * from Student;

--INNER JOIN

SELECT s.first_name, d.department_name
FROM Student s
LEFT JOIN Department d
ON s.department_id = d.department_id; -- 4 entries

SELECT s.first_name, d.department_name
FROM Student s
RIGHT JOIN Department d
ON s.department_id = d.department_id; -- 5 entries

SELECT s.first_name, d.department_name
FROM Student s
FULL OUTER JOIN Department d
ON s.department_id = d.department_id; -- 5 ENTRIES

-- CROSS JOIN: every student paired with every course
SELECT
s.first_name,
c.course_name
FROM Student s
CROSS JOIN Course c; -- 16 entries

-- MULTI table join

SELECT
s.first_name,
c.course_name,
e.marks
FROM Student s
INNER JOIN Enrollment e
ON s.student_id=e.student_id

INNER JOIN Course c
ON e.course_id=c.course_id; -- 5 entries


-- GROUP BY

-- DEPARTMENT WISE STUDENT COUNT:

SELECT
department_id,
COUNT(*) AS total_students
FROM Student
GROUP BY department_id; --3

-- GROUP BY + JOIN
SELECT
d.department_name,
COUNT(*) AS total_students
FROM Student s
INNER JOIN Department d
ON s.department_id=d.department_id
GROUP BY d.department_name; --3

--HAVING
SELECT
department_id,
COUNT(*)
FROM Student
GROUP BY department_id
HAVING COUNT(*) > 1;--1

-- UPDATE USING JOIN
UPDATE e
SET marks = marks + 5
FROM Enrollment e
INNER JOIN Course c
ON e.course_id=c.course_id
WHERE c.course_name='SQL';

-- NESTED
SELECT *
FROM Enrollment
WHERE marks >
(
    SELECT AVG(marks)
    FROM Enrollment
);
--3

--MERGE

--Create a Staging Table
CREATE TABLE Student_Staging
(
    student_id INT,
    first_name VARCHAR(50),
    city VARCHAR(50)
);

--INSERT 
INSERT INTO Student_Staging
VALUES
(101,'John','Ahmedabad'),
(106,'Chris','Jaipur');


--MERGE
MERGE Student AS Target
USING Student_Staging AS Source

ON Target.student_id = Source.student_id

WHEN MATCHED THEN
UPDATE
SET city = Source.city

WHEN NOT MATCHED THEN
INSERT
(
    student_id,
    first_name,
    city
)
VALUES
(
    Source.student_id,
    Source.first_name,
    Source.city
);

select * from Student_Staging; --2

