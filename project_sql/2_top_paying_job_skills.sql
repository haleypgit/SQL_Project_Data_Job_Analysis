/*
Question: What skills are required for the top-paying data analyst jobs?
- Goal: Provide a detailed look at which high-paying jobs demand certain skills, helping job seekers understand which skills to develop that align with top salaries.
*/

WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        company_dim.name AS company_name,
        salary_year_avg
    FROM 
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst'
        AND job_location IN ('Anywhere','New York, NY')
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills_dim.skills
FROM 
    top_paying_jobs
    INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;

/* Analysis:
SQL and Python are the top skills, essential for data querying and analysis.

R and Tableau are also in demand, reflecting the importance of statistical analysis and data visualization.

Pandas, NumPy, and Excel highlight the need for strong data manipulation and reporting skills.

Tools like Snowflake, Hadoop, and Express show a trend toward cloud platforms and big data.

Overall, employers seek analysts who can handle data end-to-end using both traditional and modern tools. */



