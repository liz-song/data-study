-- Prob1: Temp Table 이었던 것을 CREATE 와 INSERT 사용해서 바꾸기 
/*대상 코드
SELECT 
		OrderDate
		,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		,TotalDue
		,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
INTO #ranksinheader
FROM AdventureWorks2019.Sales.SalesOrderHeader



SELECT
	OrderMonth,
	TotalSales = SUM(TotalDue)
INTO #Top10Sales
FROM #ranksinheader
WHERE OrderRank > 10
GROUP BY OrderMonth


SELECT 
	OrderDate
	,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
	,TotalDue
	,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
INTO #ranksinPurheader
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader



SELECT
	OrderMonth,
	TotalPurchases = SUM(TotalDue)
INTO #Top10pur
FROM #ranksinPurheader
WHERE OrderRank > 10
GROUP BY OrderMonth


SELECT
A.OrderMonth,
A.TotalSales,
B.TotalPurchases

FROM #Top10Sales A
	JOIN #Top10Pur B ON A.OrderMonth = B.OrderMonth

ORDER BY 1 */

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
DROP TABLE #Top10pur