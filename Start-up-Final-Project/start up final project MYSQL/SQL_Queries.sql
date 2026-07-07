-- SQL Queries
USE startup_analysis;

SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM Fact_Startups;
DELETE FROM Dim_Market;
DELETE FROM Dim_BusinessModel;
DELETE FROM Dim_Industry;
SET FOREIGN_KEY_CHECKS = 1;

-- Insert Data Into Dim_Market
INSERT INTO Dim_Market (Market_Size)
SELECT DISTINCT Market_Size
FROM startups
WHERE Market_Size IS NOT NULL;

-- Insert Data Into Dim_BusinessModel
INSERT INTO Dim_BusinessModel (Business_Model)
SELECT DISTINCT Business_Model
FROM startups
WHERE Business_Model IS NOT NULL;

-- Insert Data Into Dim_Industry
INSERT INTO Dim_Industry (Industry_Name)
SELECT DISTINCT Industry
FROM startups
WHERE Industry IS NOT NULL;

-- Insert Data Into Fact_Startups
INSERT INTO Fact_Startups (
    Startup_Name,
    Industry_ID,
    Market_ID,
    Model_ID,
    Startup_Age,
    Funding_Amount,
    Number_of_Founders,
    Founder_Experience,
    Employees_Count,
    Revenue,
    Burn_Rate,
    Product_Uniqueness_Score,
    Customer_Retention_Rate,
    Marketing_Expense,
    Startup_Status
)
SELECT
    s.Startup_Name,
    (SELECT Industry_ID FROM Dim_Industry WHERE Industry_Name = s.Industry),
    (SELECT Market_ID FROM Dim_Market WHERE Market_Size = s.Market_Size),
    (SELECT Model_ID FROM Dim_BusinessModel WHERE Business_Model = s.Business_Model),
    s.Startup_Age,
    s.Funding_Amount,
    s.Number_of_Founders,
    s.Founder_Experience,
    s.Employees_Count,
    s.Revenue,
    s.Burn_Rate,
    s.Product_Uniqueness_Score,
    s.Customer_Retention_Rate,
    s.Marketing_Expense,
    s.Startup_Status
FROM startups s;

-- Result 1: Revenue and Profit by Industry
SELECT 
    d.Industry_Name,
    COUNT(*) AS total_startups,
    FORMAT(SUM(f.Revenue), 2) AS total_revenue,
    FORMAT(SUM(f.Revenue - f.Burn_Rate), 2) AS total_net_profit
FROM Fact_Startups f
JOIN Dim_Industry d
    ON f.Industry_ID = d.Industry_ID
GROUP BY d.Industry_Name
ORDER BY SUM(f.Revenue) DESC;

-- Result 2: Revenue by Business Model
SELECT 
    b.Business_Model,
    COUNT(*) AS total_startups,
    FORMAT(SUM(f.Revenue), 2) AS total_revenue
FROM Fact_Startups f
JOIN Dim_BusinessModel b
    ON f.Model_ID = b.Model_ID
GROUP BY b.Business_Model
ORDER BY SUM(f.Revenue) DESC;

-- Result 3: Customer Retention by Industry
SELECT 
    d.Industry_Name,
    ROUND(AVG(f.Customer_Retention_Rate), 2) AS avg_customer_retention
FROM Fact_Startups f
JOIN Dim_Industry d
    ON f.Industry_ID = d.Industry_ID
GROUP BY d.Industry_Name
ORDER BY avg_customer_retention DESC;

-- Result 4: Profit Margin by Industry
SELECT 
    d.Industry_Name,
    ROUND(SUM(f.Revenue - f.Burn_Rate) / SUM(f.Revenue) * 100, 2) AS profit_margin_percentage
FROM Fact_Startups f
JOIN Dim_Industry d
    ON f.Industry_ID = d.Industry_ID
GROUP BY d.Industry_Name
ORDER BY profit_margin_percentage DESC;

-- Result 5: Revenue per Employee by Industry
SELECT 
    d.Industry_Name,
    ROUND(SUM(f.Revenue) / SUM(f.Employees_Count), 2) AS revenue_per_employee
FROM Fact_Startups f
JOIN Dim_Industry d
    ON f.Industry_ID = d.Industry_ID
GROUP BY d.Industry_Name
ORDER BY revenue_per_employee DESC;

-- Create View: Industry Business Summary
CREATE OR REPLACE VIEW Industry_Business_Summary AS
SELECT 
    d.Industry_Name,
    COUNT(*) AS total_startups,
    CASE 
        WHEN SUM(f.Revenue) >= 1000000000 THEN CONCAT(ROUND(SUM(f.Revenue)/1000000000,1), 'B')
        WHEN SUM(f.Revenue) >= 1000000 THEN CONCAT(ROUND(SUM(f.Revenue)/1000000,1), 'M')
        WHEN SUM(f.Revenue) >= 1000 THEN CONCAT(ROUND(SUM(f.Revenue)/1000,1), 'K')
        ELSE ROUND(SUM(f.Revenue),2)
    END AS total_revenue,
    CASE 
        WHEN SUM(f.Burn_Rate) >= 1000000000 THEN CONCAT(ROUND(SUM(f.Burn_Rate)/1000000000,1), 'B')
        WHEN SUM(f.Burn_Rate) >= 1000000 THEN CONCAT(ROUND(SUM(f.Burn_Rate)/1000000,1), 'M')
        WHEN SUM(f.Burn_Rate) >= 1000 THEN CONCAT(ROUND(SUM(f.Burn_Rate)/1000,1), 'K')
        ELSE ROUND(SUM(f.Burn_Rate),2)
    END AS total_burn_rate,
    CASE 
        WHEN SUM(f.Revenue - f.Burn_Rate) >= 1000000000 THEN CONCAT(ROUND(SUM(f.Revenue - f.Burn_Rate)/1000000000,1), 'B')
        WHEN SUM(f.Revenue - f.Burn_Rate) >= 1000000 THEN CONCAT(ROUND(SUM(f.Revenue - f.Burn_Rate)/1000000,1), 'M')
        WHEN SUM(f.Revenue - f.Burn_Rate) >= 1000 THEN CONCAT(ROUND(SUM(f.Revenue - f.Burn_Rate)/1000,1), 'K')
        ELSE ROUND(SUM(f.Revenue - f.Burn_Rate),2)
    END AS total_net_profit,
	ROUND(AVG(f.Customer_Retention_Rate), 2) AS avg_customer_retention

FROM Fact_Startups f
JOIN Dim_Industry d 
    ON f.Industry_ID = d.Industry_ID
GROUP BY d.Industry_Name;

-- Result 6: View Result
SELECT *
FROM Industry_Business_Summary
ORDER BY total_revenue DESC;