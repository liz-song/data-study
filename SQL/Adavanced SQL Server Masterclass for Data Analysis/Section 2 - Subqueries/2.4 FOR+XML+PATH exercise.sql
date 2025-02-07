--Prob1
--SELECT절은 괄호로 감싸지 않음! 
SELECT
	SubcategoryName= B.Name
	,Products =
		STUFF(
				(
				SELECT
					';' + A.Name	
					FROM AdventureWorks2019.Production.Product A
					WHERE A.ProductSubcategoryID = B.ProductSubcategoryID
					FOR XML PATH('')
				),
		1,1,''
		)
FROM AdventureWorks2019.Production.ProductSubcategory B

--Prob2
--Products 테이블에서 50달러보다 더 큰 값을 가진 프로덕트만 
--greater than은 '초과'
SELECT
	SubcategoryName= B.Name
	,Products =
		STUFF(
				(
				SELECT
					';' + A.Name	
					FROM AdventureWorks2019.Production.Product A
					WHERE A.ProductSubcategoryID = B.ProductSubcategoryID
						AND A.ListPrice > 50
					FOR XML PATH('')
				),
		1,1,''
		)
FROM AdventureWorks2019.Production.ProductSubcategory B 