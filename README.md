
# 🧠 Data Analyst Jobs Market – SQL Project

## 📌 Introduction

In this project, I explored the **Data jobs market**, using a dataset shared by [Luke Barousse](https://www.linkedin.com/in/luke-b/). The goal? To find out which are the **top-paying data analyst jobs** and what **skills are most in demand** in the field.

🔍 If you want to check out the actual SQL queries: [See the queries](/Querys/)

---

## 🗺️ Background

This project is part of my journey to becoming a data analyst. I followed [Luke Barousse’s SQL course](https://lukebarousse.com/sql) to strengthen my SQL skills, and I was pleasantly surprised — it ended with this real-world project, analyzing job listings for data roles from 2023.

I learned a lot along the way and gained some powerful insights into the job market.

### 💭 The key questions we wanted to answer:

1. What are the top-paying data analyst jobs?
2. What skills are required for those jobs?
3. Which skills are most associated with higher salaries?
4. What are the most in-demand skills overall?
5. Which are the most *optimal* skills to learn (high salary + high demand)?

---

## 🛠️ Tools Used

- SQL  
- PostgreSQL  
- Git  

---

## 📊 The Analysis

This project focuses on **data analyst jobs**, especially **remote** ones.

### 💰 Top-Paying Jobs

We started by identifying the highest-paying remote data analyst positions. Here’s the query we used:

```sql
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
    j.job_title_short LIKE '%Data_Analyst%'
    AND j.salary_year_avg IS NOT NULL
    AND j.job_location = 'Anywhere'
ORDER BY 
    j.salary_year_avg DESC
LIMIT 10;
```

#### 🧠 Key Insights from the Top 10:

- **Huge salary range** – the highest offer hit **$650,000**, while the second was around **$336,500**!
- **Stabilization around $180K** – looks like a sweet spot for high-paying analyst roles.
- **Job title variety** – even within "Data Analyst", we saw titles like *Director of Analytics* and *Principal Data Analyst*.

![Top paying jobs](/assets/top_paying_jobs.jpg)  
*Bar chart showing the top 10 highest-paying Data Analyst roles*

---

### 🧩 Skills for Top-Paying Jobs

Next, we looked at the skills required by the top-paying positions using a CTE + JOIN approach:

```sql
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
    j.job_title_short LIKE '%Data_Analyst%' 
    AND j.salary_year_avg IS NOT NULL 
    AND j.job_location = 'Anywhere'
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
  salary_year_avg DESC;
```

We then grouped and counted the most common skills from those roles:

```sql
SELECT
  job_to_skills.skills,
  COUNT(job_to_skills.skills) AS count_of_skills
FROM job_to_skills
GROUP BY job_to_skills.skills
ORDER BY count_of_skills DESC;
```

#### 🔧 Most Common Skills in Top-Paying Jobs

| Skill       | Count |
|-------------|-------|
| SQL         | 8     |
| Python      | 7     |
| Tableau     | 6     |
| Excel       | 3     |
| AWS         | 3     |
| Snowflake   | 3     |
| Pandas      | 3     |
| R           | 3     |

✅ **SQL and Python** lead the way — no surprise there. Also, tools like **Tableau**, **AWS**, and **Snowflake** are key in well-paid roles.

---

### 📈 Most In-Demand Skills Overall

We also analyzed **all job listings for Data Analysts** to find the most commonly requested skills:

```sql
SELECT
    skills_dim.skills,
    COUNT(*) AS demand_count
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
RIGHT JOIN
    skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title LIKE '%Data_Analyst%'
GROUP BY
    skills_dim.skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

#### 🔥 Top 5 Most In-Demand Skills

| Skill     | Demand Count |
|-----------|--------------|
| SQL       | 85,030       |
| Excel     | 57,966       |
| Python    | 52,174       |
| Tableau   | 44,330       |
| Power BI  | 35,221       |

💡 SQL, Excel, and Python are clearly **must-haves**. Then come the big visualization tools: **Tableau** and **Power BI**.

---

### 💸 Skills That Pay the Most

Now let’s look at which skills are **associated with the highest average salaries**:

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

Some high-paying examples:

| Skill         | Avg Salary |
|---------------|------------|
| PySpark       | $208,172   |
| Bitbucket     | $189,155   |
| DataRobot     | $155,486   |
| Pandas        | $151,821   |
| NumPy         | $143,513   |
| Databricks    | $141,907   |
| Kubernetes    | $132,500   |

Specialized tools and libraries = **higher salaries**, especially those related to data engineering or cloud infrastructure.

---

### 🚀 Most *Optimal* Skills to Learn (High Demand + High Salary)

Here we can see the mix of high demand and high salary of the skills in the job market, helping us to make a decition on what to learn next!

```sql
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst'
        AND job_postings_fact.salary_year_avg IS NOT NULL
        AND job_postings_fact.job_work_from_home = True
    GROUP BY
        skills_dim.skill_id
),
average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        AVG(job_postings_fact.salary_year_avg) AS avg_salary
    FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst'
        AND job_postings_fact.salary_year_avg IS NOT NULL
        AND job_postings_fact.job_work_from_home = True
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    skills_demand.skills,
    skills_demand.demand_count,
    ROUND(average_salary.avg_salary, 2) AS avg_salary
FROM
    skills_demand
INNER JOIN
    average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY
    demand_count DESC, 
    avg_salary DESC
LIMIT 25;
```

#### 💡 Top Strategic Skills to Learn

| Skill        | Demand Count | Avg Salary ($) |
|--------------|---------------|----------------|
| SQL          | 398           | 97,237.16      |
| Excel        | 256           | 87,288.21      |
| Python       | 236           | 101,397.22     |
| Tableau      | 230           | 99,287.65      |
| R            | 148           | 100,498.77     |
| Power BI     | 110           | 97,431.30      |
| SAS          | 63            | 98,902.37      |
| PowerPoint   | 58            | 88,701.09      |
| Looker       | 49            | 103,795.30     |
| Word         | 48            | 82,576.04      |
| Snowflake    | 37            | 112,947.97     |
| Oracle       | 37            | 104,533.70     |
| SQL Server   | 35            | 97,785.73      |
| Azure        | 34            | 111,225.10     |
| AWS          | 32            | 108,317.30     |

---

### 📌 Conclusions

Here are some key insights we discovered from the analysis:

1. **Top-Paying Roles**: Remote data analyst jobs can reach salaries up to $650,000, showing the potential in this career path.
2. **Critical Skills for High Salaries**: SQL stands out as the most required skill in top-paying roles, proving how essential it is.
3. **Most In-Demand Skills**: Unsurprisingly, SQL, Excel, and Python dominate the demand charts.
4. **High-Salary Niche Skills**: Technologies like Snowflake, Go, and Hadoop offer incredibly high average salaries, suggesting the value of specialization.
5. **Balanced Strategy**: If you want to grow fast and stay competitive, mastering both high-demand and high-paying tools (like SQL, Python, and cloud tech) is a smart move.