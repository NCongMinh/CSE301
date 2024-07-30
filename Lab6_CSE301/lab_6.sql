use salemanagerment;

-- 1. How to check constraint in a table?
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'clients';

-- 2. Create a separate table name as “ProductCost” from “Product” table, which contains the information
-- about product name and its buying price.
create table ProductCost as select product_name, cost_price from product;

-- 3. Compute the profit percentage for all products. Note: profit = (sell-cost)/cost*100
alter table product add column profit float;
update product set profit = (sell_price - cost_price)/cost_price * 100;


-- 4. If a salesman exceeded his sales target by more than equal to 75%, his remarks should be ‘Good’.
-- 5. If a salesman does not reach more than 75% of his sales objective, he is labeled as 'Average'.
-- 6. If a salesman does not meet more than half of his sales objective, he is considered 'Poor'.
alter table salesman add column remarks text;
UPDATE Salesman
SET remarks = CASE
    WHEN target_achieved >= sales_target * 0.75 THEN 'Good'
    WHEN target_achieved < sales_target * 0.75 and target_achieved >= sales_target * 0.5 THEN 'Average'
    ELSE 'Poor'
END;
-- 7. Find the total quantity for each product. (Query)
select *, quantity_on_hand + quantity_sell as total_quantity from product;

-- 8. Add a new column and find the total quantity for each product.
alter table product add column total_quantity int;
update product set total_quantity = quantity_on_hand + quantity_sell;

-- Practice Assignment 6
-- 9. If the Quantity on hand for each product is more than 10, change the discount rate to 10 otherwise set to 5.
alter table product add column discount_rate float;
update product set discount_rate = case when quantity_on_hand > 10 then 10 else 5 end;

-- 10. If the Quantity on hand for each product is more than equal to 20, change the discount rate to 10, if it is
-- between 10 and 20 then change to 5, if it is more than 5 then change to 3 otherwise set to 0.
update product set discount_rate = case when quantity_on_hand > 20 then 10
										else case when quantity_on_hand > 10 then 5
                                        else case when quantity_on_hand > 5 then 3
                                        else 0 end end end;
                                        
-- 11. The first number of pin code in the client table should be start with 7.
alter table clients add constraint chk_start_pincode check (pincode like "7%");

-- b) Creating and using view:
-- 12. Creates a view name as clients_view that shows all customers information from Thu Dau Mot.
create view client_view as select * from clients where city = "Thu Dau Mot";

-- 13. Drop the “client_view”.
drop view client_view;

-- 14. Creates a view name as clients_order that shows all clients and their order details from Thu Dau Mot.
CREATE VIEW clients_order AS
    (SELECT 
       cl.*
    FROM
        clients cl
            JOIN
        salesorder so ON cl.client_number = so.client_number
            JOIN
        salesorderdetails sod ON sod.order_number = so.order_number where city = "Thu Dau Mot");

-- 15. Creates a view that selects every product in the "Products" table with a sell price higher than the average
-- sell price.
create view product_sell_price as select * from product where sell_price > (select avg(sell_price) from product);

-- 16. Creates a view name as salesman_view that show all salesman information and products (product names,
-- product price, quantity order) were sold by them.
create view salesman_view as (select product_name, sell_price, order_quantity, s.* from product p 
join salesorderdetails sod on sod.product_number = p.product_number 
join salesorder so on so.order_number = sod.order_number
join salesman s on s.salesman_number = so.salesman_number);

-- 17. Creates a view name as sale_view that show all salesman information and product (product names,
-- product price, quantity order) were sold by them with order_status = 'Successful'.
create view sale_view as (select product_name, sell_price, order_quantity, s.* from product p 
join salesorderdetails sod on sod.product_number = p.product_number 
join salesorder so on so.order_number = sod.order_number
join salesman s on s.salesman_number = so.salesman_number where order_status = "Successful");

-- 18. Creates a view name as sale_amount_view that show all salesman information and sum order quantity
-- of product greater than and equal 20 pieces were sold by them with order_status = 'Successful'.
select s.*, sum(order_quantity) from product p 
join salesorderdetails sod on sod.product_number = p.product_number 
join salesorder so on so.order_number = sod.order_number
join salesman s on s.salesman_number = so.salesman_number;

CREATE VIEW sale_amount_view AS
SELECT 
    s.*, SUM(order_quantity > 20) AS total_quantity
FROM
    product p
        JOIN
    salesorderdetails sod ON sod.product_number = p.product_number
        JOIN
    salesorder so ON so.order_number = sod.order_number
        JOIN
    salesman s ON s.salesman_number = so.salesman_number
WHERE
    so.order_status = 'Successful'
GROUP BY s.salesman_number
HAVING total_quantity >= 20;

-- II. Additional assignments about Constraint
-- 19. Amount paid and amounted due should not be negative when you are inserting the data.
alter table clients add constraint chk_amount_paid check (amount_paid >= 0),
					add constraint chk_amount_due check (amount_due >= 0);	
                    
-- 20. Remove the constraint from pincode;
alter table clients drop constraint chk_start_pincode;
 
-- 21. The sell price and cost price should be unique.
alter table product add constraint unique_sell_price unique(sell_price),
					add constraint unique_cost_price unique(cost_price);

-- 22. The sell price and cost price should not be unique.
alter table product drop constraint unique_sell_price,
					drop constraint unique_cost_price;

-- 23. Remove unique constraint from product name.
alter table product drop constraint Product_Name;

-- 24. Update the delivery status to “Delivered” for the product number P1007.
update salesorder so 
join salesorderdetails sod on sod.order_number = so.order_number 
set delivery_status = "Delivered"
where product_number = "P1007";

-- 25. Change address and city to ‘Phu Hoa’ and ‘Thu Dau Mot’ where client number is C104.
update clients set address = "Phu Hoa", city = "Thu Dau Mot"  where client_number = "C104";

-- 26. Add a new column to “Product” table named as “Exp_Date”, data type is Date.
alter table product add column Exp_Date Date;

-- 27. Add a new column to “Clients” table named as “Phone”, data type is varchar and size is 15.
alter table clients add column Phone varchar(15);

-- 28. Update remarks as “Good” for all salesman.
update salesman set remarks = "Good";

-- 29. Change remarks to "bad" whose salesman number is "S004".
update salesman set remarks = "Bad" where salesman_number = "S004";

-- 30. Modify the data type of “Phone” in “Clients” table with varchar from size 15 to size is 10.
alter table clients modify column Phone varchar(10);

-- 31. Delete the “Phone” column from “Clients” table.
alter table clients drop column Phone;

-- 32. alter table Clients drop column Phone;
alter table clients drop column Phone;

-- 33. Change the sell price of Mouse to 120.
update product set sell_price = 120 where product_name = "Mouse";

-- 34. Change the city of client number C104 to “Ben Cat”.
update clients set city = "Ben Cat" where client_number = "C104";

-- 35. If On_Hand_Quantity greater than 5, then 10% discount. If On_Hand_Quantity greater than 10, then 15%
-- discount. Othrwise, no discount.
-- Updating discount based on 'On_Hand_Quantity'
UPDATE Product
SET discount_rate = CASE
    WHEN Quantity_on_hand > 10 THEN 0.15
    WHEN Quantity_on_hand > 5 THEN 0.1
    ELSE 0
END;



