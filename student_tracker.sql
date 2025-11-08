
==========================================================
1. Drop existing objects (safe to rerun)
==========================================================
DROP DATABASE IF EXISTS student_tracker;
CREATE DATABASE student_tracker;
USE student_tracker;

==========================================================
2. Schema: Tables & relationships
==========================================================
Departments
CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

-- Faculty
CREATE TABLE Faculty (
    faculty_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    phone_number VARCHAR(30),
    department_id INT,
    admission_date DATE,
    experience_years INT,
    CONSTRAINT fk_faculty_dept FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Courses
CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    faculty_id INT,
    CONSTRAINT fk_course_faculty FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id)
);

-- Students
CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    dob DATE,
    gender ENUM('M','F','O'),
    email VARCHAR(150),
    phone_number VARCHAR(30),
    address TEXT,
    admission_date DATE,
    department_id INT,
    CONSTRAINT fk_student_dept FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Enrollments
CREATE TABLE Enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE,
    UNIQUE KEY uq_student_course (student_id, course_id),
    CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) REFERENCES Students(student_id),
    CONSTRAINT fk_enroll_course FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Attendance
CREATE TABLE Attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('Present','Absent','Late') NOT NULL,
    CONSTRAINT fk_att_student FOREIGN KEY (student_id) REFERENCES Students(student_id),
    CONSTRAINT fk_att_course FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Grades
CREATE TABLE Grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    marks_obtained DECIMAL(5,2) NOT NULL,
    exam_date DATE,
    CONSTRAINT fk_grade_student FOREIGN KEY (student_id) REFERENCES Students(student_id),
    CONSTRAINT fk_grade_course FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- ==========================================================
-- 3. Insert sample data (representative; expand for more tests)
-- ==========================================================
-- Departments
INSERT INTO Departments (department_name) VALUES
('Computer Science'),
('Mathematics'),
('Physics');

-- Faculty
INSERT INTO Faculty (name,email,phone_number,department_id,admission_date,experience_years)
VALUES
('Dr. A Kumar','akumar@example.com','+91-9000000001',1,'2015-07-01',10),
('Ms. S Mehta','smehta@example.com','+91-9000000002',2,'2019-09-15',6),
('Mr. R Singh','rsingh@example.com','+91-9000000003',1,'2018-01-10',7);

-- Courses
INSERT INTO Courses (course_name, faculty_id) VALUES
('Intro to Programming', 1),
('Data Structures', 1),
('Calculus I', 2),
('Physics I', 3);

-- Students
INSERT INTO Students (name,dob,gender,email,phone_number,address,admission_date,department_id)
VALUES
('Alice Sharma','2003-03-12','F','alice@example.com','+91-9000012341','City A','2021-07-01',1),
('Bob Patel','2002-11-05','M','bob@example.com','+91-9000012342','City B','2020-07-01',1),
('Chetna Rao','2004-05-20','F','chetnarao@example.com','+91-9000012343','City C','2022-07-01',2),
('Deepak Kumar','2001-01-15','M','deepak@example.com','+91-9000012344','City D','2019-07-01',1),
('Esha Verma','2003-08-21','F',NULL,'+91-9000012345','City E','2021-07-01',3);

-- Enrollments (unique constraint prevents duplicates)
INSERT INTO Enrollments (student_id, course_id, enrollment_date)
VALUES
(1,1,'2021-07-10'),
(1,2,'2021-07-10'),
(2,1,'2020-07-05'),
(2,2,'2020-07-05'),
(3,3,'2022-07-08'),
(4,1,'2019-07-10'),
(5,4,'2021-08-01');

-- Attendance
INSERT INTO Attendance (student_id, course_id, attendance_date, status) VALUES
(1,1,'2025-01-02','Present'),
(1,1,'2025-01-03','Present'),
(1,1,'2025-01-04','Absent'),
(2,1,'2025-01-02','Late'),
(2,1,'2025-01-03','Present'),
(3,3,'2025-01-03','Present'),
(4,1,'2025-01-02','Present'),
(5,4,'2025-01-02','Absent');

-- Grades
INSERT INTO Grades (student_id, course_id, marks_obtained, exam_date) VALUES
(1,1,92.50,'2025-04-10'),
(1,2,88.00,'2025-04-12'),
(2,1,71.75,'2025-04-10'),
(3,3,82.00,'2025-04-11'),
(4,1,45.00,'2025-04-10'),
(5,4,69.00,'2025-04-09');

-- ==========================================================
-- 4. CRUD examples (Low weight)
-- ==========================================================
-- INSERT example (already used above)
-- UPDATE example: update student phone number
UPDATE Students SET phone_number = '+91-9800000000' WHERE student_id = 2;

-- DELETE example: delete a dropped student (demonstration)
-- DELETE FROM Students WHERE student_id = 999; -- commented out; use with care

-- SELECT (read) example: get student record
SELECT * FROM Students WHERE student_id = 1;

-- ==========================================================
-- 5. WHERE, HAVING, LIMIT examples (Low / Medium weight)
-- ==========================================================
-- Get students enrolled in Computer Science Department (via department_id)
SELECT s.student_id, s.name, d.department_name
FROM Students s
JOIN Departments d ON s.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- Retrieve the top 3 highest-scoring students (by average marks across courses)
SELECT g.student_id, st.name,
       AVG(g.marks_obtained) AS avg_marks
FROM Grades g
JOIN Students st ON g.student_id = st.student_id
GROUP BY g.student_id
ORDER BY avg_marks DESC
LIMIT 3;

-- Find students with attendance below 75% (requires aggregate)

SELECT s.student_id, s.name,
    SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) AS present_count,
    COUNT(a.attendance_id) AS total_records,
    (SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) / NULLIF(COUNT(a.attendance_id),0)) * 100 AS attendance_percent
FROM Students s
LEFT JOIN Attendance a ON s.student_id = a.student_id
GROUP BY s.student_id
HAVING attendance_percent < 75;

-- ==========================================================
-- 6. Logical operators AND / OR / NOT (Medium weight)
-- ==========================================================
-- Students with attendance <50% AND failing (marks < 40) - join grades & attendance summary
WITH attendance_summary AS (
    SELECT student_id,
        SUM(CASE WHEN status='Present' THEN 1 ELSE 0 END) AS present_count,
        COUNT(attendance_id) AS total_count,
        (SUM(CASE WHEN status='Present' THEN 1 ELSE 0 END) / NULLIF(COUNT(attendance_id),0)) * 100 AS attendance_percent
    FROM Attendance
    GROUP BY student_id
),
avg_marks AS (
    SELECT student_id, AVG(marks_obtained) AS avg_marks FROM Grades GROUP BY student_id
)
SELECT s.student_id, s.name, m.avg_marks, a.attendance_percent
FROM Students s
LEFT JOIN avg_marks m ON s.student_id = m.student_id
LEFT JOIN attendance_summary a ON s.student_id = a.student_id
WHERE (m.avg_marks > 90) OR (a.attendance_percent = 100);

-- List faculty NOT assigned to any course
SELECT f.faculty_id, f.name
FROM Faculty f
LEFT JOIN Courses c ON f.faculty_id = c.faculty_id
WHERE c.course_id IS NULL;

-- ==========================================================
-- 7. ORDER BY & GROUP BY (Medium weight)
-- ==========================================================
-- List students alphabetically by name
SELECT student_id, name FROM Students ORDER BY name ASC;

-- Count students enrolled in each department
SELECT d.department_id, d.department_name, COUNT(s.student_id) AS student_count
FROM Departments d
LEFT JOIN Students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
ORDER BY student_count DESC;

-- Show average marks per course
SELECT c.course_id, c.course_name, AVG(g.marks_obtained) AS avg_marks
FROM Courses c
LEFT JOIN Grades g ON c.course_id = g.course_id
GROUP BY c.course_id, c.course_name;

-- ==========================================================
-- 8. Aggregate functions (High weight)
-- ==========================================================
-- Average attendance percentage of students (per course)
SELECT c.course_id, c.course_name,
    (SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) / NULLIF(COUNT(a.attendance_id),0)) * 100 AS attendance_percent
FROM Courses c
LEFT JOIN Attendance a ON c.course_id = a.course_id
GROUP BY c.course_id, c.course_name;

-- Identify highest and lowest marks obtained in each course
SELECT course_id, MAX(marks_obtained) AS max_mark, MIN(marks_obtained) AS min_mark
FROM Grades
GROUP BY course_id;

-- Total number of students per department
SELECT d.department_id, d.department_name, COUNT(s.student_id) AS total_students
FROM Departments d
LEFT JOIN Students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name;



-- ==========================================================
-- 10. Joins (High weight) - INNER, LEFT, RIGHT, FULL-like
-- ==========================================================
-- INNER JOIN: Retrieve student details with their department
SELECT s.student_id, s.name, d.department_name
FROM Students s
INNER JOIN Departments d ON s.department_id = d.department_id;

-- LEFT JOIN: students who have not enrolled in any course
SELECT s.student_id, s.name, e.enrollment_id
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

-- RIGHT JOIN: list courses that have no students assigned 
SELECT c.course_id, c.course_name, e.enrollment_id
FROM Courses c
RIGHT JOIN Enrollments e ON c.course_id = e.course_id
WHERE c.course_id IS NULL;

-- FULL OUTER JOIN emulation: students without grades and students with grades
SELECT s.student_id, s.name, g.marks_obtained
FROM Students s
LEFT JOIN Grades g ON s.student_id = g.student_id
UNION
SELECT s.student_id, s.name, g.marks_obtained
FROM Students s
RIGHT JOIN Grades g ON s.student_id = g.student_id;

-- Show students without grades using LEFT JOIN
SELECT s.student_id, s.name
FROM Students s
LEFT JOIN Grades g ON s.student_id = g.student_id
WHERE g.grade_id IS NULL;

-- ==========================================================
-- 11. Subqueries (High weight)
-- ==========================================================
-- Find students with marks above the average score (per course)
SELECT g.student_id, st.name, g.marks_obtained, g.course_id
FROM Grades g
JOIN Students st ON g.student_id = st.student_id
WHERE g.marks_obtained > (
    SELECT AVG(marks_obtained) FROM Grades WHERE course_id = g.course_id
);

-- Retrieve courses taught by faculty with at least 5 years of experience
SELECT DISTINCT c.course_id, c.course_name
FROM Courses c
WHERE c.faculty_id IN (
    SELECT faculty_id FROM Faculty WHERE experience_years >= 5
);

-- Identify students who have missed more than 1 classes (example threshold)
SELECT student_id
FROM Attendance
WHERE status = 'Absent'
GROUP BY student_id
HAVING COUNT(*) > 1;

-- ==========================================================
-- 12. Date & Time Functions (High weight)
-- ==========================================================
-- Extract month from attendance_date to analyze attendance trends
SELECT MONTH(a.attendance_date) AS month, COUNT(*) AS total_records,
       SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) AS present_count
FROM Attendance a
GROUP BY MONTH(a.attendance_date);

-- Calculate number of years since student's admission
SELECT student_id, name, admission_date,
    TIMESTAMPDIFF(YEAR, admission_date, CURDATE()) AS years_since_admission
FROM Students;

-- Format attendance_date as DD-MM-YYYY 
SELECT attendance_id, DATE_FORMAT(attendance_date, '%d-%m-%Y') AS att_date_formatted FROM Attendance;

-- ==========================================================
-- 13. String manipulation (High weight)
-- ==========================================================
-- Convert faculty names to uppercase
SELECT faculty_id, UPPER(name) AS upper_name FROM Faculty;

-- Trim spaces and replace NULL email with 'Email Not Provided'
SELECT student_id, COALESCE(NULLIF(email,''),'Email Not Provided') AS email_display
FROM Students;

-- ==========================================================
-- 14. Window Functions (Very High weight)
-- ==========================================================
-- Rank students based on their overall marks (average across courses)
SELECT student_id, name, avg_marks,
       RANK() OVER (ORDER BY avg_marks DESC) AS rank_by_avg
FROM (
    SELECT g.student_id, s.name, AVG(g.marks_obtained) AS avg_marks
    FROM Grades g
    JOIN Students s ON g.student_id = s.student_id
    GROUP BY g.student_id
) t;

-- Show cumulative attendance percentage per course (running total of present counts)
SELECT course_id, attendance_date, present_count,
       SUM(present_count) OVER (PARTITION BY course_id ORDER BY attendance_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_present_total
FROM (
    SELECT course_id, attendance_date,
        SUM(CASE WHEN status='Present' THEN 1 ELSE 0 END) AS present_count
    FROM Attendance
    GROUP BY course_id, attendance_date
) x
ORDER BY course_id, attendance_date;

-- Display running total of students enrolled per month
SELECT enrollment_month, enroll_count,
       SUM(enroll_count) OVER (ORDER BY enrollment_month) AS running_total_enroll
FROM (
    SELECT DATE_FORMAT(enrollment_date, '%Y-%m') AS enrollment_month, COUNT(*) AS enroll_count
    FROM Enrollments
    GROUP BY DATE_FORMAT(enrollment_date, '%Y-%m')
) y;

-- ==========================================================
-- 15. CASE expressions (Very High weight)
-- ==========================================================
-- Assign performance levels using CASE
SELECT student_id, name, avg_marks,
CASE
    WHEN avg_marks > 90 THEN 'Excellent'
    WHEN avg_marks BETWEEN 75 AND 90 THEN 'Good'
    ELSE 'Needs Improvement'
END AS performance_level
FROM (
    SELECT g.student_id, s.name, AVG(g.marks_obtained) AS avg_marks
    FROM Grades g
    JOIN Students s ON g.student_id = s.student_id
    GROUP BY g.student_id
) t
ORDER BY avg_marks DESC;

-- Categorize attendance records
SELECT student_id, name,
CASE
    WHEN attendance_percent >= 80 THEN 'Regular'
    WHEN attendance_percent BETWEEN 50 AND 79.999 THEN 'Irregular'
    ELSE 'Defaulter'
END AS attendance_category
FROM (
    SELECT s.student_id, s.name,
        (SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) / NULLIF(COUNT(a.attendance_id),0)) * 100 AS attendance_percent
    FROM Students s
    LEFT JOIN Attendance a ON s.student_id = a.student_id
    GROUP BY s.student_id
) z;

-- ==========================================================
-- 16. Additional helpful queries & admin views
-- ==========================================================
-- 16.1 View: top-performing students (materialized via a CREATE VIEW)
CREATE OR REPLACE VIEW vw_top_students AS
SELECT g.student_id, s.name, AVG(g.marks_obtained) AS avg_marks
FROM Grades g
JOIN Students s ON g.student_id = s.student_id
GROUP BY g.student_id
ORDER BY avg_marks DESC;

-- 16.2 Indexes for performance (optional)
CREATE INDEX idx_student_dept ON Students(department_id);
CREATE INDEX idx_enroll_course ON Enrollments(course_id);

-- ==========================================================
-- 17. Final notes & cleanup (optional)
-- ==========================================================
-- To drop the DB when done:
-- DROP DATABASE student_tracker;
