--Prob1 

SELECT 
EmployeeID = A.BusinessEntityID,
A.JobTitle,
A.HireDate,
A.VacationHours,
FirstHireVacationHours = FIRST_VALUE(A.VacationHours) OVER (PARTITION BY A.JobTitle ORDER BY A.HireDate)

FROM AdventureWorks2019.HumanResources.Employee A
ORDER BY A.JobTitle, A.HireDate ASC

--Prob2
SELECT
B.ProductID,
ProductName = B.Name,
A.ListPrice,
A.ModifiedDate,
HighestPrice = FIRST_VALUE(A.ListPrice) OVER(PARTITION BY B.ProductID ORDER BY A.ListPrice DESC),
LowestCost = FIRST_VALUE(A.ListPrice) OVER(PARTITION BY B.ProductID ORDER BY A.ListPrice DESC),
PriceRange = FIRST_VALUE(A.ListPrice) OVER(PARTITION BY B.ProductID ORDER BY A.ListPrice DESC)-
		FIRST_VALUE(A.ListPrice) OVER(PARTITION BY B.ProductID ORDER BY A.ListPrice)


FROM AdventureWorks2019.Production.ProductListPriceHistory A
	JOIN AdventureWorks2019.Production.Product B 
		ON A.ProductID = B.ProductID

ORDER BY B.ProductID, A.ModifiedDate ASC
