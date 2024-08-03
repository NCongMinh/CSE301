use salemanagerment;

-- 1. SQL statement returns the cities (only distinct values) from both the "Clients" and the "salesman"
-- table.
select city from clients
union
select city from salesman;

-- 2. SQL statement returns the cities (duplicate values also) both the "Clients" and the "salesman" table.
select city from clients
union all 
select city from salesman;
-- 3. SQL statement returns the Ho Chi Minh cities (only distinct values) from the "Clients" and the
-- "salesman" table.
select city from clients where city = "Ho Chi Minh"
union 
select city from salesman where city = "Ho Chi Minh";

-- 4. SQL statement returns the Ho Chi Minh cities (duplicate values also) from the "Clients" and the
-- "salesman" table.
select city from clients where city = "Ho Chi Minh"
union all
select city from salesman where city = "Ho Chi Minh";

-- 5. SQL statement lists all Clients and salesman.
select client_number ID, client_name Name,  "Client" as Type from clients 
union all
select salesman_number, salesman_name, "Salesman" from salesman;

-- 6. Write a SQL query to find all salesman and clients located in the city of Ha Noi on a table with
-- information: ID, Name, City and Type.
select client_number ID, client_name Name, City, "Client" as Type from clients where city = "Hanoi"
union all
select salesman_number, salesman_name, city, "Salesman" from salesman where city = "Hanoi";

-- 7. Write a SQL query to find those salesman and clients who have placed more than one order. Return
-- ID, name and order by ID.
SELECT 
    *
FROM
    (SELECT 
        c.client_number ID,
            client_name Name,
            'Client' AS Type,
            COUNT(so.client_number) OrderCount
    FROM
        clients c
    JOIN salesorder so ON so.client_number = c.client_number
    GROUP BY c.client_number , client_name
    HAVING OrderCount > 1 UNION ALL SELECT 
        s.salesman_number,
            salesman_name,
            'Salesman',
            COUNT(so.salesman_number) OrderCount
    FROM
        salesman s
    JOIN salesorder so ON so.salesman_number = s.salesman_number
    GROUP BY s.salesman_number , salesman_name
    HAVING OrderCount > 1) AS T
ORDER BY ID;

-- 8. Retrieve Name, Order Number (order by order number) and Type of client or salesman with the client
-- names who placed orders and the salesman names who processed those orders.
select * from 
(SELECT 
    client_name Name, so.order_number ID, 'Client' AS Type
FROM
    clients c
        JOIN
    salesorder so ON so.client_number = c.client_number 
UNION ALL SELECT 
    salesman_name, so.order_number, 'Salesman'
FROM
    salesman s
        JOIN
    salesorder so ON so.salesman_number = s.salesman_number) as T
ORDER BY ID;

-- 9. Write a SQL query to create a union of two queries that shows the salesman, cities, and
-- target_Achieved of all salesmen. Those with a target of 60 or greater will have the words 'High
-- Achieved', while the others will have the words 'Low Achieved'.
SELECT 
    salesman_name Name,
    City,
    Target_Achieved,
    'High Achieved' AS Type
FROM
    salesman
WHERE
    target_achieved >= 60 
UNION ALL SELECT 
    salesman_name, city, target_achieved, 'Low Achieved'
FROM
    salesman
WHERE
    target_achieved < 60;

-- 10. Write query to creates lists all products (Product_Number AS ID, Product_Name AS Name,
-- Quantity_On_Hand AS Quantity) and their stock status. Products with a positive quantity in stock are
-- labeled as 'More 5 pieces in Stock'. Products with zero quantity are labeled as ‘Less 5 pieces in Stock'.
SELECT 
    Product_Number AS ID,
    Product_Name AS Name,
    Quantity_On_Hand AS Quantity,
    'More 5 pieces in Stock' Stock_Status
FROM
    product
WHERE
    Quantity_On_Hand > 5 
UNION ALL SELECT 
    Product_Number,
    Product_Name,
    Quantity_On_Hand AS Quantity,
    'Less 5 pieces in Stock' Stock_Status
FROM
    product
WHERE
    Quantity_On_Hand <= 5;

-- 11. Create a procedure stores get_clients _by_city () saves the all Clients in table. Then Call procedure
-- stores.
Delimiter $$
	Create procedure get_clients_by_city(in c_city varchar(30))
		BEGIN
			select * from clients where city = c_city;
        END $$
Delimiter ;
call get_clients_by_city("Hanoi");

-- 12. Drop get_clients _by_city () procedure stores.
drop procedure get_clients_by_city;

-- 13. Create a stored procedure to update the delivery status for a given order number. Change value
-- delivery status of order number “O20006” and “O20008” to “On Way”.
Delimiter $$
create procedure update_delivery_status(in o_order_number varchar(15), in o_delivery_status char(15))
	begin 
		update salesorder set delivery_status = o_delivery_status where order_number = o_order_number;
    end $$
Delimiter ;
call update_delivery_status("O20006", "On Way");
call update_delivery_status("O20008", "On Way");

-- 14. Create a stored procedure to retrieve the total quantity for each product.
Delimiter $$
create procedure get_total_quantity_per_product()
	begin
		select product_name, total_quantity from product;
    end $$
Delimiter ;
call get_total_quantity_per_product;

-- 15. Create a stored procedure to update the remarks for a specific salesman.
Delimiter $$
create procedure update_remark_by_salesman_id(in id varchar(15), in remark text)
begin 
	update salesman set remarks = remark where salesman_number = id;
end $$
Delimiter ;

-- 16. Create a procedure stores find_clients() saves all of clients and can call each client by client_number.
Delimiter $$
	create procedure find_clients(in c_client_number varchar(10))
		begin 
			select * from clients where client_number = c_client_number;
		end $$
Delimiter ;

-- 17. Create a procedure stores salary_salesman() saves all of clients (salesman_number, salesman_name,
-- salary) having salary > 15000. Then execute the first 2 rows and the first 4 rows from the salesman
-- table.
Delimiter $$
create procedure salary_salesman(in numLimit int) 
	begin
		select salesman_number, salesman_name, salary from salesman where salary > 15000
        limit numLimit;
	end $$
Delimiter ;
call salary_salesman(2);
call salary_salesman(4);

-- 18. Procedure MySQL MAX() function retrieves maximum salary from MAX_SALARY of salary table.
Delimiter $$
create procedure max_salary()
 begin
	select max(salary) from salesman;
 end $$
Delimiter ; 

-- 19. Create a procedure stores execute finding amount of order_status by values order status of salesorder
-- table.
Delimiter $$
create procedure find_amount_by_order_status()
	begin
		select order_status, count(order_number) as Status_Count from salesorder 
		group by order_status;
    end $$
Delimiter ;

-- 21. Count the number of salesman with following conditions : SALARY < 20000; SALARY > 20000;
-- SALARY = 20000.
Delimiter $$
Create procedure count_number_salesman_by_salary()
	begin 
		select "Salary_Above_20000" as Conditions, count(*) Num_of_salesman from salesman where salary > 20000
		union all
		select "Salary_Below_20000", count(*) Num_of_salesman from salesman where salary < 20000
		union all 
		select "Salary_Equal_20000", count(*) Num_of_salesman from salesman where salary = 20000;
	end$$
Delimiter ;


-- 22. Create a stored procedure to retrieve the total sales for a specific salesman.
Delimiter $$
create procedure get_salesman(in s_salesman_number varchar(15), out Total_sales int)
	begin 
		select sum(order_quantity) into Total_sales from salesorder so
        join salesorderdetails sod on so.order_number = sod.order_number
        where so.salesman_number = s_salesman_number;
    end$$
Delimiter ;
set @Total_sales = 0;
call get_salesman("S003", @Total_sales);
select @Total_sales;

-- 23. Create a stored procedure to add a new product:
-- Input variables: Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price,
-- Cost_Price.
Delimiter $$
create procedure add_product(in p_Product_Number varchar(15),in p_Product_Name varchar(25), p_Quantity_On_Hand int, p_Quantity_Sell int, p_Sell_Price decimal(15,4),
p_Cost_Price decimal(15,4))
	begin 
		insert into product(Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price, Cost_Price) 
        values(p_Product_Number, p_Product_Name, p_Quantity_On_Hand, p_Quantity_Sell, p_Sell_Price, p_Cost_Price);
	end$$
Delimiter ;

-- 24. Create a stored procedure for calculating the total order value and classification:
-- - This stored procedure receives the order code (p_Order_Number) và return the total value
-- (p_TotalValue) and order classification (p_OrderStatus).
-- - Using the cursor (CURSOR) to browse all the products in the order (SalesOrderDetails).
-- - LOOP/While: Browse each product and calculate the total order value.
-- - CASE WHEN: Classify orders based on total value:
-- Greater than or equal to 10000: "Large"
-- Greater than or equal to 5000: "Midium"
-- Less than 5000: "Small"

Delimiter $$
create procedure calculate_total_order_and_classification(in p_Order_Number varchar(15), out sum decimal(15, 4), out clarity char(15))
	begin
        
        DECLARE done INT DEFAULT FALSE;
        DECLARE temp_order_quantity int;
        DECLARE temp_sell_price decimal(15, 4);
        DECLARE cur_order cursor for 
							select order_quantity, sell_price 
                            from salesorderdetails sod join product p on p.product_number = sod.product_number
                            where sod.order_number = p_Order_Number;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	
     	set sum = 0;
        open cur_order;
        read_loop: LOOP
			fetch cur_order into temp_order_quantity, temp_sell_price;
            set sum = sum + (temp_order_quantity * temp_sell_price);
            if done then
				leave read_loop;
			end if;
		end loop;
        CASE
			WHEN sum >= 10000 THEN SET clarity = 'Large';
			WHEN sum >= 5000 THEN SET clarity = 'Medium';
			ELSE SET clarity = 'Small';
		END CASE; 
	CLOSE cur_order;
end $$
Delimiter ;

select * from salesorderdetails;
select * from prod uct;
set @sum = 0;
set @clarity = "";
call calculate_total_order_and_classification('O20001', @sum, @clarity);
select @sum;
select @clarity;
