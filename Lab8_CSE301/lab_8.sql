use salemanagerment;

-- 1. Create a trigger before_total_quantity_update to update total quantity of product when
-- Quantity_On_Hand and Quantity_sell change values.
DROP TRIGGER IF EXISTS before_total_quantity_update;
CREATE TRIGGER before_total_quantity_update
BEFORE UPDATE ON product FOR EACH ROW 
SET NEW.total_quantity = new.Quantity_On_Hand + new.quantity_sell;

UPDATE product
SET Quantity_On_Hand = 30, quantity_sell = 35
WHERE product_number = 'P1004';

-- 2. Create a trigger before_remark_salesman_update to update Percentage of per_remarks in a salesman
-- table (will be stored in PER_MARKS column) : per_remarks = target_achieved*100/sales_target.
DROP TRIGGER IF EXISTS before_remark_salesman_update;
CREATE TRIGGER before_remark_salesman_update
BEFORE UPDATE ON salesman FOR EACH ROW 
SET NEW.PER_MARKS = (NEW.target_achieved * 100) / NEW.sales_target;

UPDATE salesman 
SET target_achieved = 40 
WHERE salesman_number = "S001";

-- 3. Create a trigger before_product_insert to insert a product in product table.
-- AND
DROP TRIGGER IF EXISTS before_product_insert;
DELIMITER //
CREATE TRIGGER before_product_insert
BEFORE INSERT ON product
FOR EACH ROW
BEGIN
    -- Check if required fields are provided
    IF NEW.Product_Number IS NULL OR NEW.Product_Name IS NULL OR 
       NEW.Quantity_On_Hand IS NULL OR NEW.Quantity_Sell IS NULL OR 
       NEW.Sell_Price IS NULL OR NEW.Cost_Price IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'All required fields must be provided';
    END IF;
    -- Check if prices are positive
    IF NEW.Sell_Price <= 0 OR NEW.Cost_Price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Prices must be positive';
    END IF;
    -- Check if quantities are non-negative
    IF NEW.Quantity_On_Hand < 0 OR NEW.Quantity_Sell < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantities cannot be negative';
    END IF;
    -- Set default discount_rate if not provided
    IF NEW.discount_rate IS NULL THEN
        SET NEW.discount_rate = 0.0;
    END IF;
    -- Set default Exp_Date if not provided (1 year from now)
    IF NEW.Exp_Date IS NULL THEN
        SET NEW.Exp_Date = DATE_ADD(CURDATE(), INTERVAL 1 YEAR);
    END IF;
END;
//
DELIMITER ;

INSERT INTO product (Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price, Cost_Price)
VALUES ('P1052', 'New Product', 100, 0, 50.00, 30.00);

-- 4. Create a trigger to before update the delivery status to "Delivered" when an order is marked as
-- "Successful".
DROP TRIGGER IF EXISTS before_delivery_status_update;
DELIMITER //
CREATE TRIGGER before_delivery_status_update
BEFORE UPDATE ON salesorder
FOR EACH ROW
BEGIN
    IF NEW.order_status = 'Successful' THEN
        SET NEW.delivery_status = 'Delivered';
    END IF;
END;
//
DELIMITER ;

UPDATE salesorder 
SET order_status = 'Successful' 
WHERE order_number = "O20005";

-- 5. Create a trigger to update the remarks "Good" when a new salesman is inserted.
DROP TRIGGER IF EXISTS after_salesman_insert;
DELIMITER //
CREATE TRIGGER after_salesman_insert
before INSERT ON salesman
FOR EACH ROW
BEGIN
    SET NEW.remarks = 'Good';
END;
//
DELIMITER ;

INSERT INTO salesman (salesman_number, salesman_name, city, pincode, salary, sales_target, Phone)
VALUES ('S012123', 'John Doe', 'New Yorsalesmank', 2, 10, 3, 123112323);
select * from salesman where salesman_number = "S012123" ;

-- 6. Create a trigger to enforce that the first digit of the pin code in the "Clients" table must be 7.
DROP TRIGGER IF EXISTS before_client_insert_update;
DELIMITER //
CREATE TRIGGER before_client_insert_update
BEFORE INSERT ON clients
FOR EACH ROW
BEGIN
    IF LEFT(NEW.pin_code, 1) != '7' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pin code must start with 7';
    END IF;
END;
//
DELIMITER ;

INSERT INTO clients (client_number, client_name, pincode)
VALUES ('C113', 'Test Client', '7123456');
INSERT INTO clients (client_number, client_name, pincode)
VALUES ('C112', 'Invalid Client', '6123456');

-- 7. Create a trigger to update the city for a specific client to "Unknown" when the client is deleted
DROP TRIGGER IF EXISTS before_client_delete;
DELIMITER //
CREATE TRIGGER before_client_delete
before delete ON clients
for each row
BEGIN
    -- Insert the client to be deleted into the deleted_clients table
    INSERT INTO deleted_clients (client_number, Client_Name, Address, City, Pincode, Province, Amount_Paid, Amount_Due)
    VALUES (OLD.Client_Number, OLD.Client_Name, OLD.Address, "Unknown", OLD.Pincode, OLD.Province, OLD.Amount_Paid, OLD.Amount_Due);
END; //
DELIMITER ;

CREATE TABLE deleted_clients (
    client_number varchar(10) PRIMARY KEY,
    Client_Name varchar(25),
    Address VARCHAR(30),
    city VARCHAR(30),
    Pincode int,
    Province VARCHAR(25),
    Amount_Paid DECIMAL(15, 4),
    Amount_Due DECIMAL(15, 4)
);

DELIMITER //
CREATE PROCEDURE transfer_deleted_clients()
BEGIN
    INSERT INTO clients (
        client_number, Client_Name, Address, city, Pincode, Province, Amount_Paid, Amount_Due
    )
    SELECT 
        client_number, Client_Name, Address, city, Pincode, Province, Amount_Paid, Amount_Due
    FROM 
        deleted_clients;
    -- Clear the deleted_clients table
    TRUNCATE TABLE deleted_clients;
END;//
DELIMITER ;

INSERT INTO clients (client_number, client_name, pincode) VALUES ('C113', 'Test Client', '7123456');
DELETE FROM clients WHERE client_number = "C113";
CALL transfer_deleted_clients;
select * from clients;

-- 8. Create a trigger after_product_insert to insert a product and update profit and total_quantity in product
-- table.
DROP TRIGGER IF EXISTS after_product_insert;
DELIMITER //
CREATE TRIGGER after_product_insert
before INSERT ON product
FOR EACH ROW
BEGIN
    SET NEW.total_quantity = NEW.Quantity_On_Hand + NEW.Quantity_Sell;
    SET NEW.profit = (NEW.Sell_Price * NEW.Quantity_On_Hand) - (NEW.Cost_Price * NEW.total_quantity);
END;
//
DELIMITER ;

-- 9. Create a trigger to update the delivery status to "On Way" for a specific order when an order is inserted.
DROP TRIGGER IF EXISTS after_delivery_status_insert;
DELIMITER //
CREATE TRIGGER after_delivery_status_insert
before INSERT ON salesorder
FOR EACH ROW
BEGIN
    SET new.delivery_status = "On Way";
END;//
DELIMITER ;

INSERT INTO salesorder (order_number, client_number, order_date)
VALUES ('O20054', 'C101', CURDATE());

-- 10. Create a trigger before_remark_salesman_update to update Percentage of per_remarks in a salesman
-- table (will be stored in PER_MARKS column) If per_remarks >= 75%, his remarks should be 'Good'.
-- If 50% <= per_remarks < 75%, he is labeled as 'Average'. If per_remarks <50%, he is considered
-- 'Poor'.
DROP TRIGGER IF EXISTS before_remark_salesman_update;
DELIMITER //
CREATE TRIGGER before_remark_salesman_update
BEFORE UPDATE ON salesman
FOR EACH ROW
BEGIN
    SET NEW.PER_MARKS = (NEW.target_achieved * 100) / NEW.sales_target;
    
    IF NEW.PER_MARKS >= 75 THEN 
        SET NEW.remarks = "Good";
    ELSEIF NEW.PER_MARKS >= 50 THEN
        SET NEW.remarks = "Average";
    ELSE  
        SET NEW.remarks = "Poor";
    END IF;
END;
//
DELIMITER ;

UPDATE salesman 
SET target_achieved = 80, sales_target = 100 
WHERE salesman_number = "S001";

-- 11. Create a trigger to check if the delivery date is greater than the order date, if not, do not insert it.
DROP TRIGGER IF EXISTS before_order_insert;
DELIMITER //
CREATE TRIGGER before_order_insert
BEFORE INSERT ON salesorder
FOR EACH ROW
BEGIN
    IF NEW.delivery_date <= NEW.order_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Delivery date must be after order date';
    END IF;
END;
//
DELIMITER ;

-- succeed
INSERT INTO salesorder (order_number, client_number, order_date, delivery_date)
VALUES ('O201241', 'C102', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 1 DAY));
-- fail
INSERT INTO salesorder (order_number, client_number, order_date, delivery_date)
VALUES ('O20012', 'C103', CURDATE(), DATE_SUB(CURDATE(), INTERVAL 1 DAY));

-- 12. Create a trigger to update Quantity_On_Hand when ordering a product (Order_Quantity).
DROP TRIGGER IF EXISTS after_order_insert_update_quantity;
DELIMITER //
CREATE TRIGGER after_order_insert_update_quantity
AFTER INSERT ON salesorderdetails
FOR EACH ROW
BEGIN
    UPDATE product
    SET Quantity_On_Hand = Quantity_On_Hand + NEW.Order_Quantity
    WHERE product_number = NEW.product_number;
END;
//
DELIMITER ;

INSERT INTO salesorderdetails (order_number, product_number, Order_Quantity)
VALUES ('O20010', 'P1004', 7);

-- Functions

-- 1. Find the average salesman's salary.
DROP FUNCTION IF EXISTS average_salesman_salary;
DELIMITER //
CREATE FUNCTION average_salesman_salary() 
RETURNS DECIMAL(15,4)
DETERMINISTIC
BEGIN 
    DECLARE avg_salary DECIMAL(15,4);
    SELECT AVG(salary) INTO avg_salary FROM salesman;
    RETURN avg_salary;
END;
//
DELIMITER ;

-- 2. Find the name of the highest paid salesman.
DROP FUNCTION IF EXISTS highest_paid_salesman;
DELIMITER //
CREATE FUNCTION highest_paid_salesman() 
RETURNS VARCHAR(25)
DETERMINISTIC
BEGIN 
    DECLARE salesman_name_var VARCHAR(25);
    SELECT salesman_name INTO salesman_name_var FROM salesman WHERE salary IN (SELECT MAX(salary) FROM salesman) LIMIT 1;
    RETURN salesman_name_var;
END;
//
DELIMITER ;
SELECT highest_paid_salesman() AS highest_paid;

-- 3. Find the name of the salesman who is paid the lowest salary.
DROP FUNCTION IF EXISTS lowest_paid_salesman;
DELIMITER //
CREATE FUNCTION lowest_paid_salesman() 
RETURNS VARCHAR(25)
DETERMINISTIC
BEGIN 
    DECLARE salesman_name_var VARCHAR(25);
    SELECT salesman_name INTO salesman_name_var FROM salesman WHERE salary IN (SELECT MIN(salary) FROM salesman) LIMIT 1;
    RETURN salesman_name_var;
END;
//
DELIMITER ;
SELECT lowest_paid_salesman() AS lowest_paid;

-- 4. Determine the total number of salespeople employed by the company.
DROP FUNCTION IF EXISTS total_number_salesman;
DELIMITER //
CREATE FUNCTION total_number_salesman() 
RETURNS INT
DETERMINISTIC
BEGIN 
    DECLARE total_number_salesman INT;
    SELECT COUNT(Salesman_Number) INTO total_number_salesman FROM salesman;
    RETURN total_number_salesman;
END;
//
DELIMITER ;
SELECT total_number_salesman() AS total_salesmen;

-- 5. Compute the total salary paid to the company's salesman.
DROP FUNCTION IF EXISTS total_salary_salesman;
DELIMITER //
CREATE FUNCTION total_salary_salesman() 
RETURNS DECIMAL(15,4)
DETERMINISTIC
BEGIN 
    DECLARE total_salary_salesman DECIMAL(15,4);
    SELECT SUM(salary) INTO total_salary_salesman FROM salesman;
    RETURN total_salary_salesman;
END;
//
DELIMITER ;
SELECT total_salary_salesman() AS total_salary;

-- 6. Find Clients in a Province
DROP FUNCTION IF EXISTS find_client_by_province;
DELIMITER //
CREATE FUNCTION find_client_by_province(province_name CHAR(25)) 
RETURNS varchar(500)
DETERMINISTIC
BEGIN 
  declare total_salary_salesman varchar(500);
  select group_concat((client_name) separator ', ') into total_salary_salesman
  from clients
  where province = province_name;
  return total_salary_salesman;
END;
//
DELIMITER ;
SELECT find_client_by_province("Hanoi") as clients;	

-- 7. Calculate Total Sales
DROP FUNCTION IF EXISTS calculate_total_sales;
DELIMITER //
CREATE FUNCTION calculate_total_sales() 
RETURNS INT
DETERMINISTIC
BEGIN 
    DECLARE total_sales INT;
    SELECT SUM(salesman_number) INTO total_sales FROM salesorder;
    RETURN total_sales;
END;
//
DELIMITER ;

-- 8. Calculate Total Order Amount
DROP FUNCTION IF EXISTS calculate_total_order;
DELIMITER //
CREATE FUNCTION calculate_total_order() 
RETURNS INT
DETERMINISTIC
BEGIN 
    DECLARE total_sales INT;
    SELECT SUM(order_quantity) INTO total_sales FROM salesorderdetails;
    RETURN total_sales;
END;
//
DELIMITER ;