DELIMITER //

-- Procedure to Apply Interest Discount to Customers Above 60 Years Old

CREATE PROCEDURE ApplyInterestDiscount()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur_CustomerID INT;
    DECLARE cur_DOB DATE;
    DECLARE currentDATE DATE;
    SET currentDATE = CURDATE();
    BEGIN
    DECLARE cur CURSOR FOR SELECT CustomerID, DOB FROM Customers;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO cur_CustomerID, cur_DOB;
        IF done THEN
            LEAVE read_loop;
        END IF;
        IF TIMESTAMPDIFF(YEAR, cur_DOB, currentDATE) > 60 THEN
            UPDATE Loans
            SET InterestRate = InterestRate * 0.99
            WHERE CustomerID = cur_CustomerID;
        END IF;
    END LOOP;

    CLOSE cur;
    END;
END //

-- Procedure to Promote Customers to VIP Status Based on Balance
CREATE PROCEDURE PromoteToVIP()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur_CustomerID INT;
    DECLARE cur_Balance DECIMAL(10,2);
    BEGIN
    DECLARE cur CURSOR FOR SELECT CustomerID, Balance FROM Accounts;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO cur_CustomerID, cur_Balance;
        IF done THEN
            LEAVE read_loop;
        END IF;

        IF cur_Balance > 10000 THEN
            UPDATE Customers
            SET IsVIP = TRUE
            WHERE CustomerID = cur_CustomerID;
        END IF;
    END LOOP;

    CLOSE cur;
    END;
END //


-- Procedure to Send Loan Reminders for Loans Due Within the Next 30 Days
CREATE PROCEDURE SendLoanReminders()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur_CustomerID INT;
    DECLARE cur_DueDate DATE;
    DECLARE currentDATE DATE;
    
    SET currentDATE = CURDATE();
    BEGIN
    DECLARE cur CURSOR FOR SELECT CustomerID, cur_DueDate FROM Loans WHERE cur_DueDate BETWEEN currentDATE AND DATE_ADD(currentDATE, INTERVAL 30 DAY);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO cur_CustomerID, cur_DueDate;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT CONCAT('Reminder: Loan due on ', cur_DueDate, ' for CustomerID: ', cur_CustomerID) AS ReminderMessage;
    END LOOP;

    CLOSE cur;
    END;
END //


-- Procedure to Handle Exceptions During Fund Transfers Between Accounts
CREATE PROCEDURE SafeTransferFunds(
    IN fromAccountID INT,
    IN toAccountID INT,
    IN amount DECIMAL(10,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Log any SQL error
        INSERT INTO ErrorLogs (ErrorMessage, ErrorDate) 
        VALUES (CONCAT('SQL Error during transfer from AccountID: ', fromAccountID, ' to AccountID: ', toAccountID), NOW());
        -- Rollback transaction
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Check if the from account has enough balance
    IF (SELECT Balance FROM Accounts WHERE AccountID = fromAccountID) < amount THEN
        -- Log error message
        INSERT INTO ErrorLogs (ErrorMessage, ErrorDate) 
        VALUES (CONCAT('Insufficient funds for transfer from AccountID: ', fromAccountID), NOW());
        -- Rollback transaction
        ROLLBACK;
    ELSE
        -- Deduct amount from fromAccount
        UPDATE Accounts SET Balance = Balance - amount WHERE AccountID = fromAccountID;

        -- Add amount to toAccount
        UPDATE Accounts SET Balance = Balance + amount WHERE AccountID = toAccountID;

        COMMIT;
    END IF;
END //



-- Procedure to Manage Errors When Updating Employee Salaries
CREATE PROCEDURE UpdateSalary(
    IN empID INT,
    IN percentageIncrease DECIMAL(5,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Log error message
        INSERT INTO ErrorLogs (ErrorMessage, ErrorDate) 
        VALUES (CONCAT('Error updating salary for EmployeeID: ', empID), NOW());
        -- Rollback transaction
        ROLLBACK;
    END;

    START TRANSACTION;
    -- Updating the salary
    UPDATE Employees 
    SET Salary = Salary + (Salary * (percentageIncrease / 100))
    WHERE EmployeeID = empID;
    -- Check if the update affected any row
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee ID does not exist';
    END IF;

    COMMIT;
END //

-- Procedure to Ensure Data Integrity When Adding a New Customer
CREATE PROCEDURE AddNewCustomer(
    IN newCustomerID INT,
    IN newCustomerName VARCHAR(100),
    IN newCustomerDOB DATE
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Log error message
        Create table ErrorLogs(ErrorID INT AUTO_INCREMENT PRIMARY KEY,
    ErrorMessage VARCHAR(255) NOT NULL,
    ErrorDate DATETIME NOT NULL);
        INSERT INTO ErrorLogs (ErrorMessage, ErrorDate) 
        VALUES (CONCAT('Error adding new customer with CustomerID: ', newCustomerID), NOW());
        -- Rollback transaction
        ROLLBACK;
    END;

    START TRANSACTION;
    -- Insert new customer
    INSERT INTO Customers (CustomerID, Name, DOB) 
    VALUES (newCustomerID, newCustomerName, newCustomerDOB);

    COMMIT;
END //

DELIMITER ;
-- Calling  the procedures
CALL ApplyInterestDiscount();
CALL PromoteToVIP();
CALL SendLoanReminders();
CALL SafeTransferFunds(2, 2, 500.00); 
CALL UpdateSalary(1, 10.00); 
CALL AddNewCustomer(1, 'sakshi', '1991-06-02'); 
