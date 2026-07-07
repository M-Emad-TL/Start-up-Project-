-- Financial Performance Analysis
USE startup_analysis;

-- Result 1: Average Profit by Industry
SELECT 
    d.Industry_Name,
    CONCAT(ROUND(AVG(f.Revenue - f.Burn_Rate) / 1000000, 1), 'M') AS avg_net_profit
FROM Fact_Startups f
JOIN Dim_Industry d
    ON f.Industry_ID = d.Industry_ID
GROUP BY d.Industry_Name
ORDER BY AVG(f.Revenue - f.Burn_Rate) DESC;

-- Result 2: Funding Efficiency by Industry
SELECT 
    d.Industry_Name,
    ROUND(SUM(f.Revenue) / SUM(f.Funding_Amount), 2) AS funding_efficiency
FROM Fact_Startups f
JOIN Dim_Industry d
    ON f.Industry_ID = d.Industry_ID
GROUP BY d.Industry_Name
ORDER BY funding_efficiency DESC;