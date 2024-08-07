DELIMITER //

-- Procedure to Process Monthly Interest for All Savings Accounts
CREATE PROCEDURE ApplyMonthlyInterest()
BEGIN
    -- Update balance for all savings accounts by applying an interest rate of 1%
    UPDATE Accounts
    SET Balance = Balance * 1.01
    WHERE AccountType = 'Savings';
END //

-- Procedure to Update Employee Bonus Based on Performance
CREATE PROCEDURE AdjustEmployeeBonus(
    IN deptID INT,
    IN bonusRate DECIMAL(5,2)
)
BEGIN
    -- Update the salary of employees in the specified department by adding the bonus percentage
    UPDATE Employees
    SET Salary = Salary + (Salary * (bonusRate / 100))
    WHERE DepartmentID = deptID;
END //

-- Procedure to Transfer Funds Between Accounts
CREATE PROCEDURE MoveFunds(
    IN sourceAccountID INT,
    IN targetAccountID INT,
    IN transferAmount DECIMAL(10,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Log any SQL error
        INSERT INTO ErrorLogs (ErrorMessage, ErrorDate) 
        VALUES (CONCAT('SQL Error during transfer from AccountID: ', sourceAccountID, ' to AccountID: ', targetAccountID), NOW());
        -- Rollback transaction
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Check if the source account has enough balance
    IF (SELECT Balance FROM Accounts WHERE AccountID = sourceAccountID) < transferAmount THEN
        -- Log insufficient funds error
        INSERT INTO ErrorLogs (ErrorMessage, ErrorDate) 
        VALUES (CONCAT('Insufficient funds for transfer from AccountID: ', sourceAccountID), NOW());
        -- Rollback transaction
        ROLLBACK;
    ELSE
        -- Deduct amount from the source account
        UPDATE Accounts SET Balance = Balance - transferAmount WHERE AccountID = sourceAccountID;

        -- Add amount to the destination account
        UPDATE Accounts SET Balance = Balance + transferAmount WHERE AccountID = targetAccountID;

        COMMIT;
    END IF;
END //

DELIMITER ;
