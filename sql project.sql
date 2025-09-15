create database onlinebookstore;

drop table if exists onlinebookstore.books;
create table onlinebookstore.books (
Book_ID	int not null auto_increment,
Title varchar(100),	
Author varchar(100),
Genre varchar(50),	
Published_Year	int,
Price	numeric(10,2),
Stock int,
primary key (Book_ID) );

create table onlinebookstore.customer (
Customer_ID	 int not null auto_increment,
Name	varchar(100),
Email	varchar(100),
Phone	varchar(15),
City	varchar(50),
Country varchar(50),
primary key(Customer_ID) );

CREATE TABLE onlinebookstore.orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT,
    Book_ID INT,
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10,2),
    CONSTRAINT fk_cid FOREIGN KEY (Customer_ID) REFERENCES  onlinebookstore.customer(Customer_ID),
    CONSTRAINT fk_bid FOREIGN KEY (Book_ID) REFERENCES  onlinebookstore.books(Book_ID)
);




#retrieve all books in the "fiction" genre:
select * from onlinebookstore.books WHERE
Genre='fiction';

# find book published after the year 1950:
SELECT * FROM onlinebookstore.books
WHERE `Published_Year`>1950;

# list all customer from canada:
SELECT * FROM onlinebookstore.customer
WHERE `Country`='canada';

# show orders placed in nov 2023:
SELECT * FROM onlinebookstore.orders
WHERE `Order_Date` BETWEEN '2023-11-01' and '2023-11-30';

# retrieve the total stock of books available:
SELECT sum(stock) as total_stock FROM onlinebookstore.books;

# find the detail of most expensive book:
SELECT * from onlinebookstore.books
ORDER BY price desc ;

SELECT * from onlinebookstore.books
ORDER BY price desc limit 1;

SELECT * from onlinebookstore.orders
ORDER BY `Quantity` desc limit 10;

# show all customers who ordered more than 1 quantity of a book:
SELECT * from onlinebookstore.orders
where `Quantity`>1;

# retrieve all orders where the total amount exceeds 20:
SELECT * from onlinebookstore.orders
where `Total_Amount`>20;

# list all genres available in the books table:
select DISTINCT genre from onlinebookstore.books;

# find the book with the 5 lowest stock:
select * from onlinebookstore.books
ORDER BY `Stock` limit 5;

# calculate the total revenue generate from all orders:
select sum(total_amount) as revenue FROM onlinebookstore.orders;

# retrieve the total number of books sold for each genre;
select b.genre, o.quantity FROM onlinebookstore.orders o
JOIN books b ON o.`Book_ID`=b.`Book_ID`;

select b.genre, sum(o.quantity) as total_books_sold
FROM onlinebookstore.orders o       
JOIN books b  ON o.`Book_ID`= b.`Book_ID`
GROUP BY b.genre;

# find the average price of book in the fantasy genre: 
select AVG(price) as average_price
from onlinebookstore.books
where `Genre`='fantasy';

# list customer who have placed at least 2 orders:
select customer_id, COUNT(order_id) as order_count
from onlinebookstore.orders
GROUP BY `Customer_ID`
HAVING COUNT(`Order_ID`)>=2;

select o.customer_id, c.`Name`, COUNT(o.order_id) as order_count
from onlinebookstore.orders o
JOIN onlinebookstore.customer c ON o.`Customer_ID`=c.`Customer_ID`
GROUP BY o.`Customer_ID`, c.`Name`
HAVING COUNT(`Order_ID`)>=2;

# find the most frequently ordered book:
SELECT book_id, count(order_id) as order_count
from onlinebookstore.orders
GROUP BY `Book_ID`
ORDER BY order_count desc ;

SELECT o.book_id, b.title , count(o.order_id) as order_count
from onlinebookstore.orders o
JOIN onlinebookstore.books b ON o.`Book_ID`=b.`Book_ID`
GROUP BY o.`Book_ID`, b.`Title`
ORDER BY order_count desc ;

#show the top 3 most expensive book of fantasy genre:
SELECT* FROM onlinebookstore.books
WHERE `Genre`='fantasy'
ORDER BY `Price` desc LIMIT 3;

# retrieve the total quantity of book sold by each author:
select b.`Author`, sum(o.quantity) as total_books_sold
from onlinebookstore.orders o
join onlinebookstore.books b ON b.`Book_ID`=o.`Book_ID`
GROUP BY b.`Author`; 

#list the cities where customer who spend over 300:
select DISTINCT c.city ,`Total_Amount`
from onlinebookstore.orders o
join onlinebookstore.customer c ON o.`Customer_ID`=c.`Customer_ID`
WHERE o.total_amount>300;

# find the customer who spend the most on order:
SELECT c.customer_id, c.Name, sum(o.total_amount) as total_spend
FROM onlinebookstore.orders o
JOIN onlinebookstore.customer c ON o.`Customer_ID`=c.`Customer_ID`
GROUP BY c.`Customer_ID`,c.`Name`
ORDER BY total_spend desc;