-- Fact Table
USE startup_analysis;

CREATE TABLE IF NOT EXISTS Fact_Startups (
    Startup_ID INT PRIMARY KEY AUTO_INCREMENT,
    Startup_Name VARCHAR(50),
    Industry_ID INT,
    Market_ID INT,
    Model_ID INT,
    Startup_Age INT,
    Funding_Amount DOUBLE,
    Number_of_Founders INT,
    Founder_Experience INT,
    Employees_Count INT,
    Revenue DOUBLE,
    Burn_Rate DOUBLE,
    Product_Uniqueness_Score INT,
    Customer_Retention_Rate DOUBLE,
    Marketing_Expense DOUBLE,
    Startup_Status INT,

    FOREIGN KEY (Industry_ID) REFERENCES Dim_Industry(Industry_ID),
    FOREIGN KEY (Market_ID) REFERENCES Dim_Market(Market_ID),
    FOREIGN KEY (Model_ID) REFERENCES Dim_BusinessModel(Model_ID)
);
