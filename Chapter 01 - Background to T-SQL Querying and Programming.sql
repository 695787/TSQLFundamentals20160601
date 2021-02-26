---------------------------------------------------------------------
-- Microsoft SQL Server T-SQL Fundamentals
-- Chapter 01 - Background to T-SQL Querying and Programming
-- � Itzik Ben-Gan 
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Creating Tables
---------------------------------------------------------------------

-- Create table Employees
USE TSQLV4;

DROP TABLE IF EXISTS dbo.Employees;

/*
-- Prior to SQL Server 2016 use:
IF OBJECT_ID(N'dbo.Employees', N'U') IS NOT NULL DROP TABLE dbo.Employees;
*/

CREATE TABLE dbo.Employees
(
  empid     INT         NOT NULL,
  firstname VARCHAR(30) NOT NULL,
  lastname  VARCHAR(30) NOT NULL,
  hiredate  DATE        NOT NULL,
  mgrid     INT         NULL,
  ssn       VARCHAR(20) NOT NULL,
  salary    MONEY       NOT NULL
);

---------------------------------------------------------------------
-- Data Integrity
---------------------------------------------------------------------

-- Primary key
ALTER TABLE dbo.Employees
  ADD CONSTRAINT PK_Employees
  PRIMARY KEY(empid);

-- Unique
ALTER TABLE dbo.Employees
  ADD CONSTRAINT UNQ_Employees_ssn
  UNIQUE(ssn);

-- Unique filtered index allowing duplicate NULLs
CREATE UNIQUE INDEX idx_ssn_notnull ON dbo.Employees(ssn) WHERE ssn IS NOT NULL;

-- Table used in foreign key example
DROP TABLE IF EXISTS dbo.Orders;

/*
-- Prior to SQL Server 2016 use:
IF OBJECT_ID(N'dbo.Orders', N'U') IS NOT NULL DROP TABLE dbo.Orders;
*/

CREATE TABLE dbo.Orders
(
  orderid   INT         NOT NULL,
  empid     INT         NOT NULL,
  custid    VARCHAR(10) NOT NULL,
  orderts   DATETIME2   NOT NULL,
  qty       INT         NOT NULL,
  CONSTRAINT PK_Orders
    PRIMARY KEY(orderid)
);

/*
Got error when trying to create table dbo.Orders

 [15:08:34]	Started executing query at Line 1
Msg 2714, Level 16, State 6, Line 1
There is already an object named 'Orders' in the database. 
Total execution time: 00:00:00.029 */



-- Foreign keys
ALTER TABLE dbo.Orders
  ADD CONSTRAINT FK_Orders_Employees
  FOREIGN KEY(empid)
  REFERENCES dbo.Employees(empid);CREATE TABLE dbo.Orders
(
  orderid   INT         NOT NULL,
  empid     INT         NOT NULL,
  custid    VARCHAR(10) NOT NULL,
  orderts   DATETIME2   NOT NULL,
  qty       INT         NOT NULL,
  CONSTRAINT PK_Orders
    PRIMARY KEY(orderid)
);

ALTER TABLE dbo.Employees
  ADD CONSTRAINT FK_Employees_Employees
  FOREIGN KEY(mgrid)
  REFERENCES dbo.Employees(empid);

-- Check
ALTER TABLE dbo.Employees
  ADD CONSTRAINT CHK_Employees_salary
  CHECK(salary > 0.00);

-- Default
ALTER TABLE dbo.Orders
  ADD CONSTRAINT DFT_Orders_orderts
  DEFAULT(SYSDATETIME()) FOR orderts;

-- Cleanup
DROP TABLE IF EXISTS dbo.Orders, dbo.Employees;