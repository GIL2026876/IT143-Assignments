USE AdventureWorks2025;
GO

/* =========================================================
   IT143 - W3.4 Adventure Works - Create Answers
   Database: AdventureWorks2025
   ========================================================= */

/* ---------------------------------------------------------
   Question 1
   Original author: Jose Valderrama Almanza
   What are our ten most expensive products based on list price?
   --------------------------------------------------------- */

SELECT TOP 10
    ProductID,
    Name,
    ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;


/* ---------------------------------------------------------
   Question 2
   Original author: Alexsander Machad
   How many products has a list price greater than $1,000?
   --------------------------------------------------------- */

SELECT
    COUNT(*) AS ProductsOver1000
FROM Production.Product
WHERE ListPrice > 1000;


/* ---------------------------------------------------------
   Question 3
   Original author: Jose Valderrama Almanza
   Which customers have placed orders?
   How many orders has each customer placed?
   --------------------------------------------------------- */

SELECT
    c.CustomerID,
    c.AccountNumber,
    COUNT(DISTINCT soh.SalesOrderID) AS NumberOfOrders
FROM Sales.Customer AS c
INNER JOIN Sales.SalesOrderHeader AS soh
    ON c.CustomerID = soh.CustomerID
GROUP BY
    c.CustomerID,
    c.AccountNumber
ORDER BY
    NumberOfOrders DESC;


/* ---------------------------------------------------------
   Question 4
   Original author: Elie Flaurice Dieudonne
   Which product subcategories contain the greatest number
   of products?
   --------------------------------------------------------- */

SELECT TOP 1 WITH TIES
    psc.ProductSubcategoryID,
    psc.Name AS ProductSubcategory,
    COUNT(p.ProductID) AS ProductCount
FROM Production.ProductSubcategory AS psc
INNER JOIN Production.Product AS p
    ON psc.ProductSubcategoryID = p.ProductSubcategoryID
GROUP BY
    psc.ProductSubcategoryID,
    psc.Name
ORDER BY
    ProductCount DESC;


/* ---------------------------------------------------------
   Question 5
   Original author: Alexsander Machad
   For online orders placed in 2013, what were the total
   units ordered and total sales after line discounts,
   before tax and freight, for each bicycle subcategory?
   --------------------------------------------------------- */

SELECT
    psc.Name AS BicycleSubcategory,
    SUM(sod.OrderQty) AS TotalUnitsOrdered,
    SUM(
        sod.OrderQty
        * sod.UnitPrice
        * (1 - sod.UnitPriceDiscount)
    ) AS TotalSalesAfterDiscount
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesOrderDetail AS sod
    ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID
INNER JOIN Production.ProductSubcategory AS psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pc
    ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE
    soh.OrderDate >= '2013-01-01'
    AND soh.OrderDate < '2014-01-01'
    AND soh.OnlineOrderFlag = 1
    AND pc.Name = 'Bikes'
GROUP BY
    psc.Name
ORDER BY
    TotalSalesAfterDiscount DESC;


/* ---------------------------------------------------------
   Question 6
   Original author: Elie Flaurice Dieudonne
   Show each salesperson's name, sales territory,
   number of orders processed, and total sales revenue
   during 2013.
   --------------------------------------------------------- */

SELECT
    CONCAT(pp.FirstName, ' ', pp.LastName) AS SalespersonName,
    st.Name AS SalesTerritory,
    COUNT(DISTINCT soh.SalesOrderID) AS NumberOfOrders,
    SUM(soh.TotalDue) AS TotalSalesRevenue
FROM Sales.SalesPerson AS sp
INNER JOIN Person.Person AS pp
    ON sp.BusinessEntityID = pp.BusinessEntityID
INNER JOIN Sales.SalesTerritory AS st
    ON sp.TerritoryID = st.TerritoryID
INNER JOIN Sales.SalesOrderHeader AS soh
    ON sp.BusinessEntityID = soh.SalesPersonID
WHERE
    soh.OrderDate >= '2013-01-01'
    AND soh.OrderDate < '2014-01-01'
GROUP BY
    pp.FirstName,
    pp.LastName,
    st.Name
ORDER BY
    TotalSalesRevenue DESC;


/* ---------------------------------------------------------
   Question 7
   Original author: Alexsander Machad
   Which columns in Sales.SalesOrderHeader allow NULL values,
   and what is the SQL data type of each?
   --------------------------------------------------------- */

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_SCHEMA = 'Sales'
    AND TABLE_NAME = 'SalesOrderHeader'
    AND IS_NULLABLE = 'YES'
ORDER BY
    ORDINAL_POSITION;


/* ---------------------------------------------------------
   Question 8
   Original author: Elie Flaurice Dieudonne
   Which tables contain columns named ProductID or
   ProductSubcategoryID?
   --------------------------------------------------------- */

SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE
    COLUMN_NAME IN ('ProductID', 'ProductSubcategoryID')
ORDER BY
    TABLE_SCHEMA,
    TABLE_NAME,
    COLUMN_NAME;


/* =========================================================
   Learning Resources
   =========================================================

   1. Microsoft Learn - AdventureWorks Sample Databases
      https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure

   2. Microsoft Learn - SQL Server Joins
      https://learn.microsoft.com/en-us/sql/relational-databases/performance/joins

   3. Microsoft Learn - GROUP BY
      https://learn.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql
   ========================================================= */