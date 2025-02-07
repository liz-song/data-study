-- Truncate: 테이블의 구조를 유지하면서 데이터를 삭제하는 명령어
-- 테이블 구조 재사용하면서 '반복 작업 줄이고' 효율성 높임 

--Top 10 sales + purchases script

CREATE TABLE #Orders
(
       OrderDate DATE
	  ,OrderMonth DATE
      ,TotalDue MONEY
	  ,OrderRank INT
)



INSERT INTO #Orders
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

FROM AdventureWorks2019.Sales.SalesOrderHeader


CREATE TABLE #Top10Orders
(
OrderMonth DATE,
OrderType VARCHAR(32),
Top10Total MONEY
)


INSERT INTO #Top10Orders
(
OrderMonth,
OrderType,
Top10Total
)
SELECT
OrderMonth,
OrderType = 'Sales',
Top10Total = SUM(TotalDue)

FROM #Orders
WHERE OrderRank <= 10
GROUP BY OrderMonth

SELECT * FROM #Top10Orders

/*Fun part begins here*/

TRUNCATE TABLE #Orders

INSERT INTO #Orders
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


INSERT INTO #Top10Orders
(
OrderMonth,
OrderType,
Top10Total
)
SELECT
OrderMonth,
OrderType = 'Purchase',
Top10Total = SUM(TotalDue)

FROM #Orders
WHERE OrderRank <= 10
GROUP BY OrderMonth


SELECT
A.OrderMonth,
A.OrderType,
A.Top10Total,
PrevTop10Total = B.Top10Total

FROM #Top10Orders A
	LEFT JOIN #Top10Orders B
		ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth)
			AND A.OrderType = B.OrderType

ORDER BY 1,2 DESC -- 첫번째 컬럼과 두번째 컬럼을 기준으로 정렬하라는 뜻 

DROP TABLE #Orders
DROP TABLE #Top10Orders