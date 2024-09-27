
# Data Science Jobs SQL Case Study




1. [Project Overview](#project-overview)

2. [Dataset Description](#dataset-description)
   
3. [Case Study Questions and SQL Queries](#case-study-questions-and-sql-queries)
   
4. [Pinpoint countries offering fully remote jobs for 'Manager' titles with salaries exceeding $90,000 USD](#1-youre-a-compensation-analyst-employed-by-a-multinational-corporation-your-assignment-is-to-pinpoint-countries-who-give-work-fully-remotely-for-the-title-managers-paying-salaries-exceeding-90000-usd)
	
5. [Identify top 5 countries with the greatest number of large companies](#2-as-a-remote-work-advocate-working-for-a-progressive-hr-tech-startup-who-places-their-freshers-clients-in-large-tech-firms-youre-tasked-with-identifying-top-5-country-having-greatest-count-of-large-company-size-number-of-companies)

6. [Calculate the percentage of employees enjoying fully remote roles with salaries exceeding $100,000 USD](#3-picture-yourself-as-a-data-scientist-working-for-a-workforce-management-platform-your-objective-is-to-calculate-the-percentage-of-employees-who-enjoy-fully-remote-roles-with-salaries-exceeding-100000-usd-shed-light-on-the-attractiveness-of-high-paying-remote-positions-in-todays-job-market)

7. [Identify locations where entry-level average salaries exceed market average for the same job title](#4-imagine-youre-a-data-analyst-working-for-a-global-recruitment-agency-your-task-is-to-identify-the-locations-where-entry-level-average-salaries-exceed-the-average-salary-for-that-job-title-in-market-for-entry-level-helping-your-agency-guide-candidates-toward-lucrative-opportunities)

8. [Identify which country pays the maximum average salary for each job title](#5-youve-been-hired-by-a-big-hr-consultancy-to-look-at-how-much-people-get-paid-in-different-countries-your-job-is-to-find-out-for-each-job-title-which-country-pays-the-maximum-average-salary-this-helps-you-to-place-your-candidates-in-those-countries)

9. [Pinpoint locations with consistent salary growth over the past few years](#6-as-a-data-driven-business-consultant-youve-been-hired-by-a-multinational-corporation-to-analyze-salary-trends-across-different-company-locations-your-goal-is-to-pinpoint-locations-where-the-average-salary-has-consistently-increased-over-the-past-few-years-countries-where-data-is-available-for-3-years-onlythe-present-year-and-past-two-years-providing-insights-into-locations-experiencing-sustained-salary-growth)

10. [Compare remote work adoption percentages across experience levels between 2021 and 2024](#7--picture-yourself-as-a-workforce-strategist-employed-by-a-global-hr-tech-startup-your-mission-is-to-determine-the-percentage-of-fully-remote-work-for-each-experience-level-in-2021-and-compare-it-with-the-corresponding-figures-for-2024-highlighting-any-significant-increases-or-decreases-in-remote-work-adoption-over-the-years)

11. [Calculate the average salary increase percentage for each experience level and job title between 2023 and 2024](#8-as-a-compensation-specialist-at-a-fortune-500-company-youre-tasked-with-analyzing-salary-trends-over-time-your-objective-is-to-calculate-the-average-salary-increase-percentage-for-each-experience-level-and-job-title-between-the-years-2023-and-2024-helping-the-company-stay-competitive-in-the-talent-market)

12. [Implement role-based access control for employees based on experience level](#9-youre-a-database-administrator-tasked-with-role-based-access-control-for-a-companys-employee-database-your-goal-is-to-implement-a-security-measure-where-employees-in-different-experience-level-eg-entry-level-senior-level-etc-can-only-access-details-relevant-to-their-respective-experience-level-ensuring-data-confidentiality-and-minimizing-the-risk-of-unauthorized-access)

13.[Conclusion](#conclusion)







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

- **Salary**: The total gross salary amount paid.

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

# Case Study Questions and SQL Queries

## 1. You're a Compensation analyst employed by a multinational corporation. Your Assignment is to Pinpoint Countries who give work fully remotely, for the title 'managers’ Paying salaries Exceeding $90,000 USD


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


## 2. As a remote work advocate Working for a progressive HR tech startup who places their freshers’ clients IN large tech firms. you're tasked WITH Identifying top 5 Country Having greatest count of large (company size) number of companies.


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



## 3. Picture yourself AS a data scientist Working for a workforce management platform. Your objective is to calculate the percentage of employees. Who enjoy fully remote roles with salaries exceeding $100,000 USD, Shed light on the attractiveness of high-paying remote positions IN today's job market.

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




## 4. Imagine you're a data analyst Working for a global recruitment agency. Your Task is to identify the Locations where entry-level average salaries exceed the average salary for that job title IN market for entry-level, helping your agency guide candidates toward lucrative opportunities.

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



## 5. You've been hired by a big HR Consultancy to look at how much people get paid IN different Countries. Your job is to Find out for each job title which Country pays the maximum average salary. This helps you to place your candidates IN those countries.

```SQL
# Without using the window function;

select t2.company_location,t2.job_title,t1.max_avg from 

(select job_title,max(avg_sal) as 'max_avg' from
(select company_location,job_title,avg(salary_in_usd) as 'avg_sal' from salaries
GROUP BY company_location,job_title order by job_title)t group by job_title order by job_title) t1 

join 

(select company_location,job_title,avg(salary_in_usd) as 'avg_sal' from salaries
GROUP BY company_location,job_title order by job_title) t2

on t1.job_title = t2.job_title where t1.max_avg = avg_sal order by job_title;


# updated version and fast version of the above query


select * from (
select company_location,job_title,avg(salary) 'avg_salary_in_country',
max(avg(salary)) over(PARTITION BY job_title) 'max_avg_salary'
from salaries
group by company_location,job_title
)t where avg_salary_in_country = max_avg_salary
;



# With window function

select * from (

select company_location,job_title,avg(salary),
dense_rank() over(PARTITION BY job_title order by avg(salary) desc) as salary_rank 
from salaries
GROUP BY company_location,job_title
order by job_title) t 

where salary_rank = 1
; 



```

![entry-level average salaries exceed the market average salry](https://github.com/shanto173/SQL-2024-Case_Study_01_On_data_science_dataset/blob/main/images/5.png)



## 6. As a data-driven Business consultant, you've been hired by a multinational corporation to analyze salary trends across different company Locations. Your goal is to Pinpoint Locations WHERE the average salary Has consistently increased over the past few years (Countries WHERE data is available for 3 years Only(the present year and past two years) providing Insights into Locations experiencing Sustained salary growth.


```SQL
with temp as (
	select * from salaries where company_location in (

	select company_location from 
	(
	select company_location,avg(salary),count(distinct work_year)
	from salaries where work_year >= (year(current_date()))-2
	GROUP BY company_location
	having count(DISTINCT work_year) =3
	order by company_location
	) t 
	))
    
    
select company_location,

max(case when work_year = 2022 then avg_salary end) as 'Average_2022',
max(case when work_year = 2023 then avg_salary end) as 'Average_2023',
max(case when work_year = 2024 then avg_salary end) as 'Average_2024'
from (
select company_location,work_year,avg(salary_in_usd) as avg_salary from temp
group by company_location,work_year order by company_location) t
group by company_location having Average_2024 > Average_2023 and Average_2023 > Average_2022
; 
```

![Average salary increase trend](https://github.com/shanto173/SQL-2024-Case_Study_01_On_data_science_dataset/blob/main/images/6.png)

![Average salary increase trend](https://github.com/shanto173/SQL-2024-Case_Study_01_On_data_science_dataset/blob/main/images/salary_2022%2C%20salary_2023%20and%20salary_2024.png)

* The salary trends from 2022 to 2024 show a general increase across all countries, with the largest growth seen in Argentina (AR) from 50,000 to 88,500 and Hungary (HU) from 17,684 to 63,333. Canada (CA) maintains the highest average salary, increasing steadily from 126,009 in 2022 to 153,611 in 2024. The upward trend indicates improving salary packages across various countries, reflecting positive economic or industry growth.


## 7.  Picture yourself AS a workforce strategist employed by a global HR tech startup. Your Mission is to Determine the percentage of fully remote work for each experience level IN 2021 and compare it WITH the corresponding figures for 2024, Highlighting any significant Increases or decreases IN remote work Adoption over the years.


```SQL
select n1.experience_level,n1.total_remote_percentage_2021,n2.total_remote_percentage_2024 from (

select t1.experience_level,t1.total_2021,t2.remote_2021,remote_2021/total_2021 as 'total_remote_percentage_2021' from (

select experience_level,count(*) as 'total_2021'
from salaries 
where work_year = 2021
group by experience_level
) t1
join (
select experience_level,count(*) as 'remote_2021'
from salaries 
where work_year = 2021 and remote_ratio = 100
group by experience_level
)t2 on t1.experience_level = t2.experience_level 
) n1
join (

select t1.experience_level,t1.total_2024,t2.remote_2024,remote_2024/total_2024 as 'total_remote_percentage_2024' from (

select experience_level,count(*) as 'total_2024'
from salaries 
where work_year = 2024
group by experience_level
) t1
join (
select experience_level,count(*) as 'remote_2024'
from salaries 
where work_year = 2024 and remote_ratio = 100
group by experience_level
)t2 on t1.experience_level = t2.experience_level 
) n2
on n1.experience_level = n2.experience_level

```

![percentage of fully remote work](https://github.com/shanto173/SQL-2024-Case_Study_01_On_data_science_dataset/blob/main/images/7.png)


## 8. As a Compensation specialist at a Fortune 500 company, you're tasked WITH analyzing salary trends over time. Your objective is to calculate the average salary increase percentage for each experience level and job title between the years 2023 and 2024, helping the company stay competitive IN the talent market.


```SQL
select t1.experience_level,t2.job_title,t1.avg_salary_2023,t2.avg_salary_2024,
((t2.avg_salary_2024 - t1.avg_salary_2023)/t1.avg_salary_2023)*100 as 'increase_salary'

 from (

select experience_level,job_title,avg(salary) 'avg_salary_2023'
from salaries where work_year in (2023)
group by experience_level,job_title
)t1
join( 
select experience_level,job_title,avg(salary) 'avg_salary_2024'
from salaries where work_year = 2024
group by experience_level,job_title)t2

on t1.experience_level = t2.experience_level and t1.job_title = t2.job_title
;

```

![percentage of fully remote work](https://github.com/shanto173/SQL-2024-Case_Study_01_On_data_science_dataset/blob/main/images/8.png)

## 9. You're a database administrator tasked with role-based access control for a company's employee database. Your goal is to implement a security measure where employees in different experience level (e.g. Entry Level, Senior level etc.) can only access details relevant to their respective experience level, ensuring data confidentiality and minimizing the risk of unauthorized access.


```SQL
Create user 'Entry_Level'@'%'  identified by 'EN';

create view  EntrY_Level as(
select * from salaries where experience_level = 'EN'
);

grant select on sql_case_studys.entry_level to 'Entry_level'@'%';

show PRIVILEGES;
```

### Conclusion
This case study provides an in-depth look into salary trends, remote work patterns, and company size distribution across various job titles and experience levels. Each query was designed to provide specific business insights for workforce management, compensation analysis, and strategic decision-making.



## Additional Question Case study

### 1.1 As a market researcher, your job is to Investigate the job market for a company that analyzes workforce data. Your Task is to know how many people were employed IN different types of companies AS per their size IN 2021.

```SQL

SELECT company_size,count(*) FROM sql_case_studys.salaries 
where work_year = 2021
group by company_size
;
```

![2021 employee number](https://github.com/shanto173/SQL-2024-Case_Study_01_On_data_science_dataset/blob/main/images/1.1.png)



### 1.2 Imagine you are a talent Acquisition specialist Working for an International recruitment agency. Your Task is to identify the top 3 job titles that command the highest average salary Among Full-time Positions IN the year 2023. However, you are Only Interested IN Countries WHERE there are more than 50 employees, Ensuring a robust sample size for your analysis.

```SQL

select  company_location,job_title,avg(salary_in_usd) as 'avg_sal',count(*) as 'totale_employe'
 from salaries
where employment_type = 'FT' and work_year = 2023
group by company_location,job_title 
having totale_employe > 50
order by avg_sal desc limit 3;
```

![2021 employee number](https://github.com/shanto173/SQL-2024-Case_Study_01_On_data_science_dataset/blob/main/images/1.2.png)


### 1.3 As a database analyst you have been assigned the task of selecting countries where the average mid-level salary is higher than the overall mid-level salary for the year 2023.

```SQL

select company_location,avg(salary) 'country_avg_mid_salary' 
from salaries where experience_level = 'MI'
group by company_location 
having country_avg_mid_salary >= (select avg_salary_of_mid from( 
select experience_level,avg(salary) 'avg_salary_of_mid'
from salaries where experience_level = 'MI' and work_year = 2023
group by experience_level)t

)
;



# Useing variable  

set @overallAvg = (select avg(salary) from salaries where experience_level = 'MI' and work_year = 2023); 

select company_location,avg(salary) from salaries
where experience_level = 'MI'
group by company_location having avg(salary) >= (select @overallAvg)
;



```

![Countries where avg salary greater than overallAvg](https://github.com/shanto173/SQL-2024-Case_Study_01_On_data_science_dataset/blob/main/images/1.3.png)




### 1.4 As a database analyst you have been assigned the task to Identify the company locations with the highest and lowest average salary for senior-level (SE) employees in 2023.

```SQL

with temp as (
(select company_location,avg(salary) as 'avg_sal'
from salaries 
where work_year = 2023 and experience_level = 'SE'
group by company_location order by avg_sal desc)
)

select * from (
select t1.company_location,t1.avg_sal,
ROW_NUMBER() over(order by t1.avg_sal desc) 'Highest_and_lowest_avg_value'
from temp as t1
join  temp as t2 
on t1.company_location = t2.company_location
)n where Highest_and_lowest_avg_value in (1,(select count(*) from temp))
;


```

![Countries where avg salary greater than overallAvg](https://github.com/shanto173/SQL-2024-Case_Study_01_On_data_science_dataset/blob/main/images/1.4.png)




### 1.5 You're a Financial analyst Working for a leading HR Consultancy, and your Task is to Assess the annual salary growth rate for various job titles. By Calculating the percentage Increase IN salary FROM previous year to this year, you aim to provide valuable Insights Into salary trends WITHIN different job roles.

```SQL

with temp as (

select * from (
select work_year as work_year_2023 ,job_title as 'job_title_2023',avg(salary) 'avg_sal_2023' 
from salaries where work_year = 2023
GROUP BY work_year,job_title) t1

join (select work_year as work_year_2024,job_title as 'job_title_2024',avg(salary) 'avg_sal_2024' 
from salaries where work_year = 2024
GROUP BY work_year,job_title) t2

on t1.job_title_2023 = t2.job_title_2024
)

select *,((avg_sal_2024-avg_sal_2023)/avg_sal_2023)*100 as 'pecentage_change_over_the_year' from temp;
;


```

![Countries where avg salary greater than overallAvg](https://github.com/shanto173/SQL-2024-Case_Study_01_On_data_science_dataset/blob/main/images/1.5.png)




### 1.6 You've been hired by a global HR Consultancy to identify Countries experiencing significant salary growth for entry-level roles.Your task is to list the top three Countries with the highest salary growth rate 2020 and 2023, helping multinational Corporations identify Emerging talent markets.

```SQL


with temp as (

select * from (
select work_year as work_year_2023 ,job_title as 'job_title_2023',avg(salary) 'avg_sal_2023' 
from salaries where work_year = 2023
GROUP BY work_year,job_title) t1

join (select work_year as work_year_2024,job_title as 'job_title_2024',avg(salary) 'avg_sal_2024' 
from salaries where work_year = 2024
GROUP BY work_year,job_title) t2

on t1.job_title_2023 = t2.job_title_2024
)

select *,((avg_sal_2024-avg_sal_2023)/avg_sal_2023)*100 as 'pecentage_change_over_the_year' from temp;
;


```

![Countries where avg salary greater than overallAvg](https://github.com/shanto173/SQL-2024-Case_Study_01_On_data_science_dataset/blob/main/images/1.6.png)







### 1.7 Picture yourself as a data architect responsible for database management. Companies in US and AU(Australia) decided to create a hybrid model for employees they decided that employees earning salaries exceeding $90000 USD, will be given work from home. You now need to update the remote work ratio for eligible employees, ensuring efficient remote work management while implementing appropriate error handling mechanisms for invalid input parameters.

```SQL


update salaries t1
set remote_ration_hybrid_mode = 100 
where salary > 90000 and company_location in ('US', 'AU') and remote_ratio in (0, 50);




```

![Countries where avg salary greater than overallAvg](https://github.com/shanto173/SQL-2024-Case_Study_01_On_data_science_dataset/blob/main/images/1.7.png)




### 1.8 In the year 2024, due to increased demand in the data industry, there was an increase in salaries of data field employees.Entry Level-35% of the salary.Mid junior – 30% of the salary.Immediate senior level- 22% of the salary.Expert level- 20% of the salary. You must update the salaries accordingly and update them back in the original database.

```SQL


update salaries t1
 set salary = case 

	when experience_level = 'EN' then salary+(salary*35)/100
	when experience_level = 'MI' then salary+(salary*30)/100
    when experience_level = 'SE' then salary+(salary*22)/100
    when experience_level = 'EX' then salary+(salary*20)/100 

end 
;



```

![Countries where avg salary greater than overallAvg](https://github.com/shanto173/SQL-2024-Case_Study_01_On_data_science_dataset/blob/main/images/1.8.png)



### 1.9 In the year 2024, due to increased demand in the data industry, there was an increase in salaries of data field employees.Entry Level-35% of the salary.Mid junior – 30% of the salary.Immediate senior level- 22% of the salary.Expert level- 20% of the salary. You must update the salaries accordingly and update them back in the original database.

```SQL


select * from (
select work_year,job_title,max(salary),
dense_rank() over(PARTITION BY job_title order by max(salary) desc) as ranks 
from salaries
group by work_year,job_title 
order by job_title) t
where t.ranks = 1
;




```

![Countries where avg salary greater than overallAvg](https://github.com/shanto173/SQL-2024-Case_Study_01_On_data_science_dataset/blob/main/images/1.9.png)











