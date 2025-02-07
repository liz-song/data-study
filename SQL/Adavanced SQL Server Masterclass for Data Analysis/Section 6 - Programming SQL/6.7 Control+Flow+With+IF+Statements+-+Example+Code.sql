/*
- SQL에서 if문은 프로그래밍 언어에서의 조건문과 유사. 제어흐름(control flow) 도입
- 논리 조건이 참 또는 거짓에 따라 코드가 다른 방향으로 분기됨
- 저장 프로시저, 사용자 정의 함수에서 자주 사용 
- if블록 시작, else블록 시작 시에 begin end 습관적으로 붙여주는 것이 좋음 
*/
--IF Statement - basic example
DECLARE @MyInput INT
SET @MyInput = 1

IF @MyInput > 1 
	BEGIN
		SELECT 'Hello World'
	END

ELSE
	BEGIN
		SELECT 'Farewell For Now!'
	END

--IF Statement - stored procedure example - 주로 이런 식으로 많이 쓰임 

ALTER PROCEDURE dbo.OrdersReport(@TopN INT, @OrderType INT)

AS

BEGIN

	IF @OrderType = 1
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
	ELSE
		BEGIN
			SELECT
				*
			FROM (
				SELECT 
					ProductName = B.[Name],
					LineTotalSum = SUM(A.LineTotal),
					LineTotalSumRank = DENSE_RANK() OVER(ORDER BY SUM(A.LineTotal) DESC)

				FROM AdventureWorks2019.Purchasing.PurchaseOrderDetail A
					JOIN AdventureWorks2019.Production.Product B
						ON A.ProductID = B.ProductID

				GROUP BY
					B.[Name]
				) X

			WHERE LineTotalSumRank <= @TopN
		END
END



--Calling the modified stored procedure


EXEC dbo.OrdersReport 20,1

EXEC dbo.OrdersReport 15,2