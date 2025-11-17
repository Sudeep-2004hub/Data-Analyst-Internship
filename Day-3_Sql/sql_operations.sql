USE ecommerce1;
SELECT * FROM online_retail LIMIT 20;

-- sample rows
SELECT customer_id, order_date, product_id, product_name, quantity, price, city
FROM online_retail;


-- orders in West Sarahin 2025 sorted by amount desc (amount = quantity * price)
SELECT customer_id, order_date, product_id, product_name,
       quantity, price, (quantity * price) AS order_amount, city, payment_method
FROM online_retail
WHERE city = 'West Sarah' AND order_date >= '2025-01-01' AND order_date < '2026-01-01'
ORDER BY order_amount DESC
LIMIT 50;

-- revenue & avg order size by city
SELECT city,
       COUNT(*) AS orders,
       SUM(quantity * price) AS revenue,
       AVG(quantity * price) AS avg_order_amount
FROM online_retail
GROUP BY city
ORDER BY revenue DESC;


USE ecommerce1;

-- DROP if exists for idempotency (optional)
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS order_items;

-- customers
CREATE TABLE customers AS
SELECT DISTINCT customer_id, gender, age, city
FROM online_retail
WHERE customer_id IS NOT NULL;
ALTER TABLE customers ADD PRIMARY KEY (customer_id);

-- categories
CREATE TABLE categories AS
SELECT DISTINCT category_id, category_name
FROM online_retail;
ALTER TABLE categories ADD PRIMARY KEY (category_id);

-- products (one row per product)
CREATE TABLE products AS
SELECT DISTINCT product_id, product_name, category_id
FROM online_retail;
ALTER TABLE products ADD PRIMARY KEY (product_id);

-- orders (one row per order)
CREATE TABLE orders AS
SELECT DISTINCT CONCAT(customer_id,'_',DATE_FORMAT(order_date,'%Y%m%d%H%i%s')) AS order_id,
       customer_id, order_date, payment_method
FROM online_retail;
-- if dataset has unique order ids, replace above with that
ALTER TABLE orders ADD PRIMARY KEY (order_id);

-- order_items (detailed)
CREATE TABLE order_items AS
SELECT customer_id, order_date, product_id, category_id, quantity, price, payment_method
FROM online_retail;
ALTER TABLE order_items ADD id INT AUTO_INCREMENT PRIMARY KEY FIRST;

-- INNER JOIN: orders with customer demographic
SELECT o.order_id, o.order_date, o.payment_method,
       c.customer_id, c.gender, c.age, c.city
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC;


-- LEFT JOIN: list all products and whether they were sold
SELECT p.product_id, p.product_name, cat.category_name, SUM(oi.quantity) AS total_sold
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN categories cat ON p.category_id = cat.category_id
GROUP BY p.product_id, p.product_name, cat.category_name
ORDER BY total_sold DESC;

-- IN: orders that include any product from category_id = 10
SELECT DISTINCT customer_id, order_date
FROM online_retail
WHERE product_id IN (
  SELECT product_id FROM online_retail WHERE category_id = 10
);

-- EXISTS: customers who gave a 5-star review
SELECT DISTINCT customer_id
FROM online_retail r
WHERE EXISTS (
  SELECT 1 FROM online_retail x WHERE x.customer_id = r.customer_id AND x.review_score = 5
);

-- Correlated: orders where order amount > customer's average order amount
SELECT r.customer_id, r.order_date, (r.quantity * r.price) AS order_amount
FROM online_retail r
WHERE (r.quantity * r.price) > (
  SELECT AVG(quantity * price) FROM online_retail x WHERE x.customer_id = r.customer_id
);

-- overall metrics
SELECT COUNT(*) AS total_rows,
       SUM(quantity * price) AS total_revenue,
       AVG(quantity * price) AS avg_order_amount,
       MIN(quantity * price) AS min_order_amount,
       MAX(quantity * price) AS max_order_amount
FROM online_retail;

-- customers with > 5 purchases and lifetime value
SELECT customer_id,
       COUNT(*) AS orders,
       SUM(quantity * price) AS ltv,
       AVG(quantity * price) AS avg_order
FROM online_retail
GROUP BY customer_id
HAVING COUNT(*) > 5
ORDER BY ltv DESC;

-- revenue and avg review by category
SELECT category_id, category_name,
       SUM(quantity * price) AS revenue,
       AVG(review_score) AS avg_review,
       COUNT(DISTINCT product_id) AS unique_products
FROM online_retail
GROUP BY category_id, category_name
ORDER BY revenue DESC;

-- view: order_level (if each row is a line-item, group to order)
CREATE OR REPLACE VIEW vw_order_level AS
SELECT customer_id, order_date,
       SUM(quantity * price) AS order_total,
       COUNT(*) AS line_items,
       MAX(payment_method) AS payment_method
FROM online_retail
GROUP BY customer_id, order_date;

-- Use the view: top orders
SELECT * FROM vw_order_level
ORDER BY order_total DESC
LIMIT 500;
-- view: customer_ltv
CREATE OR REPLACE VIEW vw_customer_ltv AS
SELECT customer_id,
       COUNT(*) AS orders_count,
       SUM(quantity * price) AS lifetime_value,
       AVG(quantity * price) AS avg_order_value,
       AVG(review_score) AS avg_review_score
FROM online_retail
GROUP BY customer_id;

SELECT * FROM vw_customer_ltv
ORDER BY lifetime_value DESC
LIMIT 500;


-- Single-column indexes
CREATE INDEX idx_customer ON online_retail (customer_id);
CREATE INDEX idx_orderdate ON online_retail (order_date);
CREATE INDEX idx_product ON online_retail (product_id);
CREATE INDEX idx_category ON online_retail (category_id);
CREATE INDEX idx_city ON online_retail (city);
CREATE INDEX idx_payment ON online_retail (payment_method);











