-- Create Database
CREATE DATABASE IF NOT EXISTS OnlineBookstore;
USE OnlineBookstore;

-- Drop existing tables (if any)
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Books;

-- Create Tables
CREATE TABLE Books (
    Book_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price DECIMAL(10, 2),
    Stock INT
);

CREATE TABLE Customers (
    Customer_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Orders (
    Order_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_ID INT,
    Book_ID INT,
    Order_Date DATE,
    Quantity INT,
    Total_Amount DECIMAL(10, 2),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID)
);

-- View the tables
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Import data ;
-- Have imported data with the right click and import wizard by browsing it. 

-- Queries and their solutions:

-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM books
WHERE genre='Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM books
WHERE Published_Year > 1950
ORDER BY Published_Year ASC;

-- 3) List all customers from Canada:
SELECT * FROM customers
WHERE country='Canada';

-- 4) Show orders placed in November 2023:
-- SELECT * FROM orders
-- WHERE order_date FROM 2023-11-01 TO 2023-11-31;
SELECT * FROM orders
WHERE month(order_date)=11
AND
year(order_date)=2023
ORDER BY order_date ASC;

SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
-- aggregate function
SELECT SUM(stock) AS total_stock 
FROM books; 

-- 6) Find the details of the most expensive book:
SELECT * FROM books order by price DESC;
SELECT * FROM books order by price DESC LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM orders
WHERE quantity >1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM orders
WHERE Total_Amount >1;

-- 9) List all genres available in the Books table:
SELECT DISTINCT genre from books;
-- SELECT * DISTINCT genre from books;

-- 10) Find the book with the lowest stock:
SELECT * FROM books 
ORDER BY stock
limit 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(Total_Amount) AS Revenue FROM orders;

-- ADVANCED QUESTIONS

-- 1) Retrieve the total number of books sold for each genre:
SELECT b.genre, o.quantity
FROM books b
JOIN orders o ON b.book_id=o.book_id;

SELECT b.genre, o.quantity
FROM books b
JOIN orders o ON b.book_id=o.book_id
ORDER BY genre;

SELECT b.genre, SUM(o.quantity) AS Total_num_booksold
FROM books b
JOIN orders o ON b.book_id=o.book_id
GROUP BY genre;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT AVG(price) AS Average_Price
FROM books
WHERE genre='Fantasy';

-- 3) List customers who have placed at least 2 orders:
SELECT c.Name, COUNT(o.Order_ID) AS Total_Orders
FROM customers c
JOIN orders o ON c.Customer_ID=o.Customer_ID
GROUP BY c.Customer_ID, c.name
HAVING COUNT(o.Order_ID)>=2;  -- own

SELECT Customer_ID, COUNT(Order_ID) AS Total_Count
FROM Orders
GROUP BY Customer_ID
HAVING COUNT(Order_ID)>=2;

SELECT o.Customer_ID, c.Name, COUNT(o.Order_ID) AS Total_Count
FROM Orders o
JOIN Customers c ON c.Customer_ID=o.Customer_ID
GROUP BY Customer_ID
HAVING COUNT(Order_ID)>=2;

SELECT o.Customer_ID, c.Name, COUNT(o.Order_ID) AS Total_Count
FROM Orders o
JOIN Customers c ON c.Customer_ID=o.Customer_ID
GROUP BY Customer_ID, c.Name
HAVING COUNT(Order_ID)>=2; -- this is more correct


-- 4) Find the most frequently ordered book:
SELECT Book_ID, COUNT(Book_ID) AS TOTAL_COUNT
FROM orders
GROUP BY Book_ID
ORDER BY TOTAL_COUNT DESC;                      -- this was without adding the name

SELECT b.Book_ID, b.Title, COUNT(b.Book_ID) AS TOTAL_COUNT
FROM orders o
JOIN books b ON b.BOOK_ID=o.BOOK_ID
GROUP BY Book_ID, b.Title
ORDER BY TOTAL_COUNT DESC;    

SELECT o.Book_ID, b.Title, COUNT(o.Book_ID) AS TOTAL_COUNT
FROM orders o
JOIN books b ON b.BOOK_ID=o.BOOK_ID
GROUP BY Book_ID, b.Title
ORDER BY TOTAL_COUNT DESC; 

SELECT o.Book_ID, b.Title, COUNT(o.Book_ID) AS TOTAL_COUNT
FROM orders o
JOIN books b ON b.BOOK_ID=o.BOOK_ID
GROUP BY o.Book_ID, b.Title
ORDER BY TOTAL_COUNT DESC;

SELECT o.Book_ID, b.Title, COUNT(o.Book_ID) AS TOTAL_COUNT
FROM orders o
JOIN books b ON b.BOOK_ID=o.BOOK_ID
GROUP BY o.Book_ID, b.Title
ORDER BY TOTAL_COUNT DESC LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre:
SELECT * FROM books
WHERE genre='Fantasy'
GROUP BY price DESC LIMIT 3;  -- it should be order by not group by

SELECT * FROM books
WHERE genre='Fantasy'
ORDER BY price DESC LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT b.Author, SUM(o.Quantity) AS Total_Quantity
FROM orders o
JOIN books b ON b.BOOK_ID=o.BOOK_ID
GROUP BY b.Author
ORDER BY Total_Quantity;

SELECT b.Author, SUM(o.Quantity) AS Total_Quantity
FROM orders o
JOIN books b ON b.BOOK_ID=o.BOOK_ID
GROUP BY o.BOOK_ID
ORDER BY Total_Quantity;

SELECT  SUM(o.Quantity) AS Total_Quantity
FROM orders o
JOIN books b ON b.BOOK_ID=o.BOOK_ID
GROUP BY o.BOOK_ID
ORDER BY Total_Quantity;

SELECT b.Author, SUM(o.Quantity) AS Total_Quantity
FROM orders o
JOIN books b ON b.BOOK_ID=o.BOOK_ID
GROUP BY o.BOOK_ID, b.Author
ORDER BY Total_Quantity;

SELECT b.Author, SUM(o.Quantity) AS Total_Quantity
FROM orders o
JOIN books b ON b.BOOK_ID=o.BOOK_ID
GROUP BY o.BOOK_ID, b.Author; -- taught

-- 7) List the cities where customers who spent over $30 are located:
SELECT c.City, SUM(o.TOTAL_AMOUNT) AS Total_Spent
FROM customers c
JOIN orders o ON c.CUSTOMER_ID=o.CUSTOMER_ID
GROUP BY c.City
ORDER BY TOTAL_SPENT;

SELECT c.City, SUM(o.TOTAL_AMOUNT) AS Total_Spent
FROM customers c
JOIN orders o ON c.CUSTOMER_ID=o.CUSTOMER_ID
GROUP BY c.City, c.CUSTOMER_ID
HAVING SUM(o.TOTAL_AMOUNT)>30;             -- right

SELECT c.City, SUM(o.TOTAL_AMOUNT>30) AS Total_Spent
FROM customers c
JOIN orders o ON c.CUSTOMER_ID=o.CUSTOMER_ID
GROUP BY c.City, c.CUSTOMER_ID;              -- not giving the right answer


SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN Customers c ON c.CUSTOMER_ID=o.CUSTOMER_ID
WHERE total_amount>30;

-- 8) Find the customer who spent the most on orders:
SELECT c.Name, c.CUSTOMER_ID, SUM(TOTAL_AMOUNT) AS SPENT_AMOUNT
FROM orders o
JOIN customers c ON o.CUSTOMER_ID=c.CUSTOMER_ID
GROUP BY c.Name, c.Customer_ID
ORDER BY SPENT_AMOUNT DESC;

SELECT c.Name, c.CUSTOMER_ID, SUM(TOTAL_AMOUNT) AS SPENT_AMOUNT
FROM orders o
JOIN customers c ON o.CUSTOMER_ID=c.CUSTOMER_ID
GROUP BY c.Name, c.Customer_ID
ORDER BY SPENT_AMOUNT DESC LIMIT 1;

-- 9) Calculate the stock remaining after fulfilling all orders:
SELECT b.BOOK_ID, b.TITLE, b.STOCK, COALESCE (SUM(o.quantity),0) AS order_quantity,
b.stock-COALESCE(SUM(o.quantity),0) AS remaining_quantity
FROM books b
LEFT JOIN orders o ON b.BOOK_ID=o.BOOK_ID
GROUP BY b.BOOK_ID;