/*
- View: 가상 테이블로, SQL 쿼리 결과를 기반으로 생성됨. 실제 테이블처럼 행과 열을 포함하지만, 이는 하나 이상의 실제 테이블에서 가져온 필드로 구성됨
- 뷰는 쿼리를 캡슐화해서 복잡한 로직을 숨기고, 다른 분석가들이 단순한 테이블처럼 사용할 수 있게 함 
- 단순화, 로직 일관성, 쿼리 추상화면에서 장점
- 있는 스키마에 파생된 필드를 추가할 수 있고, 파생된 필드에 대해 조건 추가하거나 조인할 수 있음 
*/

--Creating the view:

CREATE VIEW Sales.vw_SalesRolling3Days AS 

SELECT
    OrderDate,
    TotalDue,
	SalesLast3Days = SUM(TotalDue) OVER(ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
FROM (
	SELECT
		OrderDate,
		TotalDue = SUM(TotalDue)
	FROM
		Sales.SalesOrderHeader

	WHERE YEAR(OrderDate) = 2014

	GROUP BY
		OrderDate
) X


--Querying against the view:
--SERVER에서 FORMAT 함수: FORMAT(변환할 값, 원하는 출력형식, 언어및 지역설정). 
SELECT
	OrderDate
   ,TotalDue
   ,SalesLast3Days
   ,[% Rolling 3 Days Sales] = FORMAT(TotalDue / SalesLast3Days, 'p')

FROM AdventureWorks2019.Sales.vw_SalesRolling3Days