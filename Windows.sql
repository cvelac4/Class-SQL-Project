create database test;
USE test;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS employees, sales, orders;

-- Create employees table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department_id INT,
    salary DECIMAL(10, 2)
);

-- Insert data into employees
INSERT INTO employees (emp_id, emp_name, department_id, salary) VALUES
(1, 'Alinor', 101, 75000),
(2, 'Pedro', 101, 50000),
(3, 'Alex', 102, 90000),
(4, 'Diana', 102, 80000),
(5, 'zavier', 103, 60000);

-- Create sales table
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    emp_id INT,
    sale_amount DECIMAL(10, 2),
    sale_date DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

-- Insert data into sales
INSERT INTO sales (sale_id, emp_id, sale_amount, sale_date) VALUES
(1, 1, 1000, '2024-01-01'),
(2, 1, 2000, '2024-01-02'),
(3, 2, 1500, '2024-01-01'),
(4, 3, 3000, '2024-01-03'),
(5, 4, 1200, '2024-01-01'),
(6, 5, 1800, '2024-01-02');

-- Create orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    order_amount DECIMAL(10, 2)
);

-- Insert data into orders
INSERT INTO orders (order_id, order_date, order_amount) VALUES
(1, '2024-01-01', 500),
(2, '2024-01-02', 800),
(3, '2024-01-03', 700),
(4, '2024-01-04', 1000),
(5, '2024-01-05', 600);

-- Find total sales by each employee
SELECT emp_name, sale_date, sale_amount,
SUM(sale_amount) OVER (PARTITION BY emp_name ORDER BY sale_date) as Running_Total_sales,
SUM(sale_amount) OVER (PARTITION BY emp_name) as Totale_sales 
FROM sales
JOIN employees
ON
sales.emp_id = employees.emp_id; 

-- Ranking of employee by their total sales amount
SELECT emp_name, SUM(sale_amount) as Total_Sales,
RANK() OVER(ORDER BY SUM(sale_amount) DESC) as Sales_Rank
FROM sales
JOIN employees
ON sales.emp_id = employees.emp_id
GROUP BY emp_name;

-- Highest Sales of Each Employee
SELECT emp_name, Max(sale_amount)
OVER (PARTITION BY emp_name) as Highest_Sale
FROM sales 
JOIN employees 
ON sales.emp_id = employees.emp_id; 

