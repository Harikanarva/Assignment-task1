USE [AdventureWorks2022];
GO
SELECT c.CustomerID,p.FirstName, p.LastName, e.EmailAddress FROM Sales.Customer c JOIN Person.Person p ON c.PersonID = p.BusinessEntityID LEFT JOIN Person.EmailAddress e ON e.BusinessEntityID = p.BusinessEntityID;
SELECT c.CustomerID, s.Name AS CompanyName FROM Sales.Customer c JOIN Sales.Store s ON c.StoreID= s.BusinessEntityID WHERE s.Name LIKE '%N';
SELECT c.CustomerID,p.FirstName,p.LastName,a.City FROM Sales.Customer c JOIN Person.Person p ON c.PersonID = p.BusinessEntityID JOIN Person.BusinessEntityAddress bea ON c.PersonID = bea.BusinessEntityID JOIN Person.Address a ON bea.AddressID = a.AddressID WHERE a.City IN ('Berlin', 'London');
SELECT DISTINCT 
    c.CustomerID, 
    p.FirstName, 
    p.LastName, 
    cr.Name AS Country
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.BusinessEntityAddress bea ON c.PersonID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name IN ('United Kingdom', 'United�States');
SELECT 
    ProductID, 
    Name 
FROM Production.Product
ORDER�BY�Name;
SELECT 
    ProductID, 
    Name 
FROM Production.Product
WHERE Name�LIKE�'A%';
SELECT DISTINCT 
    c.CustomerID, 
    p.FirstName, 
    p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID =�soh.CustomerID;

SELECT DISTINCT 
    c.CustomerID, 
    p.FirstName, 
    p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
JOIN Person.BusinessEntityAddress bea ON c.PersonID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
WHERE a.City = 'London' AND pr.Name = 'Chai';
SELECT 
    c.CustomerID, 
    p.FirstName, 
    p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE c.CustomerID NOT IN (
    SELECT DISTINCT CustomerID 
    FROM Sales.SalesOrderHeader
);
SELECT DISTINCT 
    c.CustomerID, 
    p.FirstName, 
    p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
WHERE pr.Name = 'Tofu';
SELECT TOP 1 *
FROM Sales.SalesOrderHeader
ORDER BY OrderDate ASC;
SELECT 
    SalesOrderID,
    AVG(OrderQty) AS AverageQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

SELECT TOP 1 * FROM Sales.SalesOrderHeader ORDER BY OrderDate ASC;

-- 12. Details of most expensive order date
SELECT TOP 1 OrderDate, TotalDue FROM Sales.SalesOrderHeader ORDER BY TotalDue DESC;

-- 13. Each order: OrderID and average quantity of items 
SELECT SalesOrderID, AVG(OrderQty) AS AvgQty FROM Sales.SalesOrderDetail GROUP BY SalesOrderID;

-- 14. Each order: orderID, min qty, max qty 
SELECT SalesOrderID, MIN(OrderQty) AS MinQty, MAX(OrderQty) AS MaxQty FROM Sales.SalesOrderDetail GROUP BY SalesOrderID;
 
 --15.
 SELECT 
    Manager.BusinessEntityID AS ManagerID,
    pManager.FirstName + ' ' + pManager.LastName AS ManagerName,
    COUNT(E.BusinessEntityID) AS NumEmployeesReporting
FROM HumanResources.Employee E
JOIN HumanResources.Employee Manager
    ON E.OrganizationNode.GetAncestor(1) = Manager.OrganizationNode
JOIN Person.Person pManager
    ON Manager.BusinessEntityID = pManager.BusinessEntityID
GROUP BY Manager.BusinessEntityID, pManager.FirstName, pManager.LastName
ORDER BY NumEmployeesReporting DESC;

SELECT SalesOrderID, SUM(OrderQty) AS TotalQty
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty) > 300;

SELECT * FROM Sales.SalesOrderHeader
WHERE OrderDate >= '1996-12-31';

SELECT * FROM Sales.SalesOrderHeader oh
JOIN Person.Address a ON oh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name = 'Canada';

SELECT * FROM Sales.SalesOrderHeader
WHERE TotalDue > 200;

SELECT cr.Name AS Country, SUM(so.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader so
JOIN Person.Address a ON so.BillToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY cr.Name;

SELECT p.FirstName + ' ' + p.LastName AS CustomerName, COUNT(so.SalesOrderID) AS NumOrders
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader so ON c.CustomerID = so.CustomerID
GROUP BY p.FirstName, p.LastName;

SELECT p.FirstName + ' ' + p.LastName AS CustomerName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader so ON c.CustomerID = so.CustomerID
GROUP BY p.FirstName, p.LastName
HAVING COUNT(so.SalesOrderID) > 3;

SELECT DISTINCT p.Name, so.OrderDate
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader so ON sod.SalesOrderID = so.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
WHERE p.DiscontinuedDate IS NOT NULL
AND so.OrderDate BETWEEN '1997-01-01' AND '1998-01-01';

SELECT e.BusinessEntityID AS EmployeeID,
       ep.FirstName + ' ' + ep.LastName AS EmployeeName,
       sp.FirstName + ' ' + sp.LastName AS SupervisorName
FROM HumanResources.Employee e
JOIN Person.Person ep ON e.BusinessEntityID = ep.BusinessEntityID
LEFT JOIN HumanResources.Employee s ON e.OrganizationNode.GetAncestor(1) = s.OrganizationNode
LEFT JOIN Person.Person sp ON s.BusinessEntityID = sp.BusinessEntityID;

SELECT SalesPersonID, SUM(TotalDue) AS TotalSales FROM Sales.SalesOrderHeader GROUP BY SalesPersonID;

SELECT * FROM HumanResources.Employee AS e JOIN Person.Person AS p ON e.BusinessEntityID = p.BusinessEntityID WHERE p.FirstName LIKE '%a%';

SELECT 
    Manager.BusinessEntityID AS ManagerID,
    COUNT(*) AS ReportCount
FROM HumanResources.Employee AS Employee
JOIN HumanResources.Employee AS Manager
    ON Employee.OrganizationNode.GetAncestor(1) = Manager.OrganizationNode
GROUP BY Manager.BusinessEntityID
HAVING COUNT(*) > 4;
SELECT 
    Manager.BusinessEntityID AS ManagerID,
    COUNT(*) AS ReportCount
FROM HumanResources.Employee AS Employee
JOIN HumanResources.Employee AS Manager
    ON Employee.OrganizationNode.GetAncestor(1) = Manager.OrganizationNode
GROUP BY Manager.BusinessEntityID
HAVING COUNT(*) > 4;

SELECT soh.SalesOrderID, p.Name AS ProductName
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Sales.SalesOrderHeader soh ON soh.SalesOrderID = sod.SalesOrderID;

SELECT TOP 1 CustomerID, SUM(TotalDue) AS TotalSpent
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY TotalSpent DESC;

SELECT DISTINCT a.PostalCode
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
WHERE p.Name = 'Sport-100 Helmet, Red'; -- replace as needed

SELECT DISTINCT p.Name
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name = 'France';

SELECT p.Name AS ProductName, pc.Name AS Category
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
JOIN Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE v.Name = 'Specialty Biscuits, Ltd.'; -- if exists

SELECT p.Name
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL;

SELECT p.Name
FROM Production.ProductInventory pi
JOIN Production.Product p ON pi.ProductID = p.ProductID
WHERE pi.Quantity < 10 AND pi.Quantity = 0;

SELECT TOP 10 cr.Name AS Country, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.BillToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY cr.Name
ORDER BY TotalSales DESC;

SELECT SalesPersonID, COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader
WHERE CustomerID BETWEEN 1 AND 40
GROUP BY SalesPersonID;

SELECT TOP 1 OrderDate
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

SELECT p.Name, SUM(sod.LineTotal) AS Revenue
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.Name;

SELECT pv.BusinessEntityID AS SupplierID, COUNT(DISTINCT pv.ProductID) AS ProductsOffered
FROM Purchasing.ProductVendor pv
GROUP BY pv.BusinessEntityID;

SELECT TOP 10 CustomerID, SUM(TotalDue) AS TotalBusiness
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY TotalBusiness DESC;

SELECT SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader;














