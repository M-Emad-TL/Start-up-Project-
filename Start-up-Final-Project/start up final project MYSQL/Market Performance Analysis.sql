-- Market Performance Analysis
USE startup_analysis;

-- Result 1: Profit by Market Size
SELECT 
    m.Market_Size,
    CONCAT(ROUND(SUM(f.Revenue - f.Burn_Rate) / 1000000, 1), 'M') AS total_net_profit
FROM Fact_Startups f
JOIN Dim_Market m
    ON f.Market_ID = m.Market_ID
GROUP BY m.Market_Size
ORDER BY SUM(f.Revenue - f.Burn_Rate) DESC;

-- Result 2: Customer Retention by Business Model
SELECT 
    b.Business_Model,
    ROUND(AVG(f.Customer_Retention_Rate), 2) AS avg_customer_retention
FROM Fact_Startups f
JOIN Dim_BusinessModel b
    ON f.Model_ID = b.Model_ID
GROUP BY b.Business_Model
ORDER BY avg_customer_retention DESC;