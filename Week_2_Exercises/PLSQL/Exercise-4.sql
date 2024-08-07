DELIMITER //

-- Function to Calculate Age of Customers
CREATE FUNCTION GetCustomerAge(birthdate DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE customerAge INT;
    
    -- Calculate age based on the date of birth
    SET customerAge = TIMESTAMPDIFF(YEAR, birthdate, CURDATE());
    RETURN customerAge;
END //

-- Function to Compute Monthly Installment for a Loan
CREATE FUNCTION ComputeMonthlyPayment(
    principal DECIMAL(15,2),annualRate DECIMAL(5,2),durationYears INT
)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE monthlyInterestRate DECIMAL(7,6);
    DECLARE totalPayments INT;
    DECLARE monthlyPayment DECIMAL(15,2);
    
    SET monthlyInterestRate = annualRate / 100 / 12;
    
    SET totalPayments = durationYears * 12;
    
    SET monthlyPayment = principal * (monthlyInterestRate * POWER(1 + monthlyInterestRate, totalPayments)) / (POWER(1 + monthlyInterestRate, totalPayments) - 1);
    
    RETURN monthlyPayment;
END //

-- Function to Check if Customer Has Sufficient Balance
CREATE FUNCTION CheckAccountBalance(
    accID INT,
    transactionAmount DECIMAL(10,2)
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE accountBalance DECIMAL(10,2);
    DECLARE isSufficient BOOLEAN;
    
    SELECT Balance INTO accountBalance
    FROM Accounts
    WHERE AccountID = accID;
    
    SET isSufficient = (accountBalance >= transactionAmount);
    
    RETURN isSufficient;
END //

DELIMITER ;
