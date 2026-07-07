-- Startup Overview
USE startup_analysis;

-- Result 1: Total Startups
SELECT 
    COUNT(*) AS total_startups
FROM Fact_Startups;

-- Result 2: Financial Summary
SELECT 
    CONCAT(ROUND(SUM(Funding_Amount)/1000000,1), 'M') AS total_funding,
    CONCAT(ROUND(SUM(Revenue)/1000000,1), 'M') AS total_revenue,
    CONCAT(ROUND(SUM(Burn_Rate)/1000000,1), 'M') AS total_burn_rate,
    CONCAT(ROUND(SUM(Revenue - Burn_Rate)/1000000,1), 'M') AS total_net_profit
FROM Fact_Startups;

-- Result 3: Average Metrics
SELECT
    ROUND(AVG(Startup_Age), 2) AS avg_startup_age,
    ROUND(AVG(Number_of_Founders), 2) AS avg_founders,
    ROUND(AVG(Employees_Count), 2) AS avg_employees,
    ROUND(AVG(Customer_Retention_Rate), 2) AS avg_customer_retention
FROM Fact_Startups;

-- Result 4: Startups by Industry
SELECT 
    d.Industry_Name,
    COUNT(*) AS total_startups
FROM Fact_Startups f
JOIN Dim_Industry d
    ON f.Industry_ID = d.Industry_ID
GROUP BY d.Industry_Name
ORDER BY total_startups DESC;

-- Result 5: Startups by Market Size
SELECT 
    m.Market_Size,
    COUNT(*) AS total_startups
FROM Fact_Startups f
JOIN Dim_Market m
    ON f.Market_ID = m.Market_ID
GROUP BY m.Market_Size
ORDER BY total_startups DESC;

-- Result 6: Startups by Business Model
SELECT 
    b.Business_Model,
    COUNT(*) AS total_startups
FROM Fact_Startups f
JOIN Dim_BusinessModel b
    ON f.Model_ID = b.Model_ID
GROUP BY b.Business_Model
ORDER BY total_startups DESC;