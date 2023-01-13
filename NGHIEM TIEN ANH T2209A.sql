CREATE DATABASE EmployeeDB
GO
USE EmployeeDB
GO
CREATE TABLE Department (
	DepertId INT PRIMARY KEY,
	DeperName VARCHAR(50) NOT NULL,
	Description VARCHAR(100) NOT NULL
);

CREATE TABLE Employee (
	EmpCode CHAR(6) PRIMARY KEY,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Birthday SMALLDATETIME NOT NULL,
	Gender BIT DEFAULT 1,
	Address VARCHAR(100),
	DepartID INT,
	Salary MONEY,
	FOREIGN KEY (DepartID) REFERENCES Department(DepertID)
);

INSERT INTO Department (DepertId, DeperName, Description) VALUES (1, 'IT', 'Information Technology');
INSERT INTO Department (DepertId, DeperName, Description) VALUES (2, 'HR', 'Human Resources');
INSERT INTO Department (DepertId, DeperName, Description) VALUES (3, 'Finance', 'Finance and Accounting');

INSERT INTO Employee (EmpCode, FirstName, LastName, Birthday, Gender, Address, DepartID, Salary) VALUES ('E001', 'John', 'Doe', '1990-01-01', 1, '123 Main St', 1, 50000);
INSERT INTO Employee (EmpCode, FirstName, LastName, Birthday, Gender, Address, DepartID, Salary) VALUES ('E002', 'Jane', 'Smith', '1992-03-15', 0, '456 Park Ave', 2, 55000);
INSERT INTO Employee (empCode, FirstName, LastName, Birthday, Gender, Address, DepartID, Salary) VALUES ('E003', 'Bob', 'Johnson', '1995-05-20', 1, '789 Elm St', 3, 60000);

--Tang salary cho nhan vien len 10%

UPDATE Employee SET Salary = Salary * 1.1;

--Them rang buoc cho luong cua nhan vien luon > 0
ALTER TABLE Employee ADD CHECK (Salary > 0);
--4
CREATE TRIGGER tg_chkBirthday
ON Employee
AFTER INSERT, UPDATE
AS
BEGIN 
IF EXISTS (SELECT 1 FROM inserted WHERE Birthday <= 23)
BEGIN
RAISERROR ('Value of birthday colum must be greater than 23', 16, 1);
ROLLBACK TRANSACTION;
END
END

--5
CREATE UNIQUE INDEX IX_DepartmentName
ON Department (DeperName)
--Create a view to display employee’s code, full name and department name of all employees
SELECT Department.DeperName, Employee.EmpCode, Employee.FirstName, Employee.LastName FROM Department INNER JOIN Employee ON Department.DepertID = Employee.DepartID;
--7 To create a stored procedure named "sp_getAllEmp" that accepts a department ID as an input parameter and displays all employees in that department, you can use the following SQL code
create procedure sp_getAllEmp(@departId int)
as
	begin
		select * 
		from employee
		where departId = @departId
	end
go
--8 Create a stored procedure named sp_delDept that accepts employee Id as given input parameter to delete an employee
create proc sp_delDept @EmpCode char(6)
as
BEGIN
DELETE FROM Employee 
WHERE EmpCode=@EmpCode
end

exec sp_getAllEmp 03