🧮 Student Performance & Attendance Tracker

🎯 Objective

This project, Student Performance & Attendance Tracker, is designed to help institutions manage student data, attendance, and academic performance using MySQL.
It supports CRUD operations, advanced SQL queries, and report generation to provide actionable insights like top-performing students, attendance defaulters, and subject-wise analysis.

📚 Features Implemented

🔹 1. CRUD Operations

Added, updated, and deleted student and faculty records.

Managed course enrollments and attendance logging.

🔹 2. SQL Clauses (WHERE, HAVING, LIMIT)

Retrieved top 3 students with highest average marks.

Listed students with attendance below 75%.

Used HAVING and LIMIT to filter and restrict results.

🔹 3. Logical Operators (AND, OR, NOT)

Displayed students failing and having attendance below 50%.

Combined queries using AND / OR for conditional filtering.

🔹 4. Sorting & Grouping

Sorted students alphabetically and grouped them by department.

Calculated average marks per course and student count per department.

🔹 5. Aggregate Functions

Used SUM, AVG, MAX, MIN, COUNT to analyze marks and attendance.

Computed total students, average attendance %, and best/worst marks per course.

🔹 6. Relationships

Implemented Primary & Foreign Keys to maintain referential integrity.

Prevented duplicate enrollments using a unique composite key.

🔹 7. Joins (INNER, LEFT, RIGHT, FULL)

INNER JOIN for student–department details.

LEFT JOIN to list students not enrolled in any course.

RIGHT JOIN to identify unassigned courses.

FULL OUTER JOIN (via UNION) to merge results for all students and grades.

🔹 8. Subqueries

Found students with marks above course average.

Retrieved courses taught by faculty with ≥5 years of experience.

Identified students who missed more than 10 classes.

🔹 9. Date & Time Functions

Extracted month from attendance date.

Calculated years since admission.

Formatted dates in DD-MM-YYYY format.

🔹 10. String Functions

Converted faculty names to UPPERCASE.

Trimmed and replaced NULL email values with "Email Not Provided".

🔹 11. Window Functions

Ranked students by overall marks.

Displayed cumulative attendance % and running enrollment totals per month.

🔹 12. CASE Expressions

Categorized students by Performance (Excellent, Good, Needs Improvement).

Classified attendance as Regular, Irregular, or Defaulter.

🔹 13. Extras

Created a view (vw_top_students) showing top performers.

Added indexes for query performance optimization.
