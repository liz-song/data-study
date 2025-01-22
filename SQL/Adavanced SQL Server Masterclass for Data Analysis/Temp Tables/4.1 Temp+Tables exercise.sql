--CTE를 temp Table로 바꾸기 
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

ORDER BY 1