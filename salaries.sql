/*
1. You're a Compensation analyst employed by a multinational corporation. 
Your Assignment is to Pinpoint Countries who give work fully remotely, 
for the title 'managers’ Paying salaries Exceeding $90,000 USD

*/

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

/*
2. As a remote work advocate Working for a progressive HR tech startup who places their freshers’ 
clients IN large tech firms. you're tasked WITH Identifying top 5 Country Having greatest count of
 large (company size) number of companies.

*/

select company_location,count(company_size) from salaries
where company_size = 'L' and experience_level = 'EN'
group by company_location order by count(company_size) desc limit 5;

/*
3.
Picture yourself AS a data scientist Working for a workforce management platform. 
Your objective is to calculate the percentage of employees. Who enjoy fully remote roles WITH salaries Exceeding $100,000 USD,
Shedding light ON the attractiveness of high-paying remote positions IN today's job market.
*/ 

set @total = (select count(*) from salaries where salary_in_usd > 100000);
 
set @cont = (select count(*) from salaries where salary_in_usd > 100000 and remote_ratio = 100); 

set @percentage = round((select (@cont))/(select @total)*100,2);

select @percentage;


# anothere approach  
select (select count(*) from salaries where salary_in_usd > 100000 and remote_ratio = 100)*100
/
(select count(*) from salaries where salary_in_usd > 100000);

SELECT * FROM sql_case_studys.salaries;



/*
4.
Imagine you're a data analyst Working for a global recruitment agency. Your Task is to identify the Locations where 
entry-level average salaries exceed the average salary for that job title IN market for entry-level, 
helping your agency guide candidates toward lucrative opportunities.

*/
select company_location,t1.job_title,avg_entry_level,avg_salary_by_country from (

select job_title,avg(salary_in_usd) as 'avg_entry_level'
from salaries where experience_level = "EN" 
GROUP BY job_title
) t1 join (

select company_location,job_title,avg(salary_in_usd) as 'avg_salary_by_country'
from salaries where experience_level = "EN" 
GROUP BY company_location,job_title
) t2
on t1.job_title = t2.job_title 
where avg_salary_by_country > avg_entry_level
;

/* 

You've been hired by a big HR Consultancy to look at how much people 
get paid IN different Countries. Your job is to Find out 
for each job title which Country pays the maximum average salary. 
This helps you to place your candidates IN those countries.

*/
select * from (
select company_location,job_title,avg(salary) 'avg_salary_in_country',
max(avg(salary)) over(PARTITION BY job_title) 'max_avg_salary'
from salaries
group by company_location,job_title
)t where avg_salary_in_country = max_avg_salary
;

/*
6.
As a data-driven Business consultant, you've been hired by 
a multinational corporation to analyze salary trends across 
different company Locations. Your goal is to Pinpoint Locations 
WHERE the average salary Has consistently increased over the past 
few years (Countries WHERE data is available for 3 years Only(the present year and past two years) 
providing Insights into Locations experiencing Sustained salary growth.


*/
with temp as (
select * from salaries where company_location in ( select company_location from (
select company_location,avg(salary) 'avg_sal',count(DISTINCT work_year) 'work_year'
from salaries where work_year >= year(current_date())-2
group by company_location 
having work_year = 3
order by company_location) t)
)

select company_location,
max(case when work_year=2022 then avg_sal end) as 'work_2022',
max(case when work_year=2023 then avg_sal end) as 'work_2023',
max(case when work_year=2024 then avg_sal end) as 'work_2024'
from (select company_location,work_year,avg(salary_in_usd) 'avg_sal'  from temp
group by company_location,work_year)t GROUP BY company_location
having work_2024>work_2023 and work_2023 > work_2022 
;


/*
7.
 Picture yourself AS a workforce strategist employed by a global HR tech startup.
 Your Mission is to Determine the percentage of fully remote work 
 for each experience level IN 2021 and compare it WITH the corresponding figures for 2024, 
 Highlighting any significant Increases or decreases IN remote work Adoption over the years.

*/


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
on n1.experience_level = n2.experience_level;



/*
8.
AS a Compensation specialist at a Fortune 500 company, 
you're tasked WITH analyzing salary trends over time. 
Your objective is to calculate the average salary increase percentage 
for each experience level and job title between the years 2023 and 2024,
 helping the company stay competitive IN the talent market.

*/
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


/*
9.
You're a database administrator tasked with role-based access control 
for a company's employee database. Your goal is to implement a security 
measure where employees in different experience level (e.g. Entry Level, Senior level etc.) 
can only access details relevant to their respective experience level, ensuring data 
confidentiality and minimizing the risk of unauthorized access.

*/

Create user 'Entry_Level'@'%'  identified by 'EN';

create view  EntrY_Level as(
select * from salaries where experience_level = 'EN'
);

grant select on sql_case_studys.entry_level to 'Entry_level'@'%';

show PRIVILEGES;


/*
10.
You are working with a consultancy firm, your client comes to you with certain data
 and preferences such as (their year of experience , their employment type, company
 location and company size )  and want to make an transaction into different domain
 in data industry (like  a person is working as a data analyst and want to move to 
 some other domain such as data science or data engineering etc.) your work is to  
 guide them to which domain they should switch to base on  the input they provided,
 so that they can now update their knowledge as  per the suggestion/.. The Suggestion 
 should be based on average salary.
*/

select * from salaries;












































































