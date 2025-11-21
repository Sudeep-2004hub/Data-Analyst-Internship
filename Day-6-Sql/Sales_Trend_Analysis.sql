SELECT 
    EXTRACT(YEAR FROM order_date) AS sales_year,
    EXTRACT(MONTH FROM order_date) AS sales_month,
    SUM(amount) AS total_revenue
FROM data.online_sales_data
GROUP BY 
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date)
ORDER BY 
    sales_year,
    sales_month;
    
    
    SELECT 
    EXTRACT(YEAR FROM order_date) AS sales_year,
    EXTRACT(MONTH FROM order_date) AS sales_month,
    SUM(amount) AS total_revenue,
    COUNT(DISTINCT product_id) AS total_orders
FROM data.online_sales_data
GROUP BY 
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date)
ORDER BY 
    sales_year,
    sales_month;

SELECT 
    EXTRACT(YEAR FROM order_date) AS sales_year,
    EXTRACT(MONTH FROM order_date) AS sales_month,
    SUM(amount) AS total_revenue,
    COUNT(DISTINCT product_id) AS total_orders
FROM data.online_sales_data
WHERE EXTRACT(YEAR FROM order_date) = 2024
GROUP BY 
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date)
ORDER BY 
    sales_month;


SELECT 
    EXTRACT(YEAR FROM order_date) AS sales_year,
    EXTRACT(MONTH FROM order_date) AS sales_month,
    SUM(amount) AS total_revenue,
    COUNT(DISTINCT product_id ) AS total_orders
FROM data.online_sales_data
WHERE order_date BETWEEN '2024-01-01' AND '2024-06-30'
GROUP BY 
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date)
ORDER BY 
    sales_year,
    sales_month;
