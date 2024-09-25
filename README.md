
# Data Science Jobs SQL Case Study

## Project Overview
This case study involves analyzing salary data from a multinational corporation. As a **Compensation Analyst** and other roles, the objective is to provide insights into salary trends, remote work, and company sizes across different countries and job titles.

### Dataset Description
The dataset contains valuable information regarding salaries, work conditions, and company characteristics across multiple countries. Below are the key attributes in the dataset:

- **work_year**: The year during which the salary was paid. There are two types of work year values:
  - **2020**: Year with a definitive amount from the past.
  - **2024**: Year with an estimated amount (e.g. current year).

- **experience_level**: The experience level in the job during the year. Possible values include:
  - **EN**: Entry-level / Junior.
  - **MI**: Mid-level / Intermediate.
  - **SE**: Senior-level / Expert.
  - **EX**: Executive-level / Director.

- **employment_type**: The type of employment for the role. Possible values include:
  - **PT**: Part-time.
  - **FT**: Full-time.
  - **CT**: Contract.
  - **FL**: Freelance.

- **job_title**: The role worked in during the year (e.g., Data Scientist, Machine Learning Engineer).

- **salary**: The total gross salary amount paid.

- **salary_currency**: The currency of the salary paid, following the ISO 4217 currency code standard.

- **salary_in_usd**: The salary converted to USD, based on the average FX rate for the respective year via fxdata.foorilla.com.

- **employee_residence**: The primary country of residence of the employee during the work year, represented as an ISO 3166 country code.

- **remote_ratio**: The proportion of work done remotely. Possible values include:
  - **0**: No remote work (less than 20%).
  - **50**: Partially remote work.
  - **100**: Fully remote work (more than 80%).

- **company_location**: The country where the employer's main office or contracting branch is located, represented as an ISO 3166 country code.

- **company_size**: The average number of employees at the company during the year. Possible values include:
  - **S**: Small company (fewer than 50 employees).
  - **M**: Medium company (50 to 250 employees).
  - **L**: Large company (more than 250 employees).

### Case Study Questions and SQL Queries

#### 1. Pinpoint Countries with Fully Remote Manager Jobs Paying Over $90,000 USD
**Objective**: Identify countries offering fully remote managerial roles with salaries exceeding $90,000 USD.

```SQL
SELECT DISTINCT (t.company_location) 
FROM (
    SELECT 
        company_location, 
        job_title, 
        remote_ratio, 
        AVG(salary_in_usd), 
        COUNT(remote_ratio)
    FROM salaries
    GROUP BY 
        company_location, 
        job_title, 
        remote_ratio
    HAVING 
        remote_ratio = 100 
        AND job_title LIKE '%manager%' 
        AND AVG(salary_in_usd) > 90000
) t;

# Another easy solution for this

select distinct company_location from salaries
where job_title like '%manager%' and remote_ratio = 100 and salary > 90000;


```



![Country_proveide_remote_job](https://github.com/shanto173/SQL-2024-Case_Study_01_On_data_science_dataset/blob/main/images/1.png)

    Result:
    The following countries offer fully remote managerial roles with salaries exceeding $90,000 USD:
    
    US (United States)
    IN (India)
    MX (Mexico)
    AU (Australia)
    FR (France)


#### 2. Identify Top 5 Countries with the Most Large Companies Offering Entry-Level Jobs (HR Tech Focus)
**Objective**: Identify the top 5 countries with the highest number of large companies (company size 'L').

```SQL
select company_location,count(company_size) from salaries
where company_size = 'L' and experience_level = 'EN'
group by company_location order by count(company_size) desc limit 5;
```

![Top 5 Country_proveide_entry level job](https://github.com/shanto173/SQL-2024-Case_Study_01_On_data_science_dataset/blob/main/images/2.png)

    Result:
     United States (US) – 53 large companies
    Germany (DE) – 10 large companies
    Canada (CA) – 10 large companies
    United Kingdom (GB) – 8 large companies
    India (IN) – 6 large companies
- From the analysis, the United States stands out as the dominant location for large companies offering entry-level positions, with a significantly higher count compared to the other countries.
- Germany and Canada follow closely with equal counts, while the United Kingdom and India round out the top five.



#### 3. Percentage of Employees with Fully Remote Roles and Salaries Above $100,000 USD
**Objective**: Calculate the percentage of employees enjoying fully remote roles with salaries exceeding $100,000 USD.

```SQL
select ((select count(*) from salaries where salary > 100000 and remote_ratio =100)
/(select count(*) from salaries where salary > 100000) * 100)  as 'enjoying_remote_position_with_100k_salary'
;

# Another solution using SQL variable.

set @total = (select count(*) from salaries where salary_in_usd > 100000);
set @count = (select count(*) from salaries where salary_in_usd > 100000 and remote_ratio = 100);
set @percentage = round((select @count)/(select @total)*100,2);
select @percentage;


```
![Remote Work with $100K+ Salary](https://github.com/shanto173/SQL-2024-Case_Study_01_On_data_science_dataset/blob/main/images/3.png)

  - Conclusion for Remote Work with $100K+ Salary

    - Based on the query result, 32.35% of individuals earning over $100,000 are enjoying fully remote positions.
    - This indicates that while a considerable portion of high-paying jobs offer the flexibility of remote work,




#### 4. Locations with Entry-Level Salaries Above Market Average
**Objective**: Identify locations where entry-level average salaries exceed the market average for entry-level positions.

```SQL
select t1.job_title,t2.company_location,t1.average,t2.average_per_country from
(
select job_title,avg(salary_in_usd) as 'average' from salaries where experience_level = 'EN' GROUP BY job_title
) t1
join 
(select company_location,job_title,avg(salary_in_usd) as 'average_per_country' from salaries
where experience_level = 'EN' group by company_location,job_title)
 t2 
 on t1.job_title = t2.job_title and t2.average_per_country > t1.average;
```


![entry-level average salaries exceed the market average salry](https://github.com/shanto173/SQL-2024-Case_Study_01_On_data_science_dataset/blob/main/images/4.png)



#### 5. Countries with Maximum Average Salary by Job Title
**Objective**: Identify the country that pays the maximum average salary for each job title.

```sql
SELECT job_title, company_location, MAX(avg_salary) AS max_avg_salary
FROM (
    SELECT job_title, company_location, AVG(salary_in_usd) AS avg_salary
    FROM salaries
    GROUP BY job_title, company_location
) AS salary_data
GROUP BY job_title, company_location;
```

#### 6. Locations with Consistently Increasing Salaries (2022-2024)
**Objective**: Find locations where average salaries have consistently increased over the past three years (2022-2024).

```sql
WITH yearly_salaries AS (
    SELECT company_location, work_year, AVG(salary_in_usd) AS avg_salary
    FROM salaries
    WHERE work_year IN (2022, 2023, 2024)
    GROUP BY company_location, work_year
)
SELECT company_location
FROM yearly_salaries
GROUP BY company_location
HAVING MIN(avg_salary) < MAX(avg_salary);
```

#### 7. Percentage of Fully Remote Work by Experience Level (2021 vs. 2024)
**Objective**: Determine the percentage of fully remote work for each experience level in 2021 and 2024, highlighting significant changes.

```sql
SELECT 
    experience_level, 
    SUM(CASE WHEN work_year = 2021 THEN remote_ratio ELSE 0 END) / COUNT(*) AS remote_2021,
    SUM(CASE WHEN work_year = 2024 THEN remote_ratio ELSE 0 END) / COUNT(*) AS remote_2024
FROM salaries
GROUP BY experience_level;
```

#### 8. Average Salary Increase by Experience Level and Job Title (2023-2024)
**Objective**: Calculate the average salary increase percentage for each experience level and job title between 2023 and 2024.

```sql
WITH salary_2023 AS (
    SELECT job_title, experience_level, AVG(salary_in_usd) AS avg_salary_2023
    FROM salaries
    WHERE work_year = 2023
    GROUP BY job_title, experience_level
), salary_2024 AS (
    SELECT job_title, experience_level, AVG(salary_in_usd) AS avg_salary_2024
    FROM salaries
    WHERE work_year = 2024
    GROUP BY job_title, experience_level
)
SELECT 
    s2023.job_title, 
    s2023.experience_level, 
    ((s2024.avg_salary_2024 - s2023.avg_salary_2023) / s2023.avg_salary_2023) * 100 AS salary_increase_percentage
FROM salary_2023 s2023
JOIN salary_2024 s2024
ON s2023.job_title = s2024.job_title AND s2023.experience_level = s2024.experience_level;
```

#### 9. Implementing Role-Based Access Control (RBAC) for Experience Levels
**Objective**: Create role-based access control so employees can access details relevant only to their respective experience levels.

```sql
-- Pseudocode for RBAC implementation
-- Define roles for each experience level (e.g., 'EN', 'MI', 'SE', 'EX')
CREATE ROLE entry_level_access;
CREATE ROLE mid_level_access;
CREATE ROLE senior_level_access;
-- Assign access to relevant tables and columns for each role
GRANT SELECT ON salaries TO entry_level_access WHERE experience_level = 'EN';
GRANT SELECT ON salaries TO mid_level_access WHERE experience_level = 'MI';
GRANT SELECT ON salaries TO senior_level_access WHERE experience_level = 'SE';
```

### Conclusion
This case study provides an in-depth look into salary trends, remote work patterns, and company size distribution across various job titles and experience levels. Each query was designed to provide specific business insights for workforce management, compensation analysis, and strategic decision-making.


