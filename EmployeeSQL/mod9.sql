-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

-- Modify this code to update the DB schema diagram.
-- To reset the sample schema, replace everything with
-- two dots ('..' - without quotes).

CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL
);
DROP TABLE employees 
CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);
DROP TABLE "salaries"
CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL
);

CREATE TABLE "titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_title_id" FOREIGN KEY("title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

-- Question 1: List the employee number, last name, first name, sex, and salary of each employee.
CREATE VIEW Question1 AS
SELECT e.emp_no AS "Employee #", e.first_name AS "First Name", e.last_name AS "Last Name", e.sex AS "Sex", s.salary AS "Salary"
FROM employees e
INNER JOIN salaries s ON e.emp_no=s.emp_no;

-- Question 2: List the first name, last name, and hire date for the employees who were hired in 1986.
CREATE VIEW Question2 AS
SELECT first_name AS "First Name", last_name AS "Last Name", hire_date AS "Date Hired"
FROM employees e
WHERE EXTRACT(YEAR FROM e.hire_date) = 1986;
-- Question 3: List the manager of each department along with their department number, department name, employee number, last name, and first name.
CREATE VIEW Question3 AS
SELECT d.dept_name AS "Deparment Name", dm.dept_no AS "Department #", dm. emp_no AS "Employee #", e.last_name AS "Last Name", e.first_name AS "First Name"
FROM departments d
JOIN dept_manager dm
ON d.dept_no = dm.dept_no
JOIN employees e
ON dm.emp_no = e.emp_no;
-- Question 4: List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
CREATE VIEW Question4 AS
SELECT dm.dept_no AS "Department #", e.emp_no AS "Employee #", e.last_name AS "Last Name", e.first_name AS "First Name", d.dept_name AS "Department Name"
FROM dept_manager dm
JOIN employees e
ON dm.emp_no = e.emp_no
JOIN departments d
ON dm.dept_no = d.dept_no;
-- Question 5: List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
CREATE VIEW Question5 AS
SELECT e.first_name AS "First Name", e.last_name AS "Last Name", e.sex AS "Sex"
FROM employees e
WHERE e.first_name = 'Hercules' AND e.last_name LIKE 'B%';
-- Question 6: List each employee in the Sales department, including their employee number, last name, and first name.
CREATE VIEW Question6 AS
SELECT e.emp_no AS "Employee #", e.last_name AS "Last Name", e.first_name AS "First Name"
FROM departments d
JOIN dept_emp de 
ON d.dept_no = de.dept_no 
JOIN employees e
ON de.emp_no = e.emp_no
WHERE d.dept_name = 'Sales';

-- Question 7: List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
CREATE VIEW Question7 AS
SELECT e.emp_no AS "Employee #", e.last_name AS "Last Name", e.first_name AS "First Name", d.dept_name AS "Department Name"
FROM departments d
JOIN dept_emp de 
ON d.dept_no = de.dept_no 
JOIN employees e
ON de.emp_no = e.emp_no
WHERE d.dept_name = 'Sales' OR d.dept_name = 'Development';
-- Question 8: List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
CREATE VIEW Question8 AS
SELECT e.last_name AS "Last Name", COUNT(e.last_name) AS "Frequency"
FROM employees e
GROUP BY e.last_name
HAVING COUNT(e.last_name) > 1
ORDER BY "Frequency" DESC;