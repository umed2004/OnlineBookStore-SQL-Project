-- Create Database
CREATE DATABASE OnlineBookStore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

---IMPORT QUERY FOR BOOKS
COPY
Books(Book_Id,Title,Author,Genre,Published_Year,Price,Stock)
FROM 'D:\All Excel Practice Files\Books.csv'
CSV HEADER;

--IMPORT QUERY FOR CUSTOMERS
COPY 
Customers(Customer_Id,Name,Email,Phone,City,Country)
FROM 'D:\All Excel Practice Files\Customers.csv'
CSV HEADER;

--IMPORT QUERY FOR ORDERS
COPY 
Orders(Order_Id,Customer_Id,Book_Id,Order_Date,Quantity,Total_Amount)
FROM 'D:\All Excel Practice Files\Orders.csv'
CSV HEADER;

-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM Books WHERE genre='Fiction';


-- 2) Find books published after the year 1950:
SELECT * FROM Books WHERE published_year>1950 ORDER BY published_year ASC;

-- 3) List all customers from the Canada:
SELECT * FROM Customers WHERE country='Canada';


-- 4) Show orders placed in November 2023:
SELECT * FROM Orders WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT SUM(stock) AS total_stock FROM Books;

-- 6) Find the details of the most expensive book:
SELECT *  FROM Books ORDER BY price DESC LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders WHERE quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders WHERE total_amount>20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT genre FROM Books;

-- 10) Find the book with the lowest stock:
SELECT * FROM Books ORDER BY stock  LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) AS total_revenue FROM Orders;


-- Advance Questions : 
-- 1) Retrieve the total number of books sold for each genre:
SELECT DISTINCT Genre FROM Books;

SELECT 
b.Genre , SUM(o.Quantity) AS total_book_sold
FROM Books b JOIN Orders o 
ON b.Book_Id=o.Book_Id
GROUP BY b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT * FROM Books;
SELECT AVG(price) FROM Books WHERE Genre='Fantasy';

-- 3) List customers who have placed at least 2 orders:
SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT o.Customer_Id ,c.name ,COUNT(o.Order_Id) 
FROM Orders o JOIN Customers c
ON o.Customer_Id=c.Customer_Id
GROUP BY o.Customer_Id ,c.Customer_Id
HAVING COUNT(Order_ID)>=2;

-- 4) Find the most frequently ordered book:

SELECT o.Book_Id ,b.title, COUNT(o.Order_Id) AS Total_Count
FROM Orders o JOIN Books b
ON b.Book_Id = o.Book_Id
GROUP BY o.Book_Id,b.title
ORDER BY Total_Count DESC LIMIT 1 ;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM Books;
SELECT * FROM Books WHERE genre='Fantasy' ORDER BY price DESC LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT * FROM Orders;
SELECT b.author,SUM(o.quantity) AS Total_Quanity_Sold
FROM Books b JOIN Orders o
ON b.Book_Id=o.Book_Id
GROUP BY b.author ;

-- 7) List the cities where customers who spent over $30 are located:
SELECT * FROM Customers;
SELECT c.city,o.total_amount
FROM Customers c JOIN Orders o
ON c.Customer_Id=o.Customer_Id
GROUP BY c.City,o.total_amount
HAVING (o.total_amount)>30;

-- 8) Find the customer who spent the most on orders:

SELECT o.Customer_Id,c.name,SUM(o.total_amount) AS most_Spent
FROM Orders o JOIN Customers c 
ON c.Customer_Id = o.Customer_Id
GROUP BY c.name,o.Customer_Id
ORDER BY most_spent DESC LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id , b.title, b.stock , COALESCE(SUM(o.quantity),0) AS Order_quantity ,
b.stock-COALESCE(SUM(o.quantity),0) AS remaining_quantity
FROM Books b LEFT JOIN Orders o 
ON b.Book_Id=o.Book_Id
GROUP BY b.book_id
ORDER BY Book_Id ASC;
