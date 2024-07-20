drop database if exists HumanResourcesManagement;
create database HumanResourcesManagement;
USE HumanResourcesManagement;

-- Create DEPARTMENT table
CREATE TABLE DEPARTMENT (
    departmentID INT PRIMARY KEY,
    departmentName VARCHAR(10) NOT NULL,
    managerID VARCHAR(3),
    dateOfEmployment DATE NOT NULL
);
-- Create EMPLOYEES table
CREATE TABLE EMPLOYEES (
    employeeID VARCHAR(3) PRIMARY KEY,
    lastName VARCHAR(20) NOT NULL,
    middleName VARCHAR(20),
    firstName VARCHAR(20) NOT NULL,
    dateOfBirth DATE NOT NULL,
    gender VARCHAR(5) NOT NULL,
    salary DECIMAL(15, 2) NOT NULL,
    address VARCHAR(100) NOT NULL,
    managerID VARCHAR(3),
    departmentID INT
 --    FOREIGN KEY (managerID) REFERENCES EMPLOYEES(employeeID),
--     FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID)
);

INSERT INTO EMPLOYEES (employeeID, lastName, middleName, firstName, dateOfBirth, gender, salary, address, managerID, departmentID) VALUES
('123', 'Nguyen', 'Ba', 'An', STR_TO_DATE('01/09/1995', '%m/%d/%Y'), 'Nam', 30000.00, '731 Tran Hung Dao', '333', 5),
('333', 'Nguyen', 'Thanh', 'Tung', STR_TO_DATE('12/08/1945', '%m/%d/%Y'), 'Nam', 40000.00, '638 Nguyen Van Cu', '888', 5),
('453', 'Tran', 'Thanh', 'Tam', STR_TO_DATE('07/31/1962', '%m/%d/%Y'), 'Nam', 25000.00, '543 Mai Thi Luu Ba Dinh Ha Noi', '333', 5),
('666', 'Nguyen', 'Manh', 'Hung', STR_TO_DATE('09/15/1952', '%m/%d/%Y'), 'Nam', 38000.00, '975 Le Lai P3 Vung Tau', '333', 5),
('777', 'Tran', 'Hong', 'Quang', STR_TO_DATE('03/29/1959', '%m/%d/%Y'), 'Nam', 25000.00, '980 Le Hong Phong Vung Tau', '987', 4),
('888', 'Vuong', 'Ngoc', 'Quyen', STR_TO_DATE('10/10/1927', '%m/%d/%Y'), 'Nu', 55000.00, '450 Trung Vuong My Tho TG', NULL, 1),
('987', 'Le', 'Thi', 'Nhan', STR_TO_DATE('06/20/1931', '%m/%d/%Y'), 'Nu', 43000.00, '291 Ho Van Hue Q.PN TPHCM', '888', 4),
('999', 'Bui', 'Thuy', 'Vu', STR_TO_DATE('07/19/1958', '%m/%d/%Y'), 'Nam', 25000.00, '332 Nguyen Thai Hoc Quy Nhon', '987', 4);

-- Insert data into DEPARTMENT table
INSERT INTO DEPARTMENT (departmentID, departmentName, managerID, dateOfEmployment) VALUES
(1, 'Quan ly', '888', STR_TO_DATE('06/19/1971', '%m/%d/%Y')),
(4, 'Dieu hanh', '777', STR_TO_DATE('01/01/1985', '%m/%d/%Y')),
(5, 'Nghien cuu', '333', STR_TO_DATE('05/22/1978', '%m/%d/%Y'));

ALTER TABLE EMPLOYEES
ADD FOREIGN KEY (managerID) REFERENCES EMPLOYEES(employeeID),
ADD FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID);

ALTER TABLE DEPARTMENT
ADD FOREIGN KEY (managerID) REFERENCES EMPLOYEES(employeeID);

-- Create DEPARTMENTADDRESS table
CREATE TABLE DEPARTMENTADDRESS (
    departmentID INT,
    address VARCHAR(30),
    PRIMARY KEY (departmentID, address),
    FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID)
);

-- Create PROJECTS table
CREATE TABLE PROJECTS (
    projectID INT PRIMARY KEY,
    projectName VARCHAR(30) NOT NULL,
    projectAddress VARCHAR(100) NOT NULL,
    departmentID INT,
    FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID)
);

-- Create ASSIGNMENT table
CREATE TABLE ASSIGNMENT (
    employeeID VARCHAR(3),
    projectID INT,
    workingHour FLOAT NOT NULL,
    PRIMARY KEY (employeeID, projectID),
    FOREIGN KEY (employeeID) REFERENCES EMPLOYEES(employeeID),
    FOREIGN KEY (projectID) REFERENCES PROJECTS(projectID)
);

-- Create RELATIVE table
CREATE TABLE RELATIVE (
    employeeID VARCHAR(3),
    relativeName VARCHAR(50),
    gender VARCHAR(5) NOT NULL,
    dateOfBirth DATE,
    relationship VARCHAR(30) NOT NULL,
    PRIMARY KEY (employeeID, relativeName),
    FOREIGN KEY (employeeID) REFERENCES EMPLOYEES(employeeID)
);

-- Insert data into DEPARTMENTADDRESS table
INSERT INTO DEPARTMENTADDRESS (departmentID, address) VALUES
(1, 'TP HCM'),
(4, 'HA NOI'),
(5, 'NHA TRANG'),
(5, 'TP HCM'),
(5, 'VUNG TAU');

-- Insert data into PROJECTS table
INSERT INTO PROJECTS (projectID, projectName, projectAddress, departmentID) VALUES
(1, 'San pham X', 'VUNG TAU', 5),
(2, 'San pham Y', 'NHA TRANG', 5),
(3, 'San pham Z', 'TP HCM', 5),
(10, 'Tin hoc hoa', 'HA NOI', 4),
(20, 'Cap Quang', 'TP HCM', 1),
(30, 'Dao tao', 'HA NOI', 4);

-- Insert data into ASSIGNMENT table
INSERT INTO ASSIGNMENT (employeeID, projectID, workingHour) VALUES
(123, 1, 22.5),
(123, 2, 7.5),
(123, 3, 10),
(333, 10, 10),
(333, 20, 10),
(453, 1, 20),
(453, 2, 20),
(666, 3, 40),
(888, 20, 0),
(987, 20, 15);

-- Insert data into RELATIVE table
INSERT INTO RELATIVE (employeeID, relativeName, gender, dateOfBirth, relationship) VALUES
	('123', 'Chau', 'Nu', STR_TO_DATE('12/31/1978', '%m/%d/%Y'), 'Con gai'),
	('123', 'Duy', 'Nam', STR_TO_DATE('01/01/1978', '%m/%d/%Y'), 'Con trai'),
	('123', 'Phuong', 'Nu', STR_TO_DATE('05/05/1957', '%m/%d/%Y'), 'Vo chong'),
	('333', 'Duong', 'Nu', STR_TO_DATE('05/03/1948', '%m/%d/%Y'), 'Vo chong'),
	('333', 'Quang', 'Nu', STR_TO_DATE('04/05/1976', '%m/%d/%Y'), 'Con gai'),
	('333', 'Tung', 'Nam', STR_TO_DATE('10/25/1973', '%m/%d/%Y'), 'Con trai'),
	('987', 'Dang', 'Nam', STR_TO_DATE('02/29/1932', '%m/%d/%Y'), 'Vo chong');

-- Show the schema of all tables
DESCRIBE EMPLOYEES;
DESCRIBE DEPARTMENT;
DESCRIBE DEPARTMENTADDRESS;
DESCRIBE PROJECTS;
DESCRIBE ASSIGNMENT;
DESCRIBE RELATIVE;

-- Display the content of all tables
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENT;
SELECT * FROM DEPARTMENTADDRESS;
SELECT * FROM PROJECTS;
SELECT * FROM ASSIGNMENT;
SELECT * FROM RELATIVE;

