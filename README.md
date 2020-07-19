# Pewlett-Hackard-Analysis
__________________________________________________________________________________________________

## Technical Analysis ##

### Entity Relationship Diagram (ERD) ###
![](https://github.com/GR8505/Pewlett-Hackard-Analysis/blob/master/EmployeeDB.png)


_________________________________________________________________________________________________


## Technical Analysis Deliverable 1 ##

### Code for Creation of Tables ###
https://github.com/GR8505/Pewlett-Hackard-Analysis/blob/master/Queries/Challenge7_Assignment.sql

### Number of Titles Retiring ###
Please refer to https://github.com/GR8505/Pewlett-Hackard-Analysis/blob/master/Assignment_Data/num_titles.csv

### Number of Employees with Each Title ###
Please refer to https://github.com/GR8505/Pewlett-Hackard-Analysis/blob/master/Assignment_Data/emp_group_title.csv

### List of current employees born between January 1, 1952 ###
### and December 31, 1955 ###
Please refer to https://github.com/GR8505/Pewlett-Hackard-Analysis/blob/master/Assignment_Data/emp_titles.csv

____________________________________________________________________________________________________________________


## Technical Analysis Deliverable 2 ##

### List of Employees Eligible for Mentorship Program ###
Please refer to https://github.com/GR8505/Pewlett-Hackard-Analysis/blob/master/Assignment_Data/mentor.csv

### Eligible Mentees by Job Title ###
Please refer to 

### Block of code used to produce results ###
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
