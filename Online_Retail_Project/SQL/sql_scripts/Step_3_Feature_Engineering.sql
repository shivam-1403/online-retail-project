-- ===============================================================
-- STEP 3: FEATURE ENGINEERING
-- ===============================================================

-- Adding an Order Status Column ('Delivered' or 'Cancelled')
ALTER TABLE online_retail_clean
ADD COLUMN OrderStatus VARCHAR(20);

UPDATE online_retail_clean
SET OrderStatus = 
CASE 
  WHEN InvoiceNo LIKE 'C%' THEN 'Cancelled'
  ELSE 'Delivered'
END;


-- Adding a Total Revenue column 
ALTER TABLE online_retail_clean
ADD COLUMN TotalRevenue DECIMAL(10, 2);

UPDATE online_retail_clean
SET TotalRevenue = Quantity * UnitPrice;


-- Adding Year, Month, YearMonth column
ALTER TABLE online_retail_clean
ADD (`Year` INT, 
`Month` INT, 
YearMonth VARCHAR(7));

UPDATE online_retail_clean
SET `Year` = YEAR(InvoiceDate),
	`Month` = MONTH(InvoiceDate),
    YearMonth = DATE_FORMAT(InvoiceDate, '%Y-%m');


-- BUSINESS FEATURES CREATED
-- 1. OrderStatus: Identifies whether transaction is Cancelled or Delivered
-- 2. TotalRevenue: Calculates revenue impact per transaction (includes cancellations)
-- 3. Year, Month, YearMonth: Enables time-based trend analysis