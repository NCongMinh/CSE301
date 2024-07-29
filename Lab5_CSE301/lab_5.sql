use salemanagerment;
INSERT INTO Salesman (Salesman_Number, Salesman_Name, Address, City, Pincode, Province, Salary, Sales_Target, Target_Achieved, Phone)
VALUES 
('S007','Quang','Chanh My','Da Lat',700032,'Lam Dong',25000,90,95,'0900853487'),
('S008','Hoa','Hoa Phu','Thu Dau Mot',700051,'Binh Duong',13500,50,75,'0998213659');

INSERT INTO Salesorder (Order_Number, Order_Date, Client_Number, Salesman_Number, Delivery_Status, Delivery_Date, Order_Status)
VALUES
('O20015','2022-05-12','C108','S007','On Way', '2022-05-15','Successful'),
('O20016','2022-05-16','C109','S008','Ready to Ship',null,'In Process');
        
INSERT INTO Salesorderdetails (Order_Number, Product_Number, Order_Quantity)
VALUES
('O20015','P1008',15),
('O20015','P1007',10),
('O20016','P1007',20),
('O20016','P1003',5);

-- 1. Display the clients (name) who live in the same city:
SELECT  c1.Client_Name, c1.City
FROM Clients c1
JOIN Clients c2 ON c1.City = c2.City and c1.client_name <> c2.client_name
ORDER BY c1.City;

select * from salesman;
-- 2. Display city, the client names and salesman names who are lives in “Thu Dau Mot” city.
select c.city, c.client_name, s.salesman_name from clients c inner join salesman s on 
c.city = "Thu Dau Mot" and c.city = s.city;

-- 3. Display client name, client number, order number, salesman number, and product number for each order.
SELECT c.Client_Name, c.Client_Number, so.Order_Number, so.Salesman_Number, sod.Product_Number
FROM Clients c
JOIN Salesorder so ON c.Client_Number = so.Client_Number
JOIN Salesorderdetails sod ON so.Order_Number = sod.Order_Number;

-- 4. Find each order (client_number, client_name, order_number) placed by each client.
select s.client_number, client_name, order_number from clients c inner join salesorder s on c.Client_number = s.Client_Number;

-- 5. Display the details of clients (client_number, client_name) and the number of orders which is paid by them.
select c.client_number, c.client_name, count(s.Order_Number) Order_Count from clients c inner join salesorder s on c.Client_Number = so.Client_Number
group by c.client_number, c.client_name;

-- 6. Display the details of clients (client_number, client_name) who have paid for more than 2 orders.
select c.client_number, c.client_name, count(s.Client_Number) Order_Count from clients c inner join salesorder s on c.Client_Number = s.Client_Number
group by c.client_number, c.client_name
having Order_Count > 2;

-- 7. Display details of clients who have paid for more than 1 order in descending order of client_number.
select c.client_number, c.client_name, count(s.Client_Number) Order_Count from clients c inner join salesorder s on c.Client_Number = s.Client_Number
group by c.client_number, c.client_name
having Order_Count > 1
order by client_number desc;

-- 8. Find the salesman names who sells more than 20 products.
SELECT 
    salesman_name, SUM(d.Order_Quantity) Total_Products_Sold
FROM
    salesman s
        INNER JOIN
    salesorder o ON s.Salesman_Number = o.Salesman_Number
        INNER JOIN
    salesorderdetails d ON o.Order_Number = d.Order_Number
GROUP BY salesman_name
HAVING Total_Products_Sold > 20;

-- 9. Display the client information (client_number, client_name) and order number of those clients who
-- have order status is cancelled.
select c.client_number, client_name, s.Order_Number from clients c inner join salesorder s on c.client_number = s.client_number
where s.Order_Status = 'Cancelled';


-- 10. Display client name, client number of clients C101 and count the number of orders which were
-- received “successful”.
select c.client_name, c.client_number, count(so.Order_Number) count_orders from clients c 
inner join salesorder so on c.client_number = so.client_number AND so.Order_Status = 'Successful'
where c.Client_Number = "C101"
group by c.client_name, c.client_number;

-- 11. Count the number of clients orders placed for each product.
select p.Product_Number, product_name, count(sod.Order_Number) num_orders 
from product p inner join salesorderdetails sod on p.product_number = sod.product_number
group by p.Product_Number, product_name;

-- 12. Find product numbers that were ordered by more than two clients then order in descending by product number.
select p.product_number, count( distinct so.client_number) count_clients from product p 
inner join salesorderdetails sod on p.product_number = sod.product_number 
inner join salesorder so on sod.order_number = so.order_number
group by  p.product_number
having count_clients > 2
order by product_number desc;

-- b) Using nested query with operator (IN, EXISTS, ANY and ALL)
-- 13. Find the salesman’s names who is getting the second highest salary.
select salesman_name, salary from salesman where salary 
in (select max(salary) from salesman where salary 
not in (select max(salary) from salesman));

SELECT Salesman_Name, Salary
FROM Salesman
WHERE Salary = (
    SELECT DISTINCT Salary
    FROM Salesman
    ORDER BY Salary DESC
    LIMIT 1 OFFSET 1
);
-- 14. Find the salesman’s names who is getting second lowest salary.
select salesman_name, salary from salesman where salary = (select distinct salary from salesman order by salary asc limit 1 offset 1);

-- 15. Write a query to find the name and the salary of the salesman who have a higher salary than the
-- salesman whose salesman number is S001.
select salesman_name, salary from salesman where salary > (select salary from salesman where salesman_number = "S001");

-- 16. Write a query to find the name of all salesman who sold the product has number: P1002.
select distinct salesman_name from salesman s inner join salesorder so on s.Salesman_Number = so.Salesman_Number
inner join salesorderdetails sod on so.Order_Number = sod.Order_Number
where sod.Product_Number = "P1002";

-- 17. Find the name of the salesman who sold the product to client C108 with delivery status is “delivered”.
select salesman_name from salesman s join salesorder so on s.Salesman_Number = so.Salesman_Number
where Client_Number = "C108" and order_status = "Delivered";

-- 18. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity equal to 5.
select product_name from product where product_number in (select product_number from salesorderdetails where order_quantity = 5);

-- 19. Write a query to find the name and number of the salesman who sold pen or TV or laptop.
select distinct salesman_name, s.salesman_number from salesman s
join salesorder so on s.Salesman_Number = so.Salesman_Number
join salesorderdetails sod on sod.Order_Number = so.Order_Number
join product p on p.Product_Number = sod.Product_Number
where  p.Product_Name in ("pen","TV","laptop");


-- 20. Lists the salesman’s name sold product with a product price less than 800 and Quantity_On_Hand
-- more than 50.
select distinct salesman_name from salesman s
join salesorder so on s.Salesman_Number = so.Salesman_Number
join salesorderdetails sod on sod.Order_Number = so.Order_Number
join product p on p.Product_Number = sod.Product_Number
where Sell_Price < 800 and Quantity_On_Hand > 50;


-- 21. Write a query to find the name and salary of the salesman whose salary is greater than the average
-- salary.
select salesman_name, salary from salesman where salary > (select avg(salary) from salesman);

-- 22. Write a query to find the name and Amount Paid of the clients whose amount paid is greater than the
-- average amount paid.
select client_name, amount_paid from clients where Amount_Paid > (select avg(Amount_Paid) from clients);

-- II. Additional excersice:
-- 23. Find the product price that was sold to Le Xuan.
select sell_price from product p
join salesorderdetails sod on p.Product_Number= sod.Product_Number
join salesorder so on so.Order_Number = sod.Order_Number
join clients cl on cl.Client_Number = so.Client_Number
where Client_Name = "Le Xuan";

-- 24. Determine the product name, client name and amount due that was delivered.
select product_name, client_name, amount_due from clients c
join salesorder so on so.Client_Number = c.Client_Number
join salesorderdetails sod on sod.Order_Number = so.Order_Number
join product p on p.Product_Number = sod.Product_Number
WHERE so.Delivery_Status = 'delivered';

-- 25. Find the salesman’s name and their product name which is cancelled.
select salesman_name, product_name from salesman s 
join salesorder so on s.Salesman_Number = so.Salesman_Number
join salesorderdetails sod on sod.Order_Number = so.Order_Number
join product p on p.Product_Number = sod.Product_Number
where Order_Status = "cancelled";

-- 26. Find product names, prices and delivery status for those products purchased by Nguyen Thanh.
select product_name, sell_price, delivery_status from product p 
join salesorderdetails sod on sod.Product_Number = p.Product_Number
join salesorder so on so.Order_Number = sod.Order_Number
join clients c on c.Client_Number = so.Client_Number
where client_name = "Nguyen Thanh";

-- 27. Display the product name, sell price, salesperson name, delivery status, and order quantity information
-- for each customer.
select product_name, sell_price, salesman_name, delivery_status, order_quantity from clients cl
join salesorder so on so.Client_Number = cl.Client_Number
join salesorderdetails sod on sod.Order_Number = so.Order_Number
join salesman s on s.Salesman_Number = so.Salesman_Number
join product p on p.Product_Number = sod.Product_Number;

-- 28. Find the names, product names, and order dates of all sales staff whose product order status has been
-- successful but the items have not yet been delivered to the client.
select salesman_name, product_name, order_date from salesman s 
join salesorder so on so.Salesman_Number = s.Salesman_Number 
join salesorderdetails sod on sod.Order_Number = so.Order_Number
join product p on p.Product_Number = sod.Product_Number
where order_status = "Successful" and delivery_status <> "Delivered";

-- 29. Find each clients’ product which in on the way.
select Client_Name, Product_Name
from Clients c
join Salesorder so on c.Client_Number = so.Client_Number
join Salesorderdetails sod on so.Order_Number = sod.Order_Number
join Product p on sod.Product_Number = p.Product_Number
where so.Delivery_Status = 'On Way';

-- 30. Find salary and the salesman’s names who is getting the highest salary.
select salesman_name, salary from salesman where salary in (select max(salary) from salesman);

-- 31. Find salary and the salesman’s names who is getting second lowest salary.
select salesman_name, salary from salesman where salary in (select min(salary) from salesman where salary not in (select min(salary) from salesman));

-- 32. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity more
-- than 9.
select distinct product_name from product p 
join salesorderdetails sod on sod.Product_Number = p.Product_Number
where Order_Quantity > 9;

-- 33. Find the name of the customer who ordered the same item multiple times.
select client_name, count(sod.Product_Number) client_count from clients cl
join salesorder so on so.Client_Number = cl.Client_Number
join salesorderdetails sod on sod.Order_Number = so.Order_Number
group by Client_Name
having client_count > 1;

SELECT c.Client_Name
FROM Clients c
JOIN Salesorder so ON c.Client_Number = so.Client_Number
JOIN Salesorderdetails sod ON so.Order_Number = sod.Order_Number
GROUP BY c.Client_Number, c.Client_Name, sod.Product_Number
HAVING COUNT(*) > 1;

select * from salesorderdetails;
select * from salesorder;
select * from product;
select * from clients;

-- 34. Write a query to find the name, number and salary of the salemans who earns less than the average
-- salary and works in any of Thu Dau Mot city.

select salesman_name, salesman_number, salary from salesman 
where salary < (select avg(salary) from salesman) and  city = "Thu Dau Mot";

-- 35. Write a query to find the name, number and salary of the salemans who earn a salary that is higher than
-- the salary of all the salesman have (Order_status = ‘Cancelled’). Sort the results of the salary of the lowest to
-- highest.
select salesman_name, salesman_number, salary from salesman where salary > all 
											(select salary from salesman s 
											join salesorder so on s.Salesman_Number = so.Salesman_Number 
											where Order_Status = "Cancelled")
order by salary;

-- 36. Write a query to find the 4th maximum salary on the salesman’s table.
select distinct salary from salesman order by salary desc limit 3,1;
-- 37. Write a query to find the 3th minimum salary in the salesman’s table.
select distinct salary from salesman order by salary desc limit 2,1;
