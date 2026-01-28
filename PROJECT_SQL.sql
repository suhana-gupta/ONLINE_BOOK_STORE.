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
-- 1) Retrieve all books in the "Fiction" genre:
select * from Books
where genre='Fiction';
-- 2) Find books published after the year 1950:
select*from Books
where published_year=1950;
-- 4) Show orders placed in November 2023:
select* from Orders
where order_date BETWEEN '2023-11-01' AND '2023-11-30';
-- 5) Retrieve the total stock of books available:
SELECT sum(stock) as books_available
from Books;
-- 6) Find the details of the most expensive book:
select *from Books
order BY price DESC
LIMIT 5;
-- 7) Show all customers who ordered more than 1 quantity of a book:
select*from Orders
where quantity>1;
-- 8) Retrieve all orders where the total amount exceeds $20:
select *from Orders where total_amount>20;
-- 9) List all genres available in the Books table:

select distinct genre from Books;
-- 10) Find the book with the lowest stock:
select *from Books order by stock limit 1;
-- 11) Calculate the total revenue generated from all orders:
select  sum(total_amount)as revenue from Orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

SELECT * FROM ORDERS;
select b.genre,sum(o.quantity) as total_sales
from orders o
join books b on b.book_id=o.book_id
group by  b.genre;

-- 2) Find the average price of books in the "Fantasy" genre:

SELECT
	AVG(PRICE) AS AVERAGE_PRICE
FROM
	BOOKS
WHERE
	GENRE = 'fantasy';
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 3) List customers who have placed at least 2 orders:

select o.customer_id,c.name,count(o.orders_id) as placed_order
from orders o
join customers c on o.customer_id=c.customer_id group by o.customer_id,c.name
having count(order_id)>=2;

---4) Find the most frequently ordered book:

select o.book_id,b.title,count(o.order_id)as order_count
from orders o
join books b on o.book_id=b.book_id
group by o.book_id,b.title order by order_count
desc limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT
	*
FROM
	BOOKS
WHERE
	GENRE = 'Fantasy'
ORDER BY
	PRICE DESC
LIMIT
	3;

-- 6) Retrieve the total quantity of books sold by each author:
select b.author,sum(o.quantity)as book_sold_author
from books b 
join orders o on b.book_id=o.book_id
group by b.author;
-- 7) List the cities where customers who spent over $30 are located:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;


--9) Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;

