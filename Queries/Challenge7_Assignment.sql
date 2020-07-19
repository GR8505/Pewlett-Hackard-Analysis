-- Creating tables for PH-EmployeeDB
-- Creating table for departments
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

-- Creating table for employees
CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

-- Creating table for dept_manager
CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

-- Creating table for salaries
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

-- Creating table for dept_emp
CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
  PRIMARY KEY (emp_no, dept_no)
);

-- Creating table for titles
CREATE TABLE titles (
    emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no, title, from_date)
);

-- Checking how many employees are ready for retirement
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- Searching for employees who were born in 1952
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- Searching for employees who were born in 1953
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

-- Searching for employees who were born in 1954
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

-- Searching for employees who were born in 1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Refining Retirement eligibility search and creating new retirement info table
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Viewing retirement info table
SELECT * FROM retirement_info;

-- Drop retirement info table
DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement info and dept_emp tables
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de	
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO count_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

-- Getting Employee information table
SELECT e.emp_no,
	e.first_name,
e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	 AND (de.to_date = '9999-01-01');
	 
-- Getting list of managers that will be retiring 	 
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
-- Getting list of Department Retirees
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

SELECT * FROM sales_info;

-- Creating retirement info list for Head of sales 
SELECT r.emp_no,
r.first_name,
r.last_name,
d.dept_name	
INTO sales_info
FROM retirement_info AS r
INNER JOIN dept_emp AS de
ON (r.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

-- Creating retirement info list for Sales and Development teams
SELECT * FROM sales_info
WHERE dept_name IN ('Development', 'Sales');



-- Challenge 7 Assignment
-- Deliverable 1: Number of Retiring Employees by Title
-- Clearly we need to perform two inner joins for this table.
-- Information is in employees, salaries and titles tables
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM titles;

-- Getting table with Employee No, First and Last Name, Title,
-- from_date and Salary.  Employees must have birth dates between 1952
-- and 1955.
SELECT e.emp_no,
	e.first_name,
    e.last_name,
	ti.title,
	ti.from_date,
	s.salary
INTO emp_titles
FROM employees AS e
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
INNER JOIN salaries AS s
ON (ti.emp_no = s.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND (ti.to_date = '9999-01-01');

-- Upon viewing table we see that there are no duplicates.
SELECT * FROM emp_titles;


-- Grouping emp_titles by job titles
SELECT COUNT(emp_no), title
INTO emp_group_title
FROM emp_titles
GROUP BY title
ORDER BY COUNT(emp_no) DESC;


-- Deliverable 2: Mentorship Eligibility
-- Creating table with Employees with birth dates in 1965
-- Table must include Employee Number, First and Last Name, title
-- and from_date and to_date
-- Will join employees, titles and salaries tables to get the data that I want

SELECT * FROM employees;
SELECT * FROM titles;
SELECT * FROM salaries;


SELECT e.emp_no,
	e.first_name,
    e.last_name,
	s.from_date,
	ti.to_date,
	ti.title
INTO mentor
FROM employees AS e
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no)
INNER JOIN titles AS ti
ON (s.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND (ti.to_date = '9999-01-01');
-- To get an employee who is currently eligible for mentorship the to_date will
-- be 9999-01-01.  Doing this will also ensure that we obtain their latest job
-- position.

-- Upon viewing table we see that there are no duplicates.
SELECT * FROM mentor;

-- Looking at those eligible for mentoring based on title
SELECT COUNT(emp_no), title
INTO mentor_group
FROM mentor
GROUP BY title
ORDER BY COUNT(emp_no) DESC;

-- Viewing mentor_title table
SELECT * FROM mentor_group;