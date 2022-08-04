-- 607 total rows, 355 rows US only companies(using US only)
SELECT *
FROM DataScienceSalariesProject..salaries;

-- CLEANING DATA
-- Delete F1 column imported from original Excel file
ALTER TABLE DataScienceSalariesProject..salaries
DROP COLUMN F1;

-- Delete salary and salary_currency, keep salary_in_usd
ALTER TABLE DataScienceSalariesProject..salaries
DROP COLUMN salary, salary_currency;

-- Delete employee_residence
ALTER TABLE DataScienceSalariesProject..salaries
DROP COLUMN employee_residence;

-- Delete company locations that are not in the US
DELETE FROM DataScienceSalariesProject..salaries
WHERE company_location != 'US';

-- Delete company_location columns since all data is now based in US
ALTER TABLE DataScienceSalariesProject..salaries
DROP COLUMN company_location;

-- Update experience_level to say full thing
UPDATE DataScienceSalariesProject..salaries
SET experience_level = REPLACE(experience_level, 'EN', 'Entry')

UPDATE DataScienceSalariesProject..salaries
SET experience_level = REPLACE(experience_level, 'MI', 'Mid')

UPDATE DataScienceSalariesProject..salaries
SET experience_level = REPLACE(experience_level, 'SE', 'Senior')

UPDATE DataScienceSalariesProject..salaries
SET experience_level = REPLACE(experience_level, 'EX', 'Executive')

-- Update employment_type to say full thing
UPDATE DataScienceSalariesProject..salaries
SET employment_type = REPLACE(employment_type, 'FT', 'Full-time')

UPDATE DataScienceSalariesProject..salaries
SET employment_type = REPLACE(employment_type, 'PT', 'Part-time')

UPDATE DataScienceSalariesProject..salaries
SET employment_type = REPLACE(employment_type, 'CT', 'Contract')

UPDATE DataScienceSalariesProject..salaries
SET employment_type = REPLACE(employment_type, 'FL', 'Freelance')

-- Break things down by experience_level, EN Entry-level / Junior MI Mid-level / Intermediate SE Senior-level / Expert EX Executive-level / Director
SELECT *
FROM DataScienceSalariesProject..salaries
ORDER BY experience_level;

-- See what job titles are in the data
SELECT job_title
FROM DataScienceSalariesProject..salaries
ORDER BY job_title;

-- Tableau Queries
-- 1. Salaries for Jobs based on experience levels
SELECT experience_level, job_title, CONVERT(DECIMAL(10,2), AVG(salary_in_usd)) as average_salary
FROM DataScienceSalariesProject..salaries
GROUP BY experience_level, job_title;

-- 2. Average Salary based on experience level, employment type and company size
SELECT experience_level, employment_type, company_size, CONVERT(DECIMAL(10,2), AVG(salary_in_usd)) as average_salary
FROM DataScienceSalariesProject..salaries
GROUP BY experience_level, employment_type, company_size;

-- 3. Remote Roles Percentage based on company size
SELECT remote_ratio, CAST(CAST(COUNT(*) AS float)*100/(SELECT count(remote_ratio) FROM DataScienceSalariesProject..salaries) AS decimal(10,2)) as remote_roles_percentage, company_size
FROM DataScienceSalariesProject..salaries
GROUP BY remote_ratio, company_size;

-- 4. Salary Trends based on year
SELECT work_year, experience_level, salary_in_usd
FROM DataScienceSalariesProject..salaries
ORDER BY work_year, salary_in_usd;
