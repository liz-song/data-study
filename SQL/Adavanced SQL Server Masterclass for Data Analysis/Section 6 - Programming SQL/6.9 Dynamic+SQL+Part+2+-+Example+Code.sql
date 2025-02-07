
/*
- 코드 조각내는 이유: 동적 SQL을 쉽게 관리하고 가독성 높이려고
- AggFunc에 따라 집계함수 달라지고, TopN에 따라 결과 개수가 달라짐 
- 코드 조각내는건 마음대로 끊을 수 있지만, 구문 구조를 따라 끊어야 오류 없이 동작함 
*/
CREATE PROC dbo.DynamicTopN(@TopN INT, @AggFunc VARCHAR(50))

AS

BEGIN
	DECLARE @DynamicSQL VARCHAR(MAX)

	SET @DynamicSQL = 
	'	SELECT
			*
		FROM (
			SELECT 
				ProductName = B.[Name],
				LineTotalSum = ' 

	SET @DynamicSQL = @DynamicSQL + @AggFunc -- 이 부분에서 @AggFunc에 담긴 값을 동적 쿼리의 LineTotalSum에 추가함 

	SET @DynamicSQL = @DynamicSQL +
	'(A.LineTotal),
				LineTotalSumRank = DENSE_RANK() OVER(ORDER BY '

	SET @DynamicSQL = @DynamicSQL + @AggFunc

	SET @DynamicSQL = @DynamicSQL +
	'(A.LineTotal) DESC)

			FROM AdventureWorks2019.Sales.SalesOrderDetail A
				JOIN AdventureWorks2019.Production.Product B
					ON A.ProductID = B.ProductID

			GROUP BY
				B.[Name]
			) X

		WHERE LineTotalSumRank <= '

	SET @DynamicSQL = @DynamicSQL + CAST(@TopN AS VARCHAR)

	EXEC(@DynamicSQL)

END

