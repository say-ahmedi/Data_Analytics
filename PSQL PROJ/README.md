# Bank Database Management System

## Overview

This project implements a comprehensive relational database system for a banking environment using PostgreSQL. The system models core banking operations including customer accounts, transactions, loans, and branch management with employee roles.

## Database Schema

### Key Tables

- **Branch**: Bank branch locations
- **Employee**: Staff members with role assignments
- **Customer**: Client information
- **Account**: Financial accounts with types (Savings/Checking/Business)
- **Transaction**: Financial operations (Deposits/Withdrawals/Transfers)
- **Loan**: Customer loans with various types (Personal/Mortgage/Auto)

### Relationships

- Employees assigned to branches with specific roles
- Customers linked to accounts through many-to-many relationships
- Transactions associated with accounts
- Loans connected to customers

## Features Implemented

### Data Operations

- Complete CRUD functionality through SQL
- Sample data insertion for all entities
- Complex joins and relationships

### Analytical Queries

1. Employee directory with role and branch information
2. Customer account status analysis
3. Transaction filtering by type and date range
4. Loan portfolio analysis
5. Customer account activity reports

## SQL Techniques Demonstrated

- Multi-table JOIN operations (INNER, LEFT, RIGHT, FULL)
- Subqueries and nested queries
- Set operations (UNION, INTERSECT, EXCEPT)
- Aggregation with GROUP BY and HAVING
- Pattern matching with LIKE
- Date range filtering
- NULL handling with COALESCE

## Setup Instructions

1. **Database Creation**:

```sql
CREATE DATABASE "BankDB"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'ru-RU'
    LC_CTYPE = 'ru-RU'
    TABLESPACE = pg_default;
```



2. **Table Creation** :
   Execute all CREATE TABLE statements in sequence
3. **Sample Data** :
   Run the INSERT statements to populate test data
4. **Query Execution** :
   The included analytical queries demonstrate various business cases

## Usage Examples

**Find employees by branch:**


```
SELECT E.Name, R.RoleName, B.BranchName
FROM Employee E
JOIN Role R ON E.RoleID = R.RoleID
JOIN Branch B ON E.BranchID = B.BranchID;
```

**Get customers with no accounts:**

```
SELECT C.Name
FROM Customer C
LEFT JOIN CustomerAccount CA ON C.Customer_ID = CA.Customer_ID
WHERE CA.Account_ID IS NULL;
```

## Technical Requirements

* PostgreSQL 12+
* pgAdmin or similar database tool
* Basic SQL knowledge for query customization

## License

This project is available for educational and demonstration purposes. No license restrictions apply.
