/* 
- 저장 프로시저(stored procedures): 데이터베이스 내에서 복잡한 쿼리나 여러 작업을 묶어두고 필요할 때 실행할 수 있는 DB객체
- UDF는 하나의 값을 반환하는데 주로 사용하고, 저장 프로시저는 복잡한 쿼리나 여러 작업 포함할 수 있고, 값 반환 안해도 됨 
<작성 방법>
CREATE PROCEDURE [스키마명].[프로시저명]
AS
BEGIN
	실행할 쿼리 작성 
END;
*/
--Starter query:

	SELECT
		*
	FROM (
		SELECT 
			ProductName = B.[Name],
			LineTotalSum = SUM(A.LineTotal),
			LineTotalSumRank = DENSE_RANK() OVER(ORDER BY SUM(A.LineTotal) DESC)

		FROM AdventureWorks2019.Sales.SalesOrderDetail A
			JOIN AdventureWorks2019.Production.Product B
				ON A.ProductID = B.ProductID

		GROUP BY
			B.[Name]
		) X

	WHERE LineTotalSumRank <= 10



--Basic (non-dynamic) stored procedure: 프로시저 문법 안에 단순히 우리가 실행하고자 하는 쿼리 삽입한 것 

CREATE PROCEDURE dbo.OrdersReport

AS

BEGIN
	SELECT
		*
	FROM (
		SELECT 
			ProductName = B.[Name],
			LineTotalSum = SUM(A.LineTotal),
			LineTotalSumRank = DENSE_RANK() OVER(ORDER BY SUM(A.LineTotal) DESC)

		FROM AdventureWorks2019.Sales.SalesOrderDetail A
			JOIN AdventureWorks2019.Production.Product B
				ON A.ProductID = B.ProductID

		GROUP BY
			B.[Name]
		) X

	WHERE LineTotalSumRank <= 10
END



--Execute stored procedure: 실행할 때는 EXEC [스키마명].[프로시저명]

EXEC dbo.OrdersReport





--Modify stored procedure to accept parameter(파라미터가 있는 프로시저)
-- 이미 존재하는 저장 프로시저의 코드 수정이나 업데이트를 할 때는 ALTER PROCEDURE 사용 

ALTER PROCEDURE dbo.OrdersReport(@TopN INT)

AS

BEGIN
	SELECT
		*
	FROM (
		SELECT 
			ProductName = B.[Name],
			LineTotalSum = SUM(A.LineTotal),
			LineTotalSumRank = DENSE_RANK() OVER(ORDER BY SUM(A.LineTotal) DESC)

		FROM AdventureWorks2019.Sales.SalesOrderDetail A
			JOIN AdventureWorks2019.Production.Product B
				ON A.ProductID = B.ProductID

		GROUP BY
			B.[Name]
		) X

	WHERE LineTotalSumRank <= @TopN
END



--Execute stored procedure
--괄호가 필요없음에 주의 

EXEC dbo.OrdersReport 20




--