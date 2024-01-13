-- Assignment 1

/*
-- About our Database: 
Given a database ORG of an Ecommerce store with four tables: Customers, Products, Orders, 
and OrderDetails. This database is designed to manage information related to customers, 
products, and orders, and it establishes relationships between these entities.
*/

CREATE DATABASE ORG;
USE ORG;

CREATE TABLE Customers (
CustomerID INT PRIMARY KEY,
Name VARCHAR(255),
Email VARCHAR(255),
JoinDate DATE
);
CREATE TABLE Products (
ProductID INT PRIMARY KEY,
Name VARCHAR(255),
Category VARCHAR(255),
Price DECIMAL(10, 2)
);
CREATE TABLE Orders (
OrderID INT PRIMARY KEY,
CustomerID INT,
OrderDate DATE,
TotalAmount DECIMAL(10, 2),
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE OrderDetails (
OrderDetailID INT PRIMARY KEY,
OrderID INT,
ProductID INT,
Quantity INT,
PricePerUnit DECIMAL(10, 2),
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Inserting Values

INSERT INTO Customers (CustomerID, Name, Email, JoinDate) VALUES
(1, 'Alice Johnson', 'alice.j@example.com', '2021-01-05'),
(2, 'Bob Smith', 'bob.smith@example.com', '2021-02-12'),
(3, 'Catherine Davis', 'catherine.d@example.com', '2021-03-20'),
(4, 'David Brown', 'david.b@example.com', '2021-04-08'),
(5, 'Eva Miller', 'eva.m@example.com', '2021-05-15'),
(6, 'Frank Wilson', 'frank.w@example.com', '2021-06-02'),
(7, 'Grace Taylor', 'grace.t@example.com', '2021-07-10'),
(8, 'Henry Martinez', 'henry.m@example.com', '2021-08-18'),
(9, 'Ivy Robinson', 'ivy.r@example.com', '2021-09-25'),
(10, 'Jack Harris', 'jack.h@example.com', '2021-10-03');

INSERT INTO Products (ProductID, Name, Category, Price) VALUES
(1, 'Laptop', 'Electronics', 45000),
(2, 'Smartphone', 'Electronics', 20000),
(3, 'Wireless Headphones', 'Electronics', 5000),
(4, 'Designer Backpack', 'Fashion', 3000),
(5, 'Coffee Maker', 'Appliances', 1000),
(6, 'Modern Sofa', 'Furniture', 50000),
(7, 'Wall Art Painting', 'Home Decor', 500),
(8, 'Running Shoes', 'Sports', 2500),
(9, 'Gaming Console', 'Electronics', 1500),
(10, 'Desk Lamp', 'Home Decor', 700);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(1, 1, '2022-01-15', 45700),
(2, 3, '2022-02-20', 5000),
(3, 5, '2022-03-10', 4500),
(4, 7, '2022-04-05', 3000),
(5, 9, '2022-05-01', 30000),
(6, 2, '2022-06-15', 3000),
(7, 4, '2022-07-02', 500),
(8, 6, '2022-08-18', 40000),
(9, 8, '2022-09-01', 700),
(10, 10, '2022-10-10', 2500);

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, PricePerUnit) VALUES
(1, 1, 1, 1, 45000),
(2, 1, 10, 1, 700),
(3, 2, 8, 2, 2500),
(4, 3, 9, 3, 1500),
(5, 4, 4, 1, 3000),
(6, 5, 3, 2, 5000),
(7, 5, 2, 1, 20000),
(8, 6, 5, 3, 1000),
(9, 7, 7, 1, 500),
(10, 8, 2, 2, 20000),
(11, 9, 10, 1, 700),
(12, 10, 8, 1, 2500);


-- 1. Basic Queries:

-- ---1.1. List all customers.

select * from Customers;

-- ---1.2. Show all products in the 'Electronics' category.

select * from Products where Category = "Electronics";

-- ---1.3. Find the total number of orders placed.

select count(OrderID) as Total_Orders from Orders;

-- ---1.4. Display the details of the most recent order.

select * from Orders where OrderDate in (select max(OrderDate) from Orders);

-- 2. Joins and Relationships:
-- ---2.1. List all products along with the names of the customers who ordered them.

select p.name, c.name from 
	OrderDetails od left join
    Orders o on od.OrderID=o.OrderID left join
    Products p on od.ProductId=p.ProductID left join
    Customers c on o.CustomerID=c.CustomerID;
    
-- ---2.2. Show orders that include more than one product.

select od.OrderID, count(od.OrderID) as "Product Count" 
	from OrderDetails od 
		group by od.OrderID 
        having count(od.OrderID)>1;
-- ---2.3. Find the total sales amount for each customer.

select c.name, SUM(o.TotalAmount) as  "Total Sales"
	from Orders o join 
    Customers c on o.CustomerID=c.CustomerID
    group by C.name;

-- 3. Aggregation and Grouping:

-- ---3.1. Calculate the total revenue generated by each product category.

select P.Category, sum(Price*Quantity) as "Revenue by Category"
	from OrderDetails OD join
    Products P on OD.ProductID =P.ProductID
    group by P.Category;

-- ---3.2. Determine the average order value.

-- -------- Average Order Value: average amount of money spent by customers on each order. It is 
/* calculated by dividing the total revenue generated by all orders by the total number of orders. */

select round(sum(TotalAmount)/count(OrderID),2) as AOV
	from Orders;

select * from OrderDetails OD join
    Products P on OD.ProductID =P.ProductID order by P.Category;

-- ---3.3. Find the month with the highest number of orders.

select monthname(OrderDate),count(month(OrderDate)) as Orders
from Orders group by monthname(OrderDate) order by Orders limit 1; 

-- 4. Subqueries and Nested Queries:

-- ---4.1. Identify customers who have not placed any orders.

select Name from Customers 
	where CustomerID NOT In (select CustomerID from Orders);

-- ---4.2. Find products that have never been ordered.

select Name as Unsold_Product from Products 
	where ProductID NOT In (select ProductID from OrderDetails);

-- ---4.3. Show the top 5 best-selling products.

select P.Name, Count(OD.ProductID) as "Orders", SUM(OD.Quantity) as "Total Orders"
	from OrderDetails OD join
    Products P on OD.ProductID=P.ProductID
	group by OD.ProductID,P.Name order by Count(OD.ProductID) desc,SUM(OD.Quantity) desc limit 5;

-- 5. Date and Time Functions:

-- ---5.1. List orders placed in the last month.

/* Here I am changing year of each OrderDate to current year */

update Orders
set OrderDate = date_add(OrderDate, interval (year(now()) - year(OrderDate)) year)
where year(OrderDate) <> year(NOW());


select * from Orders where Month(OrderDate) >= month('2022-11-02' - INTERVAL 1 MONTH)

-- ---5.2. Determine the oldest customer in terms of membership duration.

select Name, datediff((select max(JoinDate) as MemberSince from Customers),JoinDate) 
	as MemberSince from Customers order by MemberSince desc limit 1;


-- ---6. Advanced Queries:

-- ---6.1. Rank customers based on their total spending.
select C.Name, rank() over (order by TotalAmount desc) as CustomerRank 
	from Orders O join
	Customers C on O.CustomerID= C.CustomerID;
    
-- ---6.2. Identify the most popular product category.

-- (category with most orders)

select P.Category,count(distinct(OD.OrderId)) as "No of times Orderded"
	from OrderDetails OD join
    Products P on OD.ProductID =P.ProductID
    group by P.Category order by count(OD.OrderId) desc limit 1;


-- ---6.3. Calculate the month-over-month growth rate in sales.

-- (CTE AND Lag() window Function

with MonthlySales as ( select date_format(OrderDate, '%Y-%m') as Month, 
	sum(TotalAmount) as MonthlySales from Orders 
		group by Month order by Month
)
select Month, MonthlySales, lag(MonthlySales) over (order by Month) as PreviousMonthSales,
    (MonthlySales - lag(MonthlySales) over (order by Month)) / lag(MonthlySales) over (order by Month) as GrowthRate
from MonthlySales;

-- 7. Data Manipulation and Updates:

-- ---7.1. Add a new customer to the Customers table.

insert into customers (CustomerID, name, email, joindate)
values (11,'New Customer', 'newcustomer@example.com', '2021-01-17');

-- ---7.2. Update the price of a specific product.

update Products
set Price = 600
where Name = "Wall Art Painting";



