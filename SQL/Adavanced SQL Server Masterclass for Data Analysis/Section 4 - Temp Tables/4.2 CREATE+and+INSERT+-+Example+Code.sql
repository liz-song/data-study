/* CTE를 임시 테이블로 변환하는 두가지 방법
1. SELECT INTO: 간단하게 임시테이블 생성 및 데이터 삽입
2. CREATE TABLE + INSERT INTO: 테이블 구조를 명시적으로 정의 후 데이터 삽입
- INTO는 테이블을 만들고, 그 안에 데이터 넣는 역할 함 
 */
--연습

CREATE TABLE #Sales
(
	 OrderDate DATE
	 ,OrderMonth DATE
     ,TotalDue MONEY
	 ,OrderRank INT
)
INSERT INTO #Sales
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

CREATE TABLE #Top10Sales
(
	OrderMonth DATE
	,Top10Total MONEY
)

INSERT INTO #Top10Sales

SELECT

	OrderMonth
	,Top10Total = SUM(TotalDue)

FROM #Sales
WHERE OrderRank <= 10
GROUP BY OrderMonth


SELECT
	A.OrderMonth,
	A.Top10Total,
	PrevTop10Total = B.Top10Total

FROM #Top10Sales A
	LEFT JOIN #Top10Sales B
		ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth)

ORDER BY 1


SELECT * FROM #Sales WHERE OrderRank <= 10

DROP TABLE #Sales
DROP TABLE #Top10Sales
