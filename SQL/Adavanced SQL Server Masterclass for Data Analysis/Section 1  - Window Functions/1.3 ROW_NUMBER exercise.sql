--Prob1
SELECT 
ProductName=C.Name,
C.ListPrice,
ProductSubcategory = B.Name,
ProductCategory = A.Name

FROM AdventureWorks2019.Production.ProductCategory A
	JOIN AdventureWorks2019.Production.ProductSubcategory B	
		ON A.ProductCategoryID = B.ProductCategoryID
	JOIN AdventureWorks2019.Production.Product C
		ON B.ProductSubcategoryID = C.ProductSubcategoryID

--Prob2
-- 컬럼 명에 띄어쓰기 하고 싶은 경우 대괄호로 묶어주기
-- ROW_NUMBER 함수 괄호 안에는 무엇인가가 필요 없지만,ROW_NUMBER 함수는 ORDER BY라는 파라미터 사용

SELECT
ProductName = C.Name,
C.ListPrice,
ProductSubcategory = B.Name,
ProductCategory = A.Name,
[Price Rank]=ROW_NUMBER() OVER(ORDER BY C.ListPrice DESC)

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
[Price Rank] = ROW_NUMBER() OVER(ORDER BY C.ListPrice DESC),
[Category Price Rank] = ROW_NUMBER() OVER(PARTITION BY A.Name ORDER BY C.ListPrice DESC)

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
[Price Rank] = ROW_NUMBER() OVER(ORDER BY C.ListPrice DESC),
[Top 5 Price In Category] = 
	CASE 
		WHEN ROW_NUMBER() OVER(PARTITION BY A.Name ORDER BY C.ListPrice DESC) <= 5 THEN 'YES'
		ELSE 'No'
	END

FROM AdventureWorks2019.Production.ProductCategory A
	JOIN AdventureWorks2019.Production.ProductSubcategory B	
		ON A.ProductCategoryID = B.ProductCategoryID
	JOIN AdventureWorks2019.Production.Product C
		ON B.ProductSubcategoryID = C.ProductSubcategoryID