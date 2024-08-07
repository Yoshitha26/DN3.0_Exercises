DELIMITER //

-- Procedure to Generate Monthly Statements for All Customers

CREATE PROCEDURE GenerateMonthlyStatements()
BEGIN
    -- Declare cursor and variables
    DECLARE done INT DEFAULT FALSE;
    DECLARE cust_id INT;
    DECLARE trans_date DATE;
    DECLARE trans_amount DECIMAL(10,2);
    DECLARE trans_description VARCHAR(255);
    
    -- Declare cursor for fetching monthly transaction details
    
    DECLARE monthly_cursor CURSOR FOR
        SELECT CustomerID, TransactionDate, Amount, Description
        FROM Transactions
        WHERE MONTH(TransactionDate) = MONTH(CURDATE())
          AND YEAR(TransactionDate) = YEAR(CURDATE());
    
    -- Declare NOT FOUND handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Open cursor and process statements
    OPEN monthly_cursor;
    read_loop: LOOP
        FETCH monthly_cursor INTO cust_id, trans_date, trans_amount, trans_description;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT('CustomerID: ', cust_id, ', Date: ', trans_date,
                      ', Amount: ', trans_amount, ', Description: ', trans_description) AS Statement;
    END LOOP;
    CLOSE monthly_cursor;
END //

-- Procedure to Apply Annual Fee to All Accounts
CREATE PROCEDURE ApplyAnnualFee()
BEGIN
    -- Declare cursor and variables
    DECLARE done INT DEFAULT FALSE;
    DECLARE acc_id INT;
    DECLARE acc_balance DECIMAL(10,2);
    DECLARE annual_fee DECIMAL(10,2) DEFAULT 50.00;  -- Example annual fee amount
    
    -- Declare cursor for fetching account details
    DECLARE accounts_cursor CURSOR FOR
        SELECT AccountID, Balance
        FROM Accounts;
    
    -- Declare NOT FOUND handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Open cursor and apply annual fee
    OPEN accounts_cursor;
    read_loop: LOOP
        FETCH accounts_cursor INTO acc_id, acc_balance;
        IF done THEN
            LEAVE read_loop;
        END IF;
        UPDATE Accounts
        SET Balance = acc_balance - annual_fee
        WHERE AccountID = acc_id;
        SELECT CONCAT('AccountID: ', acc_id, ' - Annual fee applied.') AS UpdateStatus;
    END LOOP;
    CLOSE accounts_cursor;
END //

-- Procedure to Update Interest Rates for All Loans Based on a New Policy
CREATE PROCEDURE UpdateLoanInterestRates()
BEGIN
    -- Declare cursor and variables
    DECLARE done INT DEFAULT FALSE;
    DECLARE loan_id INT;
    DECLARE current_interest_rate DECIMAL(5,2);
    DECLARE new_interest_rate DECIMAL(5,2);
    
    -- Declare cursor for fetching loan details
    DECLARE loans_cursor CURSOR FOR
        SELECT LoanID, InterestRate
        FROM Loans;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Open cursor and update interest rates
    OPEN loans_cursor;
    read_loop: LOOP
        FETCH loans_cursor INTO loan_id, current_interest_rate;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SET new_interest_rate = current_interest_rate * 1.05;  -- Example: increase by 5%
        UPDATE Loans
        SET InterestRate = new_interest_rate
        WHERE LoanID = loan_id;
        SELECT CONCAT('LoanID: ', loan_id, ' - Interest rate updated to: ', new_interest_rate) AS UpdateStatus;
    END LOOP;
    CLOSE loans_cursor;
END //

DELIMITER ;
