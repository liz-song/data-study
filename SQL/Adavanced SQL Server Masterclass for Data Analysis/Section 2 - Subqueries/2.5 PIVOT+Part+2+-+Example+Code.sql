--연습 
--만약 최종 SELECT문에 내가 집계하거나 transpose하지 않는 항목이 들어가 있으면 새로운 컬럼을 생성함
--아래 코드의 경우, OrderQty를 추가해서 각 OrderQty값별로 그룹화된 데이터가 출력됨 
SELECT
*
FROM 
(
 SELECT
	   ProductCategoryName = D.Name,
	   A.LineTotal,
	   A.OrderQty

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
	FOR ProductCategoryName IN ([Bikes],[Clothing])
) B

ORDER BY 1


--강의
--이 버전은 보는 사람 보기 편하라고 OrderQty 리네임해준 버전 
SELECT
[Order Quantity] = OrderQty,
[Bikes],
[Clothing]

FROM
(
SELECT
	   ProductCategoryName = D.Name,
	   A.LineTotal,
	   A.OrderQty

FROM AdventureWorks2019.Sales.SalesOrderDetail A
	JOIN AdventureWorks2019.Production.Product B
		ON A.ProductID = B.ProductID
	JOIN AdventureWorks2019.Production.ProductSubcategory C
		ON B.ProductSubcategoryID = C.ProductSubcategoryID
	JOIN AdventureWorks2019.Production.ProductCategory D
		ON C.ProductCategoryID = D.ProductCategoryID
) E

PIVOT(
SUM(LineTotal)
FOR ProductCategoryName IN([Bikes],[Clothing])
) F

ORDER BY 1