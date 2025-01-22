/* 서브쿼리는 포함관계로 여러 쿼리를 실행하는거고, CTE는 쿼리 1->쿼리2->쿼리3 이런 식으로 진행해서 
더 복잡한 쿼리 단계를 실행할 수 있음 */
-- CTE(Common Table Expression, 공통 테이블 표현식)
-- 목표: 월별 상위 10개의 판매 주문 합계를 구하고, 이를 이전 달의 합계와 비교
SELECT
OrderMonth,
Top10Total = SUM(TotalDue)
FROM(
SELECT 
	OrderDate,
	TotalDue,
	OrderMonth = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1),
	OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader
) X
WHERE OrderRank <= 10
GROUP BY OrderMonth

-- 여기까지가 월별 상위 10개의 주문 합계를 구한 것
SELECT
	A.OrderMonth,
	A.Top10Total,
	PrevTop10Total = B.Top10Total
From

(
SELECT
OrderMonth,
Top10Total = SUM(TotalDue)
FROM(
SELECT 
	OrderDate,
	TotalDue,
	OrderMonth = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1),
	OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader
) X
WHERE OrderRank <= 10
GROUP BY OrderMonth
) A
LEFT JOIN
(
SELECT
OrderMonth,
Top10Total = SUM(TotalDue)
FROM(
SELECT 
	OrderDate,
	TotalDue,
	OrderMonth = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1),
	OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader
) X
WHERE OrderRank > 10
GROUP BY OrderMonth
) B ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth)
Order By 1




--DATEADD: 특정 날짜에 연도, 월, 일, 시간 등을 더하거나 빼는 작업 수행 가능
--위에가 이전 달의 합계와 비교한 것 
-- 아래는 모범답안 

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


--모든 CTE는 WITH로 시작함 
WITH Sales AS
(
SELECT 
	OrderDate,
	TotalDue,
	OrderMonth = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1),
	OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader
),

Top10 AS(
SELECT
OrderMonth,
Top10Total = SUM(TotalDue)
FROM Sales
WHERE OrderRank > 10
GROUP BY OrderMonth
)


SELECT
A.OrderMonth,
A.Top10Total,
PrevTop10Total = B.Top10Total

From Top10 A
	Left JOIN Top10 B
		ON A.ORderMonth = DATEADD(MONTH,1,B.OrderMonth)

ORDER BY 1