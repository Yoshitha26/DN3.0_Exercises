DELIMITER //

-- Trigger to Automatically Update LastModified Date When a Customer's Record is Updated

CREATE TRIGGER UpdateCustomerLastModified
BEFORE UPDATE ON Customers
FOR EACH ROW
BEGIN
    -- Update the LastModified column to the current date
    SET NEW.LastModified = CURDATE();
END //


-- Trigger to Maintain an Audit Log for All Transactions
CREATE TRIGGER LogTransactionAudit
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    -- Log the details of the new transaction into the AuditLog table
    INSERT INTO AuditLog (TransactionID, TransactionDate, AccountID, Amount, TransactionType)
    VALUES (NEW.TransactionID, NEW.TransactionDate, NEW.AccountID, NEW.Amount, 'INSERT');
END //

-- Trigger to Enforce Business Rules on Deposits and Withdrawals
CREATE TRIGGER ValidateTransactionRules
BEFORE INSERT ON Transactions
FOR EACH ROW
BEGIN

    -- Check if the transaction type is withdrawal and ensure it does not exceed the balance
    
    IF NEW.TransactionType = 'WITHDRAWAL' THEN
    BEGIN
        DECLARE currentBalance DECIMAL(15,2);
        
        -- Retrieve the current balance of the account
        SELECT Balance INTO currentBalance
        FROM Accounts
        WHERE AccountID = NEW.AccountID;
        
        -- Ensure the withdrawal does not exceed the balance
        IF NEW.Amount > currentBalance THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient funds for withdrawal.';
        END IF;
        END;
    END IF;
    
    
    
    -- Check if the transaction type is deposit and ensure the deposit amount is positive
    
    IF NEW.TransactionType = 'DEPOSIT' THEN
        IF NEW.Amount <= 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Deposit amount must be positive.';
        END IF;
    END IF;
    
END //

DELIMITER ;
