/* Question: Whar are the most optimal skills to learn (high demand, high salary) for Data Analysts?
- Goal: Target skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis.
*/

WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(job_postings_fact.job_id) AS demand_count
    FROM 
    job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst'
        AND job_location IN ('Anywhere','New York, NY')
        AND job_postings_fact.salary_year_avg IS NOT NULL
    GROUP BY 
    skills_dim.skill_id  
),
average_salary AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_to_skill_salary
    FROM 
    job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst'
        AND job_location IN ('Anywhere','New York, NY')
        AND job_postings_fact.salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id  
)
SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    skills_demand.demand_count,
    average_salary.avg_to_skill_salary
FROM
    skills_demand
    INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    skills_demand.demand_count > 10
ORDER BY
    avg_to_skill_salary DESC,
    demand_count DESC
LIMIT 25;
