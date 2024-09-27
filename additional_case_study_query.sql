
/*
1.
As a market researcher, your job is to Investigate the job market 
for a company that analyzes workforce data. Your Task is to know 
how many people were employed IN different types of companies AS per their size IN 2021.

*/

SELECT company_size,count(*) FROM sql_case_studys.salaries 
where work_year = 2021
group by company_size
;


/*
2.
Imagine you are a talent Acquisition specialist Working for 
an International recruitment agency. Your Task is to identify 
the top 3 job titles that command the highest average salary 
Among part-time Positions IN the year 2023. However, 
you are Only Interested IN Countries WHERE there are more 
than 50 employees, Ensuring a robust sample size for your analysis.
*/

select  company_location,job_title,avg(salary_in_usd) as 'avg_sal',count(*) as 'totale_employe'
 from salaries
where employment_type = 'FT' and work_year = 2023
group by company_location,job_title 
having totale_employe > 50
order by avg_sal desc limit 3;


/*
3.
As a database analyst you have been assigned the task to 
Select Countries where average mid-level salary is higher
 than overall mid-level salary for the year 2023.
*/
select company_location,avg(salary) 'country_avg_mid_salary' 
from salaries where experience_level = 'MI'
group by company_location 
having country_avg_mid_salary >= (select avg_salary_of_mid from( 
select experience_level,avg(salary) 'avg_salary_of_mid'
from salaries where experience_level = 'MI' and work_year = 2023
group by experience_level)t

)
;

# Useing variabel  

set @overallAvg = (select avg(salary) from salaries where experience_level = 'MI' and work_year = 2023); 

select company_location,avg(salary) from salaries
where experience_level = 'MI'
group by company_location having avg(salary) >= (select @overallAvg)
;
;



/*
As a database analyst you have been assigned the task to Identify the 
company locations with the highest and lowest average salary for senior-level (SE) employees in 2023.
*/

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


/*

You're a Financial analyst Working for a leading HR Consultancy, and 
your Task is to Assess the annual salary growth rate for various job titles. 
By Calculating the percentage Increase IN salary FROM previous year to this year, 
you aim to provide valuable Insights Into salary trends WITHIN different job roles.

*/

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

/*
6.
You've been hired by a global HR Consultancy to identify 
Countries experiencing significant salary growth for entry-level roles.
Your task is to list the top three Countries with 
the highest salary growth rate 2020 and 2023, 
 helping multinational Corporations identify Emerging talent markets.

*/

with temp as (

select * from (
select work_year as 'work_year_2021',company_location 'company_location_t1',avg(salary) 'avg_salary_2021' from salaries 
where experience_level = 'EN' and  work_year = 2021
GROUP BY work_year,company_location) t1 

join ( select work_year work_year_2024,company_location as 'company_location_t2',avg(salary) 'avg_salary_2024' from salaries 
where experience_level = 'EN' and  work_year = 2023
GROUP BY work_year,company_location) t2

on t1.company_location_t1 = t2.company_location_t2 
)

select company_location_t1,work_year_2021,avg_salary_2021,work_year_2024,avg_salary_2024,
((avg_salary_2024-avg_salary_2021)/avg_salary_2021)*100
 from temp;







/*

Picture yourself as a data architect responsible for database management.
Companies in US and AU(Australia) decided to create a hybrid model for 
employees they decided that employees earning salaries exceeding $90000 USD, 
will be given work from home. You now need to update the remote work ratio for 
eligible employees, ensuring efficient remote work management while implementing 
appropriate error handling mechanisms for invalid input parameters.

*/

alter table salaries 
add column remote_ration_hybrid_mode integer after remote_ratio;


select * from salaries;

select `index`,company_location,salary,remote_ratio from salaries
where salary > 90000 and company_location in ('US' , 'AU') and remote_ratio in (0 , 50)
;

update salaries t1
set remote_ration_hybrid_mode = 100 
where salary > 90000 and company_location in ('US' , 'AU') and remote_ratio in (0 , 50);


/*
In the year 2024, due to increased demand in the data industry, there was an increase in salaries of data field employees.
Entry Level-35% of the salary.
Mid junior – 30% of the salary.
Immediate senior level- 22% of the salary.
Expert level- 20% of the salary.
Director – 15% of the salary.
You must update the salaries accordingly and update them back in the original database.

*/





 
 update salaries t1
 set salary = case 

	when experience_level = 'EN' then salary+(salary*35)/100
	when experience_level = 'MI' then salary+(salary*30)/100
    when experience_level = 'SE' then salary+(salary*22)/100
    when experience_level = 'EX' then salary+(salary*20)/100 

end ;


/*
9.
You are a researcher and you have been assigned the task 
to Find the year with the highest average salary for each job title.

*/

select * from (
select work_year,job_title,max(salary),
dense_rank() over(PARTITION BY job_title order by max(salary) desc) as ranks 
from salaries
group by work_year,job_title 
order by job_title) t
where t.ranks = 1
;


/*
10.
You have been hired by a market research agency where you been assigned the task to show the percentage of different employment type (full time, part time) in 
Different job roles, in the format where each row will be job title, each column will be type of employment type and  cell value  for that row and column will show 
the % value
*/
SELECT 
    job_title,
    ROUND((SUM(CASE WHEN employment_type = 'PT' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS PT_percentage, -- Calculate percentage of part-time employment
    ROUND((SUM(CASE WHEN employment_type = 'FT' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS FT_percentage, -- Calculate percentage of full-time employment
    ROUND((SUM(CASE WHEN employment_type = 'CT' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS CT_percentage, -- Calculate percentage of contract employment
    ROUND((SUM(CASE WHEN employment_type = 'FL' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS FL_percentage -- Calculate percentage of freelance employment
FROM 
    salaries
GROUP BY 
    job_title;










































































