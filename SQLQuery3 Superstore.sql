-- Query 1: Total sales by year
SELECT
    EXTRACT(YEAR FROM Order_Date) AS Year,
    SUM(Sales) AS Total_Sales
FROM
    Sales_Data
GROUP BY
    EXTRACT(YEAR FROM Order_Date)
ORDER BY
    Year;

-- Query 2: Top 10 selling products
SELECT
    Product_ID,
    SUM(Sales) AS Total_Sales
FROM
    Sales_Data
GROUP BY
    Product_ID
ORDER BY
    Total_Sales DESC
LIMIT 10;

-- Query 3: Total sales by region
SELECT
    Region,
    SUM(Sales) AS Total_Sales
FROM
    Sales_Data
GROUP BY
    Region;

-- Query 4: Profit analysis by year
SELECT
    EXTRACT(YEAR FROM Order_Date) AS Year,
    SUM(Sales - Cost) AS Total_Profit
FROM
    Sales_Data
GROUP BY
    EXTRACT(YEAR FROM Order_Date)
ORDER BY
    Year;

-- Query 5: Monthly sales trend for a specific product (Product_ID = 'P100')
SELECT
    EXTRACT(MONTH FROM Order_Date) AS Month,
    SUM(Sales) AS Monthly_Sales
FROM
    Sales_Data
WHERE
    Product_ID = 'P100'
GROUP BY
    EXTRACT(MONTH FROM Order_Date)
ORDER BY
    Month;

-- Query 6: Total sales and profit by region and year
SELECT
    EXTRACT(YEAR FROM Order_Date) AS Year,
    Region,
    SUM(Sales) AS Total_Sales,
    SUM(Sales - Cost) AS Total_Profit
FROM
    Sales_Data
GROUP BY
    EXTRACT(YEAR FROM Order_Date),
    Region
ORDER BY
    Year, Region;

-- Query 7: Sales forecast for the next year (e.g., 2023)
SELECT
    EXTRACT(YEAR FROM Order_Date) AS Year,
    EXTRACT(MONTH FROM Order_Date) AS Month,
    SUM(Sales) AS Monthly_Sales
FROM
    Sales_Data
WHERE
    EXTRACT(YEAR FROM Order_Date) = 2023
GROUP BY
    EXTRACT(YEAR FROM Order_Date),
    EXTRACT(MONTH FROM Order_Date)
ORDER BY
    Year, Month;

-- Query 8: Average order value by customer
SELECT
    Customer_ID,
    AVG(Sales) AS Avg_Order_Value
FROM
    Sales_Data
GROUP BY
    Customer_ID;

-- Query 9: Total sales by product category
SELECT
    Category,
    SUM(Sales) AS Total_Sales
FROM
    Products
JOIN
    Sales_Data ON Products.Product_ID = Sales_Data.Product_ID
GROUP BY
    Category;

-- Query 10: Year-over-year growth rate in sales
SELECT
    Year,
    (Total_Sales - LAG(Total_Sales) OVER (ORDER BY Year)) / LAG(Total_Sales) OVER (ORDER BY Year) AS YoY_Growth_Rate
FROM
    (SELECT
        EXTRACT(YEAR FROM Order_Date) AS Year,
        SUM(Sales) AS Total_Sales
    FROM
        Sales_Data
    GROUP BY
        EXTRACT(YEAR FROM Order_Date)
    ORDER BY
        Year) AS yearly_sales;

-- Query 11: Profit margin by product category
SELECT
    Category,
    AVG((Sales - Cost) / Sales) * 100 AS Profit_Margin_Percentage
FROM
    Products
JOIN
    Sales_Data ON Products.Product_ID = Sales_Data.Product_ID
GROUP BY
    Category;

-- Query 12: Customer retention rate
SELECT
    EXTRACT(YEAR FROM Order_Date) AS Year,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    COUNT(DISTINCT CASE WHEN EXTRACT(YEAR FROM Order_Date) = EXTRACT(YEAR FROM DATE_SUB(Order_Date, INTERVAL 1 YEAR)) THEN Customer_ID END) AS Retained_Customers,
    COUNT(DISTINCT CASE WHEN EXTRACT(YEAR FROM Order_Date) = EXTRACT(YEAR FROM DATE_SUB(Order_Date, INTERVAL 1 YEAR)) THEN Customer_ID END) / COUNT(DISTINCT Customer_ID) * 100 AS Retention_Rate
FROM
    Sales_Data
GROUP BY
    EXTRACT(YEAR FROM Order_Date);

-- Query 13: Total profit margin across all product categories
WITH Profit_Margins AS (
    SELECT
        Category,
        AVG((Sales - Cost) / Sales) * 100 AS Profit_Margin_Percentage
    FROM
        Products
    JOIN
        Sales_Data ON Products.Product_ID = Sales_Data.Product_ID
    GROUP BY
        Category
)
SELECT
    SUM(Profit_Margin_Percentage) AS Total_Profit_Margin_Across_Categories
FROM
    Profit_Margins;
