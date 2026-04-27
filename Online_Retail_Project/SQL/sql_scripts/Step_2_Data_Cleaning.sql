-- ===============================================================
-- STEP 2: DATA CLEANING
-- ===============================================================

-- Creating a new table
DROP TABLE IF EXISTS online_retail_clean;

CREATE TABLE online_retail_clean AS
SELECT 
	InvoiceNo,
    StockCode,
    `Description`,
    Quantity,
    STR_TO_DATE(InvoiceDate, '%Y-%m-%d %H:%i:%s') InvoiceDate,
    UnitPrice,
    CASE WHEN CustomerID IS NULL OR TRIM(CustomerID) = '' THEN NULL
	ELSE CAST(CAST(CustomerID AS DECIMAL(10, 0)) AS UNSIGNED)
    END AS CustomerID,
    Country
FROM online_retail_raw
WHERE (`Description` IS NOT NULL AND TRIM(`Description`) != '') AND (UnitPrice IS NOT NULL AND UnitPrice > 0);

-- Validation
SELECT
COUNT(*) AS total_rows,
SUM(InvoiceNo IS NULL OR InvoiceNo = '') AS missing_invoice,
SUM(StockCode IS NULL OR StockCode = '') AS missing_stockcode,
SUM(`Description` IS NULL OR `Description` = '') AS missing_description,
SUM(Quantity IS NULL OR Quantity <= 0) AS negative_quantity,
SUM(InvoiceDate IS NULL) AS missing_invoice_date,
SUM(UnitPrice IS NULL OR UnitPrice <= 0) AS invalid_price,
SUM(CustomerID IS NULL) AS missing_customer,
SUM(Country IS NULL OR Country = '') AS missing_country
FROM online_retail_clean;

-- ===============================================================
-- KEY INSIGHTS FROM DATA CLEANING
-- ===============================================================
-- 1. Total Rows = Decreased from 295,857 to 294,160
-- 2. Missing Description = Decreased from 1,101 to 0
-- 3. Negative Quantity (Returns) = Decreased from 6,290 to 5,389
-- 4. Invalid Unit Price (<= 0) = Decreased from 1,697 to 0
-- 5. Missing Customer ID = Decreased from 82,808 (~28% of data) to 81,127 (~27% of data)

-- BUSINESS OBSERVATIONS
-- 1. Dataset is now cleaned and ready for analysis
-- 2. Negative quantities represent product returns and are retained for analysis
-- 3. Missing Customer IDs (~27%) limit customer-level insights but not overall sales analysis
-- 4. InvoiceDate converted to proper DATETIME format and CustomerID standardized for accurate analysis