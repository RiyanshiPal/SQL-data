/*
Answer: what are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?
    -Identify skills in high demand and associated with high average salaries for Data Analyst roles
    -Concentrates on remote positions with specified salaries:

Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
offering strategic insights for career development in data analysis
*/
/*
by CTEs

with skill_demand as (
    SELECT
skills,
skills_dim.skill_id,
count(skills_job_dim.job_id) as demand
FROM
skills_job_dim
inner join job_postings_fact on job_postings_fact.job_id= skills_job_dim.job_id
inner JOIN skills_dim on skills_dim.skill_id= skills_job_dim.skill_id
WHERE
job_title_short='Data Analyst' AND
job_work_from_home=true AND
salary_year_avg is not null
group BY
skills_dim.skill_id
)
, average_salary as (
    SELECT
skills_job_dim.skill_id,
round(avg(salary_year_avg),0) as avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
job_title_short = 'Data Analyst' and
salary_year_avg is not null AND
job_work_from_home=TRUE

GROUP BY
skills_job_dim.skill_id
)

select 
average_salary.skill_id,
skill_demand.skills,
demand,
avg_salary
from 
average_salary
inner join skill_demand on skill_demand.skill_id= average_salary.skill_id
WHERE
demand>10
order by 
avg_salary desc,
demand desc
*/

-- compact

SELECT
skills_dim.skill_id,
skills,
count(skills_job_dim.job_id) as demand,
round(avg(salary_year_avg),0) as average_salary
FROM
skills_job_dim
inner join job_postings_fact on job_postings_fact.job_id=skills_job_dim.job_id
inner join skills_dim on skills_dim.skill_id= skills_job_dim.skill_id
WHERE
job_title_short='Data Analyst' and
salary_year_avg is not null AND
job_work_from_home=TRUE
group BY
skills_dim.skill_id
HAVING
count(skills_job_dim.job_id)>10
order BY
average_salary desc,
demand DESC
