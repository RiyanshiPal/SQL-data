/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries (remove nulls).
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment opportunity
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name as company_name
FROM
    job_postings_fact
left join company_dim on company_dim.company_id=job_postings_fact.company_id
where 
job_title_short='Data Analyst' AND
job_location='Anywhere' AND
salary_year_avg IS NOT NULL
order by salary_year_avg DESC
limit 10;