# Introduction
Exploring the Data Job Market

This project focuses on Data Analyst roles, analyzing trends in 
- top-paying positions

- in-demand skills and 

- identifying where high salaries align with strong job demand

All this in the field of data analytics.

To view the SQL queries used, visit: [project_sql_folder](/project_sql/)


# Background
In my first year, I took a course on Energy Engineering where we explored trends like energy demand, the renewable energy share, and the duck curve. That’s when I first realized how powerful data can be—not just to observe what’s happening, but to reach meaningful insights and present them in a simple, yet information-dense way.

Later, in my Programming for Data Science course, this idea became even clearer. I saw how data can answer critical questions and uncover deep trends. I knew I wanted to work with data, but I wasn’t sure where to begin. The job market felt overwhelming, with so many overlapping roles and skill requirements.

While searching for a direction, I came across [Luke Barousse](https://www.lukebarousse.com). His content gave me the clarity I needed. I learned how to write efficient SQL queries and began analyzing real-world job market data.

This project is a result of that journey—exploring top-paying data analyst roles, identifying in-demand skills, and helping others understand what to learn and how to navigate the data job market with confidence.

## Questions I set out to answer with SQL
1) What are the top-paying Data Analyst jobs?

2) What skills are required for these top-paying jobs?

3) What skills are most in demand for Data Analysts?

4) Which skills are associated with higher salaries?

5) What are the most optimal skills to learn?


# Tools I Used
To explore the data analyst job market in depth, I used a set of essential tools that supported everything from querying data to sharing my work:

- **SQL**: The core of my analysis—used to extract, filter, and explore insights from the data.

- **PostgreSQL**: My chosen database management system, well-suited for handling structured job posting data.

- **Visual Studio Code**: My go-to code editor for writing and executing SQL queries seamlessly.

- **Git & GitHub**: Used for version control and sharing my project. These tools helped me track progress and make my SQL scripts publicly accessible for collaboration and learning.

# The Analysis
Each query for this project aimed at investigating
specific
aspects of the data analyst job market.
Here's how approached each question:
### 1) Top Paying Data Analyst jobs
To identify the highest-paying roles, l filtered
data analyst positions by average yearly salary
and location, focusing on remote jobs. This query
highlights the high paying opportunities in the
field.
```sql
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
```
Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** Top 10 paying data analyst roles
span from $184,000 to $650,000, indicating
significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset
Meta, and AT&T are among those offering high
salaries, showing a broad interest across diferent
industries.

- **Job Title Variety:** There's a high diversity in job
titles, from Data Analyst to Director of Analytics
reflecting varied roles and specializations within data
analytics

![Top paying roles](assests/1_top_paying_roles.png)

*AI generated graph from my SQL query results*
### 2) Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
``` sql
with top_paying_jobs as 
(
SELECT
    job_id,
    job_title,
    salary_year_avg,
    name as company_name
FROM
    job_postings_fact
left join company_dim on company_dim.company_id=job_postings_fact.company_id
where 
job_title='Data Analyst' AND
job_location='Anywhere' AND
salary_year_avg IS NOT NULL
order by salary_year_avg DESC
limit 10
)
select 
top_paying_jobs.*,
skills
from
top_paying_jobs
inner join skills_job_dim on skills_job_dim.job_id=top_paying_jobs.job_id
inner join skills_dim on skills_dim.skill_id=skills_job_dim.skill_id
order by 
salary_year_avg desc;
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:

- SQL is leading with a bold count of 8.
- Python follows closely with a bold count of 7.
- Tableau is also highly sought after, with a bold count of 6.
- Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.


![Top Paying Skills](assests/2_top_paying_roles_skills.png)
*AI generated graph from my SQL query results*
### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 7291         |
| Excel    | 4611         |
| Python   | 4330         |
| Tableau  | 3745         |
| Power BI | 2609         |

*Table of the demand for the top 5 skills in data analyst job postings*

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```
Here's a breakdown of the results for top paying skills for Data Analysts:
- **High Demand for Big Data & ML Skills:** Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
- **Software Development & Deployment Proficiency:** Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
- **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| pyspark       |            208,172 |
| bitbucket     |            189,155 |
| couchbase     |            160,515 |
| watson        |            160,515 |
| datarobot     |            155,486 |
| gitlab        |            154,500 |
| swift         |            153,750 |
| jupyter       |            152,777 |
| pandas        |            151,821 |
| elasticsearch |            145,000 |

*Table of the average salary for the top 10 paying skills for data analysts*

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

| Skill ID | Skills     | Demand Count | Average Salary ($) |
|----------|------------|--------------|-------------------:|
| 8        | go         | 27           |            115,320 |
| 234      | confluence | 11           |            114,210 |
| 97       | hadoop     | 22           |            113,193 |
| 80       | snowflake  | 37           |            112,948 |
| 74       | azure      | 34           |            111,225 |
| 77       | bigquery   | 13           |            109,654 |
| 76       | aws        | 32           |            108,317 |
| 4        | java       | 17           |            106,906 |
| 194      | ssis       | 12           |            106,683 |
| 233      | jira       | 20           |            104,918 |

*Table of the most optimal skills for data analyst sorted by salary*

Here's a breakdown of the most optimal skills for Data Analysts in 2023: 
- **High-Demand Programming Languages:** Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
- **Cloud Tools and Technologies:** Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools:** Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
- **Database Technologies:** The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.

# What I Learned
I completed this project while following along with Luke Barousse's YouTube video on SQL. His guidance completely reshaped how I approach data problems—helping me understand not just how to write SQL, but why each query matters. His content taught me to focus on the significance of query results and, most importantly, to ask the right questions.

Everything I’ve written in the analysis section reflects the insights I gained from Luke’s tutorials. I watched the entire video from start to finish, absorbing each concept, writing the queries myself, and revisiting key sections whenever I felt stuck. His teaching style made learning intuitive and genuinely enjoyable.

To stay active and engaged while learning, I also took [Rough Handwritten Notes](assests/Notes_sql_data_analysis.pdf)

 on my Samsung Galaxy Tab S9 FE+. These notes helped me revise quickly and revisit concepts whenever I felt lost. They stand as proof of my commitment to learning and my effort to follow through the full tutorial attentively.

### What I Learned
This journey helped me level up my SQL skills with practical, real-world applications. Here's what I gained:

**Complex Query Crafting:** 
Learned to write advanced SQL queries by seamlessly joining multiple tables and using WITH clauses (CTEs) for modular, reusable queries.

**Data Aggregation:** 
Gained proficiency with GROUP BY, turning COUNT(), AVG(), and other aggregate functions into tools for summarizing and analyzing data effectively.

**Analytical Thinking:**
Developed the ability to break down real-world questions into data problems—and derive insights that are both actionable and meaningful.

# Conclusions
### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

# Special Thanks
This project wouldn’t have been the same without the guidance of *Luke Barousse*.

Luke is a data analyst, YouTuber, and engineer who helps data enthusiasts level up their skills and productivity. With over 400K subscribers, his YouTube channel is a go-to place for aspiring data professionals.

His content not only taught me how to write SQL queries, but more importantly, how to think like an analyst—asking the right questions and interpreting results meaningfully.

Check out his work here: [www.lukebarousse.com](https://www.lukebarousse.com)