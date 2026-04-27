-- ===============================================================
-- STEP 1: DATA EXPLORATION
-- ===============================================================

SELECT *
FROM online_retail_raw
LIMIT 10;

SELECT COUNT(*)
FROM online_retail_raw;

-- Finding Null, Blank, Zero and Negative Values
SELECT
COUNT(*) AS total_rows,
SUM(InvoiceNo IS NULL OR InvoiceNo = '') AS missing_invoice,
SUM(StockCode IS NULL OR StockCode = '') AS missing_stockcode,
SUM(`Description` IS NULL OR `Description` = '') AS missing_description,
SUM(Quantity IS NULL OR Quantity <= 0) AS invalid_quantity,
SUM(InvoiceDate IS NULL OR InvoiceDate = '') AS missing_invoice_date,
SUM(UnitPrice IS NULL OR UnitPrice <= 0) AS invalid_price,
SUM(CustomerID IS NULL OR CustomerID = '') AS missing_customer,
SUM(Country IS NULL OR Country = '') AS missing_country
FROM online_retail_raw;

-- ===============================================================
-- KEY INSIGHTS FROM DATA EXPLORATION
-- ===============================================================
-- 1. Total Rows = 295,857
-- 2. Missing Description = 1,101
-- 3. Invalid Quantity (<= 0) = 6,290 (includes returns)
-- 4. Invalid Unit Price (<= 0) = 1,697
-- 5. Missing Customer ID = 82,808 (~28% of data)

-- BUSINESS OBSERVATIONS
-- 1. Dataset contains transactional data (multiple rows per invoice)
-- 2. Negative quantities indicate product returns
-- 3. Missing Customer IDs limit customer-level analysis
-- 4. Rows with missing descriptions are not useful for product analysis