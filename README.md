# Data Analysis jobs

## Introduction

In this project we analyse the Data jobs market. Using a database from [Luke Barousse](https://www.linkedin.com/in/luke-b/). We are going to see the top-paying jobs and the most in-demand skills in the sector.

If you want to check out the queries: [sql_project](/Querys/)


## Background

This project starts with my data analyst jurney. I decided to follow Luke Barousse [course of SQL](https://lukebarousse.com/sql) to learn the basics, but I was surpised. This project is the end of the course, going throw a data set where you can see a lot of details from the listing jobs in 2023 from the data world. Getting a lot of conclusions and also learning a lot in the way.

### The problems that we needed to solve:
1. What are the top paying data analyst jobs?
2. What skills are required for those jobs?
3. What are the top paying data analyst jobs?
4. Wich skills are associated with the higher salaries?
5. What are the most optimal skills to learn?

## Tools used
To complete this project we used:
- SQL
- PostgreSQL
- Git

## The analysis

In this project we are just analyizing data analyst jobs.

#### Top paying jobs:

To identify the best paying roles focusing on the remote job, we filtered by the name and the salary, to clean the data and recive the information that we wanted.


````sql
SELECT 
    j.job_title_short AS title,
    c.name AS company_name,
    j.job_title,
    j.job_location AS location,
    j.salary_year_avg 
FROM
    job_postings_fact j
INNER JOIN
    company_dim c ON c.company_id = j.company_id
WHERE
    j.job_title_short LIKE '%Data_Analyst%' AND
    j.salary_year_avg IS NOT NULL AND
    j.job_location = 'Anywhere'
ORDER BY 
    j.salary_year_avg DESC
LIMIT 10;
````

Here's the breakdown of the top-ten data analyst jobs:
- **Wide salary range** Big diference between the top one ($650,000) and the top two ($336,500) jobs. This indicates a huge variaty of the best payed job offers in the market. 
- **What would be consider a top paying job?**Estabilization in $180,000, indicating that this number should be the average of the best payed jobs as a data analyst.
- **Different roles and positions** In the 10 jobs we can see a variaty of job titles ("Data Analyst", "Director of Analytics", "Principal Data Analyst") indicating there are different roles and specialaization within Data Analytics

![Top paying jobs](/assets/top_paying_jobs.jpg)
*Bar graph visualizing the salary for the top 10 salaries for data analysts; ChatGPT generated this graph from my SQL query results*


### Skills for Top Paying jobs:

To identify the skills that where required for the different jobs we use the first query in a CTE and then we used a Join to realte each job posting to the different skill:

````sql
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
    j.job_title_short LIKE '%Data_Analyst%' AND
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
````
But going a step further, I decided to sum all the skills for all of the job postings, to see wich skills where the most required

````sql
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
    j.job_title_short LIKE '%Data_Analyst%' AND
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
)

SELECT
  job_to_skills.skills,
  COUNT(job_to_skills.skills) AS count_of_skills
FROM job_to_skills
GROUP BY job_to_skills.skills
ORDER BY count_of_skills DESC
````

- **SQL** is leading with 8 jobs postings
- **Python** is repited 7 times 
- **Tableau** is also in more than a half of the jobs postings
- And then we can see that **AWS**, **R**, **Snowflake**, **Pandas** and **Excel** are also repeating along the jobs.

With this insights we can have an idea of what are the most important skills to *perfect* in order to have a good payed job in the Data Analyst world

![Top paying jobs skills](/assets/top_paying_jobs_skills.jpg)