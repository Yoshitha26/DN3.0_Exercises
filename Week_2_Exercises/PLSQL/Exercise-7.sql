DELIMITER //

-- Package for Customer Management

-- Procedure to Add a New Customer
CREATE PROCEDURE AddCustomer(IN p_CustomerID INT, IN p_Name VARCHAR(100), IN p_DOB DATE, IN p_Balance DECIMAL(10, 2))
BEGIN
    INSERT INTO Customers (CustomerID, Name, DOB) VALUES (p_CustomerID, p_Name, p_DOB);
    INSERT INTO Accounts (CustomerID, Balance) VALUES (p_CustomerID, p_Balance);
END //

-- Procedure to Update Customer Details
CREATE PROCEDURE UpdateCustomerDetails(IN p_CustomerID INT, IN p_Name VARCHAR(100), IN p_DOB DATE)
BEGIN
    UPDATE Customers
    SET Name = p_Name, DOB = p_DOB
    WHERE CustomerID = p_CustomerID;
END //

-- Function to Get Customer Balance
CREATE FUNCTION GetCustomerBalance(p_CustomerID INT) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE customer_balance DECIMAL(10, 2);
    SELECT Balance INTO customer_balance
    FROM Accounts
    WHERE CustomerID = p_CustomerID;
    
    RETURN customer_balance;
END //

-- Package for Employee Management

-- Procedure to Hire a New Employee
CREATE PROCEDURE HireEmployee(IN p_EmployeeID INT, IN p_Name VARCHAR(100), IN p_Position VARCHAR(100), IN p_Salary DECIMAL(10, 2))
BEGIN
    INSERT INTO Employees (EmployeeID, Name, Position, Salary) VALUES (p_EmployeeID, p_Name, p_Position, p_Salary);
END //

-- Procedure to Update Employee Details
CREATE PROCEDURE UpdateEmployeeDetails(IN p_EmployeeID INT, IN p_Name VARCHAR(100), IN p_Position VARCHAR(100), IN p_Salary DECIMAL(10, 2))
BEGIN
    UPDATE Employees
    SET Name = p_Name, Position = p_Position, Salary = p_Salary
    WHERE EmployeeID = p_EmployeeID;
END //

-- Function to Calculate Annual Salary of an Employee
CREATE FUNCTION CalculateAnnualSalary(p_EmployeeID INT) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE annual_salary DECIMAL(10, 2);
    SELECT Salary * 12 INTO annual_salary
    FROM Employees
    WHERE EmployeeID = p_EmployeeID;
    
    RETURN annual_salary;
END //

-- Package for Account Operations

-- Procedure to Open a New Account
CREATE PROCEDURE OpenAccount(IN p_CustomerID INT, IN p_Balance DECIMAL(10, 2))
BEGIN
    INSERT INTO Accounts (CustomerID, Balance) VALUES (p_CustomerID, p_Balance);
END //

-- Procedure to Close an Account
CREATE PROCEDURE CloseAccount(IN p_CustomerID INT)
BEGIN
    DELETE FROM Accounts
    WHERE CustomerID = p_CustomerID;
END //

-- Function to Get Total Balance of a Customer
CREATE FUNCTION GetTotalBalance(p_CustomerID INT) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_balance DECIMAL(10, 2);
    SELECT SUM(Balance) INTO total_balance
    FROM Accounts
    WHERE CustomerID = p_CustomerID;
    
    RETURN total_balance;
END //

DELIMITER ;
