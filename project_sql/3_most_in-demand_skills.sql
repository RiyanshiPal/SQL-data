-- what are the most in-demand skills for my role?

with skill_count as(
    select 
skill_id,
count(skills_job_dim.job_id) as skills_count
from skills_job_dim
inner join job_postings_fact on job_postings_fact.job_id=skills_job_dim.job_id
WHERE
job_title like '%Data Analyst%'
group by skill_id
order BY
skills_count desc
)
SELECT
skill_count.skill_id,
skills,
skills_count
from 
skill_count
left join skills_dim on skills_dim.skill_id=skill_count.skill_id
order by skills_count desc
limit 10