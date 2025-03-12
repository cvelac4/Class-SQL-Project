Use test;

-- Create Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50)
);

-- Insert Data into Customers
INSERT INTO customers VALUES
(1, 'Alinor Johnson', 'alinor@example.com', 'New York'),
(2, 'Angel Perry', 'perry@example.com', 'Los Angeles'),
(3, 'Ceaser Smith', 'ceaser@example.com', 'Chicago');

-- Create Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

-- Insert Data into Products
INSERT INTO products VALUES
(101, 'Laptop', 1200.00),
(102, 'Phone', 800.00),
(103, 'Tablet', 600.00);

-- Create Orderss Table
CREATE TABLE orderss (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Insert Data into Orders
INSERT INTO orderss VALUES
(1001, 1, '2024-02-01'),
(1002, 2, '2024-02-02'),
(1003, 1, '2024-02-05');

-- Create Order_Items Table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orderss(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert Data into Order_Items
INSERT INTO order_items VALUES
(1, 1001, 101, 1),
(2, 1001, 102, 2),
(3, 1002, 103, 1),
(4, 1003, 101, 1),
(5, 1003, 103, 2);

-- Create Payments Table
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    FOREIGN KEY (order_id) REFERENCES orderss(order_id)
);

-- Insert Data into Payments
INSERT INTO payments VALUES
(5001, 1001, 2800.00, '2024-02-02'),
(5002, 1002, 600.00, '2024-02-03'),
(5003, 1003, 1800.00, '2024-02-06');

-- Get Customers with their orders
WITH Customerorders AS(
select c.customer_id, c.name, count(o.order_id) AS Total_Orders
FROM customer c
LEFT JOIN orderss o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
)
SELECT * FROM Customerorders;

-- Total sales on each product
WITH ProductSales AS(
SELECT oi.product_id, p.product_name, SUM(oi.quantity) AS Total_Sold
FROM order_items oi
JOIN product p
ON oi.product_id = p.product_id
GROUP BY oi.product_id, p.product_name
)

SELECT * FROM ProductSales;

-- Total Revenue per Customers(Customers, orders, and Payments)
WITH CustomerRevenue AS(
SELECT o.customer_id, c.name, SUM(p.amount) AS Total_Spent
FROM orderss o
JOIN payments p ON o.order_id = p.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.name
)
SELECT * FROM CustomerRevenue; 

-- Get Orders with Payment Status
WITH PaymentStatus AS(
SELECT p.order_id, c.name, SUM(o.amount) AS Total_Payment
FROM payments p
JOIN orders o ON  p.payment_id = o.payment_id
GROUP BY p.order_id
)

SELECT * FROM PaymentStatus; 

-- Check High-Spending Customers (Above 1000)
WITH HighSpender AS(
SELECT o.customer_id, c.name, SUM(p.amount) AS Total_Spending
FROM payments p
JOIN orders o ON p.payment_id = o.payment_id
JOIN customers c ON p.customer_id = c.customer_id
GROUP BY p.customer_id, c.name
)

SELECT * FROM HighSpender; 