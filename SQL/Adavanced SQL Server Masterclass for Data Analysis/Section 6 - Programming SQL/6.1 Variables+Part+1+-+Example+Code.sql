/*프로그래밍 언어에서 사용하는 '변수' 개념을 SQL에 적용하는 방법 배울 것임 
변수: 이름이 붙은 자리표시자(named placeholder)
<변수 선언 및 사용>
- DECLARE @myvar INT;처럼, DECLARE 키워드 사용해 변수 선언, 이름은 @ 기호로 시작, 데이터 타입 지정 필요
- DECLARE @myvar INT = 11처럼 할당을 동시에 할 수 있음 
- 출력할 때는 SELECT @myvar
*/

-- 변수 연습
DECLARE @myvar INT
SET @myvar = 11
SELECT @myvar

DECLARE @myvar INT = 11 --선언과 할당 동시에 가능 
-- 하드코딩된 것을 변수로 리팩토링
DECLARE @MinPrice MONEY

SET @MinPrice = 1000

SELECT 
*
FROM AdventureWorks2019.Production.Product
WHERE ListPrice > @MinPrice

--Embedded scalar subquery example(서브쿼리를 변수로 리팩토링)

SELECT 
	   ProductID
      ,[Name]
      ,StandardCost
      ,ListPrice
	  ,AvgListPrice = (SELECT AVG(ListPrice) FROM AdventureWorks2019.Production.Product)
	  ,AvgListPriceDiff = ListPrice - (SELECT AVG(ListPrice) FROM AdventureWorks2019.Production.Product)

FROM AdventureWorks2019.Production.Product

WHERE ListPrice > (SELECT AVG(ListPrice) FROM AdventureWorks2019.Production.Product)

ORDER BY ListPrice ASC



--Rewritten with variables:
DECLARE @AvgPrice MONEY 
SELECT @AvgPrice= (SELECT AVG(ListPrice) FROM AdventureWorks2019.Production.Product)

SELECT 
	   ProductID
      ,[Name]
      ,StandardCost
      ,ListPrice
	  ,AvgListPrice = @AvgPrice
	  ,AvgListPriceDiff = ListPrice - @AvgPrice

FROM AdventureWorks2019.Production.Product

WHERE ListPrice > @AvgPrice

ORDER BY ListPrice ASC