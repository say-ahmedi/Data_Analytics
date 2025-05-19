-- Database: BANKDB

-- DROP DATABASE IF EXISTS "BANKDB";

CREATE DATABASE "BankDB"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'ru-RU'
    LC_CTYPE = 'ru-RU'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;






CREATE TABLE Role (
    RoleID SERIAL PRIMARY KEY,
    RoleName VARCHAR(50) NOT NULL
);

CREATE TABLE Branch (
    BranchID SERIAL PRIMARY KEY,
    BranchName VARCHAR(100) NOT NULL,
    AddressText TEXT NOT NULL,
    Phone VARCHAR(15) NOT NULL
);

CREATE TABLE Employee (
    EmployeeID SERIAL PRIMARY KEY,
    BranchID INT NOT NULL REFERENCES Branch(BranchID),
    RoleID INT NOT NULL REFERENCES Role(RoleID),
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Customer (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    AddressText TEXT NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE AccountType (
    AccountTypeID SERIAL PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL
);

CREATE TABLE Account (
    Account_ID SERIAL PRIMARY KEY,
    AccountTypeID INT NOT NULL REFERENCES AccountType(AccountTypeID),
    Phone VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NOT NULL
);

CREATE TABLE CustomerAccount (
    Customer_ID INT REFERENCES Customer(Customer_ID),
    Account_ID INT REFERENCES Account(Account_ID),
    PRIMARY KEY (Customer_ID, Account_ID)
);

CREATE TABLE TransactionType (
    TransactionTypeID SERIAL PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL
);

CREATE TABLE Transaction (
    Transaction_ID SERIAL PRIMARY KEY,
    Account_ID INT NOT NULL REFERENCES Account(Account_ID),
    TransactionTypeID INT NOT NULL REFERENCES TransactionType(TransactionTypeID),
    Amount NUMERIC(10,2) NOT NULL,
    Date DATE NOT NULL
);

CREATE TABLE LoanType (
    LoanTypeID SERIAL PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL
);

CREATE TABLE Loan (
    Loan_ID SERIAL PRIMARY KEY,
    Customer_ID INT NOT NULL REFERENCES Customer(Customer_ID),
    LoanTypeID INT NOT NULL REFERENCES LoanType(LoanTypeID),
    Amount NUMERIC(10,2) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL
);

--Task 3: Insert Records

-- Roles
INSERT INTO Role (RoleName) VALUES ('Manager'), ('Clerk'), ('Security');

-- Branches
INSERT INTO Branch (BranchName, AddressText, Phone) VALUES
('Downtown', '123 Main St', '1234567890'),
('Uptown', '456 High St', '0987654321'),
('Suburb', '789 Elm St', '1112223333');

-- Employees
INSERT INTO Employee (BranchID, RoleID, Name, Phone, Email) VALUES
(1, 1, 'Alice Smith', '1231231234', 'alice@example.com'),
(2, 2, 'Bob Johnson', '2342342345', 'bob@example.com'),
(3, 3, 'Charlie Lee', '3453453456', 'charlie@example.com');

-- Customers
INSERT INTO Customer (Name, AddressText, Phone, Email) VALUES
('Diana Prince', '101 Wonder St', '5556667777', 'diana@example.com'),
('Bruce Wayne', 'Wayne Manor', '8889990000', 'bruce@example.com'),
('Clark Kent', 'Daily Planet', '2223334444', 'clark@example.com');

-- Account Types
INSERT INTO AccountType (TypeName) VALUES ('Savings'), ('Checking'), ('Business');

-- Accounts
INSERT INTO Account (AccountTypeID, Phone, Email) VALUES
(1, '5551112222', 'acc1@example.com'),
(2, '5553334444', 'acc2@example.com'),
(3, '5555556666', 'acc3@example.com');

-- Customer Accounts
INSERT INTO CustomerAccount (Customer_ID, Account_ID) VALUES (1,1), (2,2), (3,3);

-- Transaction Types
INSERT INTO TransactionType (TypeName) VALUES ('Deposit'), ('Withdrawal'), ('Transfer');

-- Transactions
INSERT INTO Transaction (Account_ID, TransactionTypeID, Amount, Date) VALUES
(1,1,1000.00,'2024-01-01'),
(2,2,200.00,'2024-02-01'),
(3,3,500.00,'2024-03-01');

-- Loan Types
INSERT INTO LoanType (TypeName) VALUES ('Personal'), ('Mortgage'), ('Auto');

-- Loans
INSERT INTO Loan (Customer_ID, LoanTypeID, Amount, StartDate, EndDate) VALUES
(1,1,5000.00,'2024-01-10','2025-01-10'),
(2,2,150000.00,'2023-05-20','2043-05-20'),
(3,3,20000.00,'2022-07-15','2027-07-15');

--project 4
--1)
SELECT E.Name AS EmployeeName, R.RoleName, B.BranchName
FROM Employee E
INNER JOIN Role R ON E.RoleID = R.RoleID
INNER JOIN Branch B ON E.BranchID = B.BranchID
ORDER BY B.BranchName;
--2)
SELECT C.Name AS CustomerName
FROM Customer C
LEFT JOIN CustomerAccount CA ON C.Customer_ID = CA.Customer_ID
WHERE CA.Account_ID IS NULL;
--3)
SELECT R.RoleName, E.Name AS EmployeeName
FROM Employee E
RIGHT JOIN Role R ON E.RoleID = R.RoleID;
--4)
SELECT C.Name AS CustomerName, A.Email AS AccountEmail
FROM Customer C
FULL OUTER JOIN CustomerAccount CA ON C.Customer_ID = CA.Customer_ID
FULL OUTER JOIN Account A ON CA.Account_ID = A.Account_ID
WHERE C.Customer_ID IS NOT NULL OR A.Account_ID IS NOT NULL;
--5)
SELECT C.Name, SUM(L.Amount) AS TotalLoan
FROM Customer C
JOIN Loan L ON C.Customer_ID = L.Customer_ID
GROUP BY C.Name
HAVING SUM(L.Amount) > 20000;
--6)
SELECT T.Transaction_ID, T.Amount, T.Date
FROM "Transaction" T
JOIN TransactionType TT ON T.TransactionTypeID = TT.TransactionTypeID
WHERE TT.TypeName LIKE 'Dep%' AND T.Date BETWEEN '2024-01-01' AND '2024-12-31';
--7)
SELECT Name
FROM Employee
WHERE BranchID = (
    SELECT BranchID
    FROM Employee
    WHERE Name = 'Alice Smith'
);
--8)
SELECT Email FROM Customer
UNION
SELECT Email FROM Employee;
--9)
SELECT Email FROM Customer
EXCEPT
SELECT C.Email
FROM Customer C
JOIN CustomerAccount CA ON C.Customer_ID = CA.Customer_ID;
--10)
SELECT Email FROM Customer
INTERSECT
SELECT Email FROM Account;
--11)
SELECT Name
FROM Employee
WHERE Name LIKE '%_e';
--12)
SELECT Name
FROM Customer
WHERE Customer_ID NOT IN (
    SELECT Customer_ID FROM Loan
);
--13)
SELECT A.Account_ID, A.Email
FROM Account A
JOIN CustomerAccount CA ON A.Account_ID = CA.Account_ID
WHERE CA.Customer_ID IN (
    SELECT Customer_ID
    FROM Loan
    WHERE LoanTypeID = (
        SELECT LoanTypeID FROM LoanType WHERE TypeName = 'Personal'
    )
);
--14)
SELECT A.Account_ID, A.Email, C.Name
FROM CustomerAccount CA
RIGHT JOIN Account A ON CA.Account_ID = A.Account_ID
LEFT JOIN Customer C ON CA.Customer_ID = C.Customer_ID;

--15)
SELECT C.Name, COUNT(CA.Account_ID) AS AccountCount
FROM Customer C
JOIN CustomerAccount CA ON C.Customer_ID = CA.Customer_ID
WHERE C.Name LIKE 'C%'
GROUP BY C.Name
HAVING COUNT(CA.Account_ID) > 1;

--16)
SELECT Name
FROM Employee
WHERE BranchID BETWEEN (
    SELECT MIN(Customer_ID) FROM Loan
) AND (
    SELECT MAX(Customer_ID) FROM Loan
);

--17)
SELECT C.Name AS CustomerName, A.Email AS AccountEmail
FROM Customer C
FULL OUTER JOIN CustomerAccount CA ON C.Customer_ID = CA.Customer_ID
FULL OUTER JOIN Account A ON A.Account_ID = CA.Account_ID
WHERE C.Name IS NULL OR A.Email IS NULL;

--18)
SELECT T.Transaction_ID, T.Amount, TT.TypeName
FROM "Transaction" T
JOIN TransactionType TT ON T.TransactionTypeID = TT.TransactionTypeID
WHERE LOWER(TT.TypeName) LIKE 'dep%'
ORDER BY T.Amount DESC;

--19)
SELECT C.Name, COALESCE(SUM(L.Amount), 0) AS TotalLoan
FROM Customer C
LEFT JOIN Loan L ON C.Customer_ID = L.Customer_ID
GROUP BY C.Name;

--20)
SELECT Customer_ID FROM CustomerAccount
EXCEPT
SELECT Customer_ID FROM Loan;









