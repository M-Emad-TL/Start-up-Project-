-- Dimension Tables
USE startup_analysis;

-- Dim_Market
CREATE TABLE IF NOT EXISTS Dim_Market (
    Market_ID INT PRIMARY KEY AUTO_INCREMENT,
    Market_Size VARCHAR(20)
);

-- Dim_BusinessModel
CREATE TABLE IF NOT EXISTS Dim_BusinessModel (
    Model_ID INT PRIMARY KEY AUTO_INCREMENT,
    Business_Model VARCHAR(20)
);

-- Dim_Industry
CREATE TABLE IF NOT EXISTS Dim_Industry (
    Industry_ID INT PRIMARY KEY AUTO_INCREMENT,
    Industry_Name VARCHAR(50)
);