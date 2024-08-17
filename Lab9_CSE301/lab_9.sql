use humanresourcesmanagement;

-- II. Creating constraint for database:
-- 1. Check constraint to value of gender in “Nam” or “Nu”.
alter table employees add constraint chk_gender check (gender in ("Nam","Nu"));
-- 2. Check constraint to value of salary > 0.
alter table employees add constraint chk_salary check (salary > 0);
-- 3. Check constraint to value of relationship in Relative table in “Vo chong”, “Con trai”, “Con
-- gai”, “Me ruot”, “Cha ruot”.
alter table relative add constraint chk_relationship check (relationship in ("Vo chong", "Con trai", "Con gai", "Me ruot", "Cha ruot"));

-- III. Writing SQL Queries.
-- 1. Look for employees with salaries above 25,000 in room 4 or employees with salaries above
-- 30,000 in room 5.
select * from employees where salary > 25000 and departmentID = 4 or salary > 30000 and departmentID = 5;

-- 2. Provide full names of employees in HCM city.
select concat(lastname, " ", middlename, " ", firstname) as full_name from employees where address like "%TPHCM%";

-- 3. Indicate the date of birth of Dinh Ba Tien staff.
 select dateOfbirth from employees where concat(lastname, " ", middlename, " ", firstname) = "Dinh Ba Tien";
 
-- 4. The names of the employees of Room 5 are involved in the "San pham X" project and this
-- employee is directly managed by "Nguyen Thanh Tung".
select concat(lastname, " ", middlename, " ", firstname) as full_name from employees e 
join assignment a on e.employeeID = a.employeeID
join projects p on a.projectID = p.projectID
where e.departmentID = 5 
and projectName = "San pham X" 
and managerID in (select employeeID from employees 
				where concat(lastname, " ", middlename, " ", firstname) = "Nguyen Thanh Tung");

-- 5. Find the names of department heads of each department.
select departmentName, concat(lastname, " ", middlename, " ", firstname) as department_head from 
employees e join department d on d.managerID = e.employeeID;

-- 6. Find projectID, projectName, projectAddress, departmentID, departmentName,
-- departmentID, date0fEmployment.
select p.projectID, projectName, projectAddress, d.departmentID, departmentName, dateOfEmployment from department d
join projects p on p.departmentID = d.departmentID;

-- 7. Find the names of female employees and their relatives.
select concat(lastname, " ", middlename, " ", firstname) as full_name, relativeName from employees e
left join relative r on r.employeeID = e.employeeID
where e.gender = "Nu"; 

-- 8. For all projects in "Hanoi", list the project code (projectID), the code of the project lead
-- department (departmentID), the full name of the manager (lastName, middleName,
-- firstName) as well as the address (Address) and date of birth (date0fBirth) of the
-- Employees.
select p.projectID, d.departmentID, concat(m.lastname, " ", m.middlename, " ", m.firstname) as full_name, e.address, e.dateofbirth from projects p
join department d on p.departmentID = d.departmentID	
join employees e on e.departmentID = d.departmentID
join employees m on e.managerID = m.employeeID
where projectAddress = "HA NOI";

-- 9. For each employee, include the employee's full name and the employee's line manager.
select concat(e.lastname, " ", e.middlename, " ", e.firstname) as full_name_employees, 
		concat(m.lastname, " ", m.middlename, " ", m.firstname) as full_name_managers from employees e
left join employees m on e.managerID = m.employeeID;

-- 10. For each employee, indicate the employee's full name and the full name of the head of the
-- department in which the employee works.
select concat(e.lastname, " ", e.middlename, " ", e.firstname) as full_name_employees, 
		concat(e2.lastname, " ", e2.middlename, " ", e2.firstname) as full_name_employees from employees e
join department d on d.departmentID = e.departmentID
left join employees e2 on  d.managerID = e2.employeeID;

-- 11. Provide the employee's full name (lastName, middleName, firstName) and the names of
-- the projects in which the employee participated, if any.
SELECT CONCAT(e.lastname, " ", e.middlename, " ", e.firstname) AS full_name_employees, 
       p.projectName 
FROM employees e
LEFT JOIN assignment a ON e.employeeID = a.employeeID
LEFT JOIN projects p ON a.projectID = p.projectID;

-- 12. For each scheme, list the scheme name (projectName) and the total number of hours
-- worked per week of all employees attending that scheme.
select projectName, sum(workingHour) as workingHour from assignment a
join projects p on p.projectID = a.projectID
group by projectName;

-- 13. For each department, list the name of the department (departmentName) and the average
-- salary of the employees who work for that department.
select departmentname, avg(salary) from department d
join employees e on e.departmentID = d.departmentID
group by departmentname
;

-- 14. For departments with an average salary above 30,000, list the name of the department and
-- the number of employees of that department.
select departmentname, count(employeeID) numEmployees from department d
join employees e on e.departmentID = d.departmentID
group by departmentname
having  avg(salary) > 30000
;

-- 15. Indicate the list of schemes (projectID) that has: workers with them (lastName) as 'Dinh'
-- or, whose head of department presides over the scheme with them (lastName) as 'Dinh'.
select p.projectID from employees e
join assignment a on a.employeeID = e.employeeID
join projects p on p.projectID = a.projectID
where e.lastName = "Dinh"
or p.departmentID in (select departmentID from department where managerid in (select employeeID from employees where lastName = "Dinh"));

-- 16. List of employees (lastName, middleName, firstName) with more than 2 relatives.
select concat(e.lastname, " ", e.middlename, " ", e.firstname) as full_name_employees, count(e.employeeID) numRelatives from employees e 
join relative r on r.employeeID = e.employeeID
group by e.employeeID
having numRelatives > 2;

-- 17. List of employees (lastName, middleName, firstName) without any relatives.
select concat(e.lastname, " ", e.middlename, " ", e.firstname) as full_name_employees from employees e 
left join relative r on e.employeeID = r.employeeID
where r.employeeID is null;

-- 18. List of department heads (lastName, middleName, firstName) with at least one relative.
select concat(e.lastname, " ", e.middlename, " ", e.firstname) fullname from employees e
join (select managerID from department d
join (
	select employeeID, count(*) countR from relative
	group by employeeID
	having countR >= 1) R
on R.employeeID = d.managerID) S 
on S.managerID = e.employeeID
;

-- 19. Find the surname (lastName) of unmarried department heads.
select e2.lastname from employees e2
join department d on d.managerID = e2.employeeID
where not exists (select 1 from relative r where r.employeeID = e2.employeeID
and relationship = "Vo chong")
;

-- 20. Indicate the full name of the employee (lastName, middleName, firstName) whose salary
-- is above the average salary of the "Research" department.
select concat(e.lastname, " ", e.middlename, " ", e.firstname) fullname from employees e
where salary > (select avg(salary) from employees e
join department d on d.departmentID = e.departmentID
where departmentName = "Nghien cuu")
;

-- 21. Indicate the name of the department and the full name of the head of the department with
-- the largest number of employees.
select departmentName, concat(e.lastname, " ", e.middlename, " ", e.firstname) fullname from employees e
join department d on e.employeeID = d.managerID
join (select managerID, count(employeeID) numEm from employees
where managerID is not null
group by managerID
order by numEm desc
limit 1) R
on R.managerID = e.employeeID
;

-- 22. Find the full names (lastName, middleName, firstName) and addresses (Address) of
-- employees who work on a project in 'HCMC' but the department they belong to is not
-- located in 'HCMC'.
select concat(e.lastname, " ", e.middlename, " ", e.firstname) fullname, e.address from employees e
join assignment a on a.employeeID = e.employeeID
join projects p on p.projectID = a.projectID
join departmentaddress da on da.departmentID = p.departmentID
where projectAddress like "%HCM%"
and da.address not like "%HCM%";

-- 23. Find the names and addresses of employees who work on a scheme in a city but the
-- department to which they belong is not located in that city.
select distinct concat(e.lastname, " ", e.middlename, " ", e.firstname) fullname, e.address from employees e
join assignment a on a.employeeID = e.employeeID
join projects p on p.projectID = a.projectID
join department d on d.departmentID = e.departmentID
join departmentaddress da on da.departmentID = d.departmentID
where da.address <> projectAddress;

-- 24. Create procedure List employee information by department with input data
-- departmentName.

Delimiter $$
create procedure ListEmployeesByDepartment(dName varchar(10))
	begin
		select e.* from employees e
		join department d on d.departmentID = e.departmentID
		where departmentName = dName;
    end; 
$$
Delimiter ;
call ListEmployeesByDepartment("Nghien cuu");

-- 25. Create a procedure to Search for projects that an employee participates in based on the
-- employee's last name (lastName).
Delimiter $$
create procedure ListProjectsByEmLastName(lastNameInit varchar(10))
	begin
		select p.* from projects p
		join assignment a on a.projectID = p.projectID
		join employees e on e.employeeID = a.employeeID
		where e.lastName = lastNameInit;
    end; 
$$
Delimiter ;
call ListProjectsByEmLastName("Dinh");

-- 26. Create a function to calculate the average salary of a department with input data
-- departmentID.


Delimiter $$
create function calculateAvg(departmentIDInit int)
returns decimal(15,4)
deterministic
	begin
		declare avgSalary decimal(15,4);
        select avg(salary) into avgSalary from employees
		where departmentID = departmentIDInit;
		return avgSalary;
    end;
$$ 
Delimiter ;

-- 27. Create a function to Check if an employee is involved in a particular project input data is
	-- employeeID, projectID.
Delimiter $$
drop function isExistEmployeeByProjectID;
create function isExistEmployeeByProjectID(employeeIDInit varchar(3), projectIDInit int)
returns boolean
deterministic
	begin
		declare flag int;
		select a.projectID into flag from employees e
		left join assignment a on e.employeeID = a.employeeID
		where e.employeeID = employeeIDInit and a.projectID = projectIDInit;
        if flag > 0 then
			return true;
		else
			return false;
		end if;
    end;
$$ 
Delimiter ;
select isExistEmployeeByProjectID(123, 1); -- 1 means TRUE
select isExistEmployeeByProjectID(123, 6); -- 0 means FALSE

     