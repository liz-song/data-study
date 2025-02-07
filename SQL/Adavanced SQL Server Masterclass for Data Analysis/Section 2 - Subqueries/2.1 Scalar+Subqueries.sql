--Scalar = 단일 값(하나의 행과 하나의 열로 구성된 값)
--Scalar Subquery: 단일 값을 반환하는 하위쿼리를 의미하며, 주로 집계 함수와 함께 사용됨
--Example 1: Scalar values
SELECT
	MAX(ListPrice)
FROM AdventureWorks2019.Production.Product

SELECT
	AVG(ListPrice)
FROM AdventureWorks2019.Production.Product

--Example 2: Scalar subqueries in the SELECT and WHERE clauses
--AvgListPrice: 모든 제품 평균 가격 계산하고 그 값을 AvgListPrice 컬럼에 할당해서 다 똑같은 값 나옴
--왜 서브쿼리에 평균값?: 문법적 한계로 select 절에 집계함수 쓰려면 반드시 group by랑 함께 써야하는 이유때문에 서브쿼리로 만든 것
/*질문: 왜 서브쿼리에서 집계함수 사용할 때는 group by가 필요없을까?
-> 서브쿼리는 메인 쿼리와 독립적으로 실행됨. 즉, 서브쿼리 내에서 집계 함수 사용할 경우, 그 집계 함수가 서브쿼리 데이터 전체를 기준으로 계산되기때문에
또, 메인 쿼리는 테이블에서 다중 행을 조회하면서 각 행을 별도로 처리함. 하지만 집계 함수는 여러 행을 한데 묶어 하나의 결과만 반환하니까 group by 필요없음*/
--from절에 사용되는 서브쿼리는 alias 필요하지만, select 절에서의 서브쿼리는 alias 필요없음 
--where절에 바로 집계함수 쓰고 싶은 경우, 꼭 서브쿼리 써주기
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