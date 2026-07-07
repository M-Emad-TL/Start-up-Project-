-- Operational Efficiency Analysis
USE startup_analysis;

-- Result 1: Employee Efficiency by Business Model
SELECT 
    b.Business_Model,
    ROUND(SUM(f.Revenue) / SUM(f.Employees_Count), 2) AS revenue_per_employee
FROM Fact_Startups f
JOIN Dim_BusinessModel b
    ON f.Model_ID = b.Model_ID
GROUP BY b.Business_Model
ORDER BY revenue_per_employee DESC;

-- Result 2: Marketing Return by Market Size
SELECT 
    m.Market_Size,
    ROUND(SUM(f.Revenue) / SUM(f.Marketing_Expense), 2) AS marketing_return
FROM Fact_Startups f
JOIN Dim_Market m
    ON f.Market_ID = m.Market_ID
WHERE f.Marketing_Expense > 0
GROUP BY m.Market_Size
ORDER BY marketing_return DESC;