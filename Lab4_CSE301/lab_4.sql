use salemanagerment;	

-- 1. Show the all-clients details who lives in “Binh Duong”.
select * from clients where province = "Binh Duong";

-- 2. Find the client’s number and client’s name who do not live in “Hanoi”.
select client_number, client_number from clients where Province <> "Hanoi";

-- 3. Identify the names of all products with less than 25 in stock.
select product_name from product where Quantity_On_Hand < 25;

-- 4. Find the product names where company making losses.
select product_name from product where Sell_Price < Cost_Price;

-- 5. Find the salesman’s details who are able achieved their target.
select * from salesman where Target_Achieved >= Sales_Target;

-- 6. Select the names and city of salesman who are not received salary between 10000 and 17000.
select salesman_name, city from salesman where salary not between 10000 and 17000;

-- 7. Show order date and the clients_number of who bought the product between '2022-01-01' and '2022-02-15'.
select order_date, client_number from salesorder where order_date  between '2022-01-01' and '2022-02-15';

-- 8. Find the names of cities in clients table where city name starts with "N" ??????????????????
select city from clients where city like "N%";

-- 9. Display clients’ information whose names have "u" in third position.
select * from clients where Client_Name like "__u%";

-- 10. Find the details of clients whose names have "u" in second last position.
select * from clients where Client_Name like "%u_";

-- 11. Find the names of cities in clients table where city name starts with "D" and ends with “n”.
select city from clients where city like "D%n";

-- 12. Select all clients details who belongs from Ho Chi Minh, Hanoi and Da Lat. 
select * from clients where province in ("Ho Chi Minh", "Hanoi", "Da Lat"); 

-- 13. Choose all clients data who do not reside in Ho Chi Minh, Hanoi and Da Lat.
select * from clients where city not in ("Ho Chi Minh", "Hanoi", "Da Lat"); 

-- c) Using mySQL functions (Min(), Max(), COUNT(), AVG() and SUM())
-- 14. Find the average salesman’s salary.
select avg(salary) from salesman;

-- 15. Find the name of the highest paid salesman.
select salesman_name from salesman where salary in (select max(salary) from salesman);

-- 16. Find the name of the salesman who is paid the lowest salary.
select salesman_name from salesman where salary in (select min(salary) from salesman);

-- 17. Determine the total number of salespeople employed by the company.
select count(*) from salesman;

-- 18. Compute the total salary paid to the company's salesman.
select sum(salary) from salesman;

-- d) Using Order by keyword, limit clause
-- 19. Select the salesman’s details sorted by their salary.
select * from salesman order by salary asc;

-- 20. Display salesman names and phone numbers based on their target achieved (in ascending order) and their city (in descending order).
select salesman_name, phone from salesman order by Sales_Target asc, city desc;

-- 21. Display 3 first names of the salesman table and the salesman’s names in descending order.
select salesman_name from salesman order by salesman_name desc limit 3;

-- 22. Find salary and the salesman’s names who is getting the highest salary.
select salary, salesman_name from salesman where salary in (select max(salary) from salesman);

-- 23. Find salary and the salesman’s names who is getting second lowest salary.
select salary, salesman_name from salesman where salary not in (select min(salary) from salesman) order by salary asc limit 1;

-- 24. Display the first five sales orders in formation from the sales order table.
select * from salesorder limit 5;

-- 25. Display next ten sales order information from sales order table except first five sales order.
select * from salesorder limit 5, 10;

-- e) Using group by with having clause with aggregate functions (COUNT(), MAX(), MIN(), SUM(),
-- AVG()), order by.
-- 26. If there are more than one client, find the name of the province and the number of clients in each
-- province, ordered high to low
select province, count(*) num_clients from clients
group by province
having num_clients > 1
order by num_clients desc;

-- 27. Display information clients have number of sales order more than 1.
select c.client_number,  c.client_name,  c.city,  c.province, count(s.Order_Number) num 
from clients c inner join salesorder s on c.client_number = s.client_number
group by c.client_number,  c.client_name,  c.city,  c.province
having num > 1
order by num desc;

-- 28. Display the name and due amount of those clients who lives in “Hanoi”.
select client_name, amount_due from clients where province = "Hanoi";

-- 29. Find the clients details who has due more than 3000.
select * from clients where Amount_Due > 3000;

-- 30. Find the clients name and their province who has no due.
select client_name, province from clients where amount_due = 0;

-- 31. Show details of all clients paying between 10,000 and 13,000.
select * from clients where Amount_Paid between 10000 and 13000;

-- 32. Find the details of clients whose name is “Dat”.
select * from clients where client_name like "%Dat";

-- 33. Display all product name and their corresponding selling price.
select product_name, sell_price from product;

-- 34. How many TVs are in stock?
select quantity_on_hand from product where product_name = "TV";

-- 35. Find the salesman’s details who are not able achieved their target.
select * from salesman where Target_Achieved < Sales_Target;

-- 36. Show all the product details of product number ‘P1005’.
select * from product where product_number = "P1005";

-- 37. Find the buying price and sell price of a Mouse.
select sell_price, cost_price from product where Product_Name = "Mouse";

-- 38. Find the salesman names and phone numbers who lives in Thu Dau Mot.
select salesman_name, phone from salesman where city = "Thu Dau Mot";

-- 39. Find all the salesman’s name and salary.
select salesman_name, salary from salesman;

-- 40. Select the names and salary of salesman who are received between 10000 and 17000.
select salesman_name, salary from salesman where salary between 10000 and 17000;

-- 41. Display all salesman details who are received salary between 10000 and 20000 and achieved
-- their target.
select * from salesman where salary between 10000 and 20000 and Sales_Target <= Target_Achieved;

-- 42. Display all salesman details who are received salary between 20000 and 30000 and not achieved
-- their target.
select * from salesman where salary between 20000 and 30000 and Sales_Target > Target_Achieved;

-- 43. Find information about all clients whose names do not end with "h".
select * from clients where client_name not like "%h";

-- 44. Find client names whose second letter is 'r' or second last letter 'a'.
select * from clients where client_name like "_r%" or client_name like "%a_";

-- 45. Select all clients where the city name starts with "D" and at least 3 characters in length.
select * from clients where city like "D__%";

-- 46. Select the salesman name, salaries and target achieved sorted by their target_achieved in
-- descending order.
select salesman_name, salary from salesman order by Target_Achieved desc;

-- 47. Select the salesman’s details sorted by their sales_target and target_achieved in ascending order.
select * from salesman order by Sales_Target, Target_Achieved;

-- 48. Select the salesman’s details sorted ascending by their salary and descending by achieved target.
select * from salesman order by salary, Target_Achieved desc;

-- 49. Display salesman names and phone numbers in descending order based on their sales target.
select salesman_name, phone from salesman order by Sales_Target desc;

-- 50. Display the product name, cost price, and sell price sorted by quantity in hand.
select product_name, cost_price, sell_price from product order by Quantity_On_Hand;

-- 51. Retrieve the clients’ names in ascending order.
select client_name from clients order by client_name;

-- 52. Display client information based on order by their city.
select * from clients order by city;

-- 53. Display client information based on order by their address and city.
select * from clients order by address, city;

-- 54. Display client information based on their city, sorted high to low based on amount due.
select * from clients order by city, amount_due desc;

-- 55. Display the data of sales orders depending on their delivery status from the current date to the
-- old date.
select * from salesorder order by Delivery_Status, Order_Date desc;

-- 56. Display last five sales order information from sales order table.
select * from salesorder order by Order_Date desc, Order_Number desc limit 5; 

-- 57. Count the pincode in client table.
select count(pincode) from clients;

-- 58. How many clients are living in Binh Duong?
select count(*) from clients where province = "Binh Duong";

-- 59. Count the clients for each province.
select province, count(*) num_of_clients from clients
group by province;

-- 60. If there are more than three clients, find the name of the province and the number of clients in each
-- province.
select province, count(*) num_of_clients  from clients 
group by province
having num_of_clients > 3;

-- 61. Display product number and product name and count number orders of each product more than 1
-- (in ascending order).
SELECT 
    p.product_number, p.product_name, COUNT(*) num_of_clients
FROM
    product p
        INNER JOIN
    salesorderdetails sod ON p.product_number = sod.product_number
GROUP BY p.product_number , p.product_name
HAVING num_of_clients > 1
ORDER BY num_of_clients;

-- 62. Find products which have more quantity on hand than 20 and less than the sum of average.
SELECT 
    *
FROM
    product
WHERE
    Quantity_On_Hand > 20
        AND Quantity_On_Hand < (SELECT 
            AVG(Quantity_On_Hand)
        FROM
            product);
