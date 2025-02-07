--PIVOT도 데이터를 flatten시킬 수 있는 방법 중 하나. 
--PIVOT: 특정 컬럼을 기준으로 새로운 열을 생성하고, 그 컬럼에 대한 집계 구하는 과정 
--이 기능은 엑셀이 더 쉽지만, 엑셀에서 다룰 수 없는 큰 데이터의 경우 SQL로 해야함 

SELECT
	   ProductCategoryName = D.Name,
	   A.LineTotal

FROM AdventureWorks2019.Sales.SalesOrderDetail A
	JOIN AdventureWorks2019.Production.Product B
		ON A.ProductID = B.ProductID
	JOIN AdventureWorks2019.Production.ProductSubcategory C
		ON B.ProductSubcategoryID = C.ProductSubcategoryID
	JOIN AdventureWorks2019.Production.ProductCategory D
		ON C.ProductCategoryID = D.ProductCategoryID

--목표: 각 제품카테고리이름을 헤드로 두고, 각 카테고리이름에 따른 Line Total에 대해 SUM 집계
--가장 먼저 데이터에 대한 서브쿼리 작성해야 기본 테이블 역할을 함 
--PIVOT 구문에서는 데이터를 기준으로 사용할 열과 집계할 값 지정해야함(이 때 SQL은 고유값 못 잡아내니까 수작업해줘야)
SELECT
	[Bikes],
	[Clothing],
	[Accessories],
	[Components]
FROM 
(
 SELECT
	   ProductCategoryName = D.Name,
	   A.LineTotal

FROM AdventureWorks2019.Sales.SalesOrderDetail A
	JOIN AdventureWorks2019.Production.Product B
		ON A.ProductID = B.ProductID
	JOIN AdventureWorks2019.Production.ProductSubcategory C
		ON B.ProductSubcategoryID = C.ProductSubcategoryID
	JOIN AdventureWorks2019.Production.ProductCategory D
		ON C.ProductCategoryID = D.ProductCategoryID
) A

PIVOT(
	SUM(LineTotal)
	FOR ProductCategoryName IN ([Bikes],[Clothing],[Accessories],[Components])
) B

