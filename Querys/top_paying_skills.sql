/*
**Answer: What are the top skills based on salary?** 

- Look at the average salary associated with each skill for Data Analyst positions.
- Focuses on roles with specified salaries, regardless of location.
- Why? It reveals how different skills impact salary levels for Data Analysts and helps identify the most financially rewarding skills to acquire or improve.
 */

WITH data_analyst_jobs AS(
    SELECT
        j.job_id,
        j.salary_year_avg
    FROM
        job_postings_fact j
    WHERE
        j.job_title_short LIKE '%Data_Analyst%'
        AND j.salary_year_avg IS NOT NULL
)

SELECT
    skills_dim.skills,
    ROUND(AVG(d.salary_year_avg), 2) AS avg_salary
FROM
    data_analyst_jobs d
INNER JOIN
    skills_job_dim ON skills_job_dim.job_id = d.job_id
INNER JOIN
    skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
GROUP BY
    skills_dim.skills
ORDER BY
    avg_salary DESC;
