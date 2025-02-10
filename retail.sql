create database retail;
use retail;

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10 , 2 ),
    stock_quantity INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10 , 2 ),
    status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id)
        REFERENCES Customers (customer_id)
        ON DELETE CASCADE
);

drop table customers;
drop table products;
drop table orders;
drop table order_items;

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10 , 2 ) NOT NULL,
    stock_quantity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    total_price DECIMAL(10 , 2 ) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id)
        REFERENCES Customers (customer_id)
        ON DELETE CASCADE,
    FOREIGN KEY (product_id)
        REFERENCES Products (product_id)
        ON DELETE CASCADE
);

INSERT INTO Customers (first_name, last_name, email, phone)
VALUES 
('John', 'Doe', 'john@example.com', '9876543210'),
('Alice', 'Smith', 'alice@example.com', '9876543211'),
('Bob', 'Johnson', 'bob@example.com', '9876543212');

INSERT INTO Products (product_name, category, price, stock_quantity)
VALUES 
('iPhone 15', 'Electronics', 999.99, 50),
('MacBook Pro', 'Laptops', 1999.99, 30),
('Sony Headphones', 'Accessories', 149.99, 100);

INSERT INTO Orders (customer_id, product_id, quantity, status)
VALUES 
(1, 1, 2, 'Shipped'),   -- John bought 2 iPhones
(2, 2, 1, 'Pending'),   -- Alice bought 1 MacBook
(3, 3, 3, 'Delivered');-- Bob bought 3 Sony Headphones


DESC Customers;
SELECT 
    *
FROM
    customers;

-- Fetch All Orders with Customer & Product Details
SELECT 
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    p.product_name AS product_name,
    o.quantity,
    o.total_price,
    o.order_date,
    o.status
FROM
    Orders o
        JOIN
    Customers c ON o.customer_id = c.customer_id
        JOIN
    Products p ON o.product_id = p.product_id
ORDER BY o.order_date DESC
LIMIT 1000;


-- Calculate total revenue from all completed (Shipped or Delivered) orders
SELECT 
    SUM(o.quantity * p.price) AS total_revenue
FROM
    Orders o
        JOIN
    Products p ON o.product_id = p.product_id;


-- Find the Most Purchased Product
SELECT 
    p.product_name, SUM(o.quantity) AS total_sold
FROM
    Orders o
        JOIN
    Products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 1;


-- Count Orders by Status
SELECT 
    status, COUNT(*) AS order_count
FROM
    Orders
GROUP BY status;


-- Find Customers Who Have Ordered More Than Once
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.order_id) AS total_orders
FROM
    Orders o
        JOIN
    Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING COUNT(o.order_id) > 1;


-- This procedure will insert a new order and automatically update the stock quantity.
DELIMITER //

CREATE PROCEDURE PlaceOrder(
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE p_price DECIMAL(10,2);
    DECLARE p_stock INT;
    
    -- Get product price and stock quantity
    SELECT price, stock_quantity INTO p_price, p_stock
    FROM Products WHERE product_id = p_product_id;

    -- Check if enough stock is available
    IF p_stock >= p_quantity THEN
        -- Insert order
        INSERT INTO Orders (customer_id, product_id, quantity, status) 
        VALUES (p_customer_id, p_product_id, p_quantity, 'Pending');

        -- Reduce stock
        UPDATE Products SET stock_quantity = stock_quantity - p_quantity 
        WHERE product_id = p_product_id;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Not enough stock available';
    END IF;
END //

DELIMITER ;

CALL PlaceOrder(1, 1, 3);-- John Doe orders 3 iPhones

SELECT 
    *
FROM
    orders;

SELECT 
    *
FROM
    Orders
ORDER BY order_date DESC;

-- This trigger prevents a product from going below zero stock.
DELIMITER //

CREATE TRIGGER PreventNegativeStock
BEFORE UPDATE ON Products
FOR EACH ROW
BEGIN
    IF NEW.stock_quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock cannot be negative!';
    END IF;
END //

DELIMITER ;

UPDATE Products 
SET 
    stock_quantity = - 5
WHERE
    product_id = 1;-- This will fail

CREATE VIEW OrderSummary AS
    SELECT 
        o.order_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        p.product_name,
        o.quantity,
        (o.quantity * p.price) AS total_price,
        o.status,
        o.order_date
    FROM
        Orders o
            JOIN
        Customers c ON o.customer_id = c.customer_id
            JOIN
        Products p ON o.product_id = p.product_id;

SELECT 
    *
FROM
    OrderSummary; -- view

show tables;

SELECT 
    *
FROM
    Customers;
SELECT 
    *
FROM
    Products;
SELECT 
    *
FROM
    Orders;

SHOW PROCEDURE STATUS WHERE Db = 'retail';

SHOW TRIGGERS;

SHOW FULL TABLES IN retail WHERE TABLE_TYPE LIKE 'VIEW';


