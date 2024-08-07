DELIMITER //

-- creating a Procedure to Apply Interest Discount to Customers Above 60 Years Old

CREATE PROCEDURE ApplyInterestDiscount()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur_CustomerID INT;
    DECLARE cur_DOB DATE;
    DECLARE currentDATE DATE;
    SET currentDATE = CURDATE();
    BEGIN
    DECLARE cur CURSOR FOR SELECT CustomerID, DOB FROM Customers;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;OPEN cur;

    read_loop: LOOP
        FETCH cur INTO cur_CustomerID, cur_DOB;
        IF done THEN
            LEAVE read_loop;
        END IF;

        IF TIMESTAMPDIFF(YEAR, cur_DOB, current_date) > 60 THEN
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
    DECLARE cur CURSOR FOR SELECT CustomerID, cur_DueDate FROM Loans WHERE cur_DueDate BETWEEN current_date AND DATE_ADD(current_date, INTERVAL 30 DAY);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO cur_CustomerID, cur_DueDate;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT('Reminder: Loan due on ', cur_DueDate, ' for CustomerID: ', cur_CustomerID) 
        AS ReminderMessage;
    END LOOP;
    CLOSE cur;
    END;
END //
DELIMITER ;

-- Call the procedures
CALL ApplyInterestDiscount();
CALL PromoteToVIP();
CALL SendLoanReminders();CALL SendLoanReminders();

