-- Prob1

SELECT 
ProductName = C.Name,
C.ListPrice,
ProductSubcategory = B.Name,
ProductCategory = A.Name

FROM AdventureWorks2019.Production.ProductCategory A
	JOIN AdventureWorks2019.Production.ProductSubcategory B	
		ON A.ProductCategoryID = B.ProductCategoryID
	JOIN AdventureWorks2019.Production.Product C
		ON B.ProductSubcategoryID = C.ProductSubcategoryID

--Prob2
/*이렇게 했을 때 Group By와 다른 점은?
  - Group By: product category가 같다면 모든 행을 축약 시켜서 보여주고, 각 그룹당 하나의 결과만 반환
  - over+partition: product category가 같은 데이터만을 대상으로 List price 평균을 계산하고,
    원래 데이터의 모든 행은 유지하며, 계산된 값은 각 행에 추가*/

SELECT 
ProductName = C.Name,
C.ListPrice,
ProductSubcategory = B.Name,
ProductCategory = A.Name,
AvgPriceByCategory = AVG(C.ListPrice) OVER(PARTITION BY A.Name)

FROM AdventureWorks2019.Production.ProductCategory A
	JOIN AdventureWorks2019.Production.ProductSubcategory B	
		ON A.ProductCategoryID = B.ProductCategoryID
	JOIN AdventureWorks2019.Production.Product C
		ON B.ProductSubcategoryID = C.ProductSubcategoryID

--Prob3

SELECT 
ProductName = C.Name,
C.ListPrice,
ProductSubcategory = B.Name,
ProductCategory = A.Name,
AvgPriceByCategory = AVG(C.ListPrice) OVER(PARTITION BY A.Name),
AvgPriceByCategoryAndSubcategory = AVG(C.ListPrice) OVER(PARTITION BY A.Name, B.Name)

FROM AdventureWorks2019.Production.ProductCategory A
	JOIN AdventureWorks2019.Production.ProductSubcategory B	
		ON A.ProductCategoryID = B.ProductCategoryID
	JOIN AdventureWorks2019.Production.Product C
		ON B.ProductSubcategoryID = C.ProductSubcategoryID 


--Prob4

SELECT 
ProductName = C.Name,
C.ListPrice,
ProductSubcategory = B.Name,
ProductCategory = A.Name,
AvgPriceByCategory = AVG(C.ListPrice) OVER(PARTITION BY A.Name),
AvgPriceByCategoryAndSubcategory = AVG(C.ListPrice) OVER(PARTITION BY A.Name, B.Name),
ProductVsCategoryDelta = C.ListPrice - AVG(C.ListPrice) OVER(PARTITION BY A.Name)

FROM AdventureWorks2019.Production.ProductCategory A
	JOIN AdventureWorks2019.Production.ProductSubcategory B	
		ON A.ProductCategoryID = B.ProductCategoryID
	JOIN AdventureWorks2019.Production.Product C
		ON B.ProductSubcategoryID = C.ProductSubcategoryID 