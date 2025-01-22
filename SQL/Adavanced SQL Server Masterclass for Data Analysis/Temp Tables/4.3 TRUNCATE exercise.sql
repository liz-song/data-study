-- 이전 exercise에서 만든 테이블을 TRUNCATE사용해서 바꾸기 
/* 바꿔야 하는 코드 
CREATE TABLE #ranksinheader
(      OrderDate DATE
	  ,OrderMonth DATE
      ,TotalDue MONEY
	  ,OrderRank INT
) 

INSERT INTO #ranksinheader
(	OrderDate 
	,OrderMonth
    ,TotalDue 
	,OrderRank
)

SELECT 
	OrderDate
	,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
    ,TotalDue
	,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)

FROM AdventureWorks2019.Sales.SalesOrderHeader


CREATE TABLE #Top10Sales
(
	OrderMonth DATE
	,TotalSales MONEY
)

INSERT INTO #Top10Sales
(
	OrderMonth
	,TotalSales
)

SELECT 
	OrderMonth
	,Top10Total = SUM(TotalDue)
FROM #ranksinheader
WHERE OrderRank > 10
GROUP BY OrderMonth

CREATE TABLE #ranksinPurheader
(
	OrderDate DATE
	,OrderMonth DATE
	,TotalDue MONEY
	,OrderRank INT
)

INSERT INTO #ranksinPurheader
(
	OrderDate
	,OrderMonth
	,TotalDue
	,OrderRank
)

SELECT 
	OrderDate
	,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
	,TotalDue
	,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader

CREATE TABLE #Top10pur
(	
	OrderMonth DATE
	,TotalPurchases MONEY
)

INSERT INTO #Top10pur
(
	OrderMonth
	,TotalPurchases
)

SELECT 
	OrderMonth
	,TotalPurchases = SUM(TotalDue)
FROM #ranksinPurheader
WHERE OrderRank > 10
GROUP BY OrderMonth

SELECT
A.OrderMonth,
A.TotalSales,
B.TotalPurchases

FROM #Top10Sales A
	JOIN #Top10Pur B ON A.OrderMonth = B.OrderMonth

ORDER BY 1

DROP TABLE #ranksinheader
DROP TABLE #Top10Sales
DROP TABLE #ranksinPurheader
DROP TABLE #Top10pur */

-- #Top10Sales와 #Top10pur

CREATE TABLE #ranksinheader
(      OrderDate DATE
	  ,OrderMonth DATE
      ,TotalDue MONEY
	  ,OrderRank INT
) 

INSERT INTO #ranksinheader
(	OrderDate 
	,OrderMonth
    ,TotalDue 
	,OrderRank
)

SELECT 
	OrderDate
	,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
    ,TotalDue
	,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)

FROM AdventureWorks2019.Sales.SalesOrderHeader

CREATE TABLE #Top10
(
	OrderMonth DATE
	,category VARCHAR(32)
	,TotalSales MONEY
)

INSERT INTO #Top10
(
	OrderMonth
	,category
	,TotalSales
)

SELECT 
	OrderMonth
	,category = 'Sales'
	,Top10Total = SUM(TotalDue)
FROM #ranksinheader
WHERE OrderRank > 10
GROUP BY OrderMonth

SELECT * FROM #Top10

TRUNCATE Table #ranksinheader

INSERT INTO #ranksinheader
(
	OrderDate 
	,OrderMonth
    ,TotalDue 
	,OrderRank
)

SELECT
	OrderDate
	,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
    ,TotalDue
	,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)

FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader

INSERT INTO #Top10
(	
	OrderMonth,
	category,
	TotalSales
)


SELECT
	OrderMonth,
	OrderType = 'Purchase',
	TotalDue = SUM(TotalDue)
FROM #ranksinheader
WHERE OrderRank > 10
GROUP BY OrderMonth

SELECT
	A.OrderMonth,
	TotalSales = A.TotalSales,
	TotalPurchases = B.TotalSales

FROM #Top10 A
	JOIN #Top10 B ON A.OrderMonth = B.OrderMonth
			AND B.category = 'Purchase'
			AND A.category = 'Sales'

ORDER BY 1

