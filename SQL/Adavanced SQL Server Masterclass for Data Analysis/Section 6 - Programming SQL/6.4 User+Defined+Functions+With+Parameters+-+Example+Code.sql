-- 함수 사용시 파라미터(함수에 입력값으로 전달되는 변수) 사용해보자 
-- 파라미터 넣을 때 CREATE FUNTION [함수명] (@파라미터명 데이터타입)

--Correlated Subquery Example(함수에서 구현하고자 하는 서브쿼리):
-- A.OrderDate으로부터 A.Shipdate 사이의 날짜 중 주말과 공휴일을 제외한 날짜수를 구하는 서브쿼리 
SELECT
	   SalesOrderID
      ,OrderDate
      ,DueDate
      ,ShipDate
	  ,ElapsedBusinessDays = (
		SELECT
		COUNT(*)
		FROM AdventureWorks2019.dbo.Calendar B
		WHERE B.DateValue BETWEEN A.OrderDate AND A.ShipDate
			AND B.WeekendFlag = 0
			AND B.HolidayFlag = 0
	  ) - 1

FROM AdventureWorks2019.Sales.SalesOrderHeader A

WHERE YEAR(A.OrderDate) = 2011



--Rewriting as a fucntion, with variables:

CREATE FUNCTION dbo.ufnElapsedBusinessDays(@StartDate DATE, @EndDate DATE)

RETURNS INT

AS  

BEGIN

	RETURN 
		(
			SELECT
				COUNT(*)
			FROM AdventureWorks2019.dbo.Calendar

			WHERE DateValue BETWEEN @StartDate AND @EndDate
				AND WeekendFlag = 0
				AND HolidayFlag = 0
		)	- 1

END




--Using the function in a query

SELECT
	   SalesOrderID
      ,OrderDate
      ,DueDate
      ,ShipDate
	  ,ElapsedBusinessDays = dbo.ufnElapsedBusinessDays(OrderDate,ShipDate)

FROM AdventureWorks2019.Sales.SalesOrderHeader

WHERE YEAR(OrderDate) = 2011


