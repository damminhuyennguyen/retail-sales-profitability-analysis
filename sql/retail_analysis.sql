----------------------------------------------------------------------
-- QA / VALIDATION 
----------------------------------------------------------------------


-- Confirm imported column data types
DESCRIBE dim_calendar;

-- Validate calendar import 
SELECT 
    COUNT(*) AS total_rows, 
    COUNT(DISTINCT cal_date) AS distinct_dates, 
    SUM(cal_date IS NULL) AS null_dates, 
    MIN(cal_date) AS min_date, 
    MAX(cal_date) AS max_date, 
    SUM(month_year IS NULL) AS null_month_years, 
    MIN(month_year) AS min_month_year, 
    MAX(month_year) AS max_month_year
FROM dim_calendar; 


-- Confirm imported column data types 
DESCRIBE dim_product; 

-- Validate product import 
SELECT 
    COUNT(*) AS total_rows, 
    COUNT(DISTINCT product_key) AS distinct_product_key, 
    SUM(product_key IS NULL) AS null_product_keys
FROM dim_product;


-- Confirm imported column data types 
DESCRIBE dim_customer; 

-- Validate customer import 
SELECT 
    COUNT(*) AS total_rows, 
    COUNT(DISTINCT customer_id) AS distinct_customer_id, 
    SUM(customer_id IS NULL) AS null_customer_ids
FROM dim_customer;


-- Confirm imported column data types 
DESCRIBE fact_order_lines; 

-- Validate order import 
SELECT 
    COUNT(*) AS total_rows, 
    COUNT(DISTINCT row_id) AS distinct_row_id, 
    SUM(row_id IS NULL) AS null_row_ids, 
    SUM(order_date IS NULL) AS null_order_dates,
    SUM(ship_date IS NULL) AS null_ship_dates, 
    MIN(order_date) AS min_order_date, 
    MAX(order_date) AS max_order_date, 
    COUNT(DISTINCT order_id) AS distinct_order_id, 
    SUM(sales) AS total_sales, 
    SUM(profit) AS total_profit
FROM fact_order_lines;


----------------------------------------------------------------------
-- RELATIONSHIP INTEGRITY
----------------------------------------------------------------------


-- Check unmatched product keys
SELECT COUNT(*) AS unmatched_product_keys
FROM fact_order_lines 
LEFT JOIN dim_product 
    ON fact_order_lines.product_key = dim_product.product_key
WHERE dim_product.product_key IS NULL;


-- Check unmatched customer IDs 
SELECT COUNT(*) AS unmatched_customer_ids
FROM fact_order_lines
LEFT JOIN dim_customer
    ON fact_order_lines.customer_id = dim_customer.customer_id
WHERE dim_customer.customer_id IS NULL;


-- Check unmatched order dates 
SELECT COUNT(*) AS unmatched_order_dates
FROM fact_order_lines
LEFT JOIN dim_calendar 
    ON fact_order_lines.order_date = dim_calendar.cal_date
WHERE dim_calendar.cal_date IS NULL;


----------------------------------------------------------------------
-- BUSINESS ANALYSIS
----------------------------------------------------------------------


-- Q1 - Annual Sales and Profit Trend 
-- How did sales, profit, and profit margin change by year? 


SELECT
    dim_calendar.YEAR, 
    SUM(fact_order_lines.sales) AS total_sales, 
    SUM(fact_order_lines.profit) AS total_profit, 
    ((SUM(fact_order_lines.profit)/ SUM(fact_order_lines.sales))*100) AS profit_margin
FROM fact_order_lines 
JOIN dim_calendar
    ON fact_order_lines.order_date = dim_calendar.cal_date 
GROUP BY dim_calendar.YEAR
ORDER BY dim_calendar.YEAR ASC; 


-- Q2 - Sub-Category Profit Performance 
-- Which sub-categories generated the most and least profit?


SELECT 
    SUM(fact_order_lines.profit) AS total_profit, 
    dim_product.sub_category AS sub_category
FROM fact_order_lines
JOIN dim_product
    ON fact_order_lines.product_key = dim_product.product_key 
GROUP BY dim_product.sub_category 
ORDER BY total_profit DESC;


-- Q3 - Average discount and profit margin by state
-- How do average discount and profit margin vary by state?


SELECT 
    state, 
    (AVG(discount)*100) AS average_discount, 
   ((SUM(profit)/SUM(sales))*100) AS profit_margin
FROM fact_order_lines 
GROUP BY state
ORDER BY average_discount DESC;


-- Q4 - Annual order return rate by region
-- How did order return rate vary by region and year?


WITH regional_returns AS ( 
    SELECT 
    dim_calendar.year AS year, 
    fact_order_lines.region AS region, 
    COUNT(DISTINCT fact_order_lines.order_id)AS total_orders, 
    COUNT(DISTINCT
          CASE 
                 WHEN returned = 'Yes' THEN order_id
          END
     ) AS returned_orders
    FROM fact_order_lines
JOIN dim_calendar 
    ON fact_order_lines.order_date = dim_calendar.cal_date
GROUP BY dim_calendar.year, fact_order_lines.region
    )

SELECT 
    year, 
    region, 
    total_orders, 
    returned_orders, 
    (returned_orders/total_orders)*100 AS return_rate
FROM regional_returns
ORDER BY year ASC, region ASC;


-- Q5 - sales and profitability by customer segment
-- How did customer segments compare in sales and profitability?


SELECT 
    dim_customer.segment AS segment,
    SUM(fact_order_lines.sales) AS total_sales, 
    SUM(fact_order_lines.profit) AS total_profit, 
    (SUM(fact_order_lines.profit)/SUM(fact_order_lines.sales)*100) AS profit_margin
FROM fact_order_lines
JOIN dim_customer
    ON fact_order_lines.customer_id = dim_customer.customer_id 
GROUP BY dim_customer.segment
ORDER BY total_sales DESC; 


-- Q6 - Profit margin and discount by sub-category within furniture
-- Within Furniture, how did profit margin vary by discount level and sub-category?


SELECT 
    dim_product.sub_category AS sub_category, 
    ((fact_order_lines.discount)*100) AS discount, 
    (SUM(fact_order_lines.profit)/SUM(fact_order_lines.sales)*100) AS profit_margin
FROM fact_order_lines
JOIN dim_product
    ON fact_order_lines.product_key = dim_product.product_key
WHERE dim_product.category = 'Furniture'
GROUP BY dim_product.sub_category, fact_order_lines.discount
ORDER BY discount ASC, sub_category ASC; 