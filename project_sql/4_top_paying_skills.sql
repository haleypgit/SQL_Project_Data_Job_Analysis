/*
Question: What are the top paying skills based on salary for Data Analysts?
- Goal: Reveal how different skills impact salary levels for Data Analysts and help identify the most financially rewarding skills to acquire or improve.
*/

SELECT 
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_to_skill_salary
FROM 
    job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
    AND job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY 
    skills_dim.skills   
ORDER BY
    avg_to_skill_salary DESC
LIMIT 25;

/* Analysis:
SVN tops the chart with a surprising $400K average salary—likely reflecting niche or legacy system expertise in high-level roles.

AI/ML frameworks (like DataRobot, MXNet, PyTorch, and TensorFlow) are consistently above $120K, signaling strong demand in machine learning.

DevOps tools such as Terraform, Puppet, and VMware are high-paying, showing the value of cloud infrastructure skills.

Emerging tech pays off: Skills like Solidity (blockchain) and Golang (modern systems) earn well above $150K.
*/