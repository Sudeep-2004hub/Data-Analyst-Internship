📌 Online Retail SQL Analysis — README
📄 Project Overview
This project uses an e-commerce retail dataset containing customer, product, and order information.
The dataset was stored in MySQL and analyzed using various SQL concepts including:

SELECT, WHERE, ORDER BY, GROUP BY
JOINS (INNER, LEFT, RIGHT)
Subqueries (IN, EXISTS, Correlated)
Aggregate Functions (SUM, AVG, COUNT, MIN, MAX)
Views for analytical reporting
Index creation for performance optimization
The goal is to demonstrate real-world data analysis and database design skills by transforming a flat dataset into a structured relational schema and performing business insights queries.

🗂️ Database Structure
Database name: ecommerce1
Raw table: online_retail

✔ Normalized tables created:
customers → customer_id, gender, age, city
products → product_id, product_name, category_id
categories → category_id, category_name
orders → generated order_id, customer_id, order_date, payment_method
order_items → product-level details for each order

🛠️ Tools Used

MySQL 8+
Kaggle dataset: Online Retail (1000 rows)
Workbench / CLI for running queries
