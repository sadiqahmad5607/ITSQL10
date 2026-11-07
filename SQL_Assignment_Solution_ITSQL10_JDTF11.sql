-- Assignment :
-- ITSQL10 - JDTF11

-- Question 1
-- A retail company wants to reward its most valuable customers. Display the
-- top 5 highest-value orders along with customer names.

SELECT
    c.CustomerName,
    o.OrderID,
    o.OrderAmount
FROM Orders o
INNER JOIN Customers c
    ON o.CustomerID = c.CustomerID
ORDER BY o.OrderAmount DESC
LIMIT 5;


-- Question 2
-- The marketing team wants to send promotional emails to customers whose
-- names start with 'A', 'R', or 'S'.
-- Write a query without using multiple OR conditions.

SELECT
    CustomerID,
    CustomerName,
    City,
    JoinDate
FROM Customers
WHERE CustomerName REGEXP '^[ARS]';


-- Question 3
-- Management wants to identify customers who have placed orders worth
-- more than ₹10,000 but whose order status is still Pending.
-- Display:
-- ● Customer Name
-- ● Order ID
-- ● Order Amount
-- ● Status

SELECT
    c.CustomerName,
    o.OrderID,
    o.OrderAmount,
    o.Status
FROM Orders o
INNER JOIN Customers c
    ON o.CustomerID = c.CustomerID
WHERE o.OrderAmount > 10000
  AND o.Status = 'Pending';


-- Question 4
-- The customer success team wants to identify customers who joined more
-- than 365 days ago.
-- Display the number of days each customer has been associated with the
-- company.

SELECT
    CustomerID,
    CustomerName,
    JoinDate,
    DATEDIFF(CURDATE(), JoinDate) AS NumberOfDays
FROM Customers
WHERE DATEDIFF(CURDATE(), JoinDate) > 365;


-- Question 5
-- The finance department wants to estimate future revenue.
-- Create a report showing:
-- ● Order ID
-- ● Current Amount
-- ● 18% GST
-- ● Total Amount After GST
-- ● Expected Collection Date (15 days after order date)

SELECT
    OrderID,
    OrderAmount AS CurrentAmount,
    OrderAmount * 0.18 AS GST,
    OrderAmount * 1.18 AS TotalAmountAfterGST,
    DATE_ADD(OrderDate, INTERVAL 15 DAY) AS ExpectedCollectionDate
FROM Orders;


-- Question 6
-- The operations team wants to review the customers ranked between 11th and
-- 20th highest orders.
-- Use LIMIT and OFFSET.

SELECT
    o.OrderID,
    c.CustomerName,
    o.OrderAmount,
    o.OrderDate,
    o.Status
FROM Orders o
INNER JOIN Customers c
    ON o.CustomerID = c.CustomerID
ORDER BY o.OrderAmount DESC
LIMIT 10 OFFSET 10;


-- Question 7
-- An e-commerce company wants to identify customers who have never
-- placed any order despite registering on the platform.
-- Display:
-- ● Customer ID
-- ● Customer Name
-- ● Join Date
-- ● Number of Days Since Registration

SELECT
    c.CustomerID,
    c.CustomerName,
    c.JoinDate,
    DATEDIFF(CURDATE(), c.JoinDate) AS NumberOfDaysSinceRegistration
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;


-- Question 8
-- The HR department wants to analyze organizational hierarchy.
-- Using a JOIN, display:
-- ● Employee Name
-- ● Manager Name
-- ● Department

SELECT
    e.EmployeeName,
    m.EmployeeName AS ManagerName,
    e.Department
FROM Employees e
INNER JOIN Employees m
    ON e.ManagerID = m.EmployeeID;


-- Question 9
-- The sales director wants a report of customers who placed orders within 30
-- days of joining the platform.
-- Display:
-- ● Customer Name
-- ● Join Date
-- ● Order Date
-- ● Days Taken To Place First Order

SELECT
    c.CustomerName,
    c.JoinDate,
    o.OrderDate,
    DATEDIFF(o.OrderDate, c.JoinDate) AS DaysTakenToPlaceFirstOrder
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
INNER JOIN (
    SELECT
        CustomerID,
        MIN(OrderDate) AS FirstOrderDate
    FROM Orders
    GROUP BY CustomerID
) fo
    ON o.CustomerID = fo.CustomerID
   AND o.OrderDate = fo.FirstOrderDate
WHERE DATEDIFF(o.OrderDate, c.JoinDate) <= 30
  AND DATEDIFF(o.OrderDate, c.JoinDate) >= 0;


-- Question 10
-- Business Requirement
-- Generate a report showing:
-- ● Customer Name
-- ● Total Purchase Amount
-- ● Spending Category
-- ● Loyalty Status

-- Rules
-- Spending Category
-- ● Premium → Total Purchases > ₹50,000
-- ● Gold → ₹20,000 to ₹50,000
-- ● Silver → Less than ₹20,000
-- Loyalty Status
-- ● Joined before 2024 → Loyal Customer
-- ● Otherwise → New Customer

SELECT
    c.CustomerName,
    COALESCE(SUM(o.OrderAmount), 0) AS TotalPurchaseAmount,
    CASE
        WHEN COALESCE(SUM(o.OrderAmount), 0) > 50000 THEN 'Premium'
        WHEN COALESCE(SUM(o.OrderAmount), 0) BETWEEN 20000 AND 50000 THEN 'Gold'
        ELSE 'Silver'
    END AS SpendingCategory,
    CASE
        WHEN c.JoinDate < '2024-01-01' THEN 'Loyal Customer'
        ELSE 'New Customer'
    END AS LoyaltyStatus
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY
    c.CustomerID,
    c.CustomerName,
    c.JoinDate;


-- Question 11 : An online marketplace wants to find customers whose order
-- amount is higher than the average order amount of all orders.
-- Display:
-- ● Customer Name
-- ● Order ID
-- ● Order Amount

SELECT
    c.CustomerName,
    o.OrderID,
    o.OrderAmount
FROM Orders o
INNER JOIN Customers c
    ON o.CustomerID = c.CustomerID
WHERE o.OrderAmount > (
    SELECT AVG(OrderAmount)
    FROM Orders
);


-- Question 12
-- The management team wants the 2nd to 6th highest orders placed by
-- customers.
-- Display:
-- ● Customer Name
-- ● Order ID
-- ● Order Amount

SELECT
    c.CustomerName,
    o.OrderID,
    o.OrderAmount
FROM Orders o
INNER JOIN Customers c
    ON o.CustomerID = c.CustomerID
ORDER BY o.OrderAmount DESC
LIMIT 5 OFFSET 1;
