-- ===============================================================
-- STEP 4: ANALYSIS
-- ===============================================================

-- OVERALL METRICS

-- 1. Total Revenue
SELECT SUM(CASE WHEN OrderStatus = 'Delivered' THEN TotalRevenue ELSE 0 END) TotalRevenue
FROM online_retail_clean;

-- 2. Total Orders
SELECT COUNT(DISTINCT InvoiceNo) TotalOrders
FROM online_retail_clean;

-- 3. Total Customers
SELECT COUNT(DISTINCT CustomerID) TotalCustomers
FROM online_retail_clean;


-- PRODUCT ANALYSIS

-- 1. Top 10 Products by Quantity (Gross Sales)
SELECT StockCode, `Description`, SUM(Quantity) TotalQuantity
FROM online_retail_clean
WHERE OrderStatus = 'Delivered'
GROUP BY StockCode, `Description`
ORDER BY TotalQuantity DESC
LIMIT 10;

-- 2. Top 10 Products by Quantity (Net Sales)
SELECT StockCode, `Description`, SUM(Quantity) TotalQuantity
FROM online_retail_clean
GROUP BY StockCode, `Description`
ORDER BY TotalQuantity DESC
LIMIT 10;

-- 3. Total Sold, Total Cancelled, Net Quantity for each Product
SELECT 
	StockCode, 
	`Description`, 
    SUM(CASE WHEN OrderStatus = 'Delivered' THEN Quantity ELSE 0 END) TotalSold,
    ABS(SUM(CASE WHEN OrderStatus = 'Cancelled' THEN Quantity ELSE 0 END)) TotalCancelled,
    SUM(Quantity) NetQuantity
FROM online_retail_clean
GROUP BY StockCode, `Description`
ORDER BY TotalSold DESC;

-- 4. Top Products by Revenue (Gross Revenue)
SELECT StockCode, `Description`, SUM(TotalRevenue) TotalRevenue
FROM online_retail_clean
WHERE OrderStatus = 'Delivered'
GROUP BY StockCode, `Description`
ORDER BY TotalRevenue DESC
LIMIT 10;

-- 5. Top Products by Revenue (Net Revenue)
SELECT StockCode, `Description`, SUM(TotalRevenue) TotalRevenue
FROM online_retail_clean
GROUP BY StockCode, `Description`
ORDER BY TotalRevenue DESC
LIMIT 10;


-- CUSTOMER ANALYSIS

-- 1. Top Customers by Revenue
SELECT CustomerID, SUM(TotalRevenue) AS TotalRevenue
FROM online_retail_clean
WHERE OrderStatus = 'Delivered' AND CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY TotalRevenue DESC
LIMIT 10;

-- 2. Top Customers by Orders
SELECT CustomerID, COUNT(DISTINCT(InvoiceNo)) AS TotalOrders
FROM online_retail_clean
WHERE OrderStatus = 'Delivered' AND CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY TotalOrders DESC
LIMIT 10;

-- 3. Comparison of Top Customers
WITH revenue_cte AS (
    SELECT 
        CustomerID,
        SUM(TotalRevenue) AS TotalRevenue,
        ROW_NUMBER() OVER (ORDER BY SUM(TotalRevenue) DESC) AS rn
    FROM online_retail_clean
    WHERE OrderStatus = 'Delivered' 
      AND CustomerID IS NOT NULL
    GROUP BY CustomerID
),

orders_cte AS (
    SELECT 
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS TotalOrders,
        ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT InvoiceNo) DESC) AS rn
    FROM online_retail_clean
    WHERE OrderStatus = 'Delivered' 
      AND CustomerID IS NOT NULL
    GROUP BY CustomerID
)

SELECT 
    r.rn AS `Rank`,
    r.CustomerID AS Revenue_Customer,
    r.TotalRevenue,
    o.CustomerID AS Orders_Customer,
    o.TotalOrders
FROM revenue_cte r
JOIN orders_cte o
    ON r.rn = o.rn
WHERE r.rn <= 10;


-- TIME SERIES ANALYSIS

-- 1. Revenue by Year
SELECT `Year`, SUM(TotalRevenue) TotalRevenue
FROM online_retail_clean
WHERE OrderStatus = 'Delivered'
GROUP BY `Year`
ORDER BY `Year` DESC;

-- 2. Revenue by Months of Year
SELECT YearMonth, SUM(TotalRevenue) TotalRevenue
FROM online_retail_clean
WHERE OrderStatus = 'Delivered'
GROUP BY YearMonth
ORDER BY YearMonth DESC;

-- 3. Revenue by Month only
SELECT `Month`, SUM(TotalRevenue) TotalRevenue
FROM online_retail_clean
WHERE OrderStatus = 'Delivered'
GROUP BY `Month`
ORDER BY `Month`;

-- 4. Orders by Year
SELECT `Year`, COUNT(DISTINCT(InvoiceNo)) TotalOrders
FROM online_retail_clean
WHERE OrderStatus = 'Delivered'
GROUP BY `Year`
ORDER BY `Year` DESC;

-- 5. Orders by Months of Year
SELECT YearMonth, COUNT(DISTINCT(InvoiceNo)) TotalOrders
FROM online_retail_clean
WHERE OrderStatus = 'Delivered'
GROUP BY YearMonth
ORDER BY YearMonth DESC;

-- 6. Orders by Month only
SELECT `Month`, COUNT(DISTINCT(InvoiceNo)) TotalOrders
FROM online_retail_clean
WHERE OrderStatus = 'Delivered'
GROUP BY `Month`
ORDER BY `Month`;

-- 7. Average Order Value (AOV)
SELECT SUM(TotalRevenue) / COUNT(DISTINCT InvoiceNo) AS AOV
FROM online_retail_clean
WHERE OrderStatus = 'Delivered';

-- 8. Monthly AOV
SELECT 
    YearMonth,
    SUM(TotalRevenue) / COUNT(DISTINCT InvoiceNo) AS AOV
FROM online_retail_clean
WHERE OrderStatus = 'Delivered'
GROUP BY YearMonth
ORDER BY YearMonth;


-- CANCELLATION RATE
SELECT
	AVG(OrderStatus = 'Cancelled') * 100 CacellationRate
FROM online_retail_clean;