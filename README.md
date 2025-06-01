# Introduction
In today’s fast-evolving data-driven world, knowing which skills and roles offer the best opportunities is more important than ever. This project explores the 2023 job market for data analysts, using real job posting data to uncover meaningful insights. The analysis identifies:

🔝 The highest-paying data analyst job titles

🛠️ The top skills associated with high-paying roles

📈 The most demanded and well-compensated skills in the field

By combining salary data, job titles, and skill requirements, this project offers a clear view of what companies are truly looking for—and paying for—in today's competitive data landscape.
🔎 SQL Queries? Check them out here: [project_sql folder](/project_sql/)

# Background
With the rapid growth of data-driven roles, navigating the job market can be overwhelming. This project was created to better understand the landscape—focusing on the skills, roles, and salaries that define today’s top opportunities for data analysts.
### The questions I wanted to cover through my SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?
# Tools I used
🛠️ Tools Used:

▪ **SQL** – Used to explore, filter, and analyze the job posting data to uncover trends in salaries, roles, and skills.

▪ **PostgreSQL** – Served as the relational database system where all data was stored, queried, and processed.

▪ **VS Code** – My development environment for managing the project, writing, and executing SQL scripts with ease.

▪ **Git & GitHub** – Used for version control and sharing the project, allowing for smooth tracking of changes and collaboration.


# The Analysis
Each query is designed to investigate certain aspects of the data analyst job market in 2023. Here is the detail on my approach:

### 1. Top Paying Data Analyst Jobs
To identify the top-paying jobs, I filtered out 'Data Analyst' positions by average yearly salary. I also include 'Anywhere' and 'New York, NY' for location. This query helps me find the most high paying opportunities for my personal preference in the field. 

```sql
SELECT
    job_id,
    job_title,
    company_dim.name AS company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM 
    job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_location IN ('Anywhere','New York, NY')
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

### 2. Top Skills For Top Paying Data Analyst Jobs
With 'Data Analyst' from 'Anywhere' and 'New York, NY' selected, I navigated the skills that associate with these roles to identify what skills were needed for such high salaries.
```sql
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
```

### 3. Most Demand Skills
Using COUNT function, I found skills that were mentioned the most for Data Analysts job postings. This query will be beneficial for seeing what the current job market needs and targeting most demanded skills for job seekers.

```sql
SELECT 
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) AS demand_count
FROM 
    job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY 
    skills_dim.skills   
ORDER BY
    demand_count DESC
LIMIT 5;
```

### 4. Top-paying Skills
In order to get the highest paying skills, I used AVG function to find average anual salary for each kill. Also, I filtered out 25 niche skills that lead to highest income for data analysts.
```sql
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
```

### 5. The Optimal Skills
To found the intersection between most demanded and top-paying skills, I utilized CTEs. This would give job seekers directions both short and long term pursuing Data Analytics. 
```sql
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
```

# What I learned
🧠 **Advanced SQL Techniques:**
I significantly improved my SQL skills by working with complex queries, including the use of COUNT(), AVG(), and other aggregate functions to generate meaningful insights from data. I also practiced writing nested subqueries and Common Table Expressions (CTEs) to enhance the clarity and efficiency of my code.

🔗 **Working with Relational Databases:**
This project helped me strengthen my understanding of JOIN operations by combining multiple tables to answer data-driven questions. I became more confident in identifying the right join types and structuring queries that reflect the relationships within the database schema.

🛠️ **Problem Solving & Logical Thinking:**
Through hands-on challenges, I developed a sharper analytical mindset. I learned how to break down complex problems into smaller steps, identify patterns in data, and build queries that not only work—but also scale well with larger datasets.



# Conclusions
### 1. Top Paying Data Analyst Jobs
|job_id |job_title                                           |company_name                |job_location|job_schedule_type|salary_year_avg|job_posted_date    |
|-------|----------------------------------------------------|----------------------------|------------|-----------------|---------------|-------------------|
|226942 |Data Analyst                                        |Mantys                      |Anywhere    |Full-time        |650000.0       |2023-02-20 15:13:33|
|547382 |Director of Analytics                               |Meta                        |Anywhere    |Full-time        |336500.0       |2023-08-23 12:04:42|
|552322 |Associate Director- Data Insights                   |AT&T                        |Anywhere    |Full-time        |255829.5       |2023-06-18 16:03:12|
|339646 |Data Sector Analyst - Hedge Fund in Midtown         |Coda Search│Staffing        |New York, NY|Full-time        |240000.0       |2023-08-17 13:00:09|
|1713491|Investigations and Insights Lead Data Analyst - USDS|TikTok                      |New York, NY|Full-time        |239777.5       |2023-07-09 14:00:05|
|841064 |Investigations and Insights Lead Data Analyst - USDS|TikTok                      |New York, NY|Full-time        |239777.5       |2023-05-27 13:59:57|
|99305  |Data Analyst, Marketing                             |Pinterest Job Advertisements|Anywhere    |Full-time        |232423.0       |2023-12-05 20:00:40|
|204500 |Reference Data Analyst                              |Selby Jennings              |New York, NY|Full-time        |225000.0       |2023-05-12 19:59:54|
|1021647|Data Analyst (Hybrid/Remote)                        |Uclahealthcareers           |Anywhere    |Full-time        |217000.0       |2023-01-17 00:17:23|
|168310 |Principal Data Analyst (Remote)                     |SmartAsset                  |Anywhere    |Full-time        |205000.0       |2023-08-09 11:00:01|

📊 **Data Analyst Job Market Insights:**

💼 **Roles & Seniority:**

While all roles fall under the Data Analyst umbrella, they vary significantly in seniority and scope:

- Basic roles: Data Analyst, Marketing Data Analyst, Reference Data Analyst

- Mid-senior roles: Principal Data Analyst, Associate Director - Data Insights

- Leadership: Director of Analytics, Investigations and Insights Lead

Several roles mix domain specialization (e.g., marketing, investigations, reference data) with analytics, showing that hybrid expertise is highly valued.

💰 **High-Paying Opportunities:**

- The top-paying role is a general Data Analyst at Mantys with a surprising $650,000 salary. This is likely an outlier or includes additional compensation (e.g., equity).

- Other high-paying roles:

Director of Analytics at Meta – $336,500

Associate Director - Data Insights at AT&T – $255,829.50

Two identical roles at TikTok – $239,777.50 each

Most of these high-paying roles come with director-level or lead titles, suggesting that management experience and cross-functional leadership are strong salary drivers.

🔁 **Notable Patterns:**

- Repeated Role Posting: TikTok’s "Investigations and Insights Lead" appears twice, possibly reflecting multiple openings or reposting for visibility.

- Location Flexibility: The highest paying jobs are mostly remote-friendly ("Anywhere"), showing that companies no longer tie high salaries to expensive locations.

- Consistent Job Type: All roles are full-time, reinforcing that high-level data analysis is seen as a core, not freelance or contract, function.

🧠 **Takeaway:**

The data analyst title covers a wide range of roles, from entry-level to executive-track positions. High salaries are concentrated in leadership or specialized roles that blend analytics with strategy, business acumen, or domain knowledge. Companies increasingly offer remote work without sacrificing compensation, making the market both lucrative and flexible.
### 2. Top Skills For Top Paying Data Analyst Jobs
|job_id |job_title                                           |company_name                |salary_year_avg|skills   |
|-------|----------------------------------------------------|----------------------------|---------------|---------|
|552322 |Associate Director- Data Insights                   |AT&T                        |255829.5       |sql      |
|552322 |Associate Director- Data Insights                   |AT&T                        |255829.5       |python   |
|552322 |Associate Director- Data Insights                   |AT&T                        |255829.5       |r        |
|552322 |Associate Director- Data Insights                   |AT&T                        |255829.5       |azure    |
|552322 |Associate Director- Data Insights                   |AT&T                        |255829.5       |databricks|
|552322 |Associate Director- Data Insights                   |AT&T                        |255829.5       |aws      |
|552322 |Associate Director- Data Insights                   |AT&T                        |255829.5       |pandas   |
|552322 |Associate Director- Data Insights                   |AT&T                        |255829.5       |pyspark  |
|552322 |Associate Director- Data Insights                   |AT&T                        |255829.5       |jupyter  |
|552322 |Associate Director- Data Insights                   |AT&T                        |255829.5       |excel    |
|552322 |Associate Director- Data Insights                   |AT&T                        |255829.5       |tableau  |
|552322 |Associate Director- Data Insights                   |AT&T                        |255829.5       |power bi |
|552322 |Associate Director- Data Insights                   |AT&T                        |255829.5       |powerpoint|
|339646 |Data Sector Analyst - Hedge Fund in Midtown         |Coda Search│Staffing        |240000.0       |sql      |
|339646 |Data Sector Analyst - Hedge Fund in Midtown         |Coda Search│Staffing        |240000.0       |python   |
|339646 |Data Sector Analyst - Hedge Fund in Midtown         |Coda Search│Staffing        |240000.0       |pandas   |
|841064 |Investigations and Insights Lead Data Analyst - USDS|TikTok                      |239777.5       |sql      |
|841064 |Investigations and Insights Lead Data Analyst - USDS|TikTok                      |239777.5       |python   |
|841064 |Investigations and Insights Lead Data Analyst - USDS|TikTok                      |239777.5       |r        |
|841064 |Investigations and Insights Lead Data Analyst - USDS|TikTok                      |239777.5       |express  |
|1713491|Investigations and Insights Lead Data Analyst - USDS|TikTok                      |239777.5       |sql      |
|1713491|Investigations and Insights Lead Data Analyst - USDS|TikTok                      |239777.5       |python   |
|1713491|Investigations and Insights Lead Data Analyst - USDS|TikTok                      |239777.5       |r        |
|1713491|Investigations and Insights Lead Data Analyst - USDS|TikTok                      |239777.5       |express  |
|99305  |Data Analyst, Marketing                             |Pinterest Job Advertisements|232423.0       |sql      |
|99305  |Data Analyst, Marketing                             |Pinterest Job Advertisements|232423.0       |python   |
|99305  |Data Analyst, Marketing                             |Pinterest Job Advertisements|232423.0       |r        |
|99305  |Data Analyst, Marketing                             |Pinterest Job Advertisements|232423.0       |hadoop   |
|99305  |Data Analyst, Marketing                             |Pinterest Job Advertisements|232423.0       |tableau  |
|204500 |Reference Data Analyst                              |Selby Jennings              |225000.0       |sql      |
|204500 |Reference Data Analyst                              |Selby Jennings              |225000.0       |python   |
|1021647|Data Analyst (Hybrid/Remote)                        |Uclahealthcareers           |217000.0       |sql      |
|1021647|Data Analyst (Hybrid/Remote)                        |Uclahealthcareers           |217000.0       |crystal  |
|1021647|Data Analyst (Hybrid/Remote)                        |Uclahealthcareers           |217000.0       |oracle   |
|1021647|Data Analyst (Hybrid/Remote)                        |Uclahealthcareers           |217000.0       |tableau  |
|1021647|Data Analyst (Hybrid/Remote)                        |Uclahealthcareers           |217000.0       |flow     |
|168310 |Principal Data Analyst (Remote)                     |SmartAsset                  |205000.0       |sql      |
|168310 |Principal Data Analyst (Remote)                     |SmartAsset                  |205000.0       |python   |
|168310 |Principal Data Analyst (Remote)                     |SmartAsset                  |205000.0       |go       |
|168310 |Principal Data Analyst (Remote)                     |SmartAsset                  |205000.0       |snowflake|
|168310 |Principal Data Analyst (Remote)                     |SmartAsset                  |205000.0       |pandas   |
|168310 |Principal Data Analyst (Remote)                     |SmartAsset                  |205000.0       |numpy    |
|168310 |Principal Data Analyst (Remote)                     |SmartAsset                  |205000.0       |excel    |
|168310 |Principal Data Analyst (Remote)                     |SmartAsset                  |205000.0       |tableau  |
|168310 |Principal Data Analyst (Remote)                     |SmartAsset                  |205000.0       |gitlab   |

🧠 Skills Behind High-Paying Data Analyst Roles

💰 **1. Top Salaries, Top Skills**

The highest-paid role (Associate Director – Data Insights @ AT&T, $255,829.5) requires a blend of technical depth and tool fluency, including:

- Programming: Python, R, Pandas, PySpark

- Data Platforms: Databricks, AWS, Azure

- Visualization & Reporting: Tableau, Power BI, PowerPoint, Excel

- Notebook & collaboration tools: Jupyter

🧩 This points to a hybrid skill set — coding, cloud, and presentation — being critical at leadership levels.

🚀 **2. Most Common Skills Across High-Paying Jobs**

Here’s how often key skills appear in roles earning $200K+:

|Skill  |Mentions                                            |
|-------|----------------------------------------------------|
|SQL    |10                                                  |
|Python |9                                                   |
|Tableau|4                                                   |
|R      |4                                                   |
|Excel  |2                                                   |
|Power BI|1                                                   |
|AWS/Azure|2                                                   |
|Pandas |2                                                   |


🔎 SQL and Python dominate — they appear in nearly every role. Visualization tools like Tableau and Excel are the next most frequent.

🎯 **3. Specialized & Supporting Skills**

- Cloud & Big Data: Snowflake, Databricks, AWS, Azure, Hadoop — critical for modern data pipelines and big-data processing.

- BI & Visualization: Tableau, Power BI, Excel, Crystal, PowerPoint — needed to translate data into business insight.

- Advanced Coding & Tools:

PySpark, Go, Numpy, GitLab, Flow, Oracle, Express show up in fewer roles, but usually in more senior or domain-specific jobs.

🔍 **Final Takeaway**

To target top-paying data analyst jobs, build a stack like this:

- Core: SQL, Python, Tableau

- Bonus: R, Excel, Pandas

- Advanced: Cloud (e.g., AWS, Azure), Big Data (Databricks, Snowflake), Scripting (PySpark, Go), and Visualization (Power BI)

Mastering both technical execution and business communication tools appears to be the winning combo.

### 3. Most Demand Skills
|skills |demand_count                                        |
|-------|----------------------------------------------------|
|sql    |92628                                               |
|excel  |67031                                               |
|python |57326                                               |
|tableau|46554                                               |
|power bi|39468                                               |

📊 **In-Demand Data Skills (Job Market Insight):**

🔎 SQL is king: With over 92K mentions, SQL remains the most requested skill — it's the foundation of almost all data roles.

🧰 Excel & Python still dominate: Excel (67K) is widely used in business analytics, while Python (57K) powers automation and advanced analysis.

📈 Visualization matters: Tableau (46K) and Power BI (39K) are both in high demand — knowing at least one is key for turning data into insights.

### 4. Top-paying Skills
|skills |avg_to_skill_salary                                 |
|-------|----------------------------------------------------|
|svn    |400000                                              |
|solidity|179000                                              |
|couchbase|160515                                              |
|datarobot|155486                                              |
|golang |155000                                              |
|mxnet  |149000                                              |
|dplyr  |147633                                              |
|vmware |147500                                              |
|terraform|146734                                              |
|twilio |138500                                              |
|gitlab |134126                                              |
|kafka  |129999                                              |
|puppet |129820                                              |
|keras  |127013                                              |
|pytorch|125226                                              |
|perl   |124686                                              |
|ansible|124370                                              |
|hugging face|123950                                              |
|tensorflow|120647                                              |
|cassandra|118407                                              |
|notion |118092                                              |
|atlassian|117966                                              |
|bitbucket|116712                                              |
|airflow|116387                                              |
|scala  |115480                                              |

💰 **Top-Paying Data Skills (Based on Avg Salary):**
🧠 Niche & specialized skills = high rewards
Tools like SVN ($400K) and Solidity ($179K) top the list, reflecting demand in version control and blockchain development.

⚙️ AI, ML & MLOps skills pay well
Frameworks like PyTorch ($125K), Keras ($127K), and TensorFlow ($121K) continue to command strong salaries, especially in AI-driven roles.

🛠️ DevOps & cloud tools are lucrative
Skills like Terraform ($147K), VMware ($147K), and Ansible ($124K) show that blending data skills with DevOps/cloud expertise opens high-earning opportunities.

### 5. The Optimal Skills
|skill_id|skills    |demand_count|avg_to_skill_salary|
|--------|----------|------------|-------------------|
|93      |pandas    |16          |143661             |
|75      |databricks|15          |129104             |
|141     |express   |19          |116320             |
|80      |snowflake |50          |114672             |
|74      |azure     |47          |114397             |
|4       |java      |25          |112743             |
|97      |hadoop    |28          |109751             |
|234     |confluence|17          |109401             |
|77      |bigquery  |21          |108810             |
|76      |aws       |52          |107767             |
|26      |c         |11          |107585             |
|8       |go        |51          |106072             |
|185     |looker    |71          |106034             |
|233     |jira      |31          |105657             |
|13      |c++       |15          |105648             |
|194     |ssis      |16          |105019             |
|187     |qlik      |17          |104603             |
|1       |python    |362         |104529             |
|61      |sql server|55          |103801             |
|184     |dax       |12          |103125             |
|189     |sap       |13          |102858             |
|79      |oracle    |50          |101986             |
|92      |spark     |22          |101599             |
|23      |crystal   |14          |101243             |
|2       |nosql     |20          |101187             |

💎 **High-Demand & High-Paying Skills (Power Combo):**

🔥 **The Sweet Spot:** Widely Used & Well Paid
Skills like Python (💼 362 jobs | 💰 $104K), AWS (52 | $108K), Snowflake (50 | $114K), and Azure (47 | $114K) are both in high demand and pay exceptionally well. These are the skills that employers consistently look for — across industries and roles.

🚀 **Rising Tech:** Data Engineering & Cloud Stack
Tools like Databricks ($129K), Pandas ($143K), BigQuery ($108K), and Spark ($101K) reflect the shift toward cloud-native analytics and scalable pipelines. They’re powering modern data architectures — making them extremely valuable and future-proof.

🧰 **Enterprise & BI Tools:** Still Going Strong
Platforms like Looker, Jira, Confluence, Qlik, SSIS, and SAP may not dominate tech blogs, but they are core to business operations — offering a solid combination of enterprise reliability and six-figure salaries.

## Final Conclusion
This project provided valuable insights into the current data analyst job market, highlighting the growing demand for cloud, analytics, and programming skills. High-paying roles increasingly favor candidates skilled in tools like Python, SQL, Pandas, Databricks, and cloud platforms such as AWS and Azure. By identifying the intersection of high-demand and top-paying technologies, I gained a deeper understanding of the evolving landscape and the skillsets that open doors to competitive, future-ready opportunities in data careers and I really hope that these insights are helpful for you in some ways.