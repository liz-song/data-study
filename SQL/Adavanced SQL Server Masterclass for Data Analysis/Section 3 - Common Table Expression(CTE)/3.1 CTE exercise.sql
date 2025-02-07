-- 월별 탑10은 아웃라이어여서 잘라내야함 + 판매와 구매의 합(아웃라이어 빼고)
-- 아래 코드를 CTE로 바꿔보기 
SELECT
A.OrderMonth,
A.TotalSales,
B.TotalPurchases

FROM (
	SELECT
	OrderMonth,
	TotalSales = SUM(TotalDue)
	FROM (
		SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Sales.SalesOrderHeader
		) S
	WHERE OrderRank > 10
	GROUP BY OrderMonth
) A

JOIN (
	SELECT
	OrderMonth,
	TotalPurchases = SUM(TotalDue)
	FROM (
		SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader
		) P
	WHERE OrderRank > 10
	GROUP BY OrderMonth
) B	ON A.OrderMonth = B.OrderMonth

ORDER BY 1

-- 내 답변
WITH ranksinheader AS(
	SELECT 
		OrderDate
		,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		,TotalDue
		,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
	FROM AdventureWorks2019.Sales.SalesOrderHeader
),
Top10Sales AS(
	SELECT
		OrderMonth,
		TotalSales = SUM(TotalDue)
	FROM ranksinheader
	WHERE OrderRank > 10
	GROUP BY OrderMonth
),

ranksinPurheader AS(
		SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader
),

Top10pur AS(
	SELECT
		OrderMonth,
		TotalPurchases = SUM(TotalDue)
	FROM ranksinPurheader
	WHERE OrderRank > 10
	GROUP BY OrderMonth
)

SELECT
A.OrderMonth,
A.TotalSales,
B.TotalPurchases

FROM Top10Sales A
	JOIN Top10Pur B ON A.OrderMonth = B.OrderMonth

ORDER BY 1