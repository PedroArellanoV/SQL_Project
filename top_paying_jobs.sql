/*
**Question: What are the top-paying data analyst jobs?**

- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries.
- Why? Aims to highlight the top-paying opportunities for Data Analysts, offering insights into
employment options and location flexibility.
*/

SELECT 
    j.job_title_short AS title,
    c.name AS company_name,
    j.job_location AS location,
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
LIMIT 10;