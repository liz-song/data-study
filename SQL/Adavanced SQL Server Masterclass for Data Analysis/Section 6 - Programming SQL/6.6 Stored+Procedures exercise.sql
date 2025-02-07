/*
OrdersAboveThreshold라고 불리는 프로시저 만들기 
- @Threshold를 넘는 total due amount를 가진 모든 sales order 출력 
- @StartYear, @EndYear 파라미터 사이의 기간 값을 가지는 모든 order date가 출력되어야 함 
*/

CREATE PROCEDURE dbo.OrdersAboveThreshold(@Threshold MONEY, @StartYear INT, @EndYear INT)
AS
BEGIN
	SELECT
		A.SalesOrderID,
		A.OrderDate,
		A.TotalDue

	FROM  AdventureWorks2019.Sales.SalesOrderHeader A
		JOIN AdventureWorks2019.dbo.Calendar B
			ON A.OrderDate = B.DateValue
	WHERE A.TotalDue > @Threshold AND A.OrderDate BETWEEN @StartYear AND @EndYear
END


--실행부분
EXEC dbo.OrdersAboveThreshold 10000, 2011, 2013