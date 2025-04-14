/*
  **Question: What are the top-paying data analyst jobs, and what skills are required?** 

- Identify the top 10 highest-paying Data Analyst jobs and the specific skills required for these roles.
- Filters for roles with specified salaries that are remote
- Why? It provides a detailed look at which high-paying jobs demand certain skills, helping job seekers understand which skills to develop that align with top salaries
*/
WITH top_ten_jobs AS (
  SELECT 
    j.job_id,
    j.job_title AS title,
    c.name AS company_name,
    j.job_location,
    j.salary_year_avg 
FROM
    job_postings_fact j
INNER JOIN
    company_dim c ON c.company_id = j.company_id
WHERE
    j.job_title LIKE '%Data_Analyst%' AND
    j.salary_year_avg IS NOT NULL AND
    j.job_location = 'Anywhere'
ORDER BY 
    j.salary_year_avg DESC
LIMIT 10
)

SELECT 
  top_ten_jobs.job_id,
  title,
  salary_year_avg,
  skills
FROM
  top_ten_jobs
INNER JOIN
  skills_job_dim AS skill_to_job ON skill_to_job.job_id = top_ten_jobs.job_id
LEFT JOIN 
  skills_dim AS skills ON skills.skill_id = skill_to_job.skill_id
ORDER BY 
  top_ten_jobs.salary_year_avg DESC
  ;